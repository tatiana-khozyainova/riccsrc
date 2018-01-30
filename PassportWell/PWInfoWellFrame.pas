unit PWInfoWellFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonFrame, ComCtrls, Well, BaseObjects, StdCtrls,
  AllObjectsCbxFilterFrame, ExtCtrls, CommonValueDictFrame;

type
  //TfrmInfoWell = class(TFrame)

  TfrmInfoWell = class(TfrmCommonFrame)
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    edtNumber: TEdit;
    Panel3: TPanel;
    GroupBox5: TGroupBox;
    edtNameSyn: TEdit;
    frmFilterArea: TfrmFilter;
    frmFilterCategory: TfrmFilter;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    edtTargetDepth: TEdit;
    frmFilterTargetAge: TfrmFilter;
    frmFilterTargetResult: TfrmFilter;
    Panel2: TPanel;
    gbxDates: TGroupBox;
    GroupBox6: TGroupBox;
    dtmStartDrilling: TDateTimePicker;
    GroupBox7: TGroupBox;
    dtmFinishDrilling: TDateTimePicker;
    GroupBox8: TGroupBox;
    dtmConstructionStarted: TDateTimePicker;
    GroupBox9: TGroupBox;
    dtmConstructionFinished: TDateTimePicker;
    gbxCost: TGroupBox;
    GroupBox4: TGroupBox;
    edtTargetCost: TEdit;
    frmFilterIstResourse: TfrmFilter;
    chbxDrillingStart: TCheckBox;
    chbxDrillingFinish: TCheckBox;
    chbxConstructionStart: TCheckBox;
    chbxConstructionFinish: TCheckBox;
    procedure chbxDrillingStartClick(Sender: TObject);
    procedure chbxDrillingFinishClick(Sender: TObject);
    procedure chbxConstructionStartClick(Sender: TObject);
    procedure chbxConstructionFinishClick(Sender: TObject);
    procedure frmFilterAreacbxActiveObjectButtonClick(Sender: TObject);
  private
    function  GetWell: TWell;
  protected

    procedure ClearControls; override;
    procedure FillParentControls; override;
    procedure RegisterInspector; override;
    function  GetParentCollection: TIDObjects; override;
    function  InternalCheck: Boolean; override;

  public
    property  Well: TWell read GetWell;

    procedure FillControls(ABaseObject: TIDObject); override;
    procedure Save(AObject: TIDObject = nil); override;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

var
  frmInfoWell: TfrmInfoWell;

implementation

uses Facade, Area, Fluid, Straton, FinanceSource, BaseGUI;

{$R *.dfm}

{ TfrmCommonFrame1 }

procedure TfrmInfoWell.ClearControls;
begin
  inherited;
  edtNumber.Text := '';
  edtNameSyn.Text := '<синоним скважины>';

  frmFilterArea.AllObjects := TMainFacade.GetInstance.AllAreas;
  frmFilterArea.cbxActiveObject.Text := '<не указана>';

  frmFilterCategory.AllObjects := TMainFacade.GetInstance.AllCategoriesWells;
  frmFilterTargetResult.AllObjects := (TMainFacade.GetInstance as TMainFacade).AllFluidTypesByBalance;
  frmFilterTargetAge.AllObjects := (TMainFacade.GetInstance as TMainFacade).AllSimpleStratons;
  frmFilterIstResourse.AllObjects := (TMainFacade.GetInstance as TMainFacade).AllFinanceSources;

  frmFilterTargetResult.cbxActiveObject.Text := '<не указан>';
  frmFilterCategory.cbxActiveObject.Text := '<не указана>';
  frmFilterTargetAge.cbxActiveObject.Text := '<не указан>';
  frmFilterIstResourse.cbxActiveObject.Text := '<не указан>';

  
end;

constructor TfrmInfoWell.Create(AOwner: TComponent);
begin
  inherited;
  EditingClass := TWell;
end;

destructor TfrmInfoWell.Destroy;
begin

  inherited;
end;

procedure TfrmInfoWell.FillControls(ABaseObject: TIDObject);
begin
  inherited;

  if Assigned (Well) then
  with Well do
  begin
    edtNumber.Text := NumberWell;
    edtNameSyn.Text := Name;

    if Assigned (Area) then
    begin
      frmFilterArea.ActiveObject := Area;
      frmFilterArea.cbxActiveObject.Text := Area.Name;
    end;

    // категория
    if Assigned (TargetCategory) then
    begin
      frmFilterCategory.ActiveObject := TargetCategory;
      frmFilterCategory.cbxActiveObject.Text := TargetCategory.Name;
    end;


   // целевое назначение
    if Assigned (FluidTypeByBalance) then
    begin
      frmFilterTargetResult.ActiveObject := FluidTypeByBalance;
      frmFilterTargetResult.cbxActiveObject.Text := FluidTypeByBalance.List;
    end;

     // проектная глубина забоя
    edtTargetDepth.Text := FloatToStr(TargetDepth);
    // проектный возраст пород на забое
    if Assigned (TargetStraton) then
    begin
      frmFilterTargetAge.ActiveObject := TargetStraton;
      frmFilterTargetAge.cbxActiveObject.Text := TargetStraton.List;
    end;

    // сметная стоимость
    edtTargetCost.Text := FloatToStr(TargetCost);
    // дата начала и окончания бурения
    chbxDrillingStart.Checked := DtDrillingStart = 0;
    chbxDrillingStartClick(chbxDrillingStart);
    dtmStartDrilling.Date := DtDrillingStart;

    chbxDrillingFinish.Checked := DtConstructionFinish = 0;
    chbxDrillingFinishClick(chbxDrillingFinish);
    dtmFinishDrilling.Date := DtDrillingFinish;
    
    // даты начала и окончания строительства
    chbxConstructionStart.Checked := DtConstructionStart = 0;
    chbxConstructionStartClick(chbxConstructionStart);
    dtmConstructionStarted.Date := DtConstructionStart;

    chbxConstructionFinish.Checked := DtConstructionFinish = 0;
    chbxConstructionFinishClick(chbxConstructionFinish);
    dtmConstructionFinished.Date := DtConstructionFinish;

    // источник
    if Assigned (IstFinance) then
    begin
      frmFilterIstResourse.ActiveObject := IstFinance;
      frmFilterIstResourse.cbxActiveObject.Text := IstFinance.Name;
    end;

  end;
