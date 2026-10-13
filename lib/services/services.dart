import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/providers.dart';
import 'backup_service.dart';
import 'export_service.dart';
import 'import_service.dart';
import 'pdf_render.dart';

final importServiceProvider =
    Provider((ref) => ImportService(ref.watch(databaseProvider), ref.watch(appPathsProvider)));

final exportServiceProvider =
    Provider((ref) => ExportService(ref.watch(databaseProvider), ref.watch(appPathsProvider)));

final backupServiceProvider = Provider((ref) => BackupService(ref.watch(appPathsProvider)));

final thumbnailServiceProvider = Provider((ref) => ThumbnailService(ref.watch(appPathsProvider).thumbDir));
