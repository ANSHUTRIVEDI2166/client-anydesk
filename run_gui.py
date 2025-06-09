import tkinter as tk
from tkinter import messagebox
import subprocess

def start_script():
    keyword = entry_keyword.get().strip()
    tender_count = entry_count.get().strip()

    if not keyword:
        messagebox.showerror("Error", "Please enter a search keyword.")
        return

    if not tender_count.isdigit() or int(tender_count) < 1:
        messagebox.showerror("Error", "Please enter a valid number of tenders to scrape.")
        return

    with open("search_keywords.txt", "w") as f:
        for port in [9222, 9223, 9224, 9225, 9226]:
            f.write(f"{port}:{keyword}\n")

    with open("tender_count.txt", "w") as f:
        f.write(tender_count)

    messagebox.showinfo("Starting", "Starting scraping script...")
    subprocess.Popen(["start", "runme.bat"], shell=True)

root = tk.Tk()
root.title("Tender Scraper Launcher")
root.configure(bg="#f0f4f7")
root.geometry("500x250")

title_label = tk.Label(root, text="🚀 Tender Scraper Launcher", font=("Helvetica", 16, "bold"), bg="#f0f4f7", fg="#333")
title_label.pack(pady=10)

frame = tk.Frame(root, bg="#f0f4f7")
frame.pack(pady=10)

tk.Label(frame, text="🔎 Enter search keyword (for all sites):", font=("Helvetica", 11), bg="#f0f4f7").grid(row=0, column=0, sticky="e", pady=5)
entry_keyword = tk.Entry(frame, width=40, font=("Helvetica", 10))
entry_keyword.grid(row=0, column=1, padx=10, pady=5)

tk.Label(frame, text="📄 Number of tenders to scrape per state:", font=("Helvetica", 11), bg="#f0f4f7").grid(row=1, column=0, sticky="e", pady=5)
entry_count = tk.Entry(frame, width=20, font=("Helvetica", 10))
entry_count.grid(row=1, column=1, padx=10, pady=5, sticky="w")

start_button = tk.Button(root, text="✅ Start Scraping", font=("Helvetica", 12, "bold"), bg="#4CAF50", fg="white", command=start_script)
start_button.pack(pady=15)

root.mainloop()
