pageextension 50138 PagExtPostedPurchaseInvoice extends "Posted Purchase Invoice"
{
    layout
    {
        addafter("Vendor Invoice No.")
        {
            field(Documents; Rec.Documents)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Documents field.', Comment = '%';
            }
        }
    }
    actions
    {
        // Add changes to page actions here
        addafter(Vendor)
        {
            action(EditExtDocNo)
            {
                Caption = 'Change Ext. Doc. No.';
                Image = OpenJournal;
                ToolTip = 'change External Document No.';
                ApplicationArea = all;
                trigger OnAction()
                var
                    PurchInvHeader: Record "Purch. Inv. Header";
                    ChangeReport: Report ChangeExtDocNo_Purch;
                begin
                    PurchInvHeader.SetRange("No.", Rec."No.");
                    if PurchInvHeader.FindFirst() then begin
                        ChangeReport.SetTableView(PurchInvHeader);
                        ChangeReport.Run();
                    end;
                end;
            }
            action(EditDueDate)
            {
                Caption = 'Change Due Date';
                Image = OpenJournal;
                ToolTip = 'Change Due Date';
                ApplicationArea = all;
                trigger OnAction()
                var
                    PurchInvHeader: Record "Purch. Inv. Header";
                    ChangeReport: Report ChangeDueDate;
                begin
                    PurchInvHeader.SetRange("No.", Rec."No.");
                    if PurchInvHeader.FindFirst() then begin
                        ChangeReport.SetTableView(PurchInvHeader);
                        ChangeReport.Run();
                    end;
                end;
            }
        }
        addafter(Approvals)
        {
            /*
            action(OpenDocument)
            {
                Caption = 'Open Docs';
                Image = OpenJournal;
                ToolTip = 'Open Documents.';
                ApplicationArea = all;
                trigger OnAction()
                begin
                    Hyperlink(Rec.Documents);
                end;
            }
            */
            action(OpenDocument)
            {
                Caption = 'Open Docs';
                Image = OpenJournal;
                ToolTip = 'Open Documents.';
                ApplicationArea = all;
                trigger OnAction()
                var
                    TrafalgarSharepointCodeunit: Codeunit "Trafalgar Sharepoint Codeunit";
                    DocNo: Code[20];
                    FileURL: Text;
                begin
                    if Rec.Documents = '' then begin
                        if Rec."Quote No." <> '' then
                            DocNo := Rec."Quote No."
                        else begin
                            if Rec."Order No." = '' then
                                DocNo := Rec."Pre-Assigned No."
                            else
                                DocNo := Rec."Order No.";
                        end;
                        FileURL := TrafalgarSharepointCodeunit.OpenSharepointDocument(38, DocNo);
                    end
                    else
                        FileURL := Rec.Documents;
                    Hyperlink(FileURL);
                end;
            }
        }
        addafter("Update Document_Promoted")
        {
            actionref("Change_Doc_Promoted"; EditExtDocNo)
            {
            }
            actionref("Change_DueDate_Promoted"; Editduedate)
            {
            }
            actionref(OpenDoc_promoted; OpenDocument)
            {
            }
        }
    }
}