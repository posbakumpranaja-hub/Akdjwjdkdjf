# 🎯 FAQ - InstaReporter Termux

Pertanyaan yang sering diajukan dan jawabannya.

## 📱 Instalasi & Setup

### Q1: Berapa lama instalasi?
**A:** Sekitar 5-10 menit tergantung kecepatan internet Anda.
- Script otomatis: ~5 menit
- Manual setup: ~10 menit

### Q2: Apa kebutuhan storage?
**A:** Minimal 500MB free space untuk:
- Python packages: ~300MB
- App files: ~50MB
- Cache/temp: ~150MB

### Q3: Bisa di install di HP biasa?
**A:** **Ya!** Gunakan **Termux** (gratis di Play Store)
- Support: Android 5.0+
- RAM minimal: 2GB
- Storage minimal: 500MB

### Q4: Bagaimana jika sudah ada Python?
**A:** Tidak masalah. Script akan upgrade ke versi terbaru:
```bash
pip3 install --upgrade pip setuptools wheel
```

### Q5: Perlu root/superuser?
**A:** **TIDAK!** Termux sudah berjalan sebagai non-root user.

---

## 🔧 Masalah Teknis

### Q6: "pip: command not found"
**A:** Python/pip belum terinstall. Jalankan:
```bash
apt install python3 python3-pip -y
pip3 --version  # Verify
```

### Q7: "ModuleNotFoundError: No module named 'requests'"
**A:** Reinstall dependencies:
```bash
pip3 cache purge
pip3 install -r requirements.txt
python3 -c "import requests; print('✓ OK')"
```

### Q8: "proxybroker not installed!"
**A:** **NORMAL!** proxybroker tidak kompatibel Termux. Solusi:
```bash
pip3 uninstall proxybroker -y
# File check_modules.py sudah di-handle di doc
```

### Q9: Kenapa koneksi error terus?
**A:** Cek 3 hal:
1. **Proxy valid?** → Test di https://free-proxy-list.com/
2. **Internet stabil?** → `ping 8.8.8.8`
3. **Rate limiting?** → Tunggu 1-2 jam

### Q10: Bisa pakai VPN + Proxy?
**A:** **YA!** Kombinasi optimal:
```bash
# 1. Aktifkan VPN di HP
# 2. Buka Termux
# 3. Run dengan proxy
python3 InstaReporter.py
```

---

## ⚡ Performance & Optimasi

### Q11: Bagaimana cara cepatin proxy checking?
**A:** Edit `proxies.txt` dan gunakan proxy berkualitas:
```bash
# Gunakan sumber ini:
# - https://www.sslproxies.org/
# - https://www.proxy-list.download/
# - Hindari free proxy yang slow
```

### Q12: RAM penuh saat run, gimana?
**A:** Close apps lain, atau:
```bash
# Clear cache
rm -rf ~/.cache/*
pip3 cache purge

# Run dengan memory optimization
python3 -OO InstaReporter.py
```

### Q13: Script berjalan lambat
**A:** Kemungkinan:
1. Proxy connection lambat → ganti proxy
2. Device low specs → close background apps
3. Network bottleneck → coba lain waktu

### Q14: Berapa request per detik optimal?
**A:** Rekomendasi:
- Instagram: 1-3 request/detik (hindari ban)
- Facebook: 2-5 request/detik
- Dengan proxy: Bisa 5-10 request/detik (tapi risiko)

### Q15: Bagaimana monitor performance?
**A:** Gunakan script monitoring:
```bash
# Check process
ps aux | grep InstaReporter

# Check memory
free -h

# Check disk
df -h
```

---

## 🔐 Keamanan & Legal

### Q16: Apa risiko menggunakan tool ini?
**A:** Ada beberapa risiko:
1. **Akun ban** - Instagram/Facebook bisa ban akun
2. **Legal** - Bisa kena UU ITE jika harassment
3. **Data** - Jangan share credentials pribadi
4. **Proxy** - Proxy bisa track activity Anda

