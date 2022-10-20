import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class ImagesHelper {

  static Future<Uint8List?> getImageFromCamera() async {
    Uint8List? file = await _pickImage(ImageSource.camera);
    return file;
  }

  static Future<Uint8List?> getImageFromGallery() async {
    Uint8List? file = await _pickImage(ImageSource.gallery);
    return file;
  }

  static Future<Uint8List?> _pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);

    if (file != null) {
      return await file.readAsBytes();
    }
    print("No Image Selected");
    return null;
  }

}
