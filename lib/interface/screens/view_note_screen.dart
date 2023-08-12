import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteshell/interface/components/shared/gradient_background.dart';
import 'package:noteshell/interface/components/shared/process_complete_layout.dart';
import 'package:noteshell/interface/components/shared/processing_layout.dart';
import 'package:noteshell/interface/components/shared/styled_fab_button.dart';
import 'package:noteshell/model/note_model.dart';
import 'package:noteshell/logic/bloc/note_bloc.dart';
import 'package:noteshell/logic/bloc/note_event.dart';

import '../../logic/bloc/note_states.dart';
import '../components/shared/process_error_layout.dart';
import '../theme/app_colors.dart';

class ViewNoteScreen extends StatefulWidget {
  const ViewNoteScreen({super.key, required this.note});

  final NoteModel note;

  @override
  State<ViewNoteScreen> createState() => _ViewNoteScreenState();
}

class _ViewNoteScreenState extends State<ViewNoteScreen> {
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

  //handle deletion of note
  void deleteNote({required BuildContext context, required String id}) {
    BlocProvider.of<NoteBloc>(context).add(Delete(id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteBloc, NoteState>(builder: (context, state) {
      //deleting note
      if (state is NoteDeleting) {
        return const ProcessingLayout(title: "Deleting note...");
      }
      //deleted
      else if (state is NoteDeleted) {
        Timer(const Duration(seconds: 1), () {
          Navigator.pop(context, true);
        });
        return const ProcessCompleteLayout(title: "Moved to trash");
      }
      //updating note changes
      else if (state is NoteUpdating) {
        return const ProcessingLayout(title: "Updating changes...");
      }
      //updated
      else if (state is NoteUpdated) {
        Timer(const Duration(seconds: 1), () {
          Navigator.pop(context, true);
        });
        return const ProcessCompleteLayout(title: "Updated");
      }
      //error
      else if (state is NoteError) {
        Timer(const Duration(seconds: 2), () {
          Navigator.pop(context, true);
        });
        return const ProcessErrorLayout();
      }
      return buildInitialLayout(context: context);
    });
  }

  Widget buildInitialLayout({required BuildContext context}) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return WillPopScope(
      //for checking if any changes have been made to the note
      onWillPop: () async {
        if (_titleController.text != widget.note.title ||
            _descriptionController.text != widget.note.decription) {
          if (_titleController.text.isEmpty ||
              _descriptionController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Please fill the both fields"),
              duration: Duration(seconds: 1),
            ));
            return false;
          }
          //handle updation
          BlocProvider.of<NoteBloc>(context).add(Update(NoteModel(
              id: widget.note.id,
              title: _titleController.text,
              decription: _descriptionController.text,
              createdOn: widget.note.createdOn)));
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.primaryColorShade200,
        floatingActionButton: StyledFabButton(
            onPressed: () {
              deleteNote(context: context, id: widget.note.id);
            },
            tooltip: "Delete Note",
            iconData: Icons.delete_rounded),
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
                        border:
                            UnderlineInputBorder(borderSide: BorderSide.none),
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
                        color: AppColors.onPrimaryColor.withOpacity(0.25),
                        height: 4),
                    TextFormField(
                      decoration: const InputDecoration(
                        border:
                            UnderlineInputBorder(borderSide: BorderSide.none),
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
      ),
    );
  }
}
