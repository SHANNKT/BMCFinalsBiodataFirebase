import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController objectiveController = TextEditingController();
  final TextEditingController educationController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<TextEditingController> get _all => [
        firstNameController,
        surnameController,
        lastNameController,
        phoneController,
        emailController,
        addressController,
        objectiveController,
        educationController,
        skillsController,
        experienceController,
      ];

  Future<void> saveData() async {
    if (_all.any((c) => c.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      await firestore.collection('resume').add({
        'firstName': firstNameController.text.trim(),
        'surname': surnameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'phone': phoneController.text.trim(),
        'email': emailController.text.trim(),
        'address': addressController.text.trim(),
        'objective': objectiveController.text.trim(),
        'education': educationController.text.trim(),
        'skills': skillsController.text.trim(),
        'experience': experienceController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data saved successfully')),
      );
      for (final c in _all) {
        c.clear();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void dispose() {
    for (final c in _all) {
      c.dispose();
    }
    super.dispose();
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          alignLabelWithHint: maxLines > 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resume Form')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _field(firstNameController, 'First Name'),
            _field(surnameController, 'Surname'),
            _field(lastNameController, 'Last Name'),
            _field(phoneController, 'Phone',
                keyboardType: TextInputType.phone),
            _field(emailController, 'Email',
                keyboardType: TextInputType.emailAddress),
            _field(addressController, 'Address'),
            _field(objectiveController, 'Objective', maxLines: 3),
            _field(educationController, 'Education', maxLines: 3),
            _field(skillsController, 'Skills', maxLines: 3),
            _field(experienceController, 'Experience', maxLines: 4),
            ElevatedButton(
              onPressed: saveData,
              child: const Text('Save to Firebase'),
            ),
          ],
        ),
      ),
    );
  }
}