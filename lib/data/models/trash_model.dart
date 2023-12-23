import 'package:cloud_firestore/cloud_firestore.dart';

class TrashModel {
  String? id;
  String? name;
  GeoPoint? location;
  num? height;
  String? sensorDistance;

  TrashModel({
    this.id,
    this.height,
    this.location,
    this.name,
    this.sensorDistance,
  });

  factory TrashModel.fromJson(Map<String, dynamic> json) => TrashModel(
        id: json['id'],
        height: json['height'],
        location: json['location'],
        name: json['name'],
        sensorDistance: json['sensor_distance'],
      );

  factory TrashModel.fromDocument(DocumentSnapshot doc) => TrashModel(
        id: doc['id'],
        name: doc['name'],
        height: doc['height'],
        location: doc['location'],
        sensorDistance: doc['sensor_distance'],
      );

  Map<String, dynamic> toJson() => ({
        "id": id,
        "name": name,
        "height": height,
        "location": location,
        "sensor_distance": sensorDistance,
      });
}
