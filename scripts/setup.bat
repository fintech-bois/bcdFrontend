@echo off
REM Blockchain RMT Project - Quick Start Setup Script (Windows)
REM This script helps you set up the development environment quickly

echo ==========================================
echo Blockchain RMT Project - Quick Setup
echo ==========================================
echo.

REM Check if Node.js is installed
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Node.js is not installed
    echo Please install Node.js from https://nodejs.org/
    pause
    exit /b 1
)

echo [OK] Node.js found
node --version

REM Check if npm is installed
where npm >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] npm is not installed
    pause
    exit /b 1
)

echo [OK] npm found
npm --version
echo.

REM Check if .env.local exists
if not exist ".env.local" (
    echo [WARNING] .env.local not found
    
    if exist ".env.example" (
        echo Creating .env.local from .env.example...
        copy .env.example .env.local
        echo [OK] Created .env.local
        echo [WARNING] Please edit .env.local with your actual values before continuing
        echo.
    ) else (
        echo [ERROR] .env.example not found
        pause
        exit /b 1
    )
) else (
    echo [OK] .env.local found
)

REM Install dependencies
echo.
echo Installing dependencies...
call npm install

if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to install dependencies
    pause
    exit /b 1
)

echo [OK] Dependencies installed

echo.
echo ==========================================
echo Setup Complete!
echo ==========================================
echo.
echo Next steps:
echo.
echo 1. Set up bcdContract (Smart Contracts):
echo    - Clone the repository: git clone https://github.com/fintech-bois/bcdContract.git
echo    - Install dependencies: cd bcdContract ^&^& npm install
echo    - Start Hardhat node: npx hardhat node
echo    - Deploy contracts: npm run deploy
echo    - Copy contract address to .env.local
echo.
echo 2. Set up MySQL Database:
echo    - Install and start WAMP server
echo    - Import bcd.sql into the database
echo.
echo 3. Set up Stripe CLI:
echo    - Download from: https://stripe.com/docs/stripe-cli
echo    - Login: stripe login
echo    - Start webhook: stripe listen --forward-to localhost:3000/api/webhook
echo    - Copy webhook secret to .env.local
echo.
echo 4. Configure all environment variables in .env.local
echo.
echo 5. Create admin user:
echo    npm run create-admin
echo.
echo 6. Start the development server:
echo    npm run dev
echo.
echo For detailed instructions, see DEPLOYMENT.md
echo.
pause
