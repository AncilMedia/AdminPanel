// // import 'dart:math';
// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:iconsax/iconsax.dart';
// //
// // import '../View_model/Splash_Animation.dart';
// //
// // class LoginPage extends StatefulWidget {
// //   const LoginPage({super.key});
// //
// //   @override
// //   State<LoginPage> createState() => _LoginPageState();
// // }
// //
// // class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
// //   final usernameController = TextEditingController();
// //   final passwordController = TextEditingController();
// //   final _formKey = GlobalKey<FormState>();
// //
// //   bool obscureText = true;
// //   List<Offset>? _dotPositions;
// //
// //   late AnimationController _controller;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _controller = AnimationController(
// //       vsync: this,
// //       duration: const Duration(seconds: 5),
// //     )..repeat(reverse: true);
// //   }
// //
// //   @override
// //   void dispose() {
// //     _controller.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   void didChangeDependencies() {
// //     super.didChangeDependencies();
// //     if (_dotPositions == null) {
// //       final screenSize = MediaQuery.of(context).size;
// //       _dotPositions = _generateDotPositions(screenSize.width, screenSize.height, 250);
// //     }
// //   }
// //
// //   List<Offset> _generateDotPositions(double width, double height, int count) {
// //     final rand = Random();
// //     return List.generate(
// //       count,
// //           (_) => Offset(rand.nextDouble() * width, rand.nextDouble() * height),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final screenWidth = MediaQuery.of(context).size.width;
// //     final screenHeight = MediaQuery.of(context).size.height;
// //
// //     return Scaffold(
// //       body: Stack(
// //         children: [
// //           if (_dotPositions != null)
// //             CustomPaint(
// //               painter: BackgroundDotsPainter(positions: _dotPositions!),
// //               size: Size(screenWidth, screenHeight),
// //             ),
// //
// //           AnimatedBuilder(
// //             animation: _controller,
// //             builder: (_, __) {
// //               final progress = sin(_controller.value * 2 * pi);
// //               return Positioned(
// //                 top: screenHeight * 0.2,
// //                 left: screenWidth * 0.2,
// //                 child: CustomPaint(
// //                   painter: SplashPainter(progress: progress),
// //                   size: Size(screenWidth * 0.610, screenHeight * 0.660),
// //                 ),
// //               );
// //             },
// //           ),
// //
// //           Center(
// //             child: Container(
// //               padding: const EdgeInsets.all(20),
// //               decoration: BoxDecoration(
// //                 borderRadius: BorderRadius.circular(25),
// //                 color: Colors.grey.shade100,
// //                 boxShadow: [
// //                   BoxShadow(
// //                     color: Colors.black12,
// //                     blurRadius: 10,
// //                     offset: Offset(0, 4),
// //                   )
// //                 ],
// //               ),
// //               height: screenHeight * 0.5,
// //               width: screenWidth < 600 ? screenWidth * 0.85 : screenWidth * 0.25,
// //               child: Form(
// //                 key: _formKey,
// //                 child: Column(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     TextFormField(
// //                       controller: usernameController,
// //                       decoration: const InputDecoration(
// //                         border: OutlineInputBorder(),
// //                         labelText: 'Username',
// //                         filled: true,
// //                         fillColor: Colors.white,
// //                       ),
// //                       validator: (value) =>
// //                       value == null || value.isEmpty ? 'Please enter your username' : null,
// //                     ),
// //                     const SizedBox(height: 25),
// //                     TextFormField(
// //                       controller: passwordController,
// //                       obscureText: obscureText,
// //                       decoration: InputDecoration(
// //                         border: const OutlineInputBorder(),
// //                         labelText: 'Password',
// //                         filled: true,
// //                         fillColor: Colors.white,
// //                         suffixIcon: IconButton(
// //                           icon: Icon(
// //                             obscureText ? Iconsax.eye_slash : Iconsax.eye,
// //                             color: Colors.grey,
// //                           ),
// //                           tooltip: obscureText ? 'Show password' : 'Hide password',
// //                           onPressed: () {
// //                             setState(() {
// //                               obscureText = !obscureText;
// //                             });
// //                           },
// //                         ),
// //                       ),
// //                       validator: (value) =>
// //                       value == null || value.isEmpty ? 'Please enter your password' : null,
// //                     ),
// //                     const SizedBox(height: 25),
// //                     GestureDetector(
// //                       onTap: () {
// //                         if (_formKey.currentState!.validate()) {
// //                           print("Login attempt:");
// //                           print("Username: ${usernameController.text}");
// //                           print("Password: ${passwordController.text}");
// //                         }
// //                       },
// //                       child: Container(
// //                         padding: const EdgeInsets.symmetric(horizontal: 16),
// //                         constraints: BoxConstraints(
// //                           minWidth: 120,
// //                           maxWidth: screenWidth < 600 ? double.infinity : screenWidth * 0.2,
// //                         ),
// //                         height: 45,
// //                         decoration: BoxDecoration(
// //                           borderRadius: BorderRadius.circular(15),
// //                           color: Colors.cyan.shade200,
// //                         ),
// //                         child: Center(
// //                           child: Text(
// //                             'Submit',
// //                             style: GoogleFonts.poppins(
// //                               textStyle: const TextStyle(
// //                                 color: Colors.white,
// //                                 fontSize: 18,
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                     const SizedBox(height: 25),
// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       children: [
// //                         Text(
// //                           "Don't have an account?",
// //                           style: GoogleFonts.poppins(fontSize: 16),
// //                         ),
// //                         const SizedBox(width: 5),
// //                         GestureDetector(
// //                           onTap: () => print("SignUp clicked"),
// //                           child: Text(
// //                             "SignUp",
// //                             style: GoogleFonts.poppins(
// //                               textStyle: const TextStyle(
// //                                 fontSize: 16,
// //                                 color: Colors.purple,
// //                                 fontWeight: FontWeight.w500,
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
//
//
//
// import 'dart:math';
// import 'package:flutter/material.dart';
//
// class SplashPainter extends CustomPainter {
//   final double progress;
//
//   SplashPainter({required this.progress});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final rect = Rect.fromLTWH(0, 0, size.width, size.height);
//
//     final gradient = LinearGradient(
//       colors: [Colors.cyan.shade50, Colors.purple.shade50],
//       begin: Alignment.topLeft,
//       end: Alignment.bottomRight,
//     );
//
//     final paint = Paint()
//       ..shader = gradient.createShader(rect)
//       ..style = PaintingStyle.fill;
//
//     final offset = 20 * progress;
//
//     final path = Path();
//     path.moveTo(size.width * 0.5, size.height * 0.05 + offset);
//
//     path.cubicTo(
//         size.width * 0.6, size.height * -0.1 + offset,
//         size.width * 0.9, size.height * 0.1 + offset,
//         size.width * 0.8, size.height * 0.25 + offset);
//
//     path.cubicTo(
//         size.width * 1.05, size.height * 0.35 + offset,
//         size.width * 0.9, size.height * 0.6 + offset,
//         size.width * 0.75, size.height * 0.55 + offset);
//
//     path.cubicTo(
//         size.width * 0.95, size.height * 0.9 + offset,
//         size.width * 0.6, size.height * 1.05 + offset,
//         size.width * 0.5, size.height * 0.9 + offset);
//
//     path.cubicTo(
//         size.width * 0.45, size.height * 1.15 + offset,
//         size.width * 0.2, size.height * 1.05 + offset,
//         size.width * 0.25, size.height * 0.8 + offset);
//
//     path.cubicTo(
//         size.width * 0.05, size.height * 0.9 + offset,
//         size.width * 0.0, size.height * 0.6 + offset,
//         size.width * 0.2, size.height * 0.5 + offset);
//
//     path.cubicTo(
//         size.width * 0.05, size.height * 0.4 + offset,
//         size.width * 0.0, size.height * 0.2 + offset,
//         size.width * 0.25, size.height * 0.15 + offset);
//
//     path.cubicTo(
//         size.width * 0.3, size.height * -0.05 + offset,
//         size.width * 0.4, size.height * 0.0 + offset,
//         size.width * 0.5, size.height * 0.05 + offset);
//
//     path.close();
//
//     canvas.drawPath(path, paint);
//   }
//
//   @override
//   bool shouldRepaint(covariant SplashPainter oldDelegate) {
//     return oldDelegate.progress != progress;
//   }
// }
//
// class BackgroundDotsPainter extends CustomPainter {
//   final List<Offset> positions;
//   BackgroundDotsPainter({required this.positions});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final gradient = const LinearGradient(
//       colors: [Color(0xFFE0F7FA), Color(0xFFF3E5F5)],
//       begin: Alignment.topLeft,
//       end: Alignment.bottomRight,
//     );
//
//     final shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
//
//     final paint = Paint()
//       ..style = PaintingStyle.fill
//       ..shader = shader;
//
//     for (var pos in positions) {
//       final radius = 1.5 + (pos.dx * pos.dy) % 2.0;
//       canvas.drawCircle(pos, radius, paint);
//     }
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }
