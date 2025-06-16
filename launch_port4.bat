@echo off
echo Opening ports 9237 to 9241 in Windows Firewall...

REM Open firewall ports
for %%P in (9237 9238 9239 9240 9241) do (
    netsh advfirewall firewall add rule name="Open Port %%P" dir=in action=allow protocol=TCP localport=%%P >nul 2>&1
    echo ✅ Port %%P opened.
)

echo Launching Chrome with remote debugging on ports 9237 to 9241...

REM Path to Chrome (update this if Chrome is installed somewhere else)
set CHROME_PATH="C:\Program Files\Google\Chrome\Application\chrome.exe"

REM Ladakh Tenders - Port 9237
start "" %CHROME_PATH% --remote-debugging-port=9237 --user-data-dir="%~dp0\chrome_profile_9237" "https://tenders.ladakh.gov.in/nicgep/app"

REM Kerala Tenders - Port 9238
start "" %CHROME_PATH% --remote-debugging-port=9238 --user-data-dir="%~dp0\chrome_profile_9238" "https://etenders.kerala.gov.in/nicgep/app"

REM Jharkhand Tenders - Port 9239
start "" %CHROME_PATH% --remote-debugging-port=9239 --user-data-dir="%~dp0\chrome_profile_9239" "https://jharkhandtenders.gov.in/nicgep/app"

REM Himachal Pradesh Tenders - Port 9240
start "" %CHROME_PATH% --remote-debugging-port=9240 --user-data-dir="%~dp0\chrome_profile_9240" "https://hptenders.gov.in/nicgep/app"

REM Haryana Tenders - Port 9241
start "" %CHROME_PATH% --remote-debugging-port=9241 --user-data-dir="%~dp0\chrome_profile_9241" "https://etenders.hry.nic.in/nicgep/app"

echo ✅ All Chrome instances launched with remote debugging enabled.
pause
