# 🚀 Railway Deployment - Complete Setup Guide

## What This Folder Contains

Your AmourScans website is **100% ready** for Railway.app. All configuration is done. You just need to:
1. Push to GitHub
2. Connect to Railway
3. Set environment variables
4. Done! ✅

---

## Step-by-Step Deployment (10 minutes)

### STEP 1: Prepare GitHub Repository

```bash
# From this "railway" folder, initialize git
cd railway
git init
git add .
git config user.name "Your Name"
git config user.email "your@email.com"
git commit -m "Railway-ready AmourScans deployment"
```

### STEP 2: Create GitHub Repository

1. Go to **https://github.com/new**
2. Fill in:
   - **Repository name:** `amourscans` (or any name you want)
   - **Description:** AmourScans Manga Website
   - **Visibility:** Public or Private
3. **CRITICAL:** Do NOT check "Initialize with README"
4. Click **Create Repository**

### STEP 3: Push to GitHub

Copy-paste these commands:

```bash
# From the railway folder
git remote add origin https://github.com/YOUR_USERNAME/amourscans.git
git branch -M main
git push -u origin main
```

**Replace `YOUR_USERNAME` with your actual GitHub username**

### STEP 4: Deploy to Railway

1. Go to **https://railway.app**
2. Sign in (create account if needed - free tier available)
3. Click **New Project**
4. Select **Deploy from GitHub repo**
5. Authorize GitHub if prompted
6. Find and select your **amourscans** repository
7. Wait for Railway to build (3-5 minutes)

**Watch the build progress - you'll see "✓ Success" when done**

### STEP 5: Configure Persistent Storage (CRITICAL!)

**Without this, your database will be deleted on every redeployment:**

1. Click on your service in Railway
2. Go to **Settings** tab
3. Scroll to **Volumes** section
4. Click **New Volume**
5. Enter:
   - **Mount Path:** `/app/data`
   - **Size:** `2GB`
6. Click **Create**

### STEP 6: Set Environment Variables

1. Click **Variables** tab
2. Click **Edit** or **New**
3. Add these 7 variables exactly:

```
NODE_ENV=production
DATABASE_PATH=/app/data/database.db
SESSIONS_PATH=/app/data/sessions.db
ADMIN_EMAIL=admin@yourdomain.com
ADMIN_PASSWORD=YourSecurePassword123!
ADMIN_USERNAME=admin
PORT=5000
```

**IMPORTANT:** Replace:
- `admin@yourdomain.com` with your real email
- `YourSecurePassword123!` with a strong password (12+ characters, mixed case, numbers, symbols)

4. Click **Save/Deploy**

**Railway will automatically redeploy with these variables. Wait 2-3 minutes.**

### STEP 7: Verify It Works

Once deployment shows "✓ Success":

1. **Find your URL:**
   - In Railway dashboard, look for your service
   - Find **Domains** section
   - Copy the Railway URL (looks like `something.railway.app`)

2. **Test the health endpoint:**
   ```
   Visit: https://your-railway-url/api/health
   Expected: JSON response with {"status":"ok",...}
   ```

3. **Test the login page:**
   ```
   Visit: https://your-railway-url/login
   Expected: Login page loads
   ```

4. **Login with your admin account:**
   - Email: (the ADMIN_EMAIL you set)
   - Password: (the ADMIN_PASSWORD you set)
   - Expected: Successfully logged in, see dashboard

5. **Test user signup:**
   - Go to signup page
   - Create a test account
   - Expected: New user created, can login

6. **Verify data persists:**
   - Redeploy (git push to trigger redeploy or click redeploy button)
   - Login again
   - Expected: Your test account still exists!

---

## Troubleshooting

### ❌ Build Failed
**Check:** Railway build logs for errors
**Fix:** Verify Dockerfile and package.json are correct

### ❌ Data Disappeared After Redeployment
**Cause:** Volume not mounted
**Fix:** Go to Settings → Volumes, verify `/app/data` is mounted

### ❌ Login Doesn't Work
**Cause:** ADMIN_EMAIL or ADMIN_PASSWORD not set correctly
**Fix:** Check Variables tab, verify exact spelling and values

### ❌ "Permission Denied" in Logs
**Cause:** Volume ownership issue
**Fix:** Re-create the volume, ensure it mounts to `/app/data`

### ❌ "Out of Space" Error
**Cause:** Volume too small
**Fix:** Increase volume size to 5GB in Settings

### ❌ Can't Connect to Database
**Cause:** DATABASE_PATH env variable wrong
**Fix:** Verify it's set to `/app/data/database.db`

---

## File Structure

```
railway/
├── Dockerfile                  ← How to build for Railway
├── .railway.toml               ← Railway configuration
├── .dockerignore               ← Build optimization
├── package.json                ← Dependencies
├── server/
│   ├── index.ts               ← App server (has /api/health)
│   └── storage.ts             ← Database handling
├── client/                     ← React frontend
├── shared/                     ← Shared code
├── .env.example                ← Configuration template
├── RAILWAY_SETUP_GUIDE.md      ← This file
├── RAILWAY_CHECKLIST.txt       ← Quick reference
└── [other files]
```

---

## What's Already Configured

✅ **Dockerfile** - Optimized for Railway, builds everything automatically
✅ **Database** - Uses `/app/data` for persistence
✅ **Health endpoint** - `/api/health` for monitoring
✅ **Port binding** - Listens on dynamic PORT (Railway sets this)
✅ **Security** - Non-root user, proper permissions
✅ **Environment variables** - All configured for Railway
✅ **SQLite persistence** - Volume mounts keep data safe

**Nothing else needs to be done. Just follow the 7 steps above.**

---

## Success Checklist

After deployment, verify these all pass:

- [ ] Railway build succeeded
- [ ] `https://your-url/api/health` returns JSON
- [ ] `https://your-url/login` loads login page
- [ ] Can login with admin credentials
- [ ] Can create new user account
- [ ] Can login as new user
- [ ] Logs show no ERROR or PERMISSION messages
- [ ] Redeploy → Previous data still exists

**If all pass, you're done! 🎉**

---

## Need Help?

1. Check Railway docs: https://docs.railway.app
2. Review logs in Railway dashboard
3. See TROUBLESHOOTING.md in this folder
4. Check RAILWAY_CHECKLIST.txt for quick reference

**Good luck! Your website will be live soon!**
