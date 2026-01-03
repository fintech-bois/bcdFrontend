# Deployment Checklist

Use this checklist to track your deployment progress. Check off items as you complete them.

---

## Pre-Deployment Setup

### Accounts & API Keys

- [ ] Create Stripe account and obtain API keys
  - [ ] Publishable key (pk_test_...)
  - [ ] Secret key (sk_test_...)
  - [ ] Download and install Stripe CLI

- [ ] Create PayPal Business account
  - [ ] Client ID
  - [ ] Client Secret
  - [ ] Verify Payouts are enabled

- [ ] Create Resend account
  - [ ] API key (re_...)

- [ ] Create Reown/WalletConnect project
  - [ ] Project ID from cloud.reown.com

### Software Installation

- [ ] Install Node.js (v18 or higher)
- [ ] Install npm (comes with Node.js)
- [ ] Install Git
- [ ] Install MySQL/WAMP Server
  - [ ] Windows: Install VC++ Redistributables
- [ ] Install Stripe CLI

### Repository Setup

- [ ] Clone bcdFrontend repository
  ```bash
  git clone https://github.com/fintech-bois/bcdFrontend.git
  ```

- [ ] Clone bcdContract repository
  ```bash
  git clone https://github.com/fintech-bois/bcdContract.git
  ```

---

## Local Development Setup

### Smart Contracts (bcdContract)

- [ ] Navigate to bcdContract directory
- [ ] Install dependencies
  ```bash
  npm install
  ```

- [ ] Start Hardhat node (Terminal 1 - keep running)
  ```bash
  npx hardhat node
  ```

- [ ] Copy Account #0 address: `_________________`
- [ ] Copy Account #0 private key: `_________________`

- [ ] Deploy smart contract (Terminal 2)
  ```bash
  npm run deploy
  ```

- [ ] Copy deployed contract address: `_________________`

### Database Setup

- [ ] Start WAMP/MySQL server
- [ ] Access phpMyAdmin or MySQL CLI
- [ ] Create database 'bcd'
- [ ] Import bcd.sql file
- [ ] Verify tables were created

### Stripe Webhook Setup

- [ ] Open Stripe CLI
- [ ] Login to Stripe
  ```bash
  stripe login
  ```

- [ ] Start webhook forwarding (Terminal 3 - keep running)
  ```bash
  stripe listen --forward-to localhost:3000/api/webhook
  ```

- [ ] Copy webhook secret (whsec_...): `_________________`

### Frontend Configuration (bcdFrontend)

- [ ] Navigate to bcdFrontend directory
- [ ] Install dependencies
  ```bash
  npm install
  ```

- [ ] Create .env.local file
  ```bash
  cp .env.example .env.local
  ```

