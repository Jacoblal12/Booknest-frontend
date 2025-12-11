import 'package:flutter/material.dart';
import 'package:booknest_frontend/services/api_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  String username = "";
  String email = "";
  String password1 = "";
  String password2 = "";

  bool isLoading = false;

  /// EMAIL VALIDATION
  bool isValidEmail(String email) {
    final regex = RegExp(r"^[\w\.-]+@[\w\.-]+\.\w+$");
    return regex.hasMatch(email);
  }

  /// USERNAME VALIDATION
  bool isValidUsername(String username) {
    final regex = RegExp(r"^[a-zA-Z0-9_]{3,}$");
    return regex.hasMatch(username);
  }

  /// PASSWORD VALIDATION
  bool isStrongPassword(String pwd) {
    final regex = RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$");
    return regex.hasMatch(pwd);
  }

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => isLoading = true);

    bool success = await ApiService.signup(username, email, password1);

    setState(() => isLoading = false);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signup successful! Please log in.")),
      );
      Navigator.pop(context); // go back to login
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signup failed. Try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Account")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              /// USERNAME
              TextFormField(
                decoration: const InputDecoration(labelText: "Username"),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Username is required";
                  if (!isValidUsername(v)) {
                    return "Use 3+ characters: letters, numbers, _ only";
                  }
                  return null;
                },
                onSaved: (v) => username = v!.trim(),
              ),

              /// EMAIL
              TextFormField(
                decoration: const InputDecoration(labelText: "Email"),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Email is required";
                  if (!isValidEmail(v)) return "Enter a valid email address";
                  return null;
                },
                onSaved: (v) => email = v!.trim(),
              ),

              /// PASSWORD
              TextFormField(
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (v) {
                  if (v == null || v.isEmpty) return "Password is required";
                  if (!isStrongPassword(v)) {
                    return "Min 8 chars, must include letters & numbers";
                  }
                  return null;
                },
                onSaved: (v) => password1 = v!,
              ),

              /// CONFIRM PASSWORD
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Confirm Password",
                ),
                obscureText: true,
                validator: (v) {
                  if (v == null || v.isEmpty) return "Please confirm password";
                  if (v != password1) return "Passwords do not match";
                  return null;
                },
                onSaved: (v) => password2 = v!,
              ),

              const SizedBox(height: 20),

              /// SIGNUP BUTTON
              ElevatedButton(
                onPressed: isLoading ? null : register,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Create Account"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
