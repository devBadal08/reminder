import 'dart:ui';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Premium Light Canvas Background (Soft Cool Blue tint)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF0F4F8), Color(0xFFE2E8F0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Circle A: Premium Accent Glow - Top Right (Vibrant Royal Blue)
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF2563EB).withOpacity(0.15),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2563EB).withOpacity(0.35),
                    blurRadius: 120,
                    spreadRadius: 30,
                  ),
                ],
              ),
            ),
          ),

          // Circle B: Premium Accent Glow - Bottom Left (Rich Blue-Indigo)
          Positioned(
            bottom: -120,
            left: -120,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1D4ED8).withOpacity(0.12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1D4ED8).withOpacity(0.25),
                    blurRadius: 120,
                    spreadRadius: 30,
                  ),
                ],
              ),
            ),
          ),

          // 2. Main Center Controller Viewport
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 3. Master Glassmorphic App Card Container
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: const Color(
                            0xFF93C5FD,
                          ).withOpacity(0.4), // Hint of blue border
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF1E3A8A,
                            ).withOpacity(0.04), // Deep blue shadow
                            blurRadius: 40,
                            offset: const Offset(0, 20),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                              vertical: 36.0,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Refined Smooth Animated-style App Icon (Blue Theme)
                                Container(
                                  height: 96,
                                  width: 96,
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF2563EB,
                                    ).withOpacity(0.08),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(
                                        0xFF2563EB,
                                      ).withOpacity(0.15),
                                      width: 1,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.notifications_active_rounded,
                                    size: 44,
                                    color: Color(0xFF2563EB), // Classic Blue
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Symmetrical Clean Headlines
                                const Text(
                                  "Reminder",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w800,
                                    color: Color(
                                      0xFF1E3A8A,
                                    ), // Deep Navy Blue Text
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Stay organized and never miss an important task.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: const Color(
                                      0xFF1E3A8A,
                                    ).withOpacity(0.6),
                                    height: 1.4,
                                  ),
                                ),

                                const SizedBox(height: 32),
                                const Divider(
                                  color: Color(
                                    0xFFDBEAFE,
                                  ), // Light ice blue divider
                                  height: 1,
                                ),
                                const SizedBox(height: 28),

                                // Input Label Heading
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "GET STARTED",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(
                                        0xFF2563EB,
                                      ).withOpacity(0.6), // Blue Accent
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Clean Embedded Text Input Box
                                TextField(
                                  controller: nameController,
                                  style: const TextStyle(
                                    color: Color(0xFF1E3A8A),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  cursorColor: const Color(0xFF2563EB),
                                  decoration: InputDecoration(
                                    hintText: "Enter your name...",
                                    hintStyle: TextStyle(
                                      color: const Color(
                                        0xFF1E3A8A,
                                      ).withOpacity(0.4),
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFFF8FAFC),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                        color: const Color(
                                          0xFF2563EB,
                                        ).withOpacity(0.12),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF2563EB),
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Premium Action Button (Warm Luxury Amber Gradient Pop)
                                Container(
                                  width: double.infinity,
                                  height: 54,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFF59E0B), // Vibrant Amber
                                        Color(0xFFD97706), // Rich Dark Amber
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFFD97706,
                                        ).withOpacity(0.3),
                                        blurRadius: 16,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (nameController.text.trim().isEmpty) {
                                        // Clear any active messages before triggering a new alert to keep transitions clean
                                        ScaffoldMessenger.of(
                                          context,
                                        ).clearSnackBars();

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors
                                                .transparent, // Keeps the underlying card surface clear
                                            elevation: 0,
                                            behavior: SnackBarBehavior.floating,
                                            margin: const EdgeInsets.all(16),
                                            duration: const Duration(
                                              seconds: 3,
                                            ),
                                            content: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(
                                                  0.9,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                border: Border.all(
                                                  color: const Color(0xFFEF4444)
                                                      .withOpacity(
                                                        0.4,
                                                      ), // Subtle warning crimson stroke
                                                  width: 1.5,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color:
                                                        const Color(
                                                          0xFF1E3A8A,
                                                        ).withOpacity(
                                                          0.08,
                                                        ), // Safe matching navy shadow
                                                    blurRadius: 24,
                                                    offset: const Offset(0, 8),
                                                  ),
                                                ],
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                child: BackdropFilter(
                                                  filter: ImageFilter.blur(
                                                    sigmaX: 8,
                                                    sigmaY: 8,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 16,
                                                          vertical: 14,
                                                        ),
                                                    child: Row(
                                                      children: [
                                                        // Warning Symbol Wrapper
                                                        Container(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                8,
                                                              ),
                                                          decoration:
                                                              BoxDecoration(
                                                                color:
                                                                    const Color(
                                                                      0xFFEF4444,
                                                                    ).withOpacity(
                                                                      0.1,
                                                                    ),
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                          child: const Icon(
                                                            Icons
                                                                .error_outline_rounded,
                                                            color: Color(
                                                              0xFFEF4444,
                                                            ), // Crimson Alert Color
                                                            size: 20,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 12,
                                                        ),

                                                        // Notification Message Body Text
                                                        const Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                "Action Required",
                                                                style: TextStyle(
                                                                  color: Color(
                                                                    0xFF1E3A8A,
                                                                  ), // Matching Core Corporate Navy
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  letterSpacing:
                                                                      0.2,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 2,
                                                              ),
                                                              Text(
                                                                "Please enter your name to continue.",
                                                                style: TextStyle(
                                                                  color: Color(
                                                                    0xFF64748B,
                                                                  ), // Neutral Muted Grey text
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
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
                                            ),
                                          ),
                                        );

                                        return;
                                      }

                                      // Handle standard dashboard transition route if valid input exists
                                      Navigator.pushReplacement(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (_, __, ___) =>
                                              HomeScreen(
                                                name: nameController.text
                                                    .trim(),
                                              ),
                                          transitionsBuilder:
                                              (_, animation, __, child) {
                                                return FadeTransition(
                                                  opacity: animation,
                                                  child: child,
                                                );
                                              },
                                          transitionDuration: const Duration(
                                            milliseconds: 400,
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: const Text(
                                      "Continue",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
}
