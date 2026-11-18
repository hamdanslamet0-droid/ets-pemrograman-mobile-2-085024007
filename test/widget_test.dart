import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_katalog_buku_pribadi/book.dart';

void main() {
  test('Pengujian data buku', () {
    // Membuat objek buku pertama
    Book buku1 = Book(
      title: 'Laskar Pelangi',
      author: 'Andrea Hirata',
      year: 2005,
      description: 'Novel tentang perjuangan anak-anak Belitung.',
    );

    // Membuat objek buku kedua
    Book buku2 = Book(
      title: 'Bumi',
      author: 'Tere Liye',
      year: 2014,
      description: 'Novel fantasi tentang petualangan.',
    );

    // Membuat objek buku ketiga tanpa deskripsi
    Book buku3 = Book(
      title: 'Negeri 5 Menara',
      author: 'Ahmad Fuadi',
      year: 2009,
    );

    // Memeriksa data buku
    expect(buku1.title, 'Laskar Pelangi');
    expect(buku2.author, 'Tere Liye');
    expect(buku3.year, 2009);

    // Memeriksa null safety
    expect(buku3.description, isNull);

    print('Semua pengujian berhasil!');
  });
}
