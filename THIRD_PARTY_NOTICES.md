# Third-party notices

The MusicSheets source code is MIT-licensed (see [LICENSE](LICENSE)). The MIT license covers only
the code in this repository. The app uses other software and services, each under its own terms.

The app shows the full license texts of all bundled packages under **Settings → Open-source licenses**.

## Syncfusion Flutter PDF (proprietary)

`syncfusion_flutter_pdf` and `syncfusion_flutter_core` are **not open source**. They are used under the
[Syncfusion Community License](https://www.syncfusion.com/products/communitylicense), which is free for
individuals and organizations with less than US $1 million annual gross revenue and at most five
developers. Anyone who builds or redistributes this app must hold their own Community or commercial
license and accept the [Syncfusion license terms](https://www.syncfusion.com/content/downloads/syncfusion_license.pdf).
The packages are fetched from pub.dev at build time and are not part of this repository.

## Dart and Flutter packages

All other packages from `pubspec.lock` are open source under permissive licenses:

- BSD-3-Clause: Flutter SDK, `go_router`, `http`, `path_provider`, `shared_preferences`, `share_plus`,
  `connectivity_plus`, `wakelock_plus`, `crypto`, `animations` and others
- MIT: `drift`, `flutter_riverpod`, `pdfrx`, `perfect_freehand`, `file_picker`, `archive`, `image`, `uuid`,
  `flutter_soloud`, `super_sliver_list`, `workmanager` and others
- Apache-2.0: `just_audio`, `rxdart`, `material_color_utilities`
- BSD-2-Clause: `recase`
- MPL-2.0: `dbus`, `nm` (Linux builds only, unmodified)

## Native libraries in the app

- [PDFium](https://pdfium.googlesource.com/pdfium/) (BSD-3-Clause), via `pdfrx`
- [SoLoud](https://solhsa.com/soloud/) (zlib), via `flutter_soloud`
- [SQLite](https://sqlite.org/copyright.html) (public domain), via `sqlite3_flutter_libs`
- [AndroidX Media3 / ExoPlayer](https://github.com/androidx/media) (Apache-2.0), via `just_audio` on Android

## Online services

When "Fetch song metadata online" is turned on, the app queries:

- [MusicBrainz](https://musicbrainz.org/doc/About/Data_License): core data is CC0
- [Cover Art Archive](https://coverartarchive.org/): cover images belong to their copyright holders
- [AcousticBrainz](https://acousticbrainz.org/data): data is CC0
- [Deezer API](https://developers.deezer.com/termsofuse): subject to Deezer's API terms of use
