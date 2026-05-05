import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'medication_data.dart';
import 'success_screen.dart';

class AddMedicationScreen extends StatefulWidget {
  final Medication? medicationToEdit;
  const AddMedicationScreen({super.key, this.medicationToEdit});

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _notesController = TextEditingController();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 8, minute: 0);
  
  String _selectedFrequency = "Daily";
  final List<String> _frequencies = ["Daily", "Twice a Day", "Weekly", "As Needed"];

  // Keeping Type to satisfy Medication model, but it's optional in the UI if we follow the exact prompt.
  // We will default it to "Pill" under the hood.
  final String _defaultType = "Pill";

  final Color primaryColor = const Color(0xFF4B55D6);

  @override
  void initState() {
    super.initState();
    if (widget.medicationToEdit != null) {
      _nameController.text = widget.medicationToEdit!.name;
      _dosageController.text = widget.medicationToEdit!.dosage;
      _notesController.text = widget.medicationToEdit!.notes;
      _selectedFrequency = widget.medicationToEdit!.frequency;
      
      // Parse time string to TimeOfDay
      try {
        final dateTime = DateFormat.jm().parse(widget.medicationToEdit!.time);
        _selectedTime = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
      } catch (e) {
        _selectedTime = const TimeOfDay(hour: 8, minute: 0);
      }
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
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
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.medicationToEdit != null;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEditing ? "Edit Medication" : "Add Medication",
          style: const TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Medication Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            const SizedBox(height: 16),
            
            // Name Input (Autocomplete)
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                final predefinedMeds = [
                  "Paracetamol",
                  "Vitamin C",
                  "Biogesic",
                  "Cetirizine",
                  "Amoxicillin",
                  "Ibuprofen",
                  "Loratadine",
                  "Aspirin",
                ];
                return predefinedMeds.where((String option) {
                  return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (String selection) {
                _nameController.text = selection;
              },
              fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController, FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
                // Ensure the controller matches if pre-filled in edit mode
                if (_nameController.text.isNotEmpty && fieldTextEditingController.text.isEmpty) {
                  fieldTextEditingController.text = _nameController.text;
                }
                // Sync them
                fieldTextEditingController.addListener(() {
                  _nameController.text = fieldTextEditingController.text;
                });
                
                return TextField(
                  controller: fieldTextEditingController,
                  focusNode: fieldFocusNode,
                  decoration: InputDecoration(
                    labelText: "Name",
                    hintText: "e.g. Amoxicillin",
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            
            // Dose Input
            TextField(
              controller: _dosageController,
              decoration: InputDecoration(
                labelText: "Dose",
                hintText: "e.g. 500mg",
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            const Text("Schedule", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            const SizedBox(height: 16),

            // Time Picker
            InkWell(
              onTap: () => _selectTime(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedTime.format(context),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    Icon(Icons.access_time, color: primaryColor),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Frequency Dropdown
            DropdownButtonFormField<String>(
              initialValue: _selectedFrequency,
              decoration: InputDecoration(
                labelText: "Frequency",
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: _frequencies.map((String freq) {
                return DropdownMenuItem(value: freq, child: Text(freq));
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedFrequency = newValue!;
                });
              },
            ),
            const SizedBox(height: 24),

            const Text("Additional Info", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
            const SizedBox(height: 16),

            // Notes Multiline Input
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Notes",
                hintText: "Add any special instructions (e.g. take with food)...",
                alignLabelWithHint: true,
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
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
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  if (_nameController.text.isNotEmpty) {
                    final now = DateTime.now();
                    final scheduledTime = DateTime(now.year, now.month, now.day, _selectedTime.hour, _selectedTime.minute);
                    final timeString = DateFormat.jm().format(scheduledTime);

                    final med = Medication(
                      id: isEditing ? widget.medicationToEdit!.id : DateTime.now().toString(),
                      name: _nameController.text,
                      dosage: _dosageController.text,
                      time: timeString,
                      type: isEditing ? widget.medicationToEdit!.type : _defaultType, // Preserve type if editing
                      status: isEditing ? widget.medicationToEdit!.status : false,
                      frequency: _selectedFrequency,
                      notes: _notesController.text,
                    );

                    if (isEditing) {
                      await Provider.of<MedicationProvider>(context, listen: false).updateMedication(med);
                      if (context.mounted) {
                        Navigator.pop(context); // Just pop back to history/home if editing
                      }
                    } else {
                      await Provider.of<MedicationProvider>(context, listen: false).addMedication(med);
                      if (context.mounted) {
                        // Navigate to Success Screen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const SuccessScreen()),
                        );
                      }
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Medication name is required")),
                    );
                  }
                },
                child: const Text("Save Medication", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}