String formatToRupiah(int price) {
  String reversedPrice = price.toString().split('').reversed.join();
  List<String> chunks = [];
  for (int i = 0; i < reversedPrice.length; i += 3) {
    late String chunk;
    if (i < reversedPrice.length - 3) {
      chunk = reversedPrice.substring(i, i + 3);
    } else {
      chunk = reversedPrice.substring(i);
    }
    chunks.add(chunk);
  }
  String formattedPrice = chunks.join('.').split('').reversed.join();
  return 'Rp $formattedPrice';
}
