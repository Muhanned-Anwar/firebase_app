import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vp7_firebase_app/models/note.dart';

class FbFireStoreController {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<bool> create({required Note note}) async {
    return await _fireStore
        .collection('Notes')
        .add(note.tpMap())
        .then((value) => true)
        .catchError((error) => false);
  }

  Stream<QuerySnapshot> read() async* {
    yield* _fireStore.collection('Notes').snapshots();
  }

  Future<bool> update({required Note note}) async {
    return _fireStore
        .collection('Notes')
        .doc(note.id)
        .update(note.tpMap())
        .then((value) => true)
        .catchError((error) => false);
  }

  Future<bool> delete({required String path}) async {
    return _fireStore
        .collection('Notes')
        .doc(path)
        .delete()
        .then((value) => true)
        .catchError((error) => false);
  }
}
