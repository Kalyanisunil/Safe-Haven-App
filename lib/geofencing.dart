import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SafeZoneScreen extends StatefulWidget {
  @override
  _SafeZoneScreenState createState() => _SafeZoneScreenState();
}

class _SafeZoneScreenState extends State<SafeZoneScreen> {
  List<Map<String, double>> safeZones = [];

  @override
  void initState() {
    super.initState();
    _loadSafeZones();
  }

  Future<void> _loadSafeZones() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedLocations = prefs.getStringList("safe_zones");

    if (savedLocations != null) {
      setState(() {
        safeZones = savedLocations.map((location) {
          List<String> parts = location.split(",");
          return {
            "lat": double.parse(parts[0]),
            "lng": double.parse(parts[1]),
          };
        }).toList();
      });
    }
  }

  Future<void> _addSafeZone() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final prefs = await SharedPreferences.getInstance();

    safeZones.add({"lat": position.latitude, "lng": position.longitude});
    List<String> safeZonesStr = safeZones.map((zone) => "${zone['lat']},${zone['lng']}").toList();

    prefs.setStringList("safe_zones", safeZonesStr);

    setState(() {});
  }

  Future<void> _clearSafeZones() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("safe_zones");
    setState(() {
      safeZones.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage Safe Zones")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: safeZones.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("Lat: ${safeZones[index]['lat']}, Lng: ${safeZones[index]['lng']}"),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(onPressed: _addSafeZone, child: Text("Add Safe Zone")),
              ElevatedButton(onPressed: _clearSafeZones, child: Text("Clear All")),
            ],
          ),
        ],
      ),
    );
  }
}
