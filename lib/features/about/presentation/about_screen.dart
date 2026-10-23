import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          Text(
            'Pictogramas',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 12),
          Text(
            'Los símbolos pictográficos utilizados son propiedad del Gobierno de '
            'Aragón y han sido creados por Sergio Palao para ARASAAC '
            '(https://arasaac.org), que los distribuye bajo licencia '
            'Creative Commons BY-NC-SA.',
            style: TextStyle(fontSize: 16, height: 1.4),
          ),
          SizedBox(height: 12),
          Text(
            'Uso no comercial: se permite compartir y adaptar con atribución y '
            'bajo la misma licencia.',
            style: TextStyle(fontSize: 16, height: 1.4),
          ),
          SizedBox(height: 20),
          Text(
            'Esta aplicación funciona sin conexión a internet. Los datos no '
            'salen del teléfono.',
            style: TextStyle(fontSize: 16, height: 1.4),
          ),
        ],
      ),
    );
  }
}
