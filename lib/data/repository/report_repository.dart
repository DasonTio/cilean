import 'package:cilean/data/models/report_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportRepository {
  final _firestore = FirebaseFirestore.instance.collection('reports');

  Stream<List<ReportModel>> fetchSingleUserReportsCurrentMonth(String email) {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    return _firestore.doc(email).snapshots().map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      List<ReportModel> result = [];
      data.forEach((key, value) {
        DateTime reportedAt = (value['reported_at'] as Timestamp).toDate();
        if (reportedAt.isAfter(firstDayOfMonth) &&
            reportedAt.isBefore(lastDayOfMonth)) {
          result.add(ReportModel.fromJson(value));
        }
      });
      return result;
    });
  }

  Stream<List<ReportModel>> fetchSingleUserReports(String email) {
    return _firestore.doc(email).snapshots().map((snapshot) {
      Map<String, dynamic> data = snapshot.data()!;
      List<ReportModel> reports = [];
      data.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          reports.add(ReportModel.fromJson(value));
        }
      });
      return reports;
    });
  }

  Stream<List<List<ReportModel>>> fetchAllReports() {
    return _firestore.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        List<ReportModel> reports = [];
        data.forEach((key, value) {
          if (value is Map<String, dynamic>) {
            reports.add(ReportModel.fromJson(value));
          }
        });
        return reports;
      }).toList();
    });
  }

  Future<void> create({
    required ReportModel report,
    required String email,
  }) async {
    await _firestore.doc(email).set(report.toJson());
  }

  Future<void> update({
    required ReportModel report,
    required String email,
  }) async {
    await _firestore.doc(email).update(report.toJson());
  }

  Future<void> delete(String email) async {
    await _firestore.doc(email).delete();
  }
}
