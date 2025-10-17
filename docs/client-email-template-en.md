# 🧩 Installing nemEDI Core in Business Central

This guide shows how to install the *nemEDI Core* module in your Business Central solution.  
The module enables nemEDI to reopen sales orders via API — using the exact same login and security you already use today.

---

## 🔹 Step 1 – Upload and install the module
1. Go to **Business Central**  
   👉 [https://businesscentral.dynamics.com/](https://businesscentral.dynamics.com/)  
2. Go to **Search** (magnifying glass) → type **Extension Management**.  
3. Click **Manage → Upload Extension**.  
4. Select the file `nemEDI_nemEDI Core_1.0.0.0.app` (which you received from nemEDI).  
5. Select **Install** and wait until the status shows *Installed*.

---

## 🔹 Step 2 – Assign permissions
1. Go to **Users**.  
2. Find the **Application User** that is linked to your existing *Entra App* (used for nemEDI's API access).  
3. Open the user and add the following permission set:  
   ✅ **nemEDI CORE – Reopen Sales Orders**  
   (This permission set is automatically included with the module.)  

---

## 🔹 For the technically inclined
The module adds a secure API endpoint in your Business Central that nemEDI's system can call to automatically reopen sales orders.  
This happens using your existing OAuth token and with BC's own validation rules.