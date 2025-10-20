# Nemedi Sales Order Reopen API

## Overview
This AL extension provides a REST API for reopening sales orders in Business Central. The API allows external systems to safely reopen released sales orders using standard BC business logic.

**API Endpoint:**
```
POST /api/nemedi/core/v1.0/companies(<companyId>)/reopenSalesOrders
```

## API Configuration
- **PageType:** API
- **APIPublisher:** nemedi
- **APIGroup:** core
- **APIVersion:** v1.0
- **EntityName:** reopenSalesOrder
- **EntitySetName:** reopenSalesOrders
- **Method:** POST
- **Source:** Temporary table for request/response

## Request/Response Structure

### Request Body
```json
{
  "orderNo": "SO012345"
}
```

### Response Body
```json
{
  "id": "guid-auto-generated",
  "orderNo": "SO012345",
  "success": true,
  "message": "Sales order reopened successfully.",
  "previousStatus": "Released",
  "currentStatus": "Open"
}
```

### Response Fields
- **id** - Auto-generated unique identifier for the request
- **orderNo** - Sales order number that was processed
- **success** - Boolean indicating if the operation succeeded
- **message** - Descriptive message about the operation result
- **previousStatus** - Status of the sales order before the operation
- **currentStatus** - Status of the sales order after the operation

## Testing Instructions

> **🧪 Development Environment:** These examples are for development/sandbox testing. Contact administrator for actual credentials.

### Step 1: Get Company ID
**Request:**
```http
GET http://[YOUR-DEV-SERVER]:7048/BC/api/v2.0/companies
Authorization: Basic [YOUR-BASIC-AUTH-HEADER]
Accept: application/json
```

> **Security Note:** Replace `[YOUR-DEV-SERVER]` with your actual development server address and `[YOUR-BASIC-AUTH-HEADER]` with your Base64 encoded credentials.

**Expected Response:**
```json
{
  "value": [
    {
      "id": "your-company-id-guid-here",
      "name": "CRONUS DK A/S",
      "displayName": "CRONUS DK A/S"
    }
  ]
}
```

### Step 2: Test Sales Order Reopen API
**Request:**
```http
POST http://[YOUR-DEV-SERVER]:7048/BC/api/nemedi/core/v1.0/companies(your-company-id-guid-here)/reopenSalesOrders
Authorization: Basic [YOUR-BASIC-AUTH-HEADER]
Content-Type: application/json
Accept: application/json

{
  "orderNo": "SO012345"
}
```

**Success Response:**
```json
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "orderNo": "SO012345",
  "success": true,
  "message": "Sales order reopened successfully.",
  "previousStatus": "Released",
  "currentStatus": "Open"
}
```

**Error Response (Order Not Found):**
```json
{
  "id": "123e4567-e89b-12d3-a456-426614174001",
  "orderNo": "SO999999",
  "success": false,
  "message": "Sales order SO999999 not found.",
  "previousStatus": "",
  "currentStatus": ""
}
```

**Info Response (Already Open):**
```json
{
  "id": "123e4567-e89b-12d3-a456-426614174002",
  "orderNo": "SO012345",
  "success": true,
  "message": "Sales order already Open.",
  "previousStatus": "Open",
  "currentStatus": "Open"
}
```

### Postman Collection Settings
1. **Method:** POST
2. **Authorization Tab:**
   - Type: Basic Auth
   - Username: `[PROVIDED_BY_ADMIN]`
   - Password: `[PROVIDED_BY_ADMIN]`
3. **Headers:**
   - `Accept: application/json`
   - `Content-Type: application/json`
4. **Body (raw JSON):**
   ```json
   {
     "orderNo": "SO012345"
   }
   ```

> **🧪 Dev Environment:** Contact administrator for development server credentials.

### cURL Examples
**Get Companies:**
```bash
curl -X GET "http://[YOUR-DEV-SERVER]:7048/BC/api/v2.0/companies" \
  -H "Authorization: Basic [YOUR-BASIC-AUTH-HEADER]" \
  -H "Accept: application/json"
```