- [ ] Configure environment variables in .env.local:
  - [ ] NEXT_PUBLIC_STRIPE_PUBLIC_KEY
  - [ ] STRIPE_SECRET_KEY
  - [ ] STRIPE_WEBHOOK_SECRET
  - [ ] NEXT_PUBLIC_TOKEN_CONTRACT_ADDRESS
  - [ ] OWNER_PRIVATE_KEY
  - [ ] CONTRACT_OWNER_ADDRESS
  - [ ] RPC_URL (http://127.0.0.1:8545)
  - [ ] PAYPAL_CLIENT_ID
  - [ ] PAYPAL_CLIENT_SECRET
  - [ ] DATABASE_HOST (localhost)
  - [ ] DATABASE_USER (root)
  - [ ] DATABASE_PASSWORD
  - [ ] DATABASE_NAME (bcd)
  - [ ] NODE_ENV (development)
  - [ ] JWT_SECRET (generate random string)
  - [ ] RESEND_API_KEY
  - [ ] NEXT_PUBLIC_PROJECT_ID

- [ ] Create admin user
  ```bash
  npm run create-admin
  ```

- [ ] Admin credentials:
  - Username: `_________________`
  - Password: `_________________` (remember this!)

### Start Development Server

- [ ] Start frontend (Terminal 4 - keep running)
  ```bash
  npm run dev
  ```

- [ ] Access application at http://localhost:3000

### Verify Everything Works

- [ ] Can access homepage
- [ ] Can register new user
- [ ] Can login
- [ ] Can connect wallet (MetaMask)
- [ ] Can deposit funds (test Stripe)
- [ ] Can convert USD to RMT
- [ ] Can send tokens
- [ ] Can convert RMT to USD
- [ ] Can withdraw to PayPal
- [ ] Admin can login
- [ ] Admin can see dashboard
- [ ] Admin can approve/reject transactions
- [ ] Email notifications working

---

## Production Deployment

### Infrastructure Setup

- [ ] Choose hosting platform:
  - [ ] Vercel (recommended for Next.js)
  - [ ] Netlify
  - [ ] AWS/GCP/Azure
  - [ ] Self-hosted VPS

- [ ] Set up production database:
  - [ ] Create managed MySQL instance
  - [ ] Import bcd.sql schema
  - [ ] Configure firewall/security
  - [ ] Note connection details

- [ ] Choose blockchain network:
  - [ ] Ethereum Mainnet
  - [ ] Sepolia Testnet (for testing)
  - [ ] Other network: `_________________`

### Smart Contract Deployment (Production)

- [ ] Obtain cryptocurrency for gas fees
- [ ] Configure network in hardhat.config.js
- [ ] Deploy contracts to production network
  ```bash
  npx hardhat run scripts/deploy.js --network <network-name>
  ```

- [ ] Save deployed contract addresses
- [ ] Verify contracts on block explorer (optional)

### Frontend Deployment

- [ ] Build project locally to test
  ```bash
  npm run build
  ```

- [ ] Deploy to hosting platform
- [ ] Configure production environment variables
  - [ ] Use production Stripe keys (pk_live_..., sk_live_...)
  - [ ] Use production contract addresses
  - [ ] Use production database credentials
  - [ ] Use production RPC URL (Infura/Alchemy/QuickNode)
  - [ ] Update all other production values

- [ ] Configure custom domain
- [ ] Set up SSL certificate
- [ ] Configure Stripe production webhook
  - [ ] Add endpoint in Stripe Dashboard
  - [ ] Update STRIPE_WEBHOOK_SECRET

### Testing in Production

- [ ] Test user registration
- [ ] Test login
- [ ] Test deposit (with real Stripe)
- [ ] Test token minting
- [ ] Test token transfers
- [ ] Test token burning
- [ ] Test withdrawals
- [ ] Test admin functions
- [ ] Test email notifications
- [ ] Check all transaction records
- [ ] Verify blockchain transactions

### Monitoring & Maintenance

- [ ] Set up error logging
- [ ] Set up uptime monitoring
- [ ] Set up database backups
- [ ] Document admin procedures
- [ ] Create incident response plan
- [ ] Set up alerts for critical issues

---

## Running Services Checklist

For local development, you need these processes running:

- [ ] **Terminal 1**: Hardhat blockchain node
  ```bash
  cd bcdContract && npx hardhat node
  ```

- [ ] **Terminal 2**: Stripe CLI webhook
  ```bash
  stripe listen --forward-to localhost:3000/api/webhook
  ```

- [ ] **Terminal 3**: WAMP/MySQL server
  - Running in system tray (Windows)
  - Or MySQL service running

- [ ] **Terminal 4**: Next.js development server
  ```bash
  cd bcdFrontend && npm run dev
  ```

---

## Troubleshooting Quick Reference

### Issue: Cannot connect to database
- [ ] Check MySQL/WAMP is running
- [ ] Verify DATABASE_* variables in .env.local
- [ ] Test connection manually

### Issue: Smart contract errors
- [ ] Check Hardhat node is running
- [ ] Verify contract address in .env.local
- [ ] Check RPC_URL is correct

### Issue: Stripe webhook not working
- [ ] Verify Stripe CLI is running
- [ ] Check STRIPE_WEBHOOK_SECRET in .env.local
- [ ] Review Stripe CLI terminal for errors

### Issue: Wallet connection fails
- [ ] Install MetaMask or compatible wallet
- [ ] Check NEXT_PUBLIC_PROJECT_ID is set
- [ ] Verify network configuration

### Issue: Build fails
- [ ] Delete node_modules and reinstall
  ```bash
  rm -rf node_modules package-lock.json
  npm install
  ```
- [ ] Check all environment variables are set
- [ ] Review error messages in terminal

---

## Completion

### Local Development

- [ ] All services running smoothly
- [ ] All features tested and working
- [ ] Development environment documented
- [ ] Team members can replicate setup

### Production Deployment

- [ ] Application deployed and accessible
- [ ] All features tested in production
- [ ] Monitoring and alerts configured
- [ ] Documentation updated with production details
- [ ] Backup and recovery procedures in place
- [ ] Security review completed
- [ ] Performance optimization done
- [ ] Ready for users! 🚀

---

**Need Help?**
- Review [DEPLOYMENT.md](./DEPLOYMENT.md) for detailed instructions
- Check [README.md](./README.md) for development setup
- Open a GitHub issue for support

Good luck with your deployment!
