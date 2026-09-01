#!/bin/bash

###############################################
# Interactive Setup Wizard
# Easy step-by-step installation
###############################################

set -e

# Colors & Styling
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

# Configuration
STEP=0
TOTAL_STEPS=8

# Functions
clear_screen() {
    clear
}

show_header() {
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║        InstaReporter - Interactive Setup Wizard        ║"
    echo "║                   for Termux                           ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

show_progress() {
    STEP=$((STEP + 1))
    echo ""
    echo -e "${BLUE}┌─ Step $STEP/$TOTAL_STEPS: $1${NC}"
    echo -e "${BLUE}└─────────────────────────────────────────${NC}"
    echo ""
}

show_option() {
    local num=$1
    local desc=$2
    echo -e "${YELLOW}  $num) $desc${NC}"
}

get_user_input() {
    local prompt=$1
    read -p "$(echo -e ${YELLOW}${prompt}${NC})" response
    echo "$response"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}! $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

pause_continue() {
    read -p "$(echo -e ${CYAN}Press ENTER to continue...${NC})"
}

# Step 1: Welcome
step_welcome() {
    clear_screen
    show_header
    show_progress "Welcome"
    
    echo -e "${BOLD}Welcome to InstaReporter Setup Wizard!${NC}"
    echo ""
    echo "This wizard will guide you through the installation process."
    echo "It will:"
    echo "  • Update system packages"
    echo "  • Install dependencies"
    echo "  • Clone & setup InstaReporter"
    echo "  • Configure proxy settings"
    echo ""
    echo -e "${YELLOW}Estimated time: 5-10 minutes${NC}"
    echo ""
    
    pause_continue
}

# Step 2: System Check
step_system_check() {
    clear_screen
    show_header
    show_progress "System Check"
    
    echo -e "${BOLD}Checking your system...${NC}"
    echo ""
    
    # Check OS
    if grep -q "Android" /system/build.prop 2>/dev/null; then
        print_success "Running on Android (Termux)"
    else
        print_warning "Not detected as Android/Termux"
    fi
    
    # Check storage
    STORAGE=$(df /data | awk 'NR==2 {print $4}' | awk '{print int($1/1024)}')
    echo -e "${BLUE}Free storage: ${STORAGE}MB${NC}"
    
    if [ "$STORAGE" -lt 500 ]; then
        print_error "Not enough storage! Need at least 500MB"
        exit 1
    else
        print_success "Sufficient storage available"
    fi
    
    # Check Python
    if command -v python3 &> /dev/null; then
        PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
        print_success "Python 3 found: $PYTHON_VERSION"
    else
        print_warning "Python 3 not found"
    fi
    
    echo ""
    pause_continue
}

# Step 3: Installation Type
step_install_type() {
    clear_screen
    show_header
    show_progress "Installation Type"
    
    echo -e "${BOLD}Choose installation method:${NC}"
    echo ""
    
    show_option "1" "Automatic (Recommended) - Fast & easy"
    show_option "2" "Manual - Step by step control"
    show_option "3" "Custom - Selective components"
    echo ""
    
    INSTALL_TYPE=$(get_user_input "Enter choice (1-3): ")
    
    case $INSTALL_TYPE in
        1)
            print_success "Automatic installation selected"
            INSTALL_MODE="automatic"
            ;;
        2)
            print_success "Manual installation selected"
            INSTALL_MODE="manual"
            ;;
        3)
            print_success "Custom installation selected"
            INSTALL_MODE="custom"
            ;;
        *)
            print_error "Invalid choice"
            step_install_type
            return
            ;;
    esac
    
    echo ""
    pause_continue
}

# Step 4: System Updates
step_updates() {
    clear_screen
    show_header
    show_progress "System Update"
    
    echo -e "${BOLD}Updating system packages...${NC}"
    echo ""
    
    print_info "This may take a few minutes..."
    
    if apt update && apt upgrade -y; then
        print_success "System updated successfully"
    else
        print_error "System update failed"
        exit 1
    fi
    
    echo ""
    pause_continue
}

