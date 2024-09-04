tableextension 50141 bank extends "Bank Acc. Reconciliation"
{
    fields
    {
        field(50112; SentEmail; Boolean)
        {
            DataClassification = ToBeClassified;
            InitValue = false;

            trigger OnValidate()
            var
                Recodeunit: Codeunit 50111;
                BankReco: Record "Bank Acc. Reconciliation";
                myInt: Integer;
            begin
                if rec.SentEmail = false then begin
                    Error('cannot change');
                end else begin
                    Recodeunit.SentMailAttachmnet(Rec."Statement Type", Rec."Bank Account No.", Rec."Statement No.");
                end;


            end;
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
    procedure MatchSingleR(DateRange: Integer)
    var
        MatchBankRecLines: Codeunit "Match Bank Rec. Line";
        //System Standard
        MatchBankReclines2: Codeunit "Match Bank Rec. Lines";
        IsHandled: Boolean;
        MAtch: Report "Match Bank Entries";
        Rec: Record "Bank Acc. Reconciliation";
        BankAccrecline: Record "Bank Acc. Reconciliation Line";
        BankAccLedgerEntry: Record "Bank Account Ledger Entry";
    begin
        IsHandled := false;
        OnBeforeMatchSingle(Rec, DateRange, IsHandled);
        if IsHandled then
            exit;
        //BankAccLedgerEntry.SetRange("UTR No.", BankAccrecline."UTR No");
        MatchBankRecLines.BankAccReconciliationAutoMatch(Rec, DateRange);

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeMatchSingle(var BankAccReconciliation: Record "Bank Acc. Reconciliation"; DateRange: Integer; var IsHandled: Boolean)
    begin
    end;



    var
        myInt: Integer;

}