### Q17: Gimana cara aman?
**A:** Best practices:
```bash
# 1. Jangan gunakan akun pribadi important
# 2. Gunakan proxy reputable
# 3. Set rate limiting rendah
# 4. Monitor akun regularly
# 5. Stop jika ada warning
```

### Q18: Perlu hide identity?
**A:** Gunakan kombinasi:
- VPN + Proxy (double layer)
- Residential proxy (lebih aman)
- Multiple akun (spread requests)

### Q19: Apakah data aman?
**A:** Data local saja:
- Scripts berjalan di device Anda
- Tidak ada cloud upload
- Proxy list hanya di `proxies.txt`
- Hapus file setelah selesai jika perlu

### Q20: Apa disclaimer-nya?
**A:** Baca di **README.md** - Anda full tanggung jawab penggunaan!

---

## 📚 Troubleshooting Advanced

### Q21: IndentationError saat edit file?
**A:** Gunakan nano dengan benar:
```bash
nano file.py
# Jangan copy-paste! Ketik manual atau:
# Hapus semua (Ctrl+K), paste ulang
```

### Q22: Bagaimana jika script crashed?
**A:** Restart:
```bash
# Kill process
pkill -f InstaReporter

# Clear temp
rm -rf /tmp/insta*

# Run lagi
python3 InstaReporter.py
```

### Q23: Proxy list format?
**A:** **Format WAJIB** (IP:PORT per baris):
```
192.168.1.1:8080
10.0.0.1:3128
172.16.0.1:9090
# Komentar bisa
```

### Q24: Bisa schedule otomatis?
**A:** Gunakan `cron`:
```bash
# Edit crontab
crontab -e

# Tambah line (jalankan setiap jam):
0 * * * * cd ~/InstaReporter && python3 InstaReporter.py
```

### Q25: Gimana monitor dari jarak jauh?
**A:** Setup logging:
```bash
# Redirect output
python3 InstaReporter.py > log.txt 2>&1

# Monitor real-time
tail -f log.txt
```

---

## 💡 Tips & Tricks

### Q26: Proxy gratis vs berbayar?
**A:** Perbandingan:

| Aspek | Gratis | Berbayar |
|-------|--------|----------|
| Kecepatan | Lambat | Cepat |
| Reliability | 10-20% uptime | 95%+ uptime |
| Ban Risk | Tinggi | Rendah |
| Cost | $0 | $5-50/bln |

**Rekomendasi:** Gratis untuk test, berbayar untuk production

### Q27: Berapa proxy yang ideal?
**A:** Tergantung use case:
- Testing: 5-10 proxy
- Production: 20-50 proxy
- Large scale: 100+ proxy

### Q28: Bagaimana rotate proxy otomatis?
**A:** Script handle ini, tapi bisa manual:
```bash
# Shuffle proxy list
sort -R proxies.txt > proxies_shuffled.txt
mv proxies_shuffled.txt proxies.txt
```

### Q29: Bisa multi-threading?
**A:** Hati-hati dengan thread! Rekomendasi:
- Max 3-5 thread (hindari detection)
- Gunakan proxy rotation per thread
- Monitor resource usage

### Q30: Kapan script selesai?
**A:** Script selesai ketika:
- Semua target selesai
- Error kritis terjadi
- User stop manual (Ctrl+C)

---

## 🆘 Tidak Ketemu Jawaban?

### Resources:
- 📖 **TERMUX_INSTALLATION_GUIDE.md** - Panduan lengkap
- 🔧 **TROUBLESHOOTING.md** - Error solutions
- 💬 **GitHub Issues** - Tanya di forum
- 🌐 **Stack Overflow** - Tag `termux` + `python`

---

**Last Updated**: September 1, 2026
**Questions Covered**: 30+
**Status**: ✅ Complete
