# Azure VM Management: Start & Stop Routine

## 🎯 Purpose

Minimize Azure costs and ensure your Business Central container starts correctly when you reopen your VM.

---

## 💸 1️⃣ Stop VM Correctly (to avoid unnecessary charges)

You **must stop via Azure Portal**, not just close Windows.

### How to do it:

1. Go to [Azure Portal → Virtual Machines → bc27dk](https://portal.azure.com/#view/HubsExtension/BrowseResource/resourceType/Microsoft.Compute%2FVirtualMachines)
2. Click **Stop**
3. Wait until status shows:  
   `Stopped (deallocated)`

✅ Now you pay **only for the disk (approx. 10–15 kr/month)**  
💸 CPU/RAM costs stop completely.

---

## 🚀 2️⃣ Start VM Again

When you need to develop again:

1. Go to Azure Portal → your VM → **Start**
2. Wait until status shows **Running**
3. Connect via **RDP** (Remote Desktop)
4. Run these commands in **PowerShell (Administrator)**:

```powershell
Start-Service docker
docker start bc27dk
```

After 1–2 minutes you can open:

```
http://<public-ip>/BC
http://<public-ip>:7048/BC/api/v2.0/companies
```

---

## 🧩 3️⃣ Automatic Start (Optional)

If you want to avoid starting the container manually each time, you can make it automatic:

### 🔹 A. Startup Script

1. Create the file: `C:\start-bc.ps1`
   ```powershell
   Start-Service docker
   docker start bc27dk
   ```
2. Create a shortcut to the script in:
   ```
   C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp
   ```
3. Right-click → **Properties → Advanced → Run as administrator**

➡️ Now your BC container starts automatically when you log in.

---

### 🔹 B. Task Scheduler (Better, doesn't require login)

1. Open **Task Scheduler**
2. Click **Create Task**
3. Settings:
   - **Trigger:** At startup
   - **Action:** Start a program → `powershell.exe`
   - **Arguments:**
     ```
     -ExecutionPolicy Bypass -File "C:\start-bc.ps1"
     ```
   - **Run with highest privileges**

✅ The container starts automatically as soon as the VM boots, without needing to log on.

---

## 🧠 4️⃣ Quick Status Check

See if container is running:

```powershell
docker ps
```

Stop it manually (before shutting down VM):

```powershell
docker stop bc27dk
```

---

## 🧾 5️⃣ Quick Overview

| Action          | Command / Location    | Payment?                |
| --------------- | --------------------- | ----------------------- |
| Stop container  | `docker stop bc27dk`  | –                       |
| Stop VM correct| Azure Portal → Stop   | ❌ No CPU cost          |
| Start VM again  | Azure Portal → Start  | ✅ Starts resources     |
| Start container | `docker start bc27dk` | –                       |

---

## ✅ Result

- Pay **only for disk** when VM is shut down
- Keep everything (Docker + BC container + API)
- Can restart in just a few minutes