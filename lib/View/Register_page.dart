import 'package:ancilmediaadminpanel/View/Login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';

import '../Controller/Signup_controller.dart';
import '../View_model/Custom_snackbar.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final usernameController = TextEditingController();
  final orgnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool obscureText = true;
  bool obscureConfirmText = true;

  @override
  void dispose() {
    usernameController.dispose();
    orgnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Decorative background
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.cyan.shade100, Colors.purple.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.cyan.withOpacity(0.1),
              ),
            ),
          ),

          // Sign up form
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              constraints: BoxConstraints(
                minHeight: 400,
                maxHeight: screenHeight * 0.85,
                maxWidth: screenWidth < 600
                    ? screenWidth * 0.85
                    : screenWidth * 0.25,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.grey.shade100,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Username
                      TextFormField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Username',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter your username'
                            : null,
                      ),
                      const SizedBox(height: 20),

                      // Organization
                      TextFormField(
                        controller: orgnameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Organization',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter your organization name'
                            : null,
                      ),
                      const SizedBox(height: 20),

                      // Email
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          final emailRegex = RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Phone
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\+?[0-9]*$')),
                        ],
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Phone Number',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter your phone number'
                            : !RegExp(r'^\+?[0-9]{10,15}$')
                            .hasMatch(value)
                            ? 'Enter a valid phone number'
                            : null,
                      ),
                      const SizedBox(height: 20),

                      // Password
                      TextFormField(
                        controller: passwordController,
                        obscureText: obscureText,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Password',
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureText
                                  ? Iconsax.eye_slash
                                  : Iconsax.eye,
                              color: Colors.grey,
                            ),
                            onPressed: () =>
                                setState(() => obscureText = !obscureText),
                          ),
                        ),
                        validator: (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter your password'
                            : null,
                      ),
                      const SizedBox(height: 20),

                      // Confirm Password
                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: obscureConfirmText,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Confirm Password',
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureConfirmText
                                  ? Iconsax.eye_slash
                                  : Iconsax.eye,
                              color: Colors.grey,
                            ),
                            onPressed: () => setState(() =>
                            obscureConfirmText = !obscureConfirmText),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 25),

                      // Submit Button
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () async {
                            if (_isLoading) return;

                            if (_formKey.currentState!.validate()) {
                              setState(() => _isLoading = true);

                              final result =
                              await SignupController.signup(
                                username:
                                usernameController.text.trim(),
                                organization:
                                orgnameController.text.trim(),
                                email: emailController.text.trim(),
                                phone: phoneController.text.trim(),
                                password: passwordController.text,
                              );

                              setState(() => _isLoading = false);

                              if (result['success']) {
                                final user = result['user'];
                                final org = user['organization'];
                                print(
                                    "Signup Success: Org ID: ${org['orgId']}, Created At: ${org['createdAt']}");

                                showCustomSnackBar(
                                    context, "Signup successful!", true);

                                await Future.delayed(
                                    const Duration(seconds: 2));
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const LoginPage()),
                                );
                              } else {
                                print("Signup error response: ${result['message']}");
                                showCustomSnackBar(
                                  context,
                                  result['message'] ??
                                      "Signup failed. Please try again.",
                                  false,
                                );
                              }
                            }
                          },
                          child: Container(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 16),
                            constraints: BoxConstraints(
                              minWidth: 120,
                              maxWidth: screenWidth < 600
                                  ? double.infinity
                                  : screenWidth * 0.2,
                            ),
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.cyan.shade200,
                            ),
                            child: Center(
                              child: _isLoading
                                  ? Lottie.asset(
                                'assets/Circular_moving_dot.json',
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              )
                                  : Text(
                                'Sign Up',
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Sign in prompt
                      Wrap(
                        children: [
                          Text(
                            "Already have an account? ",
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const LoginPage()),
                                );
                              },
                              child: Text(
                                "Sign In",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.purple,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
