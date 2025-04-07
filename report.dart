import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ReportAbuseScreen extends StatefulWidget {
  @override
  _ReportAbuseScreenState createState() => _ReportAbuseScreenState();
}

class _ReportAbuseScreenState extends State<ReportAbuseScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedCategory = 'Domestic Violence';
  File? _image;
  bool _isSubmitting = false;

  final List<String> categories = [
    'Domestic Violence',
    'Child Abuse',
    'Sexual Harassment',
    'Elder Abuse',
    'Other'
  ];

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      String fileName = 'Reports/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference ref = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Image Upload Error: $e');
      return null;
    }
  }

  Future<void> _submitComplaint() async {
    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please enter complaint details")));
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    String? imageUrl;
    if (_image != null) {
      imageUrl = await _uploadImage(_image!);
    }

    await FirebaseFirestore.instance.collection('Reports').add({
      'category': _selectedCategory,
      'description': _descriptionController.text,
      'timestamp': FieldValue.serverTimestamp(),
      'imageUrl': imageUrl ?? '',
    });

    setState(() {
      _isSubmitting = false;
      _descriptionController.clear();
      _image = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Complaint submitted successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Report Abuse Anonymously')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Category"),
            DropdownButton<String>(
              value: _selectedCategory,
              items: categories.map((String category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Describe the incident...",
              ),
            ),
            SizedBox(height: 16),
            _image != null
                ? Image.file(_image!, height: 150)
                : TextButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(Icons.camera_alt),
                    label: Text("Attach Image (Optional)"),
                  ),
            SizedBox(height: 16),
            _isSubmitting
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submitComplaint,
                    child: Text("Submit Complaint"),
                  ),
          ],
        ),
      ),
    );
  }
}
