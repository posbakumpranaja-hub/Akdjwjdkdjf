# 🚀 Deployment & Advanced Setup Guide

Panduan lengkap untuk deploy InstaReporter di berbagai environment.

---

## 📱 Deployment Targets

### 1. Termux (Android) - PRIMARY ⭐
**Status**: ✅ Fully Supported
**Setup Time**: 5-10 menit
**Recommended**: YES

```bash
# Quick start
bash setup_wizard.sh

# Manual
apt update && apt upgrade -y
apt install python3 python3-pip git -y
git clone https://github.com/muneebwanee/InstaReporter.git
cd InstaReporter
pip3 install -r requirements.txt
python3 InstaReporter.py
```

### 2. Linux Desktop/Server
**Status**: ✅ Supported
**Setup Time**: 10-15 menit
**Recommended**: YES (for production)

```bash
# Ubuntu/Debian
sudo apt update && sudo apt upgrade -y
sudo apt install python3 python3-pip git -y

# Fedora
sudo dnf install python3 python3-pip git -y

# Setup
git clone https://github.com/muneebwanee/InstaReporter.git
cd InstaReporter
pip3 install -r requirements.txt
python3 InstaReporter.py
```

### 3. macOS
**Status**: ✅ Supported
**Setup Time**: 10 menit
**Recommended**: YES

```bash
# Install Homebrew (jika belum)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install dependencies
brew install python3 git

# Setup
git clone https://github.com/muneebwanee/InstaReporter.git
cd InstaReporter
pip3 install -r requirements.txt
python3 InstaReporter.py
```

### 4. Windows (via WSL)
**Status**: ⚠️ Partially Supported
**Setup Time**: 15-20 menit
**Recommended**: Use WSL2

```bash
# Dalam WSL2
apt update && apt upgrade -y
apt install python3 python3-pip git -y

# Lanjutkan seperti Linux
git clone https://github.com/muneebwanee/InstaReporter.git
cd InstaReporter
pip3 install -r requirements.txt
python3 InstaReporter.py
```

### 5. Docker (Linux/Mac/Windows)
**Status**: 🔄 In Development
**Setup Time**: 5 menit
**Recommended**: For containerized deployment

```bash
# Dockerfile akan ditambah di future release
# Untuk sekarang, gunakan Linux native atau WSL
```

---

## 🔧 Production Deployment

### Server Setup (Ubuntu 20.04 LTS)

```bash
# 1. Update system
sudo apt update && sudo apt upgrade -y

# 2. Install dependencies
sudo apt install python3 python3-pip git curl wget -y

# 3. Create dedicated user
sudo useradd -m -s /bin/bash insta
sudo su - insta

# 4. Clone repository
git clone https://github.com/muneebwanee/InstaReporter.git
cd InstaReporter

# 5. Create virtual environment
python3 -m venv venv
source venv/bin/activate

# 6. Install requirements
pip install --upgrade pip
pip install -r requirements.txt

# 7. Setup proxy list
nano proxies.txt
# Tambah proxy list

# 8. Run background
nohup python3 InstaReporter.py > insta.log 2>&1 &
```

### Monitoring Production

```bash
# Check process
ps aux | grep InstaReporter

# Check logs
tail -f insta.log

# Check resource usage
top -u insta

# Restart service
pkill -f InstaReporter
sleep 2
nohup python3 InstaReporter.py > insta.log 2>&1 &
```

### Systemd Service (Optional)

```bash
# Create service file
sudo nano /etc/systemd/system/insta.service

# Content:
[Unit]
Description=InstaReporter Service
After=network.target

[Service]
Type=simple
User=insta
WorkingDirectory=/home/insta/InstaReporter
ExecStart=/home/insta/InstaReporter/venv/bin/python3 InstaReporter.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target

# Enable & start
sudo systemctl daemon-reload
sudo systemctl enable insta
sudo systemctl start insta
sudo systemctl status insta
```

---

## 🔒 Security Hardening

### 1. Firewall Configuration

```bash
# UFW (Ubuntu)
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp   # SSH only
sudo ufw enable

# Iptables
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -j DROP
```

### 2. SSH Hardening

```bash
# Edit sshd config
sudo nano /etc/ssh/sshd_config

# Key changes:
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
Port 2222  # Change default port

# Restart SSH
sudo systemctl restart ssh
```

### 3. User Permissions

