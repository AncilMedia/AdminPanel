import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../Controller/User_controller.dart';
import '../../Model/User_Model.dart';
import '../../View_model/Authentication_state.dart';
import '../../View_model/Custom_snackbar.dart';

class EditUserDialog extends StatefulWidget {
  final UserModel user;
  final VoidCallback onSave;

  const EditUserDialog({
    super.key,
    required this.user,
    required this.onSave,
  });

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  final _formKey = GlobalKey<FormState>();
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.user.username);
    emailController = TextEditingController(text: widget.user.email);
    phoneController = TextEditingController(text: widget.user.phone);
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context, listen: false);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 450, // Fixed width for dashboard consistency
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
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Edit User Profile",
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

                _buildLabel("Username"),
                _modernTextField(
                  controller: usernameController,
                  hint: "JohnDoe",
                  icon: Iconsax.user,
                  validator: (v) => v == null || v.isEmpty ? 'Please enter username' : null,
                ),

                _buildLabel("Email Address"),
                _modernTextField(
                  controller: emailController,
                  hint: "email@example.com",
                  icon: Iconsax.sms,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value)) return 'Enter valid email';
                    }
                    return null;
                  },
                ),

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

                const SizedBox(height: 32),

                // Actions
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
    String? Function(String?)? validator,
    TextInputType? inputType,
    List<TextInputFormatter>? formatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        inputFormatters: formatters,
        validator: validator,
        style: GoogleFonts.poppins(fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, size: 20, color: Colors.teal.shade400),
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade200)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.teal.shade400, width: 1.5)),
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
            child: Text("Cancel", style: GoogleFonts.poppins(color: Colors.blueGrey, fontWeight: FontWeight.w600)),
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
            onPressed: isSaving ? null : () => _handleUpdate(authState),
            child: isSaving
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text("Update Profile", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Future<void> _handleUpdate(AuthState authState) async {
    if (_formKey.currentState!.validate()) {
      setState(() => isSaving = true);

      try {
        final result = await UserController.updateUser(
          authState: authState,
          userId: widget.user.id,
          username: usernameController.text.trim(),
          email: emailController.text.trim(),
          phone: phoneController.text.trim(),
        );

        if (result['success'] == true) {
          widget.onSave();
          Navigator.pop(context);
          showCustomSnackBar(context, "User details updated!", true);
        } else {
          showCustomSnackBar(context, result['message'] ?? 'Update failed', false);
        }
      } catch (e) {
        showCustomSnackBar(context, "Something went wrong", false);
      } finally {
        if (mounted) setState(() => isSaving = false);
      }
    }
  }
}