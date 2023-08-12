import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:noteshell/logic/repositories/notes_repository.dart';
import '../../model/note_model.dart';

class TrashRepository {
  final _trashFirestore = FirebaseFirestore.instance
      .collection("users")
      .doc("test")
      .collection("trash");

  Future<void> add({
    required String id,
    required String title,
    required String description,
    required Timestamp createdOn,
  }) async {
    try {
      await _trashFirestore.doc(id).set({
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
          await _trashFirestore.orderBy("createdOn", descending: true).get();
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
      await _trashFirestore.doc(id).delete();
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Error: ${e.message}");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> restore(String id) async {
    try {
      final response = await _trashFirestore.doc(id).get();
      NoteModel note = NoteModel.fromJson(response.data()!);
      await NotesRepository().create(
          id: note.id,
          title: note.title,
          description: note.decription,
          createdOn: note.createdOn);
      await _trashFirestore.doc(id).delete();
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Error: ${e.message}");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
