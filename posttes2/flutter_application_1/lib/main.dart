import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // dibutuhkan untuk FilteringTextInputFormatter

void main() {
  runApp(const MyApp());
}

// Kelas kumpulan warna tema aplikasi, terinspirasi dari warna brand
// GoFood: hijau sebagai warna utama, oranye untuk rating/label promo.
class AppColors {
  static const Color primaryGreen = Color(0xFF00AA13);
  static const Color darkGreen = Color(0xFF00850F);
  static const Color background = Color(0xFFF6F7F5);
  static const Color orange = Color(0xFFFF7A00);
  static const Color textDark = Color(0xFF1C1C1C);
  static const Color textGrey = Color(0xFF8A8A8A);
}

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

// ======================================================================
// HALAMAN 1: BERANDA (HOME)
// ======================================================================
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
            children: const [
              _HeaderSection(), // header hijau: sapaan, lokasi, search bar
              SizedBox(height: 20), // jarak vertikal antar bagian
              _CategorySection(), // daftar kategori makanan
              SizedBox(height: 20), // jarak vertikal
              // Padding: memberi jarak kiri-kanan pada banner promo
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _PromoBanner(),
              ),
              SizedBox(height: 24), // jarak vertikal
              // Padding: memberi jarak kiri-kanan pada judul section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _SectionTitle('Rekomendasi Untukmu'),
              ),
              SizedBox(height: 12), // jarak vertikal
              // Padding: memberi jarak kiri-kanan pada daftar menu makanan
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                // Column: menyusun kartu-kartu menu makanan secara vertikal
                child: Column(
                  children: [
                    FoodCard(
                      name: 'Nasi Goreng Spesial',
                      restaurant: 'Warung Bu Tuti',
                      price: 'Rp18.000',
                      rating: '4.8',
                    ),
                    SizedBox(height: 14), // jarak antar kartu menu
                    FoodCard(
                      name: 'Mie Ayam Bakso',
                      restaurant: 'Mie Ayam Pak Kumis',
                      price: 'Rp15.000',
                      rating: '4.7',
                    ),
                    SizedBox(height: 14), // jarak antar kartu menu
                    FoodCard(
                      name: 'Ayam Geprek Sambal Matah',
                      restaurant: 'Ayam Geprek Juara',
                      price: 'Rp16.000',
                      rating: '4.9',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20), // jarak sebelum akhir halaman
            ],
          ),
        ),
      ),
      // bottomNavigationBar: navigasi bawah aplikasi.
      // currentIndex 0 karena sedang berada di halaman Beranda.
      bottomNavigationBar: const MainNav(currentIndex: 0),
    );
  }
}

