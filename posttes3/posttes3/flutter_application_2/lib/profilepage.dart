import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'appcolors.dart';
import 'cartprovider.dart';
import 'formatrupiah.dart';
import 'mainnav.dart';

// ======================================================================
// HALAMAN 4: PROFIL (PROFILE PAGE)
// Menampilkan identitas pengguna, ringkasan belanja yang diambil dari
// CartProvider, daftar menu akun, dan pengaturan sederhana.
// StatefulWidget dipakai karena ada state lokal: status saklar notifikasi.
// ======================================================================
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // State lokal: apakah notifikasi pesanan sedang aktif.
  bool notificationsOn = true;

  // Menampilkan pesan singkat di bagian bawah layar untuk fitur yang
  // belum tersedia pada versi tugas ini.
  void showComingSoon(String feature) {
    // ScaffoldMessenger + SnackBar: menampilkan notifikasi kecil sementara.
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$feature segera hadir'),
          backgroundColor: AppColors.primaryGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  // Menampilkan dialog informasi tentang aplikasi.
  void showAboutApp() {
    // showDialog + AlertDialog: jendela pop-up berisi informasi aplikasi.
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Tentang Kenyang'),
        content: const Text(
          'Kenyang adalah aplikasi pemesanan makanan (food delivery) '
          'yang dibuat untuk praktikum Pemrograman Piranti Bergerak.\n\n'
          'Versi 1.0.0',
        ),
        actions: [
          // TextButton: tombol teks untuk menutup dialog (Navigator.pop).
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Tutup',
              style: TextStyle(color: AppColors.primaryGreen),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // context.watch: (konsep Provider) mengambil CartProvider dan membangun
    // ulang halaman ini bila isi keranjang berubah, sehingga angka
    // statistik selalu terbaru.
    final cart = context.watch<CartProvider>();

    // Scaffold: struktur dasar halaman profil.
    return Scaffold(
      backgroundColor: AppColors.background,
      // SafeArea: memastikan konten tidak tertutup notch/status bar perangkat.
      body: SafeArea(
        // SingleChildScrollView: agar halaman bisa di-scroll pada layar kecil.
        child: SingleChildScrollView(
          // Column: menyusun header, kartu statistik, dan daftar menu secara vertikal.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _ProfileHeader(), // header hijau berisi avatar & identitas
              // Transform.translate: menggeser kartu statistik ke atas
              // sehingga menumpuk di tepi bawah header (efek mengambang).
              Transform.translate(
                offset: const Offset(0, -24),
                // Padding: memberi jarak kiri-kanan pada kartu statistik.
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _StatsCard(
                    totalItems: cart.totalItems,
                    grandTotal: cart.grandTotal,
                  ),
                ),
              ),
              // Padding: memberi jarak di sekeliling kelompok menu.
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                // Column: menyusun judul dan kartu menu per kelompok.
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _GroupTitle('Akun'),
                    const SizedBox(height: 10), // jarak vertikal
                    // _MenuCard: kartu putih berisi beberapa baris menu akun.
                    _MenuCard(
                      children: [
                        _MenuRow(
                          icon: Icons.location_on_outlined,
                          title: 'Alamat Tersimpan',
                          subtitle: 'Atur alamat pengantaran',
                          onTap: () => showComingSoon('Alamat Tersimpan'),
                        ),
                        _MenuRow(
                          icon: Icons.account_balance_wallet_outlined,
                          title: 'Metode Pembayaran',
                          subtitle: 'Tunai, e-wallet, dan transfer',
                          onTap: () => showComingSoon('Metode Pembayaran'),
                        ),
                        _MenuRow(
                          icon: Icons.local_offer_outlined,
                          title: 'Voucher Saya',
                          subtitle: 'Promo yang bisa dipakai',
                          badge: '3',
                          onTap: () => showComingSoon('Voucher Saya'),
                          showDivider: false,
                        ),
                      ],
                    ),
                    const SizedBox(height: 22), // jarak antar kelompok
                    const _GroupTitle('Pengaturan'),
                    const SizedBox(height: 10), // jarak vertikal
                    _MenuCard(
                      children: [
                        // Baris notifikasi: memakai Switch sebagai trailing,
                        // statusnya disimpan di state lokal notificationsOn.
                        _MenuRow(
                          icon: Icons.notifications_none,
                          title: 'Notifikasi Pesanan',
                          subtitle: notificationsOn ? 'Aktif' : 'Nonaktif',
                          trailing: Switch(
                            value: notificationsOn,
                            activeTrackColor: AppColors.primaryGreen,
                            onChanged: (value) {
                              setState(() => notificationsOn = value);
                            },
                          ),
                          onTap: () {
                            setState(() => notificationsOn = !notificationsOn);
                          },
                        ),
                        _MenuRow(
                          icon: Icons.help_outline,
                          title: 'Bantuan',
                          subtitle: 'Pertanyaan yang sering diajukan',
                          onTap: () => showComingSoon('Bantuan'),
                        ),
                        _MenuRow(
                          icon: Icons.info_outline,
                          title: 'Tentang Aplikasi',
                          subtitle: 'Versi 1.0.0',
                          onTap: showAboutApp,
                          showDivider: false,
                        ),
                      ],
                    ),
                    const SizedBox(height: 22), // jarak sebelum tombol keluar
                    // GestureDetector: mendeteksi ketukan tombol keluar.
                    GestureDetector(
                      onTap: () => showComingSoon('Keluar akun'),
                      // Container: tampilan tombol keluar berbingkai merah.
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        // Row: menyusun ikon dan teks tombol secara horizontal.
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon: ikon keluar (logout).
                            Icon(Icons.logout, color: Colors.red.shade400, size: 18),
                            const SizedBox(width: 8), // jarak kecil
                            // Text: label tombol keluar.
                            Text(
                              'Keluar',
                              style: TextStyle(
                                color: Colors.red.shade400,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24), // jarak sebelum akhir halaman
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: currentIndex 2 karena sedang di halaman Profil.
      bottomNavigationBar: const MainNav(currentIndex: 2),
    );
  }
}

// Widget header hijau melengkung berisi tombol kembali, avatar, nama,
// email, dan label keanggotaan.
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    // Container: membungkus header, memberi warna hijau dan sudut melengkung
    // di bagian bawah, sama seperti header pada halaman lain.
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 48),
      decoration: const BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      // Column: menyusun baris judul dan identitas pengguna secara vertikal.
      child: Column(
        children: [
          // Row: menyusun tombol kembali dan judul halaman secara horizontal.
          Row(
            children: [
              // GestureDetector: mendeteksi ketukan pada ikon kembali, lalu
              // memanggil Navigator.pop untuk kembali ke halaman sebelumnya.
              GestureDetector(
                onTap: () => Navigator.pop(context),
                // Icon: ikon panah kembali (back).
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const SizedBox(width: 12), // jarak antara ikon dan judul
              // Text: judul halaman Profil.
              const Text(
                'Profil Saya',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20), // jarak sebelum avatar
          // Stack: menumpuk lencana kamera di pojok kanan bawah avatar.
          Stack(
            children: [
              // CircleAvatar: foto profil berbentuk bulat (ikon sebagai pengganti).
              const CircleAvatar(
                radius: 42,
                backgroundColor: Colors.white,
                // Icon: ikon orang sebagai foto profil bawaan.
                child: Icon(Icons.person, size: 48, color: AppColors.primaryGreen),
              ),
              // Positioned: menempatkan lencana kamera di pojok kanan bawah avatar.
              Positioned(
                right: 0,
                bottom: 0,
                // Container: lingkaran oranye pembungkus ikon kamera.
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.orange,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  // Icon: ikon kamera sebagai penanda foto bisa diganti.
                  child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12), // jarak antara avatar dan nama
          // Text: nama pengguna.
          const Text(
            'Pengguna Kenyang',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2), // jarak kecil
          // Text: email pengguna.
          const Text(
            'pengguna@kenyang.id',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 12), // jarak sebelum label keanggotaan
          // Container: label keanggotaan berbentuk kapsul semi-transparan.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            // Row: menyusun ikon bintang dan teks keanggotaan secara horizontal.
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon: ikon bintang penanda member.
                Icon(Icons.workspace_premium, color: Colors.white, size: 16),
                SizedBox(width: 6), // jarak kecil
                // Text: nama tingkat keanggotaan.
                Text(
                  'Member Hijau',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget kartu statistik: jumlah porsi di keranjang, total belanja, voucher.
// Datanya berasal dari CartProvider sehingga ikut berubah saat keranjang berubah.
class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.totalItems, required this.grandTotal});

  final int totalItems;
  final int grandTotal;

  @override
  Widget build(BuildContext context) {
    // Container: membungkus kartu statistik, memberi warna putih, sudut
    // melengkung, dan bayangan (BoxShadow) agar tampak mengambang.
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        // BoxShadow: bayangan tipis di sekeliling kartu statistik.
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      // Row: menyusun tiga kolom statistik secara horizontal.
      child: Row(
        children: [
          // Expanded: setiap statistik mendapat lebar yang sama.
          Expanded(child: _StatItem(label: 'Di Keranjang', value: '$totalItems porsi')),
          // Container: garis pemisah vertikal antar statistik.
          Container(width: 1, height: 32, color: Colors.grey.shade200),
          Expanded(child: _StatItem(label: 'Total Belanja', value: formatRupiah(grandTotal))),
          // Container: garis pemisah vertikal antar statistik.
          Container(width: 1, height: 32, color: Colors.grey.shade200),
          const Expanded(child: _StatItem(label: 'Voucher', value: '3')),
        ],
      ),
    );
  }
}

// Widget satu statistik: nilai di atas, label di bawah.
class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    // Column: menyusun nilai dan label secara vertikal di tengah.
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Text: nilai statistik (angka/nominal).
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryGreen,
          ),
        ),
        const SizedBox(height: 4), // jarak kecil
        // Text: keterangan statistik.
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
        ),
      ],
    );
  }
}

