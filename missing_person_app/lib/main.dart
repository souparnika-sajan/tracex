import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

// ---------------- MY APP ----------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

// ---------------- HOME SCREEN ----------------
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Missing Person App"),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RegisterScreen(),
              ),
            );
          },
          child: const Text("Register Missing Person"),
        ),
      ),
    );
  }
}

// ---------------- REGISTER SCREEN ----------------
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Pick image from gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register Person")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Name
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // Age
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Age",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            // Description
            TextField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Image preview + upload button
            _selectedImage != null
                ? Image.file(_selectedImage!, height: 150)
                : const Text("No Image Selected"),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text("Upload Photo"),
            ),
            const SizedBox(height: 20),

            // Submit button → Navigate to SuccessPage
            ElevatedButton(
              onPressed: () {
                // Validate fields
                if (nameController.text.isEmpty ||
                    ageController.text.isEmpty ||
                    descriptionController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please fill all fields"),
                    ),
                  );
                  return;
                }
                print("Before Navigate");

                // Navigate to SuccessPage with submitted data
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SuccessPage(
                      name: nameController.text,
                      age: ageController.text,
                      description: descriptionController.text,
                      image: _selectedImage,
                    ),
                  ),
                );
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- SUCCESS PAGE ----------------
class SuccessPage extends StatelessWidget {
  final String name;
  final String age;
  final String description;
  final File? image;

  const SuccessPage({
    super.key,
    required this.name,
    required this.age,
    required this.description,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(title: const Text("Success")),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100,
              ),
              const SizedBox(height: 20),
              Text(
                "You've Registered Successfully!",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Display submitted info
              Text("Name: $name", style: const TextStyle(fontSize: 18)),
              Text("Age: $age", style: const TextStyle(fontSize: 18)),
              Text("Description: $description", style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              image != null
                  ? Image.file(image!, height: 150)
                  : const Text("No image uploaded"),
            ],
          ),
        ),
      ),
    );
  }
}

