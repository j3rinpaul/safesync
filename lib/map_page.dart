// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
//import 'package:flutter/widgets.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:safe/analysis_page.dart';
import 'package:safe/profile_page.dart';

class LiveMap extends StatefulWidget {
  @override
  _LiveMapState createState() => _LiveMapState();
}

class _LiveMapState extends State<LiveMap> {
  LatLng _currentLocation = LatLng(0, 0);
  MapController _mapController = MapController();

  void _updateLocation(double latitude, double longitude) {
    setState(() {
      _currentLocation = LatLng(latitude, longitude);
    });
    _mapController.move(_currentLocation, 15.0,offset: Offset(10, 10));
    print('Location updated - Latitude: $latitude, Longitude: $longitude');
  }



 Future <void> _fetchLocation() async {
    try {
      final response = await http.get(Uri.parse(
          'https://accident-backend-qjlv.onrender.com/last_location'));
      print(response.statusCode);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final latitude = data['latitude'];
        final longitude = data['longitude'];
        _updateLocation(double.parse(latitude),double.parse(longitude));
      } else {
        throw Exception('Failed to fetch location: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that occur during the HTTP request
      print('Error fetching location: $e');
      // Optionally, you can rethrow the exception if you want to propagate it
      // throw e;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchLocation();
    Timer.periodic(Duration(seconds: 5), (timer) {
      _fetchLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Live Tracking',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.purple,
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(child: content()),
            Container(
              height: 120,
              // width: 120,
              //color: const Color.fromARGB(255, 219, 213, 213),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AnalysisPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple),
                      child: const Center(
                        child: Text(
                          'Analysis',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to Profile pager
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple),
                      child: const Center(
                        child: Text(
                          'Profile',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget content() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _currentLocation,
        initialZoom: 15.0,
        keepAlive: true,
        interactionOptions: InteractionOptions(
          enableMultiFingerGestureRace: true,
          enableScrollWheel: true,
          pinchZoomThreshold: 15.0,
          rotationThreshold: 20.0
          
        ),
         
      ),
      children: [
        //openStreetMapTileLayer,
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          // urlTemplate: "http://mt0.google.com/vt/lyrs=y&hl=en&x={x}&y={y}&z={z}&s=Ga.png",
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 40.0,
              height: 40.0,
              point: _currentLocation,
              //builder: (ctx) => Container(
              child: Icon(Icons.location_on, color: Colors.red),
              //),
            ),
          ],
        ),
      ],
    );
  }
}
