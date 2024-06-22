import 'package:flutter/services.dart';
import 'package:flutter_quick_video_encoder/flutter_quick_video_encoder.dart';


class VideoService {
  static const _platform = MethodChannel("com.rediones.rediones/video");

  static Future<List<Uint8List>> extractFrames(String videoPath) async {
    final List<dynamic> frames = await _platform.invokeMethod(
        'extractFrames', {'videoPath': videoPath});
    return frames.cast<Uint8List>();
  }

  // static Future<void> compressFrames(List<Uint8List> frames) async {
  //   await FlutterQuickVideoEncoder.setup(
  //     width: 1920,
  //     height: 1080,
  //     fps: 60,
  //     videoBitrate: 2500000,
  //     audioChannels: 1,
  //     audioBitrate: 64000,
  //     sampleRate: 44100,
  //     filepath: "/documents/video.mp4", // output file
  //   );
  //   for(int i = 0; i < frameCount; i++) {
  //     Uint8List rgba = _renderVideoFrame(i);  // your video function
  //     Uint8List pcm = _renderAudioFrame(i); // your audio function
  //     await FlutterQuickVideoEncoder.appendVideoFrame(rgba);
  //     await FlutterQuickVideoEncoder.appendAudioFrame(pcm);
  //   }
  //   await FlutterQuickVideoEncoder.finish();
  // }
}