pageextension 50132 PagExtPostedSalesInvoice extends "Posted Sales Invoice"
{

    layout
    {
        // Add changes to page layout here
        addafter("Order No.")
        {
            field("Prepayment Order No."; Rec."Prepayment Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Prepayment Order No. field.', Comment = '%';
            }
        }
        addlast(General)
        {
            group("Sales Order")
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
            }
        }
        addafter(Closed)
        {
            field(Documents; Rec.Documents)
            {
                ApplicationArea = all;
            }
            field("Created By"; Rec."Created By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
            }
            field("Modified By"; Rec."Modified By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Modified By field.', Comment = '%';
            }
            field("Quote Created By"; Rec."Quote Created By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Quote Created By field.', Comment = '%';
                Editable = false;
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
            field(GetTotalSalesPaid; Rec.GetTotalSalesPaid())
            {
                Caption = 'Total Paid';
                Style = StrongAccent;
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(Customer)
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
            action(EditExtDocNo)
            {
                Caption = 'Change Ext. Doc. No.';
                Image = OpenJournal;
                ToolTip = 'change External Document No.';
                ApplicationArea = all;
                trigger OnAction()
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                    ChangeReport: Report ChangeExtDocNo;
                begin
                    SalesInvHeader.SetRange("No.", Rec."No.");
                    if SalesInvHeader.FindFirst() then begin
                        ChangeReport.SetTableView(SalesInvHeader);
                        ChangeReport.Run();
                    end;
                end;
            }
            action("Take Payment")
            {
                Image = Payment;
                ApplicationArea = all;
                trigger OnAction()
                var
                    PageSalesPayments: Page "Sales Payments";
                    DocType: Enum "Sales Document Type";
                begin
                    Clear(PageSalesPayments);
                    if Rec."Order No." <> '' then
                        PageSalesPayments.SetPar(DocType::Order, Rec."Order No.")
                    else
                        PageSalesPayments.SetPar(DocType::Invoice, Rec."No.");
                    PageSalesPayments.RunModal();
                end;
            }
        }
        addafter("ChangePaymentService_Promoted")
        {
            actionref("Open_Docs_Promoted"; OpenDocument)
            {
            }
            actionref("Change_Doc_Promoted"; EditExtDocNo)
            {
            }
            actionref(TakePayment_Promoted; "Take Payment")
            {
            }
        }
    }
    var
        TrafalgarGenCodeunit: Codeunit "Trafalgar General Codeunit";
        FieldVisible: Boolean;

    trigger OnOpenPage()
    begin
        FieldVisible := TrafalgarGenCodeunit.CheckPickedAndCheckedEnabled()
    end;
}