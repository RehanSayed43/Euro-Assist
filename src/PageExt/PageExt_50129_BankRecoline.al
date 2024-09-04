pageextension 50129 MyExtension extends "Bank Acc. Reconciliation Lines"
{
    layout
    {
        addafter("Applied Amount")
        {
            field("Statement Type"; Rec."Statement Type")
            {
                ApplicationArea = all;
            }

            field("Bank Account No."; Rec."Bank Account No.")
            {
                ApplicationArea = all;
            }
            field("Statement No."; Rec."Statement No.")
            {
                ApplicationArea = all;
            }
            // }
            // field("Transaction Date";Rec."Transaction Date")
            // {
            //    ApplicationArea=all;
            // }
            field("Entry No"; Rec."Entry No")
            {
                StyleExpr = CustomStyleTxt;
                ApplicationArea = all;
            }
            field("UTR No"; Rec."UTR No")
            {
                StyleExpr = CustomStyleTxt;

                ApplicationArea = all;
                //  Editable = false;
            }
            field("Dr Amount"; Rec."Dr Amount")
            {
                ApplicationArea = all;
            }
            field("Cr Amount"; Rec."Cr Amount")
            {
                ApplicationArea = all;
                // AutoFormatExpression = GetCurrencyCode();
                // AutoFormatType = 1;
                Caption = 'Credit  Amount';

                trigger OnValidate()
                begin

                    // Rec.Difference := Rec."Cr Amount" - Rec."Applied Amount";
                end;
            }

        }
        addafter(Difference)
        {
            field("UTR/Entry No Match"; Rec."UTR/Entry No Match")
            {
                ApplicationArea = all;
            }
        }
        modify("Statement Amount")
        {
            Editable = false;
        }
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;


        CustomStyleTxt: Text;

    trigger OnAfterGetRecord()
    var
        myInt: Integer;
    begin
        GetStyleExpression()
    end;

    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
    begin
        GetStyleExpression()
    end;

    local procedure GetStyleExpression()
    var
        myInt: Integer;
    begin
        CustomStyleTxt := Rec.GetStyle();
    end;
}