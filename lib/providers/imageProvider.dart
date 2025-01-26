import 'dart:convert';

import 'package:chatgpt/models/imageModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

/// Provider for managing selected images and handling image upload
class SelectImageProvider extends ChangeNotifier {
  List<ImageModel> selectedImage = []; // List of selected images
  int count = 0; // Counter to track how many images have been uploaded
  bool isSent = true; // Flag to check if images are sent or pending

  /// Adds an image to the selectedImage list and notifies listeners
  void addImage(ImageModel data) {
    selectedImage.add(data);
    notifyListeners();
  }

  /// Uploads the selected image to Cloudinary and updates its URL
  ///
  /// Returns:
  /// - The image URL if the upload is successful.
  /// - `"error"` if the upload fails.
  Future<String> uploadImage(XFile image, int index) async {
    // Construct the Cloudinary upload URL using environment variables
    final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/${dotenv.env['CLOUD_NAME']}/upload");

    // Prepare the multipart request for uploading the image
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = dotenv.env['UPLOAD_PRESET']!
      ..files.add(await http.MultipartFile.fromPath('file', image.path));

    // Send the request and get the response
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);

      // Update the selectedImage list with the uploaded image URL
      selectedImage[index].url = jsonMap['url'];
      selectedImage[index].state = "done";
      count += 1;
      notifyListeners();
      return jsonMap['url'];
    } else {
      notifyListeners();
      return "error";
    }
  }

  /// Clears all selected images and resets the count
  void clearImage() {
    selectedImage = [];
    count = 0;
    notifyListeners();
  }

  /// Removes an image at the specified index from the selected list
  void removeImage(int index) {
    if (selectedImage[index].state == "done") {
      count -= 1;
    }
    selectedImage.removeAt(index);
    notifyListeners();
  }
}
