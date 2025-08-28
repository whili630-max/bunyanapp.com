# 🚀 Bunyan Marketplace - GoDaddy Deployment Guide

## 📋 **DEPLOYMENT OVERVIEW**
Deploy the Bunyan Marketplace Flutter web app to **bunyanapp.com** using GoDaddy hosting.

## 🛠️ **STEP 1: BUILD PREPARATION**
The Flutter web build is currently compiling. Once complete, you'll have a `build/web` folder with all deployment files.

## 📁 **STEP 2: GODADDY HOSTING SETUP**

### **Option A: GoDaddy Web Hosting (Recommended)**
1. **Access GoDaddy cPanel**:
   - Log into your GoDaddy account
   - Go to "My Products" → "Web Hosting"
   - Click "Manage" next to your hosting plan

2. **File Manager Access**:
   - In cPanel, click "File Manager"
   - Navigate to `public_html` folder
   - Delete any existing files (backup first if needed)

3. **Upload Files**:
   - Upload ALL contents from `bunyan_marketplace/build/web/` to `public_html`
   - Ensure `index.html` is in the root of `public_html`
   - The CNAME file should be included automatically

### **Option B: GitHub Pages with Custom Domain**
1. **Create GitHub Repository**:
   ```bash
   git init
   git add .
   git commit -m "Initial Bunyan Marketplace deployment"
   git branch -M main
   git remote add origin https://github.com/yourusername/bunyan-marketplace.git
   git push -u origin main
   ```

2. **Enable GitHub Pages**:
   - Go to repository Settings → Pages
   - Source: Deploy from a branch
   - Branch: main / docs or gh-pages
   - Upload build/web contents to docs folder

3. **Configure Custom Domain**:
   - In GitHub Pages settings, add `bunyanapp.com`
   - The CNAME file will handle the domain mapping

## 🌐 **STEP 3: DOMAIN CONFIGURATION**

### **GoDaddy DNS Settings**
1. **Access DNS Management**:
   - GoDaddy Account → My Products → Domains
   - Click "Manage" next to bunyanapp.com
   - Go to "DNS" tab

2. **Configure A Records** (for GoDaddy Hosting):
   ```
   Type: A
   Name: @
   Value: [Your GoDaddy hosting IP]
   TTL: 1 Hour
   
   Type: A  
   Name: www
   Value: [Your GoDaddy hosting IP]
   TTL: 1 Hour
   ```

3. **Configure CNAME** (for GitHub Pages):
   ```
   Type: CNAME
   Name: www
   Value: yourusername.github.io
   TTL: 1 Hour
   
   Type: A
   Name: @
   Value: 185.199.108.153
   TTL: 1 Hour
   ```

## 📂 **STEP 4: FILE STRUCTURE VERIFICATION**
After upload, your hosting should have:
```
public_html/
├── index.html (main entry point)
├── main.dart.js (compiled Flutter code)
├── flutter.js
├── flutter_service_worker.js
├── manifest.json
├── CNAME (bunyanapp.com)
├── assets/
│   ├── fonts/
│   ├── images/
│   └── packages/
├── canvaskit/
└── icons/
```

## 🔧 **STEP 5: CONFIGURATION FILES**

### **Web Server Configuration (.htaccess)**
Create `.htaccess` in public_html for proper routing:
```apache
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^(.*)$ /index.html [QSA,L]

# Enable GZIP compression
<IfModule mod_deflate.c>
    AddOutputFilterByType DEFLATE text/plain
    AddOutputFilterByType DEFLATE text/html
    AddOutputFilterByType DEFLATE text/xml
    AddOutputFilterByType DEFLATE text/css
    AddOutputFilterByType DEFLATE application/xml
    AddOutputFilterByType DEFLATE application/xhtml+xml
    AddOutputFilterByType DEFLATE application/rss+xml
    AddOutputFilterByType DEFLATE application/javascript
    AddOutputFilterByType DEFLATE application/x-javascript
</IfModule>

# Cache static assets
<IfModule mod_expires.c>
    ExpiresActive on
    ExpiresByType text/css "access plus 1 year"
    ExpiresByType application/javascript "access plus 1 year"
    ExpiresByType image/png "access plus 1 year"
    ExpiresByType image/jpg "access plus 1 year"
    ExpiresByType image/jpeg "access plus 1 year"
</IfModule>
```

## 🚀 **STEP 6: DEPLOYMENT VERIFICATION**

### **Test Checklist**
1. **Domain Access**: Visit https://bunyanapp.com
2. **SSL Certificate**: Ensure HTTPS is working
3. **Mobile Responsiveness**: Test on mobile devices
4. **Core Functionality**:
   - [ ] Splash screen loads
   - [ ] Client platform accessible
   - [ ] Login functionality works
   - [ ] Navigation between tabs
   - [ ] Arabic/English language support
   - [ ] Cart functionality
   - [ ] Profile management

### **Performance Optimization**
1. **Enable GZIP compression** (via .htaccess)
2. **Configure browser caching**
3. **Optimize images** (already handled by Flutter build)
4. **Enable CDN** (optional, through GoDaddy)

## 🔍 **STEP 7: TROUBLESHOOTING**

### **Common Issues**
1. **404 Errors on Refresh**:
   - Ensure .htaccess file is properly configured
   - Check that URL rewriting is enabled

2. **Assets Not Loading**:
   - Verify all files from build/web are uploaded
   - Check file permissions (755 for folders, 644 for files)

3. **Domain Not Resolving**:
   - DNS propagation can take 24-48 hours
   - Use DNS checker tools to verify propagation

4. **SSL Issues**:
   - GoDaddy provides free SSL certificates
   - Enable SSL in hosting control panel

## 📞 **SUPPORT RESOURCES**
- **GoDaddy Support**: 1-480-505-8877
- **Flutter Web Docs**: https://flutter.dev/web
- **DNS Propagation Checker**: https://dnschecker.org

## 🎉 **DEPLOYMENT COMPLETE**
Once deployed, your Bunyan Marketplace will be live at:
- **Primary**: https://bunyanapp.com
- **WWW**: https://www.bunyanapp.com

The application includes:
- ✅ Professional Arabic-first construction marketplace
- ✅ Complete authentication system
- ✅ Cart and order management
- ✅ Multi-platform architecture
- ✅ Mobile-responsive design
- ✅ Production-ready performance
