# ✅ Railway Deployment - Master Checklist

## Pre-Deployment Checklist (Do Before GitHub)

- [ ] Have GitHub account ready
- [ ] Have admin email address ready
- [ ] Have secure password ready (12+ chars, mixed case, numbers)
- [ ] Have Railway account (or will create during deploy)

## GitHub Repository Setup

- [ ] Go to github.com/new
- [ ] Repository name: `amourscans`
- [ ] Description: AmourScans Manga Website
- [ ] Visibility: Public or Private
- [ ] ⚠️ DO NOT init with README
- [ ] Create repository
- [ ] Copy the HTTPS URL

## Push to GitHub

From the `railway` folder, run:

```bash
git init
git add .
git config user.name "Your Name"
git config user.email "your@email.com"
git commit -m "Railway deployment"
git remote add origin https://github.com/YOUR_USERNAME/amourscans.git
git branch -M main
git push -u origin main
```

Then proceed to Railway:

- [ ] Go to railway.app
- [ ] Create account or sign in
- [ ] New Project → Deploy from GitHub repo
- [ ] Select your `amourscans` repository
- [ ] ⏳ Wait for build (3-5 minutes)
- [ ] Status shows ✓ Success

## Volume Configuration (⚠️ CRITICAL!)

**Without this, your database will be deleted on redeployment.**

- [ ] Click on your service/repository
- [ ] Go to Settings tab
- [ ] Scroll to Volumes section
- [ ] Click "New Volume"
- [ ] Mount Path: `/app/data` (exactly this)
- [ ] Size: `2GB`
- [ ] Click Create

## Environment Variables (Must Have All 7!)

Go to Variables tab and add:

```
NODE_ENV=production
DATABASE_PATH=/app/data/database.db
SESSIONS_PATH=/app/data/sessions.db
ADMIN_EMAIL=your-real-email@domain.com
ADMIN_PASSWORD=YourSecurePassword123!
ADMIN_USERNAME=admin
PORT=5000
```

- [ ] NODE_ENV = `production`
- [ ] DATABASE_PATH = `/app/data/database.db`
- [ ] SESSIONS_PATH = `/app/data/sessions.db`
- [ ] ADMIN_EMAIL = your actual email
- [ ] ADMIN_PASSWORD = strong password (changed from example)
- [ ] ADMIN_USERNAME = `admin`
- [ ] PORT = `5000`
- [ ] Click Save

**Railway auto-redeploys. Wait 2-3 minutes.**

## Deployment Success Indicators

- [ ] Deployments tab shows ✓ Success
- [ ] Build logs show no ERROR messages
- [ ] Service status shows "Up"

## Functionality Tests

### Test 1: Health Endpoint
- [ ] Visit `https://your-railway-url/api/health`
- [ ] See JSON response: `{"status":"ok",...}`

### Test 2: Login Page
- [ ] Visit `https://your-railway-url/login`
- [ ] Page loads without errors

### Test 3: Admin Login
- [ ] Login with your ADMIN_EMAIL and ADMIN_PASSWORD
- [ ] Successfully logged in
- [ ] Can see dashboard

### Test 4: User Signup
- [ ] Go to signup page
- [ ] Create a new test account
- [ ] Account is created successfully
- [ ] Can login with new account

### Test 5: Data Persistence
- [ ] Redeploy (git push or Railway redeploy button)
- [ ] Wait for new build (3-5 min)
- [ ] Login again
- [ ] Test user account still exists ✅
- [ ] Database persisted across deployment ✅

## Post-Deployment Verification

- [ ] No "Permission denied" errors in logs
- [ ] No "ENOENT" (file not found) errors
- [ ] No "Cannot connect to database" errors
- [ ] Health endpoint returns 200 status
- [ ] All pages load at Railway URL
- [ ] Admin login works
- [ ] User signup works
- [ ] Data persists after redeployment

## If Anything Fails

**Most common issues:**
1. Volume not mounted → See TROUBLESHOOTING.md #3
2. Missing env variables → See TROUBLESHOOTING.md #2
3. Wrong ADMIN credentials → See TROUBLESHOOTING.md #5
4. Data disappears → Volume not configured (see step above)

**How to fix:**
1. Go to Settings → Volumes → Verify `/app/data` mounted
2. Go to Variables → Verify all 7 variables set
3. Click Redeploy
4. Wait 2-3 minutes
5. Test again

**Still broken?** Read TROUBLESHOOTING.md in this folder

## Success! 🎉

Once you've completed all tests above, your AmourScans website is:
- ✅ Live on Railway
- ✅ Database persists on redeploy
- ✅ Fully functional with no manual fixes needed
- ✅ Ready for production use

**Share your Railway URL with users!**

---

**Question?** Check these guides:
1. README_RAILWAY.md - Overview
2. RAILWAY_SETUP_GUIDE.md - Detailed steps
3. TROUBLESHOOTING.md - Problem solving
4. START_HERE.txt - Quick reference
