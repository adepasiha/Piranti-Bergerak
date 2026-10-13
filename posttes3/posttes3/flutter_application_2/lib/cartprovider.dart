import 'package:flutter/foundation.dart'; // menyediakan ChangeNotifier
import 'fooditem.dart';

// ======================================================================
// CartProvider: pusat penyimpanan state aplikasi (menu, stok, keranjang).
//
// KONSEP PROVIDER (di luar modul, dijelaskan sesuai ketentuan tugas):
// - ChangeNotifier : kelas bawaan Flutter yang bisa "memberi tahu" widget
//   lain ketika datanya berubah, lewat fungsi notifyListeners().
// - Provider       : package yang menyimpan satu objek ChangeNotifier di
//   atas widget tree, sehingga semua halaman di bawahnya bisa mengakses
//   data yang sama tanpa harus mengoper parameter/callback satu per satu
//   (berbeda dengan Modul 4 yang memakai setState + lifting state up).
// ======================================================================
class CartProvider extends ChangeNotifier {
  // Daftar menu makanan yang dijual, lengkap dengan stok masing-masing.
  // imagePath menunjuk ke gambar placeholder di folder assets.
  final List<FoodItem> menuItems = [
    FoodItem(
      id: 'menu-1',
      name: 'Nasi Goreng Spesial',
      restaurant: 'Warung Bu Tuti',
      category: 'Nasi',
      price: 18000,
      rating: '4.8',
      imagePath: 'assets/food_placeholder.png',
      stock: 5,
    ),
    FoodItem(
      id: 'menu-2',
      name: 'Nasi Uduk Komplit',
      restaurant: 'Warung Bu Tuti',
      category: 'Nasi',
      price: 16000,
      rating: '4.6',
      imagePath: 'assets/food_placeholder.png',
      stock: 4,
    ),
    FoodItem(
      id: 'menu-3',
      name: 'Ayam Geprek Sambal Matah',
      restaurant: 'Ayam Geprek Juara',
      category: 'Ayam',
      price: 16000,
      rating: '4.9',
      imagePath: 'assets/food_placeholder.png',
      stock: 3,
    ),
    FoodItem(
      id: 'menu-4',
      name: 'Ayam Bakar Madu',
      restaurant: 'Ayam Geprek Juara',
      category: 'Ayam',
      price: 22000,
      rating: '4.7',
      imagePath: 'assets/food_placeholder.png',
      stock: 4,
    ),
    FoodItem(
      id: 'menu-5',
      name: 'Mie Ayam Bakso',
      restaurant: 'Mie Ayam Pak Kumis',
      category: 'Mie',
      price: 15000,
      rating: '4.7',
      imagePath: 'assets/food_placeholder.png',
      stock: 4,
    ),
    FoodItem(
      id: 'menu-6',
      name: 'Mie Goreng Jawa',
      restaurant: 'Mie Ayam Pak Kumis',
      category: 'Mie',
      price: 14000,
      rating: '4.5',
      imagePath: 'assets/food_placeholder.png',
      stock: 3,
    ),
    FoodItem(
      id: 'menu-7',
      name: 'Es Teh Manis',
      restaurant: 'Warung Bu Tuti',
      category: 'Minuman',
      price: 5000,
      rating: '4.6',
      imagePath: 'assets/food_placeholder.png',
      stock: 6,
    ),
    FoodItem(
      id: 'menu-8',
      name: 'Jus Jeruk Segar',
      restaurant: 'Kedai Segar',
      category: 'Minuman',
      price: 9000,
      rating: '4.8',
      imagePath: 'assets/food_placeholder.png',
      stock: 5,
    ),
    FoodItem(
      id: 'menu-9',
      name: 'Es Campur',
      restaurant: 'Mie Ayam Pak Kumis',
      category: 'Dessert',
      price: 12000,
      rating: '4.5',
      imagePath: 'assets/food_placeholder.png',
      stock: 2,
    ),
    FoodItem(
      id: 'menu-10',
      name: 'Pisang Coklat Keju',
      restaurant: 'Kedai Segar',
      category: 'Dessert',
      price: 10000,
      rating: '4.7',
      imagePath: 'assets/food_placeholder.png',
      stock: 4,
    ),
  ];

  // Menyimpan jumlah tiap menu di keranjang, key-nya adalah id menu.
  // Dibuat private (_) agar hanya bisa diubah lewat fungsi di kelas ini.
  final Map<String, int> _cartQuantities = {};

  // Mengambil jumlah suatu menu di keranjang (0 jika belum ada).
  int quantityOf(FoodItem item) => _cartQuantities[item.id] ?? 0;

  // Menghitung total harga seluruh isi keranjang (state turunan).
  int get grandTotal => menuItems.fold(0, (total, item) {
        return total + item.price * quantityOf(item);
      });

  // Menghitung jumlah seluruh porsi di keranjang (dipakai di halaman Profil).
  int get totalItems =>
      menuItems.fold(0, (total, item) => total + quantityOf(item));

  // Dipanggil saat tombol "+" pada FoodCard ditekan: menambah 1 item ke
  // keranjang dan mengurangi stok menu tersebut.
  void addToCart(FoodItem item) {
    if (item.stock == 0) return; // stok habis, tidak bisa ditambah
    item.stock--;
    _cartQuantities[item.id] = quantityOf(item) + 1;
    // notifyListeners: memberi tahu semua widget yang "mendengarkan"
    // provider ini agar membangun ulang tampilannya (pengganti setState).
    notifyListeners();
  }

  // Dipanggil saat pengguna mengubah angka jumlah pesanan di halaman
  // Keranjang. Stok disesuaikan berdasarkan selisih jumlah lama dan baru,
  // lalu dibatasi (clamp) agar tidak melebihi stok yang tersedia.
  void changeQuantity(FoodItem item, int quantity) {
    final currentQuantity = quantityOf(item);
    final maxQuantity = currentQuantity + item.stock;
    final nextQuantity = quantity.clamp(1, maxQuantity);
    item.stock += currentQuantity - nextQuantity;
    _cartQuantities[item.id] = nextQuantity;
    notifyListeners(); // beri tahu widget agar tampilan diperbarui
  }
}
