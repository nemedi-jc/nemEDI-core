# Phase 1 – Test kundespecifik Entra-app (OAuth token) mod BC Cloud API

## 🎯 Formål
At verificere, at en kundes egen Microsoft Entra-app (single-tenant) kan hente et OAuth token og kalde Business Central Cloud via extensionens API-endpoint (fx `/reopenSalesOrders`).  
Dette svarer til den ønskede produktionsmodel, hvor nemEDI backend kun behøver kundens tenantId, clientId og clientSecret for at tilgå BC-API’et.

---

## ✅ Subtasks

### A) Forbered kundens Entra-app (single-tenant)
- [ ] Log ind i kundens Entra (konto `nemedi@martinrud.dk`)
- [ ] Opret App Registration → *New registration*
- [ ] Sæt *Supported account types* = **My organization only**
- [ ] Notér **Application (Client) ID** og **Directory (Tenant) ID**
- [ ] Under *Certificates & secrets* → Opret *New client secret*
- [ ] Tjek API Permissions (kan stå tomt)

### B) Opret Application User i kundens Business Central
- [ ] Sørg for, at du kan oprette Application Users (kræver GA eller D365 Admin)
- [ ] BC → Users → New
- [ ] Sæt *User Type = Application*
- [ ] Indsæt *Client ID* fra app’en
- [ ] State = Enabled
- [ ] Tildel *Permission Sets = SUPER*
- [ ] Notér *Environment name* og *Company ID*

### C) Hent token fra kundens Entra (client credentials flow)
- [ ] Hent token i Postman eller cURL
- [ ] Test respons for `access_token`

### D) Kald Business Central API
- [ ] GET /companies for at finde Company ID
- [ ] GET /health endpoint (extension)
- [ ] POST /reopenSalesOrders endpoint
- [ ] Bekræft svar (success/failure)

### E) Verificér og dokumentér
- [ ] Kontrollér BC logtabel / telemetry
- [ ] Notér succes i ClickUp (kommentar + skærmbillede)
- [ ] Gem JSON-eksempler i Postman collection

---

## 📋 Hurtig checkliste
- [ ] A) App i kundens Entra oprettet
- [ ] B) Application User oprettet i BC
- [ ] C) Token hentet
- [ ] D) API-kald testet
- [ ] E) Resultat verificeret og dokumenteret
