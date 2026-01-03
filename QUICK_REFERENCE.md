# Quick Deployment Reference

**TL;DR**: This project requires coordination between two repositories (bcdFrontend and bcdContract) plus external services. Deployment is **moderately complex** but manageable.

---

## 🎯 Quick Answer: Is It Hard to Deploy?

**Difficulty: 6/10 (Moderately Complex)**

✅ **Can be deployed**: Yes, with proper preparation  
⏱️ **Time required**: 2-4 hours first time, 1-2 hours with experience  
📚 **Full guide**: See [DEPLOYMENT.md](./DEPLOYMENT.md)

---

## 🔧 What You Need

### Required Repositories
1. **bcdFrontend** (this repo) - Next.js frontend
2. **bcdContract** (separate repo) - Hardhat smart contracts

### External Services
- Stripe (payments + CLI for webhooks)
- PayPal Business (payouts)
- Resend (emails)
- MySQL Database
- Reown/WalletConnect (wallet connection)

---

## 🚀 Quick Start (Local Development)

### 1. Clone Both Repos
```bash
git clone https://github.com/fintech-bois/bcdFrontend.git
git clone https://github.com/fintech-bois/bcdContract.git
```

### 2. Set Up Smart Contracts First
```bash
cd bcdContract
npm install
npx hardhat node  # Keep running - Terminal 1
```

In another terminal:
```bash
cd bcdContract
npm run deploy    # Copy the contract address
```

### 3. Set Up Database
- Install WAMP/MySQL
- Import `bcd.sql`

### 4. Start Stripe Webhooks
```bash
stripe listen --forward-to localhost:3000/api/webhook  # Terminal 2
```

### 5. Configure Frontend
```bash
cd bcdFrontend
npm install
cp .env.example .env.local
# Edit .env.local with your values
npm run create-admin
npm run dev       # Terminal 3
```

### Running Services
You need **3 terminals** running simultaneously:
1. Hardhat node (`npx hardhat node`)
2. Stripe CLI (`stripe listen --forward-to localhost:3000/api/webhook`)
3. Next.js server (`npm run dev`)

Plus: MySQL/WAMP server running

---

## 📦 Production Deployment Options

### Option 1: Cloud Platform (Easiest)
- **Frontend**: Vercel/Netlify
- **Database**: AWS RDS, Google Cloud SQL
- **Blockchain**: Infura, Alchemy, or QuickNode

### Option 2: Self-Hosted
- VPS with Ubuntu
- PM2 for process management
- Nginx as reverse proxy
- Self-managed database

**Important**: 
- Deploy smart contracts to production network first
- Configure production webhook endpoints in Stripe Dashboard
- Use production API keys for all services

---

## 🎓 Key Concepts

### Why Two Repositories?
- **bcdContract**: Smart contract logic (blockchain)
- **bcdFrontend**: User interface (web app)
- Frontend needs deployed contract addresses to function

### Why Stripe CLI?
- **Development**: Stripe CLI forwards webhooks to localhost
- **Production**: Stripe sends webhooks directly to your domain
- Webhooks update user balances after payment

### Why Hardhat Node?
- **Development**: Local blockchain for testing
- **Production**: Connect to real networks (Sepolia, Ethereum mainnet)

---

## ⚠️ Common Pitfalls

1. **Forgetting to deploy contracts first**
   - Frontend needs contract addresses to work

2. **Not keeping services running**
   - Hardhat node, Stripe CLI must run continuously in development

3. **Environment variable mistakes**
   - Double-check all values in `.env.local`
   - Use correct network values (local vs production)

4. **Database not imported**
   - Import `bcd.sql` before starting frontend

5. **Not creating admin user**
   - Run `npm run create-admin` to access admin dashboard

---

## 📋 Essential Files

- **DEPLOYMENT.md** - Comprehensive deployment guide (read first!)
- **DEPLOYMENT_CHECKLIST.md** - Step-by-step checklist
- **.env.example** - Template for environment variables
- **README.md** - Development setup and features
- **scripts/setup.sh** - Automated setup script (Linux/Mac)
- **scripts/setup.bat** - Automated setup script (Windows)

---

## 🆘 Getting Help

1. **Read the full guide**: [DEPLOYMENT.md](./DEPLOYMENT.md)
2. **Use the checklist**: [DEPLOYMENT_CHECKLIST.md](./DEPLOYMENT_CHECKLIST.md)
3. **Check troubleshooting**: Section in DEPLOYMENT.md
4. **Open an issue**: On GitHub if stuck

---

## 🎯 Deployment Complexity Breakdown

| Component | Difficulty | Notes |
|-----------|-----------|-------|
| Next.js Frontend | ⭐ Easy | Standard deployment |
| MySQL Database | ⭐⭐ Medium | Standard setup |
| Smart Contracts | ⭐⭐⭐ Complex | Requires blockchain knowledge |
| Stripe Integration | ⭐⭐ Medium | CLI in dev, webhooks in prod |
| Multiple Services | ⭐⭐⭐ Complex | Coordination required |
| **Overall** | **⭐⭐⭐ Moderate** | **Manageable with guide** |

---

## ✅ Success Indicators

You've successfully deployed when:
- [ ] Users can register and login
- [ ] Stripe payments work
- [ ] Tokens can be minted (USD → RMT)
- [ ] Tokens can be transferred
- [ ] Tokens can be burned (RMT → USD)
- [ ] PayPal withdrawals work
- [ ] Admin dashboard accessible
- [ ] Email notifications send
- [ ] All transactions logged

---

**Ready to deploy?** Start with [DEPLOYMENT.md](./DEPLOYMENT.md) for the full guide!
