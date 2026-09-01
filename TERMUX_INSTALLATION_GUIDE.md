# 📱 InstaReporter - Panduan Instalasi Lengkap untuk Termux

> Dokumentasi lengkap untuk menginstal dan menjalankan InstaReporter di Termux dengan lancar.

## 📋 Daftar Isi
1. [Prasyarat](#prasyarat)
2. [Instalasi Awal](#instalasi-awal)
3. [Konfigurasi Proxy](#konfigurasi-proxy)
4. [Troubleshooting](#troubleshooting)
5. [Penggunaan](#penggunaan)

---

## ✅ Prasyarat

Pastikan Anda sudah memiliki:
- **Termux** (versi terbaru)
- Koneksi internet yang stabil
- Storage yang cukup (~500MB)

---

## 🚀 Instalasi Awal

### **Langkah 1: Update Sistem**
```bash
apt update && apt upgrade -y
```

### **Langkah 2: Install Dependencies**
```bash
apt install python3 python3-pip git curl wget -y
```

### **Langkah 3: Install Development Libraries**
⚠️ **PENTING**: Ini wajib untuk Termux!
```bash
apt install libffi-dev libssl-dev openssl-tool -y
```

### **Langkah 4: Clone Repository**
```bash
cd ~/storage/downloads
git clone https://github.com/muneebwanee/InstaReporter.git
cd InstaReporter
```

### **Langkah 5: Install Python Dependencies**
```bash
pip3 install --upgrade pip setuptools wheel
pip3 install requests[socks]>=2.28.0 colorama>=0.4.6 aiohttp[speedups]>=3.8.0 beautifulsoup4>=4.9.0
```

---

## ⚙️ Konfigurasi Proxy

### **Membuat File Proxy List**

1. Buat file `proxies.txt`:
```bash
nano proxies.txt
```

2. Paste proxy list Anda (format: `IP:PORT`, satu per baris):
```
192.168.1.1:8080
10.0.0.1:3128
172.16.0.1:9090
```

3. Simpan dengan: `Ctrl+X` → `Y` → `Enter`

### **Mencari Proxy Gratis**
Beberapa sumber proxy:
- https://www.proxy-list.download/
- https://www.sslproxies.org/
- https://free-proxy-list.com/

> ⚠️ Proxy gratis sering tidak stabil. Gunakan proxy berbayar untuk hasil maksimal.

---

## 🔧 Troubleshooting

### **Error 1: `proxybroker` not installed**
**Penyebab**: `proxybroker` tidak kompatibel dengan Termux.

**Solusi**:
```bash
pip3 uninstall proxybroker -y
```

### **Error 2: Module Import Error**
**Solusi - Edit `libs/check_modules.py`**:
```bash
nano libs/check_modules.py
```
Hapus atau comment baris yang memeriksa `proxybroker`.

### **Error 3: Connection Error (Instagram/Facebook)**
**Alasan**:
- Proxy mati atau expired
- Instagram memblock request
- Rate limiting

**Solusi**:
1. Update proxy list dengan yang baru
2. Gunakan VPN + Proxy kombinasi
3. Tunggu beberapa jam sebelum retry

### **Error 4: Indentation Error saat Run Script**
**Penyebab**: Extra space di awal baris code.

**Solusi**:
- Buka file dengan: `nano filename.py`
- Hapus semua, lalu paste kembali tanpa extra space
- Atau gunakan: `python3 -m py_compile filename.py` untuk check

---

## 📍 Penggunaan

### **Menjalankan InstaReporter**
```bash
python3 InstaReporter.py
```

### **Menu Interaktif**
Setelah run, akan muncul menu pilihan:

```
1. Mass Report (Instagram)
2. Mass Report (Facebook)
3. Akun Setting
4. Exit
```

### **Pilihan Mode**
- **Dengan Proxy**: Gunakan untuk menghindari blocking
- **Tanpa Proxy**: Lebih cepat tapi berisiko kena block

---

## 📊 File Structure
```
InstaReporter/
├── InstaReporter.py          # Main file
├── libs/
│   ├── check_modules.py      # Module checker
│   ├── proxy_harvester.py    # Proxy handler
│   └── reporter.py           # Core logic
├── proxies.txt               # Proxy list
└── README.md                 # Original documentation
```

---

## ⚠️ Disclaimer & Legal

**Penggunaan Tool Ini:**
- ⚖️ Hanya untuk **testing/learning purposes**
- 🚫 Jangan untuk harassment, spam, atau cyberbullying
- 📱 Instagram/Facebook dapat ban akun Anda
- ⚡ Gunakan dengan bijak dan tanggung jawab

**Konsekuensi Penggunaan Ilegal:**
- Account suspension/permanent ban
- Legal action dari Meta/Instagram
- Denda atau hukuman pidana

---

## 🔗 Resources

- **Original Repository**: https://github.com/muneebwanee/InstaReporter
- **Proxy Sources**: https://free-proxy-list.com/
- **Termux Guide**: https://wiki.termux.com/

---

## 🆘 Support

Jika masih error:
1. Cek apakah semua dependencies terinstall: `pip3 list`
2. Update Termux: `apt upgrade`
3. Bersihkan cache: `pip3 cache purge`
4. Reinstall dari awal jika perlu

**Last Updated**: 2026-09-01
