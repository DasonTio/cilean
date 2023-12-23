import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

enum LocationModel {
  car,
  person,
  trash,
}

class CLocationMarker extends StatelessWidget {
  const CLocationMarker({
    Key? key,
    required this.latitude,
    required this.longitude,
    this.model = LocationModel.car,
    this.color,
    required this.onTap,
  }) : super(key: key);

  final double latitude;
  final double longitude;
  final LocationModel model;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return MarkerLayer(
      markers: [
        Marker(
          point: LatLng(latitude, longitude),
          width: 20,
          height: 20,
          child: GestureDetector(
            onTap: onTap,
            child: Builder(builder: (context) {
              switch (model) {
                case LocationModel.person:
                  return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 0,
                          spreadRadius: 10,
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondary
                              .withOpacity(0.2),
                        ),
                      ],
                      shape: BoxShape.circle,
                    ),
                  );
                case LocationModel.car:
                  return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSecondary,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 0,
                          spreadRadius: 10,
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondary
                              .withOpacity(0.2),
                        ),
                      ],
                      shape: BoxShape.circle,
                    ),
                  );
                case LocationModel.trash:
                  return Container(
                    decoration: BoxDecoration(
                      color: color,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 0,
                          spreadRadius: 10,
                          color: color!.withOpacity(0.2),
                        ),
                      ],
                      shape: BoxShape.circle,
                    ),
                  );
                default:
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 20,
                          spreadRadius: 10,
                          color: Colors.yellow.withOpacity(0.4),
                        ),
                      ],
                      shape: BoxShape.circle,
                    ),
                  );
              }
            }),
          ),
        ),
      ],
    );
  }
}
