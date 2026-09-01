#!/bin/bash

###############################################
# Proxy Checker Script
# Validates proxy list and tests connectivity
###############################################

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Functions
print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}  Proxy Checker for InstaReporter${NC}"
    echo -e "${BLUE}================================${NC}"
    echo ""
}

print_status() {
    echo -e "${BLUE}[*]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Check if curl is installed
check_curl() {
    if ! command -v curl &> /dev/null; then
        print_error "curl is not installed"
        print_status "Installing curl..."
        apt install curl -y
    else
        print_success "curl found"
    fi
}

# Check proxy file exists
check_proxy_file() {
    if [ ! -f "proxies.txt" ]; then
        print_error "proxies.txt not found!"
        exit 1
    fi
    print_success "proxies.txt found"
    PROXY_COUNT=$(wc -l < proxies.txt)
    echo -e "${BLUE}[*]${NC} Total proxies to test: $PROXY_COUNT"
}

# Validate proxy format
validate_format() {
    print_status "Validating proxy format..."
    
    INVALID=0
    while IFS= read -r line; do
        # Skip empty lines and comments
        [[ -z "$line" || "$line" =~ ^# ]] && continue
        
        # Check format: IP:PORT
        if ! [[ $line =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}:[0-9]{1,5}$ ]]; then
            print_error "Invalid format: $line"
            ((INVALID++))
        fi
    done < proxies.txt
    
    if [ $INVALID -eq 0 ]; then
        print_success "All proxies have valid format"
    else
        print_warning "Found $INVALID invalid proxy entries"
    fi
}

# Test proxy connectivity
test_proxy() {
    local proxy="$1"
    local timeout=10
    
    # Test with curl
    if curl -x "http://$proxy" \
        --connect-timeout $timeout \
        --max-time $timeout \
        -s -o /dev/null -w "%{http_code}" \
        https://www.google.com > /dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# Main testing loop
test_proxies() {
    print_status "Testing proxies connectivity..."
    echo ""
    
    WORKING=0
    DEAD=0
    TESTED=0
    
    while IFS= read -r proxy; do
        # Skip empty lines and comments
        [[ -z "$proxy" || "$proxy" =~ ^# ]] && continue
        
        ((TESTED++))
        echo -ne "Testing [$TESTED] $proxy ... "
        
        if test_proxy "$proxy"; then
            echo -e "${GREEN}✓ OK${NC}"
            echo "$proxy" >> proxies_working.txt
            ((WORKING++))
        else
            echo -e "${RED}✗ DEAD${NC}"
            echo "$proxy" >> proxies_dead.txt
            ((DEAD++))
        fi
        
        # Progress indicator
        if [ $((TESTED % 5)) -eq 0 ]; then
            echo -e "${YELLOW}[Progress: $TESTED tested, $WORKING working, $DEAD dead]${NC}"
        fi
        
    done < proxies.txt
    
    echo ""
    print_status "Testing complete!"
}

# Generate report
generate_report() {
    echo ""
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}  Test Report${NC}"
    echo -e "${BLUE}================================${NC}"
    
    WORKING=$([ -f proxies_working.txt ] && wc -l < proxies_working.txt || echo "0")
    DEAD=$([ -f proxies_dead.txt ] && wc -l < proxies_dead.txt || echo "0")
    TOTAL=$((WORKING + DEAD))
    
    if [ $TOTAL -gt 0 ]; then
        PERCENTAGE=$((WORKING * 100 / TOTAL))
    else
        PERCENTAGE=0
    fi
    
    echo ""
    echo -e "Total Proxies:     $TOTAL"
    echo -e "Working Proxies:   ${GREEN}$WORKING${NC}"
    echo -e "Dead Proxies:      ${RED}$DEAD${NC}"
    echo -e "Success Rate:      ${YELLOW}$PERCENTAGE%${NC}"
    echo ""
    
    if [ $WORKING -eq 0 ]; then
        print_error "No working proxies found! Get new proxy list from:"
        echo "  - https://free-proxy-list.com/"
        echo "  - https://www.sslproxies.org/"
        echo "  - https://www.proxy-list.download/"
        exit 1
    else
        print_success "Found $WORKING working proxies!"
    fi
    
    echo ""
    echo -e "${YELLOW}Files generated:${NC}"
    echo "  - proxies_working.txt (ready to use)"
    echo "  - proxies_dead.txt (need to remove)"
    echo ""
}

# Cleanup function
cleanup_temp() {
    print_status "Cleaning up temporary files..."
    
    # Backup old results
    [ -f proxies_working.txt ] && mv proxies_working.txt proxies_working_backup.txt
    [ -f proxies_dead.txt ] && mv proxies_dead.txt proxies_dead_backup.txt
}

# Main execution
main() {
    print_header
    
    print_status "Starting proxy validation..."
    echo ""
    
    check_curl
    check_proxy_file
    
    echo ""
    cleanup_temp
    
    echo ""
    validate_format
    
    echo ""
    test_proxies
    
    echo ""
    generate_report
    
    # Optional: Use working proxies
    echo -e "${BLUE}[?]${NC} Do you want to replace proxies.txt with working proxies? (y/n)"
    read -r response
    
    if [ "$response" = "y" ]; then
        cp proxies.txt proxies_backup_original.txt
        cp proxies_working.txt proxies.txt
        print_success "proxies.txt updated with working proxies!"
    else
        print_status "proxies.txt remains unchanged"
    fi
    
    echo ""
    print_success "All done! Ready to run InstaReporter"
    echo ""
}

# Run main
main "$@"
