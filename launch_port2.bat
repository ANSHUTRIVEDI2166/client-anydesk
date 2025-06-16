@echo off
echo Opening ports 9227 to 9231 in Windows Firewall...

REM Open firewall ports
for %%P in (9227 9228 9229 9230 9231) do (
    netsh advfirewall firewall add rule name="Open Port %%P" dir=in action=allow protocol=TCP localport=%%P >nul 2>&1
    echo ✅ Port %%P opened.
)

echo Launching Chrome with remote debugging on ports 9227 to 9231...

REM Path to Chrome (update this if Chrome is installed somewhere else)
set CHROME_PATH="C:\Program Files\Google\Chrome\Application\chrome.exe"

REM Nagaland Tenders - Port 9227
start "" %CHROME_PATH% --remote-debugging-port=9227 --user-data-dir="%~dp0\chrome_profile_9227" "https://nagalandtenders.gov.in/nicgep/app"

REM Sikkim Tenders - Port 9228
start "" %CHROME_PATH% --remote-debugging-port=9228 --user-data-dir="%~dp0\chrome_profile_9228" "https://sikkimtender.gov.in/nicgep/app"

REM Uttar Pradesh Tenders - Port 9229
start "" %CHROME_PATH% --remote-debugging-port=9229 --user-data-dir="%~dp0\chrome_profile_9229" "https://etender.up.nic.in/nicgep/app"

REM Tripura Tenders - Port 9230
start "" %CHROME_PATH% --remote-debugging-port=9230 --user-data-dir="%~dp0\chrome_profile_9230" "https://tripuratenders.gov.in/nicgep/app"

REM Uttarakhand Tenders - Port 9231
start "" %CHROME_PATH% --remote-debugging-port=9231 --user-data-dir="%~dp0\chrome_profile_9231" "https://uktenders.gov.in/nicgep/app"

echo ✅ All Chrome instances launched with remote debugging enabled.
pause
