#!/bin/bash

###############################################
# Quick Fix Script untuk Error proxybroker
# Solusi cepat tanpa perlu install proxybroker
###############################################

echo "🔧 InstaReporter - Quick Fix Script"
echo "===================================="
echo ""

# Option 1: Skip proxybroker check
echo "Option 1: Skip proxybroker (RECOMMENDED)"
echo "========================================="
echo ""
echo "Ini akan membuat script tidak check proxybroker"
echo ""

read -p "Continue with Option 1? (y/n): " choice

if [ "$choice" = "y" ]; then
    echo "✓ Removing proxybroker check..."
    
    # Backup original file
    if [ -f "InstaReporter.py" ]; then
        cp InstaReporter.py InstaReporter.py.backup
        echo "✓ Backup dibuat: InstaReporter.py.backup"
    fi
    
    # Remove/comment proxybroker import
    sed -i 's/from proxybroker import/# from proxybroker import/' InstaReporter.py
    sed -i "s/\['\-'\] 'proxybroker'/# [\'-\'] 'proxybroker'/" InstaReporter.py
    sed -i "s/Type 'pip install proxybroker'/# Type 'pip install proxybroker'/" InstaReporter.py
    
    echo "✓ proxybroker check disabled"
    echo ""
    echo "Now try running:"
    echo "  python3 InstaReporter.py"
    
elif [ "$choice" = "n" ]; then
    echo ""
    echo "Option 2: Install Other Dependencies"
    echo "====================================="
    echo ""
    echo "Installing required packages..."
    
    pip3 install --break-system-packages requests colorama aiohttp beautifulsoup4 -q
    
    if [ $? -eq 0 ]; then
        echo "✓ Dependencies installed successfully"
        echo ""
        echo "Note: proxybroker tidak diperlukan untuk Termux"
        echo "Anda bisa menggunakan proxy tanpa proxybroker"
    else
        echo "✗ Installation failed"
    fi
fi

echo ""
echo "================================"
echo "Setup complete! 🚀"
echo "================================"
