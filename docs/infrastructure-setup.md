# Infrastructure Setup: From Scratch to Production API

This guide walks you through setting up a complete Business Central environment on Azure with API access.

---

## 1️⃣ Create Azure VM

| Setting           | Value                                                    |
| ----------------- | -------------------------------------------------------- |
| **Region**        | West Europe                                              |
| **Image**         | Windows Server 2022 Datacenter: Azure Edition Hotpatch |
| **Size**          | B4ms (4 vCPU / 16 GB RAM) during installation, later B2ms |
| **Login**         | [ADMIN_USERNAME] / [SECURE_PASSWORD]                    |
| **Inbound ports** | 3389 (RDP), 80 (HTTP)                                   |
| **Auto-shutdown** | e.g., 23:00                                              |

> **🧪 Development/Sandbox Setup:** This guide sets up a development and testing environment. Use strong, unique credentials for your setup.

---

## 2️⃣ Install Docker and BcContainerHelper

```powershell
Install-WindowsFeature -Name Containers
Restart-Computer

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name DockerMsftProvider -Repository PSGallery -Force
Install-Package -Name docker -ProviderName DockerMsftProvider -Force -Verbose
Restart-Computer

Start-Service docker
Install-Module BcContainerHelper -Scope AllUsers -Force
```

---

## 3️⃣ Create Business Central Container (with API ports)

```powershell
$artifact = Get-BcArtifactUrl -type 'OnPrem' -country 'dk' -select 'Latest' -version '27.0'
$sec  = ConvertTo-SecureString '[YOUR_SECURE_PASSWORD]' -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ('[YOUR_USERNAME]', $sec)

New-BcContainer -accept_eula `
  -containerName 'bc27dk' `
  -artifactUrl $artifact `
  -auth UserPassword `
  -Credential $cred `
  -additionalParameters @(
    "--publish 80:80",      # Web Client
    "--publish 7048:7048",  # API / OData
    "--publish 7049:7049",  # Dev Service
    "--publish 8080:8080"   # VSIX download
  ) `
  -updateHosts
```

👉 Initial setup takes 15–25 minutes (creates database and service-tier).

---

## 4️⃣ Enable API/OData and Set Public URLs

```powershell
$public = "http://[YOUR_SERVER_PUBLIC_IP]"
Set-BcContainerServerConfiguration -ContainerName bc27dk -Settings @{
  ODataServicesEnabled = "true"
  ApiServicesEnabled   = "true"
  ODataServicesPort    = "7048"
  PublicWebBaseUrl     = "$public/BC/"
  PublicODataBaseUrl   = "$public/BC/ODataV4/"
}

Invoke-ScriptInBcContainer -ContainerName bc27dk -ScriptBlock {
    Restart-NAVServerInstance -ServerInstance BC -Force
}
```

---

## 5️⃣ Open Firewall and Azure Ports

### Windows Firewall (in VM)

```powershell
New-NetFirewallRule -DisplayName "BC HTTP 80"    -Direction Inbound -Protocol TCP -LocalPort 80   -Action Allow
New-NetFirewallRule -DisplayName "BC ODATA 7048" -Direction Inbound -Protocol TCP -LocalPort 7048 -Action Allow
New-NetFirewallRule -DisplayName "BC DEV 7049"   -Direction Inbound -Protocol TCP -LocalPort 7049 -Action Allow
New-NetFirewallRule -DisplayName "BC VSIX 8080"  -Direction Inbound -Protocol TCP -LocalPort 8080 -Action Allow
```

### Azure Network Security Group (NSG)

| Name       | Port | Protocol | Action | Priority |
| ---------- | ---- | -------- | ------ | -------- |
| HTTP_80    | 80   | TCP      | Allow  | 320      |
| OData_7048 | 7048 | TCP      | Allow  | 321      |
| Dev_7049   | 7049 | TCP      | Allow  | 322      |
| VSIX_8080  | 8080 | TCP      | Allow  | 323      |

---

## 6️⃣ Verify Configuration

```powershell
Get-BcContainerServerConfiguration -ContainerName bc27dk |
  Select ApiServicesEnabled, ODataServicesEnabled, ODataServicesPort, PublicWebBaseUrl, PublicODataBaseUrl

docker ps
```

---

## 7️⃣ Test Internal Connection

```powershell
Test-NetConnection -ComputerName localhost -Port 7048
```

## 8️⃣ Test External Connection (from your own PC)

```powershell
Test-NetConnection -ComputerName [YOUR_SERVER_PUBLIC_IP] -Port 7048
```

---

## 9️⃣ Connect from VS Code

`.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "BC27 Azure VM",
      "type": "al",
      "request": "launch",
      "environmentType": "OnPrem",
      "server": "http://[YOUR_SERVER_IP]",
      "serverInstance": "BC",
      "authentication": "UserPassword",
      "startupObjectType": "Page",
      "startupObjectId": 22
    }
  ]
}
```

> **🔒 Security Note:** Add this launch.json to your local .vscode folder only. It's automatically ignored by Git to prevent credential exposure.

Then run:
```
AL: Download Symbols
```

---

## 🔧 Troubleshooting

| Error                  | Cause                                         | Solution                                  |
| ---------------------- | --------------------------------------------- | ----------------------------------------- |
| Timeout on 7048        | Port closed in NSG/firewall                  | Open TCP 7048 in both VM and Azure       |
| 401 Unauthorized       | Wrong Basic auth                              | Check credentials with administrator      |
| 404 on /BC/api         | APIs run on port 7048, not 80                | Use 7048                                  |
| 404 on custom API      | Wrong URL or extension not installed         | Check APIPublisher/APIGroup/Version       |

---

## ✅ Result

You now have:

- A fully functional Business Central 27.0 OnPrem container for **development/testing**
- Web access: `http://[YOUR_SERVER]/BC`
- API access: `http://[YOUR_SERVER]:7048/BC/api/...`
- VS Code connection via port 7049
- Your custom Sales Order Reopen API (`nemedi/core/v1.0/reopenSalesOrders`) ready for integration

> **🧪 Development Environment:** This setup is intended for development and testing purposes. For production deployments, implement additional security measures, HTTPS, and proper authentication mechanisms.