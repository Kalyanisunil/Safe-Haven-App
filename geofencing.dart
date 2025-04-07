// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:safehaven/geofencing_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SafeZoneScreen extends StatefulWidget {
//   @override
//   _SafeZoneScreenState createState() => _SafeZoneScreenState();
// }

// class _SafeZoneScreenState extends State<SafeZoneScreen> {
//   List<Map<String, double>> safeZones = [];
// late GeofenceService geofenceService;
//   @override
//   void initState() {
//     super.initState();
//     geofenceService = GeofenceService();
//     _loadSafeZones();
    
//   }

//   Future<void> _loadSafeZones() async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String>? savedLocations = prefs.getStringList("safe_zones");

//     if (savedLocations != null) {
//       setState(() {
//         safeZones = savedLocations.map((location) {
//           List<String> parts = location.split(",");
//           return {
//             "lat": double.parse(parts[0]),
//             "lng": double.parse(parts[1]),
//           };
//         }).toList();
//       });
//     }
//   }

//   Future<void> _addSafeZone() async {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     final prefs = await SharedPreferences.getInstance();

//     safeZones.add({"lat": position.latitude, "lng": position.longitude});
//     List<String> safeZonesStr =
//         safeZones.map((zone) => "${zone['lat']},${zone['lng']}").toList();

//     prefs.setStringList("safe_zones", safeZonesStr);

//     setState(() {});
//   }

//   Future<void> _clearSafeZones() async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.remove("safe_zones");
//     setState(() {
//       safeZones.clear();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Manage Safe Zones")),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: safeZones.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(
//                       "Lat: ${safeZones[index]['lat']}, Lng: ${safeZones[index]['lng']}"),
//                 );
//               },
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               ElevatedButton(
//                   onPressed: _addSafeZone, child: Text("Add Safe Zone")),
//               ElevatedButton(
//                   onPressed: _clearSafeZones, child: Text("Clear All")),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safehaven/geofencing_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SafeZoneScreen extends StatefulWidget {
  @override
  _SafeZoneScreenState createState() => _SafeZoneScreenState();
}

class _SafeZoneScreenState extends State<SafeZoneScreen> {
  List<Map<String, dynamic>> safeZones = [];
  late GeofenceService geofenceService;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _radiusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    geofenceService = GeofenceService();
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
            "name": parts[0],
            "lat": double.parse(parts[1]),
            "lng": double.parse(parts[2]),
            "radius": double.parse(parts[3]),
          };
        }).toList();
      });
    }
  }

  Future<void> _addSafeZone() async {
    if (_nameController.text.isEmpty || _radiusController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a name and radius")),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final prefs = await SharedPreferences.getInstance();

    String name = _nameController.text;
    double radius = double.parse(_radiusController.text);

    await geofenceService.saveSafeZone(name, position.latitude, position.longitude, radius);

    _nameController.clear();
    _radiusController.clear();
    _loadSafeZones();
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
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Safe Zone Name"),
                ),
                TextField(
                  controller: _radiusController,
                  decoration: InputDecoration(labelText: "Radius (meters)"),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addSafeZone,
                  child: Text("Add Safe Zone"),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: safeZones.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("${safeZones[index]['name']}"),
                  subtitle: Text(
                      "Lat: ${safeZones[index]['lat']}, Lng: ${safeZones[index]['lng']}, Radius: ${safeZones[index]['radius']}m"),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _clearSafeZones,
            child: Text("Clear All"),
          ),
        ],
      ),
    );
  }
}
