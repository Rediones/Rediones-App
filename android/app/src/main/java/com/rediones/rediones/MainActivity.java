package com.rediones.rediones;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import java.util.List;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.rediones.rediones/video";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("extractFrames")) {
                                String videoPath = call.argument("videoPath");
                                List<byte[]> frames = VideoFrameExtractor.extractFrames(videoPath);
                                result.success(frames);
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }
}
