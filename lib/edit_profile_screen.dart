import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'user_data.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _dobController = TextEditingController();
  
  String? _selectedGender;
  DateTime? _selectedDate;
  String _selectedImagePath = "";
  final ImagePicker _picker = ImagePicker();

  final List<String> genders = ['Male', 'Female', 'Other', 'Prefer not to say'];
  final Color primaryColor = const Color(0xFF4B55D6);

  @override
  void initState() {
    super.initState();
    // Pre-fill existing data
    final profile = Provider.of<UserProvider>(context, listen: false).profile;
    if (profile != null) {
      _nameController.text = profile.name;
      _emailController.text = profile.email;
      _phoneController.text = profile.phone;
      _addressController.text = profile.address;
      _dobController.text = profile.dob;
      _selectedImagePath = profile.profileImage;
      
      if (genders.contains(profile.gender)) {
        _selectedGender = profile.gender;
      }
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: const Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = DateFormat('MMM dd, yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: primaryColor.withValues(alpha: 0.1),
                      backgroundImage: _selectedImagePath.isNotEmpty 
                          ? FileImage(File(_selectedImagePath)) 
                          : null,
                      child: _selectedImagePath.isEmpty 
                          ? Icon(Icons.camera_alt, size: 40, color: primaryColor) 
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFF4B55D6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit, size: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            _buildInputLabel("Full Name"),
            _buildTextField(_nameController, "Enter your full name", Icons.person_outline),
            const SizedBox(height: 20),

            _buildInputLabel("Email"),
            _buildTextField(_emailController, "Enter your email", Icons.email_outlined, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 20),

            _buildInputLabel("Phone Number"),
            _buildTextField(_phoneController, "Enter your phone number", Icons.phone_outlined, keyboardType: TextInputType.phone),
            const SizedBox(height: 20),

            _buildInputLabel("Address"),
            _buildTextField(_addressController, "Enter your address", Icons.home_outlined),
            const SizedBox(height: 20),

            _buildInputLabel("Date of Birth"),
            TextField(
              controller: _dobController,
              readOnly: true,
              onTap: () => _selectDate(context),
              decoration: InputDecoration(
                hintText: "Select your birthday",
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                prefixIcon: const Icon(Icons.calendar_today_outlined, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 20),

            _buildInputLabel("Gender"),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                hintText: "Select Gender",
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                prefixIcon: const Icon(Icons.people_outline, color: Colors.grey),
              ),
              value: _selectedGender,
              items: genders.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
              onChanged: (val) => setState(() => _selectedGender = val),
            ),
            const SizedBox(height: 40),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () async {
                  if (_nameController.text.isNotEmpty && _emailController.text.isNotEmpty) {
                    final currentProfile = Provider.of<UserProvider>(context, listen: false).profile;
                    if (currentProfile != null) {
                      final updatedProfile = UserProfile(
                        id: currentProfile.id,
                        name: _nameController.text,
                        email: _emailController.text,
                        dob: _dobController.text,
                        gender: _selectedGender ?? currentProfile.gender,
                        weight: currentProfile.weight,
                        height: currentProfile.height,
                        bloodType: currentProfile.bloodType,
                        phone: _phoneController.text,
                        address: _addressController.text,
                        profileImage: _selectedImagePath,
                      );
                      await Provider.of<UserProvider>(context, listen: false).saveProfile(updatedProfile);
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Name and Email are required")),
                    );
                  }
                },
                child: const Text("Save Changes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1E293B)),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(icon, color: Colors.grey),
      ),
    );
  }
}