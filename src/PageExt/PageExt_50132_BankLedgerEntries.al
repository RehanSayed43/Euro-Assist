pageextension 50122 BankLedger extends "Bank Account Ledger Entries"
{
    layout
    {
        addafter("Document No.")
        {
            field("UTR No."; Rec."UTR No.")
            {
                ApplicationArea = all;
            }
        } // Add changes to page layout here
    }

    actions
    {
        addafter("Reverse Transaction")
        {
            action("UTR-Update/Modify")
            {
                ApplicationArea = All;
                Promoted = true;
                Visible = true;
                Enabled = true;

                trigger OnAction()
                var
                //  XMLBankledger:XmlPort 50113;
                begin
                    Xmlport.Run(50124);

                end;
            }

        }
        addafter(Stale_Check)
        {
            action("Status")
            {
                ApplicationArea = All;
                //Promoted = true;
                Visible = true;
                Enabled = true;

                trigger OnAction()
                begin
                    Xmlport.Run(50125);
                end;
            }

        }
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}