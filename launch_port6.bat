@echo off
echo Opening ports 9247 to 9251 in Windows Firewall...

REM Open firewall ports
for %%P in (9247 9248 9249 9250 9251) do (
    netsh advfirewall firewall add rule name="Open Port %%P" dir=in action=allow protocol=TCP localport=%%P >nul 2>&1
    echo ✅ Port %%P opened.
)

echo Launching Chrome with remote debugging on ports 9247 to 9251...

REM Path to Chrome (update this if Chrome is installed somewhere else)
set CHROME_PATH="C:\Program Files\Google\Chrome\Application\chrome.exe"

REM Assam Tenders - Port 9247
start "" %CHROME_PATH% --remote-debugging-port=9247 --user-data-dir="%~dp0\chrome_profile_9247" "https://assamtenders.gov.in/nicgep/app"

REM Arunachal Pradesh Tenders - Port 9248
start "" %CHROME_PATH% --remote-debugging-port=9248 --user-data-dir="%~dp0\chrome_profile_9248" "https://arunachaltenders.gov.in/nicgep/app"

REM Bihar Tenders - Port 9249
start "" %CHROME_PATH% --remote-debugging-port=9249 --user-data-dir="%~dp0\chrome_profile_9249" "https://eproc2.bihar.gov.in/EPSV2Web/"

REM Chhattisgarh Tenders - Port 9250
start "" %CHROME_PATH% --remote-debugging-port=9250 --user-data-dir="%~dp0\chrome_profile_9250" "https://eproc.cgstate.gov.in/CHEPS/security/getSignInAction.do"

REM Jammu & Kashmir Tenders - Port 9251
start "" %CHROME_PATH% --remote-debugging-port=9251 --user-data-dir="%~dp0\chrome_profile_9251" "https://jktenders.gov.in/nicgep/app"

echo ✅ All Chrome instances launched with remote debugging enabled.
pause
