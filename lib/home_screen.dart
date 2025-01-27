import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safehaven/chatbot.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:safehaven/btmNavbar.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
// import 'package:background_sms/background_sms.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> emergencyContacts = [
    '+917012389225',
    '+919188271040', // Replace with real numbers
  ];

  // Function to send SMS
  Future<void> sendEmergencySMS() async {
    String message = Uri.encodeComponent(
        "Emergency! I'm in danger. Please help and check on me immediately.");
    for (String contact in emergencyContacts) {
      final Uri smsUri = Uri(
        scheme: 'sms',
        path: contact,
        queryParameters: {'body': message},
      );

      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      } else {
        throw 'Could not send SMS to $contact';
      }
    }
  }
//  _sendMessage(String phoneNumber, String message, {int? simSlot}) async {
//     var result = await BackgroundSms.sendMessage(
//         phoneNumber: phoneNumber, message: message, simSlot: simSlot);
//     if (result == SmsStatus.sent) {
//       print("Sent");
//     } else {
//       print("Failed");
//     }
//   }

  // Function to make a call
  // Future<void> makeEmergencyCall() async {
  //   String number = emergencyContacts[0]; // Call the first contact
  //   final Uri callUri = Uri(scheme: 'tel', path: number);
  //   if (await canLaunchUrl(callUri)) {
  //     await launchUrl(callUri);
  //   } else {
  //     throw 'Could not launch $callUri';
  //   }
  // }
  // _callNumber() async {
  //       print("Calling...");
  //   const number = '+919188271040'; //set the number here
  //   bool? res = await FlutterPhoneDirectCaller.callNumber(number);

  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Safe Haven'), backgroundColor: Colors.transparent),
      body: Center(
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
                await sendEmergencySMS();
                // await makeEmergencyCall();
                // await _sendMessage("+919188271040", "hi");
                // await _callNumber();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Emergency Alert Sent!'),
                  ),
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
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.chat),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ChatScreen()));
        },
      ),
    );
  }
}
