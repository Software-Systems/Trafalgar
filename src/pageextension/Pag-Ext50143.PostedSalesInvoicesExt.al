pageextension 50143 PagExtPostedSalesInvoices extends "Posted Sales Invoices"
{
    layout
    {
        addafter("Order No.")
        {
            field("Assigned User ID"; Rec."Assigned User ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Assigned User ID field.', Comment = '%';
            }
            field("Method Of Enquiry"; Rec."Method Of Enquiry")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Method Of Enquiry field.', Comment = '%';
            }
            field("Sales Order Created By"; Rec."Sales Order Created By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sales Order Created By field.', Comment = '%';
            }
            field("Picked By"; Rec."Picked By")
            {
                ApplicationArea = All;
                Editable = FieldVisible;
                Visible = FieldVisible;
                ToolTip = 'Specifies the value of the Picked By field.', Comment = '%';
            }
            field("Checked By"; Rec."Checked By")
            {
                ApplicationArea = All;
                Editable = FieldVisible;
                Visible = FieldVisible;
                ToolTip = 'Specifies the value of the Checked By field.', Comment = '%';
            }
        }
    }
    actions
    {
        addafter("Update Document")
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
                        FileURL := TrafalgarSharepointCodeunit.OpenSharepointDocument(36, DocNo);
                    end
                    else
                        FileURL := Rec.Documents;
                    Hyperlink(FileURL);
                end;
            }
        }
        addafter("Update Document_Promoted")
        {
            actionref("OpenDocs_Promoted"; OpenDocument)
            {
            }
        }
    }

    var
        TrafalgarGenCodeunit: Codeunit "Trafalgar General Codeunit";
        FieldVisible: Boolean;

    trigger OnOpenPage()
    begin
        FieldVisible := TrafalgarGenCodeunit.CheckPickedAndCheckedEnabled();
        Rec.SetAscending("No.", false);
    end;
}
