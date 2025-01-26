import 'package:image_picker/image_picker.dart';

/*
This class is responsible for handling functionalities related to picking images from gallery.
 */

class PickImage {
  //This function picks images from gallery
  static Future<XFile?> pickImageFromGallery() async {
    final selectedPhoto =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    return selectedPhoto;
  }
}
