# 🌐 Windows NetSwitch

A simple and lightweight Batch script to quickly block or restore internet access on Windows using the built-in Windows Firewall.

---

## 🚀 Key Features
*   **Instant Toggle:** Block or restore all network traffic via a simple menu.
*   **Admin Check:** Automatically verifies if the script is running with the necessary Administrator privileges.
*   **Visual Status:** Uses ANSI color codes (Red/Green) to show the current network state at a glance.
*   **Full Isolation:** Creates rules for both **Inbound** and **Outbound** connections.

## 🛠 How to Use
1.  **Download** the `InternetControl.bat` file.
2.  **Right-click** the file and select **"Run as Administrator"** (required to modify Firewall rules).
3.  **Choose an option** from the menu:
    *   `1` — **Block** Internet.
    *   `2` — **Restore** Internet.
    *   `3` — **Exit**.

## ⚠️ Important Notes
*   **Local Network:** Blocking "All" traffic may also disconnect you from local devices like printers or shared folders.
*   **Compatibility:** Optimized for **Windows 10 and 11** to support ANSI console colors.
*   **Safety:** The script only manages the specific rules it creates and won't affect your existing firewall settings.
