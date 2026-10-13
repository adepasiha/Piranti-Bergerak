import 'package:flutter/material.dart';
import 'appcolors.dart';
import 'cartpage.dart';
import 'profilepage.dart';

// Widget navigasi bawah aplikasi dengan highlight hijau pada tab aktif.
// Menekan tab "Keranjang" atau "Profil" membuka halaman tujuannya dengan
// Navigator.push (dari Beranda) atau Navigator.pushReplacement (dari tab
// lain, supaya tumpukan halaman tidak menumpuk). Menekan "Beranda" dari
// halaman lain kembali ke Beranda menggunakan Navigator.popUntil. Karena CartProvider berada di atas MaterialApp,
// halaman yang dibuka lewat Navigator.push tetap bisa mengaksesnya.
class MainNav extends StatelessWidget {
  final int currentIndex;

  const MainNav({super.key, required this.currentIndex});

  // Membuka halaman tujuan. Dari Beranda memakai Navigator.push (halaman
  // ditumpuk di atas Beranda). Dari tab lain memakai pushReplacement
  // (halaman saat ini diganti) agar tombol kembali tetap menuju Beranda.
  void _openPage(BuildContext context, Widget page) {
    final route = MaterialPageRoute(builder: (_) => page);
    if (currentIndex == 0) {
      Navigator.push(context, route);
    } else {
      Navigator.pushReplacement(context, route);
    }
  }

  // Fungsi navigasi ketika salah satu tab ditekan.
  void _onTabTapped(BuildContext context, int index) {
    if (index == currentIndex) return; // sudah di halaman ini, tidak perlu apa-apa

    if (index == 0) {
      // Navigator.popUntil: kembali ke halaman paling awal (Beranda)
      // dengan menghapus semua halaman di atasnya dari navigation stack.
      Navigator.popUntil(context, (route) => route.isFirst);
    } else if (index == 1) {
      _openPage(context, const CartPage()); // tab Keranjang
    } else if (index == 2) {
      _openPage(context, const ProfilePage()); // tab Profil
    }
  }

  @override
  Widget build(BuildContext context) {
    // Container: membungkus seluruh bottom navigation, memberi warna putih
    // dan bayangan tipis di bagian atas agar terlihat menonjol dari body.
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        // BoxShadow: bayangan tipis di sisi atas bottom navigation.
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      // Row: menyusun 3 item navigasi secara horizontal dengan jarak merata.
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _NavItem(
            icon: Icons.home,
            label: 'Beranda',
            isActive: currentIndex == 0,
            onTap: () => _onTabTapped(context, 0),
          ),
          _NavItem(
            icon: Icons.shopping_cart,
            label: 'Keranjang',
            isActive: currentIndex == 1,
            onTap: () => _onTabTapped(context, 1),
          ),
          _NavItem(
            icon: Icons.person,
            label: 'Profil',
            isActive: currentIndex == 2,
            onTap: () => _onTabTapped(context, 2),
          ),
        ],
      ),
    );
  }
}

// Widget satu item navigasi bawah (ikon + label), dipakai ulang 3 kali.
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = isActive ? AppColors.primaryGreen : AppColors.textGrey;
    // GestureDetector: mendeteksi ketukan pengguna pada item navigasi
    // lalu memanggil fungsi navigasi (onTap) yang dikirim dari MainNav.
    return GestureDetector(
      onTap: onTap,
      // Column: menyusun ikon dan label teks secara vertikal.
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon: ikon menu navigasi.
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 4), // jarak kecil antara ikon dan label
          // Text: label nama menu navigasi.
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
