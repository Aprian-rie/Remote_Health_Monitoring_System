// providers/image_provider.dart
import 'dart:io';
import 'package:flutter/material.dart';

class UserImageProvider extends ChangeNotifier {
  File? _selectedImage;

  File? get selectedImage => _selectedImage;

  void setSelectedImage(File? image) {
    _selectedImage = image;
    notifyListeners();
  }

  void clearSelectedImage() {
    _selectedImage = null;
    notifyListeners();
  }
}


