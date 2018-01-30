unit SubDividerWellConfirm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Variants;

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
    lblProblem: TLabel;
    lblReport: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure cmbxAreaChange(Sender: TObject);
    procedure cmbxWellNumChange(Sender: TObject);
  private
    { Private declarations }
    vCurrentWells: variant;
    procedure EnableOk;
  public
    { Public declarations }
    FoundAltitude, FoundDepth: single;
    FoundWellUIN:  integer;
    procedure ShowProblem(AText: string; Found: variant); overload;
    procedure ShowProblem(AText, AAreaName, AWellNum: string); overload;
  end;

var
  frmWellConfirm: TfrmWellConfirm;

implementation

uses SubDividerCommon, ClientCommon;

{$R *.DFM}

procedure TfrmWellConfirm.ShowProblem(AText, AAreaName, AWellNum: string);
var i: integer;
    S: string;
begin
  lblProblem.Caption := AText;
  AAreaName := RusTransLetter(AAreaName);
  cmbxArea.ItemIndex := -1;
  EnableOK;
  lblReport.Caption := '';
  with cmbxArea do
  for i := 0 to Items.Count - 1 do
  if pos(AAreaName, RusTransLetter(Items[i])) > 0 then
  begin
    ItemIndex := i;
    break;
  end;

  if cmbxArea.ItemIndex > -1 then
  begin
    cmbxArea.OnChange(cmbxArea);
    with cmbxWellNum do
    begin
      ItemIndex := Items.IndexOf(AWellNum);
      if ItemIndex = -1 then
      begin
        AWellNum := RusTransletter(AWellNum);
        for i := 0 to Items.Count - 1 do
        begin
          S := RusTransLetter(Items[i]);
          if  (pos(AWellNum, S) > 0)
          or  (pos(S, AWellNum) > 0) then
          begin
            ItemIndex := i;
            break;
          end;
        end;
      end;
      OnChange(cmbxWellNum);
    end;
  end;
end;

procedure TfrmWellConfirm.EnableOk;
begin
  btnOk.Enabled := (cmbxArea.Items.IndexOf(cmbxArea.Text) > -1)
                    and (cmbxWellNum.Items.IndexOf(cmbxWellNum.Text) > -1)
                    and (cmbxArea.ItemIndex > -1)
                    and (cmbxWellNum.ItemIndex > -1);
end;

procedure TfrmWellConfirm.ShowProblem(AText: string; Found: variant);
begin
  lblProblem.Caption := AText;
  cmbxArea.ItemIndex := -1;
  EnableOK;
  lblReport.Caption := '';
  if not varIsEmpty(Found) then
  begin
    cmbxArea.ItemIndex := cmbxArea.Items.IndexOf(Found[3, 0]);
    cmbxArea.OnChange(cmbxArea);
    cmbxWellNum.ItemIndex := cmbxWellNum.Items.IndexOf(Found[2, 0]);
    cmbxWellNum.OnChange(cmbxWellNum);
  end;
end;

procedure TfrmWellConfirm.FormCreate(Sender: TObject);
var i: integer;
begin
  for i := 0 to varArrayHighBound(AllDicts.AreaDict, 2) do
    cmbxArea.Items.Add(AllDicts.AreaDict[1, i]);
  cmbxArea.Sorted := true;
end;

procedure TfrmWellConfirm.cmbxAreaChange(Sender: TObject);
var i, iResult, iAreaID: integer;
begin
  iAreaID := GetObjectId(AllDicts.AreaDict, cmbxArea.Text, 1);
  cmbxWellNum.Clear;
  iResult := IServer.ExecuteQuery('select distinct Well_UIN, vch_Well_Num, num_Rotor_Altitude, num_True_Depth ' +
//                                  'from vw_Well_Main_Info ' +
                                  'from vw_Well ' +
                                  'where Area_ID = ' + intToStr(iAreaID));

  if iResult > 0 then
  begin
    vCurrentWells := IServer.QueryResult;
    for i := 0 to varArrayHighBound(vCurrentWells, 2) do
      cmbxWellNum.Items.Add(vCurrentWells[1, i]);
    cmbxWellNum.Sorted := true;
  end;
  EnableOk;
end;

procedure TfrmWellConfirm.cmbxWellNumChange(Sender: TObject);
var vTemp: variant;
begin
  EnableOk;
  // загружаем скважину
  FoundWellUIN := GetObjectId(vCurrentWells, cmbxWellNum.Text);
  lblReport.Caption := '';
  if FoundWellUIN > 0 then
  begin
    vTemp := GetObject(vCurrentWells, FoundWellUIN);
    if not varIsEmpty(vTemp) then
    begin
      FoundAltitude := vTemp[2];
      FoundDepth := vTemp[3];
      lblReport.Caption := 'Выбрана скважина: ' + cmbxWellNum.Text + '-' +cmbxArea.Text;
      lblReport.Caption := lblReport.Caption + '. Альтитуда: ' + Format('%6.2f', [FoundAltitude]) +
                           '; забой: ' + Format('%6.2f', [FoundDepth]) + '.';
    end;
  end;
end;

end.
