@echo off
echo Opening ports 9232 to 9236 in Windows Firewall...

REM Open firewall ports
for %%P in (9232 9233 9234 9235 9236) do (
    netsh advfirewall firewall add rule name="Open Port %%P" dir=in action=allow protocol=TCP localport=%%P >nul 2>&1
    echo ✅ Port %%P opened.
)

echo Launching Chrome with remote debugging on ports 9232 to 9236...

REM Path to Chrome (update this if Chrome is installed somewhere else)
set CHROME_PATH="C:\Program Files\Google\Chrome\Application\chrome.exe"

REM Mizoram Tenders - Port 9232
start "" %CHROME_PATH% --remote-debugging-port=9232 --user-data-dir="%~dp0\chrome_profile_9232" "https://mizoramtenders.gov.in/nicgep/app"

REM Meghalaya Tenders - Port 9233
start "" %CHROME_PATH% --remote-debugging-port=9233 --user-data-dir="%~dp0\chrome_profile_9233" "https://meghalayatenders.gov.in/nicgep/app"

REM Manipur Tenders - Port 9234
start "" %CHROME_PATH% --remote-debugging-port=9234 --user-data-dir="%~dp0\chrome_profile_9234" "https://manipurtenders.gov.in/nicgep/app"

REM Madhya Pradesh Tenders - Port 9235
start "" %CHROME_PATH% --remote-debugging-port=9235 --user-data-dir="%~dp0\chrome_profile_9235" "https://mptenders.gov.in/nicgep/app"

REM Union Territories of Lakshadweep Tenders - Port 9236
start "" %CHROME_PATH% --remote-debugging-port=9236 --user-data-dir="%~dp0\chrome_profile_9236" "https://tendersutl.gov.in/nicgep/app"

echo ✅ All Chrome instances launched with remote debugging enabled.
pause
