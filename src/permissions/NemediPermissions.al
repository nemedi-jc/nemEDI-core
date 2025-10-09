// Nemedi Permission Set for API access
// Provides read/modify access to Sales Header for reopen operations
// Assignable to users who need access to the Sales Order Reopen API

namespace nemEDI.Core;

using Microsoft.Sales.Document;

permissionset 50111 "NemediApiRWM"
{
    Access = Public;
    Assignable = true;
    Caption = 'Nemedi API R/W (Sales)';

    Permissions =
        tabledata "Sales Header" = RM,
        tabledata "Nemedi Reopen SO Request" = RMID,
        codeunit "Release Sales Document" = X,
        codeunit "Nemedi SalesOps" = X,
        page "Nemedi Reopen SO API" = X;
}