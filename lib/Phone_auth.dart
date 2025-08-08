
import 'dart:convert';

import 'package:ancilmediaadminpanel/environmental%20variables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:http/http.dart' as http;

import 'Model/User_Model.dart';
import 'Services/api_client.dart';
import 'View_model/Authentication_state.dart';


class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({super.key});
  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  String verificationId = '';
  bool otpSent = false;
  bool loading = false;

  Future<void> sendOTP() async {
    setState(() => loading = true);
    final phone = phoneController.text.trim();

    if (kIsWeb) {
      // ✅ Web reCAPTCHA setup with correct auth instance
      final verifier = RecaptchaVerifier(
        auth: FirebaseAuthPlatform.instance,
        onSuccess: () {
          print('reCAPTCHA Completed!');
        },
        onError: (FirebaseAuthException error) {
          print('reCAPTCHA Failed: $error');
        },
        onExpired: () {
          print('reCAPTCHA Expired!');
        },
      );

      await FirebaseAuth.instance
          .signInWithPhoneNumber(phone, verifier)
          .then((confirmationResult) {
        verificationId = confirmationResult.verificationId;
        otpSent = true;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP sent to your phone.")),
        );
      }).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      });
    } else {
      // ✅ Mobile
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${e.message}")),
          );
        },
        codeSent: (String verId, int? resendToken) {
          verificationId = verId;
          otpSent = true;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("OTP sent.")),
          );
        },
        codeAutoRetrievalTimeout: (String verId) {
          verificationId = verId;
        },
      );
    }

    setState(() => loading = false);
  }

  Future<void> verifyOTP() async {
    setState(() => loading = true);
    final otp = otpController.text.trim();
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Phone Auth Successful")),
      );
    } catch (e) {
      print("Error : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed: ${e.toString()}")),
      );
    }
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Phone Auth")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: "Phone Number (e.g. +911234567890)",
              ),
            ),
            const SizedBox(height: 16),
            if (otpSent)
              TextField(
                controller: otpController,
                decoration: const InputDecoration(labelText: "OTP"),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: otpSent ? verifyOTP : sendOTP,
              child: Text(otpSent ? "Verify OTP" : "Send OTP"),
            ),
          ],
        ),
      ),
    );
  }
}


