
# nemEDI Business Central Extension – Architecture & Implementation Guide

## 🎯 Purpose
This document summarizes the agreed approach for turning the PoC into a production-ready Business Central (BC) extension that allows nemEDI to reopen sales orders in clients’ BC SaaS environments.

---

## 1. Overall Architecture

### Scope
- **Phase 1:** BC SaaS only (Microsoft-hosted)
- **Phase 2:** Future on-prem support (no code changes needed)

### Core Concept
- A **single `.app` extension**, target = `Cloud`
- Exposes minimal, secure API endpoints that execute BC business logic
- Uses **Microsoft Entra ID (OAuth)** for authentication
- Optionally, nemEDI can add **Azure API Management (APIM)** later for API keys, IP filtering, and rate limiting

### High-Level Flow
```
nemEDI backend → Entra ID (OAuth token) → BC SaaS API → Extension → Business Logic → Response
```

---

## 2. Design Principles

✅ Cloud-first, OnPrem-compatible  
✅ Standard OAuth authentication (no custom headers)  
✅ Minimal API surface for MVP  
✅ Business logic and security separated  
✅ Single `.app` for all clients  
✅ Extensible for APIM or on-prem later  

---

## 3. Authentication & Security Model

### Inside BC (Extension)
- Executes business logic (reopen sales order)
- Performs validation, permission checks, and audit logging
- Uses built-in BC OAuth identity (no custom auth)

### Outside BC (nemEDI Infrastructure)
- Handles API keys, IP allowlisting, rate limiting, and monitoring (via APIM or proxy)
- Manages OAuth token acquisition and refresh
- Provides dashboards and alerting

### Benefits
- Fully SaaS-compliant
- Clean separation of concerns
- Ready for enterprise-scale monitoring later

---

## 4. API Endpoints

| Endpoint | Method | Purpose | Notes |
|-----------|---------|----------|-------|
| `/reopenSalesOrders` | POST | Reopen a single sales order | MVP core endpoint |
| `/health` | GET | Returns version, company name, and connection status | Simple diagnostics |
| `/reopenSalesOrders:batch` | POST | (Future) Reopen multiple orders | Optional later |
| `/salesOrders({id})/status` | GET | (Future) Query status | Optional later |

### API Versioning
- Use `/v1.0/` prefix
- Future breaking changes go to `/v1.1/` (new pages)

---

## 5. AL Implementation Overview

### app.json
```json
{
  "id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "name": "nemEDI Sales Ops",
  "publisher": "nemEDI",
  "version": "1.0.0.0",
  "brief": "API to reopen sales orders via OAuth",
  "target": "Cloud",
  "application": "24.0.0.0",
  "idRanges": [{ "from": 50100, "to": 50149 }]
}
```

### Core Objects

| Object | Type | Purpose |
|--------|------|----------|
| `NemEdi_ReopenSalesOrder` | Codeunit | Wraps BC logic to reopen orders |
| `NemEdi_ReopenSalesOrders` | API Page | Exposes POST endpoint using temp record pattern |
| `NemEdi_Health` | API Page | Returns app version and connection health |
| `NemEdi_Log` | Table | Stores audit trail of all calls |
| `NemEdi_Setup` | Table | Stores config (telemetry, purge days, callback URL) |
| `NemEdi_LogPurge` | Codeunit | Deletes old log entries |
| `NemEdi_Permissions` | Permission Set | Grants access to BC APIs & required objects |

---

## 6. Example AL Stubs

### Health API Page
```al
page 50100 "NemEdi Health"
{
    PageType = API;
    APIPublisher = 'nemedi';
    APIGroup = 'core';
    APIVersion = 'v1.0';
    EntityName = 'health';
    EntitySetName = 'health';
    SourceTable = CompanyInformation;

    layout
    {
        area(content)
        {
            field(version; '1.0.0') { }
            field(companyName; Name) { }
            field(canReadSalesHeader; CanReadSalesHeader()) { }
        }
    }

    local procedure CanReadSalesHeader(): Boolean
    var
        sh: Record "Sales Header";
    begin
        exit(sh.FindFirst());
    end;
}
```

### ReopenSalesOrder API Page (simplified)
```al
page 50101 "NemEdi Reopen Sales Orders"
{
    PageType = API;
    APIPublisher = 'nemedi';
    APIGroup = 'core';
    APIVersion = 'v1.0';
    EntityName = 'reopenSalesOrder';
    EntitySetName = 'reopenSalesOrders';
    SourceTableTemporary = true;
    SourceTable = "NemEdi Reopen Request";

    layout
    {
        area(content)
        {
            field(orderNo; Rec."Order No.") { }
            field(previousStatus; Rec."Previous Status") { }
            field(currentStatus; Rec."Current Status") { }
            field(message; Rec.Message) { }
            field(success; Rec.Success) { }
        }
    }

    trigger OnInsert()
    var
        Reopen: Codeunit "NemEdi Reopen Sales Order";
    begin
        Reopen.Run(Rec);
    end;
}
```

---

## 7. Log Table
```al
table 50102 "NemEdi Log"
{
    fields
    {
        field(1; "Id"; Guid) { }
        field(2; "Order No."; Code[20]) { }
        field(3; "Previous Status"; Text[30]) { }
        field(4; "Current Status"; Text[30]) { }
        field(5; "Result"; Boolean) { }
        field(6; "Message"; Text[250]) { }
        field(7; "Company Id"; Guid) { }
        field(8; "Correlation Id"; Text[100]) { }
        field(9; "Created At"; DateTime) { }
    }
}
```

---

## 8. Permission Set (Example)
```al
permissionset 50103 "NemEdi API RW"
{
    Assignable = true;
    Permissions =
        tabledata "Sales Header" = RIMD,
        codeunit "NemEdi Reopen Sales Order" = X,
        page "NemEdi Reopen Sales Orders" = X,
        tabledata "NemEdi Log" = RIMD;
}
```

---

## 9. Client Onboarding Steps
1. **Install Extension** (AppSource or direct upload)  
2. **Create Service Principal** (Entra ID app registration)  
3. **Grant API Permissions** to BC for that app  
4. **Assign Permission Set** to nemEDI app user in BC  
5. **Share Tenant ID + Environment Name** with nemEDI  
6. **nemEDI Tests** `/health` and `/reopenSalesOrders` endpoints  

---

## 10. Future Enhancements
- Batch reopen endpoint (`POST /reopenSalesOrders:batch`)
- Webhook callback after successful operations
- Application Insights telemetry (optional)
- On-prem connectivity via APIM proxy

---

## 11. Summary Checklist
✅ Single Cloud-targeted .app file  
✅ OAuth authentication (no custom headers)  
✅ Minimal endpoints: `/health`, `/reopenSalesOrders`  
✅ Log + purge + config tables  
✅ Permission set scoped to sales ops only  
✅ Ready for APIM integration later  
✅ No SaaS-specific dependencies  

---

## 12. Next Steps
1. Finalize AL objects and naming  
2. Test in BC sandbox with real OAuth token  
3. Write short client setup guide (consent + app-user + permissions)  
4. Optional: Add telemetry + correlation ID support  
5. Package for AppSource or direct distribution  

---

**Author:** Martin Rud  
**Project:** nemEDI Sales Order Reopen API  
**Version:** 1.0.0  
**Date:** 2025-10-07
