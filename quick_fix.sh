#!/bin/bash

###############################################
# ULTIMATE FIX untuk proxybroker error
# Solusi lengkap tanpa perlu install proxybroker
###############################################

clear
echo "╔════════════════════════════════════════════╗"
echo "║   🔧 InstaReporter - ULTIMATE FIX v2.0    ║"
echo "║   Mengatasi Error: proxybroker not found  ║"
echo "╚════════════════════════════════════════════╝"
echo ""

# Detect current directory
if [ -f "InstaReporter.py" ]; then
    echo "✓ InstaReporter.py ditemukan"
else
    echo "✗ InstaReporter.py tidak ditemukan!"
    echo "Pastikan Anda di folder InstaReporter"
    exit 1
fi

echo ""
echo "OPSI SOLUSI:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "1) DISABLE proxybroker check (RECOMMENDED)"
echo "2) Install missing dependencies"
echo "3) Edit InstaReporter.py manual"
echo "4) View current error"
echo "0) Exit"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
read -p "Pilih opsi (0-4): " choice

case $choice in
    1)
        echo ""
        echo "🔧 Disabling proxybroker check..."
        echo ""
        
        # Backup original
        if [ ! -f "InstaReporter.py.backup" ]; then
            cp InstaReporter.py InstaReporter.py.backup
            echo "✓ Backup dibuat: InstaReporter.py.backup"
        fi
        
        # Method 1: Comment out proxybroker import
        sed -i "s/from proxybroker import/# from proxybroker import/g" InstaReporter.py
        
        # Method 2: Comment out error check
        sed -i "s/\['\-'\] 'proxybroker' package/# ['-'] 'proxybroker' package/g" InstaReporter.py
        sed -i "s/Type 'pip install proxybroker'/# Disabled: proxybroker not needed/g" InstaReporter.py
        
        # Method 3: Find and comment check_modules if exists
        if grep -q "check_modules" InstaReporter.py; then
            sed -i "s/check_modules()/# check_modules() - disabled/g" InstaReporter.py
            echo "✓ check_modules() disabled"
        fi
        
        echo "✓ proxybroker check disabled"
        echo ""
        echo "✅ SELESAI!"
        echo ""
        echo "Sekarang jalankan:"
        echo "  python3 InstaReporter.py"
        echo ""
        ;;
        
    2)
        echo ""
        echo "📦 Installing dependencies..."
        echo ""
        
        # Install with system packages flag
        echo "Installing: requests, colorama, aiohttp, beautifulsoup4..."
        pip3 install --break-system-packages requests colorama aiohttp beautifulsoup4 -q
        
        if [ $? -eq 0 ]; then
            echo "✓ Dependencies installed successfully"
            echo ""
            echo "Note: proxybroker TIDAK diperlukan untuk Termux"
            echo ""
            echo "Sekarang jalankan:"
            echo "  python3 InstaReporter.py"
        else
            echo "✗ Installation failed"
            echo ""
            echo "Try: pip3 install --break-system-packages -r requirements.txt"
        fi
        echo ""
        ;;
        
    3)
        echo ""
        echo "📝 Opening editor for manual fix..."
        echo ""
        echo "Cari baris yang berisi 'proxybroker' dan comment (#)"
        echo "Contoh:"
        echo "  # from proxybroker import"
        echo "  # if 'proxybroker' not in modules:"
        echo ""
        
        # Try different editors
        if command -v nano &> /dev/null; then
            nano InstaReporter.py
        elif command -v vi &> /dev/null; then
            vi InstaReporter.py
        else
            echo "✗ No editor found (nano/vi)"
        fi
        echo ""
        ;;
        
    4)
        echo ""
        echo "📋 Current error:"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        python3 InstaReporter.py 2>&1 | head -20
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        ;;
        
    0)
        echo "Goodbye! 👋"
        exit 0
        ;;
        
    *)
        echo "✗ Invalid option!"
        exit 1
        ;;
esac

echo ""
echo "═══════════════════════════════════════════"
echo "Need more help? Check:"
echo "  - README.md"
echo "  - TROUBLESHOOTING.md"
echo "  - FAQ.md"
echo "═══════════════════════════════════════════"
