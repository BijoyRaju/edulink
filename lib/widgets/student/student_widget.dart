import 'package:flutter/material.dart';

Widget detailTile(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFF325B3D)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey)),
              Text(
                value,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }