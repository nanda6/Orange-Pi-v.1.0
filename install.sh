#!/bin/sh
# ============================================================
#  Orange Pi 4 Pro - Launcher Android (installer 1 perintah)
#  Jalankan di Orange Pi (Xfce):  bash install.sh
#  Berkas payload.tar.gz harus berada di folder yang SAMA
#  dengan script ini.
# ============================================================
set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
PAY="$DIR/payload.tar.gz"

if [ ! -f "$PAY" ]; then
  echo "ERROR: payload.tar.gz tidak ditemukan di samping script ini." >&2
  exit 1
fi

echo "=> Mengekstrak berkas ke \$HOME ($HOME)..."
tar xzf "$PAY" -C "$HOME"

echo "=> Menyesuaikan path absolut ($HOME)..."
sed -i "s|/home/orangepi|$HOME|g" \
  "$HOME/.local/share/applications/orange-launcher.desktop" \
  "$HOME/.config/autostart/orange-launcher.desktop" \
  "$HOME/.config/autostart/touch-click.desktop" 2>/dev/null || true

echo "=> Memberi izin eksekusi skrip..."
chmod +x "$HOME/.local/bin/orange-launcher" "$HOME/.local/bin/touch-click" "$HOME/.local/bin/orange-sleep"

echo "=> Memeriksa dependensi..."
if ! command -v xdotool >/dev/null 2>&1; then
  echo "   memasang xdotool..."
  apt-get install -y xdotool >/dev/null 2>&1 || sudo apt-get install -y xdotool >/dev/null 2>&1 || \
    echo "   Gagal memasang xdotool (pasang manual: sudo apt install xdotool)" >&2
fi
if ! command -v wmctrl >/dev/null 2>&1; then
  echo "   memasang wmctrl..."
  apt-get install -y wmctrl >/dev/null 2>&1 || sudo apt-get install -y wmctrl >/dev/null 2>&1 || true
fi
if ! dpkg -s gir1.2-wnck-3.0 >/dev/null 2>&1; then
  echo "   memasang gir1.2-wnck-3.0..."
  apt-get install -y gir1.2-wnck-3.0 >/dev/null 2>&1 || sudo apt-get install -y gir1.2-wnck-3.0 >/dev/null 2>&1 || true
fi

echo "=> Membersihkan sisa launcher lama (tint2/tombol nav)..."
pkill -x tint2 2>/dev/null || true
rm -f "$HOME/.config/autostart/tint2-nav.desktop"
rm -f "$HOME/.local/share/applications/nav-apps.desktop" \
      "$HOME/.local/share/applications/nav-back.desktop" \
      "$HOME/.local/share/applications/nav-home.desktop" \
      "$HOME/.local/share/applications/nav-recent.desktop" \
      "$HOME/.local/share/applications/nav-recents.desktop" \
      "$HOME/.local/share/applications/nav-power.desktop" \
      "$HOME/.local/share/applications/nav-spacer.desktop"
rm -rf "$HOME/.config/tint2" "$HOME/.local/bin/apps-drawer" "$HOME/.local/bin/power-menu"

echo "=> Menaruh ikon launcher di desktop (agar tampil sebagai aplikasi)..."
if [ -d "$HOME/Desktop" ]; then
  cp "$HOME/.local/share/applications/orange-launcher.desktop" "$HOME/Desktop/"
  chmod +x "$HOME/Desktop/orange-launcher.desktop"
  if command -v gio >/dev/null 2>&1; then
    gio set "$HOME/Desktop/orange-launcher.desktop" metadata::trusted true 2>/dev/null || true
  fi
fi

