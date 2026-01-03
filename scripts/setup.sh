#!/bin/bash

# Blockchain RMT Project - Quick Start Setup Script
# This script helps you set up the development environment quickly

set -e  # Exit on error

echo "=========================================="
echo "Blockchain RMT Project - Quick Setup"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo -e "${RED}Error: Node.js is not installed${NC}"
    echo "Please install Node.js from https://nodejs.org/"
    exit 1
fi

echo -e "${GREEN}✓ Node.js found: $(node --version)${NC}"

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo -e "${RED}Error: npm is not installed${NC}"
    exit 1
fi

echo -e "${GREEN}✓ npm found: $(npm --version)${NC}"
echo ""

# Check if .env.local exists
if [ ! -f ".env.local" ]; then
    echo -e "${YELLOW}⚠ .env.local not found${NC}"
    
    if [ -f ".env.example" ]; then
        echo "Creating .env.local from .env.example..."
        cp .env.example .env.local
        echo -e "${GREEN}✓ Created .env.local${NC}"
        echo -e "${YELLOW}⚠ Please edit .env.local with your actual values before continuing${NC}"
        echo ""
    else
        echo -e "${RED}Error: .env.example not found${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✓ .env.local found${NC}"
fi

# Install dependencies
echo ""
echo "Installing dependencies..."
npm install

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Dependencies installed${NC}"
else
    echo -e "${RED}Error: Failed to install dependencies${NC}"
    exit 1
fi

echo ""
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo ""
echo "1. Set up bcdContract (Smart Contracts):"
echo "   - Clone the repository: git clone https://github.com/fintech-bois/bcdContract.git"
echo "   - Install dependencies: cd bcdContract && npm install"
echo "   - Start Hardhat node: npx hardhat node"
echo "   - Deploy contracts: npm run deploy"
echo "   - Copy contract address to .env.local"
echo ""
echo "2. Set up MySQL Database:"
echo "   - Install and start WAMP server (Windows) or MySQL"
echo "   - Import bcd.sql into the database"
echo ""
echo "3. Set up Stripe CLI:"
echo "   - Download from: https://stripe.com/docs/stripe-cli"
echo "   - Login: stripe login"
echo "   - Start webhook: stripe listen --forward-to localhost:3000/api/webhook"
echo "   - Copy webhook secret to .env.local"
echo ""
echo "4. Configure all environment variables in .env.local"
echo ""
echo "5. Create admin user:"
echo "   npm run create-admin"
echo ""
echo "6. Start the development server:"
echo "   npm run dev"
echo ""
echo "For detailed instructions, see DEPLOYMENT.md"
echo ""
