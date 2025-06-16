@echo off
echo Opening ports 9242 to 9246 in Windows Firewall...

REM Open firewall ports
for %%P in (9242 9243 9244 9245 9246) do (
    netsh advfirewall firewall add rule name="Open Port %%P" dir=in action=allow protocol=TCP localport=%%P >nul 2>&1
    echo ✅ Port %%P opened.
)

echo Launching Chrome with remote debugging on ports 9242 to 9246...

REM Path to Chrome (update this if Chrome is installed somewhere else)
set CHROME_PATH="C:\Program Files\Google\Chrome\Application\chrome.exe"

REM Goa Tenders - Port 9242
start "" %CHROME_PATH% --remote-debugging-port=9242 --user-data-dir="%~dp0\chrome_profile_9242" "https://eprocure.goa.gov.in/nicgep/app"

REM Delhi Tenders - Port 9243
start "" %CHROME_PATH% --remote-debugging-port=9243 --user-data-dir="%~dp0\chrome_profile_9243" "https://govtprocurement.delhi.gov.in/nicgep/app"

REM Dadra & Nagar Haveli and Daman & Diu Tenders - Port 9244
start "" %CHROME_PATH% --remote-debugging-port=9244 --user-data-dir="%~dp0\chrome_profile_9244" "https://ddtenders.gov.in/nicgep/app"

REM Daman & Diu (Alternate) Tenders - Port 9245
start "" %CHROME_PATH% --remote-debugging-port=9245 --user-data-dir="%~dp0\chrome_profile_9245" "https://dnhtenders.gov.in/nicgep/app"

REM Chandigarh Tenders - Port 9246
start "" %CHROME_PATH% --remote-debugging-port=9246 --user-data-dir="%~dp0\chrome_profile_9246" "https://etenders.chd.nic.in/nicgep/app"

echo ✅ All Chrome instances launched with remote debugging enabled.
pause
