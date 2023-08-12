import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteshell/interface/screens/view_trash_note_screen.dart';
import 'package:noteshell/logic/bloc/note_event.dart';

import '../../logic/bloc/note_bloc.dart';
import '../../logic/bloc/note_states.dart';
import '../../model/note_model.dart';
import '../components/shared/process_complete_layout.dart';
import '../components/shared/processing_layout.dart';
import '../theme/app_colors.dart';

class TrashScreen extends StatefulWidget {
  const TrashScreen({super.key});

  @override
  State<TrashScreen> createState() => _TrashScreenState();
}

class _TrashScreenState extends State<TrashScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<NoteBloc>(context).add(GetTrash());
  }

  //handle reload after deletye operation
  void reload() {
    BlocProvider.of<NoteBloc>(context).add(GetTrash());
  }

  //handle deletion of note
  void deleteNote({required BuildContext context, required String id}) {
    BlocProvider.of<NoteBloc>(context).add(DeleteTrash(id));
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        title: Text(
          "Trash",
          style: textTheme.headlineMedium,
        ),
        backgroundColor: AppColors.primaryColorShade200,
      ),
      body: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          //fetching trash notes
          if (state is FetchingTrashNotes) {
            return const SizedBox.expand(
              child: Center(
                child: CircularProgressIndicator(
                    color: AppColors.onPrimaryColor, strokeWidth: 4),
              ),
            );
          }
          //fetched
          else if (state is FetchedTrashNotes) {
            return buildNotesLayout(
                data: state.trashNotesData, textTheme: textTheme);
          }
          //deleting note
          if (state is DeletingTrashNote) {
            return const ProcessingLayout(
                title: "Deleting note permanently...");
          }
          //deleted
          else if (state is DeletedTrashNote) {
            reload();
            return const ProcessCompleteLayout(title: "Deleted");
          }
          //default error
          return SizedBox.expand(
            child: Center(
              child: Text("Something Went Wrong", style: textTheme.bodyLarge),
            ),
          );
        },
      ),
    );
  }

  Widget buildNotesLayout(
      {required List<NoteModel> data, required TextTheme textTheme}) {
    return data.isEmpty
        ? SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Image(
                    image: AssetImage("assets/images/empty_trash.png"),
                    height: 150),
                const SizedBox(height: 8),
                Text(
                  "Nothing here...",
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium,
                )
              ],
            ),
          ) //empty notes
        : SafeArea(
            child: ListView.separated(
              itemCount: data.length,
              padding: const EdgeInsets.all(16),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Material(
                      elevation: 0.1,
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) =>
                                      ViewTrashNote(note: data[index])))
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
                      ),
                    ),
                    Align(
                      heightFactor: 0.5,
                      child: InkWell(
                        onTap: () {
                          deleteNote(context: context, id: data[index].id);
                        },
                        splashFactory: InkSparkle.splashFactory,
                        splashColor: Colors.white54,
                        borderRadius: BorderRadius.circular(16),
                        child: Ink(
                          height: 70,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: AppColors.onPrimaryColor,
                          ),
                          child: const Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              height: 50,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.delete_forever,
                                        color: AppColors.primaryColor,
                                        size: 24),
                                    SizedBox(width: 8),
                                    Text(
                                      "Delete",
                                      style: TextStyle(
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 32),
            ),
          );
  }
}
