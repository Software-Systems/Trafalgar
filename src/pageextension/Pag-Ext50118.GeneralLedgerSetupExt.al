pageextension 50118 PagExtGeneralLedgerSetup extends "General Ledger Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter(EnableDataCheck)
        {
            field("SharePoint Document Path"; Rec."SharePoint Document Path")
            {
                ApplicationArea = All;
            }
            field("Auto Send Invoice on Posting"; Rec."Auto Send Invoice on Posting")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Auto Send Invoice on Order Posting field.', Comment = '%';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}