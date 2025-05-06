import 'package:flutter/material.dart';

import 'custom_button.dart';

class CustomCard extends StatefulWidget {
  final String title;
  final String description;
  final VoidCallback onPressed;

  const CustomCard({
    super.key,
    required this.title,
    required this.description,
    required this.onPressed,
  });

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border(
            left: BorderSide(width: 10, color: const Color(0xFF003F92)),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                color: Color(0xFF094AB2),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.description,
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 15,
                color: Color(0xFF707070),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: CustomButton(
                onPressed: () {},
                text: 'Acessar',
                color: Colors.white,
                textColor: Color(0xFF094AB2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
