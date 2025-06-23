import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../Controller/User_controller.dart';
import '../../Model/User_Model.dart';
import '../../View_model/Authentication_state.dart';

class Block_User extends StatefulWidget {
  final UserModel user;
  final VoidCallback onSave;

  const Block_User({
    super.key,
    required this.user,
    required this.onSave,
  });

  @override
  State<Block_User> createState() => _Block_UserState();
}

class _Block_UserState extends State<Block_User> {
  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context, listen: false);

    return AlertDialog(
      title: Text(
        widget.user.blocked ? 'Unblock User' : 'Block User',
        style: GoogleFonts.poppins(
          textStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
      content: Text(
        widget.user.blocked
            ? 'Are you sure you want to unblock this user?'
            : 'Are you sure you want to block this user?',
        style: GoogleFonts.poppins(
          textStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
      actions: [
        Row(
          children: [
            // Close Button
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Close",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Confirm Button
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: isSaving
                    ? null
                    : () async {
                  setState(() {
                    isSaving = true;
                  });

                  final success = await UserController.updateBlockStatus(
                    authState: authState,
                    userId: widget.user.id,
                    block: !widget.user.blocked,
                  );

                  setState(() {
                    isSaving = false;
                  });

                  if (success) widget.onSave();
                  Navigator.pop(context);
                },
                child: isSaving
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : Text(
                  widget.user.blocked ? "Yes, Unblock" : "Yes, Block",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
