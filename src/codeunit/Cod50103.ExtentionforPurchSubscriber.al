codeunit 50103 "Extention for Purch Subscriber"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnApproveApprovalRequest', '', false, false)]
    local procedure OnApproveApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        PurchHeader: Record "Purchase Header";

    begin
        if (ApprovalEntry."Document Type" = ApprovalEntry."Document Type"::Order) and (ApprovalEntry."Table ID" = 38) then begin
            PurchHeader.Reset();
            PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Order);
            PurchHeader.SetRange("No.", ApprovalEntry."Document No.");
            if PurchHeader.FindFirst() then begin
                PurchHeader."Price Changed" := false;
                PurchHeader.Modify();
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", OnBeforeConfirmPost, '', true, true)]
    local procedure OnBeforeConfirmPost(var DefaultOption: Integer)
    begin
        DefaultOption := 1;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", OnAfterConfirmPost, '', true, true)]
    local procedure OnAfterConfirmPost(var PurchaseHeader: Record "Purchase Header")
    var
        ConfirmManagement: Codeunit "Confirm Management";
        SalesLine: Record "Sales Line";
        QuestionLbl: Label 'Do you want to Update the Posting & Document Date to today?';
    begin
        if ConfirmManagement.GetResponse(QuestionLbl, false) then begin
            PurchaseHeader."Posting Date" := Today;
            PurchaseHeader.Validate("Document Date", Today);
            PurchaseHeader."VAT Reporting Date" := Today;
        end;
    end;
}