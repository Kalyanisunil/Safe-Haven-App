import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<String> getLocationLink() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    
    return "https://maps.google.com/?q=${position.latitude},${position.longitude}";
  }
}