```bash
# Create restricted user
sudo useradd -m -s /bin/bash -G sudo insta
sudo chmod 700 /home/insta

# No sudo password needed (optional)
# sudo visudo
# insta ALL=(ALL) NOPASSWD: ALL
```

### 4. Log Rotation

```bash
# Setup logrotate
sudo nano /etc/logrotate.d/insta

# Content:
/home/insta/InstaReporter/insta.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    create 0640 insta insta
}
```

---

## 📊 Monitoring & Analytics

### Setup Monitoring

```bash
# Install monitoring tools
sudo apt install htop iotop nethogs -y

# Monitor in real-time
htop
iotop
nethogs

# Setup cron job for logs
crontab -e

# Add:
0 * * * * cd /home/insta/InstaReporter && tail -1000 insta.log > insta_archive_$(date +\%Y\%m\%d).log
```

### Create Dashboard

```bash
# Install dashboard tools
pip install rich pandas matplotlib

# Create monitoring script
cat > monitor.py << 'EOF'
#!/usr/bin/env python3
import subprocess
import json
from datetime import datetime

def get_stats():
    result = subprocess.run(['ps', 'aux'], capture_output=True, text=True)
    
    stats = {
        'timestamp': datetime.now().isoformat(),
        'process_count': len([l for l in result.stdout.split('\n') if 'InstaReporter' in l]),
        'uptime': subprocess.run(['uptime'], capture_output=True, text=True).stdout.strip()
    }
    
    return stats

if __name__ == '__main__':
    print(json.dumps(get_stats(), indent=2))
EOF

chmod +x monitor.py
python3 monitor.py
```

---

## 🔄 Backup & Recovery

### Automated Backup

```bash
# Create backup script
cat > backup.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/home/insta/backups"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR

# Backup data
tar -czf $BACKUP_DIR/insta_$DATE.tar.gz \
    /home/insta/InstaReporter/results* \
    /home/insta/InstaReporter/proxies.txt \
    /home/insta/InstaReporter/insta.log

# Keep only last 7 days
find $BACKUP_DIR -name "insta_*.tar.gz" -mtime +7 -delete

echo "Backup completed: $BACKUP_DIR/insta_$DATE.tar.gz"
EOF

chmod +x backup.sh

# Schedule via cron
crontab -e
# Add: 0 2 * * * /home/insta/backup.sh
```

### Recovery Procedure

```bash
# List backups
ls -lh /home/insta/backups/

# Restore from backup
cd /home/insta/InstaReporter
tar -xzf /home/insta/backups/insta_20260901_020000.tar.gz

# Verify
ls -la
```

---

## 🚨 Troubleshooting Deployment

### Port Already in Use

```bash
# Find process using port
sudo lsof -i :PORT_NUMBER

# Kill process
sudo kill -9 PID

# Or change port in config
# Edit InstaReporter.py config
```

### Out of Memory

```bash
# Check memory
free -h

# Clear cache
sudo sync && sudo echo 3 > /proc/sys/vm/drop_caches

# Limit process memory
ulimit -v 1000000  # 1GB limit
```

### High Disk Usage

```bash
# Find large files
du -sh /*

# Compress logs
gzip /home/insta/InstaReporter/insta.log

# Archive old results
tar -czf results_archive_$(date +%Y%m).tar.gz results_* 
rm results_*
```

---

## 📈 Performance Tuning

### Optimize System

```bash
# Increase file descriptors
sudo nano /etc/security/limits.conf
# Add: insta soft nofile 65536
#      insta hard nofile 65536

# Kernel parameters
sudo nano /etc/sysctl.conf
# Add: net.ipv4.tcp_tw_reuse = 1
#      net.ipv4.ip_local_port_range = 10000 65000

sudo sysctl -p
```

### Python Optimization

```bash
# Use PyPy for faster execution (jika ada)
pip install pypy3

# Or use optimization flags
python3 -OO InstaReporter.py  # -OO untuk aggressive optimization
```

---

## 🎯 Deployment Checklist

- [ ] System updated (`apt update && apt upgrade`)
- [ ] Python 3.7+ installed
- [ ] Dependencies installed (`pip install -r requirements.txt`)
- [ ] Proxy list configured (`proxies.txt`)
- [ ] Firewall configured
- [ ] SSH hardened
- [ ] Monitoring setup
- [ ] Backup script configured
- [ ] Logrotate configured
- [ ] Service auto-restart configured
- [ ] Regular backups tested
- [ ] Security audit completed

---

**Last Updated**: September 1, 2026
**Status**: ✅ Complete Deployment Guide