LIVE=$(pgrep -x xfwm4 >/dev/null 2>&1 && echo yes || echo no)
if [ "$LIVE" = "yes" ]; then
  echo "=> Menyalakan ulang launcher..."
  PIDF="$HOME/.local/bin/orange-launcher"
  OLD=$(pgrep -f "$PIDF" 2>/dev/null | head -1)
  if [ -n "$OLD" ]; then
    # Muat ulang di tempat (HUP): PID, sesi, dan izin ikut terjaga.
    kill -HUP "$OLD" 2>/dev/null || true
    sleep 4
  fi
  if pgrep -f "$PIDF" >/dev/null 2>&1; then
    echo "   orange-launcher aktif."
  else
    DISPLAY=:0 nohup "$HOME/.local/bin/orange-launcher" >/dev/null 2>&1 &
    sleep 2
    if pgrep -f "$HOME/.local/bin/orange-launcher" >/dev/null 2>&1; then
      echo "   orange-launcher aktif."
    else
      echo "   Peringatan: orange-launcher tidak berjalan. Mungkin belum log in ke Xfce." >&2
    fi
  fi

  echo "=> Menyalakan daemon sentuh-ke-klik..."
  pkill -f "$HOME/.local/bin/touch-click" 2>/dev/null || true
  sleep 1
  DISPLAY=:0 nohup "$HOME/.local/bin/touch-click" >/dev/null 2>&1 &
  sleep 1
  if pgrep -f "$HOME/.local/bin/touch-click" >/dev/null 2>&1; then
    echo "   touch-click aktif."
  else
    echo "   Peringatan: touch-click tidak berjalan." >&2
  fi
else
  echo "=> Mode headless: launcher akan otomatis aktif setelah log masuk ke Xfce."
fi

if grep -q '"hide_panel": *true' "$HOME/.config/orange-launcher/config.json" 2>/dev/null; then
  echo "=> Panel bawah disembunyikan (pengaturan bawaan)..."
  pkill -x xfce4-panel 2>/dev/null || true
fi

echo "=> Menyiapkan wallpaper seukuran LCD (bangun-tidur presisi)..."
if [ -f /usr/share/backgrounds/orangepi/orangepi-default.png ] && python3 -c 'import PIL.Image' 2>/dev/null; then
  mkdir -p "$HOME/.local/share/backgrounds"
  GEO=$(DISPLAY=:0 xdotool getdisplaygeometry 2>/dev/null || echo "1024 600")
  TW=$(echo "$GEO" | cut -d' ' -f1); TH=$(echo "$GEO" | cut -d' ' -f2)
  # Pakai wallpaper MILIK pengguna bila ada (jangan timpa dgn stock).
  SRC=/usr/share/backgrounds/orangepi/orangepi-default.png
  if [ "$LIVE" = "yes" ]; then
    for f in $(DISPLAY=:0 xfconf-query -c xfce4-desktop -lv 2>/dev/null | grep -E 'image-path|last-image' | awk '{print $NF}'); do
      case "$f" in
        *.png|*.jpg|*.jpeg|*.bmp)
          if [ -f "$f" ] && [ "${f##*/}" != "orangepi-lcd.png" ]; then SRC="$f"; break; fi;;
      esac
    done
  fi
  echo "   sumber: $SRC"
  python3 - "$SRC" \
    "$HOME/.local/share/backgrounds/orangepi-lcd.png" "$TW" "$TH" <<'PYEOF' || true
import sys
from PIL import Image
src, dst, tw, th = sys.argv[1], sys.argv[2], int(sys.argv[3]), int(sys.argv[4])
im = Image.open(src).convert('RGB')
s = max(tw / im.width, th / im.height)
nw, nh = int(im.width * s + 0.5), int(im.height * s + 0.5)
im = im.resize((nw, nh), Image.LANCZOS)
x = (nw - tw) // 2; y = (nh - th) // 2
im.crop((x, y, x + tw, y + th)).save(dst)
print('wallpaper LCD: ' + dst)
PYEOF
  if [ -f "$HOME/.local/share/backgrounds/orangepi-lcd.png" ] && [ "$LIVE" = "yes" ]; then
    for p in $(DISPLAY=:0 xfconf-query -c xfce4-desktop -lv 2>/dev/null | grep 'last-image' | awk '{print $1}'); do
      DISPLAY=:0 xfconf-query -c xfce4-desktop -p "$p" \
        -s "$HOME/.local/share/backgrounds/orangepi-lcd.png" 2>/dev/null || true
    done
  fi
fi

echo ""
echo "SELESAI. Launcher Android aktif:"
echo "  Bilah navigasi kanan: Aplikasi, Kembali, Beranda, Terkini, Daya(merah)"
echo "  Sentuh sebentar sekali = klik. Buka dari Desktop/menu: Orange Launcher"
echo ""
echo "Cek status / log:"
echo "  pgrep -f orange-launcher"
echo "  tail -f /tmp/orange-launcher.log"