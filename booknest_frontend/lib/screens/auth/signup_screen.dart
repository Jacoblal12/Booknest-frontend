import 'package:flutter/material.dart';
import 'package:booknest_frontend/services/api_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool isLoading = false;
  bool showPassword = false;
  bool showPassword2 = false;

  // -------------------------------
  // VALIDATION HELPERS
  // -------------------------------
  bool isValidEmail(String email) {
    final regex = RegExp(r"^[\w\.-]+@[\w\.-]+\.\w+$");
    return regex.hasMatch(email);
  }

  bool isValidUsername(String username) {
    final regex = RegExp(r"^[a-zA-Z0-9_]{3,}$");
    return regex.hasMatch(username);
  }

  bool isStrongPassword(String pwd) {
    // at least 8 chars, 1 letter + 1 number
    final regex = RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$");
    return regex.hasMatch(pwd);
  }

  // -------------------------------
  // REGISTER FUNCTION
  // -------------------------------
  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;

    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password1 = _passwordController.text.trim();
    final password2 = _confirmPasswordController.text.trim();

    if (password1 != password2) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }

    setState(() => isLoading = true);

    bool success = await ApiService.signup(username, email, password1);

    setState(() => isLoading = false);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signup successful! Please log in.")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signup failed. Try again.")),
      );
    }
  }

  // -------------------------------
  // CLEAN INPUT BUILDER
  // -------------------------------
  Widget _inputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool isPassword = false,
    bool? showPass,
    VoidCallback? toggleVisibility,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? !(showPass ?? false) : false,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  (showPass ?? false) ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: toggleVisibility,
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        ),
      ),
    );
  }

  // -----------------------------
  // PASSWORD STRENGTH CHECK
  // -----------------------------
  int getPasswordStrength(String password) {
    if (password.isEmpty) return 0;

    bool hasLetters = RegExp(r"[A-Za-z]").hasMatch(password);
    bool hasNumbers = RegExp(r"[0-9]").hasMatch(password);
    bool hasSpecial = RegExp(r"[!@#\$%^&*().?\:|<>]").hasMatch(password);

    if (password.length >= 10 && hasLetters && hasNumbers && hasSpecial) {
      return 3; // Strong
    } else if (password.length >= 8 && hasLetters && hasNumbers) {
      return 2; // Medium
    } else {
      return 1; // Weak
    }
  }

  // -------------------------------
  // UI BUILD
  // -------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Account"), elevation: 1),

      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),

              // TITLE
              const Text(
                "Join BookNest 📚",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              // USERNAME
              _inputField(
                label: "Username",
                icon: Icons.person,
                controller: _usernameController,
                validator: (v) {
                  if (v == null || v.isEmpty) return "Username is required";
                  if (!isValidUsername(v)) {
                    return "Use 3+ characters: letters, numbers, _ allowed";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // EMAIL
              _inputField(
                label: "Email",
                icon: Icons.email,
                controller: _emailController,
                validator: (v) {
                  if (v == null || v.isEmpty) return "Email is required";
                  if (!isValidEmail(v)) return "Enter a valid email";
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // PASSWORD
              _inputField(
                label: "Password",
                icon: Icons.lock,
                controller: _passwordController,
                isPassword: true,
                showPass: showPassword,
                toggleVisibility: () =>
                    setState(() => showPassword = !showPassword),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Password required";
                  if (!isStrongPassword(v)) {
                    return "Min 8 chars, include letters & numbers";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Password Strength Meter
              AnimatedBuilder(
                animation: _passwordController,
                builder: (context, child) {
                  final strength = getPasswordStrength(
                    _passwordController.text,
                  );

                  Color bar1 = Colors.grey.shade300;
                  Color bar2 = Colors.grey.shade300;
                  Color bar3 = Colors.grey.shade300;
                  String label = "Weak";

                  if (strength == 1) {
                    bar1 = Colors.red;
                    label = "Weak";
                  } else if (strength == 2) {
                    bar1 = Colors.orange;
                    bar2 = Colors.orange;
                    label = "Medium";
                  } else if (strength == 3) {
                    bar1 = Colors.green;
                    bar2 = Colors.green;
                    bar3 = Colors.green;
                    label = "Strong";
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 6,
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              color: bar1,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 6,
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              color: bar2,
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 6,
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              color: bar3,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: strength == 3
                              ? Colors.green
                              : strength == 2
                              ? Colors.orange
                              : Colors.red,
                        ),
                      ),
                    ],
                  );
                },
              ),

              // CONFIRM PASSWORD
              _inputField(
                label: "Confirm Password",
                icon: Icons.lock_outline,
                controller: _confirmPasswordController,
                isPassword: true,
                showPass: showPassword2,
                toggleVisibility: () =>
                    setState(() => showPassword2 = !showPassword2),
                validator: (v) {
                  if (v == null || v.isEmpty) return "Confirm your password";
                  if (v != _passwordController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),

              // SIGNUP BUTTON
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Create Account",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
