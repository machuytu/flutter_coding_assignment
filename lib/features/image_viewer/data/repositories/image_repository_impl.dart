import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import '../../domain/repositories/image_repository_interface.dart';

class ImageRepositoryImpl implements ImageRepositoryInterface {
  @override
  Future<String> downloadAndResizeImage(String imageUrl) async {
    try {
      // Download image bytes
      final Uint8List imageBytes = await _downloadImageBytes(imageUrl);

      // Save original image to temporary file
      final Directory tempDir = await getTemporaryDirectory();
      final String tempFilePath =
          '${tempDir.path}/temp_${DateTime.now().millisecondsSinceEpoch}.png';
      final File tempFile = File(tempFilePath);
      await tempFile.writeAsBytes(imageBytes);

      // Resize image using compute with static method
      await compute<String, void>(_resizeImage, tempFilePath);

      // Read the resized image
      final Uint8List resizedBytes = await tempFile.readAsBytes();

      // Save to documents directory
      final String filePath = await _saveImageToDocuments(
        resizedBytes,
        imageUrl,
      );

      // Clean up temp file
      await tempFile.delete();

      return filePath;
    } catch (e) {
      throw Exception('Failed to download and resize image: $e');
    }
  }

  Future<Uint8List> _downloadImageBytes(String imageUrl) async {
    try {
      final HttpClient client = HttpClient();
      final HttpClientRequest request = await client.getUrl(
        Uri.parse(imageUrl),
      );
      final HttpClientResponse response = await request.close();

      final List<int> bytes = await response.fold<List<int>>(
        <int>[],
        (List<int> previous, List<int> element) => previous..addAll(element),
      );

      return Uint8List.fromList(bytes);
    } catch (e) {
      throw Exception('Failed to download image: $e');
    }
  }

  // Static method that will run in isolate
  static Future<void> _resizeImage(String filePath) async {
    try {
      final File file = File(filePath);
      final Uint8List bytes = await file.readAsBytes();

      debugPrint("Picture original size: ${bytes.length}");

      // Decode the image using image package
      final img.Image? originalImage = img.decodeImage(bytes);
      if (originalImage == null) {
        throw Exception('Failed to decode image');
      }

      // Calculate new dimensions (half size)
      final int newWidth = (originalImage.width / 2).round();
      final int newHeight = (originalImage.height / 2).round();

      // Resize the image
      final img.Image resizedImage = img.copyResize(
        originalImage,
        width: newWidth,
        height: newHeight,
        interpolation: img.Interpolation.linear,
      );

      // Encode to JPEG format with compression to reduce file size
      final Uint8List resizedBytes = img.encodeJpg(resizedImage, quality: 70);
      debugPrint("Picture resized size: ${resizedBytes.length}");

      // Write back to the same file
      await file.writeAsBytes(resizedBytes);
    } catch (e) {
      throw Exception('Failed to resize image: $e');
    }
  }

  Future<String> _saveImageToDocuments(
    Uint8List imageBytes,
    String originalUrl,
  ) async {
    try {
      final Directory documentsDir = await getApplicationDocumentsDirectory();
      final String fileName =
          '${DateTime.now().millisecondsSinceEpoch}_resized.jpg';
      final String filePath = '${documentsDir.path}/$fileName';

      final File file = File(filePath);
      await file.writeAsBytes(imageBytes);

      return filePath;
    } catch (e) {
      throw Exception('Failed to save image: $e');
    }
  }
}
