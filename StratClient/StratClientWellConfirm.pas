unit StratClientWellConfirm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Variants, Area, Well;

type
  TfrmWellConfirm = class(TForm)
    pnlButtons: TPanel;
    btnOk: TButton;
    btnIgnore: TButton;
    gbxWell: TGroupBox;
    Label1: TLabel;
    cmbxArea: TComboBox;
    cmbxWellNum: TComboBox;
    Label2: TLabel;
    lblReport: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure cmbxAreaChange(Sender: TObject);
    procedure cmbxWellNumChange(Sender: TObject);
  private
    { Private declarations }
    vCurrentWells: variant;
    procedure EnableOk;
    function GetSelectedArea: TSimpleArea;
    function GetSelectedWell: TSimpleWell;
  public
    { Public declarations }
    FoundAltitude, FoundDepth: single;
    property  SelectedArea: TSimpleArea read GetSelectedArea;
    property  SelectedWell: TSimpleWell read GetSelectedWell;
    procedure SetAreaAndWell(AAreaName, AWellNum: string);
  end;

var
  frmWellConfirm: TfrmWellConfirm;

implementation

uses ClientCommon, StringUtils, Facade;

{$R *.DFM}


procedure TfrmWellConfirm.EnableOk;
begin
  btnOk.Enabled := Assigned(SelectedArea) and Assigned(SelectedWell);
end;

procedure TfrmWellConfirm.FormCreate(Sender: TObject);
begin
  TMainFacade.GetInstance.AllAreas.MakeList(cmbxArea.Items, true, false);
end;

procedure TfrmWellConfirm.cmbxAreaChange(Sender: TObject);
begin
  if Assigned(SelectedArea) then SelectedArea.Wells.MakeList(cmbxWellNum.Items)
  else cmbxWellNum.Clear;
  EnableOk;
end;

procedure TfrmWellConfirm.cmbxWellNumChange(Sender: TObject);
var vTemp: variant;
begin
  EnableOk;
  // загружаем скважину
  lblReport.Caption := '';
  if Assigned(SelectedWell) then
  begin
    lblReport.Caption := 'Выбрана скважина: ' + SelectedWell.NumberWell + '-' + SelectedArea.Name;
    lblReport.Caption := lblReport.Caption + '. Альтитуда: ' + Format('%6.2f', [SelectedWell.Altitude]) +
                           '; забой: ' + Format('%6.2f', [SelectedWell.TrueDepth]) + '.';
  end;
end;

function TfrmWellConfirm.GetSelectedArea: TSimpleArea;
begin
  if cmbxArea.ItemIndex > -1 then
    Result := cmbxArea.Items.Objects[cmbxArea.ItemIndex] as TSimpleArea
  else
    Result := nil;
end;

function TfrmWellConfirm.GetSelectedWell: TSimpleWell;
begin
  if cmbxWellNum.ItemIndex > -1 then
    Result := cmbxWellNum.Items.Objects[cmbxWellNum.ItemIndex] as TSimpleWell
  else
    Result := nil;
end;

procedure TfrmWellConfirm.SetAreaAndWell(AAreaName,
  AWellNum: string);
var i: integer;
begin
  lblReport.Caption := '';
  AAreaName := trim(StringReplace(AAreaName, '(-ое)', '', [rfReplaceAll]));
  cmbxArea.ItemIndex := cmbxArea.Items.IndexOf(AAreaName);

  if cmbxArea.ItemIndex = -1 then
  for i := 0 to cmbxArea.Items.Count - 1 do
  if pos(AnsiUpperCase(AAreaName), AnsiUpperCase(cmbxArea.Items[i])) = 1 then
  begin
    cmbxArea.ItemIndex := i;
    break;
  end;

  if cmbxArea.ItemIndex = -1 then
  for i := 0 to cmbxArea.Items.Count - 1 do
  if pos(AnsiUpperCase(AAreaName), AnsiUpperCase(cmbxArea.Items[i])) > 0 then
  begin
    cmbxArea.ItemIndex := i;
    break;
  end;

  cmbxAreaChange(cmbxArea);
  
  if cmbxArea.ItemIndex > -1 then
  begin
    cmbxWellNum.ItemIndex := cmbxWellNum.Items.IndexOf(AWellNum);

    if cmbxWellNum.ItemIndex = -1 then
    for i := 0 to cmbxWellNum.Items.Count - 1 do
    if pos(AnsiUpperCase(AWellNum), AnsiUpperCase(cmbxWellNum.Items[i])) = 1 then
    begin
      cmbxWellNum.ItemIndex := i;
      break;
    end;

    if cmbxWellNum.ItemIndex = -1 then
    for i := 0 to cmbxWellNum.Items.Count - 1 do
    if pos(AnsiUpperCase(AWellNum), AnsiUpperCase(cmbxWellNum.Items[i])) > 0 then
    begin
      cmbxWellNum.ItemIndex := i;
      break;
    end;
  end;
  EnableOk;

end;

end.
