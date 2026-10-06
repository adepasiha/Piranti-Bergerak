// Model data: satu menu makanan di dalam aplikasi.
class FoodItem {
  FoodItem({
    required this.id,
    required this.name,
    required this.restaurant,
    required this.price,
    required this.rating,
    required this.imagePath,
    required this.stock,
  });

  final String id;
  final String name;
  final String restaurant;
  final int price;
  final String rating;
  final String imagePath;
  int stock; // jumlah stok, berkurang setiap kali ditambahkan ke keranjang
}
