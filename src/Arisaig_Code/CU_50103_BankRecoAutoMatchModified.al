// codeunit 50103 BankRecoAutoMatch1
// {
//     trigger OnRun()
//     begin

//     end;

//     //  [EventSubscriber(ObjectType::Codeunit, Codeunit::"Match Bank Rec. Lines", 'OnAfterMatchBankRecLinesMatchSingle', '', false, false)]

//     procedure AddFilter_AutoMatch(CountMatchCandidates: Integer; TempBankStatementMatchingBuffer: Record "Bank Statement Matching Buffer" temporary; BankAccountReco: Record "Bank Acc. Reconciliation")
//     var
//         BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
//         RecordMatchMgt: Codeunit "Record Match Mgt.";
//         ConfirmManagement: Codeunit "Confirm Management";
//         BankRecMatchCandidates: Query "Bank_Reco_Matching";
//         Window: Dialog;
//         Score: Integer;
//         AmountMatched: Boolean;
//         UtrnoMatched:Boolean;
//         DocumentNoMatched: Boolean;
//         ExternalDocumentNoMatched: Boolean;
//         TransactionDateMatched: Boolean;
//         RelatedPartyMatched: Boolean;
//         DescriptionMatched: Boolean;
//         Overwrite: Boolean;
//         ListOfMatchFields: Text;
//         MatchSummaryMsg: Label '%1 reconciliation lines out of %2 are matched.\\';
//         MatchDetailsTxt: Label 'This statement line matched the corresponding bank account ledger entry on the following fields: %1.', Comment = '%1 - a comma-separated list of field captions.';
//         MatchedManuallyTxt: Label 'This statement line was matched manually.';
//         MissingMatchMsg: Label 'Text shorter than %1 characters cannot be matched.';
//         ProgressBarMsg: Label 'Please wait while the operation is being completed.';
//         ManyToManyNotSupportedErr: Label 'Many-to-Many matchings are not supported';
//         PaymentTypeMatched: Boolean;
//         MemberShipNumMatched: Boolean;
//         CheckNumMatched: Boolean;
//         OverwriteExistingMatchesTxt: Label 'There are lines in this statement that are already matched with ledger entries.\\ Do you want to overwrite the existing matches?';
//         DateRange: Integer;
//         intDocCount: Integer;
//         FilterDate: Date;
//         CUMatchBank: Codeunit "Match Bank Rec. Lines";
//     begin
//         intDocCount := 1;
//         TempBankStatementMatchingBuffer.DeleteAll();

//         FilterDate := MatchCandidateFilterDate(BankAccountReco);

//         BankAccReconciliationLine.FilterBankRecLines(BankAccountReco);
//         BankAccReconciliationLine.SetFilter("Applied Entries", '<>%1', 0);
//         if BankAccReconciliationLine.FindSet() then
//             Overwrite := ConfirmManagement.GetResponseOrDefault(OverwriteExistingMatchesTxt, false);

//         if not Overwrite then
//             BankRecMatchCandidates.SetRange(Rec_Line_Applied_Entries, 0)
//         else begin
//             BankAccReconciliationLine.Reset();
//             BankAccReconciliationLine.SetFilter("Bank Account No.", BankAccountReco."Bank Account No.");
//             BankAccReconciliationLine.SetFilter("Statement No.", BankAccountReco."Statement No.");
//             RemoveMatchesFromRecLines(BankAccReconciliationLine);
//         end;

//         Window.Open(ProgressBarMsg);
//         CountMatchCandidates := 0;
//         SetMatchLengthTreshold(4);
//         SetNormalizingFactor(10);
//         BankRecMatchCandidates.SetRange(Rec_Line_Bank_Account_No, BankAccountReco."Bank Account No.");
//         BankRecMatchCandidates.SetRange(Rec_Line_Statement_No, BankAccountReco."Statement No.");

//         if FilterDate <> 0D then
//             BankRecMatchCandidates.SetFilter(Posting_Date, '<=' + Format(FilterDate));
//         if BankRecMatchCandidates.Open then
//             while BankRecMatchCandidates.Read do begin
//                 CountMatchCandidates += 1;
//                 Score := CalculateMatchScore(BankRecMatchCandidates, DateRange);

//                 if Score > 2 then begin
//                     TempBankStatementMatchingBuffer.AddMatchCandidate(BankRecMatchCandidates.Rec_Line_Statement_Line_No,
//                       BankRecMatchCandidates.Entry_No, Score, "Gen. Journal Account Type"::"G/L Account", '');

