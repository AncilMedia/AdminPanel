
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart'; // 🔹 Added for SharedPreferences
import '../View_model/Authentication_state.dart';
import '../View_model/Custom_snackbar.dart';
import '../View_model/Splash_Animation.dart';
import '../Controller/Login_controller.dart';
import 'Mainlayout.dart';
import 'Register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final identifierController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool obscureText = true;
  bool _isLoading = false;
  List<Offset> _dotPositions = [];

  late AnimationController _bgController;
  late AnimationController _entryController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late AuthState authState;

  final TextStyle baseStyle = GoogleFonts.poppins();

  @override
  void initState() {
    super.initState();

    // 🔹 1. AUTH GUARD: Check if user is already logged in
    _checkExistingAuth();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOutBack,
    ));

    _entryController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      setState(() {
        _dotPositions = _generateDotPositions(size.width, size.height, 120);
      });
      authState = Provider.of<AuthState>(context, listen: false);
    });
  }

  // 🔹 Logic to redirect users who are already logged in
  Future<void> _checkExistingAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('accessToken');
    if (token != null && token.isNotEmpty) {
      if (mounted) {
        // Use go_router or Navigator to move to home
        context.go('/home');
      }
    }
  }

  List<Offset> _generateDotPositions(double width, double height, int count) {
    final random = Random();
    return List.generate(count, (_) => Offset(random.nextDouble() * width, random.nextDouble() * height));
  }

  @override
  void dispose() {
    identifierController.dispose();
    passwordController.dispose();
    _bgController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  // Future<void> _handleLogin() async {
  //   setState(() => _isLoading = true);
  //   final result = await AuthService().login(identifierController.text.trim(), passwordController.text);
  //   setState(() => _isLoading = false);
  //
  //   if (result['status'] == 200 && result['parsed']['accessToken'] != null) {
  //     if (mounted) {
  //       // 🔹 2. Navigate and clear history so they can't "Back" into Login
  //       context.go('/home');
  //     }
  //   } else {
  //     if (mounted) {
  //       showCustomSnackBar(context, result['parsed']['message'] ?? "Login failed", false);
  //     }
  //   }
  // }

  // Future<void> _handleLogin() async {
  //   setState(() => _isLoading = true);
  //
  //   final result = await AuthService()
  //       .login(identifierController.text.trim(), passwordController.text);
  //
  //   setState(() => _isLoading = false);
  //
  //   if (result['status'] == 200 && result['parsed']['accessToken'] != null) {
  //
  //     final prefs = await SharedPreferences.getInstance();
  //
  //     // ✅ Save token immediately
  //     await prefs.setString(
  //         'accessToken', result['parsed']['accessToken']);
  //
  //     if (mounted) {
  //       context.go('/home');
  //     }
  //
  //   } else {
  //     if (mounted) {
  //       showCustomSnackBar(
  //           context,
  //           result['parsed']['message'] ?? "Login failed",
  //           false);
  //     }
  //   }
  // }

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    final identifier = identifierController.text.trim();
    final password = passwordController.text;

    final result = await AuthService().login(identifier, password);

    setState(() {
      _isLoading = false;
    });

    final status = result['status'];
    final parsed = result['parsed'];

    if (status == 200 && parsed['accessToken'] != null) {
      if (!context.mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainLayout(initialPage: 'home',)),
      );
    } else {
      if (!context.mounted) return;

      final errorMessage = parsed['error'] ?? parsed['message'] ?? "Login failed. Please try again.";
      showCustomSnackBar(context, errorMessage, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 800;

    // 🔹 3. PopScope to handle/disable the back button
    return PopScope(
      canPop: false, // Prevents backing out of the login screen into a void
      child: Scaffold(
        body: Stack(
          children: [
            // BACKGROUND LAYER
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.indigo.shade900, Colors.deepPurple.shade900, Colors.black],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            // ANIMATION LAYER: Particles
            AnimatedBuilder(
              animation: _bgController,
              builder: (context, child) {
                return CustomPaint(
                  painter: BackgroundDotsPainter(positions: _dotPositions),
                  size: size,
                );
              },
            ),

            // UI LAYER: Glassmorphism Card
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                      child: Container(
                        width: isWeb ? 420 : size.width * 0.88,
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(color: Colors.white.withOpacity(0.12)),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildHeader(),
                              const SizedBox(height: 48),
                              _modernInput("Identifier", identifierController, Iconsax.user, false),
                              const SizedBox(height: 24),
                              _modernInput("Password", passwordController, Iconsax.key, true),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "Forgot Password?",
                                  style: baseStyle.copyWith(color: Colors.white54, fontSize: 12),
                                ),
                              ),
                              const SizedBox(height: 40),
                              _isLoading
                                  ? Lottie.asset('assets/signin_button.json', height: 70)
                                  : _buildSubmitButton(),
                              const SizedBox(height: 32),
                              _buildFooter(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          "ANCIL MEDIA",
          style: baseStyle.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 2,
          width: 40,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Colors.indigoAccent, Colors.purpleAccent]),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "ADMIN DASHBOARD",
          style: baseStyle.copyWith(fontSize: 12, color: Colors.white38, letterSpacing: 1.5),
        ),
      ],
    );
  }

  Widget _modernInput(String label, TextEditingController controller, IconData icon, bool isPassword) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? obscureText : false,
      style: baseStyle.copyWith(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: baseStyle.copyWith(color: Colors.white38),
        prefixIcon: Icon(icon, color: Colors.indigoAccent.shade100, size: 20),
        suffixIcon: isPassword
            ? IconButton(
            icon: Icon(obscureText ? Iconsax.eye_slash : Iconsax.eye, color: Colors.white24, size: 18),
            onPressed: () => setState(() => obscureText = !obscureText))
            : null,
        filled: true,
        fillColor: Colors.white.withOpacity(0.04),
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.indigoAccent, width: 1.5),
        ),
      ),
      validator: (v) => (v == null || v.isEmpty) ? "Field required" : null,
    );
  }

  Widget _buildSubmitButton() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () { if (_formKey.currentState!.validate()) _handleLogin(); },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 56,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFFA855F7)]),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.indigo.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: Center(
            child: Text(
              "SIGN IN",
              style: baseStyle.copyWith(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "New here? ",
          style: baseStyle.copyWith(color: Colors.white38, fontSize: 14),
        ),
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupPage())),
          child: Text(
            "Create Account",
            style: baseStyle.copyWith(color: Colors.indigoAccent, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
      ],
    );
  }
}