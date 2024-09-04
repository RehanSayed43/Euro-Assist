// codeunit 50148 CustomMatchAutomatically1
// {

//NOT IN USE----
//     procedure MatchAutomatically(var SelectedBankAccReconciliationLine: Record "Bank Acc. Reconciliation Line"; var SelectedBankAccountLedgerEntry: Record "Bank Account Ledger Entry")
//     var
//         BankAccLECount: Integer;
//         BankAccRecLineCount: Integer;
//         MatchingEntryFound: Boolean;
//     begin
//         // Count the records
//         BankAccLECount := SelectedBankAccountLedgerEntry.Count();
//         BankAccRecLineCount := SelectedBankAccReconciliationLine.Count();

//         // Error if many-to-many relationship
//         if (BankAccLECount > 1) and (BankAccRecLineCount > 1) then
//             Error('Many-to-many matching is not supported.');

//         // Iterate through each reconciliation line
//         if SelectedBankAccReconciliationLine.FindSet() then begin
//             repeat
//                 MatchingEntryFound := false;
//                 SelectedBankAccountLedgerEntry.SetRange("UTR No.", SelectedBankAccReconciliationLine."UTR No");

//                 // Check if there's a matching ledger entry
//                 if SelectedBankAccountLedgerEntry.FindSet() then begin
//                     repeat
//                         // Check if the debit and credit amounts match
//                         if (SelectedBankAccountLedgerEntry."Debit Amount" = SelectedBankAccReconciliationLine."Statement Amount") and
//                            (SelectedBankAccountLedgerEntry."Credit Amount" = SelectedBankAccReconciliationLine."Statement Amount") then begin
//                             // Check if the difference is zero
//                             if SelectedBankAccountLedgerEntry."Debit Amount" - SelectedBankAccountLedgerEntry."Credit Amount" = 0 then begin
//                                 MatchingEntryFound := true;
//                                 SelectedBankAccReconciliationLine."Description" := 'Matched';
//                                 SelectedBankAccReconciliationLine.Modify();
//                                 SelectedBankAccountLedgerEntry."Description" := 'Matched';
//                                 SelectedBankAccountLedgerEntry.Modify();
//                             end;
//                         end;
//                     until SelectedBankAccountLedgerEntry.Next() = 0;
//                 end;

//                 if not MatchingEntryFound then begin
//                     SelectedBankAccReconciliationLine."Description" := 'No Match Found';
//                     SelectedBankAccReconciliationLine.Modify();
//                 end;

//             until SelectedBankAccReconciliationLine.Next() = 0;
//         end;
//     end;
// }
