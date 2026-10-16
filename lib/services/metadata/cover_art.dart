import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

import 'musicbrainz_client.dart';

/// Downloads front cover art from the Cover Art Archive and stores a small JPEG.
class CoverArtService {
  CoverArtService(this.client);

  final http.Client client;
  static const size = 300;

  /// Resizes to at most [size] pixels on the long side and encodes as JPEG.
  static Uint8List? toThumbnail(Uint8List bytes) {
    final decoded = img.decodeImage(bytes);
    if (decoded == null) return null;
    final scaled = decoded.width >= decoded.height
        ? img.copyResize(decoded, width: decoded.width > size ? size : decoded.width)
        : img.copyResize(decoded, height: decoded.height > size ? size : decoded.height);
    return Uint8List.fromList(img.encodeJpg(scaled, quality: 82));
  }

  /// Writes the cover to [target]. Returns false when there is no cover.
  Future<bool> download(String releaseGroupId, File target) async {
    final url = Uri.parse('https://coverartarchive.org/release-group/$releaseGroupId/front-500');
    final res = await guardedGet(client, url, {'User-Agent': userAgent});
    if (res.statusCode != 200 || res.bodyBytes.isEmpty) return false;
    final thumb = toThumbnail(res.bodyBytes);
    if (thumb == null) return false;
    await target.writeAsBytes(thumb, flush: true);
    return true;
  }
}
