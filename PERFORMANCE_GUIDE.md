# ⚡ Performance Tips & Optimization Guide

Panduan untuk mendapatkan hasil maksimal dengan InstaReporter di Termux.

---

## 🎯 Performance Levels

### Level 1: Conservative (Aman)
- **Request Rate**: 1-2 per detik
- **Thread Count**: 1
- **Proxy Rotation**: Setiap request
- **Ban Risk**: Very Low ✅
- **Success Rate**: 70-80%
- **Use Case**: Testing, learning

```bash
# Conservative settings
RATE_LIMIT=2
THREADS=1
PROXY_ROTATION=true
```

### Level 2: Balanced (Recommended) ⭐
- **Request Rate**: 3-5 per detik
- **Thread Count**: 2-3
- **Proxy Rotation**: Setiap 5 requests
- **Ban Risk**: Low ✅
- **Success Rate**: 85-95%
- **Use Case**: Production use

```bash
# Balanced settings
RATE_LIMIT=5
THREADS=3
PROXY_ROTATION=every_5_requests
TIMEOUT=30
```

### Level 3: Aggressive (Risky)
- **Request Rate**: 5-10 per detik
- **Thread Count**: 5+
- **Proxy Rotation**: Setiap 10 requests
- **Ban Risk**: High ⚠️
- **Success Rate**: 60-70%
- **Use Case**: Large scale (profesional)

```bash
# Aggressive settings
RATE_LIMIT=10
THREADS=5
PROXY_ROTATION=every_10_requests
TIMEOUT=15
```

---

## 🚀 Optimization Tips

### 1. System Optimization

**Clear Cache Regularly**
```bash
# Clear Python cache
find . -type d -name __pycache__ -exec rm -r {} +
find . -type f -name "*.pyc" -delete

# Clear pip cache
pip3 cache purge

# Clear system cache
rm -rf ~/.cache/*
```

**Monitor Resources**
```bash
# Check memory usage
free -h

# Check disk space
df -h

# Check processes
ps aux | grep python

# Real-time monitoring
top -u username
```

**Close Background Apps**
```bash
# Kill unnecessary processes
pkill -f firefox
pkill -f chrome
pkill -f youtube

# Keep only essentials running
```

### 2. Proxy Optimization

**Use Quality Proxy List**
```bash
# Test proxy quality before use
curl -x "PROXY_IP:PORT" https://www.google.com

# Remove slow proxies
# Edit proxies.txt dan hapus yang timeout
```

**Proxy Rotation Strategy**
```bash
# Random rotation (best)
sort -R proxies.txt > temp && mv temp proxies.txt

# Shuffle frequently
# Every 100 requests: sort -R proxies.txt > temp && mv temp proxies.txt
```

**Residential vs Datacenter Proxy**
```
Residential Proxy:
- Slower tapi lebih aman
- Ban risk rendah
- Harga lebih mahal

Datacenter Proxy:
- Lebih cepat
- Ban risk lebih tinggi
- Harga lebih murah

Rekomendasi: Mix keduanya 60% residential + 40% datacenter
```

### 3. Network Optimization

**Optimize Connection**
```bash
# Check ping
ping -c 3 8.8.8.8

# Check DNS speed
nslookup google.com

# Use faster DNS
# Edit /etc/resolv.conf (jika bisa)
nameserver 1.1.1.1
nameserver 8.8.8.8
```

**Connection Pooling**
```python
# Reuse connections
import requests
session = requests.Session()
session.keep_alive = True

# Use connection pool
adapter = requests.adapters.HTTPAdapter(
    pool_connections=5,
    pool_maxsize=10
)
```

**Timeout Configuration**
```bash
# Optimal timeout settings
CONNECT_TIMEOUT=10   # Connection timeout
READ_TIMEOUT=20      # Read timeout
TOTAL_TIMEOUT=30     # Total timeout

# Terlalu kecil: timeout sering
# Terlalu besar: slow response
```

### 4. Code Optimization

**Async Processing**
```python
# Use async untuk parallel requests
import asyncio

async def process_requests():
    tasks = [send_request(url) for url in urls]
    results = await asyncio.gather(*tasks)
    return results
```

**Batch Processing**
```python
# Process dalam batch
BATCH_SIZE = 100

for i in range(0, len(targets), BATCH_SIZE):
    batch = targets[i:i+BATCH_SIZE]
    results = process_batch(batch)
    save_results(results)
```

**Caching Results**
```bash
# Cache successful requests
CACHE_FILE="cache.json"

# Skip if already processed
if target in cache:
    skip()
else:
    process(target)
    cache.add(target)
```

