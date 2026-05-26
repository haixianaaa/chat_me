# 从 pubspec.yaml 读取版本号
$yaml = Get-Content "pubspec.yaml" -Raw
if ($yaml -match 'version:\s*([0-9]+\.[0-9]+\.[0-9]+)') {
    $verName = $Matches[1]
} else {
    $verName = "1.0.0"
}

Write-Host "Building ChatMe v$verName ..." -ForegroundColor Cyan

flutter build apk --release

if ($LASTEXITCODE -eq 0) {
    $src = "build\app\outputs\flutter-apk\app-release.apk"
    $dst = "build\app\outputs\flutter-apk\chat_me-v$verName.apk"
    Copy-Item $src $dst -Force
    Write-Host "APK built: $dst" -ForegroundColor Green
} else {
    Write-Host "Build failed!" -ForegroundColor Red
}
