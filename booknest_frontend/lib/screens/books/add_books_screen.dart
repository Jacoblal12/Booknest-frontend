import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:booknest_frontend/services/api_service.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();

  String title = "";
  String author = "";
  String description = "";
  String isbn = "";
  String genre = "other";
  String availableFor = "rent";

  File? imageFile;

  Future pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => imageFile = File(picked.path));
    }
  }

  Future uploadBook() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final success = await ApiService.uploadBook(
      title: title,
      author: author,
      description: description,
      isbn: isbn,
      genre: genre,
      availableFor: availableFor,
      imageFile: imageFile,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Book uploaded successfully!")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to upload")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Book")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(imageFile!, fit: BoxFit.cover),
                        )
                      : const Center(child: Text("Tap to choose cover")),
                ),
              ),

              const SizedBox(height: 20),

              TextFormField(
                decoration: const InputDecoration(labelText: "Title"),
                validator: (v) => v!.isEmpty ? "Required" : null,
                onSaved: (v) => title = v!,
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: "Author"),
                validator: (v) => v!.isEmpty ? "Required" : null,
                onSaved: (v) => author = v!,
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: "ISBN"),
                onSaved: (v) => isbn = v ?? "",
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
                onSaved: (v) => description = v ?? "",
              ),

              const SizedBox(height: 10),

              // GENRE DROPDOWN
              DropdownButtonFormField(
                value: genre,
                decoration: const InputDecoration(labelText: "Genre"),
                items: const [
                  DropdownMenuItem(value: "fiction", child: Text("Fiction")),
                  DropdownMenuItem(
                    value: "nonfiction",
                    child: Text("Non-Fiction"),
                  ),
                  DropdownMenuItem(value: "fantasy", child: Text("Fantasy")),
                  DropdownMenuItem(value: "mystery", child: Text("Mystery")),
                  DropdownMenuItem(value: "romance", child: Text("Romance")),
                  DropdownMenuItem(value: "thriller", child: Text("Thriller")),
                  DropdownMenuItem(value: "science", child: Text("Science")),
                  DropdownMenuItem(value: "history", child: Text("History")),
                  DropdownMenuItem(
                    value: "biography",
                    child: Text("Biography"),
                  ),
                  DropdownMenuItem(value: "selfhelp", child: Text("Self Help")),
                  DropdownMenuItem(value: "other", child: Text("Other")),
                ],
                onChanged: (v) => genre = v!,
              ),

              const SizedBox(height: 10),

              // AVAILABLE FOR DROPDOWN
              DropdownButtonFormField(
                value: availableFor,
                decoration: const InputDecoration(labelText: "Available For"),
                items: const [
                  DropdownMenuItem(value: "rent", child: Text("Rent")),
                  DropdownMenuItem(value: "exchange", child: Text("Exchange")),
                  DropdownMenuItem(value: "donate", child: Text("Donate")),
                ],
                onChanged: (v) => availableFor = v!,
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: uploadBook,
                child: const Text("Upload Book"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
