import 'package:flutter/material.dart';

class SearchBarWithFilter extends StatelessWidget {
  final VoidCallback? onSearchTap;

  const SearchBarWithFilter({
    super.key,
    this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: GestureDetector(
        onTap: onSearchTap,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.12),
                spreadRadius: 0,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.blue[600], size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Where would you like to live?',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              // Subtle divider
              Container(
                height: 24,
                width: 1,
                color: Colors.grey[200],
                margin: const EdgeInsets.symmetric(horizontal: 12),
              ),
              // Filter icon
              Icon(
                Icons.tune,
                color: Colors.grey[600],
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
