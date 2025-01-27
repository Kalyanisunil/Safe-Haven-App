class UserProfile {
  String id; // Unique identifier for the user
  String name; // User's name
  String email; // User's email
  String phone; // User's phone number

  // Constructor
  UserProfile({required this.id, required this.name, required this.email, required this.phone});

  // Convert UserProfile to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
    };
  }

  // Create a UserProfile from a Map
  UserProfile.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        email = map['email'],
        phone = map['phone'];
}