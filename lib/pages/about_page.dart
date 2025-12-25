import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tentang Toko")),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nama Toko:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Toko Online Flutter"),
            SizedBox(height: 16),
            Text("Pengembang:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Nama Mahasiswa"),
            SizedBox(height: 16),
            Text("Deskripsi:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              "Aplikasi toko online sederhana menggunakan Flutter "
              "dengan state management BLoC/Cubit dan routing.",
            ),
            SizedBox(height: 16),
            Text("Kontak:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text("mahasiswa@telkomuniversity.ac.id"),
          ],
        ),
      ),
    );
  }
}
