// import 'package:ancilmediaadminpanel/View/Login_page.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:lottie/lottie.dart';
//
// import '../Controller/Signup_controller.dart';
// import '../View_model/Custom_snackbar.dart';
//
// class SignupPage extends StatefulWidget {
//   const SignupPage({super.key});
//
//   @override
//   State<SignupPage> createState() => _SignupPageState();
// }
//
// class _SignupPageState extends State<SignupPage> {
//   final usernameController = TextEditingController();
//   final orgnameController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();
//   final phoneController = TextEditingController();
//
//   final _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;
//   bool obscureText = true;
//   bool obscureConfirmText = true;
//
//   @override
//   void dispose() {
//     usernameController.dispose();
//     orgnameController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     phoneController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Decorative background
//           Positioned(
//             top: -100,
//             left: -100,
//             child: Container(
//               width: 300,
//               height: 300,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 gradient: LinearGradient(
//                   colors: [Colors.cyan.shade100, Colors.purple.shade100],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: -50,
//             right: -80,
//             child: Container(
//               width: 200,
//               height: 200,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.cyan.withOpacity(0.1),
//               ),
//             ),
//           ),
//
//           // Sign up form
//           Center(
//             child: Container(
//               padding: const EdgeInsets.all(20),
//               constraints: BoxConstraints(
//                 minHeight: 400,
//                 maxHeight: screenHeight * 0.85,
//                 maxWidth: screenWidth < 600
//                     ? screenWidth * 0.85
//                     : screenWidth * 0.25,
//               ),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(25),
//                 color: Colors.grey.shade100,
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 10,
//                     offset: Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: SingleChildScrollView(
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     children: [
//                       // Username
//                       TextFormField(
//                         controller: usernameController,
//                         decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           labelText: 'Username',
//                           filled: true,
//                           fillColor: Colors.white,
//                         ),
//                         validator: (value) => value == null || value.isEmpty
//                             ? 'Please enter your username'
//                             : null,
//                       ),
//                       const SizedBox(height: 20),
//
//                       // Organization
//                       TextFormField(
//                         controller: orgnameController,
//                         decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           labelText: 'Organization',
//                           filled: true,
//                           fillColor: Colors.white,
//                         ),
//                         validator: (value) => value == null || value.isEmpty
//                             ? 'Please enter your organization name'
//                             : null,
//                       ),
//                       const SizedBox(height: 20),
//
//                       // Email
//                       TextFormField(
//                         controller: emailController,
//                         keyboardType: TextInputType.emailAddress,
//                         decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           labelText: 'Email',
//                           filled: true,
//                           fillColor: Colors.white,
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter your email';
//                           }
//                           final emailRegex = RegExp(
//                             r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
//                           );
//                           if (!emailRegex.hasMatch(value)) {
//                             return 'Please enter a valid email address';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 20),
//
//                       // Phone
//                       TextFormField(
//                         controller: phoneController,
//                         keyboardType: TextInputType.phone,
//                         inputFormatters: [
//                           FilteringTextInputFormatter.allow(
//                             RegExp(r'^\+?[0-9]*$'),
//                           ),
//                         ],
//                         decoration: const InputDecoration(
//                           border: OutlineInputBorder(),
//                           labelText: 'Phone Number',
//                           filled: true,
//                           fillColor: Colors.white,
//                         ),
//                         validator: (value) => value == null || value.isEmpty
//                             ? 'Please enter your phone number'
//                             : !RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)
//                             ? 'Enter a valid phone number'
//                             : null,
//                       ),
//                       const SizedBox(height: 20),
//
//                       // Password
//                       TextFormField(
//                         controller: passwordController,
//                         obscureText: obscureText,
//                         decoration: InputDecoration(
//                           border: const OutlineInputBorder(),
//                           labelText: 'Password',
//                           filled: true,
//                           fillColor: Colors.white,
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               obscureText ? Iconsax.eye_slash : Iconsax.eye,
//                               color: Colors.grey,
//                             ),
//                             onPressed: () =>
//                                 setState(() => obscureText = !obscureText),
//                           ),
//                         ),
//                         validator: (value) => value == null || value.isEmpty
//                             ? 'Please enter your password'
//                             : null,
//                       ),
//                       const SizedBox(height: 20),
//
//                       // Confirm Password
//                       TextFormField(
//                         controller: confirmPasswordController,
//                         obscureText: obscureConfirmText,
//                         decoration: InputDecoration(
//                           border: const OutlineInputBorder(),
//                           labelText: 'Confirm Password',
//                           filled: true,
//                           fillColor: Colors.white,
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               obscureConfirmText
//                                   ? Iconsax.eye_slash
//                                   : Iconsax.eye,
//                               color: Colors.grey,
//                             ),
//                             onPressed: () => setState(
//                               () => obscureConfirmText = !obscureConfirmText,
//                             ),
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please confirm your password';
//                           }
//                           if (value != passwordController.text) {
//                             return 'Passwords do not match';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 25),
//
//                       // Submit Button
//                       MouseRegion(
//                         cursor: SystemMouseCursors.click,
//                         child: GestureDetector(
//                           onTap: () async {
//                             if (_isLoading) return;
//
//                             if (_formKey.currentState!.validate()) {
//                               setState(() => _isLoading = true);
//
//                               final result = await SignupController.signup(
//                                 username: usernameController.text.trim(),
//                                 organization: orgnameController.text.trim(),
//                                 email: emailController.text.trim(),
//                                 phone: phoneController.text.trim(),
//                                 password: passwordController.text,
//                               );
//
//                               setState(() => _isLoading = false);
//
//                               if (result['success']) {
//                                 final user = result['user'];
//                                 final org = user['organization'];
//                                 print(
//                                   "Signup Success: Org ID: ${org['orgId']}, Created At: ${org['createdAt']}",
//                                 );
//
//                                 showCustomSnackBar(
//                                   context,
//                                   "Signup successful!",
//                                   true,
//                                 );
//
//                                 await Future.delayed(
//                                   const Duration(seconds: 2),
//                                 );
//                                 Navigator.pushReplacement(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => const LoginPage(),
//                                   ),
//                                 );
//                               } else {
//                                 print(
//                                   "Signup error response: ${result['message']}",
//                                 );
//                                 showCustomSnackBar(
//                                   context,
//                                   result['message'] ??
//                                       "Signup failed. Please try again.",
//                                   false,
//                                 );
//                               }
//                             }
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 16),
//                             constraints: BoxConstraints(
//                               minWidth: 120,
//                               maxWidth: screenWidth < 600
//                                   ? double.infinity
//                                   : screenWidth * 0.2,
//                             ),
//                             height: 45,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(15),
//                               color: Colors.cyan.shade200,
//                             ),
//                             child: Center(
//                               child: _isLoading
//                                   ? Lottie.asset(
//                                       'assets/Circular_moving_dot.json',
//                                       width: 40,
//                                       height: 40,
//                                       fit: BoxFit.cover,
//                                     )
//                                   : Text(
//                                       'Sign Up',
//                                       style: GoogleFonts.poppins(
//                                         textStyle: const TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 18,
//                                         ),
//                                       ),
//                                     ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//
//                       // Sign in prompt
//                       Wrap(
//                         children: [
//                           Text(
//                             "Already have an account? ",
//                             style: GoogleFonts.poppins(fontSize: 16),
//                           ),
//                           MouseRegion(
//                             cursor: SystemMouseCursors.click,
//                             child: GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => const LoginPage(),
//                                   ),
//                                 );
//                               },
//                               child: Text(
//                                 "Sign In",
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 16,
//                                   color: Colors.purple,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../View/Login_page.dart';
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
  final otpController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool obscureText = true;
  bool obscureConfirmText = true;
  bool isPhoneVerified = false;
  bool isEmailSent = false;
  bool isEmailVerified = false;

  String? _verificationId;

  @override
  void dispose() {
    usernameController.dispose();
    orgnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  Future<void> verifyPhone() async {
    String phone = phoneController.text.trim();
    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(phone)) {
      showCustomSnackBar(context, "Enter valid phone number", false);
      return;
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        setState(() => isPhoneVerified = true);
        showCustomSnackBar(context, "Phone auto-verified", true);
      },
      verificationFailed: (e) {
        showCustomSnackBar(context, e.message ?? "Phone verification failed", false);
      },
      codeSent: (verificationId, resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
        showCustomSnackBar(context, "OTP sent to $phone", true);
      },
      codeAutoRetrievalTimeout: (verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  Future<void> submitOtp() async {
    if (_verificationId == null) return;

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otpController.text.trim(),
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      setState(() => isPhoneVerified = true);
      showCustomSnackBar(context, "Phone verified successfully", true);
    } catch (e) {
      showCustomSnackBar(context, "Invalid OTP", false);
    }
  }

  Future<void> sendEmailVerification() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      final user = FirebaseAuth.instance.currentUser;

      await user?.sendEmailVerification();
      setState(() => isEmailSent = true);
      showCustomSnackBar(context, "Verification email sent", true);
    } catch (e) {
      showCustomSnackBar(context, "Email already in use or invalid", false);
    }
  }

  Future<void> checkEmailVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.reload();

    if (user != null && user.emailVerified) {
      setState(() => isEmailVerified = true);
      showCustomSnackBar(context, "Email verified!", true);
    } else {
      showCustomSnackBar(context, "Email not verified yet", false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
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
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              constraints: BoxConstraints(
                minHeight: 400,
                maxHeight: screenHeight * 0.9,
                maxWidth: screenWidth < 600 ? screenWidth * 0.85 : screenWidth * 0.4,
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
                      _buildTextField("Username", usernameController),
                      const SizedBox(height: 20),
                      _buildTextField("Organization", orgnameController),
                      const SizedBox(height: 20),
                      _buildTextField("Email", emailController, inputType: TextInputType.emailAddress),
                      if (!isEmailVerified)
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: isEmailSent ? checkEmailVerified : sendEmailVerification,
                              child: Text(isEmailSent ? "Check Email Verified" : "Send Verification"),
                            ),
                            if (isEmailVerified)
                              const Icon(Icons.verified, color: Colors.green)
                          ],
                        ),
                      const SizedBox(height: 20),
                      _buildTextField("Phone Number", phoneController, inputType: TextInputType.phone),
                      if (!isPhoneVerified)
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: verifyPhone,
                              child: const Text("Send OTP"),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: otpController,
                                decoration: const InputDecoration(labelText: "Enter OTP"),
                              ),
                            ),
                            IconButton(
                              onPressed: submitOtp,
                              icon: const Icon(Icons.check_circle, color: Colors.green),
                            ),
                          ],
                        ),
                      if (isPhoneVerified)
                        Row(
                          children: const [
                            Icon(Icons.verified, color: Colors.green),
                            SizedBox(width: 5),
                            Text("Phone Verified")
                          ],
                        ),
                      const SizedBox(height: 20),
                      _buildPasswordField("Password", passwordController, true),
                      const SizedBox(height: 20),
                      _buildPasswordField("Confirm Password", confirmPasswordController, false),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: (!isEmailVerified || !isPhoneVerified || _isLoading)
                            ? null
                            : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => _isLoading = true);
                            // Save to DB or Backend here if needed
                            showCustomSnackBar(context, "Registered successfully", true);
                            await Future.delayed(const Duration(seconds: 2));
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (_) => const LoginPage()));
                          }
                        },
                        child: Container(
                          height: 45,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: (!isPhoneVerified || !isEmailVerified)
                                ? Colors.grey
                                : Colors.cyan.shade400,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: _isLoading
                                ? Lottie.asset('assets/Circular_moving_dot.json', width: 40, height: 40)
                                : Text(
                              'Sign Up',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        children: [
                          Text("Already have an account? ", style: GoogleFonts.poppins(fontSize: 16)),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => const LoginPage()));
                            },
                            child: Text("Sign In",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.purple,
                                  fontWeight: FontWeight.w600,
                                )),
                          )
                        ],
                      )
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

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType inputType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: const OutlineInputBorder(),
      ),
      validator: (value) => value == null || value.isEmpty ? 'Please enter $label' : null,
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, bool isMain) {
    return TextFormField(
      controller: controller,
      obscureText: isMain ? obscureText : obscureConfirmText,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            isMain
                ? (obscureText ? Iconsax.eye_slash : Iconsax.eye)
                : (obscureConfirmText ? Iconsax.eye_slash : Iconsax.eye),
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              if (isMain) {
                obscureText = !obscureText;
              } else {
                obscureConfirmText = !obscureConfirmText;
              }
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Enter $label';
        if (!isMain && value != passwordController.text) return 'Passwords do not match';
        return null;
      },
    );
  }
}
