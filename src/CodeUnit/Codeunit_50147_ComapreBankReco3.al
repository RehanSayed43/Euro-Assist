// codeunit 50147 BankReconciliationComparison
// {
//     procedure CompareUTRNumbersAndSyncData()
//     var
//         BankLedgerEntry: Record "Bank Account Ledger Entry";
//         BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
//     begin
//         // Log the start of the process
//         Message('CompareUTRNumbersAndSyncData: Process started.');

//         // Set the range for Bank Ledger Entry to Payment type
//         BankLedgerEntry.SetRange("Document Type", BankLedgerEntry."Document Type"::Payment);

//         // Loop through all Bank Ledger Entries
//         if BankLedgerEntry.FindSet then begin
//             Message('Bank Ledger Entries found.');


//             repeat
//                 Message('Processing Bank Ledger Entry: ' + Format(BankLedgerEntry."Entry No."));

//                 // Clear filters on Bank Acc. Reconciliation Line and set new ones
//                 BankAccReconciliationLine.Reset();
//                 BankAccReconciliationLine.SetRange("Bank Account No.", BankLedgerEntry."Bank Account No.");
//                 BankAccReconciliationLine.SetRange("Statement No.", BankLedgerEntry."Statement No.");
//                 BankAccReconciliationLine.SetRange("UTR No", BankLedgerEntry."UTR No.");

//                 // Check if there are matching entries in Bank Acc. Reconciliation Line
//                 if BankAccReconciliationLine.FindSet then begin
//                     Message('Matching Bank Acc. Reconciliation Line entries found.');

//                     // Sync data between entries as needed
//                     repeat
//                         Message('Updating Bank Acc. Reconciliation Line: ' + Format(BankAccReconciliationLine."Statement Line No."));
//                         BankAccReconciliationLine."Cr Amount" := BankLedgerEntry."Credit Amount";
//                         BankAccReconciliationLine.Modify();
//                     until BankAccReconciliationLine.Next() = 0;
//                 end else begin
//                     Message('No matching Bank Acc. Reconciliation Line entries found for UTR No: ' + BankLedgerEntry."UTR No.");
//                 end;
//             until BankLedgerEntry.Next() = 0;
//         end else begin
//             Message('No Bank Ledger Entries found.');
//         end;

//         // Log the end of the process
//         Message('CompareUTRNumbersAndSyncData: Process completed.');
//     end;
// }
