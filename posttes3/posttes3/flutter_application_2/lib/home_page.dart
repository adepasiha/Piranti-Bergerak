import 'package:flutter/material.dart';
import 'common/app_colors.dart';
import 'models/food_item.dart';
import 'widgets/food_card.dart';
import 'widgets/main_nav.dart';

// ======================================================================
// HALAMAN 1: BERANDA (HOME)
// ======================================================================
class HomePage extends StatefulWidget {
  const HomePage({
    required this.menuItems,
    required this.onAddToCart,
    required this.onOpenCart,
    super.key,
  });

  final List<FoodItem> menuItems;
  final ValueChanged<FoodItem> onAddToCart;
  final VoidCallback onOpenCart;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Menyimpan kata kunci pencarian yang diketik pengguna.
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // Menu yang ditampilkan: hanya yang stoknya masih ada dan namanya
    // cocok dengan kata kunci pencarian.
    final visibleItems = widget.menuItems.where((item) {
      return item.stock > 0 && item.name.toLowerCase().contains(searchQuery);
    }).toList();

    // Scaffold: struktur dasar halaman (body + bottomNavigationBar).
    return Scaffold(
      backgroundColor: AppColors.background,
      // SafeArea: memastikan konten tidak tertutup notch/status bar perangkat.
      body: SafeArea(
        // SingleChildScrollView: agar seluruh isi halaman bisa di-scroll
        // karena kontennya lebih panjang dari layar.
        child: SingleChildScrollView(
          // Column: menyusun semua bagian halaman secara vertikal.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header hijau berisi sapaan, lokasi, dan search bar.
              // onSearchChanged dihubungkan ke state searchQuery di atas.
              _HeaderSection(
                onSearchChanged: (value) {
                  setState(() => searchQuery = value.toLowerCase());
                },
              ),
              const SizedBox(height: 20), // jarak vertikal antar bagian
              const _CategorySection(), // daftar kategori makanan
              const SizedBox(height: 20), // jarak vertikal
              // Padding: memberi jarak kiri-kanan pada banner promo
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _PromoBanner(),
              ),
              const SizedBox(height: 24), // jarak vertikal
              // Padding: memberi jarak kiri-kanan pada judul section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _SectionTitle('Rekomendasi Untukmu'),
              ),
              const SizedBox(height: 12), // jarak vertikal
              // Padding: memberi jarak kiri-kanan pada daftar menu makanan
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                // Column: menyusun kartu-kartu menu makanan secara vertikal,
                // satu kartu untuk setiap menu yang lolos filter pencarian.
                child: Column(
                  children: [
                    for (var i = 0; i < visibleItems.length; i++) ...[
                      FoodCard(
                        item: visibleItems[i],
                        onAddToCart: () => widget.onAddToCart(visibleItems[i]),
                      ),
                      if (i < visibleItems.length - 1)
                        const SizedBox(height: 14), // jarak antar kartu menu
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20), // jarak sebelum akhir halaman
            ],
          ),
        ),
      ),
      // bottomNavigationBar: navigasi bawah aplikasi.
      // currentIndex 0 karena sedang berada di halaman Beranda.
      bottomNavigationBar: MainNav(
        currentIndex: 0,
        onCartTap: widget.onOpenCart,
      ),
    );
  }
}

