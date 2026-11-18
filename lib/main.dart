import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'book.dart';
import 'providers.dart';

// Titik masuk aplikasi: ProviderScope menyediakan container Riverpod
// untuk seluruh widget di bawah MyApp.
void main() {
  runApp(const ProviderScope(child: MyApp()));
}

// Widget root yang mengatur konfigurasi tema dan halaman pertama aplikasi.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Katalog Buku Pribadi',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const BookPage(),
    );
  }
}

// Halaman katalog membaca data dari provider dan menyusun tampilan utama.
class BookPage extends ConsumerWidget {
  const BookPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch berlangganan pada provider; widget akan dibangun ulang
    // ketika data provider yang digunakan berubah.
    final nama = ref.watch(nameProvider);
    final npm = ref.watch(npmProvider);
    final books = ref.watch(booksProvider);
    final info = ref.watch(infoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Buku Pribadi'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      // LayoutBuilder memberi lebar aktual agar daftar dapat menyesuaikan
      // jumlah kolom pada ponsel, tablet, dan layar yang lebih lebar.
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Ambang lebar ini memilih daftar satu kolom atau grid.
          int columns;

          if (constraints.maxWidth < 600) {
            columns = 1;
          } else if (constraints.maxWidth < 1000) {
            columns = 2;
          } else {
            columns = 3;
          }

          return Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kartu ringkasan identitas dan jumlah koleksi buku.
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nama: $nama',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text('NPM: $npm', style: const TextStyle(fontSize: 16)),

                        const SizedBox(height: 8),

                        Text(
                          'Jumlah Buku: ${books.length}',
                          style: const TextStyle(fontSize: 16),
                        ),

                        const SizedBox(height: 8),

                        Text(info, style: const TextStyle(color: Colors.blue)),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Daftar Buku',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                // Gunakan daftar vertikal pada layar sempit dan grid
                // pada layar yang cukup lebar.
                Expanded(
                  child: columns == 1
                      ? ListView.builder(
                          itemCount: books.length,
                          itemBuilder: (context, index) {
                            return BookCard(book: books[index], index: index);
                          },
                        )
                      : GridView.builder(
                          itemCount: books.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                mainAxisExtent: 300,
                              ),
                          itemBuilder: (context, index) {
                            return BookCard(book: books[index], index: index);
                          },
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

// Kartu buku membaca state visibilitas deskripsi langsung dari Riverpod.
class BookCard extends ConsumerWidget {
  // Data buku serta indeksnya; indeks dipakai sebagai identitas state
  // visibilitas deskripsi dalam daftar katalog.
  final Book book;
  final int index;

  const BookCard({super.key, required this.book, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Pantau Set indeks yang deskripsinya sedang dibuka.
    final visibleBooks = ref.watch(descriptionVisibilityProvider);

    final deskripsiTerlihat = visibleBooks.contains(index);

    // Model mengizinkan deskripsi null. Periksa null dan teks kosong/spasi
    // sebelum digunakan agar UI selalu memiliki teks yang dapat ditampilkan.
    final deskripsi =
        (book.description == null || book.description!.trim().isEmpty)
        ? 'Deskripsi buku belum tersedia.'
        : book.description!;

    // Susun metadata dan kontrol deskripsi dalam satu kartu.
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Informasi utama buku dan metadata penerbitan.
            Text(
              book.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text('Penulis: ${book.author}'),

            const SizedBox(height: 6),

            Text('Tahun: ${book.year}'),

            const SizedBox(height: 10),

            // Perbarui state melalui notifier saat tombol ditekan.
            ElevatedButton(
              onPressed: () {
                ref.read(descriptionVisibilityProvider.notifier).toggle(index);
              },
              child: Text(
                deskripsiTerlihat ? 'Sembunyikan Deskripsi' : 'Lihat Deskripsi',
              ),
            ),

            // AnimatedContainer menghaluskan perubahan tinggi, padding,
            // dan warna ketika deskripsi dibuka atau ditutup.
            ClipRect(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                height: deskripsiTerlihat ? 85 : 0,
                padding: deskripsiTerlihat
                    ? const EdgeInsets.all(10)
                    : EdgeInsets.zero,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: deskripsiTerlihat
                      ? Colors.blue.shade50
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    deskripsi,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
