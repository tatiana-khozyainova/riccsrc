unit FormReports;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonObjectSelectFilter, FormEvent, FrameReportsAttribute,
  FrameReportsView, ActnList, Grids, ImgList, StdCtrls, 
  FrameReportsBut, BaseObjects, Material;

type
  TfrmReports = class(TForm)
    frmbjctslct: TfrmObjectSelect;
    frmReportsView: TfrmReportsView;
    frmReportsAtrtribute: TfrmReportsAtrtribute;
    actlstReports: TActionList;
    actReportsGridView: TAction;
    il1: TImageList;
    actClose: TAction;
    btnReportsGridView: TButton;
    btnClose: TButton;
    actAddAtr: TAction;
    actAtrUp: TAction;
    actAtrDown: TAction;
    actAtrDel: TAction;
    btnExcel: TButton;
    actExcel: TAction;
    actAddAllAtr: TAction;
    actAtrAllDel: TAction;
    txtInstruction: TStaticText;
    lbl1: TLabel;

    procedure actAddAllAtrExecute(Sender: TObject);
    procedure actAddAtrExecute(Sender: TObject);
    procedure actAtrAllDelExecute(Sender: TObject);
    procedure actAtrDelExecute(Sender: TObject);
    procedure actAtrDownExecute(Sender: TObject);
    procedure actAtrUpExecute(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure actExcelExecute(Sender: TObject);
    procedure actReportsGridViewExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure frmReportsViewstrngrdDrawCell(Sender: TObject; ACol, ARow: Integer;
        Rect: TRect; State: TGridDrawState);
    procedure frmReportsViewstrngrdMouseDown(Sender: TObject; Button: TMouseButton;
        Shift: TShiftState; X, Y: Integer);



  private
    { Private declarations }
    FOnMyEvent:TMyEvent;
    FLenText:Integer;
    Fflag:Boolean;
    FSimplDocSelection:TSimpleDocuments;
  public
    { Public declarations }
    procedure   ReloadData(Sender: TObject);
    procedure ColumnWidthAlign(Sg: TStringGrid; ColNum : Integer);
    procedure RowHightAlign(Sg: TStringGrid;RowNum: Integer);
    property OnMyEvent:TMyEvent read FOnMyEvent write FOnMyEvent;
    property LenText:Integer read FLenText write FLenText;
    property SimplDocSelection: TSimpleDocuments read FSimplDocSelection write FSimplDocSelection;
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmReports: TfrmReports;

implementation

uses Facade, SeisWorkReport;
{$R *.dfm}

constructor TfrmReports.Create(AOwner: TComponent);
var i:Integer;
begin
  inherited;
  
  Lentext:=50;
  (TMainFacade.GetInstance as TMainFacade).Filter := '';


  frmbjctslct.OnReloadData := ReloadData;


end;



procedure TfrmReports.actAddAllAtrExecute(Sender: TObject);
var i,j:Integer;
begin
while frmReportsAtrtribute.lstAllAttribute.Count<>0 do
begin
frmReportsAtrtribute.lstCurrentAttribute.Items.AddObject(frmReportsAtrtribute.lstAllAttribute.Items.Strings[0],frmReportsAtrtribute.lstAllAttribute.Items.Objects[0]);
frmReportsAtrtribute.lstAllAttribute.Items.Delete(0);
end;
frmReportsAtrtribute.lstCurrentAttribute.ItemIndex:=0;
end;

procedure TfrmReports.actAddAtrExecute(Sender: TObject);
var i:Integer;flag:Boolean;
begin
if frmReportsAtrtribute.lstAllAttribute.ItemIndex>-1 then
begin
i:=frmReportsAtrtribute.lstAllAttribute.ItemIndex;
frmReportsAtrtribute.lstCurrentAttribute.Items.AddObject(frmReportsAtrtribute.lstAllAttribute.Items.Strings[frmReportsAtrtribute.lstAllAttribute.ItemIndex],frmReportsAtrtribute.lstAllAttribute.Items.Objects[frmReportsAtrtribute.lstAllAttribute.ItemIndex]);
frmReportsAtrtribute.lstAllAttribute.Items.Delete(frmReportsAtrtribute.lstAllAttribute.ItemIndex);
frmReportsAtrtribute.lstAllAttribute.ItemIndex:=i;
end;
end;

procedure TfrmReports.actAtrAllDelExecute(Sender: TObject);
var i:Integer;
begin
while frmReportsAtrtribute.lstCurrentAttribute.Count<>0 do
begin
frmReportsAtrtribute.lstAllAttribute.Items.AddObject(frmReportsAtrtribute.lstCurrentAttribute.Items.Strings[0],frmReportsAtrtribute.lstCurrentAttribute.Items.Objects[0]);
frmReportsAtrtribute.lstCurrentAttribute.Items.Delete(0);
end;
frmReportsAtrtribute.lstAllAttribute.ItemIndex:=0;
end;

procedure TfrmReports.actAtrDelExecute(Sender: TObject);
var i:Integer;
begin
if frmReportsAtrtribute.lstCurrentAttribute.ItemIndex>-1 then
begin
i:=frmReportsAtrtribute.lstCurrentAttribute.ItemIndex;
frmReportsAtrtribute.lstAllAttribute.Items.AddObject(frmReportsAtrtribute.lstCurrentAttribute.Items.Strings[frmReportsAtrtribute.lstCurrentAttribute.ItemIndex],frmReportsAtrtribute.lstCurrentAttribute.Items.Objects[frmReportsAtrtribute.lstCurrentAttribute.ItemIndex]);
frmReportsAtrtribute.lstCurrentAttribute.Items.Delete(frmReportsAtrtribute.lstCurrentAttribute.ItemIndex);
frmReportsAtrtribute.lstCurrentAttribute.ItemIndex:=i;
end;
end;

procedure TfrmReports.actAtrDownExecute(Sender: TObject);
var i,ibuf:Integer;strbuf:string;obuf:TObject;
begin
  obuf:=TObject.Create;
  if frmReportsAtrtribute.lstCurrentAttribute.ItemIndex<frmReportsAtrtribute.lstCurrentAttribute.Count-1 then
  begin
    obuf:=frmReportsAtrtribute.lstCurrentAttribute.Items.Objects[frmReportsAtrtribute.lstCurrentAttribute.ItemIndex+1];
    strbuf:=frmReportsAtrtribute.lstCurrentAttribute.Items.Strings[frmReportsAtrtribute.lstCurrentAttribute.ItemIndex+1];
    ibuf:=frmReportsAtrtribute.lstCurrentAttribute.ItemIndex+1;
    frmReportsAtrtribute.lstCurrentAttribute.Items.InsertObject(frmReportsAtrtribute.lstCurrentAttribute.ItemIndex,strbuf,obuf);
    frmReportsAtrtribute.lstCurrentAttribute.Items.Delete(frmReportsAtrtribute.lstCurrentAttribute.ItemIndex+1);
    frmReportsAtrtribute.lstCurrentAttribute.ItemIndex:=ibuf;
  end;
end;

procedure TfrmReports.actAtrUpExecute(Sender: TObject);
var i,ibuf:Integer;strbuf:string;obuf:TObject;
begin
obuf:=TObject.Create;
if frmReportsAtrtribute.lstCurrentAttribute.ItemIndex>0 then
begin
obuf:=frmReportsAtrtribute.lstCurrentAttribute.Items.Objects[frmReportsAtrtribute.lstCurrentAttribute.ItemIndex];
strbuf:=frmReportsAtrtribute.lstCurrentAttribute.Items.Strings[frmReportsAtrtribute.lstCurrentAttribute.ItemIndex];
ibuf:=frmReportsAtrtribute.lstCurrentAttribute.ItemIndex;
frmReportsAtrtribute.lstCurrentAttribute.Items.InsertObject(frmReportsAtrtribute.lstCurrentAttribute.ItemIndex-1,strbuf,obuf);
frmReportsAtrtribute.lstCurrentAttribute.Items.Delete(frmReportsAtrtribute.lstCurrentAttribute.ItemIndex);
frmReportsAtrtribute.lstCurrentAttribute.ItemIndex:=ibuf-1;
end;
end;

procedure TfrmReports.actCloseExecute(Sender: TObject);
begin
Close;
end;

procedure TfrmReports.actExcelExecute(Sender: TObject);
var i,j:Integer;
begin
for i:=1 to frmReportsView.strngrd.RowCount-1 do
if frmReportsView.strngrd.Objects[0,i]<>nil then
SimplDocSelection.Add(frmReportsView.strngrd.Objects[1,i] as TSimpleDocument);
(TMainFacade.GetInstance.AllReports.ReportByClassType[TSeisReport] as TSeisReport).ReportingObjects.Clear;
(TMainFacade.GetInstance.AllReports.ReportByClassType[TSeisReport]).ReportingObjects.AddObjects(SimplDocSelection, False, False);
(TMainFacade.GetInstance.AllReports.ReportByClassType[TSeisReport]).Execute;
SimplDocSelection.Clear;
  (TMainFacade.GetInstance.AllReports.ReportByClassType[TSeisReport] as TSeisReport).ReportingObjects.Clear;
end;

procedure TfrmReports.actReportsGridViewExecute(Sender: TObject);
var i,j,k,poz:Integer;strprof,strhead:string;pozmas:array[0..17] of Integer;MSExcel:OleVariant;
begin
  (TMainFacade.GetInstance.AllReports.ReportByClassType[TSeisReport] as TSeisReport).ReportingObjects.Clear;
  (TMainFacade.GetInstance.AllReports.ReportByClassType[TSeisReport] as TSeisReport).FieldList.AddStrings(frmReportsAtrtribute.lstCurrentAttribute.Items);
  (TMainFacade.GetInstance.AllReports.ReportByClassType[TSeisReport]).ReportingObjects.AddObjects(TMainFacade.GetInstance.AllSimpleDocuments, False, False);

  //(TMainFacade.GetInstance.AllReports.ReportByClassType[TSeisReport]).Execute;

if frmReportsView.Visible=False then
begin
frmReportsView.Visible:=True;
frmbjctslct.Visible:=False;
frmReportsAtrtribute.Visible:=False;
btnReportsGridView.Caption:='Назад';
txtInstruction.Visible:=true;
lbl1.Visible:=true;
btnExcel.Visible:=True;
frmReportsView.strngrd.RowCount:=TMainFacade.GetInstance.AllSimpleDocuments.Count+1;
frmReportsView.strngrd.ColCount:=19;
frmReportsView.strngrd.Cells[0,0]:='Выбр.все';
frmReportsView.strngrd.ColWidths[0]:=frmReportsView.strngrd.Canvas.TextWidth(frmReportsView.strngrd.Cells[0,0])+4;

(TMainFacade.GetInstance.AllReports.ReportByClassType[TSeisReport] as TSeisReport).MakeGrid(frmReportsView.strngrd);

for i:=1 to frmReportsView.strngrd.RowCount-1 do RowHightAlign(frmReportsView.strngrd,i);
for i:=1 to frmReportsView.strngrd.ColCount-1 do ColumnWidthAlign(frmReportsView.strngrd,i);
frmReportsView.strngrd.ColCount:=frmReportsAtrtribute.lstCurrentAttribute.Items.Count+1;
end
else
begin
frmReportsView.Visible:=False;
//frmReportsView.Align:=alNone;
//frmReportsView.strngrd.Align:=alclient;
frmbjctslct.Visible:=True;
frmReportsAtrtribute.Visible:=True;
btnExcel.Visible:=False;
txtInstruction.Visible:=False;
lbl1.Visible:=False;
btnReportsGridView.Caption:='Далее';
end;
end;



procedure TfrmReports.FormActivate(Sender: TObject);
begin
frmbjctslct.Prepare;
SimplDocSelection:=TSimpleDocuments.Create;
end;

procedure TfrmReports.ReloadData(Sender: TObject);
begin
  // здесь перезагружаем куда следует, что следует
  TMainFacade.GetInstance.Filter := frmbjctslct.SQL;
  TMainFacade.GetInstance.SkipSimpleDocuments;
  if Assigned(FOnMyEvent) then FOnMyEvent(Sender);
end;

procedure TfrmReports.ColumnWidthAlign(Sg: TStringGrid;ColNum: Integer);
var i,widthmax:Integer;
begin
widthmax:=sg.ColWidths[ColNum];
for i:=1 to sg.RowCount-1 do
begin
if widthmax<Sg.Canvas.TextWidth(Sg.Cells[ColNum,i]) then widthmax:=Sg.Canvas.TextWidth(Sg.Cells[ColNum,i]);
end;
if ((widthmax<6*Lentext)) then Sg.ColWidths[ColNum]:=widthmax+1 else Sg.ColWidths[ColNum]:=6*Lentext+5;
end;

procedure TfrmReports.RowHightAlign(Sg: TStringGrid;RowNum: Integer);
var i,heightmax:Integer;
begin
heightmax:=1;
for i:=1 to sg.ColCount-1 do
if ((Length(Sg.Cells[i,RowNum])div Lentext)+1)>heightmax then heightmax:=((Length(Sg.Cells[i,RowNum])div Lentext)+1);
Sg.RowHeights[RowNum]:=15*heightmax;
end;

procedure TfrmReports.frmReportsViewstrngrdDrawCell(Sender: TObject; ACol,
    ARow: Integer; Rect: TRect; State: TGridDrawState);
var i,rowh:Integer;str:string;icon:TPicture;
begin
if (ARow mod 2)=0 then frmReportsView.strngrd.Canvas.Brush.Color:=clwhite else frmReportsView.strngrd.Canvas.Brush.Color:=cl3DLight;
if ACol = 0 then frmReportsView.strngrd.Canvas.Brush.Color:=clMoneyGreen;
if ARow = 0 then frmReportsView.strngrd.Canvas.Brush.Color:=clMoneyGreen;
if (ACol=0) and (frmReportsView.strngrd.Objects[ACol,ARow]<>nil) then
begin

frmReportsView.strngrd.Canvas.Brush.Color:=clBlue;
end;
frmReportsView.strngrd.Canvas.FillRect(Rect);
for i:=1 to ((Length(frmReportsView.strngrd.Cells[ACol, ARow])div Lentext)+1) do
begin
str := Copy(frmReportsView.strngrd.Cells[ACol, ARow],((i-1)*Lentext+1),Lentext);
frmReportsView.strngrd.Canvas.TextOut(Rect.Left+1, Rect.Top+1 - (i - 1) * (frmReportsView.strngrd.Canvas.Font.Height-2), str);
end;
end;

procedure TfrmReports.frmReportsViewstrngrdMouseDown(Sender: TObject; Button:
    TMouseButton; Shift: TShiftState; X, Y: Integer);
var Col,Row,i:Integer;
begin
(Sender as TStringGrid).MouseToCell(X,Y,Col,Row);
if (Col=0) and (Row>0) and (frmReportsView.strngrd.Objects[Col,Row]=nil) then
frmReportsView.strngrd.Objects[Col,Row]:=TObject(1)
else
if (Col=0) and (Row>0) and (frmReportsView.strngrd.Objects[Col,Row]<>nil) then
frmReportsView.strngrd.Objects[Col,Row]:=nil;
if (Col=0) and (Row=0) and (frmReportsView.strngrd.Objects[Col,Row]=nil) then
for i:=0 to frmReportsView.strngrd.RowCount-1 do frmReportsView.strngrd.Objects[0,i]:=TObject(1)
else
if (Col=0) and (Row=0) and (frmReportsView.strngrd.Objects[Col,Row]<>nil) then
for i:=0 to frmReportsView.strngrd.RowCount-1 do frmReportsView.strngrd.Objects[0,i]:=nil;
end;



end.
