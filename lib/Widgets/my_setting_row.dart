import 'package:flutter/material.dart';

Widget MySettingRow(IconData icon, String text, VoidCallback onTab) {
  return Padding(
    padding: const EdgeInsets.only(top: 25.0, bottom: 16),
    child: GestureDetector(
      onTap: onTab,
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.blue,
            size: 28,
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          const Expanded(
              child: SizedBox(
            height: 1,
          )),
          const Icon(
            Icons.arrow_forward_ios_outlined,
            size: 16,
          ),
        ],
      ),
    ),
  );
}
