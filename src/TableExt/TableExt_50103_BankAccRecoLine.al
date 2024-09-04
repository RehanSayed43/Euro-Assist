tableextension 50128 MyExtension extends "Bank Acc. Reconciliation Line"
{
    fields
    {
        field(50101; "UTR No"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50102; "Entry No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50103; "Dr Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                //"Statement Amount" := "Dr Amount";
                Validate("Statement Amount", "Dr Amount");
            end;
        }
        field(50104; "Cr Amount"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                myInt: Integer;
            begin
                //"Statement Amount" := "Cr Amount";
                Validate("Statement Amount", -"Cr Amount");

            end;
        }
        field(50105; Matchingstatus; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50106; AutoMatchCheck; Boolean)
        {
        }
        field(5010; "UTR/Entry No Match"; Boolean)
        {
            DataClassification = ToBeClassified;
        }



        // Add changes to table fields here
    }
    keys
    {
        key(key10; "UTR No")
        {
        }
        // Add changes to keys here
    }
    // procedure FilterBankRecLines(BankAccReconciliation: Record "Bank Acc. Reconciliation"; Overwrite: Boolean)
    // begin
    //     Rec.Reset();
    //     Rec.SetRange("Statement Type", BankAccReconciliation."Statement Type");
    //     Rec.SetRange("Bank Account No.", BankAccReconciliation."Bank Account No.");
    //     Rec.SetRange("Statement No.", BankAccReconciliation."Statement No.");
    //     if not Overwrite then
    //         Rec.SetRange("Applied Entries", 0);
    //     //  FilterBankRecLines(Rec, BankAccReconciliation);
    // end;

    // procedure FilterBankRecLines(BankAccReconciliation: Record "Bank Acc. Reconciliation")
    // begin
    //     FilterBankRecLines(BankAccReconciliation, true);
    // end;






    var
        myInt: Integer;
        Rec1: Record "Bank Acc. Reconciliation Line";


}