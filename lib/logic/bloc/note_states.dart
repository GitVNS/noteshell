import 'package:equatable/equatable.dart';
import 'package:noteshell/model/note_model.dart';

abstract class NoteState extends Equatable {}

class InitialState extends NoteState {
  @override
  List<Object?> get props => [];
}

class NoteCreating extends NoteState {
  @override
  List<Object?> get props => [];
}

class NoteCreated extends NoteState {
  @override
  List<Object?> get props => [];
}

class NotesFetching extends NoteState {
  @override
  List<Object?> get props => [];
}

class NotesFetched extends NoteState {
  final List<NoteModel> notesData;
  NotesFetched(this.notesData);
  @override
  List<Object?> get props => [];
}

class NoteDeleting extends NoteState {
  @override
  List<Object?> get props => [];
}

class NoteDeleted extends NoteState {
  @override
  List<Object?> get props => [];
}

class NoteUpdating extends NoteState {
  @override
  List<Object?> get props => [];
}

class NoteUpdated extends NoteState {
  @override
  List<Object?> get props => [];
}

class NoteError extends NoteState {
  final String error;
  NoteError(this.error);

  @override
  List<Object?> get props => [error];
}

///Trash States
class FetchingTrashNotes extends NoteState {
  @override
  List<Object?> get props => [];
}

class FetchedTrashNotes extends NoteState {
  final List<NoteModel> trashNotesData;
  FetchedTrashNotes(this.trashNotesData);
  @override
  List<Object?> get props => [];
}

class DeletingTrashNote extends NoteState {
  @override
  List<Object?> get props => [];
}

class DeletedTrashNote extends NoteState {
  @override
  List<Object?> get props => [];
}

class RestoringTrashNote extends NoteState {
  @override
  List<Object?> get props => [];
}

class RestoredTrashNote extends NoteState {
  @override
  List<Object?> get props => [];
}
