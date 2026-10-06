import 'package:flutter/material.dart';
import 'common/app_colors.dart';
import 'common/format_rupiah.dart';
import 'models/food_item.dart';
import 'widgets/cart_item_card.dart';
import 'widgets/main_nav.dart';

// ======================================================================
// HALAMAN 2: KERANJANG (CART PAGE)
// Halaman ini menampilkan isi keranjang yang benar-benar terhubung ke
// data di MyApp: mengubah jumlah pesanan di sini akan ikut mengubah
// stok menu di halaman Beranda.
// ======================================================================
class CartPage extends StatefulWidget {
  const CartPage({
    required this.menuItems,
    required this.cartQuantities,
    required this.onQuantityChanged,
    required this.grandTotal,
    required this.onCheckout,
    super.key,
  });

  final List<FoodItem> menuItems;
  final Map<String, int> cartQuantities;
  final void Function(FoodItem item, int quantity) onQuantityChanged;
  final int grandTotal;
  final VoidCallback onCheckout;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String searchQuery = ''; // kata kunci pencarian di dalam keranjang

  // Menghitung ulang grand total tiap kali halaman dibangun ulang,
  // supaya nominalnya selalu sesuai isi keranjang terbaru.
  int get currentGrandTotal => widget.menuItems.fold(0, (total, item) {
        return total + item.price * (widget.cartQuantities[item.id] ?? 0);
      });

  @override
  Widget build(BuildContext context) {
    // Item keranjang yang ditampilkan: hanya yang jumlahnya > 0 dan
    // namanya cocok dengan kata kunci pencarian.
    final cartItems = widget.menuItems.where((item) {
      return (widget.cartQuantities[item.id] ?? 0) > 0 &&
          item.name.toLowerCase().contains(searchQuery);
    }).toList();

    // Scaffold: struktur dasar halaman keranjang.
    return Scaffold(
      backgroundColor: AppColors.background,
      // SafeArea: memastikan konten tidak tertutup notch/status bar perangkat.
      body: SafeArea(
        // Column: menyusun header, daftar item (bisa scroll), dan ringkasan
        // total secara vertikal.
        child: Column(
          children: [
            // Header hijau dengan tombol kembali (Navigator.pop) dan
            // search bar untuk mencari item di dalam keranjang.
            _CartHeader(
              onSearchChanged: (value) {
                setState(() => searchQuery = value.toLowerCase());
              },
            ),
            // Expanded: memaksa area daftar item mengisi sisa tinggi layar
            // di antara header dan ringkasan total.
            Expanded(
              // SingleChildScrollView: agar daftar item keranjang bisa di-scroll
              // apabila jumlah item melebihi tinggi layar.
              child: SingleChildScrollView(
                // Padding: memberi jarak di sekeliling daftar item.
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  // Column: menyusun kartu-kartu item keranjang secara vertikal.
                  child: Column(
                    children: [
                      for (var i = 0; i < cartItems.length; i++) ...[
                        CartItemCard(
                          item: cartItems[i],
                          quantity: widget.cartQuantities[cartItems[i].id]!,
                          maxQuantity: widget.cartQuantities[cartItems[i].id]! +
                              cartItems[i].stock,
                          onQuantityChanged: (quantity) {
                            widget.onQuantityChanged(cartItems[i], quantity);
                            setState(() {});
                          },
                        ),
                        if (i < cartItems.length - 1)
                          const SizedBox(height: 14), // jarak antar kartu item
                      ],
                      // Text: pesan ketika keranjang kosong.
                      if (cartItems.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Text(
                            'Keranjang masih kosong',
                            style: TextStyle(color: AppColors.textGrey),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            // Ringkasan total & tombol checkout, dinonaktifkan jika total 0.
            _CartSummaryBar(
              grandTotal: currentGrandTotal,
              onCheckout: currentGrandTotal > 0 ? widget.onCheckout : null,
            ),
          ],
        ),
      ),
      // bottomNavigationBar: navigasi bawah aplikasi.
      // currentIndex 1 karena sedang berada di halaman Keranjang.
      bottomNavigationBar: const MainNav(currentIndex: 1),
    );
  }
}

// Widget header hijau pada halaman Keranjang: tombol kembali (Navigator.pop)
// dan search bar untuk mencari item di dalam keranjang.
class _CartHeader extends StatelessWidget {
  const _CartHeader({required this.onSearchChanged});

  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context) {
    // Container: membungkus header, memberi warna hijau dan sudut melengkung
    // di bagian bawah, sama seperti header pada halaman Beranda.
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      decoration: const BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      // Column: menyusun baris judul dan search bar secara vertikal.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row: menyusun tombol kembali dan judul halaman secara horizontal.
          Row(
            children: [
              // GestureDetector: mendeteksi ketukan pada ikon kembali, lalu
              // memanggil Navigator.pop untuk kembali ke halaman sebelumnya
              // (menghapus halaman Keranjang dari navigation stack).
              GestureDetector(
                onTap: () => Navigator.pop(context),
                // Icon: ikon panah kembali (back).
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const SizedBox(width: 12), // jarak antara ikon dan judul
              // Text: judul halaman Keranjang.
              const Text(
                'Keranjang Saya',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14), // jarak sebelum search bar
          // Container: membungkus TextField pencarian, sama gayanya dengan
          // search bar di halaman Beranda.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              // BoxShadow: memberi efek bayangan tipis di bawah search bar.
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            // TextField: input pencarian item di dalam keranjang.
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Cari di keranjang',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                // Icon: ikon kaca pembesar di sisi kiri input.
                prefixIcon: const Icon(Icons.search, color: AppColors.primaryGreen),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget ringkasan total belanja beserta tombol checkout, ditampilkan
// tetap di bagian bawah (di atas bottom navigation).
class _CartSummaryBar extends StatelessWidget {
  const _CartSummaryBar({required this.grandTotal, required this.onCheckout});

  final int grandTotal;
  final VoidCallback? onCheckout; // null berarti tombol dinonaktifkan

  @override
  Widget build(BuildContext context) {
    // Container: membungkus ringkasan total, memberi warna putih dan
    // bayangan (BoxShadow) di sisi atas agar terlihat menonjol dari daftar item.
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        // BoxShadow: bayangan tipis di sisi atas summary bar.
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      // Row: menyusun label total (kiri) dan tombol checkout (kanan).
      child: Row(
        children: [
          // Expanded: memaksa kolom total mengisi sisa ruang di sisi kiri.
          Expanded(
            // Column: menyusun label "Total" dan nominal harga secara vertikal.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text: label "Total".
                const Text('Total', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                // Text: nominal total harga, dihitung otomatis dari isi keranjang.
                Text(
                  formatRupiah(grandTotal),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
          // GestureDetector: mendeteksi ketukan tombol checkout. Jika
          // onCheckout bernilai null (keranjang kosong), ketukan diabaikan.
          GestureDetector(
            onTap: onCheckout,
            // Container: tombol checkout, warnanya abu-abu saat dinonaktifkan.
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: onCheckout != null ? AppColors.primaryGreen : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              // Row: menyusun ikon dan teks tombol secara horizontal.
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon: ikon keranjang pada tombol checkout.
                  Icon(Icons.shopping_cart_checkout, color: Colors.white, size: 16),
                  SizedBox(width: 6), // jarak kecil
                  // Text: label tombol checkout.
                  Text(
                    'Checkout Sekarang',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
