import 'dart:math';

import 'package:cilean/constants/config/size_config.dart';
import 'package:cilean/constants/constants.dart';
import 'package:cilean/data/repository/location_repository.dart';
import 'package:cilean/features/navigation/interfaces/components/c_location_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class HomeMapLayout extends StatefulWidget {
  const HomeMapLayout({Key? key}) : super(key: key);

  @override
  _HomeMapLayoutState createState() => _HomeMapLayoutState();
}

class _HomeMapLayoutState extends State<HomeMapLayout> {
  final LocationRepository _repository = LocationRepository();
  late Future<Position?> _currentPosition;
  List<LatLng> _destinationPoints = [];
  List<LatLng> _routePoints = [];

  @override
  void initState() {
    super.initState();
    Stream.periodic(Duration(seconds: 2)).asyncMap(
      (_) => FlutterCompass.events!.first.asStream().listen(
        (CompassEvent event) {
          print(event.accuracy);
        },
      ),
    );
    _currentPosition = getUserLongitudeLatitue();
    for (int i = 0; i < 5; i++)
      _destinationPoints.add(
        LatLng(-6.2658925 + Random().nextInt(9) / 1000,
            106.6047361 + Random().nextInt(9) / 1000),
      );
  }

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    if (permission == LocationPermission.deniedForever) return false;
    return true;
  }

  Future<Position?> getUserLongitudeLatitue() async {
    bool hasPermission = await handleLocationPermission();
    if (!hasPermission) return null;
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return Future(() => position);
  }

  Future<void> getPlaceDirection(LatLng user, LatLng destination) async {
    _routePoints = [];
    final List<LatLng> res = await _repository.getRoutePaths(
      user: user,
      destination: destination,
    );
    setState(() {
      _routePoints.addAll(res);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig(context);
    return Container(
      height: SizeConfig.blockHeight * 30,
      margin: EdgeInsets.symmetric(vertical: SizeConfig.blockHeight * 2),
      padding: EdgeInsets.all(SizeConfig.blockWidth),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        border: Border.all(
          width: 2,
          color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.08),
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: FutureBuilder(
        future: _currentPosition,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return GestureDetector(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(
                      snapshot.data!.latitude,
                      snapshot.data!.longitude,
                    ),
                    initialZoom: 17,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tiles.stadiamaps.com/tiles/alidade_smooth/{z}/{x}/{y}@2x.png?api_key=${API_KEY}',
                      userAgentPackageName: 'com.example.app',
                    ),
                    CLocationMarker(
                      latitude: snapshot.data!.latitude,
                      longitude: snapshot.data!.longitude,
                      model: LocationModel.car,
                      onTap: () {},
                    ),
                    ..._destinationPoints.map(
                      (e) => CLocationMarker(
                        latitude: e.latitude,
                        longitude: e.longitude,
                        model: LocationModel.car,
                        onTap: () {
                          getPlaceDirection(
                            LatLng(
                              snapshot.data!.latitude,
                              snapshot.data!.longitude,
                            ),
                            LatLng(
                              e.latitude,
                              e.longitude,
                            ),
                          );
                        },
                      ),
                    ),
                    PolylineLayer(
                      polylineCulling: false,
                      polylines: [
                        Polyline(
                          points: _routePoints,
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondary
                              .withOpacity(0.6),
                          strokeWidth: 6,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
