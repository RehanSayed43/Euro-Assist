report 50140 MatchBankEntriesReport
{
    //REHAN SAYED;
    Caption = 'Match Bank Entries';
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem("Bank Acc. Reconciliation"; "Bank Acc. Reconciliation")
        {
            DataItemTableView = SORTING("Bank Account No.", "Statement No.");

            trigger OnAfterGetRecord()
            begin

                MatchSingle(DateRange);
                // BankRecline.SetRange("Account No.", "Bank Acc. Reconciliation"."Bank Account No.");
                // BankRecline.SetRange("Statement No.", "Bank Acc. Reconciliation"."Statement No.");
                // BankRecline.SetRange("Statement Type", "Bank Acc. Reconciliation"."Statement Type");
                // if BankRecline.Difference = ' ' then begin
                //     CodeunitEmail.Run();

            end;


            // end;
            // if "Bank Acc. Reconciliation"."Total Difference" = 0 then begin
            //     CodeunitEmail.SentMailAttachmnet("Bank Acc. Reconciliation"."Statement Type", "Bank Acc. Reconciliation"."Statement No.", "Bank Acc. Reconciliation"."Bank Account No.");
            // end;


            //end;

            trigger OnPostDataItem()
            var
                myInt: Integer;
            begin
                // "Bank Acc. Reconciliation".SetRange("Statement Type", BankRecline."Statement Type");

                // if "Bank Acc. Reconciliation".FindFirst() then begin
                //     CodeunitEmail.SentMailAttachmnet("Bank Acc. Reconciliation"."Statement Type", "Bank Acc. Reconciliation"."Statement No.", "Bank Acc. Reconciliation"."Bank Account No.");

                // end;
                // CodeunitEmail.SentMailAttachmnet("Bank Acc. Reconciliation"."Statement Type", "Bank Acc. Reconciliation"."Statement No.", "Bank Acc. Reconciliation"."Bank Account No.");


            end;
        }

    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Control3)
                {
                    ShowCaption = false;

                    field(DateRange; DateRange)
                    {
                        ApplicationArea = Basic, Suite;
                        BlankZero = true;
                        Caption = 'Transaction Date Tolerance (Days)';
                        MinValue = 0;
                        ToolTip = 'Specifies the span of days before and after the bank account ledger entry posting date within which the function will search for matching transaction dates in the bank statement. If you enter 0 or leave the field blank, then the Match Automatically function will only search for matching transaction dates on the bank account ledger entry posting date.';
                    }
                }
            }
        }
        actions
        {
        }
    }
    labels
    {
    }
    var
        DateRange: Integer;
        BankLine: Record "Bank Acc. Reconciliation Line";
        CodeunitEmail: Codeunit 50111;
        GLAcc: Record "G/L Account";
        GLentry: Record "G/L Entry";
        BankLedger: Record "Bank Account Ledger Entry";
        BankRecline: Record "Bank Acc. Reconciliation Line";
        BankReco: Record "Bank Acc. Reconciliation";
}
