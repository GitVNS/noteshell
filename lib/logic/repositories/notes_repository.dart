import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:noteshell/logic/repositories/trash_repository.dart';
import 'package:noteshell/model/note_model.dart';

class NotesRepository {
  final _notesFirestore = FirebaseFirestore.instance
      .collection("users")
      .doc("test")
      .collection("notes");

  Future<void> create({
    required String id,
    required String title,
    required String description,
    required Timestamp createdOn,
  }) async {
    try {
      await _notesFirestore.doc(id).set({
        "id": id,
        "title": title,
        "description": description,
        "createdOn": createdOn,
      });
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Error: ${e.message}");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<NoteModel>> get() async {
    List<NoteModel> notes = [];
    try {
      final response =
          await _notesFirestore.orderBy("createdOn", descending: true).get();
      for (var element in response.docs) {
        notes.add(NoteModel.fromJson(element.data()));
      }
      return notes;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Error: ${e.message}");
      }
      return notes;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> delete(String id) async {
    try {
      final response = await _notesFirestore.doc(id).get();
      NoteModel note = NoteModel.fromJson(response.data()!);
      await TrashRepository().add(
          id: note.id,
          title: note.title,
          description: note.decription,
          createdOn: note.createdOn);
      await _notesFirestore.doc(id).delete();
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Error: ${e.message}");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> update(NoteModel noteModel) async {
    try {
      await _notesFirestore.doc(noteModel.id).update(
          {"title": noteModel.title, "description": noteModel.decription});
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Error: ${e.message}");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
