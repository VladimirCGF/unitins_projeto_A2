import 'package:flutter/material.dart';

class CustomExpansionTile extends StatefulWidget {
  final String title;
  final List<Widget> children;

  const CustomExpansionTile({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        unselectedWidgetColor: Colors.white,
        colorScheme: Theme.of(
          context,
        ).colorScheme.copyWith(primary: Colors.white),
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF003F92),
          borderRadius: BorderRadius.only(
            topLeft: Radius.zero,
            topRight: Radius.zero,
            bottomLeft: Radius.circular(3),
            bottomRight: Radius.circular(3),
          ),
        ),
        child: ExpansionTile(
          onExpansionChanged: (value) {
            setState(() {
              _isExpanded = value;
            });
          },
          tilePadding: EdgeInsets.zero,
          title: Container(
            color: _isExpanded ? Colors.white : const Color(0xFF003F92),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Text(
                widget.title,
                style: TextStyle(
                  color: _isExpanded ? const Color(0xFF003F92) : Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          trailing: Container(
            decoration: BoxDecoration(
              color: _isExpanded ? Colors.white : Colors.transparent,
            ),
            child: Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
              color: _isExpanded ? const Color(0xFF003F92) : Colors.white,
            ),
          ),
          children: widget.children,
        ),
      ),
    );
  }
}
