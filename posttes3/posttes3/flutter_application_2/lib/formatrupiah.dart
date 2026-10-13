// Fungsi bantuan untuk memformat angka harga menjadi format Rupiah,
// misalnya 18000 menjadi "Rp18.000".
String formatRupiah(int value) {
  final digits = value.toString();
  final groups = <String>[];
  for (var end = digits.length; end > 0; end -= 3) {
    final start = end - 3 < 0 ? 0 : end - 3;
    groups.insert(0, digits.substring(start, end));
  }
  return 'Rp${groups.join('.')}';
}
