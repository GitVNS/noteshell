import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteshell/logic/bloc/note_event.dart';

import '../../logic/bloc/note_bloc.dart';
import '../../logic/bloc/note_states.dart';
import '../../model/note_model.dart';
import '../components/shared/gradient_background.dart';
import '../components/shared/process_complete_layout.dart';
import '../components/shared/process_error_layout.dart';
import '../components/shared/processing_layout.dart';
import '../components/shared/styled_fab_button.dart';
import '../theme/app_colors.dart';

class ViewTrashNote extends StatefulWidget {
  const ViewTrashNote({super.key, required this.note});

  final NoteModel note;

  @override
  State<ViewTrashNote> createState() => _ViewTrashNoteState();
}

class _ViewTrashNoteState extends State<ViewTrashNote> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.note.title;
    _descriptionController.text = widget.note.decription;
  }

  //convert timestamp to date
  String getDate() {
    final day = widget.note.createdOn.toDate().day;
    final month = widget.note.createdOn.toDate().month;
    final year = widget.note.createdOn.toDate().year;
    return "Created on: $day/$month/$year";
  }

  //handle restoration of trash note
  void restoreNote({required BuildContext context, required String id}) {
    BlocProvider.of<NoteBloc>(context).add(RestoreNote(id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteBloc, NoteState>(
      builder: (context, state) {
        //restoring trash note
        if (state is RestoringTrashNote) {
          return const ProcessingLayout(title: "Restoring note...");
        }
        //restored
        else if (state is RestoredTrashNote) {
          Timer(const Duration(seconds: 1), () {
            Navigator.pop(context, true);
          });
          return const ProcessCompleteLayout(title: "Restored");
        }
        //error while restoring
        else if (state is NoteError) {
          Timer(const Duration(seconds: 2), () {
            Navigator.pop(context, true);
          });
          return const ProcessErrorLayout();
        }
        //default layout
        return buildInitialLayout();
      },
    );
  }

  Widget buildInitialLayout() {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.primaryColorShade200,
      floatingActionButton: StyledFabButton(
          onPressed: () {
            restoreNote(context: context, id: widget.note.id);
          },
          tooltip: "Restore Note",
          iconData: Icons.restore_rounded),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: GradientBackground(
        child: SafeArea(
          child: Stack(
            children: [
              ListView(
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
                    readOnly: true,
                    cursorColor: AppColors.onPrimaryColor,
                    style: textTheme.displayMedium,
                  ),
                  Divider(
                      color: AppColors.onPrimaryColor.withOpacity(0.25),
                      height: 4),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(borderSide: BorderSide.none),
                      hintText: "Note",
                    ),
                    controller: _descriptionController,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    readOnly: true,
                    cursorColor: AppColors.onPrimaryColor,
                    style: textTheme.bodyLarge,
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text(getDate(), style: textTheme.bodyLarge),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