// Widget header hijau melengkung berisi sapaan, lokasi, avatar, dan search bar.
class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

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
            // TextField: input pencarian makanan/resto.
            child: TextField(
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

// Widget kartu menu makanan: gambar, rating, nama, resto, harga, tombol tambah.
class FoodCard extends StatelessWidget {
  final String name;
  final String restaurant;
  final String price;
  final String rating;

  const FoodCard({
    super.key,
    required this.name,
    required this.restaurant,
    required this.price,
    required this.rating,
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
              // Container: kotak placeholder gambar makanan.
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                // Icon: ikon default pengganti foto makanan.
                child: const Icon(
                  Icons.restaurant,
                  color: AppColors.primaryGreen,
                  size: 32,
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
                        rating,
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
            // Column: menyusun nama, resto, dan baris harga secara vertikal.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text: nama menu makanan.
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2), // jarak kecil
                // Text: nama restoran/warung penjual.
                Text(
                  restaurant,
                  style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
                ),
                const SizedBox(height: 8), // jarak sebelum baris harga
                // Row: menyusun harga (kiri) dan tombol tambah (kanan)
                // dengan jarak maksimal di antara keduanya.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Text: harga menu makanan.
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    // Container: tombol tambah berbentuk lingkaran hijau.
                    Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      // Icon: ikon tambah (+) di dalam tombol.
                      child: const Icon(Icons.add, color: Colors.white, size: 18),
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

// ======================================================================
// HALAMAN 2: KERANJANG (CART PAGE)
// Halaman baru ini ditambahkan agar Navigator (push & pop) bisa dipakai,
// serta mempraktikkan widget Modul 3: Image, Stack, Positioned, BoxShadow.
// ======================================================================
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data contoh isi keranjang (dummy, untuk keperluan tampilan).
    const items = [
      {
        'name': 'Nasi Goreng Spesial',
        'price': 'Rp18.000',
        'image': 'https://picsum.photos/seed/nasigoreng/200/200',
      },
      {
        'name': 'Mie Ayam Bakso',
        'price': 'Rp15.000',
        'image': 'https://picsum.photos/seed/mieayam/200/200',
      },
      {
        'name': 'Es Teh Manis',
        'price': 'Rp5.000',
        'image': 'https://picsum.photos/seed/esteh/200/200',
      },
    ];

    // Scaffold: struktur dasar halaman keranjang.
    return Scaffold(
      backgroundColor: AppColors.background,
      // SafeArea: memastikan konten tidak tertutup notch/status bar perangkat.
      body: SafeArea(
        // Column: menyusun header, daftar item (bisa scroll), dan ringkasan
        // total secara vertikal. Header & ringkasan tetap diam, hanya
        // daftar item yang bisa digulir (lewat Expanded + SingleChildScrollView).
        child: Column(
          children: [
            const _CartHeader(), // header hijau dengan tombol kembali
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
                      for (final item in items) ...[
                        CartItemCard(
                          name: item['name']!,
                          price: item['price']!,
                          imageUrl: item['image']!,
                        ),
                        const SizedBox(height: 14), // jarak antar kartu item
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const _CartSummaryBar(), // ringkasan total & tombol checkout
          ],
        ),
      ),
      // bottomNavigationBar: navigasi bawah aplikasi.
      // currentIndex 1 karena sedang berada di halaman Keranjang.
      bottomNavigationBar: const MainNav(currentIndex: 1),
    );
  }
}

// Widget header hijau pada halaman Keranjang, dilengkapi tombol kembali
// yang memanggil Navigator.pop untuk kembali ke halaman sebelumnya.
class _CartHeader extends StatelessWidget {
  const _CartHeader();

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
      // Row: menyusun tombol kembali dan judul halaman secara horizontal.
      child: Row(
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
    );
  }
}

// Widget kartu satu item di dalam keranjang: gambar, nama, harga,
// dan input jumlah pesanan yang hanya menerima angka.
class CartItemCard extends StatelessWidget {
  final String name;
  final String price;
  final String imageUrl;

  const CartItemCard({
    super.key,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    // Container: membungkus seluruh kartu item, memberi warna putih,
    // sudut melengkung, dan bayangan tipis (BoxShadow).
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        // BoxShadow: memberi efek bayangan tipis pada kartu item.
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      // Row: menyusun gambar (kiri) dan detail item (kanan) secara horizontal.
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Stack: menumpuk badge kecil "Baru" di atas gambar produk.
          Stack(
            children: [
              // ClipRRect + Image: menampilkan foto produk dari internet
              // dengan sudut membulat.
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                // Image.network: menampilkan gambar dari URL internet.
                // width dan height mengatur ukuran gambar, fit mengatur
                // bagaimana gambar menyesuaikan area yang tersedia.
                child: Image.network(
                  imageUrl,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  // errorBuilder: gambar cadangan bila gagal dimuat (mis. tanpa internet).
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 72,
                    height: 72,
                    color: AppColors.primaryGreen.withOpacity(0.1),
                    child: const Icon(Icons.fastfood, color: AppColors.primaryGreen),
                  ),
                ),
              ),
              // Positioned: menempatkan label "Baru" di pojok kiri atas gambar.
              Positioned(
                top: 0,
                left: 0,
                // Container: membungkus label dengan warna oranye.
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: const BoxDecoration(
                    color: AppColors.orange,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  // Text: teks label kecil pada badge.
                  child: const Text(
                    'Baru',
                    style: TextStyle(color: Colors.white, fontSize: 9),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12), // jarak antara gambar dan detail
          // Expanded: memaksa kolom nama & harga mengisi sisa ruang
          // agar kolom input jumlah tetap berukuran tetap di kanan.
          Expanded(
            // Column: menyusun nama dan harga produk secara vertikal.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text: nama produk di keranjang.
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4), // jarak kecil
                // Text: harga satuan produk.
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8), // jarak sebelum input jumlah
          // SizedBox: membatasi lebar TextField jumlah produk agar tidak
          // memenuhi baris.
          SizedBox(
            width: 48,
            // TextField: input jumlah produk yang dipesan.
            // keyboardType TextInputType.number memunculkan keyboard angka,
            // dan inputFormatters memastikan hanya digit (0-9) yang bisa
            // diketik, sesuai materi Modul 3 tentang membatasi input TextField.
            child: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textAlign: TextAlign.center,
              controller: TextEditingController(text: '1'),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
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
  const _CartSummaryBar();

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
              children: const [
                // Text: label "Total".
                Text('Total', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
                // Text: nominal total harga (dummy, penjumlahan manual).
                Text(
                  'Rp38.000',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
          // Container: tombol checkout berwarna hijau dengan sudut melengkung.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen,
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
        ],
      ),
    );
  }
}

// ======================================================================
// NAVIGASI BAWAH (BOTTOM NAVIGATION) — dipakai bersama oleh semua halaman
// ======================================================================

// Widget navigasi bawah aplikasi dengan highlight hijau pada tab aktif.
// Sekarang bersifat interaktif: menekan tab "Keranjang" akan memanggil
// Navigator.push menuju CartPage, dan menekan "Beranda" dari halaman lain
// akan kembali ke Beranda menggunakan Navigator.popUntil.
class MainNav extends StatelessWidget {
  final int currentIndex;
  const MainNav({super.key, required this.currentIndex});

  // Fungsi navigasi ketika salah satu tab ditekan.
  void _onTabTapped(BuildContext context, int index) {
    if (index == currentIndex) return; // sudah di halaman ini, tidak perlu apa-apa

    if (index == 0) {
      // Navigator.popUntil: kembali ke halaman paling awal (Beranda)
      // dengan menghapus semua halaman di atasnya dari navigation stack.
      Navigator.popUntil(context, (route) => route.isFirst);
    } else if (index == 1) {
      // Navigator.push: membuka halaman baru (CartPage) dan menambahkannya
      // ke bagian paling atas navigation stack.
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CartPage()),
      );
    }
    // Tab Favorit dan Profil belum memiliki halaman pada tugas ini.
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
      // Row: menyusun 4 item navigasi secara horizontal dengan jarak merata.
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
            icon: Icons.favorite_border,
            label: 'Favorit',
            isActive: false,
            onTap: () => _onTabTapped(context, 2),
          ),
          _NavItem(
            icon: Icons.person,
            label: 'Profil',
            isActive: false,
            onTap: () => _onTabTapped(context, 3),
          ),
        ],
      ),
    );
  }
}

// Widget satu item navigasi bawah (ikon + label), dipakai ulang 4 kali.
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