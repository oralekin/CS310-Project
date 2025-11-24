import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    // TODO: backend login isteği yapılacak yer
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isSubmitting = false);

    // başarılı login varsayalım → chat screen'e git
    Navigator.of(context).pushReplacementNamed('/chat');
  }

  void _goToRegister() {
    Navigator.of(context).pushNamed('/register');
  }

  void _goToPasswordReset() {
    Navigator.of(context).pushNamed('/password-reset');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(
        0xFFF3F3F3,
      ), // Figma’daki açık gri fondan yakın
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                // UniConnect başlığı
                const Text(
                  'UniConnect',
                  style: TextStyle(
                    fontSize: 28,
                    fontFamily: "Inter",
                    fontVariations: [FontVariation("wght", 700)],
                  ),
                ),

                const SizedBox(height: 48),

                // Login başlığı
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),

                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // University Mail Address
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'University Mail Address',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your university email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email address';
                          }
                          // İsterseniz burada ".edu" / üniversite domain kontrolü ekleyebilirsiniz
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Password
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Login butonu (siyah)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
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
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Login',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Forgot Password?
                      TextButton(
                        onPressed: _goToPasswordReset,
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.black87, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Alt kısım: "Don’t have an account? Register"
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: _goToRegister,
                      child: Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
