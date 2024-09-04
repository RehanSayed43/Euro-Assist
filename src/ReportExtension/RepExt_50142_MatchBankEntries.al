reportextension 50142 MyExtension extends "Match Bank Entries"
{
    dataset
    {
        // dataitem(bqn)
        // {
        //     column(ColumnName; SourceFieldName)
        //     {

        //     }
        // }

        modify("Bank Acc. Reconciliation")
        {
            trigger OnAfterAfterGetRecord()

            begin

                // if BankLine.FindFirst() then
                //     if BankLine.Difference = 0 then begin

                //         Recodeunit.SentMailAttachmnet("Bank Acc. Reconciliation"."Statement Type", "Bank Acc. Reconciliation"."Bank Account No.", "Bank Acc. Reconciliation"."Statement No.");
                //         "Bank Acc. Reconciliation".SentEmail := true;
                //         "Bank Acc. Reconciliation".Modify()



                //     end;


            end;


        }

        // Add changes to dataitems and columns here
    }
    trigger OnPostReport()
    var
        myInt: Integer;
    begin


    end;

    // requestpage
    // {
    //     // Add changes to the requestpage here
    // }

    // rendering
    // {
    //     layout(LayoutName)
    //     {
    //         Type = RDLC;
    //         LayoutFile = 'mylayout.rdl';
    //     }
    // }
    var

        Recodeunit: Codeunit 50111;
        bank: Record "Bank Acc. Reconciliation";
        BankLine: Record "Bank Acc. Reconciliation Line";
}