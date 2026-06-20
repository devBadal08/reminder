import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final TextEditingController nameController = TextEditingController();

  // Premium Custom Theme Palette Matching Global Core Colors
  final Color primaryThemeBlue = const Color(0xFF8C4A32);
  final Color backgroundCream = const Color(0xFFF6F4F0);
  final Color textMutedColor = const Color(0xFF6B6A66);

  // Gold Gradient Colors for the Action Button
  final List<Color> goldGradient = const [Color(0xFFE5CBB2), Color(0xFFD3B69A)];

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

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
                  const SizedBox(height: 10),

                  // Subtitle App Description Text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Text(
                      "Stay organized and never\nmiss an important task.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Serif',
                        fontSize: 17,
                        color: textMutedColor,
                        height: 1.4,
                      ),
                    ),
                  ),

                  // Reduced Compact Scale Box for the Center Illustration Artwork
                  SizedBox(
                    height:
                        screenHeight *
                        0.24, // Reduced from 0.28 to give layout whitespace breathing room
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                  left: 28.0,
                  right: 28.0,
                  top: 56.0,
                  bottom: 40.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "GET STARTED",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFD5CDBC),
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Input Name Textfield Layer Layout
                    TextField(
                      controller: nameController,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      cursorColor: const Color(0xFFE5CBB2),
                      decoration: InputDecoration(
                        hintText: "Enter your name...",
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontWeight: FontWeight.w300,
                        ),
                        prefixIcon: Icon(
                          Icons.person_outline_rounded,
                          color: Colors.white.withOpacity(0.5),
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
                    const SizedBox(height: 22),

                    // Premium Gold Variant Interactive Submission Trigger Button
                    GestureDetector(
                      onTap: () => _verifyAndNavigate(context),
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
                              "Continue",
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _verifyAndNavigate(BuildContext context) async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your name to continue.")),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', nameController.text.trim());

    if (!context.mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(name: nameController.text.trim()),
      ),
    );
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
