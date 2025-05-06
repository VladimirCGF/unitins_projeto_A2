import 'package:flutter/material.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity,
      decoration: const BoxDecoration(color: Color(0xFF0949B1)),
      child: const Center(
        child: Text(
          '2025 - Unitins - Todos os direitos reservados.\nDesenvolvido pela Diretoria de Tecnologia da Informação',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 11),
        ),
      ),
    );
  }
}
