// Nemedi Sales Operations Codeunit
// Provides business logic for sales order operations
// Main function: ReopenSalesOrder - safely reopens sales orders using standard BC logic

namespace nemEDI.Core;

using Microsoft.Sales.Document;

codeunit 50120 "Nemedi SalesOps"
{
    SingleInstance = false;

    // Constants for error messages
    var
        SalesOrderNotFoundErr: Label 'Sales order %1 not found.';
        SalesOrderAlreadyOpenMsg: Label 'Sales order already Open.';
        SalesOrderReopenedSuccessMsg: Label 'Sales order reopened successfully.';
        CouldNotReopenErr: Label 'Could not reopen sales order. Current status: %1';
        MissingOrderNoErr: Label 'Missing orderNo parameter.';

    /// <summary>
    /// Validates input parameters for sales order operations
    /// </summary>
    /// <param name="OrderNo">Sales order number to validate</param>
    /// <param name="ErrorMsg">Returns error message if validation fails</param>
    /// <returns>True if valid, false otherwise</returns>
    local procedure ValidateOrderNo(OrderNo: Code[20]; var ErrorMsg: Text[250]): Boolean
    begin
        if OrderNo = '' then begin
            ErrorMsg := MissingOrderNoErr;
            exit(false);
        end;
        exit(true);
    end;

    /// <summary>
    /// Finds a sales order by number
    /// </summary>
    /// <param name="OrderNo">Sales order number to find</param>
    /// <param name="SalesHeader">Returns the found sales header record</param>
    /// <param name="ErrorMsg">Returns error message if not found</param>
    /// <returns>True if found, false otherwise</returns>
    local procedure FindSalesOrder(OrderNo: Code[20]; var SalesHeader: Record "Sales Header"; var ErrorMsg: Text[250]): Boolean
    begin
        SalesHeader.Reset();
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SetRange("No.", OrderNo);
        if not SalesHeader.FindFirst() then begin
            ErrorMsg := StrSubstNo(SalesOrderNotFoundErr, OrderNo);
            exit(false);
        end;
        exit(true);
    end;

    /// <summary>
    /// Attempts to reopen a sales order using standard BC logic
    /// </summary>
    /// <param name="SalesHeader">Sales header record to reopen</param>
    /// <param name="ErrorMsg">Returns error message if operation fails</param>
    /// <returns>True if successful, false otherwise</returns>
    local procedure TryReopenSalesOrder(var SalesHeader: Record "Sales Header"; var ErrorMsg: Text[250]): Boolean
    var
        ReleaseCU: Codeunit "Release Sales Document";
    begin
        ReleaseCU.Reopen(SalesHeader);
        SalesHeader.Find(); // Refresh record

        if SalesHeader.Status <> SalesHeader.Status::Open then begin
            ErrorMsg := StrSubstNo(CouldNotReopenErr, Format(SalesHeader.Status));
            exit(false);
        end;
        exit(true);
    end;
    /// <summary>
    /// Reopens a sales order using standard BC business logic
    /// </summary>
    /// <param name="OrderNo">Sales order number to reopen</param>
    /// <param name="PrevStatusTxt">Returns the previous status as text</param>
    /// <param name="CurrStatusTxt">Returns the current status as text</param>
    /// <param name="Msg">Returns success or error message</param>
    /// <returns>True if successful, false otherwise</returns>
    procedure ReopenSalesOrder(OrderNo: Code[20]; var PrevStatusTxt: Text[30]; var CurrStatusTxt: Text[30]; var Msg: Text[250]) Success: Boolean
    var
        SalesHeader: Record "Sales Header";
    begin
        // Validate input
        if not ValidateOrderNo(OrderNo, Msg) then
            exit(false);

        // Find sales order
        if not FindSalesOrder(OrderNo, SalesHeader, Msg) then
            exit(false);

        PrevStatusTxt := Format(SalesHeader.Status);

        // If already Open, return success with informative message
        if SalesHeader.Status = SalesHeader.Status::Open then begin
            CurrStatusTxt := PrevStatusTxt;
            Msg := SalesOrderAlreadyOpenMsg;
            exit(true);
        end;

        // Attempt to reopen
        if not TryReopenSalesOrder(SalesHeader, Msg) then begin
            CurrStatusTxt := Format(SalesHeader.Status);
            exit(false);
        end;

        // Success
        CurrStatusTxt := Format(SalesHeader.Status);
        Msg := SalesOrderReopenedSuccessMsg;
        exit(true);
    end;

    /// <summary>
    /// Gets the current status of a sales order
    /// </summary>
    /// <param name="OrderNo">Sales order number</param>
    /// <param name="StatusText">Returns the current status as text</param>
    /// <param name="ErrorMsg">Returns error message if order not found</param>
    /// <returns>True if order found, false otherwise</returns>
    procedure GetSalesOrderStatus(OrderNo: Code[20]; var StatusText: Text[30]; var ErrorMsg: Text[250]): Boolean
    var
        SalesHeader: Record "Sales Header";
    begin
        if not ValidateOrderNo(OrderNo, ErrorMsg) then
            exit(false);

        if not FindSalesOrder(OrderNo, SalesHeader, ErrorMsg) then
            exit(false);

        StatusText := Format(SalesHeader.Status);
        exit(true);
    end;
}