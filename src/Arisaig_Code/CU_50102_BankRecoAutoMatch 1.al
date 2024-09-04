// codeunit 50102 BankRecoAutoMatch
// {
//     //ASHWINI   
//     trigger OnRun()
//     begin

//     end;

//     //  [EventSubscriber(ObjectType::Codeunit, Codeunit::"Match Bank Rec. Lines", 'OnAfterMatchBankRecLinesMatchSingle', '', false, false)]

//     procedure AddFilter_AutoMatch(CountMatchCandidates: Integer; TempBankStatementMatchingBuffer: Record "Bank Statement Matching Buffer" temporary
//         ; BankAccountReco: Record "Bank Acc. Reconciliation");
//     var //TempBankStatementMatchingBuffer: Record "Bank Statement Matching Buffer" temporary;
//         BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
//         RecordMatchMgt: Codeunit "Record Match Mgt.";
//         ConfirmManagement: Codeunit "Confirm Management";
//         BankRecMatchCandidates: Query "Bank_Reco_Matching";
//         Window: Dialog;
//         Score: Integer;
//         //CountMatchCandidates: Integer;
//         AmountMatched: Boolean;
//         DocumentNoMatched: Boolean;
//         ExternalDocumentNoMatched: Boolean;
//         TransactionDateMatched: Boolean;
//         RelatedPartyMatched: Boolean;
//         textDocString: Text;
//         DescriptionMatched: Boolean;
//         Overwrite: Boolean;
//         ListOfMatchFields: Text;
//         //BankAccReconciliation: Record "Bank Acc. Reconciliation";
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

//         // FilterDate := BankAccReconciliation.MatchCandidateFilterDate();
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

//     local procedure ListOfMatchedFields(AmountMatched: Boolean; ChecNumMatched: Boolean; PaymentTypeMatched: Boolean; MembershipNumMatched: Boolean; DocumentNoMatched: Boolean; ExternalDocumentNoMatched: Boolean; TransactionDateMatched: Boolean; RelatedPartyMatched: Boolean; DescriptionMatched: Boolean): Text
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

//         if ChecNumMatched then begin
//             if ListOfFields <> '' then
//                 ListOfFields += Comma;
//             ListOfFields += BankAccountLedgerEntry.FieldCaption(BankAccountLedgerEntry."Cheque No.");
//         end;


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

//         if RelatedPartyMatched or DescriptionMatched then begin
//             if ListOfFields <> '' then
//                 ListOfFields += Comma;
//             ListOfFields += BankAccountLedgerEntry.FieldCaption(BankAccountLedgerEntry.Description);
//         end;

//         exit(ListOfFields);
//     end;

//     local procedure RemoveMatchesFromRecLines(var SelectedBankAccReconciliationLine: Record "Bank Acc. Reconciliation Line")
//     var
//         BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
//         BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
//         CheckLedgEntry: Record "Check Ledger Entry";
//         BankAccRecMatchBuffer: Record "Bank Acc. Rec. Match Buffer";
//         BankAccEntrySetReconNo: Codeunit "Bank Acc. Entry Set Recon.-No.";
//         CheckEntrySetReconNo: Codeunit "Check Entry Set Recon.-No.";
//     begin
//         if SelectedBankAccReconciliationLine.FindSet() then
//             repeat
//                 BankAccReconciliationLine.Get(
//                   SelectedBankAccReconciliationLine."Statement Type",
//                   SelectedBankAccReconciliationLine."Bank Account No.",
//                   SelectedBankAccReconciliationLine."Statement No.",
//                   SelectedBankAccReconciliationLine."Statement Line No.");

//                 case BankAccReconciliationLine.Type of
//                     BankAccReconciliationLine.Type::"Bank Account Ledger Entry":

//                         begin
//                             BankAccountLedgerEntry.SetCurrentKey("Bank Account No.", Open);
//                             BankAccountLedgerEntry.SetRange("Bank Account No.", BankAccReconciliationLine."Bank Account No.");
//                             BankAccountLedgerEntry.SetRange("Statement No.", BankAccReconciliationLine."Statement No.");
//                             BankAccountLedgerEntry.SetRange("Statement Line No.", BankAccReconciliationLine."Statement Line No.");
//                             BankAccountLedgerEntry.SetRange(Open, true);
//                             BankAccountLedgerEntry.SetRange("Statement Status", BankAccountLedgerEntry."Statement Status"::"Bank Acc. Entry Applied");
//                             if BankAccountLedgerEntry.FindSet() then
//                                 repeat
//                                     BankAccEntrySetReconNo.RemoveApplication(BankAccountLedgerEntry);
//                                 until BankAccountLedgerEntry.Next() = 0;

//                             BankAccountLedgerEntry.Reset();
//                             BankAccReconciliationLine.FilterManyToOneMatches(BankAccRecMatchBuffer);
//                             if BankAccRecMatchBuffer.FindSet() then
//                                 repeat
//                                     BankAccountLedgerEntry.Get(BankAccRecMatchBuffer."Ledger Entry No.");
//                                     BankAccEntrySetReconNo.RemoveApplication(BankAccountLedgerEntry);
//                                 until BankAccRecMatchBuffer.Next() = 0;
//                         end;
//                     BankAccReconciliationLine.Type::"Check Ledger Entry":
//                         begin
//                             CheckLedgEntry.SetCurrentKey("Bank Account No.", Open);
//                             CheckLedgEntry.SetRange("Bank Account No.", BankAccReconciliationLine."Bank Account No.");
//                             CheckLedgEntry.SetRange("Statement No.", BankAccReconciliationLine."Statement No.");
//                             CheckLedgEntry.SetRange("Statement Line No.", BankAccReconciliationLine."Statement Line No.");
//                             CheckLedgEntry.SetRange("Statement Status", CheckLedgEntry."Statement Status"::"Check Entry Applied");
//                             CheckLedgEntry.SetRange(Open, true);
//                             if CheckLedgEntry.FindSet() then
//                                 repeat
//                                     CheckEntrySetReconNo.RemoveApplication(CheckLedgEntry);
//                                 until CheckLedgEntry.Next() = 0;
//                         end;
//                 end;
//             until SelectedBankAccReconciliationLine.Next() = 0;
//     end;

//     procedure MatchCandidateFilterDate(var BankAccReco: Record "Bank Acc. Reconciliation"): Date
//     var
//         BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
//         BankAccReconciliation: Record "Bank Acc. Reconciliation";
//     begin
//         BankAccReconciliationLine.SetRange("Statement Type", BankAccReco."Statement Type");
//         BankAccReconciliationLine.SetRange("Statement No.", BankAccReco."Statement No.");
//         BankAccReconciliationLine.SetRange("Bank Account No.", BankAccReco."Bank Account No.");
//         BankAccReconciliationLine.SetCurrentKey("Transaction Date");
//         BankAccReconciliationLine.Ascending := false;
//         if BankAccReconciliationLine.FindFirst() then
//             if BankAccReconciliationLine."Transaction Date" > BankAccReco."Statement Date" then
//                 exit(BankAccReconciliationLine."Transaction Date");

//         exit(BankAccReco."Statement Date");
//     end;

//     procedure SetMatchLengthTreshold(NewMatchLengthThreshold: Integer)
//     MatchLengthTreshold: Integer;
//     begin
//         MatchLengthTreshold := NewMatchLengthThreshold;
//     end;

//     procedure SetNormalizingFactor(NewNormalizingFactor: Integer)
//     NormalizingFactor: Integer;
//     begin
//         NormalizingFactor := NewNormalizingFactor;
//     end;

//     local procedure CalculateMatchScore(var BankRecMatchCandidates: Query "Bank_Reco_Matching"; DateRange: Integer): Integer
//     var
//         Score: Integer;
//     begin
//         if BankRecMatchCandidates.Rec_Line_Difference = BankRecMatchCandidates.Remaining_Amount then
//             Score += 13;

//         Score += GetDescriptionMatchScore(BankRecMatchCandidates.Rec_Line_Description, BankRecMatchCandidates.Description,
//             BankRecMatchCandidates.Document_No, BankRecMatchCandidates.External_Document_No);



//         Score += GetDescriptionMatchScore(BankRecMatchCandidates.Check_No_, BankRecMatchCandidates.Cheque_No_,
//          BankRecMatchCandidates.Document_No, BankRecMatchCandidates.External_Document_No);



//         Score += GetDescriptionMatchScore(BankRecMatchCandidates.Rec_Line_RltdPty_Name, BankRecMatchCandidates.Description,
//             BankRecMatchCandidates.Document_No, BankRecMatchCandidates.External_Document_No);

//         Score += GetDescriptionMatchScore(BankRecMatchCandidates.Rec_Line_Transaction_Info, BankRecMatchCandidates.Description,
//             BankRecMatchCandidates.Document_No, BankRecMatchCandidates.External_Document_No);

//         if BankRecMatchCandidates.Rec_Line_Transaction_Date <> 0D then
//             case true of
//                 BankRecMatchCandidates.Rec_Line_Transaction_Date = BankRecMatchCandidates.Posting_Date:
//                     Score += 1;
//                 Abs(BankRecMatchCandidates.Rec_Line_Transaction_Date - BankRecMatchCandidates.Posting_Date) > DateRange:
//                     Score := 0;
//             end;

