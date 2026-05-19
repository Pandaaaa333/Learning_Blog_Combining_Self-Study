# Repackage Script for Study Management System
# This script stops existing containers, rebuilds images without cache, and starts everything up.

Write-Host "--- Stopping existing containers ---" -ForegroundColor Cyan
docker-compose down

Write-Host "`n--- Rebuilding all images (No Cache) ---" -ForegroundColor Cyan
Write-Host "This might take a few minutes..."
docker-compose build --no-cache

Write-Host "`n--- Starting all services ---" -ForegroundColor Cyan
docker-compose up -d

Write-Host "`n--- Service Status ---" -ForegroundColor Cyan
docker-compose ps

Write-Host "`nPackaging complete! You can access the apps at:" -ForegroundColor Green
Write-Host "React Frontend: http://localhost:3000"
Write-Host "Flutter Web:    http://localhost:8081"
Write-Host "Backend API:    http://localhost:8080"
Write-Host "MinIO Console:  http://localhost:9001 (User: minioadmin, Pass: minioadminpassword)"
Write-Host "MinIO API:      http://localhost:9000"
