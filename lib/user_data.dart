import 'package:flutter/material.dart';
import 'database_helper.dart';

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String dob;
  final String gender;
  final String weight;
  final String height;
  final String bloodType;
  final String phone;
  final String address;
  final String profileImage;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.dob,
    required this.gender,
    required this.weight,
    required this.height,
    required this.bloodType,
    this.phone = "",
    this.address = "",
    this.profileImage = "",
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'dob': dob,
      'gender': gender,
      'weight': weight,
      'height': height,
      'bloodType': bloodType,
      'phone': phone,
      'address': address,
      'profileImage': profileImage,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      dob: map['dob'],
      gender: map['gender'],
      weight: map['weight'],
      height: map['height'],
      bloodType: map['bloodType'],
      phone: map['phone'] ?? "",
      address: map['address'] ?? "",
      profileImage: map['profileImage'] ?? "",
    );
  }
}

class UserProvider with ChangeNotifier {
  UserProfile? _profile;

  UserProfile? get profile => _profile;

  Future<void> fetchProfile() async {
    final data = await DatabaseHelper.instance.getProfile();
    if (data != null) {
      _profile = UserProfile.fromMap(data);
      notifyListeners();
    }
  }

  Future<void> saveProfile(UserProfile profile) async {
    await DatabaseHelper.instance.saveProfile(profile.toMap());
    _profile = profile;
    notifyListeners();
  }
}