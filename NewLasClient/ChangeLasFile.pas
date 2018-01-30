unit ChangeLasFileFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ActnList, Facade, LasFile, Well, Area, BaseObjects, CurveDictForm;

type
  TfrmAddChangeSaveLasFiles = class(TFrame)
    pgcMain: TPageControl;
    tsLink: TTabSheet;
    tsChange: TTabSheet;
    tsSave: TTabSheet;
    lstBxArea: TListBox;
    lstBxWells: TListBox;
    btnAddToWell: TButton;
    actlstPgcMain: TActionList;
    actLstBxAreaClick: TAction;
    actBtnAddToWell: TAction;
    lst1: TListBox;
    btnViewLasFile: TButton;
    actViewLasFile: TAction;
    btn1: TButton;
    btn2: TButton;
    procedure lstBxAreaClick(Sender: TObject);
    procedure actBtnAddToWellExecute(Sender: TObject);
    procedure actBtnAddToWellUpdate(Sender: TObject);
    procedure actViewLasFileExecute(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
  private
    { Private declarations }
    FOnSelectedWellChanged: TNotifyEvent;
    FSelectedLasFile : TLasFile;
    function GetSelectedWell: TWell;
    procedure SetSelectedLasFile(const Value: TLasFile);
  public
    { Public declarations }
    property OnWellSelected: TNotifyEvent read FOnSelectedWellChanged write FOnSelectedWellChanged;
    property SelectedWell: TWell read GetSelectedWell;
    property SelectedLasFile: TLasFile read FSelectedLasFile write SetSelectedLasFile;
  end;

implementation


{$R *.dfm}

procedure TfrmAddChangeSaveLasFiles.lstBxAreaClick(Sender: TObject);
var
 TmpArea : TIDObject;
begin
  TmpArea := (lstBxArea.Items.Objects [lstBxArea.ItemIndex]) as TIDObject;
  TMainFacade.GetInstance.LasFilter:= 'AREA_ID = ' + IntToStr(TmpArea.ID);
  TMainFacade.GetInstance.SkipLasWells;
  TMainFacade.GetInstance.AllLasWells.MakeList(lstBxWells.Items);
end;

function TfrmAddChangeSaveLasFiles.GetSelectedWell: TWell;
begin
  if lstBxWells.ItemIndex > -1 then
    Result := (lstBxWells.Items.Objects [lstBxWells.ItemIndex]) as TWell
  else
    Result := nil;
end;

procedure TfrmAddChangeSaveLasFiles.actBtnAddToWellExecute(
  Sender: TObject);
begin
  if Assigned(FOnSelectedWellChanged) then FOnSelectedWellChanged(SelectedWell);
end;

procedure TfrmAddChangeSaveLasFiles.actBtnAddToWellUpdate(Sender: TObject);
begin
  actBtnAddToWell.Enabled := Assigned(SelectedWell);
end;

procedure TfrmAddChangeSaveLasFiles.SetSelectedLasFile(
  const Value: TLasFile);
begin
  FSelectedLasFile := Value;
end;

procedure TfrmAddChangeSaveLasFiles.actViewLasFileExecute(Sender: TObject);
var
  filename:string;
  lf : TLasFile;
  lfc : TLasFileContent;
  i,j:Integer;
  replas : TReplacement;
  b:TLasFileBlock;
  
begin
filename:='v_b_5r2i.las';
lf := TLasFile.Create(nil);
lf.OldFileName:=filename;
lfc := TLasFileContent.Create(lf);
lfc.LasFileName:=lf.OldFileName;
lfc.ReadFile;

{
lst1.Items.AddStrings(lfc.Blocks.ItemByName['~Version'].RealContent);
lst1.Items.AddStrings(lfc.Blocks.ItemByName['~Well'].RealContent);
lst1.Items.AddStrings(lfc.Blocks.ItemByName['~Curve'].RealContent);
lst1.Items.AddStrings(lfc.Blocks.ItemByName['~Parameter'].RealContent);
lst1.Items.AddStrings(lfc.Blocks.ItemByName['~Parametr'].RealContent);
lst1.Items.AddStrings(lfc.Blocks.ItemByName['~Other'].RealContent);
lst1.Items.AddStrings(lfc.Blocks.ItemByName['~A'].RealContent);
}

lst1.Items.AddStrings(lfc.Blocks.ItemByName['~Well'].RealContent);

replas:=TReplacement.Create();
replas.BlockName:='~Well';
replas.Field:='WELL';
replas.What := '5_Vbagan';
replas.ForWhat := 'hello!';
lfc.MakeReplacement(replas);

lst1.Items.AddStrings(lfc.Blocks.ItemByName['~Well'].RealContent);




{
with lfc.Blocks.ItemByName['~Curve'] do
lst1.Items.Add(TableContent.Rows[TableContent.RowCOunt - 1].Cols[0]);
}
end;







procedure TfrmAddChangeSaveLasFiles.btn1Click(Sender: TObject);
begin
if not Assigned (frmCurveDict) then frmCurveDict := TfrmCurveDict.Create(Self);
  frmCurveDict.ShowModal;
end;

procedure TfrmAddChangeSaveLasFiles.btn2Click(Sender: TObject);
begin
///
end;

end.
