import 'dart:math';
import 'package:ancilmediaadminpanel/View/Mainlayout.dart';
import 'package:ancilmediaadminpanel/View/Register_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Controller/Login_controller.dart';
import '../View_model/Splash_Animation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  List<Offset> _dotPositions = [];
  late AnimationController _controller;

  List<Offset> _generateDotPositions(double width, double height, int count) {
    final random = Random();
    return List.generate(count, (_) {
      return Offset(
        random.nextDouble() * width,
        random.nextDouble() * height,
      );
    });
  }

  Future<void> _checkIfAlreadyLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final refreshToken = prefs.getString('refreshToken');

    if (accessToken != null && accessToken.isNotEmpty) {
      print("✅ Access token found. Navigating to MainLayout...");
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainLayout()),
        );
      }
    } else if (refreshToken != null && refreshToken.isNotEmpty) {
      print("🟡 Only refresh token found. Attempting to refresh...");
      final newAccessToken = await AuthService().refreshAccessToken();
      if (newAccessToken != null) {
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainLayout()),
          );
        }
      } else {
        print("🔴 Refresh token expired or invalid.");
      }
    } else {
      print("❌ No tokens found. Stay on login page.");
    }
  }


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      setState(() {
        _dotPositions = _generateDotPositions(size.width, size.height, 250);
      });
      _checkIfAlreadyLoggedIn(); // 🟢 Check token after dot generation
    });
  }


  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final username = usernameController.text.trim();
    final password = passwordController.text;

    final result = await AuthService().login(username, password);

    if (result != null && result['accessToken'] != null) {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainLayout()),
        );
      }
    } else {
      // Show error snackbar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Login failed. Invalid credentials."),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bool isWideScreen = screenWidth > 800;

    return Scaffold(
      body: Stack(
        children: [
          // Background Dots
          CustomPaint(
            painter: BackgroundDotsPainter(positions: _dotPositions),
            size: Size(screenWidth, screenHeight),
          ),

          // Decorative Circles
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

          // Animated Splash Painter (only on wide screens)
          if (isWideScreen)
            AnimatedBuilder(
              animation: _controller,
              builder: (_, __) {
                final progress = sin(_controller.value * 2 * pi);
                return Positioned(
                  top: screenHeight * 0.150,
                  left: screenWidth * 0.2,
                  child: CustomPaint(
                    painter: SplashPainter(progress: progress),
                    size: Size(screenWidth * 0.6, screenHeight * 0.750),
                  ),
                );
              },
            ),

          // Center login form
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
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
              height: screenHeight * 0.5,
              width: screenWidth < 600 ? screenWidth * 0.85 : screenWidth * 0.25,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Username Field
                    TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Username',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),

                    // Password Field
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
                            obscureText ? Iconsax.eye_slash : Iconsax.eye,
                            color: Colors.grey,
                          ),
                          tooltip: obscureText ? 'Show password' : 'Hide password',
                          onPressed: () {
                            setState(() {
                              obscureText = !obscureText;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),

                    // Submit Button
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            print("Pressed submit button in login page");
                            print("Username: ${usernameController.text}");
                            print("Password: ${passwordController.text}");
                            _handleLogin();
                          }
                        },

                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          constraints: BoxConstraints(
                            minWidth: 120,
                            maxWidth: screenWidth < 600 ? double.infinity : screenWidth * 0.2,
                          ),
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.cyan.shade200,
                          ),
                          child: Center(
                            child: Text(
                              'Submit',
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
                    const SizedBox(height: 25),
                    Wrap(
                      children: [
                        Text("Don't Have an Account?",style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 16
                          )
                        ),),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: (){
                              print("Pressed signup in login");
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>SignupPage()));
                            },
                            child: Text("SignUp",style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.purple,
                                fontWeight: FontWeight.w600
                              )
                            ),),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
