import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:noteshell/model/note_model.dart';

abstract class NoteEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Create extends NoteEvent {
  final String id;
  final String title;
  final String description;
  final Timestamp createdOn;

  Create(this.id, this.title, this.description, this.createdOn);
}

class Get extends NoteEvent {
  Get();
}

class Delete extends NoteEvent {
  final String id;
  Delete(this.id);
}

class Update extends NoteEvent {
  final NoteModel noteModel;
  Update(this.noteModel);
}

class GetTrash extends NoteEvent {
  GetTrash();
}

class DeleteTrash extends NoteEvent {
  final String id;
  DeleteTrash(this.id);
}

class RestoreNote extends NoteEvent {
  final String id;
  RestoreNote(this.id);
}
