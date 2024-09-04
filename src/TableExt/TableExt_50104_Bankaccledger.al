tableextension 50104 BankLeger extends "Bank Account Ledger Entry"
{
    fields
    {
        field(50101; "UTRNo."; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        // Add changes to table fields here
    }

    // Add changes to keys here
    // keys
    // {
    //     key(Utr; "UTR No.")
    //     {

    //     }
    // }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}