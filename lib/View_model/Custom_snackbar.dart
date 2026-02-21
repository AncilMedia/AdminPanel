import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

void showCustomSnackBar(BuildContext context, String message, bool isSuccess) {
  // Clear any existing snackbars first to prevent "stacking"
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      // The margin makes it "not touch anywhere"
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50), // Fully curved sides
          gradient: LinearGradient(
            colors: isSuccess
                ? [const Color(0xFF2E3192), const Color(0xFF1BFFFF)] // Modern Blue/Cyan Success
                : [const Color(0xFFD4145A), const Color(0xFFFBB03B)], // Modern Pink/Orange Error
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSuccess ? Iconsax.tick_circle : Iconsax.info_circle,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
      duration: const Duration(seconds: 3),
    ),
  );
}