# Step 5: Dependencies
step_dependencies() {
    clear_screen
    show_header
    show_progress "Install Dependencies"
    
    echo -e "${BOLD}Installing required packages...${NC}"
    echo ""
    
    print_info "Installing: Python3, pip, git, development tools..."
    
    if apt install python3 python3-pip git libffi-dev libssl-dev -y; then
        print_success "Dependencies installed"
    else
        print_error "Dependency installation failed"
        exit 1
    fi
    
    # Upgrade pip
    print_info "Upgrading pip..."
    pip3 install --upgrade pip setuptools wheel
    
    echo ""
    pause_continue
}

# Step 6: Clone Repository
step_clone() {
    clear_screen
    show_header
    show_progress "Clone Repository"
    
    echo -e "${BOLD}Downloading InstaReporter...${NC}"
    echo ""
    
    # Ask for location
    print_info "Default location: ~/storage/downloads/InstaReporter"
    CUSTOM=$(get_user_input "Use default location? (y/n): ")
    
    if [ "$CUSTOM" = "n" ]; then
        LOCATION=$(get_user_input "Enter custom path: ")
    else
        LOCATION="~/storage/downloads"
    fi
    
    # Create directory
    mkdir -p "$LOCATION"
    cd "$LOCATION"
    
    # Clone
    if git clone https://github.com/muneebwanee/InstaReporter.git; then
        print_success "Repository cloned successfully"
        REPO_PATH="$LOCATION/InstaReporter"
        cd "$REPO_PATH"
    else
        print_error "Failed to clone repository"
        exit 1
    fi
    
    echo ""
    pause_continue
}

# Step 7: Python Packages
step_python_packages() {
    clear_screen
    show_header
    show_progress "Install Python Packages"
    
    echo -e "${BOLD}Installing Python dependencies...${NC}"
    echo ""
    
    print_info "This may take a few minutes..."
    
    if pip3 install requests[socks] aiohttp[speedups] colorama beautifulsoup4; then
        print_success "Python packages installed"
    else
        print_error "Package installation failed"
        exit 1
    fi
    
    # Remove proxybroker
    print_warning "Removing incompatible proxybroker package..."
    pip3 uninstall proxybroker -y 2>/dev/null || true
    
    echo ""
    pause_continue
}

# Step 8: Configuration
step_configuration() {
    clear_screen
    show_header
    show_progress "Configuration"
    
    echo -e "${BOLD}Configuring InstaReporter...${NC}"
    echo ""
    
    # Create proxies.txt template
    if [ ! -f "proxies.txt" ]; then
        print_info "Creating proxies.txt template..."
        cat > proxies.txt << 'EOF'
# Add your proxy list here (format: IP:PORT)
# Get proxies from:
# - https://free-proxy-list.com/
# - https://www.sslproxies.org/
# - https://www.proxy-list.download/

# Example:
# 192.168.1.1:8080
# 10.0.0.1:3128
EOF
        print_success "proxies.txt created"
    else
        print_warning "proxies.txt already exists"
    fi
    
    # Ask to add proxies now
    EDIT_NOW=$(get_user_input "Add proxies now? (y/n): ")
    if [ "$EDIT_NOW" = "y" ]; then
        nano proxies.txt
        print_success "Proxies configured"
    else
        print_warning "You can edit proxies.txt later: nano proxies.txt"
    fi
    
    echo ""
    pause_continue
}

# Step 9: Completion
step_completion() {
    clear_screen
    show_header
    
    echo -e "${GREEN}"
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║           Installation Complete! ✓                    ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo ""
    echo -e "${BOLD}Next steps:${NC}"
    echo ""
    echo "1. Add proxies to proxies.txt:"
    echo "   $(pwd)/proxies.txt"
    echo ""
    echo "2. Run InstaReporter:"
    echo "   cd $(pwd)"
    echo "   python3 InstaReporter.py"
    echo ""
    
    echo -e "${CYAN}Quick commands:${NC}"
    echo "  • Check proxies: bash check_proxies.sh"
    echo "  • View guide: cat TERMUX_INSTALLATION_GUIDE.md"
    echo "  • Help: cat FAQ.md"
    echo ""
    
    echo -e "${YELLOW}⚠️  Disclaimer:${NC}"
    echo "Use responsibly and legally. Read README.md for full disclaimer."
    echo ""
}

# Main execution
main() {
    TOTAL_STEPS=8
    
    step_welcome
    step_system_check
    step_install_type
    step_updates
    step_dependencies
    step_clone
    step_python_packages
    step_configuration
    step_completion
    
    print_success "Setup wizard completed!"
}

# Run
main "$@"
