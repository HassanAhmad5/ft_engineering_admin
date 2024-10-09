import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationTrackingScreen extends StatefulWidget {
  const LocationTrackingScreen({super.key});

  @override
  _LocationTrackingScreenState createState() => _LocationTrackingScreenState();
}

class _LocationTrackingScreenState extends State<LocationTrackingScreen> {
  GoogleMapController? _controller;
  static const LatLng _initialPosition = LatLng(12.9716, 77.5946); // Initial map position (Latitude, Longitude)
  LatLng _currentPosition = _initialPosition;

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  void _updateLocation() {
    setState(() {
      _currentPosition = const LatLng(12.9346, 77.6266); // Example of updating location
    });
    _controller?.moveCamera(CameraUpdate.newLatLng(_currentPosition));
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade200,
        title: const Text("Ft Engineering", style: TextStyle(
            fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: _initialPosition,
              zoom: 14.0,
            ),
            myLocationEnabled: true,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 0.05 * MediaQuery.of(context).size.width),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Location',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Latitude: ${_currentPosition.latitude}, Longitude: ${_currentPosition.longitude}',
                    ),
                    const SizedBox(height: 8),
                    Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          child: ElevatedButton(
                            onPressed: () async {
                              _updateLocation();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellow.shade200,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            child: isLoading
                                ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    color: Colors.yellow.shade200,
                                    height: 20,
                                    width: 20,
                                    child: const CircularProgressIndicator(color: Colors.black,)),
                                const SizedBox(width: 5,),
                                const Text('Loading',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'roboto',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ],
                            )
                                : const Text('Update Location',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'roboto',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        )
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
