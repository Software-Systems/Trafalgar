pageextension 51171 UserTaskCardExt extends "User Task Card"
{
    layout
    {
        modify("Percent Complete")
        {
            Visible = False;
        }
        modify("User Task Group Assigned To")
        {
            Visible = False;
        }
        modify("Start DateTime")
        {
            Visible = False;
        }
        modify("Task Item")
        {
            Visible = False;
        }
        modify(MultiLineTextControl)
        {
            Visible = False;
        }
        moveafter(Title; "Assigned To User Name")

        addfirst(General)
        {
            field(ID; Rec.ID)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the ID of the task.';
            }
        }
        addafter(General)
        {
            group(TaskDescription_TG)
            {
                Caption = 'Task Description';
                field(MultiLineTextControl_TG; MultiLineTextControl)
                {
                    ShowCaption = False;
                    ApplicationArea = All;
                    MultiLine = true;

                    trigger OnValidate()
                    begin
                        Rec.SetDescription(MultiLineTextControl);
                    end;
                }
            }
            Group("Customer Information")
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer No. field.', Comment = '%';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Name field.', Comment = '%';
                }
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sales Order No. field.', Comment = '%';
                }
                field("Posted Sales Invoice No."; Rec."Posted Sales Invoice No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posted Sales Invoice No. field.', Comment = '%';
                }
                field("Refund Amount"; Rec."Refund Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Refund Amount field.', Comment = '%';
                }
                group(Bank)
                {
                    field("Bank BSB"; Rec."Bank BSB")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the BSB field.', Comment = '%';
                    }
                    field("Bank Account No."; Rec."Bank Account No.")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Account No. field.', Comment = '%';
                    }
                    field("Bank Account Name"; Rec."Bank Account Name")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Account Name field.', Comment = '%';
                    }
                    field("Bank Email Contact"; Rec."Bank Email Contact")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Email Contact field.', Comment = '%';
                    }
                    field(Documents; Rec.Documents)
                    {
                        ApplicationArea = all;
                    }
                }
            }
        }
        addlast(FactBoxes)
        {
            systempart(Links; Links)
            {
                ApplicationArea = all;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        addafter("Go To Task Item")
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
                    FileURL: Text;
                begin
                    FileURL := TrafalgarSharepointCodeunit.OpenSharepointDocument(1170, Format(Rec.ID) + '-' + Rec.Title);
                    if FileURL <> '' then
                        Hyperlink(FileURL);
                end;
            }
        }
        addbefore("Go To Task Item_Promoted")
        {
            actionref(OpenDocument_Promoted; OpenDocument)
            {
            }
        }
    }


    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        ErrorMessage: Text;
        TypeHelper: Codeunit "Type Helper";
    begin
        Clear(ErrorMessage);
        Rec.CalcFields(Rec."Assigned To User Name");
        if Rec."Assigned To User Name" = '' then
            ErrorMessage := 'Please Select User Assigned To';

        if Rec."Customer No." = '' then
            ErrorMessage := ErrorMessage + TypeHelper.CRLFSeparator() + 'Please Fill In Account No.';

        if Rec."Refund Amount" = 0 then
            ErrorMessage := ErrorMessage + TypeHelper.CRLFSeparator() + 'Please Fill In Refund Amount';

        if ErrorMessage <> '' then
            Error(ErrorMessage);
    end;
}