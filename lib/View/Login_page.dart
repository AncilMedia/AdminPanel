import 'dart:math';
import 'package:ancilmediaadminpanel/View/Mainlayout.dart';
import 'package:ancilmediaadminpanel/View/Register_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Controller/Login_controller.dart';
import '../View_model/Custom_snackbar.dart';
import '../View_model/Splash_Animation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  List<Offset> _dotPositions = [];
  late AnimationController _controller;
  bool _isLoading = false;

  List<Offset> _generateDotPositions(double width, double height, int count) {
    final random = Random();
    return List.generate(count, (_) {
      return Offset(random.nextDouble() * width, random.nextDouble() * height);
    });
  }

  Future<void> _checkIfAlreadyLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final refreshToken = prefs.getString('refreshToken');

    if (accessToken != null && accessToken.isNotEmpty) {
      print("Access token found. Navigating to MainLayout...");
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainLayout()),
        );
      }
    } else if (refreshToken != null && refreshToken.isNotEmpty) {
      print("Only refresh token found. Attempting to refresh...");
      final newAccessToken = await AuthService().refreshAccessToken();
      if (newAccessToken != null) {
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainLayout()),
          );
        }
      } else {
        print("Refresh token expired or invalid.");
      }
    } else {
      print("No tokens found. Stay on login page.");
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
      _checkIfAlreadyLoggedIn();
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
    setState(() {
      _isLoading = true;
    });

    final username = usernameController.text.trim();
    final password = passwordController.text;

    final result = await AuthService().login(username, password);

    setState(() {
      _isLoading = false;
    });

    final status = result['status'];
    final parsed = result['parsed'];

    if (status == 200 && parsed['accessToken'] != null) {
      if (!context.mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainLayout()),
      );
    } else {
      if (!context.mounted) return;

      final errorMessage =
          parsed['error'] ??
          parsed['message'] ??
          "Login failed. Please try again.";

      showCustomSnackBar(context, errorMessage, false);
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
          CustomPaint(
            painter: BackgroundDotsPainter(positions: _dotPositions),
            size: Size(screenWidth, screenHeight),
          ),
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
              width: screenWidth < 600
                  ? screenWidth * 0.85
                  : screenWidth * 0.25,
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
                          tooltip: obscureText
                              ? 'Show password'
                              : 'Hide password',
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
                    _isLoading
                        ? SizedBox(
                            height: 50,
                            width: 50,
                            child: Lottie.asset(
                              'assets/signin_button.json',
                              fit: BoxFit.cover,
                            ),
                          )
                        : MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  _handleLogin();
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 120,
                                  maxWidth: screenWidth < 600
                                      ? double.infinity
                                      : screenWidth * 0.2,
                                ),
                                height: 45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.cyan.shade200,
                                ),
                                child: Center(
                                  child: Text(
                                    'Sign In',
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
                        Text(
                          "Don't Have an Account?",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(fontSize: 16),
                          ),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              print("Pressed signup in login");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignupPage(),
                                ),
                              );
                            },
                            child: Text(
                              "SignUp",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.purple,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
