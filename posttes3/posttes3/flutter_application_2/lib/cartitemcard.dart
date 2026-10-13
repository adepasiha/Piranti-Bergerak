import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // dibutuhkan untuk FilteringTextInputFormatter
import 'package:provider/provider.dart';
import 'appcolors.dart';
import 'cartprovider.dart';
import 'fooditem.dart';
import 'formatrupiah.dart';

// Widget kartu satu item di dalam keranjang: gambar, nama, harga,
// dan input jumlah pesanan yang hanya menerima angka serta terhubung
// dengan stok menu. Tetap StatefulWidget karena memiliki
// TextEditingController beserta siklus hidupnya (initState, dispose).
class CartItemCard extends StatefulWidget {
  const CartItemCard({
    super.key,
    required this.item,
    required this.quantity,
    required this.maxQuantity,
  });

  final FoodItem item;
  final int quantity;
  final int maxQuantity;

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  late final TextEditingController quantityController;

  @override
  void initState() {
    super.initState();
    // Controller diisi dengan jumlah pesanan saat ini.
    quantityController = TextEditingController(text: '${widget.quantity}');
  }

  @override
  void didUpdateWidget(covariant CartItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Menyamakan teks pada TextField apabila jumlah berubah dari luar
    // (misalnya setelah provider menyesuaikan jumlah).
    if (oldWidget.quantity != widget.quantity &&
        quantityController.text != '${widget.quantity}') {
      quantityController.text = '${widget.quantity}';
    }
  }

  @override
  void dispose() {
    quantityController.dispose(); // membersihkan controller saat widget dibuang
    super.dispose();
  }

  // Memvalidasi teks yang diketik pengguna: hanya diproses jika berupa
  // angka valid dan minimal 1, lalu dibatasi (clamp) sampai stok maksimum.
  // Perubahan dikirim ke CartProvider lewat context.read (tanpa berlangganan).
  void updateQuantity(String value) {
    final parsed = int.tryParse(value);
    if (parsed == null || parsed < 1) return;
    context
        .read<CartProvider>()
        .changeQuantity(widget.item, parsed.clamp(1, widget.maxQuantity));
  }

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
              // ClipRRect: memotong gambar agar sudutnya membulat.
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                // Image.asset: menampilkan gambar dari folder assets project.
                child: Image.asset(
                  widget.item.imagePath,
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
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
            // Column: menyusun nama, harga, dan sisa stok secara vertikal.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text: nama produk di keranjang.
                Text(
                  widget.item.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4), // jarak kecil
                // Text: harga satuan produk.
                Text(
                  formatRupiah(widget.item.price),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 2), // jarak kecil
                // Text: sisa stok menu yang masih tersedia untuk ditambah.
                Text(
                  'Stok tersisa: ${widget.item.stock}',
                  style: const TextStyle(fontSize: 10, color: AppColors.textGrey),
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
            // keyboardType number memunculkan keyboard angka, dan
            // inputFormatters memastikan hanya digit (0-9) yang bisa diketik.
            child: TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textAlign: TextAlign.center,
              onChanged: updateQuantity,
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
