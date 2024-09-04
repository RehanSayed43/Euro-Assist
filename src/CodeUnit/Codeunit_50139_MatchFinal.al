// codeunit 50139 MatchingBankLedg_Manual_Auto
// {

//     //REHAN SAYED
//     Permissions = tabledata "Bank Account Ledger Entry" = rimd,
//         tabledata "Bank Acc. Reconciliation Line" = rimd;

//     trigger OnRun()
//     begin
//     end;

//     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Bank Acc. Entry Set Recon.-No.", 'OnBeforeApplyEntries', '', true, true)]
//     procedure ApplyEntries(var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
//     var BankAccountLedgerEntry: Record "Bank Account Ledger Entry")//;var Relation: Option "One-to-One","One-to-Many")
//     var
//         BankAccountLedgerEntry1: Record "Bank Account Ledger Entry";
//         RecBankAccRecLine: Record "Bank Acc. Reconciliation Line";
//         RecReportMatchBankEntries: Report "Match Bank Entries";
//         RecBankAccRec: Record "Bank Acc. Reconciliation";
//         MatchBankRecLines: Codeunit "Match Bank Rec. Lines";
//     begin
//         if (BankAccReconciliationLine."UTR No" <> '') or (BankAccountLedgerEntry."UTR No." <> '') then begin
//             if (BankAccReconciliationLine."UTR No" <> BankAccountLedgerEntry."UTR No.") then
//                 Error('UTR No. does not match')

//         end;

//         RecBankAccRecLine.Reset();
//         RecBankAccRecLine.SetRange("Bank Account No.", BankAccReconciliationLine."Bank Account No.");
//         RecBankAccRecLine.SetRange("Statement No.", BankAccReconciliationLine."Statement No.");
//         if RecBankAccRecLine.FindSet() then
//             repeat
//                 //Message('1  %1   %2', RecBankAccRecLine."Statement Amount", RecBankAccRecLine."UTR No.");
//                 BankAccountLedgerEntry1.Reset();
//                 BankAccountLedgerEntry1.SetRange("Bank Account No.", RecBankAccRecLine."Bank Account No.");
//                 BankAccountLedgerEntry1.SetRange(BankAccountLedgerEntry1.Open, true);
//                 BankAccountLedgerEntry1.SetFilter("Remaining Amount", '<>%1', 0);
//                 BankAccountLedgerEntry1.SetRange("UTR No.", RecBankAccRecLine."UTR No");
//                 if not BankAccountLedgerEntry1.FindFirst() then begin
//                     //Message('2  %1   %2', BankAccountLedgerEntry1.Amount, BankAccountLedgerEntry1."UTR No.");
//                     Error('UTR No. %1 does not match for Statement Line No. %2', RecBankAccRecLine."UTR No", RecBankAccRecLine."Statement Line No.")
//                     //end else begin
//                 end;
//             until RecBankAccRecLine.Next() = 0;



//         //if not (BankAccountLedgerEntry.IsApplied) or ((Relation = Relation::"One-to-One") and (BankAccReconciliationLine."Applied Entries" > 0)) then begin

//         BankAccountLedgerEntry1.Reset();
//         BankAccountLedgerEntry1.SetRange("Bank Account No.", BankAccountLedgerEntry."Bank Account No.");
//         BankAccountLedgerEntry1.SetRange(BankAccountLedgerEntry1.Open, true);
//         BankAccountLedgerEntry1.SetFilter("Remaining Amount", '<>%1', 0);
//         if BankAccountLedgerEntry1.FindSet() then
//             repeat
//                 if not BankAccReconciliationLine.AutoMatchCheck = true then begin
//                     if (BankAccReconciliationLine."UTR No" <> '') or (BankAccountLedgerEntry1."UTR No." <> '') then begin
//                         if (BankAccReconciliationLine."UTR No" <> BankAccountLedgerEntry1."UTR No.") then
//                             Error('UTR No. does not match')
//                         else begin
//                             BankAccReconciliationLine.AutoMatchCheck := true;
//                             BankAccReconciliationLine.Modify();

//                         end;
//                     end;
//                 end;

//             until BankAccountLedgerEntry1.Next() = 0;
//         if (BankAccReconciliationLine."UTR No" <> BankAccountLedgerEntry."UTR No.")
//                 and (BankAccReconciliationLine."Check No." <> BankAccountLedgerEntry."Cheque No.") then
//             Error('UTR No. & Cheque No does not match')
//         else
//             if (BankAccReconciliationLine."UTR No" <> BankAccountLedgerEntry."UTR No.") then begin
//                 BankAccReconciliationLine.TestField("Check No.");
//                 BankAccountLedgerEntry.TestField("Cheque No.");
//                 if not (BankAccReconciliationLine."Check No." = BankAccountLedgerEntry."Cheque No.") then
//                     Error('UTR No. & Cheque No does not match');
//             end;
//     end;

//     procedure SetReconNo(var BankAccLedgEntry: Record "Bank Account Ledger Entry";
//     var BankAccReconLine: Record "Bank Acc. Reconciliation Line")
//     var
//         CheckLedgEntry: Record "Check Ledger Entry";
//     begin
//         BankAccLedgEntry.TestField(Open, true);
//         BankAccLedgEntry.TestField("Statement Status", BankAccLedgEntry."Statement Status"::Open);
//         BankAccLedgEntry.TestField("Statement No.", '');
//         BankAccLedgEntry.TestField("Statement Line No.", 0);
//         BankAccLedgEntry.TestField("Bank Account No.", BankAccReconLine."Bank Account No.");
//         BankAccLedgEntry."Statement Status" := BankAccLedgEntry."Statement Status"::"Bank Acc. Entry Applied";
//         BankAccLedgEntry."Statement No." := BankAccReconLine."Statement No.";
//         BankAccLedgEntry."Statement Line No." := BankAccReconLine."Statement Line No.";
//         BankAccLedgEntry.Modify();
//         CheckLedgEntry.Reset();
//         CheckLedgEntry.SetCurrentKey("Bank Account Ledger Entry No.");
//         CheckLedgEntry.SetRange("Bank Account Ledger Entry No.", BankAccLedgEntry."Entry No.");
//         CheckLedgEntry.SetRange(Open, true);
//         if CheckLedgEntry.Find('-') then
//             repeat
//                 CheckLedgEntry.TestField("Statement Status", CheckLedgEntry."Statement Status"::Open);
//                 CheckLedgEntry.TestField("Statement No.", '');
//                 CheckLedgEntry.TestField("Statement Line No.", 0);
//                 CheckLedgEntry."Statement Status" := CheckLedgEntry."Statement Status"::"Bank Acc. Entry Applied";
//                 CheckLedgEntry."Statement No." := '';
//                 CheckLedgEntry."Statement Line No." := 0;
//                 CheckLedgEntry.Modify();
//             until CheckLedgEntry.Next() = 0;
//     end;

//     local procedure ModifyBankAccReconLine(var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line")
//     begin
//         OnBeforeModifyBankAccReconLine(BankAccReconciliationLine);
//         BankAccReconciliationLine.Modify();
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure OnBeforeModifyBankAccReconLine(var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line")
//     begin
//     end;
// }
