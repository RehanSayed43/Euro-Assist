// pageextension 50100 PageExt50100 extends "Bank Acc. Reconciliation"
// {
//     layout
//     {
//         // Add changes to page layout here
//     }

//     actions
//     {
//         modify(MatchAutomatically)
//         {
//             //Enabled = true;//vikas
//             //Visible = true;//Vikas
//             //CCIT AN ++
//             Visible = false;
//         }
//         modify(MatchManually)
//         {
//             Visible = false;
//         }
//         //CCIT AN --
//         addafter(ChangeStatementNo)
//         {
//             action(BRS)
//             {
//                 ApplicationArea = All;

//                 trigger OnAction()
//                 begin
//                     Xmlport.Run(50100);

//                 end;
//             }
//             action(MatchAutomatically_New)
//             {
//                 Enabled = true;
//                 Visible = true;
//                 Promoted = true;
//                 Caption = 'Match Automatically New';
//                 //PromotedCategory = Process; //Vikas
//                 PromotedCategory = Category5;
//                 ApplicationArea = Basic, Suite;
//                 // Ellipsis = true;
//                 PromotedIsBig = true;
//                 trigger OnAction()
//                 var
//                     CU_BankReco: Codeunit BankRecoAutoMatch;
//                     recBankStatmentBuff: Record "Bank Statement Matching Buffer";
//                 begin
//                     CU_BankReco.AddFilter_AutoMatch(0, recBankStatmentBuff, Rec);
//                 end;
//             }
//         }

//         /*addafter(NotMatched)
//         {
//             action(MatchAutomatically_New1)
//             {
//                 Enabled = true;
//                 Visible = true;
//                 Promoted = true;
//                 Caption = 'Match Automatically New';
//                 PromotedCategory = Process;
//                 ApplicationArea = Basic, Suite;
//                 // Ellipsis = true;
//                 PromotedIsBig = true;
//                 trigger OnAction()
//                 var
//                     CU_BankReco: Codeunit BankRecoAutoMatch;
//                     recBankStatmentBuff: Record "Bank Statement Matching Buffer";
//                 begin
//                     CU_BankReco.AddFilter_AutoMatch(0, recBankStatmentBuff, Rec);
//                 end;
//             }
//         }*/
//         // Add changes to page actions here
//     }

//     var
//         myInt: Integer;
// }