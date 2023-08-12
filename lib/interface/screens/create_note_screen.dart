import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteshell/interface/components/shared/gradient_background.dart';
import 'package:noteshell/interface/components/shared/process_complete_layout.dart';
import 'package:noteshell/interface/components/shared/process_error_layout.dart';
import 'package:noteshell/interface/components/shared/processing_layout.dart';
import 'package:noteshell/interface/components/shared/styled_fab_button.dart';
import 'package:noteshell/logic/bloc/note_event.dart';
import 'package:noteshell/logic/bloc/note_states.dart';
import 'package:uuid/uuid.dart';
import '../../logic/bloc/note_bloc.dart';

import '../theme/app_colors.dart';

class CreateNoteScreen extends StatefulWidget {
  const CreateNoteScreen({super.key});

  @override
  State<CreateNoteScreen> createState() => _CreateNoteScreenState();
}

class _CreateNoteScreenState extends State<CreateNoteScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final uuid = const Uuid();

  //handle note creation
  void createNote(BuildContext context) {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please add Title and Note"),
        duration: Duration(seconds: 1),
      ));
      return;
    }
    BlocProvider.of<NoteBloc>(context).add(Create(uuid.v4(),
        _titleController.text, _descriptionController.text, Timestamp.now()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteBloc, NoteState>(builder: (context, state) {
      //creating note
      if (state is NoteCreating) {
        return const ProcessingLayout(title: "Creating note...");
      }
      //note created
      else if (state is NoteCreated) {
        Timer(const Duration(seconds: 1), () {
          Navigator.pop(context, true);
        });
        return const ProcessCompleteLayout(title: "Created");
      }
      //error while creating
      else if (state is NoteError) {
        Timer(const Duration(seconds: 2), () {
          Navigator.pop(context, true);
        });
        return const ProcessErrorLayout();
      }
      //default initial layout
      return buildInitialLayout(context: context);
    });
  }

  Widget buildInitialLayout({required BuildContext context}) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.primaryColorShade200,
      floatingActionButton: StyledFabButton(
          onPressed: () {
            createNote(context);
          },
          tooltip: "Create",
          iconData: Icons.done_rounded),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: GradientBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 128),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(borderSide: BorderSide.none),
                  hintText: "Title",
                ),
                controller: _titleController,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                cursorColor: AppColors.onPrimaryColor,
                style: textTheme.displayMedium,
              ),
              Divider(
                  color: AppColors.onPrimaryColor.withOpacity(0.25), height: 4),
              TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(borderSide: BorderSide.none),
                  hintText: "Note",
                ),
                controller: _descriptionController,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                cursorColor: AppColors.onPrimaryColor,
                style: textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
