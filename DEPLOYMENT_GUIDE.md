# Deploy Flutter Web App to GitHub Pages

This guide walks you through deploying your Flutter web app to GitHub Pages for free, public hosting.

## Prerequisites
- Flutter SDK installed and `flutter build web` working
- GitHub account (free tier is fine)
- Git installed on your machine
- A built `build/web` folder ready to deploy

## Deployment Methods

You have two options for deployment:

### **Option A: Automatic Deployment with GitHub Actions (Recommended)**
GitHub Actions automatically rebuilds and deploys your app every time you push to the `main` branch.

### **Option B: Manual Deployment**
You manually push the built `build/web` folder to GitHub and enable GitHub Pages.

---

## **Option A: Automatic Deployment (GitHub Actions)**

### Step 1: Create a GitHub Repository

1. Go to [github.com](https://github.com) and log in
2. Click the `+` icon (top-right) → **New repository**
3. Name it `website-for-kuya` (or any name you prefer)
4. **Important:** Do NOT initialize with README, .gitignore, or license (we already have these)
5. Click **Create repository**

### Step 2: Add Remote and Push Initial Code

Run these commands in your project folder:

```powershell
Set-Location -LiteralPath "d:\Website\website_for_kuya"

# Configure Git user (if not already set)
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Add all files (respecting .gitignore)
git add .

# Commit
git commit -m "Initial commit: Flutter web project with build"

# Add remote (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/website-for-kuya.git

# Rename branch to main (GitHub's default)
git branch -M main

# Push to GitHub
git push -u origin main
```

### Step 3: Enable GitHub Pages

1. Go to your repository on GitHub
2. Click **Settings** (gear icon, right side)
3. Scroll down to **Pages** section (left sidebar)
4. Under "Build and deployment":
   - **Source**: Select `Deploy from a branch`
   - **Branch**: Select `gh-pages` / `root`
   - Click **Save**

Note: The GitHub Actions workflow automatically creates a `gh-pages` branch and publishes to it.

### Step 4: Monitor Deployment

1. After pushing, go to the **Actions** tab in your repository
2. You'll see a workflow named "Deploy to GitHub Pages" running
3. Wait for it to complete (usually 1-2 minutes)
4. Once successful, your site will be live at: `https://YOUR_USERNAME.github.io/website-for-kuya`

### Step 5: Update Your App in the Future

Whenever you make changes to your Flutter app:

```powershell
Set-Location -LiteralPath "d:\Website\website_for_kuya"

# Make your code changes
# ... (edit files)

# Build locally (optional, for testing)
flutter build web --release

# Commit and push
git add .
git commit -m "Update: Add new features"
git push
```

GitHub Actions will automatically rebuild and redeploy. No manual steps needed!

---

## **Option B: Manual Deployment**

### Step 1: Create a GitHub Repository

(Same as Option A, Step 1)

### Step 2: Push Source Code (Without build/ folder)

```powershell
Set-Location -LiteralPath "d:\Website\website_for_kuya"

git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

git add .
git commit -m "Initial commit: Flutter web project"

git remote add origin https://github.com/YOUR_USERNAME/website-for-kuya.git
git branch -M main
git push -u origin main
```

### Step 3: Create a Deployment Folder

Create a separate branch or folder for deployment:

```powershell
# Create a new branch for deployment
git checkout --orphan gh-pages
git rm -rf .

# Copy only the build/web contents
Copy-Item -Path ".\build\web\*" -Destination "." -Recurse

git add .
git commit -m "Deploy: Initial build"
git push -u origin gh-pages
```

### Step 4: Enable GitHub Pages (Same as Option A, Step 3)

---

## **Option C: Custom Domain (Optional)**

If you have a custom domain (e.g., `myrobotics.com`):

### Step 1: Create a CNAME File

Add a `CNAME` file to your `build/web` folder with your domain:

**File: `d:\Website\website_for_kuya\build\web\CNAME`**
```
myrobotics.com
```

### Step 2: Update DNS Records

In your domain registrar's DNS settings, add:

| Type  | Name | Value |
|-------|------|-------|
| CNAME | www  | YOUR_USERNAME.github.io |
| A     | @    | 185.199.108.153 |
|       |      | 185.199.109.153 |
|       |      | 185.199.110.153 |
|       |      | 185.199.111.153 |

### Step 3: Configure GitHub Pages

1. Go to **Settings** → **Pages**
2. Under "Custom domain", enter your domain name (e.g., `myrobotics.com`)
3. Check the **Enforce HTTPS** checkbox
4. Click **Save**

DNS propagation takes 24-48 hours. Your site will be live at your custom domain!

---

## **Troubleshooting**

### GitHub Actions Workflow Fails to Deploy
- Check the **Actions** tab for error messages
- Common issues:
  - Flutter version mismatch: Update `flutter-version` in `.github/workflows/deploy.yml`
  - Dependencies not installing: Run `flutter pub get` locally first
  - Build errors: Run `flutter build web --release` locally to debug

### Site Shows 404 or Blank Page
- Verify `gh-pages` branch exists in GitHub
- Check **Settings** → **Pages** → ensure correct branch is selected
- Try clearing browser cache (Ctrl+Shift+Delete)
- Check build output at `https://YOUR_USERNAME.github.io/website-for-kuya/` with trailing slash

### Custom Domain Not Working
- Wait 24-48 hours for DNS propagation
- Verify CNAME file exists in root of published folder
- Use online DNS checker: [mxtoolbox.com](https://mxtoolbox.com)
- Check GitHub Pages settings for errors

---

## **Quick Reference: Workflow Overview**

```
1. Edit code locally
   ↓
2. Run: git add . && git commit -m "message" && git push
   ↓
3. GitHub Actions automatically:
   - Checks out your code
   - Installs Flutter
   - Runs: flutter pub get
   - Runs: flutter build web --release
   - Pushes build/web to gh-pages branch
   ↓
4. GitHub Pages serves from gh-pages branch
   ↓
5. Site live at: https://YOUR_USERNAME.github.io/website-for-kuya
```

---

## **Summary**

- **Recommended**: Use GitHub Actions (Option A) for automatic deployment on every push
- **Manual**: Use Option B if you prefer control over when to deploy
- **Domain**: Add a custom domain anytime via CNAME + DNS records
- **Cost**: Free tier includes unlimited public repositories and GitHub Pages

Your Flutter web app is now ready to deploy! 🚀
