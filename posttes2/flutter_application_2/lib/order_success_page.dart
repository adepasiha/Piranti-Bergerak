import 'package:flutter/material.dart';
import 'common/app_colors.dart';
import 'common/format_rupiah.dart';
import 'widgets/main_nav.dart';

// ======================================================================
// HALAMAN 3: SUKSES CHECKOUT (ORDER SUCCESS PAGE)
// Ditampilkan setelah pengguna menekan tombol Checkout Sekarang.
// ======================================================================
class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({required this.grandTotal, super.key});

  final int grandTotal;

  @override
  Widget build(BuildContext context) {
    // Scaffold: struktur dasar halaman sukses checkout.
    return Scaffold(
      backgroundColor: AppColors.background,
      // SafeArea: memastikan konten tidak tertutup notch/status bar perangkat.
      body: SafeArea(
        // Center: menempatkan seluruh isi halaman di tengah layar.
        child: Center(
          // Padding: memberi jarak kiri-kanan pada konten.
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            // Column: menyusun ikon centang, teks, total, dan tombol secara vertikal.
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Container: lingkaran hijau berisi ikon centang.
                Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  // Icon: ikon centang tanda pesanan berhasil.
                  child: const Icon(Icons.check, color: Colors.white, size: 90),
                ),
                const SizedBox(height: 48), // jarak vertikal
                // Text: pesan konfirmasi pesanan berhasil.
                const Text(
                  'Pesanan kamu berhasil dibuat!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, height: 1.2, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 26), // jarak vertikal
                // Text: menampilkan total yang harus dibayar, diformat Rupiah.
                Text(
                  formatRupiah(grandTotal),
                  style: const TextStyle(
                    fontSize: 30,
                    height: 1,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 34), // jarak sebelum tombol
                // SizedBox: mengatur lebar tombol agar memenuhi lebar layar.
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  // GestureDetector: mendeteksi ketukan tombol kembali.
                  child: GestureDetector(
                    // Navigator.pop: kembali ke halaman Keranjang sebelumnya.
                    onTap: () => Navigator.pop(context),
                    // Container: tampilan tombol "Kembali".
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // Center: menengahkan teks tombol secara vertikal & horizontal.
                      child: const Center(
                        // Text: label tombol kembali.
                        child: Text(
                          'Kembali',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: menekan tab Beranda dari sini akan kembali
      // langsung ke halaman paling awal (Beranda), melewati Keranjang.
      bottomNavigationBar: const MainNav(currentIndex: 1),
    );
  }
}