//                     AmountMatched := (BankRecMatchCandidates.Rec_Line_Difference = BankRecMatchCandidates.Remaining_Amount);
//                    // UtrnoMatched:=(BankRecMatchCandidates.UTR_No=BankRecMatchCandi)
//                     TransactionDateMatched := (BankRecMatchCandidates.Rec_Line_Transaction_Date = BankRecMatchCandidates.Posting_Date);
//                     RelatedPartyMatched := (GetDescriptionMatchScore(BankRecMatchCandidates.Rec_Line_RltdPty_Name, BankRecMatchCandidates.Description, BankRecMatchCandidates.Document_No, BankRecMatchCandidates.External_Document_No) > 0);

//                     if (BankRecMatchCandidates.Check_No_ <> '') Or (BankRecMatchCandidates.Cheque_No_ <> '') then
//                         CheckNumMatched := (BankRecMatchCandidates.Check_No_ = BankRecMatchCandidates.Cheque_No_);

//                     DocumentNoMatched := (RecordMatchMgt.CalculateStringNearness(BankRecMatchCandidates.Rec_Line_Description, BankRecMatchCandidates.Document_No, GetMatchLengthTreshold(), GetNormalizingFactor()) = GetNormalizingFactor()) or (RecordMatchMgt.CalculateStringNearness(BankRecMatchCandidates.Rec_Line_Transaction_Info, BankRecMatchCandidates.Document_No, GetMatchLengthTreshold(), GetNormalizingFactor()) = GetNormalizingFactor());
//                     ExternalDocumentNoMatched := (RecordMatchMgt.CalculateStringNearness(BankRecMatchCandidates.Rec_Line_Description, BankRecMatchCandidates.External_Document_No, GetMatchLengthTreshold(), GetNormalizingFactor()) = GetNormalizingFactor()) or (RecordMatchMgt.CalculateStringNearness(BankRecMatchCandidates.Rec_Line_Transaction_Info, BankRecMatchCandidates.External_Document_No, GetMatchLengthTreshold(), GetNormalizingFactor()) = GetNormalizingFactor());
//                     DescriptionMatched := (RecordMatchMgt.CalculateStringNearness(BankRecMatchCandidates.Rec_Line_Description, BankRecMatchCandidates.Description, GetMatchLengthTreshold(), GetNormalizingFactor()) >= 0.8 * GetNormalizingFactor()) or (RecordMatchMgt.CalculateStringNearness(BankRecMatchCandidates.Rec_Line_Transaction_Info, BankRecMatchCandidates.Description, GetMatchLengthTreshold(), GetNormalizingFactor()) >= 0.8 * GetNormalizingFactor());

//                     ListOfMatchFields := ListOfMatchedFields(AmountMatched, CheckNumMatched, PaymentTypeMatched, MemberShipNumMatched, DocumentNoMatched, ExternalDocumentNoMatched, TransactionDateMatched, RelatedPartyMatched, DescriptionMatched);

//                     TempBankStatementMatchingBuffer."Match Details" := StrSubstNo(MatchDetailsTxt, ListOfMatchFields);
//                     TempBankStatementMatchingBuffer.Modify();
//                 end;
//             end;

//         SaveOneToOneMatching(TempBankStatementMatchingBuffer, BankAccountReco."Bank Account No.",
//           BankAccountReco."Statement No.");

//         Window.Close;
//         ShowMatchSummary(BankAccountReco);
//     end;

//     local procedure GetDescriptionMatchScore(RelatedPartyName: Text; Description: Text; DocumentNo: Text; ExternalDocumentNo: Text): Integer
//     begin
//         // Implement logic for matching score calculation based on description, related party name, document no, and external document no
//         // Placeholder implementation:
//         exit(10); // Return a constant score as an example
//     end;

//     local procedure SaveOneToOneMatching(var TempBankStatementMatchingBuffer: Record "Bank Statement Matching Buffer" temporary; BankAccountNo: Code[20]; StatementNo: Code[20])
//     var
//         BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
//         BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
//         PaymentMatchingDetails: Record "Payment Matching Details";
//         BankAccEntrySetReconNo: Codeunit "Bank Acc. Entry Set Recon.-No.";
//         Relation: Option "One-to-One","One-to-Many","Many-to-One";
//     begin
//         TempBankStatementMatchingBuffer.Reset();
//         TempBankStatementMatchingBuffer.SetCurrentKey(Quality);
//         TempBankStatementMatchingBuffer.Ascending(false);

