import 'package:flutter/material.dart';
import 'cart_page.dart';
import 'common/app_colors.dart';
import 'home_page.dart';
import 'models/food_item.dart';
import 'order_success_page.dart';

void main() {
  runApp(const MyApp());
}

// ======================================================================
// MyApp: widget paling atas yang menyimpan seluruh data & logika keranjang
// (mirip pola pada contoh abang asisten: state disimpan di root widget,
// lalu dioper ke halaman-halaman di bawahnya).
// ======================================================================
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // GlobalKey navigator: dipakai agar Navigator.push bisa dipanggil dari
  // luar widget tree (misalnya dari dalam fungsi onOpenCart di bawah).
  final navigatorKey = GlobalKey<NavigatorState>();

  // Daftar menu makanan yang dijual, lengkap dengan stok masing-masing.
  // imagePath menunjuk ke gambar placeholder yang ada di folder assets.
  final menuItems = <FoodItem>[
    FoodItem(
      id: 'menu-1',
      name: 'Nasi Goreng Spesial',
      restaurant: 'Warung Bu Tuti',
      price: 18000,
      rating: '4.8',
      imagePath: 'assets/food_placeholder.png',
      stock: 5,
    ),
    FoodItem(
      id: 'menu-2',
      name: 'Mie Ayam Bakso',
      restaurant: 'Mie Ayam Pak Kumis',
      price: 15000,
      rating: '4.7',
      imagePath: 'assets/food_placeholder.png',
      stock: 4,
    ),
    FoodItem(
      id: 'menu-3',
      name: 'Ayam Geprek Sambal Matah',
      restaurant: 'Ayam Geprek Juara',
      price: 16000,
      rating: '4.9',
      imagePath: 'assets/food_placeholder.png',
      stock: 3,
    ),
    FoodItem(
      id: 'menu-4',
      name: 'Es Teh Manis',
      restaurant: 'Warung Bu Tuti',
      price: 5000,
      rating: '4.6',
      imagePath: 'assets/food_placeholder.png',
      stock: 6,
    ),
    FoodItem(
      id: 'menu-5',
      name: 'Es Campur',
      restaurant: 'Mie Ayam Pak Kumis',
      price: 12000,
      rating: '4.5',
      imagePath: 'assets/food_placeholder.png',
      stock: 2,
    ),
  ];

  // Menyimpan jumlah tiap menu yang ada di keranjang, key-nya adalah id menu.
  final cartQuantities = <String, int>{};

  // Dipanggil saat tombol "+" pada FoodCard ditekan: menambah 1 item ke
  // keranjang dan mengurangi stok menu tersebut.
  void addToCart(FoodItem item) {
    if (item.stock == 0) return; // stok habis, tidak bisa ditambah
    setState(() {
      item.stock--;
      cartQuantities[item.id] = (cartQuantities[item.id] ?? 0) + 1;
    });
  }

  // Dipanggil saat pengguna mengubah angka jumlah pesanan di halaman
  // Keranjang. Stok disesuaikan kembali berdasarkan selisih jumlah lama
  // dan jumlah baru, lalu dibatasi (clamp) agar tidak melebihi stok yang ada.
  void changeQuantity(FoodItem item, int quantity) {
    final currentQuantity = cartQuantities[item.id] ?? 0;
    final maxQuantity = currentQuantity + item.stock;
    final nextQuantity = quantity.clamp(1, maxQuantity);
    setState(() {
      item.stock += currentQuantity - nextQuantity;
      cartQuantities[item.id] = nextQuantity;
    });
  }

  // Menghitung total harga seluruh isi keranjang.
  int get grandTotal => menuItems.fold(0, (total, item) {
        return total + item.price * (cartQuantities[item.id] ?? 0);
      });

  @override
  Widget build(BuildContext context) {
    // MaterialApp: widget wrapper utama aplikasi Flutter.
    // navigatorKey dipasang agar navigasi bisa dipicu dari luar widget tree.
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryGreen),
        scaffoldBackgroundColor: AppColors.background,
      ),
      debugShowCheckedModeBanner: false, // menonaktifkan banner debug
      navigatorKey: navigatorKey,
      // home: HomePage menerima data menu beserta fungsi-fungsi callback
      // agar HomePage tidak perlu tahu cara kerja keranjang, cukup
      // memanggil fungsi yang sudah disediakan.
      home: HomePage(
        menuItems: menuItems,
        onAddToCart: addToCart,
        onOpenCart: () {
          // Navigator.push: membuka halaman CartPage baru di atas
          // navigation stack.
          navigatorKey.currentState!.push(
            MaterialPageRoute(
              builder: (_) => CartPage(
                menuItems: menuItems,
                cartQuantities: cartQuantities,
                onQuantityChanged: changeQuantity,
                grandTotal: grandTotal,
                onCheckout: () {
                  // Navigator.push: membuka halaman sukses checkout.
                  navigatorKey.currentState!.push(
                    MaterialPageRoute(
                      builder: (_) => OrderSuccessPage(grandTotal: grandTotal),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
