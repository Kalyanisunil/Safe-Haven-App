// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart'
//     as permission_handler;
// import 'package:safehaven/chatbot.dart';
// import 'package:safehaven/contacts_screen.dart';
// import 'package:safehaven/fake_call_screen.dart';
// // import 'package:safehaven/fake_call_screen.dart';

// import 'package:safehaven/geofencing.dart';
// import 'package:safehaven/profile.dart';
// import 'package:safehaven/services/location_service.dart';
// // import 'package:url_launcher/url_launcher.dart';
// // import 'package:safehaven/btmNavbar.dart';
// import 'package:telephony_sms/telephony_sms.dart';
// import 'package:location/location.dart';
// import 'package:another_telephony/telephony.dart';
// import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
// // import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
// // import 'package:background_sms/background_sms.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   // void _sendSMS(String message, List<String> recipents) async {
//   //   String _result = await sendSMS(message: message, recipients: recipents)
//   //       .catchError((onError) {
//   //     print(onError);
//   //   });
//   //   print(_result);
//   // }
//   var tel = Telephony.instance;
//   Location location = new Location();
//   LocationData? _locationData;
//   void getLocation() async {
//     bool _serviceEnabled;
//     PermissionStatus _permissionGranted;

//     _serviceEnabled = await location.serviceEnabled();
//     if (!_serviceEnabled) {
//       _serviceEnabled = await location.requestService();
//       if (!_serviceEnabled) {
//         return;
//       }
//     }

//     _permissionGranted = await location.hasPermission();
//     if (_permissionGranted == PermissionStatus.denied) {
//       _permissionGranted = await location.requestPermission();
//       if (_permissionGranted != PermissionStatus.granted) {
//         return null;
//       }
//     }

//     _locationData = await location.getLocation();
//   }

//   @override
//   void setState(VoidCallback fn) {
//     getLocation();
//     super.setState(fn);
//   }

//   final List<String> emergencyContacts = [
//     '+918136912029',
//     '+917012389225' // Replace with real numbers
//   ];
//   final _telephonySMS = TelephonySMS();
//   // Function to send SMS
//   Future<String> sendEmergencySMS() async {
//     String returnVal = 'Something went wrong';
//     String message = Uri.encodeComponent(
//         "Emergency! I'm in danger. Please help and check on me immediately.");
//     var loc = await LocationService.getLocationLink();
//     var msg =
//         "Emergency! I'm in danger. Please help and check on me immediately.location : ${loc ?? 'Location not available'}\n";
//     // for (String contact in emergencyContacts) {
//     //   print('sending to $contact');
//     //   // _telephonySMS.call();
//     //   await _telephonySMS
//     //       .sendSMS(
//     //     phone: contact,
//     //     message: msg,
//     //   )
//     //       .then((val) {
//     //     print('Sent to $contact');
//     //     // print(val);
//     //   });
//     //   print('Sent to $contact');
//     // }
//     for (var contact in emergencyContacts) {
//       tel.sendSms(to: contact, message: msg);
//     }
//     //tel.sendSms(to: to, message: message)
//     returnVal = 'Emergency Alert Sent!';

//     return returnVal;
//   }

//   int currentIndex = 0;
//   PageController controller = PageController(initialPage: 0, keepPage: true);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           title: Text('Safe Haven'),
//           backgroundColor: Colors.white,
//           elevation: 3),
//       body: PageView(
//         children: [
//           homeWidget(context),
//           SafeZoneScreen(),
//           ContactsScreen(),
//           UserProfilePage(),
//           // FakeCallScreen()
//         ],
//         controller: controller,
//         scrollBehavior: ScrollBehavior(),
//         allowImplicitScrolling: false,
//         onPageChanged: (index) {
//           setState(() {
//             // currentIndex = index;

//             currentIndex = index;
//           });
//         },
//       ),
//       bottomNavigationBar: WaterDropNavBar(
//         barItems: [
//           BarItem(
//             filledIcon: Icons.home,
//             outlinedIcon: Icons.home_outlined,
//           ),
//           BarItem(filledIcon: Icons.map, outlinedIcon: Icons.map_outlined),
//           BarItem(
//               filledIcon: Icons.contacts,
//               outlinedIcon: Icons.contacts_outlined),
//           BarItem(filledIcon: Icons.person, outlinedIcon: Icons.person_outline),
//           //  BarItem(filledIcon: Icons.accessibility, outlinedIcon: Icons.accessibility_new_outlined),
//         ],
//         selectedIndex: currentIndex,
//         onItemSelected: (index) {
//           setState(() {
//             controller.animateToPage(index,
//                 duration: Duration(milliseconds: 200), curve: Curves.easeIn);
//             currentIndex = index;
//           });
//         },
//         waterDropColor: Colors.pink,
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.pinkAccent,
//         child: Icon(
//           Icons.chat,
//           color: Colors.white,
//         ),
//         onPressed: () {
//           Navigator.push(
//               context, MaterialPageRoute(builder: (context) => ChatScreen()));
//         },
//       ),
//     );
//   }

