import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:history_buddy/HistSite.dart';


class StepTracking extends StatefulWidget {
  const StepTracking({Key? key,required this.histsite}) : super(key: key);
  final HistSite histsite;
  @override
  _StepTrackingState createState() => _StepTrackingState();
}

class _StepTrackingState extends State<StepTracking> {

    late LatLng _center = LatLng(widget.histsite.getCoordinates()[1],
        widget.histsite.getCoordinates()[0]);
    late GoogleMapController mapController;

    Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
    void _onMapCreated(GoogleMapController controller) {
      mapController = controller;

      final marker = Marker(
        markerId: MarkerId(widget.histsite.getName()),
        position: _center,
        infoWindow: InfoWindow(
          title: widget.histsite.getName(),
        ),

      );

      setState(() {
        markers[MarkerId(widget.histsite.getName())] = marker;
      });

    }


    @override
    Widget build(BuildContext context) {
      Set<Circle> myCircles = {Circle(
        circleId: CircleId('1'),
        center:_center,
        radius: 500,
        fillColor: Colors.blue.shade100.withOpacity(0.7),
        strokeColor:  Colors.blue.shade100.withOpacity(0.3),
      )};

      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text(widget.histsite.getName()),
            backgroundColor: Colors.teal[200],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: (){
              //add pedometer later
            },
            label : const Text('Start Counting!'),
            backgroundColor: Colors.teal[200],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          body: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 15.0,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: markers.values.toSet(),
            circles: myCircles,
          ),
        ),
      );
    }
  }


