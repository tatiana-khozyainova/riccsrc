unit CurveDictForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Facade, LasFile, ActnList, StdCtrls, Menus, Grids;

type
  TfrmCurveDict = class(TForm)
    MainMenu: TMainMenu;
    file1: TMenuItem;
    edtInput: TEdit;
    lblInput: TLabel;
    actlst: TActionList;
    actLoadCurves: TAction;
    strngrdCurves: TStringGrid;
    actFind: TAction;
    procedure FormShow(Sender: TObject);
    procedure edtInputChange(Sender: TObject);
  private
    FAllDictCurves : TCurves;
    function GetAllDictCurves : TCurves;
    { Private declarations }
  public
    property AllDictCurves: TCurves read GetAllDictCurves;
    function Find (Text:string) : Integer;
    { Public declarations }
  end;

var
  frmCurveDict: TfrmCurveDict;

implementation

{$R *.dfm}


function TfrmCurveDict.Find(Text: string): Integer;
var
  i:Integer;
  up1, up2 :string;
  res: Integer;
begin
  res:=0;
  if Assigned(AllDictCurves) then
  begin
  for i:=1 to AllDictCurves.Count-1 do
    begin
      up1 := AnsiUpperCase(AllDictCurves.Items[i].ShortName);
      up2 := AnsiUpperCase(Text);
      if (Pos(up2, up1) <> 0) then
        begin
        res:=i;
        Break;
        end;
    end;
  end;
Result:=res;
end;

procedure TfrmCurveDict.FormShow(Sender: TObject);
var
  i:Integer;
  cc : TCurveCategory;
  f : TForm;
begin
  strngrdCurves.RowCount:=1;
  strngrdCurves.ColCount:=3;
  strngrdCurves.ColWidths[1]:=400;
 with TMainFacade.GetInstance do
  for i := 1 to AllCurves.Count - 1 do
  begin
  strngrdCurves.RowCount := strngrdCurves.RowCount+1;
  strngrdCurves.Cells[0,i-1] := AllCurves.Items[i].ShortName;
  strngrdCurves.Cells[1,i-1] := AllCurves.Items[i].Name;
  strngrdCurves.Cells[2,i-1] := AllCurves.Items[i].CurveUnit;
  end;
end;

function TfrmCurveDict.GetAllDictCurves: TCurves;
begin
Result:=TMainFacade.GetInstance.AllCurves;
end;

procedure TfrmCurveDict.edtInputChange(Sender: TObject);
var
  pos:Integer;
  txt : string;
begin
  txt:=edtInput.Text;
if ( Length(txt)>0) then
  begin
  pos:=Find(edtInput.Text);
  if (pos>0) then
    begin
    strngrdCurves.Selection := TGridRect(rect(0, pos-1, 2, pos-1));
    strngrdCurves.TopRow := pos-1;
    end;
  end;
end;
end.



