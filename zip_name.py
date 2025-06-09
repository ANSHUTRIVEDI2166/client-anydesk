from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
import json
import os
import pandas as pd

# Port to Folder mapping
PORT_FOLDER_MAP = {
    9222: r"C:\Users\Admin\rajasthan",
    9223: r"C:\Users\Admin\maharashtra",
    9224: r"C:\Users\Admin\andaman",
    9225: r"C:\Users\Admin\west bengal",
    9226: r"C:\Users\Admin\tamilnadu"
}

def save_data(tenders_data, output_folder, port):
    # Save JSON
    json_path = os.path.join(output_folder, f"tenders_{port}.json")
    with open(json_path, "w", encoding="utf-8") as f:
        json.dump(tenders_data, f, indent=2, ensure_ascii=False)
    print(f"📝 JSON saved to {json_path}")

    # Save Excel
    df = pd.DataFrame(tenders_data)
    df = df[["Title and Tender ID", "Published Date", "Submission Closing Date", "Opening Date", "Organisation Chain", "ZIP File Path"]]
    excel_path = os.path.join(output_folder, f"tenders_{port}.xlsx")
    df.to_excel(excel_path, index=False)
    print(f"📊 Excel saved to {excel_path}")

def scrape_tenders(port, search_term, max_tenders=20):
    print(f"\n🔌 Connecting to Chrome on port {port}...")
    options = Options()
    options.debugger_address = f"localhost:{port}"
    driver = webdriver.Chrome(options=options)
    wait = WebDriverWait(driver, 15)

    print(f"✅ Connected to Chrome on port {port}.")

    # Enter search term and click Go
    search_input = wait.until(EC.presence_of_element_located((By.ID, "SearchDescription")))
    search_input.clear()
    search_input.send_keys(search_term)
    driver.find_element(By.ID, "Go").click()

    wait.until(EC.presence_of_element_located((By.ID, "table")))
    time.sleep(1)
    print(f"📄 Results loaded. Starting scrape...")

    tenders_data = []
    output_folder = PORT_FOLDER_MAP.get(port)
    os.makedirs(output_folder, exist_ok=True)

    current_page = 1
    tenders_scraped = 0

    while tenders_scraped < max_tenders:
        print(f"\n📄 Scraping page {current_page}...")

        # Get tender rows on current page
        tender_rows = wait.until(EC.presence_of_all_elements_located(
            (By.XPATH, '//table[@id="table"]//tr[td/a[@title="View Tender Information"]]')))

        total_rows = len(tender_rows)
        if total_rows == 0:
            print(f"⚠️ No tenders found on page {current_page}. Ending scrape.")
            break

        # Calculate how many tenders to scrape this page
        tenders_to_scrape = min(max_tenders - tenders_scraped, total_rows)

        for i in range(tenders_to_scrape):
            try:
                print(f"🔍 Scraping tender {tenders_scraped + 1} (index {i}) on page {current_page}...")

                # Refresh rows to avoid stale elements
                tender_rows = driver.find_elements(By.XPATH, '//table[@id="table"]//tr[td/a[@title="View Tender Information"]]')
                row = tender_rows[i]
                cols = row.find_elements(By.TAG_NAME, "td")

                tender = {
                    "Published Date": cols[1].text.strip() or "N/A",
                    "Submission Closing Date": cols[2].text.strip() or "N/A",
                    "Opening Date": cols[3].text.strip() or "N/A",
                    "Title and Tender ID": cols[4].text.strip() or "N/A",
                    "Organisation Chain": cols[5].text.strip() or "N/A",
                    "ZIP File Path": "ZIP not found"  # default
                }

                tender_link = cols[4].find_element(By.TAG_NAME, "a")
                driver.execute_script("arguments[0].scrollIntoView(true);", tender_link)
                time.sleep(0.5)
                tender_link.click()

                wait.until(EC.presence_of_element_located((By.CLASS_NAME, "tablebg")))

                try:
                    zip_link = wait.until(EC.element_to_be_clickable((By.ID, "DirectLink_7")))
                    zip_link.click()
                    print(f"[{port}] 📦 ZIP download clicked.")
                    time.sleep(4)  # Wait for download to finish
                except Exception as e:
                    print(f"[{port}] ❌ ZIP download failed: {e}")

                # Assign ZIP file path
                zip_files = [f for f in os.listdir(output_folder) if f.lower().endswith(".zip")]
                assigned_zips = [t.get("ZIP File Path", "") for t in tenders_data if t.get("ZIP File Path", "") != "ZIP not found"]
                available_zips = [z for z in zip_files if os.path.join(output_folder, z) not in assigned_zips]

                if available_zips:
                    zip_path = os.path.join(output_folder, available_zips[0])
                    tender["ZIP File Path"] = zip_path
                else:
                    tender["ZIP File Path"] = "ZIP not found"

                tenders_data.append(tender)
                tenders_scraped += 1

                # Save after each tender
                save_data(tenders_data, output_folder, port)

                back_btn = wait.until(EC.element_to_be_clickable((By.ID, "DirectLink_11")))
                back_btn.click()
                wait.until(EC.presence_of_element_located((By.ID, "table")))

            except Exception as e:
                print(f"⚠️ Error scraping tender {tenders_scraped + 1}: {e}")
                continue

            if tenders_scraped >= max_tenders:
                break

        # Go to next page if needed
        current_page += 1
        if tenders_scraped < max_tenders:
            try:
                page_link = driver.find_element(By.XPATH, f'//a[contains(@href, "sp={current_page}")]')
                driver.execute_script("arguments[0].click();", page_link)
                wait.until(EC.presence_of_element_located((By.ID, "table")))
                time.sleep(1)
            except Exception as e:
                print(f"❌ Couldn’t go to page {current_page}: {e}")
                break

    driver.quit()
    print(f"✅ Done scraping {tenders_scraped} tenders from port {port}.\n")

if __name__ == "__main__":
    try:
        with open("search_keywords.txt", "r") as f:
            search_map = {
                int(line.split(":")[0].strip()): line.split(":")[1].strip()
                for line in f if ":" in line
            }
    except Exception as e:
        print(f"❌ Failed to read search keywords: {e}")
        exit(1)

    # Read tender count from file instead of user input
    try:
        with open("tender_count.txt", "r") as f:
            tender_count_str = f.read().strip()
            max_tenders = int(tender_count_str)
            if max_tenders <= 0:
                raise ValueError
    except Exception as e:
        print(f"⚠️ Failed to read tender count from file or invalid value: {e}")
        print("⚠️ Using default of 10 tenders per port.")
        max_tenders = 10

    for port in [9222, 9223, 9224, 9225, 9226]:
        try:
            search_term = search_map.get(port, "")
            if not search_term:
                print(f"⚠️ Skipping port {port} — no keyword provided.")
                continue
            print(f"\n🔍 Searching on port {port} with keyword: {search_term}")
            scrape_tenders(port, search_term, max_tenders=max_tenders)
            print("⏳ Waiting before next port...")
            time.sleep(5)
        except Exception as e:
            print(f"❌ Skipped port {port} due to error: {e}")
