pageextension 55159 PagExtSalesOrderArchive extends "Sales Order Archive"
{
    layout
    {
        addafter("External Document No.")
        {
            field(Documents; Rec.Documents)
            {
                ApplicationArea = all;
            }
            field("CC Machine"; Rec."CC Machine")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the CC Machine field.', Comment = '%';
            }
            field("CC Card Type"; Rec."CC Card Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the CC Card Type field.', Comment = '%';
            }
            field("CC Payment Date"; Rec."CC Payment Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the CC Payment Date field.', Comment = '%';
            }
            field("CC Processed By"; Rec."CC Processed By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the CC Processed By field.', Comment = '%';
            }
            field("Amount Paid"; Rec."Amount Paid")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Amount Paid field.', Comment = '%';
            }
        }
        addafter(Status)
        {
            field("Work Description"; WorkDescription)
            {
                ApplicationArea = all;
                Caption = 'Work Description';
                MultiLine = true;
            }
        }
    }
    actions
    {
        addbefore(Restore)
        {
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
        }
        addafter(Restore_Promoted)
        {
            actionref("Open_Docs_Promoted"; OpenDocument)
            {
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        WorkDescription := GetWorkDescription();
    end;

    var
        WorkDescription: Text;

    procedure GetWorkDescription() WorkDescription: Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        Rec.CalcFields("Work Description");
        Rec."Work Description".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), Rec.FieldName(Rec."Work Description")));
    end;
}
