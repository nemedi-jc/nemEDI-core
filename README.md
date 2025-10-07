# 🔄 Nemedi Sales Order API - ALProject3

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
| **[Infrastructure Setup](docs/infrastructure-setup.md)** | Step-by-step guide to set up Business Central on Azure |
| **[VM Management](docs/vm-management.md)** | How to start/stop your Azure VM to minimize costs |

---

## 🚀 Quick Start

### For API Users
1. Read the **[API Reference](docs/api-reference.md)** for endpoint details and testing
2. Use the provided authentication: `admin / P@ssw0rd!`
3. Test with: `POST http://135.225.91.78:7048/BC/api/nemedi/core/v1.0/companies(<companyId>)/reopenSalesOrders`

### For Developers  
1. Follow the **[Infrastructure Setup](docs/infrastructure-setup.md)** to deploy to Azure
2. Use **[VM Management](docs/vm-management.md)** to control costs
3. Connect VS Code using the provided `launch.json` configuration

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
│   ├── api-reference.md              # API usage guide
│   ├── infrastructure-setup.md       # Azure deployment guide
    └── vm-management.md              # Cost optimization guide
└── app.json                          # AL project configuration
```

---

## 🔐 Authentication

- **Username:** `admin`
- **Password:** `P@ssw0rd!`  
- **Authorization:** `Basic YWRtaW46UEBzc3cwcmQh`

---

## 🌍 Environment

- **Web Client:** `http://135.225.91.78/BC`
- **API Base:** `http://135.225.91.78:7048/BC/api/`
- **Development:** Port 7049 (VS Code connection)

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