import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  bool verified;
  Timestamp reportedAt;
  GeoPoint location;

  ReportModel({
    required this.verified,
    required this.reportedAt,
    required this.location,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
        verified: json['verified'],
        reportedAt: json['reported_at'],
        location: json['location'],
      );

  factory ReportModel.fromDocument(DocumentSnapshot doc) => ReportModel(
        verified: doc['verified'],
        reportedAt: doc['reported_at'],
        location: doc['location'],
      );

  Map<String, dynamic> toJson() => ({
        "${location!.latitude}${location!.longitude}": {
          "verified": verified,
          "reported_at": reportedAt,
          "location": location,
        },
      });
}
