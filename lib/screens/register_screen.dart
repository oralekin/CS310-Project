import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  static const String _adminAccessCode = 'UNICONNECT_ADMIN_2025';

  String _selectedRole = 'student';
  String? _selectedUniversity;

  final List<String> _universities = [
    'Sabanci University',
    'Bogazici University',
    'Koc University',
    'METU',
    'ITU',
    'Bilkent University',
    'Hacettepe University',
    'Other',
  ];

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  final TextEditingController _clubNameController = TextEditingController();
  final TextEditingController _adminCodeController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _clubNameController.dispose();
    _adminCodeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    String? errorMessage;
    try {
      final auth = context.read<AuthProvider>();
      await auth.signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        role: _selectedRole,
        fullName: _fullNameController.text.trim(),
        university: (_selectedUniversity ?? '').trim(),
        clubName: _selectedRole == 'admin'
            ? _clubNameController.text.trim()
            : null,
      );

      errorMessage = auth.errorMessage;
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }

    if (!mounted) return;

    if (errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Registration Successful"),
        content: const Text("Your account has been created."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),

              const Text(
                "UniConnect",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 40),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // ROLE
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Account Type",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          ChoiceChip(
                            label: const Text("Student"),
                            selected: _selectedRole == 'student',
                            onSelected: (selected) {
                              if (!selected) return;
                              setState(() => _selectedRole = 'student');
                            },
                          ),
                          const SizedBox(width: 10),
                          ChoiceChip(
                            label: const Text("Admin"),
                            selected: _selectedRole == 'admin',
                            onSelected: (selected) {
                              if (!selected) return;
                              setState(() => _selectedRole = 'admin');
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Full Name
                      TextFormField(
                        controller: _fullNameController,
                        decoration: _inputDecoration("Full Name"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your full name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // University
                    DropdownButtonFormField<String>(
                      value: _selectedUniversity,
                      decoration: _inputDecoration("University"),
                      items: _universities
                          .map(
                            (uni) => DropdownMenuItem<String>(
                              value: uni,
                              child: Text(uni),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() => _selectedUniversity = value);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please select your university";
                        }
                        return null;
                      },
                    ),
                      const SizedBox(height: 12),

                      if (_selectedRole == 'admin') ...[
                        // Club/Organization Name
                        TextFormField(
                          controller: _clubNameController,
                          decoration:
                          _inputDecoration("Club/Organization Name"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your club name";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Mail Address
                      TextFormField(
                        controller: _emailController,
                        decoration: _inputDecoration("Mail Address"),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }
                        if (!value.contains("@")) {
                          return "Please enter a valid email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: _inputDecoration("Password"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a password";
                        }
                        if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Confirm Password
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: _inputDecoration("Confirm Password"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please confirm your password";
                        }
                        if (value != _passwordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    if (_selectedRole == 'admin') ...[
                      TextFormField(
                        controller: _adminCodeController,
                        obscureText: true,
                        decoration: _inputDecoration("Admin Access Code"),
                        validator: (value) {
                          if (_selectedRole != 'admin') return null;
                          if (value == null || value.isEmpty) {
                            return "Please enter the admin access code";
                          }
                          if (value.trim() != _adminAccessCode) {
                            return "Invalid admin access code";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Register button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding:
                          const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                            AlwaysStoppedAnimation<Color>(
                                Colors.white),
                          ),
                        )
                            : const Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: _goToLogin,
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade300,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}
