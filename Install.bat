@echo off
setlocal

set NODE_VERSION=18.16.0
set INSTALLER=node-v%NODE_VERSION%-x64.msi
set DOWNLOAD_URL=https://nodejs.org/dist/v%NODE_VERSION%/%INSTALLER%

set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

node -v >nul 2>&1
if %errorlevel% == 0 (
    echo Node.js is already installed.
    echo Running npm install...
    npm install
    exit /b
)

echo Downloading Node.js...
curl -o %INSTALLER% %DOWNLOAD_URL%

echo Installing Node.js...
msiexec /i %INSTALLER% /quiet /norestart

echo Waiting for installation to finish...
timeout /t 10 /nobreak >nul

node -v >nul 2>&1
if %errorlevel% == 0 (
    echo Node.js installed successfully.
) else (
    echo Node.js installation failed.
    exit /b 1
)

del %INSTALLER%

cd /d "%SCRIPT_DIR%"
echo Running npm install...
npm install

echo Done.
endlocal
exit /b
