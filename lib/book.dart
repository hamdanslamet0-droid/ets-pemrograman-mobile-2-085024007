class Book {
  final String title;

  final String author;

  final int year;

  final String? description;

  /// Membuat data buku dengan judul, penulis, dan tahun yang wajib.
  Book({
    required this.title,
    required this.author,
    required this.year,
    this.description,
  });
}
