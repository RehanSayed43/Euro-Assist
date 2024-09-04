// XmlPort 50113 "BRS3"
// {
//     FieldDelimiter = '<None>';
//     FieldSeparator = ',';
//     Format = VariableText;



//     schema
//     {
//         textelement(Root)
//         {
//             tableelement("Bank Acc. Reconciliation Line"; "Bank Acc. Reconciliation Line")
//             {
//                 XmlName = 'BankAccRecoLine';
//                 AutoSave = false;
//                 textelement(BankAccNo)
//                 {
//                 }
//                 textelement(BankstatementNo)
//                 {
//                 }

//                 textelement(Transactiondate)
//                 {
//                 }
//                 textelement(Description)
//                 {
//                 }

//                 textelement(ValueDate)
//                 {
//                 }
//                 textelement(EntryNos)
//                 {
//                     MinOccurs = Zero;
//                 }
//                 textelement(UtrNos)
//                 {
//                     MinOccurs = Zero;
//                 }
//                 textelement(DAmount)
//                 {
//                     MinOccurs = Zero;

//                 }
//                 textelement(CAmount)
//                 {
//                     MinOccurs = Zero;
//                 }



//                 trigger OnAfterInsertRecord()
//                 var
//                     bankAccRecoLine: Record "Bank Acc. Reconciliation Line";
//                     bankAccRecoLine1: Record "Bank Acc. Reconciliation Line";
//                     BankAccReco: record "Bank Acc. Reconciliation";

//                     TransactionDate1: date;
//                     valuedate1: date;
//                     Amount1: Decimal;
//                     LineNo: Integer;
//                     Entry: Integer;

//                 begin
//                     //cnt := cnt + 1;
//                     //if cnt > 1 then begin
//                     if CAmount = '' then
//                         CAmount := '0';
//                     if DAmount = '' then
//                         DAmount := '0';
//                     BankAccReco.Reset();
//                     BankAccReco.SetRange("Bank Account No.", BankAccNo);
//                     BankAccReco.SetRange("Statement No.", BankstatementNo);
//                     if BankAccReco.Find('-') then begin
//                         bankAccRecoLine.Reset();
//                         bankAccRecoLine.SetRange("Bank Account No.", BankAccNo);
//                         bankAccRecoLine.SetRange("Statement No.", BankstatementNo);
//                         if bankAccRecoLine.FindLast then
//                             LineNo := bankAccRecoLine."Statement Line No." + 10000
//                         else
//                             LineNo := 10000;


//                         bankAccRecoLine1.Init();
//                         bankAccRecoLine1.validate("Bank Account No.", BankAccNo);
//                         bankAccRecoLine1.validate("Statement No.", BankstatementNo);
//                         bankAccRecoLine1.validate("Statement Line No.", LineNo);
//                         Evaluate(TransactionDate1, Transactiondate);
//                         bankAccRecoLine1.validate("Transaction Date", Transactiondate1);
//                         bankAccRecoLine1.Validate(Description, Description);
//                         //bankAccRecoLine1.Validate("Entry No", EntryNos);
//                         bankAccRecoLine1.Validate("UTR No", UtrNos);
//                         //  bankAccRecoLine1.Validate("NEFT/RTGS", neftno);
//                         Evaluate(valuedate1, ValueDate);
//                         bankAccRecoLine1.Validate("Value Date", valuedate1);
//                         Evaluate(Entry, EntryNos);
//                         bankAccRecoLine1.Validate("Entry No", Entry);
//                         Evaluate(Amount1, CAmount);
//                         if Amount1 > 0 then
//                             bankAccRecoLine1.Validate("Statement Amount", -Amount1);
//                         Evaluate(Amount1, DAmount);
//                         if Amount1 > 0 then
//                             bankAccRecoLine1.Validate("Statement Amount", Amount1);

//                         bankAccRecoLine1.Insert();
//                     end

//                 end;
//                 //End;
//             }
//         }
//     }

//     requestpage
//     {

//         layout
//         {
//         }

//         actions
//         {
//         }
//     }

//     var
//         PurchaseLine2: Record "Purchase Line";
//         TypeOfDocumentING: Integer;
//         DocumentTypeINT: Integer;
//         NoSeriesMgt: Codeunit NoSeriesManagement;
//         OrderDateFormat: Date;
//         PurchasesPayablesSetup: Record "Purchases & Payables Setup";
//         LineNo: Integer;
//         AllocShare: Decimal;
//         PurchaseOrderNo: Code[50];
//         NewDimSetID: Integer;
//         DimMngt: Codeunit DimensionManagement;
//         PurchaseHeader: Record "Purchase Header";
//         UserSetup: Record "User Setup";
//         ApprovalsMgmt: Codeunit "Approvals Mgmt.";
//         ReleasePurchDoc: Codeunit "Release Purchase Document";
//         ArchiveManagement: Codeunit ArchiveManagement;

//         No2: text;
//         cnt: integer;


// }
