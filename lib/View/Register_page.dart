import 'dart:math';
import 'dart:ui';
import 'package:ancilmediaadminpanel/View/Login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';

import '../Controller/Signup_controller.dart';
import '../View_model/Custom_snackbar.dart';
import '../View_model/Splash_Animation.dart'; // Using your existing particle painter

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with TickerProviderStateMixin {
  final usernameController = TextEditingController();
  final orgnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool obscureText = true;
  bool obscureConfirmText = true;

  // Animation Controllers
  late AnimationController _bgController;
  late AnimationController _contentController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  List<Offset> _dotPositions = [];
  final TextStyle baseStyle = GoogleFonts.poppins();

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = CurvedAnimation(parent: _contentController, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _contentController, curve: Curves.easeOutBack));

    _contentController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      setState(() {
        _dotPositions = _generateDotPositions(size.width, size.height, 100);
      });
    });
  }

  List<Offset> _generateDotPositions(double width, double height, int count) {
    final random = Random();
    return List.generate(count, (_) => Offset(random.nextDouble() * width, random.nextDouble() * height));
  }

  @override
  void dispose() {
    usernameController.dispose();
    orgnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    _bgController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  // --- Animation Helper ---
  Widget _staggeredEntry(double start, double end, {required Widget child}) {
    final animation = CurvedAnimation(
      parent: _contentController,
      curve: Interval(start, end, curve: Curves.easeOutQuart),
    );
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(animation),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWeb = size.width > 800;

    return Scaffold(
      body: Stack(
        children: [
          // 1. Dynamic Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade900, Colors.deepPurple.shade900, Colors.black],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // 2. Particles
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, child) => CustomPaint(
              painter: BackgroundDotsPainter(positions: _dotPositions),
              size: size,
            ),
          ),

          // 3. Signup Card
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
                      width: isWeb ? 450 : size.width * 0.9,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: Colors.white.withOpacity(0.12)),
                      ),
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _staggeredEntry(0.0, 0.4, child: _buildHeader()),
                              const SizedBox(height: 32),

                              _staggeredEntry(0.1, 0.5, child: _modernInput("Username", usernameController, Iconsax.user)),
                              const SizedBox(height: 16),

                              _staggeredEntry(0.2, 0.6, child: _modernInput("Organization", orgnameController, Iconsax.hierarchy)),
                              const SizedBox(height: 16),

                              _staggeredEntry(0.3, 0.7, child: _modernInput("Email", emailController, Iconsax.sms, type: TextInputType.emailAddress)),
                              const SizedBox(height: 16),

                              _staggeredEntry(0.4, 0.8, child: _modernInput("Phone", phoneController, Iconsax.call, type: TextInputType.phone)),
                              const SizedBox(height: 16),

                              _staggeredEntry(0.5, 0.9, child: _modernInput("Password", passwordController, Iconsax.key, isPassword: true, obscure: obscureText, onToggle: () => setState(() => obscureText = !obscureText))),
                              const SizedBox(height: 16),

                              _staggeredEntry(0.6, 1.0, child: _modernInput("Confirm Password", confirmPasswordController, Iconsax.key, isPassword: true, obscure: obscureConfirmText, onToggle: () => setState(() => obscureConfirmText = !obscureConfirmText))),
                              const SizedBox(height: 32),

                              _staggeredEntry(0.7, 1.0, child: _buildSubmitButton(size)),
                              const SizedBox(height: 24),

                              _staggeredEntry(0.8, 1.0, child: _buildFooter()),
                            ],
                          ),
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
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text("JOIN US", style: baseStyle.copyWith(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 4)),
        const SizedBox(height: 8),
        Container(height: 2, width: 40, decoration: BoxDecoration(gradient: const LinearGradient(colors: [Colors.cyanAccent, Colors.purpleAccent]), borderRadius: BorderRadius.circular(10))),
        const SizedBox(height: 12),
        Text("CREATE YOUR ADMIN ACCOUNT", style: baseStyle.copyWith(fontSize: 10, color: Colors.white38, letterSpacing: 1.5)),
      ],
    );
  }

  Widget _modernInput(String label, TextEditingController controller, IconData icon, {bool isPassword = false, bool obscure = false, VoidCallback? onToggle, TextInputType type = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: type,
      style: baseStyle.copyWith(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: baseStyle.copyWith(color: Colors.white38),
        prefixIcon: Icon(icon, color: Colors.indigoAccent.shade100, size: 20),
        suffixIcon: isPassword ? IconButton(icon: Icon(obscure ? Iconsax.eye_slash : Iconsax.eye, color: Colors.white24, size: 18), onPressed: onToggle) : null,
        filled: true,
        fillColor: Colors.white.withOpacity(0.04),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.white.withOpacity(0.08))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.indigoAccent, width: 1.5)),
      ),
      validator: (v) => (v == null || v.isEmpty) ? "Field required" : null,
    );
  }

  Widget _buildSubmitButton(Size size) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _isLoading ? null : _handleSignup,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 56,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF22D3EE), Color(0xFFA855F7)]),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.cyan.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
          ),
          child: Center(
            child: _isLoading
                ? Lottie.asset('assets/Circular_moving_dot.json', width: 40)
                : Text("SIGN UP", style: baseStyle.copyWith(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final result = await SignupController.signup(
        username: usernameController.text.trim(),
        organization: orgnameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        password: passwordController.text,
      );
      setState(() => _isLoading = false);

      if (result['success']) {
        showCustomSnackBar(context, "Welcome aboard!", true);
        context.pushReplacement('/login'); // Or your login route
      } else {
        showCustomSnackBar(context, result['message'] ?? "Signup failed", false);
      }
    }
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Already have an account? ", style: baseStyle.copyWith(color: Colors.white38, fontSize: 14)),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Text("Sign In", style: baseStyle.copyWith(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 14)),
        ),
      ],
    );
  }
}