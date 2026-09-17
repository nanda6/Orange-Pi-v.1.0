Orange Launcher untuk Orange Pi 4 Pro

Peluncur bergaya Android untuk Orange Pi 4 Pro (Xfce) dengan navigasi
sentuh: bilah navigasi tepi layar, laci aplikasi, aplikasi terkini,
menu daya, kalender, pengatur suara, WiFi, dan Bluetooth.


Fitur

  Bilah navigasi Aplikasi, Kembali, Beranda, Terkini, Daya di tepi layar
  Laci aplikasi dengan kategori dan pencarian
  Jendela Terkini dengan tutup semua
  Menu Daya untuk matikan, mulai ulang, tidur, dan keluar
  Pil status berisi tanggal dan kalender, Bluetooth, WiFi, dan volume
  Mode tidur hemat daya, bangun seketika saat disentuh
  Tampilan menyesuaikan otomatis berbagai ukuran LCD
  Daemon sentuh ke klik untuk layar sentuh


Sudah diuji

  Aplikasi ini sudah diuji langsung di board Orange Pi 4 Pro
  dengan citra Ubuntu 26 (Resolute) dan tampilan Xfce, memakai
  LCD 7 inci 1024x600. Yang diuji: bilah navigasi beserta semua
  tombolnya, laci aplikasi, jendela Terkini, menu Daya, pil
  status (kalender, Bluetooth, WiFi, volume), mode tidur dan
  bangun dengan wallpaper yang kembali seketika, serta nyala
  otomatis setiap board dinyalakan ulang.

  Paket binari ini hanya untuk citra dan perangkat tersebut.
  Citra lain, arsitektur lain, atau tampilan selain Xfce tidak
  didukung dan belum diuji.


Kebutuhan

  Orange Pi 4 Pro yang sudah menyala dan masuk tampilan desktop
  (layar bergambar, bukan layar hitam berisi tulisan saja)
  Koneksi internet HANYA saat pemasangan (untuk melengkapi
  kebutuhan sistem). Sesudah terpasang, aplikasi berjalan
  normal tanpa internet, kecuali fitur yang memang butuh
  jaringan seperti WiFi dan Bluetooth.
  Dua berkas dari halaman GitHub proyek ini:
  'install.sh' dan 'payload.tar.gz'

  Simpan kedua berkas instalasi itu baik-baik. Kapan pun butuh
  pasang ulang atau pindah board, cukup ulangi langkah
  pemasangan di bawah tanpa mengunduh lagi.


Pemasangan lengkap

  Siapkan dulu kedua berkas 'install.sh' dan 'payload.tar.gz'.
  Unduh dari halaman GitHub lewat peramban Chrome di Orange Pi,
  atau salin dari flashdisk. Taruh keduanya berdampingan dalam
  satu folder yang sama, misalnya folder Dokumen.

  Langkah memasang:

  1. Buka folder tempat kedua berkas tadi, misalnya Dokumen.
  2. Klik kanan area kosong di dalam folder, lalu pilih Terminal.
     Jendela hitam berisi tulisan akan terbuka.
  3. Ketik perintah ini lalu tekan Enter:

     bash install.sh

  4. Tunggu sampai muncul tulisan SELESAI. Selama proses berjalan,
     berkas dipasang ke folder Home, izin diatur, dan kebutuhan
     sistem dipasang otomatis. Kadang Terminal meminta kata sandi,
     ketik kata sandi pengguna lalu Enter (tulisan sandi tidak
     terlihat, itu normal).
  5. Bilah navigasi langsung muncul di tepi kanan layar. Ikon
     Orange Launcher juga ada di Desktop dan menu aplikasi.

  Memastikan berhasil, ketik di Terminal lalu Enter:

     pgrep -f orange-launcher

     Bila muncul angka (nomor proses), berarti launcher berjalan.
     Instalasi hanya perlu sekali. Setiap board dinyalakan ulang,
     launcher berjalan otomatis sendiri.

  Bila bilah tidak muncul, pastikan Anda masuk ke tampilan
  desktop Xfce, lalu ulangi bash install.sh dari folder yang sama.

  Melihat catatan kerja bila ada masalah, ketik di Terminal:

     tail -f /tmp/orange-launcher.log

     Untuk keluar dari tampilan itu, tekan Ctrl dan C bersamaan.


Pembaruan

  Unduh 'install.sh' dan 'payload.tar.gz' versi baru, timpa yang
  lama di folder yang sama, lalu jalankan ulang bash install.sh.
  Proses launcher dimuat ulang di tempat tanpa mengganggu sesi.
  Nomor versi paket ini tercatat di berkas 'VERSION'.


Lisensi

  Perangkat lunak berpemilik. Lihat berkas 'LICENSE'.
  Dilarang menyalin, mengubah, merekayasa balik, atau
  mendistribusikan ulang tanpa izin tertulis dari pemilik.
