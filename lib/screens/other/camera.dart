import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera_camera/camera_camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:rediones/tools/constants.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {

  int cameraSide = 0; // 0 is for back camera and 1 is for the front camera


  void flipImage(File? file) async {

    if(file == null) {
      pop(null);
      return;
    }

    Uint8List imageBytes = await file.readAsBytes();
    if(cameraSide == 0) {
      pop(imageBytes);
      return;
    }

    img.Image original = img.decodeImage(imageBytes)!;
    img.Image flipped = img.flipHorizontal(original);
    List<int> flippedBytes = img.encodeJpg(flipped) as Uint8List;
    pop(flippedBytes);
  }

  void pop(List<int>? file) => context.router.pop(file);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CameraCamera(
        onCameraFlipped: (int index) => setState(() => cameraSide = index),
        onFile: flipImage,
      ),
    );
  }
}
