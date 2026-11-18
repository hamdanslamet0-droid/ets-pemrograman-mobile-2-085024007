import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'book.dart';

// Provider nilai tetap untuk identitas pemilik katalog.
final nameProvider = Provider<String>((ref) {
  return 'Hamdan Slamet Riyadi';
});

// Provider nilai tetap untuk NPM pemilik katalog.
final npmProvider = Provider<String>((ref) {
  return '085024007';
});

// Menyediakan daftar data buku yang menjadi sumber tampilan katalog.
final booksProvider = Provider<List<Book>>((ref) {
  return [
    Book(
      title: 'Laskar Pelangi',
      author: 'Andrea Hirata',
      year: 2005,
      description:
          'Kisah perjuangan anak-anak Belitung '
          'dalam mendapatkan pendidikan.',
    ),
    Book(
      title: 'Bumi',
      author: 'Tere Liye',
      year: 2014,
      description:
          'Novel fantasi tentang petualangan '
          'di dunia paralel.',
    ),
    Book(
      title: 'Negeri 5 Menara',
      author: 'Ahmad Fuadi',
      year: 2009,
      description: null,
    ),
  ];
});

// Menggabungkan data dari provider lain menjadi ringkasan yang ditampilkan.
// ref.watch membuat nilai ini dihitung ulang jika nama atau daftar buku berubah.
final infoProvider = Provider<String>((ref) {
  final nama = ref.watch(nameProvider);
  final books = ref.watch(booksProvider);

  return '$nama memiliki ${books.length} buku.';
});

// State notifier mengelola indeks buku yang deskripsinya sedang terlihat.
class DescriptionVisibilityNotifier extends Notifier<Set<int>> {
  @override
  Set<int> build() {
    // Awalnya tidak ada deskripsi yang dibuka.
    return {};
  }

  /// Membuka atau menutup deskripsi buku pada [index] tertentu.
  void toggle(int index) {
    // Salin Set agar state baru memiliki identitas berbeda dan Riverpod
    // dapat mendeteksi perubahan tanpa memutasi state sebelumnya.
    final newState = {...state};

    if (newState.contains(index)) {
      newState.remove(index);
    } else {
      newState.add(index);
    }

    state = newState;
  }
}

// Menyediakan notifier beserta Set indeks yang dipakai oleh tampilan.
final descriptionVisibilityProvider =
    NotifierProvider<DescriptionVisibilityNotifier, Set<int>>(
      DescriptionVisibilityNotifier.new,
    );
