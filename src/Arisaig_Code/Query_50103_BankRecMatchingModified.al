// query 50112 Bank_Reco_Matching
// {
//     QueryType = Normal;
//     Caption = 'Bank Rec. Match Candidates';

//     elements
//     {
//         dataitem(Bank_Acc_Reconciliation_Line; "Bank Acc. Reconciliation Line")
//         {
//             DataItemTableFilter = Difference = FILTER(<> 0);

//             column(Rec_Line_Bank_Account_No; "Bank Account No.") { }
//             column(Rec_Line_Statement_No; "Statement No.") { }
//             column(Rec_Line_Statement_Line_No; "Statement Line No.") { }
//             column(Rec_Line_Transaction_Date; "Transaction Date") { }
//             column(Rec_Line_Description; Description) { }
//             column(Rec_Line_RltdPty_Name; "Related-Party Name") { }
//             column(Rec_Line_Transaction_Info; "Additional Transaction Info") { }
//             column(Rec_Line_Statement_Amount; "Statement Amount") { }
//             column(Rec_Line_Applied_Amount; "Applied Amount") { }
//             column(Rec_Line_Difference; Difference) { }
//             column(Check_No_; "Check No.") { }
//             column(Rec_Line_Applied_Entries; "Applied Entries") { }
//             column(UTR_No; "UTR No") { }
//             column(Entry_Nos; "Entry No") { }

//             dataitem(Bank_Account_Ledger_Entry; "Bank Account Ledger Entry")
//             {
//                 DataItemLink = "Bank Account No." = Bank_Acc_Reconciliation_Line."Bank Account No.",
//                                "Cheque No." = Bank_Acc_Reconciliation_Line."Check No.";


//                 DataItemTableFilter = "Remaining Amount" = FILTER(<> 0),
//                                       Open = const(true),
//                                       "Statement Status" = const(Open),
//                                       Reversed = const(false);

//                 column(Entry_No; "Entry No.") { }
//                 column(Bank_Account_No; "Bank Account No.") { }
//                 column(Posting_Date; "Posting Date") { }
//                 column(Document_No; "Document No.") { }
//                 column(Description; Description) { }
//                 column(Remaining_Amount; "Remaining Amount") { }
//                 column(Bank_Ledger_Entry_Open; Open) { }
//                 column(Statement_Status; "Statement Status") { }
//                 column(External_Document_No; "External Document No.") { }
//                 column(Cheque_No_; "Cheque No.") { }
//                 column(UTR_No_SS; "UTR No.") { }
//                 column(Entry_No_SS; "Entry No.") { }
//             }
//         }
//     }

//     var
//         myInt: Integer;

//     trigger OnBeforeOpen()
//     begin
//         // Any custom logic you want to add before the query opens
//     end;
// }
