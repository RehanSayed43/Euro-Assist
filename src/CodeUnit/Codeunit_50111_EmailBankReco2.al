codeunit 50111 "Email Integration1"
{
    procedure SentMailAttachmnet(var statementtype: Option; var docno: code[20]; var statementno: Code[20])
    var
        SalesHeader: Record "Sales Invoice Header";
        BankRec: Record "Bank Acc. Reconciliation";

        EmailAccount: Record "Email Account";
        EmailMsg: Codeunit "Email Message";
        flag: Boolean;
        BodyText: text;
        outstream: OutStream;
        instream: InStream;
        reportPO: report 1408;
        tempblob: Codeunit "Temp Blob";
        Vendor: record Customer;
        VendEmail: text;
        VendEmail2: text;
        company: Record "Company Information";
        BankName: Text;
        bANKBranchcode: Text;
        BankAccNo: Text;
        Iban: Code[50];
    begin
        BankRec.Reset();

        //BankRec."Statement Type"
        BankRec.SetRange("Statement Type", statementtype);
        BankRec.SetRange("Bank Account No.", docno);
        BankRec.SetRange("Statement No.", statementno);
        if BankRec.FindFirst()
           then begin
            BodyText := '<br>' + '<br>Dear Team,' + '</B>';
            CC.Add('rehan@cocoonitservices.com');
            EmailMsg.Create(CC, 'Tax Invoice ' + BankRec."Bank Account No.", BodyText, true, CC1, CC1);
            reportPO.SetTableView(BankRec);
            tempblob.CreateOutStream(outstream);
            flag := reportPO.SaveAs('', ReportFormat::Pdf, outstream);
            tempblob.CreateInStream(instream);
            EmailMsg.AddAttachment('Bank Reco Report ' + BankRec."Statement No." + '.pdf', 'PDF', instream);
            EmailMsg.AppendToBody('<br>');
            EmailMsg.AppendToBody('<br>This is the Bank Reco Report' + '</B>');

            if flag then begin
                Email.Send(EmailMsg, Enum::"Email Scenario"::Default);
                // SMTPMail.Send;
                MESSAGE('mail Sent Successfuly');
            end;
        end;
    end;


    //BANK CUSTOM CODE
    //BEFORE APPLY ENTRIES;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Bank Acc. Entry Set Recon.-No.", OnBeforeApplyEntries, '', false, false)]
    local procedure "Bank Acc. Entry Set Recon.-No._OnBeforeApplyEntries"(var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line"; var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; var Relation: Option)
    begin
        if BankAccReconciliationLine."UTR No" <> '' then begin

            if BankAccReconciliationLine."UTR No" = BankAccountLedgerEntry."UTR No." then begin
                //BankAccReconciliationLine."UTR/Entry No Match" := true;
                if BankAccReconciliationLine."Statement Amount" <> BankAccountLedgerEntry.Amount then
                    BankAccReconciliationLine.Difference := BankAccountLedgerEntry.Amount - BankAccReconciliationLine."Statement Amount";
                // BankAccReconciliationLine.Difference := BankAccReconciliationLine."Statement Amount" - BankAccountLedgerEntry.Amount;

                BankAccReconciliationLine."UTR/Entry No Match" := true;
                BankAccReconciliationLine.Modify();
            end else
                if BankAccReconciliationLine."Entry No" = BankAccountLedgerEntry."Entry No." then begin

                    if BankAccReconciliationLine."Statement Amount" <> BankAccountLedgerEntry.Amount then
                        BankAccReconciliationLine."UTR/Entry No Match" := true;
                    BankAccReconciliationLine.Modify();

                end;
        end else begin
            if BankAccReconciliationLine."Entry No" = BankAccountLedgerEntry."Entry No." then begin

                if BankAccReconciliationLine."Statement Amount" <> BankAccountLedgerEntry.Amount then
                    if BankAccReconciliationLine."Statement Amount" > BankAccountLedgerEntry.Amount then
                        BankAccReconciliationLine.Difference := BankAccReconciliationLine."Statement Amount" - BankAccountLedgerEntry.Amount;
                // else
                //     BankAccReconciliationLine.Difference := BankAccountLedgerEntry.Amount - BankAccReconciliationLine."Statement Amount";
                // BankAccReconciliationLine.Difference := BankAccountLedgerEntry.Amount - BankAccReconciliationLine."Statement Amount";
                BankAccReconciliationLine."UTR/Entry No Match" := true;
                BankAccReconciliationLine.Modify();

            end;

        end;

    end;


    //REHAN
    //TO  MATCH UTR NO AND ENTRY NO.
    //AFTER APPLY ENTRIES;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Bank Acc. Entry Set Recon.-No.", OnAfterApplyEntries, '', false, false)]
    local procedure "Bank Acc. Entry Set Recon.-No._OnAfterApplyEntries"(var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line"; var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; var Relation: Option)
    begin
        if (BankAccReconciliationLine."UTR No" = '') and (BankAccReconciliationLine."Entry No" = 0) then begin

        end;
        if BankAccReconciliationLine."UTR No" <> '' then begin

            if BankAccReconciliationLine."UTR No" = BankAccountLedgerEntry."UTR No." then begin
                BankAccReconciliationLine."UTR/Entry No Match" := true;
                BankAccReconciliationLine.Modify();
            end else
                if BankAccReconciliationLine."Entry No" = BankAccountLedgerEntry."Entry No." then begin
                    BankAccReconciliationLine."UTR/Entry No Match" := true;
                    BankAccReconciliationLine.Modify();

                end;
        end else begin
            if BankAccReconciliationLine."Entry No" = BankAccountLedgerEntry."Entry No." then begin
                BankAccReconciliationLine."UTR/Entry No Match" := true;
                BankAccReconciliationLine.Modify();

            end;

        end;

        if not BankAccReconciliationLine."UTR/Entry No Match" then begin
            BankAccReconciliationLine.Difference := BankAccReconciliationLine."Statement Amount";
            BankAccReconciliationLine.Modify();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Bank Acc. Reconciliation Post", OnBeforeFinalizePost, '', false, false)]
    local procedure "Bank Acc. Reconciliation Post_OnBeforeFinalizePost"(var BankAccReconciliation: Record "Bank Acc. Reconciliation")
    begin
        BankAccReconciliation.TestField(SentEmail);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Bank Acc. Entry Set Recon.-No.", OnBeforeModifyBankAccReconLine, '', false, false)]
    local procedure "Bank Acc. Entry Set Recon.-No._OnBeforeModifyBankAccReconLine"(var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line")
    begin
        BankAccReconciliationLine."UTR/Entry No Match" := false;
    end;


    var
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        Receipent: List of [Text];
        Body: Text;

        Contact: Record 5050;
        CC: List of [Text];
        CC1: List of [Text];
}