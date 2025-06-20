import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../Controller/User_controller.dart';
import '../../Model/User_Model.dart';
import '../../View_model/Authentication_state.dart';

class DeleteUser extends StatelessWidget {
  final UserModel user;
  final VoidCallback onDelete;

  const DeleteUser({
    super.key,
    required this.user,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context, listen: false);

    return AlertDialog(
      title: Text("Confirm Delete",style: GoogleFonts.poppins(
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500
        )
      ),),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'assets/Trash_trash.json',
            height: MediaQuery.of(context).size.height * .12,
            width: MediaQuery.of(context).size.width * .12,
          ),
          const SizedBox(height: 12),
          Text(
            "Are you sure you want to delete ${user.username}?",
            style: GoogleFonts.poppins(fontSize: 15),
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  final success = await UserController.deleteUser(
                    authState: authState,
                    userId: user.id,
                  );
                  if (success) {
                    onDelete(); // refresh list
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to delete user')),
                    );
                  }
                },
                child: Text(
                  "Delete",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
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
