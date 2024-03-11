// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
//import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

import 'package:rediones/tools/constants.dart';
import 'media_view.dart';

/// Camera example home widget.
class CameraApp extends StatefulWidget {
  /// Default Constructor
  const CameraApp({Key? key}) : super(key: key);

  @override
  State<CameraApp> createState() => _CameraAppState();
}

void _logError(String code, String? message) {
  // ignore: avoid_print
  print('Error: $code${message == null ? '' : '\nError Message: $message'}');
}

class _CameraAppState extends State<CameraApp>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late List<CameraDescription> allCameras;
  int currentCamera = 0;

  CameraController? controller;
  XFile? imageFile;
  VoidCallback? videoPlayerListener;
  bool enableAudio = true;

  // double _minAvailableExposureOffset = 0.0;
  // double _maxAvailableExposureOffset = 0.0;
  // double _currentExposureOffset = 0.0;
  late AnimationController _flashModeControlRowAnimationController;
  late Animation<double> _flashModeControlRowAnimation;
  late AnimationController _exposureModeControlRowAnimationController;
  late Animation<double> _exposureModeControlRowAnimation;
  late AnimationController _focusModeControlRowAnimationController;
  late Animation<double> _focusModeControlRowAnimation;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentScale = 1.0;
  double _baseScale = 1.0;

  // Counting pointers (number of user fingers on screen)
  int _pointers = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _flashModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _flashModeControlRowAnimation = CurvedAnimation(
      parent: _flashModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
    _exposureModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _exposureModeControlRowAnimation = CurvedAnimation(
      parent: _exposureModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
    _focusModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _focusModeControlRowAnimation = CurvedAnimation(
      parent: _focusModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );

    onNewCameraSelected(allCameras[currentCamera]);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _flashModeControlRowAnimationController.dispose();
    _exposureModeControlRowAnimationController.dispose();
    super.dispose();
  }

  // #docregion AppLifecycle
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  // #enddocregion AppLifecycle

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("CREAM",
            style: context.textTheme.titleMedium),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _modeControlRowWidget(),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Center(
                    child: _cameraPreviewWidget(),
                  ),
                ),
              ),
            ),
            _captureControlRowWidget(context),
          ],
        ),
      ),
    );
  }

  Widget _cameraPreviewWidget() {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return const Text(
        'Setting up camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w800,
        ),
      );
    } else {
      return Listener(
        onPointerDown: (_) => _pointers++,
        onPointerUp: (_) => _pointers--,
        child: CameraPreview(
          controller!,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onScaleStart: _handleScaleStart,
                  onScaleUpdate: _handleScaleUpdate,
                  onTapDown: (TapDownDetails details) =>
                      onViewFinderTap(details, constraints),
                );
              }),
        ),
      );
    }
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (controller == null || _pointers != 2) {
      return;
    }

    _currentScale = (_baseScale * details.scale)
        .clamp(_minAvailableZoom, _maxAvailableZoom);

    await controller!.setZoomLevel(_currentScale);
  }

  /// Display a bar with buttons to change the flash and exposure modes
  Widget _modeControlRowWidget() {
    return Container(
      color: Colors.black,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.flash_on),
                color: appRed,
                onPressed: controller != null ? onFlashModeButtonPressed : null,
              ),
              // The exposure and focus mode are currently not supported on the web.
              ...!kIsWeb
                  ? <Widget>[
                IconButton(
                  icon: const Icon(Icons.exposure),
                  color: appRed,
                  onPressed: controller != null
                      ? onExposureModeButtonPressed
                      : null,
                ),
                IconButton(
                  icon: const Icon(Icons.filter_center_focus),
                  color: appRed,
                  onPressed: controller != null
                      ? onFocusModeButtonPressed
                      : null,
                )
              ]
                  : <Widget>[],
            ],
          ),
          _flashModeControlRowWidget(),
          _exposureModeControlRowWidget(),
          _focusModeControlRowWidget(),
        ],
      ),
    );
  }

  Widget _flashModeControlRowWidget() {
    return SizeTransition(
      sizeFactor: _flashModeControlRowAnimation,
      child: Column(
        children: [
          const Center(
            child: Text('Flash Mode', style: TextStyle(color: Colors.white)),
          ),
          ClipRect(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.flash_off),
                  color: controller?.value.flashMode == FlashMode.off
                      ? Colors.orange
                      : Colors.blue,
                  onPressed: controller != null
                      ? () => onSetFlashModeButtonPressed(FlashMode.off)
                      : null,
                ),
                IconButton(
                  icon: const Icon(Icons.flash_auto),
                  color: controller?.value.flashMode == FlashMode.auto
                      ? Colors.orange
                      : Colors.blue,
                  onPressed: controller != null
                      ? () => onSetFlashModeButtonPressed(FlashMode.auto)
                      : null,
                ),
                IconButton(
                  icon: const Icon(Icons.flash_on),
                  color: controller?.value.flashMode == FlashMode.always
                      ? Colors.orange
                      : Colors.blue,
                  onPressed: controller != null
                      ? () => onSetFlashModeButtonPressed(FlashMode.always)
                      : null,
                ),
                IconButton(
                  icon: const Icon(Icons.highlight),
                  color: controller?.value.flashMode == FlashMode.torch
                      ? Colors.orange
                      : Colors.blue,
                  onPressed: controller != null
                      ? () => onSetFlashModeButtonPressed(FlashMode.torch)
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _exposureModeControlRowWidget() {
    final ButtonStyle styleAuto = TextButton.styleFrom(

      // ignore: deprecated_member_use
      backgroundColor: controller?.value.exposureMode == ExposureMode.auto
          ? Colors.orange
          : Colors.blue,
    );
    final ButtonStyle styleLocked = TextButton.styleFrom(
      // ignore: deprecated_member_use
      backgroundColor: controller?.value.exposureMode == ExposureMode.locked
          ? Colors.orange
          : Colors.blue,
    );

    return SizeTransition(
      sizeFactor: _exposureModeControlRowAnimation,
      child: ClipRect(
        child: Container(
          color: Colors.black,
          child: Column(
            children: <Widget>[
              const Center(
                child: Text('Exposure Mode',
                    style: TextStyle(color: Colors.white)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextButton(
                    style: styleAuto,
                    onPressed: controller != null
                        ? () =>
                        onSetExposureModeButtonPressed(ExposureMode.auto)
                        : null,
                    onLongPress: () {
                      if (controller != null) {
                        controller!.setExposurePoint(null);
                      }
                    },
                    child: const Text('AUTO'),
                  ),
                  TextButton(
                    style: styleLocked,
                    onPressed: controller != null
                        ? () =>
                        onSetExposureModeButtonPressed(ExposureMode.locked)
                        : null,
                    child: const Text('LOCKED'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _focusModeControlRowWidget() {
    final ButtonStyle styleAuto = TextButton.styleFrom(
      // ignore: deprecated_member_use
      backgroundColor: controller?.value.focusMode == FocusMode.auto
          ? Colors.orange
          : Colors.blue,
    );
    final ButtonStyle styleLocked = TextButton.styleFrom(
      // ignore: deprecated_member_use
      backgroundColor: controller?.value.focusMode == FocusMode.locked
          ? Colors.orange
          : Colors.blue,
    );

    return SizeTransition(
      sizeFactor: _focusModeControlRowAnimation,
      child: ClipRect(
        child: Container(
          color: Colors.black,
          child: Column(
            children: <Widget>[
              const Center(
                child:
                Text('Focus Mode', style: TextStyle(color: Colors.white)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextButton(
                    style: styleAuto,
                    onPressed: controller != null
                        ? () => onSetFocusModeButtonPressed(FocusMode.auto)
                        : null,
                    onLongPress: () {
                      if (controller != null) {
                        controller!.setFocusPoint(null);
                      }
                    },
                    child: const Text('AUTO'),
                  ),
                  TextButton(
                    style: styleLocked,
                    onPressed: controller != null
                        ? () => onSetFocusModeButtonPressed(FocusMode.locked)
                        : null,
                    child: const Text('LOCKED'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Display the control bar with buttons to take pictures and record videos.
  Widget _captureControlRowWidget(BuildContext context) {
    final CameraController? cameraController = controller;

    return Container(
      height: 120,
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _cameraTogglesRowWidget(),
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
                color: neutral2, borderRadius: BorderRadius.circular(40)),
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.camera_alt, size: 32),
                color: appRed,
                onPressed: cameraController != null &&
                    cameraController.value.isInitialized &&
                    !cameraController.value.isRecordingVideo
                    ? onTakePictureButtonPressed
                    : null,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (imageFile == null) return;
              if (controller != null) {
                onSetFlashModeButtonPressed(FlashMode.off);
              }

              // context.router.pushNamed(Pages.previewImages, pathParameters:
              // {
              //   'images' : jsonEncode([imageFile!.path]),
              //   'type' : jsonEncode(DisplayType.file),
              //   'bottom' : jsonEncode(true),
              //   'index' : jsonEncode(0)
              // }).then((value) {
              //   if (value != null && value == true) {
              //     context.router.pop(imageFile!.path);
              //   }
              // });
            },
            child: SizedBox(
                width: 64.0,
                height: 64.0,
                child: imageFile == null
                    ? null
                    : kIsWeb
                    ? Image.network(imageFile!.path)
                    : Image.file(File(imageFile!.path))),
          )
        ],
      ),
    );
  }

  Widget _cameraTogglesRowWidget() {
    void onChanged(CameraDescription? description) {
      if (description == null) {
        return;
      }

      onNewCameraSelected(description);
    }

    if (allCameras.isEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        showInSnackBar('No camera found.');
      });
      return const Text('None');
    }

    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
          color: neutral2, borderRadius: BorderRadius.circular(30)),
      child: Center(
        child: IconButton(
            icon: const Icon(Boxicons.bx_refresh, color: appRed, size: 28),
            onPressed: () {
              currentCamera += 1;
              currentCamera %= allCameras.length;
              onChanged(allCameras[currentCamera]);
            },
            splashRadius: 0.05),
      ),
    );
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    context.messenger
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }

    final CameraController cameraController = controller!;

    final Offset offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    final CameraController? oldController = controller;
    if (oldController != null) {
      controller = null;
      await oldController.dispose();
    }

    final CameraController cameraController = CameraController(
      cameraDescription,
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
      enableAudio: enableAudio,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {
        showInSnackBar(
            'Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
      await Future.wait(<Future<Object?>>[
        // ...!kIsWeb
        //     ? <Future<Object?>>[
        //         cameraController.getMinExposureOffset().then(
        //             (double value) => _minAvailableExposureOffset = value),
        //         cameraController
        //             .getMaxExposureOffset()
        //             .then((double value) => _maxAvailableExposureOffset = value)
        //       ]
        //     : <Future<Object?>>[],
        cameraController.setFlashMode(FlashMode.off),
        cameraController
            .getMaxZoomLevel()
            .then((double value) => _maxAvailableZoom = value),
        cameraController
            .getMinZoomLevel()
            .then((double value) => _minAvailableZoom = value),
      ]);
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          showInSnackBar('You have denied camera access.');
          break;
        case 'CameraAccessDeniedWithoutPrompt':
        // iOS only
          showInSnackBar('Please go to Settings app to enable camera access.');
          break;
        case 'CameraAccessRestricted':
        // iOS only
          showInSnackBar('Camera access is restricted.');
          break;
        case 'AudioAccessDenied':
          showInSnackBar('You have denied audio access.');
          break;
        case 'AudioAccessDeniedWithoutPrompt':
        // iOS only
          showInSnackBar('Please go to Settings app to enable audio access.');
          break;
        case 'AudioAccessRestricted':
        // iOS only
          showInSnackBar('Audio access is restricted.');
          break;
        default:
          _showCameraException(e);
          break;
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

//   onPressed: () async {
//   // take picture
//   try {
//   final XFile file = await controller.takePicture();
//   // load the picture as bytes
//   final blob = await file.readAsBytes();
//   // try to flip it horizontally
//   final img.Image? original = img.decodeImage(blob);
//   if (original != null) {
//   final img.Image oriented = img.flipHorizontal(original);
//   final orientedBlob =
//   Uint8List.fromList(img.encodeJpg(oriented));
//   setState(() {
//   // set the image to show the output
//   image = Image.memory(orientedBlob);
//   });
//   }
//   } catch (e) {
//   print(e);
//   }
// },

  void onTakePictureButtonPressed() {
    takePicture().then((XFile? file) async {
      if (mounted) {
        if (allCameras[currentCamera].lensDirection ==
            CameraLensDirection.front &&
            file != null) {
          // FlutterFFmpeg mpeg = FlutterFFmpeg();
          // await mpeg
          //     .execute("-y -i ${file.path} -filter:v \"hflip\" ${file.path}");
        }

        setState(() {
          imageFile = file;
        });
      }
    });
  }

  void onFlashModeButtonPressed() {
    if (_flashModeControlRowAnimationController.value == 1) {
      _flashModeControlRowAnimationController.reverse();
    } else {
      _flashModeControlRowAnimationController.forward();
      _exposureModeControlRowAnimationController.reverse();
      _focusModeControlRowAnimationController.reverse();
    }
  }

  void onExposureModeButtonPressed() {
    if (_exposureModeControlRowAnimationController.value == 1) {
      _exposureModeControlRowAnimationController.reverse();
    } else {
      _exposureModeControlRowAnimationController.forward();
      _flashModeControlRowAnimationController.reverse();
      _focusModeControlRowAnimationController.reverse();
    }
  }

  void onFocusModeButtonPressed() {
    if (_focusModeControlRowAnimationController.value == 1) {
      _focusModeControlRowAnimationController.reverse();
    } else {
      _focusModeControlRowAnimationController.forward();
      _flashModeControlRowAnimationController.reverse();
      _exposureModeControlRowAnimationController.reverse();
    }
  }

  void onSetFlashModeButtonPressed(FlashMode mode) {
    setFlashMode(mode).then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void onSetExposureModeButtonPressed(ExposureMode mode) {
    setExposureMode(mode).then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void onSetFocusModeButtonPressed(FocusMode mode) {
    setFocusMode(mode).then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> setFlashMode(FlashMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      await controller!.setFlashMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setExposureMode(ExposureMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      await controller!.setExposureMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setExposureOffset(double offset) async {
    if (controller == null) {
      return;
    }

    // setState(() {
    //   _currentExposureOffset = offset;
    // });

    try {
      offset = await controller!.setExposureOffset(offset);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> setFocusMode(FocusMode mode) async {
    if (controller == null) {
      return;
    }

    try {
      await controller!.setFocusMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      final XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void _showCameraException(CameraException e) {
    _logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}