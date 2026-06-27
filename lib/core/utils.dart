import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

// Future<FilePickerResult?> pickImage() async {
//   return await FilePicker.pickFiles();
// }

Future<XFile?> pickImage() async {
  return await ImagePicker().pickImage(source: ImageSource.gallery);
}
