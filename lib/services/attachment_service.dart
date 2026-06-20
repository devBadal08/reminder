import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class AttachmentService {
  static Future<List<String>> pickAndSaveFiles({
    bool allowMultiple = false,
  }) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: allowMultiple,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result == null) return [];

    final externalDir = await getExternalStorageDirectory();
    if (externalDir == null) return [];

    final attachmentDir = Directory("${externalDir.path}/attachments");

    if (!await attachmentDir.exists()) {
      await attachmentDir.create(recursive: true);
    }

    List<String> savedPaths = [];

    for (var file in result.files) {
      if (file.path == null) continue;

      final destinationPath = "${attachmentDir.path}/${file.name}";

      final savedFile = await File(file.path!).copy(destinationPath);

      savedPaths.add(savedFile.path);
    }

    return savedPaths;
  }
}
