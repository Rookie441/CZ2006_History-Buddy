import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'HistSite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geojson/geojson.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

// parse data
// need to display the data ??
class SitesMgr {

//  List<LatLng> polylineCoordinates = [];
  // PolylinePoints polylinePoints = PolylinePoints();

  // constructor
  SitesMgr();

  readSiteLocations() async {
    String s = await rootBundle.loadString(
        "assets/historic-sites-geojson.geojson");
    final data = await json.decode(s);

    List<String> histnames = [];
    List<LatLng> coords = [];
    List<String> desc = [];
    for (int i = 0; i < data["features"].length; i++) {
      String siteName = data["features"][i]["properties"]["Name"];
      histnames.add(data["features"][i]["properties"]["Name"]);

      coords.add(LatLng(data["features"][i]["geometry"]["coordinates"][0],
          data["features"][i]["geometry"]["coordinates"][1]));
      desc.add(data["features"][i]["properties"]["Description"]);
      HistSite histsite = HistSite(
          siteName, data["features"][i]["geometry"]["coordinates"][0],
          data["features"][i]["geometry"]["coordinates"][1],
          data["features"][i]["properties"]["Description"]);
    }
  }
}