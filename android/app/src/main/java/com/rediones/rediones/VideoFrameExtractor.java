package com.rediones.rediones;

// File: VideoFrameExtractor.java

import android.graphics.Bitmap;
import android.media.MediaMetadataRetriever;
import android.os.Build;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.List;

public class VideoFrameExtractor {


    public static List<byte[]> extractFrames(String videoPath) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
            return new ArrayList<>();
        }

        try (MediaMetadataRetriever retriever = new MediaMetadataRetriever()) {
            retriever.setDataSource(videoPath);
            List<byte[]> frames = new ArrayList<>();
            String time = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION);
            long duration = Long.parseLong(time) * 1000; // microsecond

            for (long i = 0; i < duration; i += 33333) { // Extract 30 frames per second
                Bitmap bitmap = retriever.getFrameAtTime(i, MediaMetadataRetriever.OPTION_CLOSEST_SYNC);
                if (bitmap != null) {
                    ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
                    bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream);
                    frames.add(outputStream.toByteArray());
                }
            }
            retriever.release();
            return frames;
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }
}