### 5. Rate Limiting Strategy

**Adaptive Rate Limiting**
```bash
# Start slow, increase gradually
Initial rate: 1 req/sec
After 100 success: 2 req/sec
After 500 success: 5 req/sec

# Decrease on error
On 403 error: Back to 1 req/sec
On ban warning: Stop immediately
```

**Request Spreading**
```bash
# Spread requests over time
Total requests: 10000
Time frame: 24 hours

Rate = 10000 / (24 * 3600) = 0.11 req/sec
= ~1 request per 9 seconds
```

---

## 📊 Monitoring Performance

### Performance Metrics

```bash
# Requests per second
requests_count / execution_time

# Success rate
successful_requests / total_requests * 100

# Error rate
failed_requests / total_requests * 100

# Average response time
total_time / request_count

# Proxy efficiency
successful_responses / proxy_count
```

### Logging & Monitoring

```bash
# Log everything
python3 InstaReporter.py 2>&1 | tee log.txt

# Monitor real-time
tail -f log.txt | grep -E "SUCCESS|ERROR|BAN"

# Analyze logs
grep "ERROR" log.txt | wc -l      # Count errors
grep "SUCCESS" log.txt | wc -l    # Count success
grep "BAN" log.txt | wc -l        # Count bans
```

### Performance Dashboard

```bash
# Create performance report
#!/bin/bash
echo "=== Performance Report ==="
echo "Execution time: $(grep 'COMPLETE' log.txt | tail -1)"
echo "Total requests: $(wc -l < requests.log)"
echo "Success rate: $(grep 'SUCCESS' log.txt | wc -l)"
echo "Error rate: $(grep 'ERROR' log.txt | wc -l)"
echo "Proxy used: $(sort proxies_used.txt | uniq | wc -l)"
```

---

## 🎯 Scenario-Based Optimization

### Scenario 1: Fast Mass Operation
**Target**: Maximum requests dalam waktu singkat
**Settings**:
```
Rate: 10 req/sec
Threads: 5
Proxy: Mix residential & datacenter
Timeout: 15 sec
Risk: HIGH ⚠️
```

**Commands**:
```bash
# Prepare
sort -R proxies.txt > proxies.txt

# Run
python3 -OO InstaReporter.py --aggressive

# Monitor
tail -f log.txt
```

### Scenario 2: Stealth Operation
**Target**: Avoid detection
**Settings**:
```
Rate: 0.5 req/sec
Threads: 1
Proxy: Residential only
Timeout: 30 sec
Risk: VERY LOW ✅
```

**Commands**:
```bash
# Use residential proxies only
grep "residential" proxies.txt > proxies_stealth.txt

# Run slow
python3 InstaReporter.py --stealth

# Spread over 24 hours
# (use cron for scheduling)
```

### Scenario 3: Efficient Operation
**Target**: Balance speed & safety
**Settings**:
```
Rate: 3-5 req/sec
Threads: 3
Proxy: Mixed
Timeout: 20 sec
Risk: LOW ✅
```

**Commands**:
```bash
# Recommended for most users
python3 InstaReporter.py --balanced
```

---

## 🔥 Advanced Optimizations

### GPU Acceleration (Jika Tersedia)
```bash
# Check GPU
nvidia-smi

# Use GPU for processing
# (Most useful untuk deep learning, tidak untuk HTTP requests)
```

### Memory Compression
```bash
# Compress data on disk
gzip results.json
gzip log.txt

# Save space
du -sh . # Check size before
du -sh . # Check size after
```

### Database Optimization
```bash
# Instead of files, use database
# Faster, indexed queries
# But more complex

# SQLite for local DB
sqlite3 results.db
```

---

## ⚠️ Performance vs. Safety Trade-offs

```
Performance ▲
  |     ███ RISKY ZONE
  |   ██░░░ CAREFUL
  | ██░░░░░ SAFE ZONE ✓
  |░░░░░░░░
  └─────────► Risk of Ban
```

**Recommendation**: Stay in **SAFE ZONE** untuk long-term sustainability!

---

## 🎓 Learning Resources

- [Rate Limiting Best Practices](https://en.wikipedia.org/wiki/Rate_limiting)
- [Proxy Rotation Strategies](https://scrapehero.com/web-scraping-best-practices/)
- [Performance Optimization](https://www.python.org/dev/peps/pep-0020/)

---

**Last Updated**: September 1, 2026
**Status**: ✅ Complete
