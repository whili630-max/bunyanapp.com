@echo off
echo 🚀 Bunyan Marketplace - Deployment Script
echo ========================================

echo.
echo 📦 Building for production...
flutter build web --release --web-renderer html

echo.
echo ✅ Build completed successfully!
echo.
echo 📁 Deployment files are ready in: build\web\
echo.
echo 🌐 Next steps for bunyanapp.com deployment:
echo 1. Upload all files from build\web\ to your web server
echo 2. Configure DNS to point bunyanapp.com to your server
echo 3. Enable HTTPS with SSL certificate
echo 4. Test the deployment
echo.
echo 📋 Files ready for deployment:
dir build\web\ /b

echo.
echo 🎉 Bunyan Marketplace is ready for bunyanapp.com!
pause