//         if TempBankStatementMatchingBuffer.FindSet then
//             repeat
//                 BankAccountLedgerEntry.Get(TempBankStatementMatchingBuffer."Entry No.");
//                 BankAccReconciliationLine.Get(
//                   BankAccReconciliationLine."Statement Type"::"Bank Reconciliation",
//                   BankAccountNo, StatementNo,
//                   TempBankStatementMatchingBuffer."Line No.");
//                 if BankAccEntrySetReconNo.ApplyEntries(BankAccReconciliationLine, BankAccountLedgerEntry, Relation::"One-to-One") then
//                     PaymentMatchingDetails.CreatePaymentMatchingDetail(BankAccReconciliationLine, TempBankStatementMatchingBuffer."Match Details");
//             until TempBankStatementMatchingBuffer.Next() = 0;
//     end;

//     local procedure ListOfMatchedFields(AmountMatched: Boolean; CheckNumMatched: Boolean; PaymentTypeMatched: Boolean; MembershipNumMatched: Boolean; DocumentNoMatched: Boolean; ExternalDocumentNoMatched: Boolean; TransactionDateMatched: Boolean; RelatedPartyMatched: Boolean; DescriptionMatched: Boolean): Text
//     var
//         BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
//         ListOfFields: Text;
//         Comma: Text;
//     begin
//         Comma := ', ';
//         if AmountMatched then
//             ListOfFields += BankAccountLedgerEntry.FieldCaption(BankAccountLedgerEntry."Remaining Amount");

//         if DocumentNoMatched then begin
//             if ListOfFields <> '' then
//                 ListOfFields += Comma;
//             ListOfFields += BankAccountLedgerEntry.FieldCaption(BankAccountLedgerEntry."Document No.");
//         end;

//         // if CheckNumMatched then begin
//         //     if ListOfFields <> '' then
//         //         ListOfFields += Comma;
//         //     ListOfFields += BankAccountLedgerEntry.FieldCaption(BankAccountLedgerEntry."Check No.");
//         // end;

//         if ExternalDocumentNoMatched then begin
//             if ListOfFields <> '' then
//                 ListOfFields += Comma;
//             ListOfFields += BankAccountLedgerEntry.FieldCaption(BankAccountLedgerEntry."External Document No.");
//         end;

//         if TransactionDateMatched then begin
//             if ListOfFields <> '' then
//                 ListOfFields += Comma;
//             ListOfFields += BankAccountLedgerEntry.FieldCaption(BankAccountLedgerEntry."Posting Date");
//         end;

//         if RelatedPartyMatched then begin
//             if ListOfFields <> '' then
//                 ListOfFields += Comma;
//             ListOfFields += BankAccountLedgerEntry.FieldCaption(BankAccountLedgerEntry.Description);
//         end;

//         if DescriptionMatched then begin
//             if ListOfFields <> '' then
//                 ListOfFields += Comma;
//             ListOfFields += BankAccountLedgerEntry.FieldCaption(BankAccountLedgerEntry.Description);
//         end;

//         exit(ListOfFields);
//     end;

//     local procedure CalculateMatchScore(BankRecMatchCandidates: Query "Bank_Reco_Matching"; DateRange: Integer): Integer
//     var
//         RecDateDifference: Integer;
//     begin
//         RecDateDifference := CalculateDateDifference(BankRecMatchCandidates.Rec_Line_Transaction_Date, BankRecMatchCandidates.Posting_Date);
//         if RecDateDifference <= DateRange then
//             exit(GetNormalizingFactor() - RecDateDifference);
//         exit(0);
//     end;

//     local procedure CalculateDateDifference(Date1: Date; Date2: Date): Integer
//     begin
//         exit(Date1 - Date2);
//     end;

//     local procedure GetMatchLengthTreshold(): Integer
//     begin
//         exit(4);
//     end;

//     local procedure SetMatchLengthTreshold(Value: Integer)
//     begin
//         // Placeholder for setting match length threshold logic
//     end;

//     local procedure GetNormalizingFactor(): Integer
//     begin
//         exit(10);
//     end;

//     local procedure SetNormalizingFactor(Value: Integer)
//     begin
//         // Placeholder for setting normalizing factor logic
//     end;

//     local procedure MatchCandidateFilterDate(BankAccountReco: Record "Bank Acc. Reconciliation"): Date
//     begin
//         // Placeholder for logic to determine filter date for match candidates
//         exit(0D);
//     end;

//     local procedure RemoveMatchesFromRecLines(var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line")
//     begin
//         // Placeholder for logic to remove matches from reconciliation lines
//     end;

//     local procedure ShowMatchSummary(BankAccountReco: Record "Bank Acc. Reconciliation")
//     begin
//         // Placeholder for logic to show match summary
//     end;
// }
