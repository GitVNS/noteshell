import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteshell/interface/components/notes_screen_app_bar.dart';
import 'package:noteshell/interface/components/shared/styled_fab_button.dart';
import 'package:noteshell/interface/screens/trash_screen.dart';
import 'package:noteshell/interface/screens/view_note_screen.dart';
import 'package:noteshell/interface/theme/app_colors.dart';
import 'package:noteshell/interface/screens/create_note_screen.dart';
import 'package:noteshell/model/note_model.dart';
import 'package:noteshell/logic/bloc/note_event.dart';

import '../../logic/bloc/note_bloc.dart';
import '../../logic/bloc/note_states.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<NoteBloc>(context).add(Get());
  }

  //handle reload after coming back to this page
  void reload() {
    BlocProvider.of<NoteBloc>(context).add(Get());
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      floatingActionButton: StyledFabButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => const CreateNoteScreen()))
                .then((shouldReload) => shouldReload == true ? reload() : null);
          },
          tooltip: "Create Note",
          iconData: Icons.add_rounded),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 128),
            children: [
              NotesScreenAppBar(onTrashButtonTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(
                        builder: (context) => const TrashScreen()))
                    .then((shouldReload) =>
                        shouldReload == true ? reload() : reload());
              }),
              Divider(
                  color: AppColors.onPrimaryColor.withOpacity(0.25), height: 4),
              const SizedBox(height: 16),
              //fetching notes
              if (state is NotesFetching)
                Container(
                  height: 200,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(
                      color: AppColors.onPrimaryColor, strokeWidth: 4),
                ),
              //fetched
              if (state is NotesFetched)
                buildNotesLayout(data: state.notesData, textTheme: textTheme),
              //error while fetching
              if (state is NoteError)
                Container(
                  height: 200,
                  alignment: Alignment.center,
                  child:
                      Text("Something Went Wrong", style: textTheme.bodyLarge),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget buildNotesLayout(
      {required List<NoteModel> data, required TextTheme textTheme}) {
    return data.isEmpty
        ? Column(
            children: [
              const Image(
                  image: AssetImage("assets/images/empty_notes.png"),
                  height: 150),
              const SizedBox(height: 8),
              Text(
                "Start taking some Notes...",
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium,
              )
            ],
          ) //empty notes
        : ListView.separated(
            itemCount: data.length,
            padding: const EdgeInsets.all(0),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) =>
                              ViewNoteScreen(note: data[index])))
                      .then((shouldReload) =>
                          shouldReload == true ? reload() : null);
                },
                splashFactory: InkSparkle.splashFactory,
                splashColor: Colors.white54,
                borderRadius: BorderRadius.circular(16),
                child: Ink(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.primaryColorShade200,
                    border: Border.all(
                      color: AppColors.primaryColorShade300,
                      width: 2,
                    ),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 24,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            data[index].title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.headlineMedium,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            data[index].decription,
                            maxLines: 2,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 16),
          );
  }
}
