import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rediones/api/file_handler.dart';
import 'package:zero_story_editor/flutter_story_editor.dart';
import 'package:zero_story_editor/src/controller/controller.dart';


class CreateStoryPage extends StatefulWidget {
  final List<SingleFileResponse> media;

  const CreateStoryPage({super.key, required this.media});

  @override
  State<CreateStoryPage> createState() => _CreateStoryPageState();
}

class _CreateStoryPageState extends State<CreateStoryPage> {
  FlutterStoryEditorController storyController = FlutterStoryEditorController();
  final TextEditingController captionController = TextEditingController();

  late List<File> selectedFiles;

  @override
  void initState() {
    super.initState();
    selectedFiles = widget.media.map((md) => File(md.path)).toList();
  }

  @override
  void dispose() {
    storyController.dispose();
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterStoryEditor(
        controller: storyController,
        captionController: captionController,
        selectedFiles: selectedFiles,
        onSaveClickListener: (files) {

        },
      ),
    );
  }
}
