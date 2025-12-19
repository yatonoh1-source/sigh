# 🔧 Troubleshooting Guide

## Common Issues & Fixes

### 1. Build Fails with Docker Error

**Error:** `docker build failed` or `Dockerfile syntax error`

**Fix:**
- Railway uses Dockerfile builder (not Nixpacks)
- Check that Dockerfile exists in root folder
- Verify no syntax errors in Dockerfile
- Try rebuilding in Railway dashboard

---

### 2. "Cannot Connect to Database"

**Error:** Application crashes with database connection error

**Cause:** DATABASE_PATH variable not set or wrong

**Fix:**
1. Go to Railway → Settings → Variables
2. Verify these are set EXACTLY:
   ```
   DATABASE_PATH=/app/data/database.db
   SESSIONS_PATH=/app/data/sessions.db
   ```
3. Click Save/Deploy
4. Wait for redeploy

---

### 3. "Permission Denied /app/data"

**Error:** `EACCES: permission denied /app/data`

**Cause:** Volume not properly mounted or owned

**Fix:**
1. Go to Settings → Volumes
2. Delete the old volume
3. Create NEW volume:
   - Mount Path: `/app/data`
   - Size: `2GB`
4. Redeploy

---

### 4. Data Disappears After Redeployment

**Problem:** Login works, but after redeploy, database is empty

**Cause:** Volume not mounted (this is the #1 issue!)

**Fix:**
1. Go to Settings → Volumes
2. **MUST see:** `/app/data` mounted
3. If not there, create it (see issue #3 above)
4. Redeploy

**Why?** Without volume, `/app/data` is ephemeral (temporary) and deleted on redeploy.

---

### 5. Login Page Shows But Login Fails

**Error:** Can see login page, but login attempt doesn't work

**Cause:** ADMIN_EMAIL or ADMIN_PASSWORD not set

**Fix:**
1. Go to Settings → Variables
2. Verify these exist and are correct:
   ```
   ADMIN_EMAIL=your-email@domain.com
   ADMIN_PASSWORD=your-secure-password
   ADMIN_USERNAME=admin
   ```
3. Check for typos or extra spaces
4. Save and Redeploy
5. Wait 2 minutes for restart

---

### 6. "Health Check Failed" or Service Crashed

**Error:** Railway shows service as "crashed" or "exited"

**Cause:** App crashed during startup

**Fix:**
1. Click service → Deployments tab
2. Click most recent deployment
3. Read the full logs
4. Look for ERROR messages
5. Check if DATABASE_PATH, ADMIN_EMAIL are set
6. Try redeploying

---

### 7. Can't Find My Railway URL

**Problem:** Deployed but don't know the website URL

**Fix:**
1. Go to your Railway project
2. Click on the service (repository name)
3. Look for **Domains** section
4. You'll see `*.railway.app` URL
5. Copy and visit in browser

---

### 8. "Port Already in Use"

**Error:** Server won't start, "EADDRINUSE: address already in use"

**Cause:** PORT variable not set or hardcoded port conflict

**Fix:**
1. Go to Settings → Variables
2. Do NOT set PORT manually (Railway sets it)
3. Remove PORT from variables if you added it
4. Let Railway control the port
5. Redeploy

---

### 9. "ENOENT: no such file or directory"

**Error:** Application looks for a file that doesn't exist

**Cause:** Paths hardcoded to development folder

**Fix:**
- Check that DATABASE_PATH is `/app/data/database.db` (absolute path)
- NOT `./data/database.db` (relative path)
- Verify in Variables: `DATABASE_PATH=/app/data/database.db`
- Redeploy

---

### 10. "Out of Space" Error

**Error:** `ENOSPC: no space left on device`

**Cause:** Volume too small

**Fix:**
1. Go to Settings → Volumes
2. Edit the `/app/data` volume
3. Increase size to 5GB or 10GB
4. Redeploy

---

## Quick Checklist if Something's Wrong

- [ ] Volume mounted to `/app/data`? (Settings → Volumes)
- [ ] All 7 environment variables set? (Settings → Variables)
- [ ] No typos in ADMIN_EMAIL or ADMIN_PASSWORD?
- [ ] DATABASE_PATH = `/app/data/database.db`? (not relative path)
- [ ] Dockerfile in root folder?
- [ ] Recent build succeeded? (Deployments tab)
- [ ] Logs show "Server running"? (not ERROR messages)

---

## How to Read Railway Logs

1. Go to your service
2. Click **Logs** tab
3. Scroll to bottom for newest messages
4. Look for:
   - `Server running on port` = Good ✅
   - `ERROR` = Problem ❌
   - `EACCES: permission denied` = Volume issue
   - `ENOENT: no such file` = Path issue
   - `Cannot connect to database` = DB path issue

---

## Still Stuck?

1. **Take a screenshot** of the error
2. **Copy the full error message** from logs
3. **Redeploy** and wait for fresh attempt
4. **Check Railway status** at status.railway.app
5. **Review RAILWAY_SETUP_GUIDE.md** for steps

---

## Nuclear Option: Start Fresh

If everything is broken:

1. In Railway dashboard, delete the service
2. **Keep the volume** (don't delete it!)
3. Redeploy from GitHub
4. Reconfigure variables
5. Attach the old volume to `/app/data`
6. Deploy

This preserves your database while restarting the app.

---

**Most issues are either:**
- Missing/wrong environment variables
- Volume not mounted
- Trying to use relative paths instead of `/app/data`

**Fix these three, and you're good!** ✅