end;

procedure TfrmInfoWell.FillParentControls;
begin
  inherited;

end;

function TfrmInfoWell.GetParentCollection: TIDObjects;
begin
  Result := nil;
end;

function TfrmInfoWell.GetWell: TWell;
begin
  Result := EditingObject as TWell;
end;

procedure TfrmInfoWell.RegisterInspector;
begin
  inherited;
  Inspector.Add(edtNumber, nil, ptString, 'номер скважины', false);
  Inspector.Add(frmFilterArea.cbxActiveObject, nil, ptString, 'площадь', false);

end;

procedure TfrmInfoWell.Save(AObject: TIDObject = nil);
var o: TFinanceSourceWell;
begin
  inherited;

  with Well do
  begin
    NumberWell := trim (edtNumber.Text);
    Area := frmFilterArea.ActiveObject as TSimpleArea;
    Name := trim (edtNameSyn.Text);
    // категория
    TargetCategory := frmFilterCategory.ActiveObject as TWellCategory;

    // целевое назначение
    FluidTypeByBalance := frmFilterTargetResult.ActiveObject as TFluidType;

    // проектная глубина забоя
    if trim (edtTargetDepth.Text) <> '' then
      TargetDepth := StrToFloat(edtTargetDepth.Text);

    // проектный возраст пород на забое
    TargetStraton := frmFilterTargetAge.ActiveObject as TSimpleStraton;

    // сметная стоимость
    if trim (edtTargetCost.Text) <> '' then
      TargetCost := StrToFloat(Trim(edtTargetCost.Text));

    // дата начала и окончания бурения
    if not chbxDrillingStart.Checked then
      DtDrillingStart := dtmStartDrilling.Date
    else
      DtDrillingStart := 0;

    if not chbxDrillingFinish.Checked then
      DtDrillingFinish := dtmFinishDrilling.Date
    else
      DtDrillingFinish := 0;

    if not chbxConstructionStart.Checked then
      DtConstructionStart := dtmConstructionStarted.Date
    else
      DtConstructionStart := 0;

    if not chbxConstructionFinish.Checked then
      DtConstructionFinish := dtmConstructionFinished.Date
    else
      DtConstructionFinish := 0;


    // источник
    if Assigned (frmFilterIstResourse.ActiveObject) then
    begin
      if IstFinances.Count = 0 then
      begin
        o := TFinanceSourceWell(frmFilterIstResourse.ActiveObject);
        IstFinances.Add(o);
      end
      else IstFinance.Assign(frmFilterIstResourse.ActiveObject);
    end;
  end;
end;

procedure TfrmInfoWell.chbxDrillingStartClick(Sender: TObject);
begin
  dtmStartDrilling.Enabled := not chbxDrillingStart.Checked;
  if dtmStartDrilling.Enabled then dtmStartDrilling.Date := Now;
end;

procedure TfrmInfoWell.chbxDrillingFinishClick(Sender: TObject);
begin
  dtmFinishDrilling.Enabled := not chbxDrillingFinish.Checked;
  if dtmFinishDrilling.Enabled then dtmFinishDrilling.Date := Now;
end;

procedure TfrmInfoWell.chbxConstructionStartClick(Sender: TObject);
begin
  dtmConstructionStarted.Enabled := not chbxConstructionStart.Checked;
  if dtmConstructionStarted.Enabled then dtmConstructionStarted.Date := Now;
end;

procedure TfrmInfoWell.chbxConstructionFinishClick(Sender: TObject);
begin
  dtmConstructionFinished.Enabled := not chbxConstructionFinish.Checked;
  if dtmConstructionFinished.Enabled then dtmConstructionFinished.Date := Now;
end;

function TfrmInfoWell.InternalCheck: Boolean;
var iResult: integer;
    v: OleVariant;
    i: integer;
begin
  Result := trim(edtNumber.Text) <> '';
  if not Result then
  begin
    StatusBar.Panels[0].Text := 'Введите номер скважины';
    exit;
  end;

  Result := Assigned(frmFilterArea.ActiveObject);
  if not Result then
  begin
    StatusBar.Panels[0].Text := 'Выберите площадь';
    exit;
  end;


  iResult := TMainFacade.GetInstance.DBGates.Server.ExecuteQuery('select WELL_UIN from vw_Well where Area_ID = ' + IntToStr(frmFilterArea.ActiveObject.ID) + ' AND ' + 'vch_Well_Num = ' + '''' + trim(edtNumber.Text) + '''');
  Result := iResult = 0;
  if not Result then
  begin
    v := TMainFacade.GetInstance.DBGates.Server.QueryResult;

    Result := false;
    for i := 0 to VarArrayHighBound(v, 1) do
      Result := Result or (v[0, i] = Well.ID);

    if not Result then
    begin
      StatusBar.Panels[0].Text := 'Скважина уже существует';
      exit;
    end;
  end;

  StatusBar.Panels[0].Text := '';
end;

procedure TfrmInfoWell.frmFilterAreacbxActiveObjectButtonClick(
  Sender: TObject);
begin
  frmFilterArea.cbxActiveObjectButtonClick(Sender);
  Check;
end;

end.
