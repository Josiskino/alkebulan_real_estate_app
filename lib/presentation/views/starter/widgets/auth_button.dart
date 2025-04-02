import 'package:flutter/material.dart';

enum AuthButtonType { google, email }

class AuthButton extends StatelessWidget {
  final AuthButtonType type;
  final String label;
  final VoidCallback onPressed;

  const AuthButton({
    super.key,
    required this.type,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case AuthButtonType.google:
        return _buildGoogleButton();
      case AuthButtonType.email:
        return _buildEmailButton();
    }
  }

  Widget _buildGoogleButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        icon: Image.asset(
          'assets/images/google_logo.png',
          height: 24,
          width: 24,
        ),
        label: Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black87,
          backgroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton.icon(
        icon: const Icon(Icons.mail_outline, size: 24, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white60, width: 1.5),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
