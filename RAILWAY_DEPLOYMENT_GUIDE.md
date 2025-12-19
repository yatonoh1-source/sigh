# Railway.app Deployment Guide for AmourScans

This guide will deploy your AmourScans manga website to Railway.app with 100% automation and data persistence.

## Prerequisites
- GitHub account with the amourscanc.com repository pushed
- Railway.app account (free tier available)
- Your admin email and a secure password

## Complete Deployment Steps

### Step 1: Create GitHub Repository (If Not Already Done)

```bash
# Create amourscanc.com folder
mkdir -p ../amourscanc.com
cp -r . ../amourscanc.com/
cd ../amourscanc.com

# Remove node_modules (will reinstall in Railway)
rm -rf node_modules package-lock.json

# Initialize git
git init
git add .
git commit -m "Railway-ready AmourScans deployment"

# Create repo on github.com/new (name: amourscanc.com, keep private)
# Then push
git remote add origin https://github.com/YOUR-USERNAME/amourscanc.com.git
git branch -M main
git push -u origin main
```

### Step 2: Railway Dashboard Setup

1. **Login to railway.app**
   - Go to https://railway.app
   - Sign in or create account

2. **Create New Project**
   - Click "New Project" → "Deploy from GitHub repo"
   - Authorize GitHub if prompted
   - Select `amourscanc.com` repository

3. **Wait for Initial Build**
   - Railway will auto-detect Dockerfile
   - Build takes 3-5 minutes
   - You'll see build logs in progress

### Step 3: Configure Persistent Volume (CRITICAL)

**This ensures your database persists between deployments:**

1. Go to your Railway project
2. Click on the service (should be named after your repo)
3. Go to **Settings** tab → **Volumes**
4. Click **New Volume**
   - Mount Path: `/app/data`
   - Size: `2GB` (sufficient for SQLite)
5. Click **Create Volume**

### Step 4: Set Environment Variables

1. Go to **Variables** tab in your service settings
2. Add these exact variables:

```
NODE_ENV=production
DATABASE_PATH=/app/data/database.db
SESSIONS_PATH=/app/data/sessions.db
ADMIN_EMAIL=your-real-email@yourdomain.com
ADMIN_PASSWORD=generate-secure-random-password-here
ADMIN_USERNAME=admin
PORT=5000
```

**Important:** Replace:
- `your-real-email@yourdomain.com` with your actual email
- `generate-secure-random-password-here` with a strong password (minimum 12 characters, mix of uppercase, lowercase, numbers, symbols)

### Step 5: Deploy

1. Railway typically auto-deploys after variable configuration
2. Watch the **Deployments** tab
3. Wait for status to show `✓ Success`

### Step 6: Verify Deployment

Once deployment is successful:

1. **Find Your URL**
   - Go to your service settings
   - Look for **Domains** section
   - Copy your Railway URL (usually `*.railway.app`)

2. **Test the Application**
   - Go to `https://your-railway-url/login`
   - Login with credentials you set:
     - Email: (your ADMIN_EMAIL)
     - Password: (your ADMIN_PASSWORD)
   - Create a test user account
   - Verify pages load correctly

3. **Check Health Endpoint**
   - Visit `https://your-railway-url/api/health`
   - Should return JSON: `{"status":"ok","timestamp":"...","uptime":...,"environment":"production"}`

4. **Verify Database Persistence**
   - Redeploy your app (or wait for new deployment)
   - Login again - all data should persist
   - If you see fresh database, the volume mount failed

## Complete Verification Checklist

- [ ] Railway build completed without errors
- [ ] Server logs show "serving on http://0.0.0.0:5000"
- [ ] `/api/health` endpoint returns 200 status
- [ ] Login page loads at your Railway URL
- [ ] Admin login works with your credentials
- [ ] User signup creates new accounts
- [ ] SQLite files visible in `/app/data` volume
- [ ] Database persists after redeployment
- [ ] No "permission denied" errors in logs
- [ ] No "ENOENT" (file not found) errors

## Troubleshooting

### "Cannot connect to database" error
**Fix:** Check that DATABASE_PATH is set to `/app/data/database.db`

### "Permission denied" for /app/data
**Fix:** Volume mount not configured properly
- Go to Settings → Volumes
- Verify `/app/data` mount exists

### Data disappears after redeployment
**Fix:** Volume mount not properly attached
- Ensure volume is mounted to `/app/data`
- Check volume is at least 2GB

### "No space left on device"
**Fix:** Volume is too small
- Increase volume size to 5GB in settings

### Login doesn't work
**Fix:** Admin user wasn't created
- Check logs for admin initialization messages
- Verify ADMIN_EMAIL and ADMIN_PASSWORD are set

### Rebuild after code changes
```bash
cd ../amourscanc.com
git add .
git commit -m "Your change description"
git push origin main
# Railway auto-rebuilds within seconds
```

## Important Notes

- **Database files are stored in the `/app/data` volume** - they persist across deployments
- **Do NOT commit .db files to GitHub** - they're gitignored automatically
- **Your admin credentials must be changed** from example defaults
- **First deployment creates the admin user automatically** from environment variables
- **HTTPS is automatic** - Railway provides free SSL certificates

## Support & Logs

If deployment fails:
1. Check **Deployments** tab for build errors
2. Click the failed deployment to see full logs
3. Common issues are usually missing environment variables or volume configuration

## After Deployment Success

Your AmourScans manga website is now live at your Railway URL!

- Share your Railway URL with users
- Your data persists securely in the volume
- Scale up when needed (paid Railway tier)
- Monitor uptime and performance in Railway dashboard

---

**Questions?** Check Railway documentation: https://docs.railway.app
