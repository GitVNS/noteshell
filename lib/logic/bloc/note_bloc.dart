import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteshell/logic/bloc/note_event.dart';
import 'package:noteshell/logic/bloc/note_states.dart';
import 'package:noteshell/logic/repositories/notes_repository.dart';
import 'package:noteshell/logic/repositories/trash_repository.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NotesRepository notesRepository;
  final TrashRepository trashRepository;
  NoteBloc({required this.notesRepository, required this.trashRepository})
      : super(InitialState()) {
    on<Create>((event, emit) async {
      emit(NoteCreating());
      try {
        await notesRepository.create(
            id: event.id,
            title: event.title,
            description: event.description,
            createdOn: event.createdOn);
        emit(NoteCreated());
      } catch (e) {
        emit(NoteError(e.toString()));
      }
    });

    on<Get>((event, emit) async {
      emit(NotesFetching());
      try {
        final data = await notesRepository.get();
        emit(NotesFetched(data));
      } catch (e) {
        emit(NoteError(e.toString()));
      }
    });

    on<Delete>((event, emit) async {
      emit(NoteDeleting());
      try {
        await notesRepository.delete(event.id);
        emit(NoteDeleted());
      } catch (e) {
        emit(NoteError(e.toString()));
      }
    });

    on<Update>((event, emit) async {
      emit(NoteUpdating());
      try {
        await notesRepository.update(event.noteModel);
        emit(NoteUpdated());
      } catch (e) {
        emit(NoteError(e.toString()));
      }
    });

    on<GetTrash>((event, emit) async {
      emit(FetchingTrashNotes());
      try {
        final trashData = await trashRepository.get();
        emit(FetchedTrashNotes(trashData));
      } catch (e) {
        emit(NoteError(e.toString()));
      }
    });

    on<DeleteTrash>((event, emit) async {
      emit(DeletingTrashNote());
      try {
        await trashRepository.delete(event.id);
        emit(DeletedTrashNote());
      } catch (e) {
        emit(NoteError(e.toString()));
      }
    });

    on<RestoreNote>((event, emit) async {
      emit(RestoringTrashNote());
      try {
        await trashRepository.restore(event.id);
        emit(RestoredTrashNote());
      } catch (e) {
        emit(NoteError(e.toString()));
      }
    });
  }
}
