// Nemedi Reopen Sales Order Request Table
// Temporary table used for API operations to reopen sales orders
// Contains request parameters and response data

namespace nemEDI.Core;

table 50120 "Nemedi Reopen SO Request"
{
    DataClassification = SystemMetadata;
    TableType = Temporary;

    fields
    {
        field(1; Id; Guid)
        {
            DataClassification = SystemMetadata;
            Caption = 'ID';
        }
        field(2; "orderNo"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Order No.';
            NotBlank = true;
        }
        field(10; "success"; Boolean)
        {
            DataClassification = SystemMetadata;
            Caption = 'Success';
            Editable = false;
        }
        field(11; "message"; Text[250])
        {
            DataClassification = SystemMetadata;
            Caption = 'Message';
            Editable = false;
        }
        field(12; "previousStatus"; Text[30])
        {
            DataClassification = SystemMetadata;
            Caption = 'Previous Status';
            Editable = false;
        }
        field(13; "currentStatus"; Text[30])
        {
            DataClassification = SystemMetadata;
            Caption = 'Current Status';
            Editable = false;
        }
    }

    keys
    {
        key(PK; Id)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        if IsNullGuid(Id) then
            Id := CreateGuid();
    end;
}