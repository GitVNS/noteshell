import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  final String id;
  final String title;
  final String decription;
  final Timestamp createdOn;

  NoteModel(
      {required this.id,
      required this.title,
      required this.decription,
      required this.createdOn});

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'],
      title: json['title'],
      decription: json['description'],
      createdOn: json['createdOn'],
    );
  }
}
