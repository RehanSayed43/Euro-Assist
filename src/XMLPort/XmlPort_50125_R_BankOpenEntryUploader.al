XmlPort 50125 "BankUpload-OpenUpdate"
{
    // FieldDelimiter = '<None>';
    // FieldSeparator = ',';
    Format = VariableText;
    Permissions = tabledata "Bank Account Ledger Entry" = rmid;
    schema
    {
        textelement(Root)
        {
            tableelement("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
            {
                XmlName = 'BankAccLedgerEntry';
                AutoSave = false;

                textelement(Documentno)
                {
                    XmlName = 'EntryNo';
                }
                textelement(EntryNo)
                {
                    XmlName = 'Amount';
                }
                textelement(Open1)
                {
                    XmlName = 'UtrNo';
                }

                trigger OnBeforeInsertRecord()
                var
                    bankAccLedgerEntry: Record "Bank Account Ledger Entry";
                    ent: Integer;

                    myInt: Integer;
                begin
                    // bankAccLedgerEntry.SetRange("Document No.", Documentno);

                    // bankAccLedgerEntry.Validate("Document No.", Documentno);
                    if

                               //bankAccLedgerEntry.SetRange("Document No.",Documentno);
                               Evaluate(ent, EntryNo) then begin
                        if bankAccLedgerEntry.Get(ent) then begin
                            //  if bankAccLedgerEntry.Open = false then begin
                            Evaluate(openboolean, Open1);
                            bankAccLedgerEntry.Validate(Open, openboolean);
                            bankAccLedgerEntry.Modify();
                            // end;
                        end else begin
                            Error('Entry No. %1 does not exist in Bank Acc. Ledger Entry.', "Bank Account Ledger Entry"."Entry No.");
                        end;
                    end else begin
                        Error('Invalid Entry No.: %1', EntryNo);
                    end;

                    // if
                    // Evaluate(ent, Documentno)
                    //  then begin
                    //     if bankAccLedgerEntry.Get(ent) then begin
                    //         Evaluate(openboolean, Open1);
                    //         bankAccLedgerEntry.Validate(Open, openboolean);
                    //     end;
                    // end;

                end;

            }

        }


    }

    // trigger OnPostXmlPort()
    // var
    //     bankAccLedgerEntry: Record "Bank Account Ledger Entry";
    //     ent: Integer;

    //     myInt: Integer;
    // begin
    //     bankAccLedgerEntry.SetRange("Document No.", Documentno);

    //     bankAccLedgerEntry.Validate("Document No.", Documentno);
    //     if

    //                //bankAccLedgerEntry.SetRange("Document No.",Documentno);
    //                Evaluate(ent, EntryNo) then begin
    //         if bankAccLedgerEntry.Get(ent) then begin
    //             if bankAccLedgerEntry.Open = true then begin
    //                 Evaluate(openboolean, Open1);
    //                 bankAccLedgerEntry.Validate(Open, openboolean);
    //                 bankAccLedgerEntry.Modify();
    //             end;
    //         end else begin
    //             Error('Entry No. %1 does not exist in Bank Acc. Ledger Entry.', "Bank Account Ledger Entry"."Entry No.");
    //         end;
    //     end else begin
    //         Error('Invalid Entry No.: %1', EntryNo);
    //     end;

    //     if
    //     Evaluate(ent,Documentno)
    //      then
    //     begin
    //         if bankAccLedgerEntry.Get(ent) then
    //         begin
    //             Evaluate(openboolean,Open1);
    //             bankAccLedgerEntry.Validate(Open,openboolean);
    //         end;
    //     end;

    // end;

    //    requestpage
    // {
    //     layout
    //     {
    //     }

    //     actions
    //     {
    //     }
    // }

    var
        No2: Text;
        cnt: Integer;
        amt1: Decimal;
        entno: Integer;
        Amount2: Decimal;
        LineNo: Integer;
        openboolean: Boolean;
}
