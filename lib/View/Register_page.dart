import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';

import '../View/Login_page.dart';
import '../View_model/Custom_snackbar.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final otpController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  bool obscureConfirmText = true;
  bool _isLoading = false;
  bool otpSent = false;
  String? _verificationId;

  final auth = FirebaseAuth.instance;

  Future<void> _sendOtp() async {
    final phone = '+91${phoneController.text.trim()}';
    setState(() => _isLoading = true);

    await auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (_) {},
      verificationFailed: (e) {
        showCustomSnackBar(context, e.message ?? "Phone verification failed", false);
        setState(() => _isLoading = false);
      },
      codeSent: (vId, _) {
        _verificationId = vId;
        setState(() {
          otpSent = true;
          _isLoading = false;
        });
        showCustomSnackBar(context, "OTP sent to $phone", true);
      },
      codeAutoRetrievalTimeout: (vId) => _verificationId = vId,
    );
  }

  Future<void> _verifyOtpAndSignUp() async {
    if (_verificationId == null || otpController.text.trim().isEmpty) {
      showCustomSnackBar(context, "Enter the OTP", false);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otpController.text.trim(),
      );
      await auth.signInWithCredential(credential);

      // After phone auth, optionally link email/password if needed.
      final user = auth.currentUser;
      if (user != null) {
        await user.updateEmail(emailController.text.trim());
        await user.updatePassword(passwordController.text);
        if (!user.emailVerified) {
          await user.sendEmailVerification();
        }

        showCustomSnackBar(context, "Signup successful! Verification email sent.", true);
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    } catch (e) {
      showCustomSnackBar(context, "Invalid OTP", false);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Container(
              width: screenWidth < 600 ? screenWidth * 0.9 : 400,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [BoxShadow(blurRadius: 12, color: Colors.black12)],
              ),
              child: Column(
                children: [
                  _buildTextField(usernameController, 'Username', false,
                          (v) => v!.isEmpty ? 'Enter username' : null),
                  const SizedBox(height: 16),
                  _buildTextField(emailController, 'Email', false, (v) {
                    if (v == null || v.isEmpty) return 'Enter email';
                    final regex = RegExp(r"^[\w\.\-+%]+@[\w\.\-]+\.\w+$");
                    return regex.hasMatch(v) ? null : 'Enter valid email';
                  }),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            bottomLeft: Radius.circular(4),
                          ),
                        ),
                        child: const Text('+91'),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(4),
                                bottomRight: Radius.circular(4),
                              ),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Enter phone number';
                            return v.length == 10 ? null : 'Enter 10-digit number';
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (otpSent)
                    _buildTextField(otpController, 'Enter OTP', true, (v) {
                      if (v == null || v.isEmpty) return 'Enter OTP';
                      return null;
                    }),
                  if (otpSent) const SizedBox(height: 16),
                  _buildTextField(passwordController, 'Password', obscureText,
                          (v) => v!.isEmpty ? 'Enter password' : null),
                  const SizedBox(height: 16),
                  _buildTextField(confirmPasswordController, 'Confirm Password',
                      obscureConfirmText, (v) {
                        if (v == null || v.isEmpty) return 'Confirm password';
                        return v != passwordController.text ? 'Passwords do not match' : null;
                      }),
                  const SizedBox(height: 24),
                  _isLoading
                      ? Lottie.asset('assets/Circular_moving_dot.json', width: 40)
                      : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan.shade400,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (!otpSent) {
                          _sendOtp();
                        } else {
                          _verifyOtpAndSignUp();
                        }
                      }
                    },
                    child: Text(
                      otpSent ? 'Verify OTP & Sign Up' : 'Send OTP',
                      style: GoogleFonts.poppins(
                        textStyle:
                        const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account? ", style: GoogleFonts.poppins()),
                      InkWell(
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                        ),
                        child: Text("Sign In",
                            style: GoogleFonts.poppins(
                                color: Colors.purple, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label, bool obscure,
      String? Function(String?)? validator) {
    return TextFormField(
      controller: ctrl,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: const OutlineInputBorder(),
        suffixIcon: (label.toLowerCase().contains("password"))
            ? IconButton(
          icon: Icon(
              label == "Password"
                  ? (obscureText ? Iconsax.eye_slash : Iconsax.eye)
                  : (obscureConfirmText ? Iconsax.eye_slash : Iconsax.eye),
              color: Colors.grey),
          onPressed: () => setState(() {
            if (label == "Password") {
              obscureText = !obscureText;
            } else {
              obscureConfirmText = !obscureConfirmText;
            }
          }),
        )
            : null,
      ),
      validator: validator,
    );
  }
}