// Widget judul kelompok menu (misalnya "Akun", "Pengaturan").
class _GroupTitle extends StatelessWidget {
  const _GroupTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    // Text: judul kelompok menu.
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      ),
    );
  }
}

// Widget kartu putih pembungkus beberapa baris menu.
class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    // Container: membungkus baris-baris menu dengan warna putih, sudut
    // melengkung, dan bayangan tipis (BoxShadow).
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        // BoxShadow: bayangan tipis di sekeliling kartu menu.
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      // Column: menyusun baris-baris menu secara vertikal.
      child: Column(children: children),
    );
  }
}

// Widget satu baris menu: ikon, judul, subjudul, lalu badge/penutup di kanan.
class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.badge,
    this.trailing,
    this.showDivider = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final String? badge; // teks badge kecil (opsional), misalnya jumlah voucher
  final Widget? trailing; // widget di ujung kanan (opsional), misalnya Switch
  final bool showDivider; // garis pemisah di bawah baris

  @override
  Widget build(BuildContext context) {
    // GestureDetector: mendeteksi ketukan pada baris menu.
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      // Column: menyusun isi baris dan garis pemisah secara vertikal.
      child: Column(
        children: [
          // Padding: memberi jarak di dalam baris menu.
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            // Row: menyusun ikon, teks, dan penutup secara horizontal.
            child: Row(
              children: [
                // Container: kotak hijau muda pembungkus ikon menu.
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  // Icon: ikon menu.
                  child: Icon(icon, color: AppColors.primaryGreen, size: 22),
                ),
                const SizedBox(width: 12), // jarak antara ikon dan teks
                // Expanded: teks judul & subjudul mengisi sisa ruang.
                Expanded(
                  // Column: menyusun judul dan subjudul secara vertikal.
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text: judul menu.
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 2), // jarak kecil
                      // Text: keterangan singkat menu.
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                // Container: badge oranye kecil (hanya tampil jika badge ada).
                if (badge != null)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.orange,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // Text: isi badge.
                    child: Text(
                      badge!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                // Penutup di kanan: widget khusus (mis. Switch) atau panah.
                trailing ??
                    // Icon: ikon panah kanan penanda baris bisa ditekan.
                    const Icon(Icons.chevron_right, color: AppColors.textGrey),
              ],
            ),
          ),
          // Divider: garis tipis pemisah antar baris menu.
          if (showDivider)
            Divider(height: 1, indent: 66, color: Colors.grey.shade200),
        ],
      ),
    );
  }
}
