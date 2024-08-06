import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mime/mime.dart';
import 'package:rediones/api/file_handler.dart';
import 'package:rediones/api/message_service.dart';
import 'package:rediones/tools/constants.dart';
import 'package:rediones/tools/functions.dart';
import 'package:rediones/tools/providers.dart';
import 'package:zero_story_editor/flutter_story_editor.dart';
import 'package:zero_story_editor/src/controller/controller.dart';

class CreateStoryPage extends ConsumerStatefulWidget {
  final SingleFileResponse media;

  const CreateStoryPage({super.key, required this.media});

  @override
  ConsumerState<CreateStoryPage> createState() => _CreateStoryPageState();
}

class _CreateStoryPageState extends ConsumerState<CreateStoryPage> {
  FlutterStoryEditorController storyController = FlutterStoryEditorController();
  final TextEditingController captionController = TextEditingController();

  late List<File> selectedFiles;

  @override
  void initState() {
    super.initState();
    selectedFiles = [File(widget.media.path)];
  }

  @override
  void dispose() {
    storyController.dispose();
    captionController.dispose();
    super.dispose();
  }

  List<dynamic> determineFileType(String filePath) {
    String? mimeStr = lookupMimeType(filePath);

    if (mimeStr != null) {
      var fileType = mimeStr.split('/');
      if (fileType[0] == 'image') {
        return [1, fileType[1]];
      } else if (fileType[0] == 'video') {
        return [2, fileType[1]];
      }
    }

    return [];
  }

  void create(Map<String, dynamic> map) {
    createStory(map);
    context.router.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterStoryEditor(
        controller: storyController,
        captionController: captionController,
        selectedFiles: selectedFiles,
        onSaveClickListener: (files) async {
          File file = files.first;

          String base64 = await FileHandler.convertFilePathToBase64(file.path);
          List<dynamic> type = determineFileType(file.path);

          Map<String, dynamic> map = {
            "media": "data:image/${type.first};base64,$base64",
            "type": type[1],
            "caption": "",
          };

          create(map);
        },
      ),
    );
  }
}
