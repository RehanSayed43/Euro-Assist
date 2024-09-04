pageextension 50141 bankAccReconciliationPageExt extends "Bank Acc. Reconciliation"
{

    layout
    {
        addafter(BalanceLastStatement)
        {

            field(SentEmail; Rec.SentEmail)
            {
                Editable = not EnableAction;
                ApplicationArea = all;



            }
        }

    }
    actions
    {
        addafter("&Card")
        {


        }

        modify(MatchAutomatically)
        {
            Visible = true;
        }
        addafter(MatchDetails)
        {
            //     action(MatchAutomatic)
            //     {
            //         ApplicationArea = basic, suite;
            //         Caption = 'Match AutomaticallyR';

            //         Enabled = true;
            //         Visible = true;
            //         Promoted = true;

            //         Image = MapAccounts;
            //         ToolTip = 'Automatically search for and match bank statement lines.';

            //         trigger OnAction()
            //         var
            //             bankaccledger: Record "Bank Account Ledger Entry";
            //             bankaccrecline: Record "Bank Acc. Reconciliation Line";
            //         begin
            //             Rec.SetRange("Statement Type", Rec."Statement Type");
            //             Rec.SetRange("Bank Account No.", Rec."Bank Account No.");
            //             Rec.SetRange("Statement No.", Rec."Statement No.");

            //             bankaccledger.SetRange("Bank Account No.", Rec."Bank Account No.");
            //             bankaccledger.SetRange("Statement No.", Rec."Statement No.");

            //             if bankaccrecline.FindSet() then begin
            //                 repeat
            //                     bankaccledger.SetRange("Entry No.", bankaccrecline."Entry No");
            //                     bankaccledger.SetRange("UTR No.", bankaccrecline."UTR No");
            //                     bankaccledger.SetRange("Credit Amount", bankaccrecline."Cr Amount");
            //                     bankaccledger.SetRange("Debit Amount", bankaccrecline."Dr Amount");
            //                     if bankaccledger.FindFirst() then begin
            //                         bankaccrecline.Matchingstatus := true;
            //                         bankaccrecline.Modify();

            //                     end;
            //                 until bankaccrecline.Next() = 0;
            //             end;
            //             REPORT.Run(REPORT::MatchBankEntriesReport, true, true, Rec);
            //             //Report.Run(Report::"Match Bank Entries", true, true, Rec);
            //         end;
            //     }


        }


        addafter(ChangeStatementNo)
        {

            action("Import BankReco Lines.")
            {
                ApplicationArea = All;
                Promoted = true;
                Visible = true;
                Enabled = true;

                trigger OnAction()
                begin
                    Xmlport.Run(50123);
                end;
            }
            action("Send Report Email")
            {
                ApplicationArea = All;
                Enabled = true;
                Visible = false;
                Promoted = true;

                trigger OnAction()
                var
                    Recodeunit: Codeunit 50111;
                    BankReco: Record "Bank Acc. Reconciliation";
                begin
                    Recodeunit.SentMailAttachmnet(Rec."Statement Type", Rec."Bank Account No.", Rec."Statement No.");

                end;
            }
            action(Remove)
            {
                ApplicationArea = All;
                Visible = true;
                Promoted = true;
                trigger OnAction()
                begin
                    Rec.SentEmail := false;
                    Rec.Modify()
                end;
            }



        }
    }
    var
        EnableAction: Boolean;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        EnableAction := Rec.SentEmail;
        CurrPage.Update();
        CurrPage.SaveRecord();
    end;


}
