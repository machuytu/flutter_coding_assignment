import 'dart:io';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

class _ResizeImageParams {
  final Uint8List imageBytes;
  final int newWidth;
  final int newHeight;

  _ResizeImageParams(this.imageBytes, this.newWidth, this.newHeight);
}

class ImageRepository {
  Future<String> downloadAndResizeImage(String imageUrl) async {
    try {
      // Download image bytes
      final Uint8List imageBytes = await _downloadImageBytes(imageUrl);

      // Decode image to get original dimensions
      final ui.Codec codec = await ui.instantiateImageCodec(imageBytes);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      final ui.Image originalImage = frameInfo.image;

      // Calculate new dimensions (half size)
      final int newWidth = (originalImage.width / 2).round();
      final int newHeight = (originalImage.height / 2).round();

      // Resize image using compute isolate
      final Uint8List resizedBytes = await _resizeImageInIsolate(
        imageBytes,
        newWidth,
        newHeight,
      );

      // Save to documents directory
      final String filePath = await _saveImageToDocuments(
        resizedBytes,
        imageUrl,
      );

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

  Future<Uint8List> _resizeImageInIsolate(
    Uint8List imageBytes,
    int newWidth,
    int newHeight,
  ) async {
    // This will run in a separate isolate to avoid blocking the main thread
    final params = _ResizeImageParams(imageBytes, newWidth, newHeight);
    return await compute(_resizeImage, params);
  }

  static Future<Uint8List> _resizeImage(_ResizeImageParams params) async {
    final Uint8List imageBytes = params.imageBytes;
    final int newWidth = params.newWidth;
    final int newHeight = params.newHeight;
    try {
      // Decode the image
      final ui.Codec codec = await ui.instantiateImageCodec(imageBytes);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      final ui.Image originalImage = frameInfo.image;

      // Create a picture recorder
      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final ui.Canvas canvas = ui.Canvas(recorder);

      // Draw the resized image
      final ui.Paint paint = ui.Paint()..filterQuality = ui.FilterQuality.high;
      canvas.drawImageRect(
        originalImage,
        ui.Rect.fromLTWH(
          0,
          0,
          originalImage.width.toDouble(),
          originalImage.height.toDouble(),
        ),
        ui.Rect.fromLTWH(0, 0, newWidth.toDouble(), newHeight.toDouble()),
        paint,
      );

      // Convert to image
      final ui.Picture picture = recorder.endRecording();
      final ui.Image resizedImage = await picture.toImage(newWidth, newHeight);

      // Convert to bytes
      final ByteData? byteData = await resizedImage.toByteData(
        format: ui.ImageByteFormat.png,
      );
      if (byteData == null) {
        throw Exception('Failed to convert image to bytes');
      }

      return byteData.buffer.asUint8List();
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
          '${DateTime.now().millisecondsSinceEpoch}_resized.png';
      final String filePath = '${documentsDir.path}/$fileName';

      final File file = File(filePath);
      await file.writeAsBytes(imageBytes);

      return filePath;
    } catch (e) {
      throw Exception('Failed to save image: $e');
    }
  }
}
