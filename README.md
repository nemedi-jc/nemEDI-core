# 🔄 Nemedi Sales Order API - nemEDI Core

Welcome to the **Nemedi Sales Order Reopen API** project - a complete Business Central AL extension that provides REST API endpoints for sales order operations.

---

## 🎯 Project Overview

This project provides a production-ready Sales Order API for Business Central with:

✅ **Sales Order Reopen API**: `POST /api/nemedi/core/v1.0/companies(<companyId>)/reopenSalesOrders`  
✅ **Complete Azure infrastructure setup**  
✅ **Clean, refactored architecture with DRY principles**  
✅ **Organized folder structure for scalability**  
✅ **Ready for testing and integration**  

---

## 📚 Documentation

| Document | Description |
|----------|-------------|
| **[API Reference](docs/api-reference.md)** | Complete API documentation, testing instructions, and troubleshooting |
| **[Build Guide](docs/build-guide.md)** | How to build the extension into a deployable .app file |
| **[Infrastructure Setup](docs/infrastructure-setup.md)** | Step-by-step guide to set up Business Central on Azure |
| **[VM Management](docs/vm-management.md)** | How to start/stop your Azure VM to minimize costs |
| **[Project Summary](docs/project-summary.md)** | Complete development history and architecture documentation |
| **[Client Installation Guide (English)](docs/client-email-template-en.md)** | Installation guide for Business Central customers |
| **[Client Installation Guide (Danish)](docs/client-email-template-da.md)** | Installationsguide til Business Central kunder |
| **[Security Guidelines](SECURITY.md)** | Security configuration and credential management |

---

## 🚀 Quick Start

### For API Users
1. Read the **[API Reference](docs/api-reference.md)** for endpoint details and testing
2. Contact the administrator for authentication credentials (see **[Security Guidelines](SECURITY.md)**)
3. Test with: `POST http://[YOUR-DEV-SERVER]:7048/BC/api/nemedi/core/v1.0/companies(<companyId>)/reopenSalesOrders`

> **🧪 Development Environment Note:** This project includes setup instructions for a sandbox/test Business Central environment suitable for development and testing purposes.

### For Developers  
1. Follow the **[Infrastructure Setup](docs/infrastructure-setup.md)** to deploy to Azure
2. Use **[VM Management](docs/vm-management.md)** to control costs
3. Connect VS Code using the provided `launch.json` configuration
4. Build the extension using the **[Build Guide](docs/build-guide.md)**

### For Building and Deployment
1. **Download Symbols:** `AL: Download Symbols` (Ctrl+Shift+P)
2. **Build Extension:** `AL: Package` (Ctrl+Shift+P) 
3. **Deploy:** `AL: Publish` (Ctrl+F5)
4. **Assign Permissions:** Add `NEMEDIAPIRWM` *(Nemedi API R/W (Sales))* to API users
5. **Complete guide:** See **[Build Guide](docs/build-guide.md)** for detailed instructions

### For Business Central Customers
1. **English**: Follow the **[Client Installation Guide](docs/client-email-template-en.md)** to install the extension
2. **Danish**: Følg **[installationsguiden](docs/client-email-template-da.md)** for at installere udvidelsen

---

## 📁 Project Structure

```
├── src/                              # Organized source code
│   ├── api/
│   │   └── sales/
│   │       └── NemediReopenSOAPI.al    # Sales Order Reopen API (ID 50120)
│   ├── codeunits/
│   │   └── sales/
│   │       └── NemediSalesOps.al       # Business logic for sales operations
│   ├── tables/
│   │   └── requests/
│   │       └── NemediReopenSORequest.al # API request/response structure
│   └── permissions/
│       └── NemediPermissions.al        # Permission set (ID 50111)
├── docs/                             # Documentation
│   ├── api-reference.md
│   ├── infrastructure-setup.md
│   ├── vm-management.md
│   ├── project-summary.md
│   ├── client-email-template-en.md
│   └── client-email-template-da.md
└── app.json                          # AL project configuration
```

---

## 🔐 Authentication

- **Username:** [Contact administrator]
- **Password:** [Contact administrator]  
- **Authorization:** [Will be provided upon request]

> **🔒 Security Note:** Credentials are not stored in this repository for security reasons. Contact the system administrator to obtain access credentials for the development environment. See **[Security Guidelines](SECURITY.md)** for more information.

---

## 🌍 Environment

- **Web Client:** `http://[DEV-SERVER]/BC`
- **API Base:** `http://[DEV-SERVER]:7048/BC/api/`
- **Development:** Port 7049 (VS Code connection)

> **🧪 Development/Sandbox Environment:** This setup is designed for development and testing purposes. Server details are provided separately for security reasons. See **[Security Guidelines](SECURITY.md)** for credential management.

---

## ✅ Current Status

| Component | Status |
|-----------|---------|
| AL Extension | ✅ Compiled & Published |
| Azure VM | ✅ Running BC v27 |
| Sales Order Reopen API | ✅ Responding |
| External Access | ✅ Ports configured |
| Documentation | ✅ Complete |
| Code Architecture | ✅ Refactored & Organized |

---

## 🏗️ Architecture Highlights

- **🔄 DRY Principles**: Centralized error handling and validation
- **📂 Organized Structure**: Domain-driven folder organization
- **🧪 Testable**: Clean separation of concerns
- **📈 Scalable**: Ready for additional API endpoints
- **🔒 Secure**: Proper permission management

---

**Author:** Martin Rud  
**Last Updated:** October 2025