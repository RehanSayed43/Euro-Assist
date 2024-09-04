tableextension 50106 MyExtension190 extends "Bank Statement Matching Buffer"
{
    fields
    {
        field(50138; "UTR Nos"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        // Add changes to table fields here
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}