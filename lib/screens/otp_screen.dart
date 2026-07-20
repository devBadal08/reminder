import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class OtpScreen extends StatefulWidget {
  final String name;
  final String email;
  final String password;
  final String phone;

  const OtpScreen({
    super.key,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  // Updated from 4 to 6 individual digit controllers and focus nodes
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  // Global Brand Color Core Palette
  final Color primaryThemeBlue = const Color(0xFF8C4A32);
  final Color backgroundCream = const Color(0xFFF6F4F0);
  final Color inputFieldFill = const Color(0xFFF0EDE6);
  final Color textMutedColor = const Color(0xFF6B6A66);
  final List<Color> goldGradient = const [Color(0xFFE5CBB2), Color(0xFFD3B69A)];

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  // Combines the values of all 6 input boxes into a single string token
  String get _getCompleteOtp => _controllers.map((c) => c.text.trim()).join();

  Future<void> verifyOtp() async {
    final String singleOtpString = _getCompleteOtp;

    if (singleOtpString.length < 6) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter 6 digit OTP")));
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.2:8000/api/verify-otp'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "name": widget.name,
          "email": widget.email,
          "password": widget.password,
          "phone": widget.phone,
          "otp": singleOtpString,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('token', data['token']);
        await prefs.setString('user_name', data['user']['name']);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(name: data['user']['name']),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "Invalid OTP")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundCream,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background Decor Accent Ring
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

          CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Safe Content Presentation Elements
                    SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 16),
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
                                  Icons.verified_user_rounded,
                                  size: 34,
                                  color: Color(0xFFE5CBB2),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            Text(
                              "Verification",
                              style: TextStyle(
                                fontFamily: 'Serif',
                                fontSize: 38,
                                fontWeight: FontWeight.w500,
                                color: primaryThemeBlue,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 4),

                            Text(
                              "Enter the code sent to ${widget.email}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                color: textMutedColor,
                              ),
                            ),
                            const SizedBox(height: 12),

                            Text(
                              "Powered by",
                              style: TextStyle(
                                fontSize: 13,
                                color: textMutedColor.withOpacity(0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Image.asset(
                              'assets/logo.png',
                              height: 32,
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
                            const SizedBox(height: 6),

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
                            const SizedBox(height: 32),

                            // 6-Digit Inline Form Token Input Section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                6,
                                (index) => _buildDigitCodeBox(index),
                              ),
                            ),
                            const SizedBox(height: 32),

                            Image.asset(
                              'assets/calendar_illustration.png',
                              height: 130,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Bottom Curve Control Dashboard Action Sheet
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
                            GestureDetector(
                              onTap: verifyOtp,
                              child: Container(
                                width: double.infinity,
                                height: 54,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: goldGradient,
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Text(
                                      "Verify Code",
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
                            const SizedBox(height: 16),

                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     const Text(
                            //       "Didn't receive the code? ",
                            //       style: TextStyle(
                            //         color: Colors.white70,
                            //         fontSize: 15,
                            //       ),
                            //     ),
                            //     GestureDetector(
                            //       onTap: () {
                            //         // Resend logic trigger
                            //       },
                            //       child: const Text(
                            //         "Resend",
                            //         style: TextStyle(
                            //           color: Colors.white,
                            //           fontWeight: FontWeight.bold,
                            //           fontSize: 15,
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
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

  // Generates optimized square digit blocks for a 6-digit array flow
  Widget _buildDigitCodeBox(int index) {
    return SizedBox(
      width:
          48, // Slightly narrower block width so 6 fields sit beautifully across standard screens
      height: 52,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: primaryThemeBlue,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: inputFieldFill,
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: textMutedColor.withOpacity(0.15),
              width: 1.2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryThemeBlue, width: 2.0),
          ),
        ),
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
