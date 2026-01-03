# Deployment Guide for Blockchain RMT Project

This guide explains how to deploy the Blockchain RMT (Remittance Token) project, which consists of a Next.js frontend and requires integration with a Hardhat blockchain contract repository.

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Prerequisites](#prerequisites)
4. [Deployment Complexity Assessment](#deployment-complexity-assessment)
5. [Local Development Deployment](#local-development-deployment)
6. [Production Deployment](#production-deployment)
7. [Troubleshooting](#troubleshooting)
8. [Deployment Checklist](#deployment-checklist)

---

## Overview

The Blockchain RMT platform is a cross-border remittance system that uses blockchain technology to enable fast, low-cost international money transfers. The platform consists of:

- **Frontend**: Next.js application (this repository)
- **Smart Contracts**: Hardhat-based blockchain contracts (bcdContract repository)
- **Database**: MySQL database for user data and transaction records
- **External Services**: Stripe, PayPal, and Resend email service
- **Blockchain Network**: Local Hardhat node or public blockchain network

---

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    User Interface                        │
│               (Next.js Frontend - bcdFrontend)          │
└─────────────────┬───────────────────────────────────────┘
                  │
         ┌────────┴────────┐
         │                 │
    ┌────▼─────┐     ┌─────▼──────┐
    │  MySQL   │     │  Hardhat   │
    │ Database │     │ Blockchain │
    │          │     │ (bcdContract)│
    └──────────┘     └────────────┘
         │                 │
         │                 │
    ┌────▼─────────────────▼──────┐
    │   External Services:        │
    │   - Stripe (Payments)       │
    │   - Stripe CLI (Webhooks)   │
    │   - PayPal (Payouts)        │
    │   - Resend (Email)          │
    └─────────────────────────────┘
```

---

## Prerequisites

### Required Software

1. **Node.js** (v18 or higher) - [Download](https://nodejs.org/)
2. **npm** or **yarn** - Comes with Node.js
3. **Git** - For cloning repositories
4. **MySQL Database Server**
   - **For Local Development**: [WAMP](https://sourceforge.net/projects/wampserver/) (Windows) or MySQL server
   - **For Production**: Managed MySQL service (AWS RDS, Google Cloud SQL, etc.)
5. **Hardhat** - Will be installed as part of bcdContract setup

### Required Accounts & API Keys

1. **Stripe Account** - [Sign up](https://dashboard.stripe.com/register)
   - Publishable Key
   - Secret Key
   - Stripe CLI for webhooks
2. **PayPal Business Account** - [Apply](https://www.paypal.com/my/webapps/mpp/account-selection)
   - Client ID
   - Client Secret
3. **Resend Account** - [Sign up](https://resend.com/)
   - API Key
4. **Reown Project** - For Web3 wallet connection
   - Project ID from [cloud.reown.com](https://cloud.reown.com)

### Repository Access

You need access to both repositories:
- **Frontend**: `fintech-bois/bcdFrontend` (this repository)
- **Smart Contracts**: `fintech-bois/bcdContract` (blockchain contracts)

---

## Deployment Complexity Assessment

### Is It Hard to Deploy?

**Answer: Moderately Complex** (6/10 difficulty)

#### Complexity Factors:

✅ **Easy/Standard Components:**
- Next.js deployment is straightforward (supports Vercel, Netlify, etc.)
- Database setup is standard MySQL
- Node.js ecosystem is well-documented

⚠️ **Moderate Complexity:**
- Multiple external service integrations (Stripe, PayPal, Resend)
- Stripe CLI must run continuously for webhooks
- Environment variables management across services
- Database initialization and admin setup

❌ **Challenging Components:**
- **Blockchain Integration**: Requires running a Hardhat node or connecting to a blockchain network
- **Two Separate Repositories**: Frontend (bcdFrontend) and contracts (bcdContract) must be coordinated
- **Smart Contract Deployment**: Contracts must be deployed before frontend can function
- **Contract Address Management**: Frontend needs deployed contract addresses
- **Stripe CLI Webhook**: Requires a persistent process for payment updates

#### Time Estimate:
- **First-time Local Setup**: 2-4 hours
- **Production Deployment**: 4-8 hours (including testing)
- **With Experience**: 1-2 hours

---

## Local Development Deployment

### Step 1: Clone Both Repositories

```bash
# Clone the frontend repository
git clone https://github.com/fintech-bois/bcdFrontend.git
cd bcdFrontend

# Install frontend dependencies
npm install

# Clone the contract repository in a separate directory
cd ..
git clone https://github.com/fintech-bois/bcdContract.git
cd bcdContract

# Install contract dependencies
npm install
```

### Step 2: Set Up MySQL Database

#### Using WAMP (Windows):
1. Download and install [WAMP Server](https://sourceforge.net/projects/wampserver/)
2. Install [VC++ Redistributables](https://github.com/abbodi1406/vcredist/releases)
3. Start WAMP server
4. Access phpMyAdmin at `http://localhost/phpmyadmin`
5. Import the `bcd.sql` file (located in bcdFrontend root)

#### Using MySQL Command Line:
```bash
# Create database
mysql -u root -p -e "CREATE DATABASE bcd;"

# Import schema
mysql -u root -p bcd < path/to/bcd.sql
```

### Step 3: Deploy Smart Contracts (bcdContract)

```bash
cd bcdContract

# Start local Hardhat blockchain node (keep this running in a separate terminal)
npx hardhat node

# In the output, copy:
# - The first account address (Account #0)
# - Its private key
```

**Important**: Keep the `npx hardhat node` terminal running throughout development.

In a **new terminal**, deploy the contracts:

```bash
cd bcdContract

# Deploy the smart contract
npm run deploy
# or
npx hardhat run scripts/deploy.js --network localhost

# Copy the deployed contract address from the output
```

### Step 4: Set Up Stripe CLI

1. Download [Stripe CLI](https://stripe.com/docs/stripe-cli)
2. Extract and navigate to the folder
3. Login to Stripe:
   ```bash
   stripe login
   ```
4. Start webhook forwarding (keep this running in a separate terminal):
   ```bash
   stripe listen --forward-to localhost:3000/api/webhook
   ```
5. Copy the webhook signing secret from the output (starts with `whsec_`)

### Step 5: Configure Environment Variables (bcdFrontend)

```bash
cd bcdFrontend

# Create .env.local file
cp .env.example .env.local  # If example exists
# Or create manually
```

Edit `.env.local` with your configuration:

```env
# Stripe Configuration
NEXT_PUBLIC_STRIPE_PUBLIC_KEY=pk_test_your_publishable_key
STRIPE_SECRET_KEY=sk_test_your_secret_key
STRIPE_WEBHOOK_SECRET=whsec_your_webhook_secret

# Smart Contract Configuration
NEXT_PUBLIC_TOKEN_CONTRACT_ADDRESS=0x... # From step 3
OWNER_PRIVATE_KEY=0x... # From step 3 (Account #0 private key)
RPC_URL=http://127.0.0.1:8545
CONTRACT_OWNER_ADDRESS=0x... # From step 3 (Account #0 address)

# PayPal Configuration
PAYPAL_CLIENT_ID=your_paypal_client_id
PAYPAL_CLIENT_SECRET=your_paypal_client_secret

# Database Configuration
DATABASE_HOST=localhost
DATABASE_USER=root
DATABASE_PASSWORD=
DATABASE_NAME=bcd

# Application Configuration
NODE_ENV=development
JWT_SECRET=your_random_jwt_secret_key_here

# Email Service
RESEND_API_KEY=re_your_resend_api_key

# Web3 Wallet Configuration
NEXT_PUBLIC_PROJECT_ID=your_reown_project_id
```

### Step 6: Create Admin User

```bash
cd bcdFrontend
npm run create-admin
```

Follow the prompts to create an admin account.

### Step 7: Start the Frontend

```bash
cd bcdFrontend
npm run dev
```

Access the application at `http://localhost:3000`

### Running Services Summary (Local Development)

You need **4 terminal windows/processes** running simultaneously:

1. **Terminal 1**: Hardhat blockchain node
   ```bash
   cd bcdContract && npx hardhat node
   ```

2. **Terminal 2**: Stripe CLI webhook forwarding
   ```bash
   stripe listen --forward-to localhost:3000/api/webhook
   ```

3. **Terminal 3**: WAMP server (or MySQL service)

4. **Terminal 4**: Next.js development server
   ```bash
   cd bcdFrontend && npm run dev
   ```

---

## Production Deployment

Production deployment is more complex and requires careful planning. Here's a comprehensive approach:

### Option 1: Deploy to a Cloud Platform (Recommended)

#### Frontend Deployment (Vercel/Netlify)

**Using Vercel** (Easiest for Next.js):

1. **Prepare the repository**:
   ```bash
   cd bcdFrontend
   npm run build  # Test production build locally
   ```

2. **Deploy to Vercel**:
   - Sign up at [vercel.com](https://vercel.com)
   - Connect your GitHub repository
   - Configure environment variables in Vercel dashboard
   - Deploy

3. **Configure Environment Variables** in Vercel:
   - Add all variables from `.env.local`
   - Use production values (production Stripe keys, production database, etc.)

#### Smart Contract Deployment

**For Production, you have two main options:**

##### Option A: Deploy to a Public Testnet (Recommended for Testing)

```bash
cd bcdContract

# Edit hardhat.config.js to add network configuration
# Example: Sepolia testnet

# Deploy to testnet
npx hardhat run scripts/deploy.js --network sepolia

# Save the deployed contract address
```

##### Option B: Deploy to Mainnet (For Production)

```bash
cd bcdContract

# Deploy to Ethereum mainnet or other production networks
npx hardhat run scripts/deploy.js --network mainnet

# This requires real ETH for gas fees!
```

#### Database Deployment

**Use a managed database service:**

- **AWS RDS** for MySQL
- **Google Cloud SQL**
- **Azure Database for MySQL**
- **PlanetScale** (MySQL-compatible)
- **Railway** or **Render** (Simpler options)

**Steps:**
1. Create a managed MySQL instance
2. Import `bcd.sql` schema
3. Configure firewall rules to allow your application
4. Update `DATABASE_HOST`, `DATABASE_USER`, `DATABASE_PASSWORD` in environment variables

#### Webhook Configuration for Production

For Stripe webhooks in production:

1. Go to Stripe Dashboard → Webhooks
2. Add endpoint: `https://yourdomain.com/api/webhook`
3. Select events to listen to
4. Copy the signing secret
5. Add to `STRIPE_WEBHOOK_SECRET` environment variable

**Note**: Stripe CLI is only for local development. Production uses Stripe's webhook endpoint.

### Option 2: Self-Hosted Deployment (VPS/Dedicated Server)

If deploying to your own server (DigitalOcean, AWS EC2, etc.):

#### Server Requirements

- **OS**: Ubuntu 20.04+ or similar
- **RAM**: 4GB minimum (8GB recommended)
- **Storage**: 50GB+ SSD
- **Node.js**: v18+
- **MySQL**: 8.0+
- **Process Manager**: PM2 for running Node.js apps

#### Deployment Steps

1. **Set up the server**:
   ```bash
   # SSH into your server
   ssh user@your-server-ip

   # Update system
   sudo apt update && sudo apt upgrade -y

   # Install Node.js
   curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
   sudo apt install -y nodejs

   # Install MySQL
   sudo apt install mysql-server

   # Install PM2
   sudo npm install -g pm2

   # Install Nginx (reverse proxy)
   sudo apt install nginx
   ```

2. **Clone and set up repositories**:
   ```bash
   cd /var/www
   sudo git clone https://github.com/fintech-bois/bcdFrontend.git
   sudo git clone https://github.com/fintech-bois/bcdContract.git

   cd bcdFrontend
   sudo npm install
   sudo npm run build

   cd ../bcdContract
   sudo npm install
   ```

3. **Configure MySQL**:
   ```bash
   sudo mysql
   CREATE DATABASE bcd;
   CREATE USER 'bcduser'@'localhost' IDENTIFIED BY 'secure_password';
   GRANT ALL PRIVILEGES ON bcd.* TO 'bcduser'@'localhost';
   FLUSH PRIVILEGES;
   EXIT;

   mysql -u bcduser -p bcd < /var/www/bcdFrontend/bcd.sql
   ```

4. **Deploy smart contracts**:
   ```bash
   cd /var/www/bcdContract
   # Deploy to your chosen network (testnet or mainnet)
   npx hardhat run scripts/deploy.js --network <network-name>
   ```

5. **Configure environment variables**:
   ```bash
   cd /var/www/bcdFrontend
   sudo nano .env.local
   # Add production environment variables
   ```

6. **Start the application with PM2**:
   ```bash
   cd /var/www/bcdFrontend
   pm2 start npm --name "bcdFrontend" -- start
   pm2 save
   pm2 startup
   ```

7. **Configure Nginx**:
   ```bash
   sudo nano /etc/nginx/sites-available/bcdFrontend
   ```

   Add configuration:
   ```nginx
   server {
       listen 80;
       server_name yourdomain.com;

       location / {
           proxy_pass http://localhost:3000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```

   Enable site:
   ```bash
   sudo ln -s /etc/nginx/sites-available/bcdFrontend /etc/nginx/sites-enabled/
   sudo nginx -t
   sudo systemctl restart nginx
   ```

8. **Set up SSL with Let's Encrypt**:
   ```bash
   sudo apt install certbot python3-certbot-nginx
   sudo certbot --nginx -d yourdomain.com
   ```

### Blockchain Node Considerations for Production

**Option A**: Use a managed blockchain node service:
- **Infura** (Ethereum)
- **Alchemy** (Multiple chains)
- **QuickNode**

Update `RPC_URL` to use the provider's endpoint instead of `http://127.0.0.1:8545`

**Option B**: Run your own node (advanced):
- Requires significant resources
- Needs to stay synced
- More control but more maintenance

---

## Troubleshooting

### Common Issues

#### 1. "Cannot connect to MySQL"
- **Check**: Is MySQL/WAMP running?
- **Check**: Are database credentials correct in `.env.local`?
- **Fix**: Restart MySQL service

#### 2. "Smart contract address not defined"
- **Check**: Did you deploy the contract from bcdContract?
- **Check**: Is `NEXT_PUBLIC_TOKEN_CONTRACT_ADDRESS` set in `.env.local`?
- **Fix**: Deploy contract and update environment variable

#### 3. "Stripe webhook not receiving events"
- **Check**: Is Stripe CLI running?
- **Check**: Is it forwarding to the correct URL?
- **Fix**: Restart Stripe CLI: `stripe listen --forward-to localhost:3000/api/webhook`

#### 4. "Network connection issues with blockchain"
- **Check**: Is Hardhat node running? (`npx hardhat node`)
- **Check**: Is `RPC_URL` correct?
- **Fix**: Restart Hardhat node

#### 5. "Build fails in production"
- **Check**: Are all dependencies installed?
- **Check**: Are environment variables set correctly?
- **Fix**: Run `npm install` and verify `.env.local` or production environment variables

#### 6. "Wallet connection fails"
- **Check**: Is `NEXT_PUBLIC_PROJECT_ID` (Reown) set?
- **Check**: Is MetaMask or another wallet installed?
- **Fix**: Get project ID from [cloud.reown.com](https://cloud.reown.com)

### Logs and Debugging

```bash
# View Next.js logs (development)
# Logs appear in the terminal where you ran `npm run dev`

# View PM2 logs (production)
pm2 logs bcdFrontend

# View Stripe CLI logs
# Logs appear in the Stripe CLI terminal

# View Hardhat node logs
# Logs appear in the Hardhat node terminal

# View MySQL logs
tail -f /var/log/mysql/error.log  # Linux
# Or check WAMP logs directory on Windows
```

---

## Deployment Checklist

### Pre-Deployment

- [ ] Both repositories cloned (bcdFrontend and bcdContract)
- [ ] All accounts created (Stripe, PayPal, Resend, Reown)
- [ ] MySQL database installed and running
- [ ] Node.js and npm installed
- [ ] All API keys obtained

### Local Development Setup

- [ ] bcdContract dependencies installed (`npm install`)
- [ ] Hardhat node running (`npx hardhat node`)
- [ ] Smart contracts deployed (`npm run deploy`)
- [ ] Contract address copied
- [ ] Stripe CLI installed and logged in
- [ ] Stripe webhook forwarding active
- [ ] bcdFrontend dependencies installed (`npm install`)
- [ ] `.env.local` file created with all variables
- [ ] Database imported (`bcd.sql`)
- [ ] Admin user created (`npm run create-admin`)
- [ ] Frontend running (`npm run dev`)
- [ ] Application accessible at `http://localhost:3000`

### Production Deployment

- [ ] Production database provisioned
- [ ] Database schema imported
- [ ] Smart contracts deployed to production network (testnet/mainnet)
- [ ] Contract addresses documented
- [ ] Frontend deployed to hosting platform
- [ ] All production environment variables configured
- [ ] Domain configured and SSL certificate installed
- [ ] Stripe production webhook endpoint configured
- [ ] PayPal production credentials configured
- [ ] Email service (Resend) configured
- [ ] Admin user created in production database
- [ ] All services tested end-to-end
- [ ] Monitoring and logging set up

### Testing Checklist

- [ ] User registration works
- [ ] User login works
- [ ] Deposit funds with Stripe (test mode)
- [ ] Convert USD to RMT (mint tokens)
- [ ] Send tokens to another wallet
- [ ] Convert RMT to USD (burn tokens)
- [ ] Withdraw to PayPal
- [ ] Admin can approve/reject withdrawals
- [ ] Email notifications working
- [ ] All transaction types logged correctly

---

## Additional Resources

### Documentation
- [Next.js Deployment](https://nextjs.org/docs/deployment)
- [Hardhat Deployment](https://hardhat.org/hardhat-runner/docs/guides/deploying)
- [Stripe Webhooks](https://stripe.com/docs/webhooks)
- [Vercel Deployment Guide](https://vercel.com/docs)

### Support
- Review the main [README.md](./README.md) for development setup
- Check [SYSTEMFEATURES.md](./SYSTEMFEATURES.md) for feature details
- Open an issue on GitHub for bugs or questions

---

## Summary

**Is deployment hard?** 

It's **moderately complex** due to the multi-component architecture:
- ✅ Manageable with proper planning and this guide
- ⚠️ Requires understanding of blockchain, webhooks, and multiple services
- 🎯 Follow this guide step-by-step for success

**Key Success Factors:**
1. Deploy contracts first (bcdContract)
2. Set up database before frontend
3. Configure all environment variables correctly
4. Keep required services running (Hardhat, Stripe CLI for development)
5. Test thoroughly before production deployment

**Recommended Deployment Path:**
1. Start with local development (follow Local Development Deployment)
2. Test all features thoroughly
3. Deploy to staging/testnet first
4. Finally deploy to production

Good luck with your deployment! 🚀
