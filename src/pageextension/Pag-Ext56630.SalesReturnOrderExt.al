pageextension 56630 PagExtSalesReturnOrder extends "Sales Return Order"
{
    layout
    {
        addafter("External Document No.")
        {
            field("Completely Shipped"; Rec."Completely Shipped")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies whether all the items on the order have been shipped or, in the case of inbound items, completely received.';
            }
            field("Refund Type"; Rec."Refund Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Refund Type field.', Comment = '%';
            }
            field(Documents; Rec.Documents)
            {
                ApplicationArea = all;
            }
        }
        modify("Assigned User ID")
        {
            Visible = False;
            Editable = False;
        }
        addafter("Salesperson Code")
        {
            field(AssignedUserID; AssignedUserID)
            {
                Caption = 'Assigned User ID';
                ApplicationArea = all;
                Style = StrongAccent;
                TableRelation = "User Setup"."User ID" where("Sales Doc Assigned" = const(true));
                ShowMandatory = true;
                trigger OnValidate()
                begin
                    Rec."Assigned User ID" := AssignedUserID;
                end;
            }
        }
        addafter(Status)
        {
            field("Method Of Enquiry"; Rec."Method Of Enquiry")
            {
                ApplicationArea = All;
                ShowMandatory = true;
            }
            field("Created By"; Rec."Created By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
            }
        }
    }
    actions
    {
        addafter("Archive Document")
        {
            action(OpenDocument)
            {
                Caption = 'Open Docs';
                Image = OpenJournal;
                ToolTip = 'Open Documents.';
                ApplicationArea = all;
                trigger OnAction()
                var
                    TrafalgarSharepointCodeunit: Codeunit "Trafalgar Sharepoint Codeunit";
                begin
                    if Rec.Documents = '' then
                        Rec.Documents := TrafalgarSharepointCodeunit.OpenSharepointDocument(36, Rec."No.");
                    Hyperlink(Rec.Documents);
                end;
            }
        }
        addafter("Archive Document_Promoted")
        {
            actionref("OpenDocs_Promoted"; OpenDocument)
            {
            }
        }
    }

    var
        AssignedUserID: Code[50];

    trigger OnAfterGetRecord()
    begin

        AssignedUserID := Rec."Assigned User ID";
    end;
}
