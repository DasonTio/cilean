import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class LocationRepository {
  LocationRepository();

  Future<List<LatLng>> getRoutePaths({
    String profile = 'driving',
    required LatLng user,
    required LatLng destination,
  }) async {
    String coordinates =
        "${user.longitude},${user.latitude};${destination.longitude},${destination.latitude}";
    Uri url = Uri.parse(
        "http://router.project-osrm.org/route/v1/$profile/$coordinates?steps=true&annotations=true&geometries=geojson");

    http.Response response = await http.get(url);
    dynamic routes =
        jsonDecode(response.body)['routes'][0]['geometry']['coordinates'];
    List<LatLng> tempRoutes = [];
    for (int i = 0; i < routes.length; i++) {
      String route = routes[i].toString();
      route = route.replaceAll('[', '');
      route = route.replaceAll(']', '');

      final [long, lat] = route.split(',');
      tempRoutes.add(LatLng(double.parse(lat), double.parse(long)));
    }

    return tempRoutes;
  }
}
