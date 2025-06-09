@echo off
echo Opening ports 9222 to 9226 in Windows Firewall...

REM Open firewall ports
for %%P in (9222 9223 9224 9225 9226) do (
    netsh advfirewall firewall add rule name="Open Port %%P" dir=in action=allow protocol=TCP localport=%%P >nul 2>&1
    echo ✅ Port %%P opened.
)

echo Launching Chrome with remote debugging on ports 9222 to 9226...

REM Path to Chrome (update this if Chrome is installed somewhere else)
set CHROME_PATH="C:\Program Files\Google\Chrome\Application\chrome.exe"

REM Rajasthan Tenders - Port 9222
start "" %CHROME_PATH% --remote-debugging-port=9222 --user-data-dir="%~dp0\chrome_profile_9222" "https://eproc.rajasthan.gov.in/nicgep/app"

REM Maharashtra Tenders - Port 9223
start "" %CHROME_PATH% --remote-debugging-port=9223 --user-data-dir="%~dp0\chrome_profile_9223" "https://mahatenders.gov.in"

REM Andaman & Nicobar Tenders - Port 9224
start "" %CHROME_PATH% --remote-debugging-port=9224 --user-data-dir="%~dp0\chrome_profile_9224" "https://eprocure.andaman.gov.in/nicgep/app"

REM West Bengal Tenders - Port 9225
start "" %CHROME_PATH% --remote-debugging-port=9225 --user-data-dir="%~dp0\chrome_profile_9225" "https://wbtenders.gov.in/nicgep/app"

REM Tamil Nadu Tenders - Port 9226
start "" %CHROME_PATH% --remote-debugging-port=9226 --user-data-dir="%~dp0\chrome_profile_9226" "https://tntenders.gov.in/nicgep/app"

echo ✅ All Chrome instances launched with remote debugging enabled.
pause
