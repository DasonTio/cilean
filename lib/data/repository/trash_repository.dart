import 'package:cilean/data/models/trash_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TrashRepository {
  final _firestore = FirebaseFirestore.instance.collection('trashes');

  Stream<TrashModel> fetchSingleTrash(String id) {
    return _firestore
        .doc(id)
        .snapshots()
        .map((doc) => TrashModel.fromDocument(doc));
  }

  Stream<List<TrashModel>> fetchAllTrashes() {
    return _firestore.snapshots().map((snapshot) {
      print(snapshot);
      return snapshot.docs.map((doc) {
        print(TrashModel.fromDocument(doc).id);
        return TrashModel.fromDocument(doc);
      }).toList();
    });
  }
}
