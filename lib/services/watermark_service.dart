import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:watermark_kit/watermark_kit.dart';
import 'package:intl/intl.dart';

class WatermarkService {
  final _watermarker = WatermarkKit();

  Future<File?> watermarkImage(File imageFile, double lat, double lng) async {
    try {
      final bytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(bytes);

      if (image == null) return null;

      final timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      final text = 'Lat: ${lat.toStringAsFixed(4)}, Lng: ${lng.toStringAsFixed(4)}\n$timestamp';

      // Draw text on image
      img.drawString(
        image,
        text,
        font: img.arial24,
        x: 20,
        y: image.height - 80,
        color: img.ColorRgb8(255, 255, 255),
      );

      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/watermarked_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final watermarkedFile = File(path);
      await watermarkedFile.writeAsBytes(img.encodeJpg(image));

      return watermarkedFile;
    } catch (e) {
      print('Image Watermark Error: $e');
      return null;
    }
  }

  Future<File?> watermarkVideo(File videoFile, double lat, double lng) async {
    final timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    final text = 'Lat: ${lat.toStringAsFixed(4)}, Lng: ${lng.toStringAsFixed(4)} | $timestamp';

    try {
      final task = await _watermarker.composeVideo(
        inputVideoPath: videoFile.path,
        text: text,
        anchor: 'bottomLeft',
        margin: 20.0,
        widthPercent: 0.8,
        opacity: 0.9,
      );

      final result = await task.done;
      if (result.path != null) {
        return File(result.path!);
      }
      return null;
    } catch (e) {
      print('WatermarkKit Error: $e');
      return null;
    }
  }
}