//   Center homeWidget(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             'Emergency Alert',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//           ),
//           SizedBox(height: 20),
//           GestureDetector(
//             onTap: () async {
//               var msg = await sendEmergencySMS();

//               var snackBar = SnackBar(
//                 content: Text(msg),
//               );
//               ScaffoldMessenger.of(context).showSnackBar(
//                 snackBar,
//               );
//             },
//             child: Container(
//               width: 200,
//               height: 200,
//               decoration: BoxDecoration(
//                 color: Colors.red,
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.redAccent.withOpacity(0.5),
//                     blurRadius: 10,
//                     spreadRadius: 5,
//                   ),
//                 ],
//               ),
//               child: Center(
//                 child: Text(
//                   'SOS',
//                   style: TextStyle(
//                     fontSize: 40,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 30),
//           Text(
//             'Tap the SOS button to send an alert.',
//             textAlign: TextAlign.center,
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.black54,
//             ),
//           ),
//           SizedBox(height: 20),
//           // ElevatedButton(
//           //   child: Text('Fake  Call'),
//           //  onPressed: () {
//           //   Navigator.push(
//           //     context,
//           //     MaterialPageRoute(builder: (context) => FakeCallScreen()),
//           //   );
//           // },
//           //   style: ElevatedButton.styleFrom(
//           //     backgroundColor: const Color.fromARGB(255, 228, 230, 232), // Button color
//           //     padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//           //     shape: RoundedRectangleBorder(
//           //       borderRadius: BorderRadius.circular(10),
//           //     ),
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;
import 'package:safehaven/card.dart';
import 'package:safehaven/chatbot.dart';
import 'package:safehaven/contacts_screen.dart';
import 'package:safehaven/fake_call_screen.dart';
import 'package:safehaven/geofencing.dart';
import 'package:safehaven/profile.dart';
import 'package:safehaven/report.dart';
import 'package:safehaven/services/location_service.dart';
import 'package:safehaven/voice_sos.dart';
import 'package:telephony_sms/telephony_sms.dart';
import 'package:location/location.dart';
import 'package:another_telephony/telephony.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:safehaven/test.dart';
import 'package:picovoice_flutter/picovoice_manager.dart';
import 'package:picovoice_flutter/picovoice_error.dart';
import 'package:rhino_flutter/rhino.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var tel = Telephony.instance;
  final SpeechService _speechService = SpeechService();
  String _text = "Press the button and start speaking";
  Location location = Location(); // Declared only once
  LocationData? _locationData;
  List<String> emergencyContacts = [];
  VoiceSOSService voiceSOSService = VoiceSOSService();
  var ppmasset = 'assets/please-help_en_android_v3_0_0.ppn';
  var rhmasset = 'assets/Safe-Haven_en_android_v3_0_0.rhn';
  final String accessKey =
      "A2N5rNrdwke2WWmrj7YXq7NgrxBIVqGtaWSVk8lLJIC5PrJuqbT8YA=="; // AccessKey obtained from Picovoice Console (https://console.picovoice.ai/)
  late PicovoiceManager _picovoiceManager;

  void onWakeupCall() {
    print('picovoice wakeup');
    sendEmergencySMS();
  }

  void _inferenceCallback(RhinoInference inference) {
    print(inference);
  }

  void initPicovoice() async {
    print('starting picovoice');
    try {
      _picovoiceManager = await PicovoiceManager.create(
          accessKey, ppmasset, onWakeupCall, rhmasset, _inferenceCallback);
      await _picovoiceManager.start();
    } on PicovoiceException catch (ex) {
      print('picovoice ERROR ${ex.message}');
    } catch (ex) {
      print('picovoice ERROR ${ex.toString()}');
    }
  }

  void _startListening() async {
    await _speechService.startListening();
    setState(() {
      _text = "Listening...";
    });
  }

  void _stopListening() {
    _speechService.stopListening();
    setState(() {
      _text = "Tap the button to start again";
    });
  }

  @override
  void initState() {
    super.initState();
    getLocation();
    loadEmergencyContacts();
    initPicovoice();
  }

  Future<void> loadEmergencyContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      emergencyContacts = prefs.getStringList('contacts') ?? [];
    });
  }

  Future<String> sendEmergencySMS() async {
    await loadEmergencyContacts();
    String returnVal = 'Something went wrong';
    var loc = await LocationService.getLocationLink();
    var msg =
        "Emergency! I'm in danger. Please help and check on me immediately. Location: ${loc ?? 'Location not available'}";

    for (var contact in emergencyContacts) {
      tel.sendSms(to: contact, message: msg);
    }
    print('here : ${emergencyContacts}');
    returnVal = 'Emergency Alert Sent!';
    return returnVal;
  }

  Future<void> getLocation() async {
    bool _serviceEnabled;
    permission_handler.PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await permission_handler.Permission.location.status;
    if (_permissionGranted == permission_handler.PermissionStatus.denied) {
      _permissionGranted =
          await permission_handler.Permission.location.request();
      if (_permissionGranted != permission_handler.PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    setState(() {}); // Updates UI after getting location
  }

  int currentIndex = 0;
  PageController controller = PageController(initialPage: 0, keepPage: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Safe Haven'),
          backgroundColor: Colors.white,
          elevation: 3),
      body: PageView(
        children: [
          homeWidget(context),
          SafeZoneScreen(),
          ContactsScreen(),
          UserProfilePage(),
          // ReportAbuseScreen(),
          // FakeCallScreen(),
        ],
        controller: controller,
        scrollBehavior: null,
        allowImplicitScrolling: false,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            // currentIndex = index;

            currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: WaterDropNavBar(
        barItems: [
          BarItem(
            filledIcon: Icons.home,
            outlinedIcon: Icons.home_outlined,
          ),
          BarItem(filledIcon: Icons.map, outlinedIcon: Icons.map_outlined),
          BarItem(
              filledIcon: Icons.contacts,
              outlinedIcon: Icons.contacts_outlined),
          BarItem(filledIcon: Icons.person, outlinedIcon: Icons.person_outline),
          //  BarItem(filledIcon: Icons.report, outlinedIcon: Icons.report_off_outlined),
        ],
        selectedIndex: currentIndex,
        onItemSelected: (index) {
          setState(() {
            controller.animateToPage(index,
                duration: Duration(milliseconds: 200), curve: Curves.easeIn);
            currentIndex = index;
          });
        },
        waterDropColor: Colors.pink,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pinkAccent,
        child: Icon(
          Icons.chat,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ChatScreen()));
        },
      ),
    );
  }

  Center homeWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Emergency Alert',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () async {
              var msg = await sendEmergencySMS();

              var snackBar = SnackBar(
                content: Text(msg),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                snackBar,
              );
            },
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'SOS',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          Text(
            'Tap the SOS button to send an alert.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 20),

          // ElevatedButton(
          //     onPressed: voiceSOSService.isListening
          //         ? voiceSOSService.stopVoiceSOS
          //         : () => voiceSOSService.startVoiceSOS(context),
          //     child: Text(voiceSOSService.isListening ? "Stop Listening" : "Start Voice SOS"),
          // //   ),
          // ElevatedButton(onPressed: _startListening, child: Text("Start")),
          //    ElevatedButton(onPressed: _stopListening, child: Text("Stop")),

          Center(
            child: Text(
              "Say 'Please Help' to trigger an alert, even when the app is closed.",
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white70,
                ),
            alignment: Alignment.center,
            width: double.infinity,
            height: 120,
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: ListView(
              padding: EdgeInsets.all(5),
              scrollDirection: Axis.horizontal,
              children: [
                content(
                    title: 'Abuse Report',
                    onclick: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReportAbuseScreen()),
                      );
                    }),
                SizedBox(
                  width: 10,
                ),
                content(
                    title: 'Police Dept',
                    onclick: () {
                      launchUrlString("tel://100");
                    }),
                SizedBox(
                  width: 10,
                ),
                content(
                    title: 'Child Helpline',
                    onclick: () {
                      launchUrlString("tel://1012");
                    }),
                SizedBox(
                  width: 10,
                ),
                content(
                    title: 'Fire Dept',
                    onclick: () {
                      launchUrlString("tel://101");
                    })
                //   ,SizedBox(
                //     width:10,
                //   ),
                //   content(
                //     title: 'Fake Call',
                //     onclick: () { Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => FakeCallScreen()),
                //       );
                      
                //     }),
                // SizedBox(
                //   width: 10,
                // ),

              ],
            ),
          )
        ],
      ),
    );
  }

  Widget content({required String title, required Function onclick}) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.pinkAccent,
      ),
      width: 135,
      child: (ListTile(
        titleAlignment: ListTileTitleAlignment.center,
        title: Text(title),
        onTap: () {
          onclick();
          print('Clicked');
        },
      )),
    );
  }
}
