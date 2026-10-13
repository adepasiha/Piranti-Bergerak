import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // package state management Provider
import 'appcolors.dart';
import 'cartprovider.dart';
import 'homepage.dart';

void main() {
  runApp(
    // ChangeNotifierProvider: (konsep Provider) membuat satu objek
    // CartProvider dan menyediakannya untuk seluruh widget di bawahnya.
    // Diletakkan di atas MaterialApp agar semua halaman (Beranda,
    // Keranjang, Sukses Checkout) bisa mengakses data yang sama.
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: const MyApp(),
    ),
  );
}

// MyApp sekarang cukup StatelessWidget, karena state (menu & keranjang)
// sudah dipindahkan ke CartProvider.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp: widget wrapper utama aplikasi Flutter.
    // Mengatur tema global dan halaman awal (home) yang ditampilkan.
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryGreen),
        scaffoldBackgroundColor: AppColors.background,
      ),
      debugShowCheckedModeBanner: false, // menonaktifkan banner debug
      home: const HomePage(), // halaman yang pertama kali ditampilkan
    );
  }
}
