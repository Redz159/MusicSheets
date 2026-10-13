import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../core/settings.dart';
import '../../core/viewer_layout.dart';
import '../../data/db.dart';
import '../../data/providers.dart';
import '../../services/pdf_render.dart';
import '../../widgets/song_actions.dart';
import '../annotate/annotation_layer.dart';
import '../annotate/annotation_store.dart';
import '../annotate/annotation_toolbar.dart';
import '../annotate/tool_state.dart';

class ViewerArgs {
  const ViewerArgs({
    required this.songIds,
    this.startSong = 0,
    this.startPage,
    this.setlistName,
    this.resumeLastPage = true,
  });

  final List<int> songIds;
  final int startSong;
  final int? startPage;

  /// Set when playing a setlist: all songs are shown as one continuous sequence.
  final String? setlistName;
  final bool resumeLastPage;

  bool get isSetlist => setlistName != null;
}

class ViewerScreen extends ConsumerStatefulWidget {
  const ViewerScreen({super.key, required this.args});
  final ViewerArgs args;

  @override
  ConsumerState<ViewerScreen> createState() => _ViewerScreenState();
}

class _ViewerScreenState extends ConsumerState<ViewerScreen> {
  late final AppDatabase _db = ref.read(databaseProvider);
  late final AppPaths _paths = ref.read(appPathsProvider);
  late final AnnotationStore _store = AnnotationStore(_db);
  final _docs = PdfDocCache();
  final _tools = ToolState();
  final _focus = FocusNode(debugLabel: 'viewer');
  final _transform = TransformationController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scrubber = ScrollController();

  /// For single-song viewing: show the whole song (folder/library). Setlists: all songs.
  List<Song>? _songs;
  List<PageRef> _flat = const [];
  List<int> _offsets = const [];
  List<List<int>> _units = const [];
  bool? _spread;
  PageController? _pc;
  int _unit = 0;
  int _startFlat = 0;
  int? _currentSong;

  bool _half = false;
  bool _chrome = false;
  bool _annotating = false;
  bool _zoomed = false;
  double _renderZoom = 1;
  double _slotWidth = 0;

  // Annotate mode: one finger / the pen draws, two fingers zoom and pan.
  final _touches = <int, Offset>{};
  final _pinching = ValueNotifier(false);
  Offset? _pinchFocal;
  double _pinchSpan = 0;

