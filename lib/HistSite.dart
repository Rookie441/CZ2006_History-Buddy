class HistSite {
  late String _siteName, _description, _address;
  double _lat = -1, _lng = -1;

  //class constructor
  HistSite(String siteName, double lat, double lng, String description) {
    _siteName = siteName;
    _lat = lat;
    _lng = lng;
    _description = description;
  }

  String getName() {
    return _siteName;
  }

  List<double> getCoordinates() {
    return [_lat, _lng];
  }
}