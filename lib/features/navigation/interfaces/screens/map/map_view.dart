import 'dart:math';

import 'package:cilean/constants/config/size_config.dart';
import 'package:cilean/constants/constants.dart';
import 'package:cilean/data/models/trash_model.dart';
import 'package:cilean/data/repository/location_repository.dart';
import 'package:cilean/data/repository/trash_repository.dart';
import 'package:cilean/features/navigation/interfaces/components/c_location_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final LocationRepository _repository = LocationRepository();
  final TrashRepository _trashRepository = TrashRepository();
  late Future<Position?> _currentPosition;
  List<LatLng> _destinationPoints = [];
  List<LatLng> _routePoints = [];
  Stream<TrashModel>? _trashModel = null;

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
    print(position);

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

  Future<void> getTrashDetail(String id) async {
    setState(() {
      _trashModel = _trashRepository.fetchSingleTrash(id);
    });
  }

  Color getStatusColor(int sensorDistance, num height) {
    final level = height - sensorDistance;
    if (level > height * (2 / 3) || level >= height) {
      return Colors.redAccent;
    }
    if (level > height * (1 / 3)) {
      return Colors.orangeAccent;
    }
    return Colors.greenAccent;
  }

  void removeTrashDetail() {
    setState(() {
      _trashModel = null;
      _routePoints = [];
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig(context);
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => Container(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
              minHeight: constraints.maxHeight,
            ),
            child: Stack(
              children: [
                FutureBuilder(
                    future: _currentPosition,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return StreamBuilder<List<TrashModel>>(
                          stream: _trashRepository.fetchAllTrashes(),
                          builder: (context, trashSnapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                trashSnapshot.hasData) {
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
                                      ...trashSnapshot.data!.map((e) {
                                        return CLocationMarker(
                                            latitude: e.location!.latitude,
                                            longitude: e.location!.longitude,
                                            model: LocationModel.trash,
                                            color: getStatusColor(
                                              int.parse(e.sensorDistance!),
                                              e.height!,
                                            ),
                                            onTap: () {
                                              getPlaceDirection(
                                                LatLng(
                                                  snapshot.data!.latitude,
                                                  snapshot.data!.longitude,
                                                ),
                                                LatLng(
                                                  e.location!.latitude,
                                                  e.location!.longitude,
                                                ),
                                              );
                                              getTrashDetail(e.id!);
                                            });
                                      }),
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
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
                AnimatedPositioned(
                  bottom:
                      _trashModel != null ? 0 : SizeConfig.blockHeight * -40,
                  left: 0,
                  right: 0,
                  duration: Duration(milliseconds: 600),
                  curve: Curves.easeInOut,
                  child: StreamBuilder<TrashModel>(
                    stream: _trashModel,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final binHeight = snapshot.data!.height!;
                        final sensorDistance =
                            int.parse(snapshot.data!.sensorDistance!);

                        var sensorFin = sensorDistance;
                        if (sensorDistance <= 0) {
                          sensorFin = 0;
                        } else if (sensorDistance > sensorFin) {
                          sensorFin = int.parse(binHeight.toString());
                        }
                        var percentage =
                            ((binHeight - sensorFin) / binHeight * 100);
                        return GestureDetector(
                          onPanDown: (details) => removeTrashDetail(),
                          child: Container(
                            height: SizeConfig.blockHeight * 45,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.blockHeight,
                              horizontal: SizeConfig.blockWidth * 6,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: SizeConfig.blockHeight * 0.5,
                                  width: SizeConfig.blockWidth * 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary
                                        .withOpacity(0.7),
                                  ),
                                ),
                                SizedBox(height: SizeConfig.blockHeight * 1.5),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: SizeConfig.blockHeight * 5),
                                  child: Row(
                                    children: [
                                      Container(
                                        child: Stack(
                                          children: [
                                            Container(
                                              height:
                                                  SizeConfig.blockWidth * 35,
                                              width: SizeConfig.blockWidth * 35,
                                              decoration: BoxDecoration(
                                                color: getStatusColor(
                                                        sensorDistance,
                                                        binHeight)
                                                    .withOpacity(0.4),
                                                shape: BoxShape.circle,
                                              ),
                                              child: CircularProgressIndicator(
                                                backgroundColor: getStatusColor(
                                                  sensorDistance,
                                                  binHeight,
                                                ),
                                                value: 0,
                                              ),
                                            ),
                                            Positioned(
                                              child: SizedBox(
                                                height:
                                                    SizeConfig.blockWidth * 35,
                                                width:
                                                    SizeConfig.blockWidth * 35,
                                                child: Center(
                                                  child: Text(
                                                    "${(percentage).toStringAsFixed(0)} %",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall!
                                                        .copyWith(
                                                          color: getStatusColor(
                                                            sensorDistance,
                                                            binHeight,
                                                          ),
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                          width: SizeConfig.blockWidth * 5),
                                      Column(
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                              children: [
                                                TextSpan(
                                                  text: '\n',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!,
                                                ),
                                                TextSpan(
                                                  text:
                                                      '${snapshot.data!.name!}\n\n',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                                TextSpan(
                                                  text: 'Sensor Distance: ',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      '${snapshot.data!.sensorDistance!} cm\n',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                                TextSpan(
                                                  text: 'Bin Height: ',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      '${snapshot.data!.height!} cm\n',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
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
                ),
              ],
            )),
      ),
    );
  }
}
