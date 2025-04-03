import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import 'widgets/background_with_gradient.dart';
import 'widgets/auth_button.dart';

class StarterScreen extends StatelessWidget {
  const StarterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with gradient
          const BackgroundWithGradient(imagePath: 'assets/images/duplex1.jpeg'),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(flex: 2),

                // Main text with gradient on "Find" and "Go"
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                      fontFamily: 'SF Pro',
                    ),
                    children: [
                      TextSpan(
                        text: 'Find',
                        style: TextStyle(
                          foreground: Paint()
                            ..shader = LinearGradient(
                              colors: [
                                Colors.blue.shade300,
                                Colors.blue.shade700,
                              ],
                            ).createShader(const Rect.fromLTWH(0, 0, 100, 40)),
                        ),
                      ),
                      const TextSpan(text: ' Your Dream\nHome on the '),
                      TextSpan(
                        text: 'Go',
                        style: TextStyle(
                          foreground: Paint()
                            ..shader = LinearGradient(
                              colors: [
                                Colors.blue.shade300,
                                Colors.blue.shade700,
                              ],
                            ).createShader(const Rect.fromLTWH(0, 0, 50, 40)),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Subtitle
                const Text(
                  'Scroll, Select, and Let\'s Settle In!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontFamily: 'SF Pro',
                  ),
                ),

                const SizedBox(height: 48),

                // Google login button
                AuthButton(
                  type: AuthButtonType.google,
                  label: 'Continue with Google',
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Email login button
                AuthButton(
                  type: AuthButtonType.email,
                  label: 'Continue with Email',
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Sign in text
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontFamily: 'SF Pro',
                        ),
                        children: [
                          const TextSpan(text: 'Already have an account? '),
                          TextSpan(
                            text: 'Sign In',
                            style: TextStyle(
                              color: Colors.blue.shade400,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
