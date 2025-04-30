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
  bool _customIcon = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent, // Remove linha de divisão
          ),
          child: Container(
            decoration: BoxDecoration(
              color: _isExpanded ? Colors.lightBlueAccent : const Color(0xFF003F92),
              borderRadius: BorderRadius.only(
                topLeft: Radius.zero,
                topRight: Radius.zero,
                bottomLeft: Radius.circular(3),
                bottomRight: Radius.circular(3),
              ),
            ),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
              title: Text(
                widget.title,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: _isExpanded ? const Color(0xFF003F92) : Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              trailing: Icon(
                _customIcon ? Icons.expand_less_sharp : Icons.expand_more_sharp,
                color: _customIcon ? const Color(0xFF003F92) : Colors.white,
              ),
              children: [
                Container(
                  width: double.infinity,
                  color: const Color(0xFF003F92), // Azul escuro
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildItem(
                        Icons.login,
                        'Primeiro acesso ou problemas de acesso',
                      ),
                      _buildItem(
                        Icons.help_outline,
                        'Esqueci a senha ou quero trocá-la',
                      ),
                      _buildItem(
                        Icons.person_outline,
                        'Como utilizar as ferramentas do Educ@',
                      ),
                      _buildItem(
                        Icons.menu_book_outlined,
                        'Guia Prático do Acadêmico',
                      ),
                      _buildItem(
                        Icons.menu_book_outlined,
                        'Manual do Acadêmico',
                      ),
                      _buildItem(
                        Icons.library_books_outlined,
                        'SIBUNI - Sistema Integrado de Bibliotecas',
                      ),
                    ],
                  ),
                ),
              ],
              onExpansionChanged: (bool expanded) {
                setState(() {
                  _customIcon = expanded;
                  _isExpanded = expanded;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