//         exit(Score);
//     end;

//     local procedure GetDescriptionMatchScore(BankRecDescription: Text; BankEntryDescription: Text; DocumentNo: Code[20]; ExternalDocumentNo: Code[35]): Integer
//     var
//         RecordMatchMgt: Codeunit "Record Match Mgt.";
//         Nearness: Integer;
//         Score: Integer;
//         MatchLengthTreshold: Integer;
//         NormalizingFactor: Integer;
//     begin
//         BankRecDescription := RecordMatchMgt.Trim(BankRecDescription);
//         BankEntryDescription := RecordMatchMgt.Trim(BankEntryDescription);

//         MatchLengthTreshold := GetMatchLengthTreshold;
//         NormalizingFactor := GetNormalizingFactor;
//         Score := 0;

//         Nearness := RecordMatchMgt.CalculateStringNearness(BankRecDescription, DocumentNo,
//             MatchLengthTreshold, NormalizingFactor);
//         if Nearness = NormalizingFactor then
//             Score += 11;

//         Nearness := RecordMatchMgt.CalculateStringNearness(BankRecDescription, ExternalDocumentNo,
//             MatchLengthTreshold, NormalizingFactor);
//         if Nearness = NormalizingFactor then
//             Score += Nearness;

//         Nearness := RecordMatchMgt.CalculateStringNearness(BankRecDescription, BankEntryDescription,
//             MatchLengthTreshold, NormalizingFactor);
//         if Nearness >= 0.8 * NormalizingFactor then
//             Score += Nearness;

//         exit(Score);
//     end;

//     local procedure GetNormalizingFactor(): Integer
//     var
//         NormalizingFactor: Integer;
//     begin
//         exit(NormalizingFactor);
//     end;

//     local procedure GetMatchLengthTreshold(): Integer
//     var
//         MatchLengthTreshold: Integer;
//     begin
//         exit(MatchLengthTreshold);
//     end;
//     //MatchLengthTreshold: Integer;


//     [EventSubscriber(ObjectType::Page, Page::"Bank Acc. Reconciliation", 'OnOpenPageEvent', '', false, false)]

//     procedure AddFilter_AutoMatch1();
//     var
//     begin

//     end;

//     [EventSubscriber(ObjectType::Page, Page::"Bank Acc. Reconciliation", 'OnAfterActionEvent', 'MatchAutomatically', false, false)]

//     procedure AddFilter_AutoMatch12(var Rec: Record "Bank Acc. Reconciliation");
//     var
//         BankStatMatchBuffer: Record "Bank Statement Matching Buffer";
//     begin
//         AddFilter_AutoMatch(0, BankStatMatchBuffer, Rec);
//     end;

//     local procedure ShowMatchSummary(BankAccReconciliation: Record "Bank Acc. Reconciliation")
//     var
//         BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
//         FinalText: Text;
//         MissingMatchMsg: Label 'Text shorter than %1 characters cannot be matched.';
//         AdditionalText: Text;
//         TotalCount: Integer;
//         MatchedCount: Integer;
//         MatchSummaryMsg: Label '%1 reconciliation lines out of %2 are matched.\\';
//     begin
//         BankAccReconciliationLine.SetRange("Bank Account No.", BankAccReconciliation."Bank Account No.");
//         BankAccReconciliationLine.SetRange("Statement Type", BankAccReconciliation."Statement Type");
//         BankAccReconciliationLine.SetRange("Statement No.", BankAccReconciliation."Statement No.");
//         BankAccReconciliationLine.SetRange(Type, BankAccReconciliationLine.Type::"Bank Account Ledger Entry");
//         TotalCount := BankAccReconciliationLine.Count();
//         BankAccReconciliationLine.SetFilter("Applied Entries", '<>%1', 0);
//         MatchedCount := BankAccReconciliationLine.Count();

//         if MatchedCount < TotalCount then
//             AdditionalText := StrSubstNo(MissingMatchMsg, Format(GetMatchLengthTreshold));
//         FinalText := StrSubstNo(MatchSummaryMsg, MatchedCount, TotalCount) + AdditionalText;
//         Message(FinalText);

//     end;


//     [EventSubscriber(ObjectType::Page, Page::"Bank Account Ledger Entries", 'OnAfterGetRecordEvent', '', false, false)]
//     local procedure BankAccLedger()
//     var
//         i: Integer;
//     begin

//     end;


//     // end;

//     [EventSubscriber(ObjectType::Page, Page::"Bank Acc. Reconciliation", 'OnAfterGetRecordEvent', '', false, false)]
//     local procedure BankAccLedger1()
//     var
//         i: Integer;
//     begin

//     end;

//     var
//         myInt: Integer;
// }