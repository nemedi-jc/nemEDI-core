// Nemedi Reopen Sales Order API
// REST API endpoint for reopening sales orders
// URL: POST /api/nemedi/core/v1.0/companies(<companyId>)/reopenSalesOrders
// Body: { "orderNo": "SO012345" }

namespace DefaultPublisher.ALProject3;

page 50120 "Nemedi Reopen SO API"
{
    PageType = API;
    APIPublisher = 'nemedi';
    APIGroup = 'core';
    APIVersion = 'v1.0';

    EntityName = 'reopenSalesOrder';
    EntitySetName = 'reopenSalesOrders';

    SourceTable = "Nemedi Reopen SO Request";
    SourceTableTemporary = true;
    ODataKeyFields = Id;

    DelayedInsert = true;
    Caption = 'Nemedi Reopen Sales Order API';
    Editable = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(id; Rec.Id)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'ID';
                }
                field(orderNo; Rec."orderNo")
                {
                    ApplicationArea = All;
                    Caption = 'Order No.';
                }
                field(success; Rec.success)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Success';
                }
                field(message; Rec.message)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Message';
                }
                field(previousStatus; Rec.previousStatus)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Previous Status';
                }
                field(currentStatus; Rec.currentStatus)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Current Status';
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        SalesOps: Codeunit "Nemedi SalesOps";
        IsSuccess: Boolean;
        PrevStatus: Text[30];
        CurrStatus: Text[30];
        ResultMessage: Text[250];
    begin
        // Execute reopen operation using the business logic codeunit
        IsSuccess := SalesOps.ReopenSalesOrder(Rec."orderNo", PrevStatus, CurrStatus, ResultMessage);

        // Set response fields
        Rec.success := IsSuccess;
        Rec.message := ResultMessage;
        Rec.previousStatus := PrevStatus;
        Rec.currentStatus := CurrStatus;

        exit(true);
    end;
}