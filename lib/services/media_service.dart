import 'package:image_picker/image_picker.dart';

class MediaService {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickImage(ImageSource source) async {
    return await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );
  }

  Future<XFile?> pickVideo(ImageSource source) async {
    return await _picker.pickVideo(
      source: source,
      maxDuration: const Duration(seconds: 30),
    );
  }
}
