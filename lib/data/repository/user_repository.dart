import 'package:cilean/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final _firestore = FirebaseFirestore.instance.collection('user');

  Stream<UserModel> fetchSingleUser(String email) {
    return _firestore
        .doc(email)
        .snapshots()
        .map((doc) => UserModel.fromDocument(doc));
  }

  Stream<List<UserModel>> fetchAllUsers() {
    return _firestore.snapshots().map(
          (snapshot) =>
              snapshot.docs.map((doc) => UserModel.fromDocument(doc)).toList(),
        );
  }

  Future<void> create(UserModel user) async {
    await _firestore.doc(user.email).set(user.toJson());
  }

  Future<void> update(UserModel user) async {
    await _firestore.doc(user.email).update(user.toJson());
  }

  Future<void> delete(String email) async {
    await _firestore.doc(email).delete();
  }
}
