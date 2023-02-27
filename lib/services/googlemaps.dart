import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:on_the_go_reminder/services/notifications.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController; //controller for Google map
  PolylinePoints polylinePoints = PolylinePoints();

  String googleAPiKey = "AIzaSyAa6z7r-Ne12mp0mURJj9Hlfw_tblfrHf0";

  Set<Marker> markers = Set(); //markers for google map
  Map<PolylineId, Polyline> polylines = {}; //poly-lines to show direction

  LatLng startLocation =
      const LatLng(41.11037902717075, 20.806958533569365); //my home location
  LatLng endLocation = const LatLng(
      41.11086111902888, 20.807275914058135); // beauty center location

  LocalNotificationsService notificationsService = LocalNotificationsService();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Timer? timer;

  void _checkLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double distanceInMeters = await Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        endLocation.latitude,
        endLocation.longitude);
    if (distanceInMeters < 100) {
      notificationsService.showNotification(
          id: 1,
          title: 'Entered Target Location',
          body: 'You have tasks to complete at this location!');
    }
  }

  @override
  void initState() {
    markers.add(
      Marker(
        markerId: MarkerId(startLocation.toString()),
        position: startLocation,
        infoWindow: const InfoWindow(
          title: 'Home',
          snippet: 'Start Marker',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
    markers.add(
      Marker(
        markerId: MarkerId(endLocation.toString()),
        position: endLocation,
        infoWindow: const InfoWindow(
          title: 'Beauty Center',
          snippet: 'Destination Marker',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );

    getDirections(); //fetch direction poly-lines from Google API

    super.initState();
    Geolocator.getPositionStream().listen((position) {
      _checkLocation();
    });
  }

  getDirections() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(startLocation.latitude, startLocation.longitude),
      PointLatLng(endLocation.latitude, endLocation.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.deepPurpleAccent,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Route Directions in Google Map"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: GoogleMap(
        zoomGesturesEnabled: true,
        initialCameraPosition: CameraPosition(
          target: startLocation,
          zoom: 16.0,
        ),
        markers: markers,
        polylines: Set<Polyline>.of(polylines.values),
        mapType: MapType.normal,
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
          });
        },
      ),
    );
  }
}
