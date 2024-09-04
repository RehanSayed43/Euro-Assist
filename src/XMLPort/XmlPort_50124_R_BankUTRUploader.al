XmlPort 50124 "BankUpload-UTRUpdate"
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

                textelement(EntryNo)
                {
                    XmlName = 'EntryNo';
                }
                textelement(Amount)
                {
                    XmlName = 'Amount';
                }
                textelement(UtrNo)
                {
                    XmlName = 'UtrNo';
                }
                trigger OnBeforeInsertRecord()
                var
                    bankAccLedgerEntry: Record "Bank Account Ledger Entry";
                    ent: Integer;
                    Amt: Decimal;

                    myInt: Integer;
                begin
                    // if
                    Evaluate(ent, EntryNo); //then begin
                    Clear(bankAccLedgerEntry);
                    if bankAccLedgerEntry.Get(ent) then begin
                        Evaluate(Amt, Amount);
                        if abs(bankAccLedgerEntry.Amount) = abs(Amt) then begin
                            if bankAccLedgerEntry.Open = true then begin
                                bankAccLedgerEntry.Validate("UTR No.", UtrNo);

                                bankAccLedgerEntry.Modify();
                            end;
                        end;
                    end else begin
                        Error('Entry No. %1 does not exist in Bank Acc. Ledger Entry.', "Bank Account Ledger Entry"."Entry No.");
                    end;
                    // end else begin
                    //     Error('Invalid Entry No.: %1', EntryNo);
                end;


            }
            // trigger OnAfterAssignVariable()
            // var
            //     bankAccLedgerEntry: Record "Bank Account Ledger Entry";
            //     ent: Integer;
            //     Amt: Decimal;
            //     myInt: Integer;
            // begin
            //     // if
            //     Evaluate(ent, EntryNo); //then begin
            //     Clear(bankAccLedgerEntry);
            //     if bankAccLedgerEntry.Get(ent) then begin
            //         Evaluate(Amt, Amount);
            //         if abs(bankAccLedgerEntry.Amount) = abs(Amt) then begin
            //             if bankAccLedgerEntry.Open = true then begin
            //                 bankAccLedgerEntry.Validate("UTR No.", UtrNo);

            //                 bankAccLedgerEntry.Modify();
            //             end;
            //         end;
            //     end else begin
            //         Error('Entry No. %1 does not exist in Bank Acc. Ledger Entry.', "Bank Account Ledger Entry"."Entry No.");
            //     end;
            //     // end else begin
            //     //     Error('Invalid Entry No.: %1', EntryNo);
            // end;
        }


    }

    // trigger OnPostXmlPort()
    // var
    //     bankAccLedgerEntry: Record "Bank Account Ledger Entry";
    //     ent: Integer;
    //     Amt: Decimal;

    //     myInt: Integer;
    // begin
    //     // if
    //     Evaluate(ent, EntryNo); //then begin
    //     Clear(bankAccLedgerEntry);
    //     if bankAccLedgerEntry.Get(ent) then begin
    //         Evaluate(Amt, Amount);
    //         if abs(bankAccLedgerEntry.Amount) = abs(Amt) then begin
    //             if bankAccLedgerEntry.Open = true then begin
    //                 bankAccLedgerEntry.Validate("UTR No.", UtrNo);

    //                 bankAccLedgerEntry.Modify();
    //             end;
    //         end;
    //     end else begin
    //         Error('Entry No. %1 does not exist in Bank Acc. Ledger Entry.', "Bank Account Ledger Entry"."Entry No.");
    //     end;
    //     // end else begin
    //     //     Error('Invalid Entry No.: %1', EntryNo);
    // end;

    // //end;



    var
        No2: Text;
        cnt: Integer;
        amt1: Decimal;
        entno: Integer;
        Amount2: Decimal;
        LineNo: Integer;
}
