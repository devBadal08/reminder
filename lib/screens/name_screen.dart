import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:reminder/screens/signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Premium Custom Theme Palette Matching Global Core Colors
  final Color primaryThemeBlue = const Color(0xFF8C4A32);
  final Color backgroundCream = const Color(0xFFF6F4F0);
  final Color textMutedColor = const Color(0xFF6B6A66);
  bool _obscurePassword = true;

  // Gold Gradient Colors for the Action Button
  final List<Color> goldGradient = const [Color(0xFFE5CBB2), Color(0xFFD3B69A)];

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backgroundCream,
      body: Stack(
        children: [
          // Background Minimalist Line Accents
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

          // Upper Structural Content Presentation Layer
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  // Centered Notification Bell Icon Group
                  Center(
                    child: Container(
                      height: 76,
                      width: 76,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryThemeBlue,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.notifications_none_rounded,
                        size: 34,
                        color: Color(0xFFE5CBB2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Header Typography Title
                  Text(
                    "Reminder",
                    style: TextStyle(
                      fontFamily: 'Serif',
                      fontSize: 46,
                      fontWeight: FontWeight.w500,
                      color: primaryThemeBlue,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Integrated Brand Signature Row Label
                  Column(
                    children: [
                      Text(
                        "Powered by",
                        style: TextStyle(
                          fontSize: 15,
                          color: textMutedColor.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Image.asset(
                        'assets/logo.png',
                        height: 38, // adjust logo size
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Text(
                            "TechStrota",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: primaryThemeBlue,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),

                  // Elegant Small Diamond Divider Line
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 36,
                        height: 1,
                        color: const Color(0xFFD2CFC9),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
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

                  // Subtitle App Description Text
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  //   child: Text(
                  //     "Stay organized and never\nmiss an important task.",
                  //     textAlign: TextAlign.center,
                  //     style: TextStyle(
                  //       fontFamily: 'Serif',
                  //       fontSize: 17,
                  //       color: textMutedColor,
                  //       height: 1.4,
                  //     ),
                  //   ),
                  // ),

                  // Reduced Compact Scale Box for the Center Illustration Artwork
                  SizedBox(
                    height:
                        screenHeight *
                        0.15, // Reduced from 0.28 to give layout whitespace breathing room
                    width: screenWidth * 0.60,
                    child: Image.asset(
                      'assets/calendar_illustration.png',
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.calendar_month_rounded,
                            size: 64,
                            color: primaryThemeBlue.withOpacity(0.1),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Curved Dashboard Registration Input Control Panel
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: ConcaveCurveClipper(),
              child: Container(
                width: double.infinity,
                color: primaryThemeBlue,
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 40.0,
                  bottom: 20.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "WELCOME BACK",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFD5CDBC),
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Input Name Textfield Layer Layout
                    TextField(
                      controller: emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Enter email",
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                        ),
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.white,
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 16,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.25),
                            width: 1.2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFFE5CBB2),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    TextField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Enter your password",
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                        ),
                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 16,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: Colors.white.withOpacity(0.25),
                            width: 1.2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFFE5CBB2),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ),
                    ),

                    // Premium Gold Variant Interactive Submission Trigger Button
                    GestureDetector(
                      onTap: () async {
                        await login();
                      },
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: goldGradient,
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: primaryThemeBlue,
                              ),
                            ),
                            Positioned(
                              right: 20,
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                color: primaryThemeBlue,
                                size: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SignupScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
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

  Future<void> login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // Empty validation
    if (email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter email")));
      return;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter password")));
      return;
    }

    // Email format validation
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');

    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter valid email")));
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.2:8000/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "password": password}),
      );

      final data = jsonDecode(response.body);

      // Login success
      if (response.statusCode == 200 && data['success'] == true) {
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('token', data['token']);
        await prefs.setString('user_name', data['user']['name']);

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(name: data['user']['name']),
          ),
        );
      } else {
        // Wrong email/password
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? "Invalid email or password"),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
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