**Reopen Sales Order:**
```bash
curl -X POST "http://[YOUR-DEV-SERVER]:7048/BC/api/nemedi/core/v1.0/companies(your-company-id)/reopenSalesOrders" \
  -H "Authorization: Basic [YOUR-BASIC-AUTH-HEADER]" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{"orderNo": "SO012345"}'
```

## Business Logic & Validation

### Order Number Validation
- **Required Field**: `orderNo` cannot be empty
- **Format**: Standard BC sales order number format
- **Case Sensitivity**: Exact match required

### Sales Order Status Handling
The API handles different sales order statuses intelligently:

| Current Status | Action | Result |
|----------------|--------|---------|
| **Open** | No action needed | Returns success with info message |
| **Released** | Calls BC Reopen function | Changes to Open status |
| **Other statuses** | Attempts reopen | May succeed or fail based on BC rules |

### Error Scenarios
| Scenario | HTTP Status | Success Field | Message |
|----------|-------------|---------------|---------|
| Order not found | 200 | false | "Sales order {orderNo} not found." |
| Missing orderNo | 200 | false | "Missing orderNo parameter." |
| Already open | 200 | true | "Sales order already Open." |
| Reopen successful | 200 | true | "Sales order reopened successfully." |
| Reopen failed | 200 | false | "Could not reopen sales order. Current status: {status}" |

## Troubleshooting

### Common Issues

**401 Unauthorized**
- ✅ Verify Basic Auth credentials with administrator-provided values
- ✅ Check if user has necessary permissions (assign `NemediApiRWM` permission set)

**404 Not Found**
- ✅ Ensure AL extension is published successfully
- ✅ Verify API URL structure and spelling of APIPublisher/APIGroup/APIVersion
- ✅ Check company ID is correct (use the GUID from companies endpoint)
- ✅ Confirm endpoint path: `/reopenSalesOrders` (not `/customers`)

**Connection Timeout**
- ✅ Verify port 7048 is published in Docker container: `docker run -p 7048:7048`
- ✅ Check Azure Network Security Group (NSG) allows inbound traffic on port 7048
- ✅ Verify Windows Firewall on Azure VM allows port 7048
- ✅ Test internal connectivity: `telnet [YOUR-DEV-SERVER] 7048`

**Invalid Request Format**
- ✅ Ensure Content-Type is `application/json`
- ✅ Verify JSON body contains `orderNo` field
- ✅ Check for proper JSON syntax (quotes, brackets, etc.)

**500 Internal Server Error**
- ✅ Check BC Event Log for detailed error messages
- ✅ Verify AL extension compiled without warnings
- ✅ Test API page directly in BC web client first

## Permission Management
The extension includes the `NemediApiRWM` permission set (ID: 50111) which provides:
- Read/Modify access to Sales Header table
- Read/Insert/Modify/Delete access to request table
- Execute access to Release Sales Document codeunit
- Execute access to business logic codeunit
- Execute access to the API page

Assign this permission set to users who need API access without giving full SUPER permissions.

## Architecture Overview

### File Structure
```
src/
├── api/sales/
│   └── NemediReopenSOAPI.al          # REST API endpoint
├── codeunits/sales/
│   └── NemediSalesOps.al             # Business logic
├── tables/requests/
│   └── NemediReopenSORequest.al      # Data structure
└── permissions/
    └── NemediPermissions.al          # Security
```

### Code Features
- **DRY Principles**: Centralized error messages and validation
- **Separation of Concerns**: API, business logic, and data layers
- **Testable Architecture**: Isolated business logic methods
- **Enterprise Patterns**: Standard AL development practices

## Installation Steps
1. Download symbols: `AL: Download Symbols`
2. Build extension: `AL: Package` or `Ctrl+Shift+P`
3. Publish extension: `AL: Publish` or `Ctrl+F5`
4. Assign permissions: Add `NemediApiRWM` to API user
5. Test API endpoint using examples above