  String? _toast;
  Timer? _toastTimer;
  Timer? _saveTimer;
  final _markedOpened = <int>{};

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    if (ref.read(settingsProvider).keepScreenOn) WakelockPlus.enable();
    _load();
  }

  Future<void> _load() async {
    final args = widget.args;
    final songs = await _db.songsByIds(args.songIds);
    if (songs.isEmpty) {
      if (mounted) Navigator.of(context).pop();
      return;
    }
    final startSong = args.startSong.clamp(0, songs.length - 1);
    final counts = [for (final s in songs) s.pageCount];
    _flat = flattenPages(counts);
    _offsets = songOffsets(counts);
    final s = songs[startSong];
    final page = (args.startPage ?? (args.resumeLastPage ? s.lastPage : 0)).clamp(0, (s.pageCount - 1).clamp(0, 1 << 30));
    _startFlat = _offsets[startSong] + page;
    await Future.wait([
      _store.load(songs.map((s) => s.id)),
      _docs.load(_paths.pdf(s.fileName)).then((_) {}, onError: (_) {}),
    ]);
    if (!mounted) return;
    setState(() => _songs = songs);
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    _flushLastPage();
    _toastTimer?.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    WakelockPlus.disable();
    _store.dispose();
    _docs.dispose();
    _pc?.dispose();
    _focus.dispose();
    _transform.dispose();
    _pinching.dispose();
    _scrubber.dispose();
    _tools.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------------ navigation

  int get _currentFlat => _units.isEmpty ? _startFlat : _units[_unit].first;

  Song _songAt(int flat) {
    final s = _songs![_flat[flat].song];
    return ref.read(songByIdProvider)[s.id] ?? s;
  }

  bool get _halfMode => ref.read(settingsProvider).halfPageTurn && _spread == false;

  void _goToUnit(int u, {bool animate = false}) {
    if (_units.isEmpty) return;
    u = u.clamp(0, _units.length - 1);
    if (u == _unit && !_half) return;
    final pc = _pc;
    if (pc == null || !pc.hasClients) return;
    if (u == _unit) {
      setState(() => _half = false);
    } else if (animate) {
      pc.animateToPage(u, duration: const Duration(milliseconds: 280), curve: Curves.easeOutCubic);
    } else {
      pc.jumpToPage(u);
    }
  }

  void _goToFlat(int flat) => _goToUnit(unitOf(_units, flat));

  void _next() {
    if (_units.isEmpty) return;
    final last = _unit >= _units.length - 1;
    if (last) {
      HapticFeedback.lightImpact();
      _showToast(widget.args.isSetlist ? 'End of setlist' : 'Last page');
      return;
    }
    if (_halfMode && !_half) {
      setState(() => _half = true);
      return;
    }
    _goToUnit(_unit + 1);
  }

  void _prev() {
    if (_half) {
      setState(() => _half = false);
      return;
    }
    if (_unit == 0) {
      HapticFeedback.lightImpact();
      return;
    }
    _goToUnit(_unit - 1);
  }

  void _onPageChanged(int u) {
    setState(() {
      _unit = u;
      _half = false;
      _zoomed = false;
      _renderZoom = 1;
    });
    _transform.value = Matrix4.identity();
    _afterUnitChange();
  }

  void _syncZoom() {
    final scale = _transform.value.getMaxScaleOnAxis();
    final zoomed = scale > 1.01;
    // Re-render sharper in half steps once the gesture settles.
    final render = zoomed ? (scale * 2).ceil() / 2 : 1.0;
    if (zoomed != _zoomed || render != _renderZoom) {
      setState(() {
        _zoomed = zoomed;
        _renderZoom = render;
      });
    }
  }

  void _annoPointerDown(PointerDownEvent e) {
    if (e.kind != PointerDeviceKind.touch) return;
    _touches[e.pointer] = e.localPosition;
    _pinchFocal = null;
    if (_touches.length >= 2) _pinching.value = true;
  }

  void _annoPointerMove(PointerMoveEvent e) {
    if (!_touches.containsKey(e.pointer)) return;
    _touches[e.pointer] = e.localPosition;
    final fingerPan = ref.read(settingsProvider).stylusOnly && _zoomed && _touches.length == 1;
    if (_touches.length < 2 && !fingerPan) return;

    final pts = _touches.values.take(2).toList();
    final focal = pts.length == 2 ? (pts[0] + pts[1]) / 2 : pts[0];
    final span = pts.length == 2 ? (pts[0] - pts[1]).distance : 0.0;
    final lastFocal = _pinchFocal;
    final lastSpan = _pinchSpan;
    _pinchFocal = focal;
    _pinchSpan = span;
    if (lastFocal == null) return;

    final m = _transform.value;
    final k = m.getMaxScaleOnAxis();
    var s = span > 0 && lastSpan > 0 ? span / lastSpan : 1.0;
    final k2 = (k * s).clamp(1.0, 5.0);
    s = k2 / k;
    // Keep the content under the fingers: t' = s·t + focal − s·lastFocal.
    final size = MediaQuery.sizeOf(context);
    final tx = (s * m.entry(0, 3) + focal.dx - s * lastFocal.dx).clamp(size.width * (1 - k2), 0.0);
    final ty = (s * m.entry(1, 3) + focal.dy - s * lastFocal.dy).clamp(size.height * (1 - k2), 0.0);
    _transform.value = Matrix4.identity()
      ..setEntry(0, 0, k2)
      ..setEntry(1, 1, k2)
      ..setEntry(0, 3, tx)
      ..setEntry(1, 3, ty);
  }

  void _annoPointerUp(PointerEvent e) {
    if (_touches.remove(e.pointer) == null) return;
    _pinchFocal = null;
    if (_touches.isEmpty) {
      _pinching.value = false;
      _syncZoom();
    }
  }

  void _afterUnitChange() {
    final flat = _currentFlat;
    final songIndex = _flat[flat].song;
    final song = _songAt(flat);
    if (songIndex != _currentSong) {
      final first = _currentSong == null;
      _currentSong = songIndex;
      if (widget.args.isSetlist && !first) {
        _showToast('${songIndex + 1}/${_songs!.length}  ·  ${song.title}');
      }
      if (_markedOpened.add(song.id)) _db.markOpened(song.id);
    }
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 1), _flushLastPage);
    _prefetch();
    if (_chrome) _scrollScrubberToCurrent();
  }

  void _flushLastPage() {
    if (_songs == null || _units.isEmpty) return;
    final flat = _currentFlat;
    final song = _songs![_flat[flat].song];
    _db.saveLastPage(song.id, _flat[flat].page);
  }

  /// Renders the neighbouring pages ahead of time so turning is instant.
  Future<void> _prefetch() async {
    if (_slotWidth <= 0) return;
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final width = renderWidthFor(_slotWidth, dpr);
    for (final d in [1, 2, -1]) {
      final u = _unit + d;
      if (u < 0 || u >= _units.length) continue;
      for (final f in _units[u]) {
        final song = _songs![_flat[f].song];
        try {
          final doc = await _docs.load(_paths.pdf(song.fileName));
          if (!mounted) return;
          final img = await PageImageCache.instance.get(doc, song.fileName, _flat[f].page, width);
          img?.dispose();
        } catch (_) {}
      }
    }
  }

  void _showToast(String text) {
    _toastTimer?.cancel();
    setState(() => _toast = text);
    _toastTimer = Timer(const Duration(milliseconds: 1600), () {
      if (mounted) setState(() => _toast = null);
    });
  }

  void _handleTap(Offset global) {
    if (_annotating) return;
    final width = MediaQuery.sizeOf(context).width;
    final zone = ref.read(settingsProvider).tapZoneFraction;
    final x = global.dx / width;
    if (x < zone) {
      _prev();
    } else if (x > 1 - zone) {
      _next();
    } else {
      setState(() => _chrome = !_chrome);
      if (_chrome) WidgetsBinding.instance.addPostFrameCallback((_) => _scrollScrubberToCurrent());
    }
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent e) {
    if (e is! KeyDownEvent && e is! KeyRepeatEvent) return KeyEventResult.ignored;
    final swap = ref.read(settingsProvider).swapPedal;
    final k = e.logicalKey;
    final forward = {
      LogicalKeyboardKey.arrowRight,
      LogicalKeyboardKey.arrowDown,
      LogicalKeyboardKey.pageDown,
      LogicalKeyboardKey.space,
      LogicalKeyboardKey.enter,
      LogicalKeyboardKey.mediaTrackNext,
    };
    final back = {
      LogicalKeyboardKey.arrowLeft,
      LogicalKeyboardKey.arrowUp,
      LogicalKeyboardKey.pageUp,
      LogicalKeyboardKey.backspace,
      LogicalKeyboardKey.mediaTrackPrevious,
    };
    if (forward.contains(k)) {
      swap ? _prev() : _next();
      return KeyEventResult.handled;
    }
    if (back.contains(k)) {
      swap ? _next() : _prev();
      return KeyEventResult.handled;
    }
    if (k == LogicalKeyboardKey.escape && _annotating) {
      _setAnnotating(false);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _setAnnotating(bool on) {
    setState(() {
      _annotating = on;
      _chrome = false;
      _half = false;
    });
    // Zoom is kept on purpose: zoom in, then annotate the detail.
    _touches.clear();
    _pinching.value = false;
    if (!on) _store.flush();
  }

  void _scrollScrubberToCurrent() {
    if (!_scrubber.hasClients) return;
    const extent = _ScrubberStrip.itemExtent;
    final target = _currentFlat * extent - (_scrubber.position.viewportDimension - extent) / 2;
    _scrubber.jumpTo(target.clamp(0, _scrubber.position.maxScrollExtent));
  }

  // ------------------------------------------------------------------ layout

  void _syncUnits(bool spread) {
    if (_spread == spread && _pc != null) return;
    final flat = _currentFlat;
    _spread = spread;
    _units = buildUnits(_flat, spread: spread);
    _unit = unitOf(_units, flat);
    _half = false;
    final old = _pc;
    _pc = PageController(initialPage: _unit);
    if (old != null) WidgetsBinding.instance.addPostFrameCallback((_) => old.dispose());
    if (_currentSong == null) WidgetsBinding.instance.addPostFrameCallback((_) => _afterUnitChange());
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    ref.watch(songByIdProvider); // refresh titles after edits
    final size = MediaQuery.sizeOf(context);
    final songs = _songs;
    const background = Color(0xFF1C1C1E);

    if (songs == null) {
      return const Scaffold(backgroundColor: background, body: Center(child: CircularProgressIndicator()));
    }
    _syncUnits(settings.twoPageLandscape && size.width > size.height && size.width >= 700);
    final current = _songAt(_currentFlat);
    final pageInSong = _flat[_currentFlat].page;

    return PopScope(
      canPop: !_annotating,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _setAnnotating(false);
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: settings.pageTint == PageTint.night ? Colors.black : background,
        endDrawer: widget.args.isSetlist ? _songDrawer(songs) : null,
        endDrawerEnableOpenDragGesture: false, // edge swipes turn pages instead
        body: Focus(
          focusNode: _focus,
          autofocus: true,
          onKeyEvent: _onKey,
          child: Stack(children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                // No double-tap handler on purpose: it would delay every single tap.
                onTapUp: _annotating ? null : (d) => _handleTap(d.globalPosition),
                child: PageView.builder(
                  key: ValueKey(_spread),
                  controller: _pc,
                  physics: _annotating || _zoomed ? const NeverScrollableScrollPhysics() : const PageScrollPhysics(),
                  itemCount: _units.length,
                  onPageChanged: _onPageChanged,
                  itemBuilder: (context, u) => _buildUnit(u, settings),
                ),
              ),
            ),
            // Song change / end toast
            Positioned(
              top: MediaQuery.paddingOf(context).top + (_chrome ? 76 : 16),
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Center(
                  child: AnimatedOpacity(
                    opacity: _toast == null ? 0 : 1,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.78), borderRadius: BorderRadius.circular(24)),
                      child: Text(_toast ?? '', style: const TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ),
              ),
            ),
            _topBar(current, pageInSong, settings),
            _bottomBar(),
            if (_annotating)
              Positioned(
                left: 12,
                right: 12,
                top: MediaQuery.paddingOf(context).top + 12,
                child: Center(
                  child: AnnotationToolbar(
                    tools: _tools,
                    store: _store,
                    stylusOnly: settings.stylusOnly,
                    onStylusOnly: (v) => ref.read(settingsProvider.notifier).set((s) => s.copyWith(stylusOnly: v)),
                    onClearPage: () {
                      for (final f in _units[_unit]) {
                        _store.clearPage(_songAt(f).id, _flat[f].page);
                      }
                    },
                    onDone: () => _setAnnotating(false),
                  ),
                ),
              ),
          ]),
        ),
      ),
    );
  }

  Widget _buildUnit(int u, AppSettings settings) {
    final pages = _units[u];
    final isCurrent = u == _unit;
    Widget child;
    if (isCurrent && _half && u + 1 < _units.length) {
      child = _halfComposite(_units[u + 1].first, pages.first, settings);
    } else {
      final editable = isCurrent && _annotating;
      final zoom = isCurrent ? _renderZoom : 1.0;
      if (pages.length == 1) {
        child = _pageSlot(pages.first, settings, editable: editable, zoom: zoom);
      } else {
        child = Row(children: [
          Expanded(
              child: _pageSlot(pages[0], settings,
                  editable: editable, zoom: zoom, alignment: Alignment.centerRight)),
          const SizedBox(width: 4),
          Expanded(
              child: _pageSlot(pages[1], settings,
                  editable: editable, zoom: zoom, alignment: Alignment.centerLeft)),
        ]);
      }
    }
    // Every page gets an InteractiveViewer (and Listener) so the tree doesn't change
    // shape when the current page changes (which would rebuild the page mid-swipe).
    final active = isCurrent && _annotating;
    return Listener(
      onPointerDown: active ? _annoPointerDown : null,
      onPointerMove: active ? _annoPointerMove : null,
      onPointerUp: active ? _annoPointerUp : null,
      onPointerCancel: active ? _annoPointerUp : null,
      child: InteractiveViewer(
        transformationController: isCurrent ? _transform : null,
        minScale: 1,
        maxScale: 5,
        // While annotating, zoom/pan is driven by [_annoPointerMove] instead.
        scaleEnabled: isCurrent && !_annotating,
        panEnabled: isCurrent && _zoomed && !_annotating,
        onInteractionEnd: (_) => _syncZoom(),
        child: Padding(padding: const EdgeInsets.all(6), child: child),
      ),
    );
  }

  /// Top half: the next page's top. Bottom half: the current page's bottom.
  Widget _halfComposite(int nextFlat, int currentFlat, AppSettings settings) {
    return LayoutBuilder(builder: (context, c) {
      final h = c.maxHeight;
      final scheme = Theme.of(context).colorScheme;
      return Column(children: [
        SizedBox(
          height: h / 2 - 1,
          child: ClipRect(
            child: OverflowBox(
              alignment: Alignment.topCenter,
              minHeight: h,
              maxHeight: h,
              child: _pageSlot(nextFlat, settings, editable: false),
            ),
          ),
        ),
        Container(height: 2, color: scheme.primary),
        SizedBox(
          height: h / 2 - 1,
          child: ClipRect(
            child: OverflowBox(
              alignment: Alignment.bottomCenter,
              minHeight: h,
              maxHeight: h,
              child: _pageSlot(currentFlat, settings, editable: false),
            ),
          ),
        ),
      ]);
    });
  }

  Widget _pageSlot(int flat, AppSettings settings,
      {required bool editable, double zoom = 1, Alignment alignment = Alignment.center}) {
    final ref0 = _flat[flat];
    final song = _songs![ref0.song];
    final path = _paths.pdf(song.fileName);
    final doc = _docs.peek(path);
    if (doc == null) {
      return FutureBuilder<PdfDocument>(
        future: _docs.load(path),
        builder: (context, snap) {
          if (snap.hasError) {
            return const Center(child: Text('Could not open this PDF', style: TextStyle(color: Colors.white70)));
          }
          if (!snap.hasData) return const SizedBox.expand();
          return _pageSlot(flat, settings, editable: editable, zoom: zoom, alignment: alignment);
        },
      );
    }
    final page = doc.pages[ref0.page.clamp(0, doc.pages.length - 1)];
    final filter = tintFilter(settings.pageTint);
    Widget image = PdfPageImage(doc: doc, docKey: song.fileName, page: ref0.page, zoom: zoom);
    if (filter != null) image = ColorFiltered(colorFilter: filter, child: image);
    return Align(
      alignment: alignment,
      child: AspectRatio(
        aspectRatio: page.width / page.height,
        child: LayoutBuilder(builder: (context, c) {
          _slotWidth = c.maxWidth;
          return DecoratedBox(
            decoration: const BoxDecoration(boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 10)]),
            child: Stack(fit: StackFit.expand, children: [
              image,
              AnnotationLayer(
                key: ValueKey('anno-${song.id}-${ref0.page}'),
                songId: song.id,
                page: ref0.page,
                store: _store,
                tools: _tools,
                editable: editable,
                pinching: _pinching,
                stylusOnly: settings.stylusOnly,
                onFingerTap: (g) {
                  // In stylus-only mode fingers still use the tap zones.
                  final w = MediaQuery.sizeOf(context).width;
                  final zone = settings.tapZoneFraction;
                  if (g.dx / w < zone) _prev();
                  if (g.dx / w > 1 - zone) _next();
                },
                // When zoomed, a finger pans instead of turning the page.
                onFingerSwipe: _zoomed ? null : (d) => d > 0 ? _next() : _prev(),
              ),
            ]),
          );
        }),
      ),
    );
  }

  // ------------------------------------------------------------------ chrome

  Widget _topBar(Song current, int pageInSong, AppSettings settings) {
    final top = MediaQuery.paddingOf(context).top;
    final notifier = ref.read(settingsProvider.notifier);
    final songIndex = _flat[_currentFlat].song;
    final pageLabel = _units[_unit].length == 2
        ? '${pageInSong + 1}–${pageInSong + 2} / ${current.pageCount}'
        : '${pageInSong + 1} / ${current.pageCount}';
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      top: _chrome ? 0 : -(top + 80),
      left: 0,
      right: 0,
      child: Material(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.96),
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.only(top: top, left: 4, right: 8),
          child: SizedBox(
            height: 64,
            child: Row(children: [
              IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).maybePop()),
              const SizedBox(width: 4),
              Expanded(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(current.title,
                      maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.titleMedium),
                  Text(
                    [
                      if (widget.args.isSetlist) '${widget.args.setlistName} · ${songIndex + 1}/${_songs!.length}',
                      if (current.composer.isNotEmpty) current.composer,
                      'Page $pageLabel',
                    ].join('  ·  '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ]),
              ),
              IconButton(
                tooltip: 'Annotate',
                icon: const Icon(Icons.draw_outlined),
                onPressed: () => _setAnnotating(true),
              ),
              PopupMenuButton<String>(
                tooltip: 'View options',
                icon: const Icon(Icons.chrome_reader_mode_outlined),
                onSelected: (v) {
                  switch (v) {
                    case 'two':
                      notifier.set((s) => s.copyWith(twoPageLandscape: !s.twoPageLandscape));
                    case 'half':
                      notifier.set((s) => s.copyWith(halfPageTurn: !s.halfPageTurn));
                      setState(() => _half = false);
                    default:
                      notifier.set((s) => s.copyWith(pageTint: PageTint.values.byName(v)));
                  }
                },
                itemBuilder: (_) => [
                  CheckedPopupMenuItem(
                      value: 'two', checked: settings.twoPageLandscape, child: const Text('Two pages in landscape')),
                  CheckedPopupMenuItem(value: 'half', checked: settings.halfPageTurn, child: const Text('Half-page turns')),
                  const PopupMenuDivider(),
                  for (final t in PageTint.values)
                    CheckedPopupMenuItem(value: t.name, checked: settings.pageTint == t, child: Text('${t.label} page')),
                ],
              ),
              IconButton(
                tooltip: 'Share PDF',
                icon: const Icon(Icons.ios_share),
                onPressed: () async {
                  await _store.flush();
                  if (mounted) await exportSongs(context, ref, [current], current.title);
                },
              ),
              IconButton(
                tooltip: 'Edit details',
                icon: const Icon(Icons.info_outline),
                onPressed: () => editSong(context, ref, current),
              ),
              if (widget.args.isSetlist)
                IconButton(
                  tooltip: 'Songs',
                  icon: const Icon(Icons.format_list_numbered),
                  onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
                ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _bottomBar() {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      bottom: _chrome ? 0 : -(bottom + 140),
      left: 0,
      right: 0,
      child: Material(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.96),
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottom, top: 8),
          child: _ScrubberStrip(
            controller: _scrubber,
            count: _flat.length,
            current: _units[_unit],
            songStarts: _offsets.toSet(),
            labelOf: (flat) => '${_flat[flat].page + 1}',
            builder: (flat) => _thumb(flat),
            onTap: (flat) {
              _goToFlat(flat);
            },
          ),
        ),
      ),
    );
  }

  Widget _thumb(int flat) {
    final r = _flat[flat];
    final song = _songs![r.song];
    final path = _paths.pdf(song.fileName);
    final doc = _docs.peek(path);
    if (doc == null) {
      return FutureBuilder(
        future: _docs.load(path),
        builder: (context, snap) => snap.hasData ? _thumb(flat) : const ColoredBox(color: Colors.white),
      );
    }
    return PdfPageImage(doc: doc, docKey: song.fileName, page: r.page, quality: 1);
  }

  Widget _songDrawer(List<Song> songs) {
    final currentSong = _flat[_currentFlat].song;
    return Drawer(
      child: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text(widget.args.setlistName ?? '', style: Theme.of(context).textTheme.titleLarge),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, i) {
                final s = ref.read(songByIdProvider)[songs[i].id] ?? songs[i];
                return ListTile(
                  selected: i == currentSong,
                  leading: CircleAvatar(radius: 14, child: Text('${i + 1}', style: const TextStyle(fontSize: 12))),
                  title: Text(s.title),
                  subtitle: Text('${s.pageCount} pages'),
                  onTap: () {
                    Navigator.pop(context);
                    _goToFlat(_offsets[i]);
                  },
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}

class _ScrubberStrip extends StatelessWidget {
  const _ScrubberStrip({
    required this.controller,
    required this.count,
    required this.current,
    required this.songStarts,
    required this.labelOf,
    required this.builder,
    required this.onTap,
  });

  static const itemExtent = 76.0;

  final ScrollController controller;
  final int count;
  final List<int> current;
  final Set<int> songStarts;
  final String Function(int flat) labelOf;
  final Widget Function(int flat) builder;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 112,
      child: ListView.builder(
        controller: controller,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemExtent: itemExtent,
        itemCount: count,
        itemBuilder: (context, i) {
          final active = current.contains(i);
          return GestureDetector(
            onTap: () => onTap(i),
            child: Padding(
              padding: EdgeInsets.only(left: songStarts.contains(i) && i > 0 ? 10 : 4, right: 4, bottom: 4),
              child: Column(children: [
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    decoration: BoxDecoration(
                      border: Border.all(color: active ? scheme.primary : scheme.outlineVariant, width: active ? 3 : 1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: ClipRRect(borderRadius: BorderRadius.circular(4), child: builder(i)),
                  ),
                ),
                const SizedBox(height: 4),
                Text(labelOf(i),
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: active ? FontWeight.bold : FontWeight.normal,
                        color: active ? scheme.primary : scheme.onSurfaceVariant)),
              ]),
            ),
          );
        },
      ),
    );
  }
}
