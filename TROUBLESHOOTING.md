# 🔧 Troubleshooting Guide - InstaReporter on Termux

Panduan lengkap untuk mengatasi error yang sering terjadi saat instalasi dan penggunaan InstaReporter di Termux.

---

## 📋 Daftar Error

1. [proxybroker not installed](#proxybroker-not-installed)
2. [IndentationError](#indentationerror)
3. [Connection Error](#connection-error)
4. [Module Not Found](#module-not-found)
5. [Permission Denied](#permission-denied)
6. [Timeout Error](#timeout-error)
7. [Out of Memory](#out-of-memory)

---

## ❌ proxybroker not installed

### Error Message
```
[-] 'proxybroker' package not installed!
[*] Type 'pip install proxybroker' to install!
```

### Penyebab
`proxybroker` tidak kompatibel dengan Termux. Package ini tidak support untuk Android/Termux environment.

### ✅ Solusi

**Option 1: Uninstall proxybroker**
```bash
pip3 uninstall proxybroker -y
```

**Option 2: Edit check_modules.py**
```bash
nano libs/check_modules.py
```
Hapus atau comment baris:
```python
# from proxybroker import Broker
```

**Option 3: Gunakan requirements.txt yang sudah dioptimalkan**
```bash
pip3 install -r requirements.txt
```

---

## ❌ IndentationError

### Error Message
```
File "...instagram_bot.py", line 1
    from instagrapi import Client
IndentationError: unexpected indent
```

### Penyebab
Ada extra space/tab di awal baris code.

### ✅ Solusi

**Method 1: Re-edit file**
```bash
nano filename.py
```
- Hapus SEMUA isi file (Ctrl+A → Delete)
- Paste kembali code yang benar (tanpa leading spaces)
- Simpan (Ctrl+X → Y → Enter)

**Method 2: Verify with Python compiler**
```bash
python3 -m py_compile filename.py
```

**Method 3: Remove leading whitespace**
```bash
# Menggunakan sed untuk remove leading spaces
sed 's/^[[:space:]]*//g' filename.py > filename_fixed.py
mv filename_fixed.py filename.py
```

---

## ❌ Connection Error

### Error Message
```
[ ERR ] Connection error has occurred! (FacebookRequestsError)
[ ERR ] Connection error has occurred! (InstagramRequestsError)
```

### Penyebab
- ❌ Proxy mati atau expired
- ❌ Instagram/Facebook memblock request
- ❌ Rate limiting (terlalu banyak request)
- ❌ Network connectivity issue

### ✅ Solusi

**Step 1: Cek proxy list**
```bash
# Buka dan lihat proxies.txt
cat proxies.txt

# Update dengan proxy baru dari:
# https://free-proxy-list.com/
```

**Step 2: Test proxy connectivity**
```bash
# Test single proxy
curl -x "192.168.1.1:8080" https://www.google.com

# Install curl jika belum
apt install curl -y
```

**Step 3: Tunggu sebelum retry**
```bash
# Instagram rate-limiting: tunggu 1-2 jam
sleep 3600  # 1 hour
python3 InstaReporter.py
```

**Step 4: Gunakan VPN + Proxy**
- Aktifkan VPN terlebih dahulu
- Kemudian jalankan app dengan proxy

**Step 5: Clear cache & retry**
```bash
rm -rf ~/.cache
pip3 cache purge
python3 InstaReporter.py
```

---

## ❌ Module Not Found

### Error Message
```
ModuleNotFoundError: No module named 'requests'
ModuleNotFoundError: No module named 'aiohttp'
```

### Penyebab
Module belum terinstall atau Python tidak menemukan module.

### ✅ Solusi

**Option 1: Install specific module**
```bash
pip3 install requests
pip3 install aiohttp
pip3 install beautifulsoup4
```

**Option 2: Install dari requirements.txt**
```bash
pip3 install -r requirements.txt
```

**Option 3: Check installed packages**
```bash
pip3 list
# Cari module yang Anda cari di list
```

**Option 4: Verify import**
```bash
python3 -c "import requests; print(requests.__version__)"
```

**Option 5: Reinstall semua dependencies**
```bash
pip3 uninstall -r requirements.txt -y
pip3 cache purge
pip3 install --upgrade pip
pip3 install -r requirements.txt
```

---

## ❌ Permission Denied

### Error Message
```
Permission denied: 'InstaReporter.py'
bash: ./InstaReporter.py: Permission denied
```

### Penyebab
File tidak memiliki permission untuk execute.

### ✅ Solusi

**Option 1: Give execute permission**
```bash
chmod +x InstaReporter.py
chmod +x install.sh
```

**Option 2: Run with python3**
```bash
# Instead of:
./InstaReporter.py

# Do this:
python3 InstaReporter.py
```

**Option 3: Check file permissions**
```bash
ls -la InstaReporter.py
# Seharusnya output: -rwxr-xr-x (atau similar)
```

---

## ❌ Timeout Error

### Error Message
```
ConnectTimeout: Failed to connect
ReadTimeout: Failed to read data
socket.timeout: timed out
```

### Penyebab
- ❌ Network connection lambat
- ❌ Proxy connection timeout
- ❌ Server Instagram/Facebook tidak respond

### ✅ Solusi

**Option 1: Increase timeout value**
Edit code dan tambahkan timeout parameter:
```python
import requests
response = requests.get(url, timeout=30)  # 30 seconds
```

**Option 2: Cek network**
```bash
# Ping google untuk test koneksi
ping 8.8.8.8

# Cek proxy connectivity
curl -x "192.168.1.1:8080" https://www.google.com
```

**Option 3: Gunakan proxy dengan connection pooling**
```python
import requests
session = requests.Session()
# Reuse connection untuk multiple requests
```

**Option 4: Retry mechanism**
```python
import time
for retry in range(3):
    try:
        # Your code
        break
    except Exception as e:
        print(f"Retry {retry+1}/3...")
        time.sleep(2 ** retry)
```

---

## ❌ Out of Memory

### Error Message
```
MemoryError: Unable to allocate memory
Killed (signal 9)
```

### Penyebab
Termux running out of available memory (RAM).

### ✅ Solusi

**Option 1: Close background apps**
```bash
# Check running processes
ps aux

# Kill unnecessary apps
pkill -f appname
```

**Option 2: Clear cache & temp files**
```bash
# Clear Python cache
find . -type d -name __pycache__ -exec rm -r {} +

# Clear pip cache
pip3 cache purge

# Clear system cache
rm -rf ~/.cache/*
```

**Option 3: Increase swap memory**
```bash
# Check current swap
swapon --show

# Create swap file (if on Termux)
fallocate -l 1G /data/local/tmp/swapfile
chmod 600 /data/local/tmp/swapfile
mkswap /data/local/tmp/swapfile
swapon /data/local/tmp/swapfile
```

**Option 4: Reduce process size**
- Gunakan Python3 dengan `-OO` flag (optimize)
```bash
python3 -OO InstaReporter.py
```

---

## 🔍 Debug Checklist

Sebelum troubleshoot, pastikan:

- ✅ Python3 terinstall: `python3 --version`
- ✅ Pip terinstall: `pip3 --version`
- ✅ Dependencies terinstall: `pip3 list`
- ✅ Proxy file exist: `ls proxies.txt`
- ✅ File permissions OK: `ls -la *.py`
- ✅ Network connected: `ping 8.8.8.8`
- ✅ Termux updated: `apt upgrade`

---

## 📋 Quick Fix Commands

```bash
# 1. Full system update
apt update && apt upgrade -y

# 2. Reinstall all dependencies
pip3 cache purge
pip3 install -r requirements.txt

# 3. Remove problematic packages
pip3 uninstall proxybroker -y

# 4. Clear all cache
rm -rf ~/.cache/*
find . -type d -name __pycache__ -exec rm -r {} +

# 5. Verify installation
python3 -m py_compile InstaReporter.py
python3 -c "import requests, aiohttp, colorama; print('✓ OK')"

# 6. Run with debug mode
python3 -u InstaReporter.py  # Unbuffered output
```

---

## 🎯 Still Not Working?

Jika semua solusi tidak berhasil:

1. **Reinstall dari awal**:
   ```bash
   rm -rf InstaReporter
   bash install.sh
   ```

2. **Report issue** dengan:
   - `python3 --version`
   - `pip3 list`
   - Error message (full)
   - Steps yang sudah dicoba

3. **Check resources**:
   - GitHub Issues: https://github.com/muneebwanee/InstaReporter/issues
   - Stack Overflow: Tag `termux` dan `python`

---

**Last Updated**: September 1, 2026
**Status**: ✅ Complete
