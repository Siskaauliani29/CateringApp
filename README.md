# 🍽️ Catering App

**Catering App** adalah aplikasi mobile yang dirancang untuk mempermudah proses pemesanan makanan katering secara online. Aplikasi ini memungkinkan pengguna untuk memilih menu harian, melihat detail makanan, melakukan pemesanan, dan mengelola langganan katering langsung dari ponsel mereka. Dengan desain antarmuka yang sederhana dan user-friendly, aplikasi ini cocok digunakan oleh semua kalangan.

---

## 🎯 Tujuan Aplikasi

- Menyediakan layanan katering digital yang praktis dan cepat.
- Membantu pengguna memilih menu sehat dan sesuai kebutuhan harian.
- Memberikan pengalaman pemesanan makanan yang efisien dan terjadwal.
- Menjadi solusi teknologi untuk bisnis katering agar lebih modern dan menjangkau lebih banyak pelanggan.

---

## 🧩 Fitur Utama

1. **Login & Registrasi**  
   Pengguna dapat membuat akun atau login menggunakan email/sosial media.

2. **Dashboard Menu**  
   Menampilkan daftar menu makanan berdasarkan waktu makan (pagi, siang, malam).

3. **Detail Makanan**  
   Menampilkan informasi seperti deskripsi, komposisi, kalori, harga, dan foto makanan.

4. **Pemesanan & Checkout**  
   Pengguna dapat memilih makanan, memasukkannya ke keranjang, dan menyelesaikan transaksi.

5. **Paket Berlangganan**  
   Tersedia pilihan paket katering harian/mingguan dengan harga terjangkau.

6. **Riwayat Pesanan**  
   Pengguna dapat melihat histori pesanan sebelumnya.

7. **Profil & Pengaturan**  
   Edit profil, alamat, metode pembayaran, dan logout.

8. **Favorit & Review**  
   Menyimpan menu favorit dan memberikan ulasan makanan yang telah dipesan.

---

## 🛠️ Tools & Teknologi

| Teknologi       | Fungsi                                                         |
|------------------|----------------------------------------------------------------|
| **Android Studio** | IDE utama untuk mengembangkan aplikasi Android                |
| **Figma**         | Mendesain UI/UX aplikasi secara interaktif dan kolaboratif    |
| **Flutter**       | Framework untuk membuat tampilan antarmuka yang responsif      |
| **Java**          | Bahasa pemrograman utama untuk logika aplikasi Android         |
| **MongoDB**       | Database NoSQL untuk menyimpan data pengguna, menu, dan pesanan|

---

## 📦 Struktur Folder (Contoh)

/catering-app
│
├── lib/ # Kode utama aplikasi Flutter
│ ├── screens/ # Halaman-halaman aplikasi (home, login, detail, dsb)
│ ├── widgets/ # Komponen UI yang dapat digunakan ulang
│ ├── models/ # Model data (User, Menu, Order)
│ └── services/ # Logika pemrosesan data & koneksi ke MongoDB
│
├── assets/ # Gambar dan ikon
├── pubspec.yaml # Konfigurasi dan dependensi Flutter
└── README.md # Dokumentasi proyek

---

## 🚀 Cara Menjalankan Aplikasi

1. **Clone repository**
   ```bash
   git clone https://github.com/username/catering-app.git
   cd catering-app
2.Buka di Android Studio atau VS Code

3.Install dependensi

4.flutter pub get
Jalankan aplikasi


5.flutter run
Pastikan koneksi ke MongoDB tersedia (gunakan MongoDB Atlas/cloud/local)