// Widget header hijau melengkung berisi sapaan, lokasi, avatar, dan search bar.
class _HeaderSection extends StatelessWidget {
  const _HeaderSection({required this.onSearchChanged});

  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context) {
    // Container: membungkus seluruh isi header, memberi warna hijau,
    // padding, dan sudut melengkung di bagian bawah (BoxDecoration).
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      decoration: const BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      // Column: menyusun baris atas (sapaan+avatar) dan search bar secara vertikal.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row: menyusun kolom teks sapaan dan avatar profil secara horizontal,
          // dengan jarak maksimal di antara keduanya.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Column: menyusun teks sapaan dan lokasi secara vertikal.
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text: menampilkan kalimat sapaan ke pengguna.
                  Text(
                    'Mau makan apa hari ini?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 6), // jarak vertikal kecil
                  // Row: menyusun ikon lokasi dan teks lokasi secara horizontal.
                  Row(
                    children: [
                      // Icon: ikon pin lokasi.
                      Icon(Icons.location_on, color: Colors.white70, size: 16),
                      SizedBox(width: 4), // jarak horizontal kecil
                      // Text: menampilkan nama lokasi pengguna.
                      Text(
                        'Balikpapan, Kalimantan Timur',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              // CircleAvatar: menampilkan avatar profil pengguna berbentuk bulat.
              const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                // Icon: ikon default profil di dalam avatar.
                child: Icon(Icons.person, color: AppColors.primaryGreen),
              ),
            ],
          ),
          const SizedBox(height: 18), // jarak sebelum search bar
          // Container: membungkus TextField agar berbentuk kotak putih
          // dengan sudut melengkung. BoxShadow dipakai agar search bar
          // tampak "mengambang" di atas header.
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
            // TextField: input pencarian makanan/resto. onChanged memanggil
            // fungsi onSearchChanged agar HomePage bisa menyaring daftar menu.
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Cari makanan atau resto',
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

// Widget baris kategori makanan dalam bentuk chip yang bisa di-scroll horizontal.
class _CategorySection extends StatelessWidget {
  const _CategorySection();

  static const List<Map<String, dynamic>> categories = [
    {'label': 'Semua', 'icon': Icons.restaurant_menu},
    {'label': 'Nasi', 'icon': Icons.rice_bowl},
    {'label': 'Ayam', 'icon': Icons.egg_alt},
    {'label': 'Mie', 'icon': Icons.ramen_dining},
    {'label': 'Minuman', 'icon': Icons.local_cafe},
    {'label': 'Dessert', 'icon': Icons.icecream},
  ];

  @override
  Widget build(BuildContext context) {
    // SizedBox: membatasi tinggi area kategori agar tidak memenuhi layar.
    return SizedBox(
      height: 40,
      // ListView.separated: daftar chip kategori yang bisa di-scroll ke samping,
      // dengan jarak antar item otomatis dari separatorBuilder.
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16), // jarak tepi kiri-kanan
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10), // jarak antar chip
        itemBuilder: (context, index) {
          final bool isActive = index == 0;
          final category = categories[index];
          // Container: membungkus tiap chip kategori, memberi warna,
          // padding, sudut melengkung, dan border sesuai status aktif.
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isActive ? AppColors.primaryGreen : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isActive ? AppColors.primaryGreen : Colors.grey.shade300,
              ),
            ),
            // Row: menyusun ikon kategori dan teks label secara horizontal.
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon: ikon yang mewakili kategori makanan.
                Icon(
                  category['icon'] as IconData,
                  size: 16,
                  color: isActive ? Colors.white : AppColors.textGrey,
                ),
                const SizedBox(width: 6), // jarak antara ikon dan teks
                // Text: nama kategori makanan.
                Text(
                  category['label'] as String,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : AppColors.textDark,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Widget banner promo dengan latar gradasi hijau.
class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    // Container: membungkus seluruh isi banner, memberi padding,
    // gradasi warna (LinearGradient), dan sudut melengkung.
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryGreen, AppColors.darkGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      // Row: menyusun teks promo (kiri) dan ikon delivery (kanan) secara horizontal.
      child: Row(
        children: [
          // Expanded: memaksa kolom teks mengisi sisa ruang horizontal
          // agar ikon di sebelah kanan tidak tertindih.
          Expanded(
            // Column: menyusun judul, deskripsi, dan tombol promo secara vertikal.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text: judul promo.
                const Text(
                  'Gratis Ongkir',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6), // jarak vertikal kecil
                // Text: deskripsi singkat promo.
                const Text(
                  'Untuk pesanan pertama hari ini',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 14), // jarak sebelum tombol
                // Container: membungkus teks tombol agar tampak seperti
                // tombol putih dengan sudut melengkung.
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  // Text: label tombol ajakan bertindak.
                  child: const Text(
                    'Pesan Sekarang',
                    style: TextStyle(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Icon: ilustrasi ikon pengantaran di sisi kanan banner.
          const Icon(Icons.delivery_dining, color: Colors.white, size: 56),
        ],
      ),
    );
  }
}

// Widget judul section, dipakai ulang di beberapa bagian halaman.
class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    // Text: menampilkan judul section (misal "Rekomendasi Untukmu").
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
