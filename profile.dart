import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safehaven/btmNavbar.dart';
import 'models/user_profile.dart'; // Import the UserProfile model
import 'services/firestorefunction.dart'; // Import the FirestoreService

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService(); // Create an instance

  void _registerUser() {
    // Generate a unique ID for the user (you can use Firebase Auth for real apps)
    String userId = DateTime.now().millisecondsSinceEpoch.toString();

    // Create a new UserProfile instance
    UserProfile newUser = UserProfile(
      id: userId,
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
    );

    // Save the user profile
    _firestoreService.saveUserProfile(newUser).then((_) {
      // Optionally, clear the text fields after saving
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
    }).catchError((error) {
      print('Error saving user profile: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registerUser,
              child: Text('Save Profile'),
            ),
          ],
        ),
      ),
     // bottomNavigationBar: BottomNavBar(currentIndex: 1),
    );
  }
}
