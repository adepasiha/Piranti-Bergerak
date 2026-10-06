import 'package:flutter/material.dart';
import '../common/app_colors.dart';
import '../common/format_rupiah.dart';
import '../models/food_item.dart';

// Widget kartu menu makanan: gambar, rating, nama, resto, harga, stok,
// dan tombol tambah ke keranjang yang benar-benar mengurangi stok.
class FoodCard extends StatelessWidget {
  final FoodItem item;
  final VoidCallback onAddToCart;

  const FoodCard({
    super.key,
    required this.item,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    // Container: membungkus seluruh kartu, memberi warna putih,
    // sudut melengkung, dan bayangan tipis (BoxShadow) agar tampak seperti kartu.
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        // BoxShadow: efek bayangan tipis di sekeliling kartu.
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      // Row: menyusun gambar (kiri) dan detail menu (kanan) secara horizontal.
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stack: menumpuk badge rating di atas gambar menu.
          Stack(
            children: [
              // ClipRRect + Image: menampilkan foto menu dari folder assets
              // dengan sudut membulat.
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                // Image.asset: menampilkan gambar yang tersimpan di dalam
                // folder assets project. width dan height mengatur ukuran
                // gambar, fit mengatur bagaimana gambar menyesuaikan area.
                child: Image.asset(
                  item.imagePath,
                  width: 84,
                  height: 84,
                  fit: BoxFit.cover,
                ),
              ),
              // Positioned: menempatkan badge rating di pojok kiri bawah gambar,
              // relatif terhadap Stack di atas.
              Positioned(
                bottom: 4,
                left: 4,
                // Container: membungkus badge rating dengan warna oranye.
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.orange,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  // Row: menyusun ikon bintang dan angka rating secara horizontal.
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Icon: ikon bintang rating.
                      const Icon(Icons.star, color: Colors.white, size: 10),
                      const SizedBox(width: 2), // jarak kecil
                      // Text: angka rating menu.
                      Text(
                        item.rating,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12), // jarak antara gambar dan detail
          // Expanded: memaksa kolom detail menu mengisi sisa ruang horizontal
          // agar harga dan tombol tidak keluar dari batas kartu.
          Expanded(
            // Column: menyusun nama, resto, stok, dan baris harga secara vertikal.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text: nama menu makanan.
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2), // jarak kecil
                // Text: nama restoran/warung penjual.
                Text(
                  item.restaurant,
                  style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
                ),
                const SizedBox(height: 2), // jarak kecil
                // Text: sisa stok menu, agar pengguna tahu ketersediaan.
                Text(
                  'Stok: ${item.stock}',
                  style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
                ),
                const SizedBox(height: 6), // jarak sebelum baris harga
                // Row: menyusun harga (kiri) dan tombol tambah (kanan)
                // dengan jarak maksimal di antara keduanya.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Text: harga menu makanan, diformat dengan formatRupiah.
                    Text(
                      formatRupiah(item.price),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    // GestureDetector: mendeteksi ketukan pada tombol tambah,
                    // lalu memanggil onAddToCart yang mengurangi stok &
                    // menambah jumlah di keranjang. Tombol dinonaktifkan
                    // (abu-abu) apabila stok sudah habis.
                    GestureDetector(
                      onTap: item.stock > 0 ? onAddToCart : null,
                      // Container: tombol tambah berbentuk lingkaran hijau.
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: item.stock > 0
                              ? AppColors.primaryGreen
                              : Colors.grey.shade300,
                          shape: BoxShape.circle,
                        ),
                        // Icon: ikon tambah (+) di dalam tombol.
                        child: const Icon(Icons.add, color: Colors.white, size: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
