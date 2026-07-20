import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:reminder/screens/otp_screen.dart';
import 'name_screen.dart'; // Import your Login/Name screen here

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  bool isLoading = false;
  bool _obscurePassword = true;

  // Core Theme Palette Colors
  final Color primaryThemeBlue = const Color(0xFF8C4A32); // Deep brown-red tone
  final Color backgroundCream = const Color(0xFFF6F4F0);
  final Color inputFieldFill = const Color(
    0xFFF0EDE6,
  ); // Slightly darker cream for input boxes
  final Color textMutedColor = const Color(0xFF6B6A66);
  final List<Color> goldGradient = const [Color(0xFFE5CBB2), Color(0xFFD3B69A)];

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundCream,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background Minimalist Line Accent
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFEADBCE), width: 1.5),
              ),
            ),
          ),

          // Core Scroll/Viewport Structure
          CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Headers & Input Forms Area
                    SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 16),
                            // Create Account User Icon
                            Center(
                              child: Container(
                                height: 76,
                                width: 76,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: primaryThemeBlue,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 16,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.person_add_alt_1_rounded,
                                  size: 34,
                                  color: Color(0xFFE5CBB2),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Header Title Text
                            Text(
                              "Create Account",
                              style: TextStyle(
                                fontFamily: 'Serif',
                                fontSize: 38,
                                fontWeight: FontWeight.w500,
                                color: primaryThemeBlue,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 4),

                            // Subtitle description block
                            Text(
                              "Sign up to get started with Reminder.",
                              style: TextStyle(
                                fontSize: 15,
                                color: textMutedColor,
                              ),
                            ),

                            const SizedBox(height: 6),

                            // Small Decorative Diamond Divider
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 36,
                                  height: 1,
                                  color: const Color(0xFFD2CFC9),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Icon(
                                    Icons.lens_blur_sharp,
                                    size: 8,
                                    color: Color(0xFFD2CFC9),
                                  ),
                                ),
                                Container(
                                  width: 36,
                                  height: 1,
                                  color: const Color(0xFFD2CFC9),
                                ),
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40.0,
                              ),
                              child: Text(
                                "Stay organized and never\nmiss an important task.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Serif',
                                  fontSize: 14,
                                  color: textMutedColor,
                                  height: 1.4,
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // ====== FORM INPUT FIELDS ======
                            _buildInputField(
                              controller: nameController,
                              hintText: "Full Name",
                              icon: Icons.person_outline_rounded,
                            ),
                            const SizedBox(height: 12),
                            _buildInputField(
                              controller: emailController,
                              hintText: "Email Address",
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 12),
                            _buildInputField(
                              controller: passwordController,
                              hintText: "Password",
                              icon: Icons.lock_outline_rounded,
                              obscureText: true,
                              suffixIcon: Icons.visibility_off_outlined,
                            ),
                            const SizedBox(height: 12),
                            _buildInputField(
                              controller: phoneController,
                              hintText: "Phone Number",
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),

                    // Bottom Curve Control Action Panel
                    ClipPath(
                      clipper: ConcaveCurveClipper(),
                      child: Container(
                        width: double.infinity,
                        color: primaryThemeBlue,
                        padding: const EdgeInsets.only(
                          left: 28.0,
                          right: 28.0,
                          top: 48.0,
                          bottom: 28.0,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Sign Up Trigger Action Button
                            GestureDetector(
                              onTap: isLoading
                                  ? null
                                  : () async => await register(),
                              child: Container(
                                width: double.infinity,
                                height: 54,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: goldGradient,
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Center(
                                  child: isLoading
                                      ? SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  primaryThemeBlue,
                                                ),
                                          ),
                                        )
                                      : Text(
                                          "Send OTP",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: primaryThemeBlue,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Footer Bottom Navigation Text
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Already have an account? ",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 15,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // Navigate back to Login/NameScreen interface
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const NameScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Log In",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // DRY Helper Method for rendering unified cream background input styles
  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    IconData? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText ? _obscurePassword : false,
      keyboardType: keyboardType,
      style: TextStyle(color: primaryThemeBlue, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: textMutedColor.withOpacity(0.6),
          fontSize: 16,
        ),
        prefixIcon: Icon(icon, color: textMutedColor.withOpacity(0.7)),
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: Icon(
                  obscureText
                      ? (_obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined)
                      : suffixIcon,
                  color: textMutedColor.withOpacity(0.6),
                ),
                onPressed: obscureText
                    ? () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      }
                    : null,
              )
            : null,
        filled: true,
        fillColor: inputFieldFill,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: textMutedColor.withOpacity(0.15),
            width: 1.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryThemeBlue, width: 1.5),
        ),
      ),
    );
  }

  Future<void> register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final phone = phoneController.text.trim();

    // Name validation
    if (name.isEmpty) {
      _showError("Please enter full name");
      return;
    }

    // Email validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (email.isEmpty) {
      _showError("Please enter email");
      return;
    }

    if (!emailRegex.hasMatch(email)) {
      _showError("Please enter valid email");
      return;
    }

    // Password validation
    if (password.isEmpty) {
      _showError("Please enter password");
      return;
    }

    if (password.length < 6) {
      _showError("Password must be at least 6 characters");
      return;
    }

    // Phone validation
    final phoneRegex = RegExp(r'^[0-9]{10}$');

    if (phone.isEmpty) {
      _showError("Please enter phone number");
      return;
    }

    if (!phoneRegex.hasMatch(phone)) {
      _showError("Phone number must be 10 digits");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.2:8000/api/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
          "phone": phoneController.text.trim(),
        }),
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("OTP sent to email")));

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpScreen(
              name: nameController.text.trim(),
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
              phone: phoneController.text.trim(),
            ),
          ),
        );
      } else {
        String errorMessage = "Signup failed";

        if (data['errors'] != null) {
          final errors = data['errors'];

          if (errors['email'] != null) {
            errorMessage = errors['email'][0];
          } else if (errors['password'] != null) {
            errorMessage = errors['password'][0];
          } else if (errors['phone'] != null) {
            errorMessage = errors['phone'][0];
          }
        } else if (data['message'] != null) {
          errorMessage = data['message'];
        }

        _showError(errorMessage);
      }
    } catch (e) {
      print(e);
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }
}

class ConcaveCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 40);
    var firstControlPoint = Offset(size.width / 2, -12);
    var firstEndPoint = Offset(size.width, 40);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
