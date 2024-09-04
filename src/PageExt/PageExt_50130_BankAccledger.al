pageextension 50130 BankAccledger extends "Apply Bank Acc. Ledger Entries"
{
    layout
    {
        addafter("Remaining Amount")
        {
            // field("UTR No."; Rec."UTRNo.")
            // {
            //     ApplicationArea = all;
            // }
            field("UTR No."; Rec."UTR No.")
            {

                ApplicationArea = all;
            }
        }
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}