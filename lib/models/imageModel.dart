import 'package:image_picker/image_picker.dart';

class ImageModel {
  final XFile image;
  String state;
  String url;

  ImageModel({required this.image, required this.state, required this.url});
}
