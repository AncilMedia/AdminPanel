import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../Controller/User_controller.dart';
import '../../View_model/Authentication_state.dart';
import '../../View_model/Custom_snackbar.dart';

class AddUserDialog extends StatefulWidget {
  final VoidCallback onSave;

  const AddUserDialog({
    super.key,
    required this.onSave,
  });

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;

  bool obscureText = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context, listen: false);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        // Constraining width for a better web/desktop admin feel
        width: 450,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 30,
              offset: const Offset(0, 15),
            )
          ],
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Close Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Add New User",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey.shade900,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Iconsax.close_circle, color: Colors.grey),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(height: 32, thickness: 1),

                // Username Field
                _buildLabel("Username"),
                _modernTextField(
                  controller: usernameController,
                  hint: "JohnDoe",
                  icon: Iconsax.user,
                  validator: (v) => v == null || v.isEmpty ? 'Please enter a username' : null,
                ),

                // Email Field
                _buildLabel("Email Address"),
                _modernTextField(
                  controller: emailController,
                  hint: "john@example.com",
                  icon: Iconsax.sms,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
                    }
                    return null;
                  },
                ),

                // Phone Field
                _buildLabel("Phone Number"),
                _modernTextField(
                  controller: phoneController,
                  hint: "+1 234 567 890",
                  icon: Iconsax.call,
                  inputType: TextInputType.phone,
                  formatters: [FilteringTextInputFormatter.allow(RegExp(r'^\+?[0-9]*$'))],
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) return 'Enter valid phone number';
                    }
                    return null;
                  },
                ),

                // Password Field
                _buildLabel("Secure Password"),
                _modernTextField(
                  controller: passwordController,
                  hint: "••••••••",
                  icon: Iconsax.lock,
                  obscure: obscureText,
                  suffix: IconButton(
                    icon: Icon(obscureText ? Iconsax.eye_slash : Iconsax.eye, size: 20, color: Colors.grey),
                    onPressed: () => setState(() => obscureText = !obscureText),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Please enter a password' : null,
                ),

                const SizedBox(height: 32),

                // Action Buttons Row
                _buildActionButtons(authState),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= MODERN STYLING COMPONENTS =================

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.blueGrey.shade700
        ),
      ),
    );
  }

  Widget _modernTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
    String? Function(String?)? validator,
    TextInputType? inputType,
    List<TextInputFormatter>? formatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: inputType,
        inputFormatters: formatters,
        validator: validator,
        style: GoogleFonts.poppins(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, size: 20, color: Colors.teal.shade400),
          suffixIcon: suffix,
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.shade200)
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.teal.shade400, width: 1.5)
          ),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.redAccent)
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _buildActionButtons(AuthState authState) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(
                "Cancel",
                style: GoogleFonts.poppins(color: Colors.blueGrey, fontWeight: FontWeight.w600)
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal.shade400,
              padding: const EdgeInsets.symmetric(vertical: 20),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: isSaving ? null : () => _handleSave(authState),
            child: isSaving
                ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
            )
                : Text(
                "Create User",
                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSave(AuthState authState) async {
    if (_formKey.currentState!.validate()) {
      final username = usernameController.text.trim();
      final email = emailController.text.trim();
      final phone = phoneController.text.trim();
      final password = passwordController.text;

      if (email.isEmpty && phone.isEmpty) {
        // Assuming your custom snackbar helper is globally available
        showCustomSnackBar(context, 'Please enter an email or phone number', false);
        return;
      }

      setState(() => isSaving = true);
      try {
        final result = await UserController.createUser(
          authState: authState,
          username: username,
          email: email,
          phone: phone,
          password: password,
        );

        if (result['success'] == true) {
          widget.onSave();
          Navigator.pop(context);
          showCustomSnackBar(context, "User $username added successfully!", true);
        } else {
          showCustomSnackBar(context, result['message'] ?? 'Failed to create user', false);
        }
      } catch (e) {
        showCustomSnackBar(context, 'Something went wrong. Please try again.', false);
      } finally {
        if (mounted) setState(() => isSaving = false);
      }
    }
  }
}