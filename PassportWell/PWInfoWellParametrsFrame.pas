unit PWInfoWellParametrsFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonFrame, ComCtrls, Well, BaseObjects, StdCtrls,
  CommonValueDictFrame, Buttons, Mask, ToolEdit, ExtCtrls, ActnList;

type
  //TfrmInfoWellParametrs = class(TFrame)


  TfrmInfoWellParametrs = class(TfrmCommonFrame)
    GroupBox2: TGroupBox;
    frmFilterState: TfrmFilter;
    Panel6: TPanel;
    Panel1: TPanel;
    frmFilterProfileName: TfrmFilter;
    frmFilterTrueAltitude: TfrmFilter;
    pnlCategory: TPanel;
    frmFilterCategory: TfrmFilter;
    frmFilterAbandonReason: TfrmFilter;
    gbxDateLiq: TGroupBox;
    dtmLiquidation: TDateTimePicker;
    frmFilterTrueResult: TfrmFilter;
    GroupBox6: TGroupBox;
    edtTrueDepth: TEdit;
    frmFilterTrueAge: TfrmFilter;
    GroupBox9: TGroupBox;
    edtFactCost: TEdit;
    gbxHistory: TGroupBox;
    lwDynamics: TListView;
    pnlButtons: TPanel;
    btnEdit: TSpeedButton;
    btnFinishEdit: TSpeedButton;
    actnlstEditHistory: TActionList;
    actnStartEdit: TAction;
    actnFinishEdit: TAction;
    chbxLicDate: TCheckBox;
    actnAddHistoryItem: TAction;
    actnDeleteHistoryItem: TAction;
    btnStartEdit: TSpeedButton;
    btnDelete: TSpeedButton;
    procedure frmFilterStatecbxActiveObjectChange(Sender: TObject);
    procedure frmFilterTrueAltitudecbxActiveObjectButtonClick(
      Sender: TObject);
    procedure chbxLicDateClick(Sender: TObject);
    procedure actnStartEditExecute(Sender: TObject);
    procedure actnStartEditUpdate(Sender: TObject);
    procedure actnFinishEditExecute(Sender: TObject);
    procedure actnFinishEditUpdate(Sender: TObject);
    procedure actnDeleteHistoryItemExecute(Sender: TObject);
    procedure actnDeleteHistoryItemUpdate(Sender: TObject);
    procedure actnAddHistoryItemUpdate(Sender: TObject);
    procedure actnAddHistoryItemExecute(Sender: TObject);
  private
    FEditingStarted: boolean;
    function  GetWell: TWell;
    procedure LoadDynamics;
    function  GetActiveParameters: TWellDynamicParameters;
    procedure SetActiveParameters(const Value: TWellDynamicParameters);
    function  ListItemByObject(AObject: TObject): TListItem;
    procedure SetEditingStarted(const Value: boolean);
  protected
    procedure FillControls(ABaseObject: TIDObject); override;
    procedure ClearControls; override;
    procedure FillParentControls; override;
    procedure RegisterInspector; override;
    function  GetParentCollection: TIDObjects; override;
    function  InternalCheck: boolean; override;
  public
    property  EditingStarted: boolean read FEditingStarted write SetEditingStarted;

    property  Well: TWell read GetWell;
    property  ActiveParameters: TWellDynamicParameters read GetActiveParameters write SetActiveParameters;

    procedure   Save(AObject: TIDObject = nil); override;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

var
  frmInfoWellParametrs: TfrmInfoWellParametrs;

implementation

uses Facade, SDFacade, State, Fluid, Profile, DateUtils, PWEditInfoWellAltitude,
     Straton, BaseConsts, PWSelectVersionForm;

{$R *.dfm}

{ TfrmCommonFrame1 }

procedure TfrmInfoWellParametrs.ClearControls;
begin
  inherited;
  frmFilterState.AllObjects := TMainFacade.GetInstance.AllStatesWells;
  frmFilterProfileName.AllObjects := (TMainFacade.GetInstance as TMainFacade).AllProfiles;
  frmFilterTrueAge.AllObjects := (TMainFacade.GetInstance as TMainFacade).AllSimpleStratons;
  frmFilterTrueResult.AllObjects := (TMainFacade.GetInstance as TMainFacade).AllFluidTypes;
  frmFilterAbandonReason.AllObjects := (TMainFacade.GetInstance as TMainFacade).AllAbandonReasons;
  frmFilterCategory.AllObjects := TMainFacade.GetInstance.AllCategoriesWells;

  frmFilterAbandonReason.cbxActiveObject.Text := '<не указана>';
  frmFilterState.cbxActiveObject.Text := '<не указано>';
  frmFilterProfileName.cbxActiveObject.Text := '<не указан>';
  frmFilterTrueAge.cbxActiveObject.Text := '<не указан>';
  frmFilterTrueResult.cbxActiveObject.Text := '<не указан>';
  frmFilterCategory.cbxActiveObject.Text := '<не указана>';
end;


constructor TfrmInfoWellParametrs.Create(AOwner: TComponent);
begin
  inherited;
  EditingClass := TWell;
  EditingStarted := false;
  frmFilterAbandonReason.Enabled := false;
  dtmLiquidation.Enabled := False;
  chbxLicDate.Enabled := false;

  ControlStyle := ControlStyle + [csOpaque];
end;

destructor TfrmInfoWellParametrs.Destroy;
begin

  inherited;
end;

procedure TfrmInfoWellParametrs.FillControls(ABaseObject: TIDObject);
begin
  inherited;

  with Well do
  begin

    frmFilterCategory.ActiveObject := Category;
    // фактическа€ глубина забо€
    edtTrueDepth.Text := FloatToStr(TrueDepth);

    // фактический возраст пород на забое
    if Assigned (TrueStraton) then
    begin
      frmFilterTrueAge.ActiveObject := TrueStraton;
      frmFilterTrueAge.cbxActiveObject.Text := TrueStraton.List;
    end;


    // результат бурени€
    if Assigned (FluidType) then
    begin
      frmFilterTrueResult.ActiveObject := FluidType;
      frmFilterTrueResult.cbxActiveObject.Text := FluidType.Name;
    end;

    // состо€ние скважины
    if Assigned (State) then
    begin
      frmFilterState.ActiveObject := State;
      frmFilterState.cbxActiveObject.Text := State.Name;

      if State.ID = WELL_STATE_LIQIUDATED then
      begin
        frmFilterAbandonReason.Enabled := True;
        dtmLiquidation.Enabled := True;
      end;
    end;

    // причина и дата ликвидации
    if Assigned (AbandonReason) then
    begin
      frmFilterAbandonReason.ActiveObject := AbandonReason;
      frmFilterAbandonReason.cbxActiveObject.Text := AbandonReason.Name;

      if not chbxLicDate.Checked then
        dtmLiquidation.Date := AbandonReason.DtLiquidation
      else
        dtmLiquidation.Date := 0;
    end;


    // альтитуда ротора
    if Altitudes.Count > 0 then
      frmFilterTrueAltitude.cbxActiveObject.Text := 'указана' // ...
    else frmFilterTrueAltitude.cbxActiveObject.Text := '<отсутствует>';



     // профиль
    if Assigned (Profile) then
    begin
      frmFilterProfileName.ActiveObject := Profile;
      frmFilterProfileName.cbxActiveObject.Text := Profile.Name;
    end;

    // фактическа€ стоимость
    edtFactCost.Text := FloatToStr(TrueCost);

    // загрузка динамических параметров
    LoadDynamics;


    ActiveParameters := WellDynamicParametersSet.Items[WellDynamicParametersSet.Count - 1];
    EditingStarted := false;
    Check;
  end;
end;

procedure TfrmInfoWellParametrs.FillParentControls;
begin
  inherited;

end;

function TfrmInfoWellParametrs.GetParentCollection: TIDObjects;
begin
  Result := nil;
end;

function TfrmInfoWellParametrs.GetWell: TWell;
begin
  Result := EditingObject as TWell;
end;

procedure TfrmInfoWellParametrs.RegisterInspector;
begin
  inherited;

end;

procedure TfrmInfoWellParametrs.Save;
var
    ar: TAbandonReasonWell;
    i: integer;
begin
  inherited;

  if Assigned (Well) then
  with Well do
  begin
    // фактическа€ глубина забо€
    if trim (edtTrueDepth.Text) <> '' then
      TrueDepth := StrToFloat(edtTrueDepth.Text);


    // результат бурени€
    FluidType := frmFilterTrueResult.ActiveObject as TFluidType;

    // фактический возраст пород на забое
    TrueStraton := frmFilterTrueAge.ActiveObject as TSimpleStraton;

    // состо€ние скважины
    State := frmFilterState.ActiveObject as TState;

    // причина ликвидации
    if Assigned(State) and (State.ID = WELL_STATE_LIQIUDATED) then
    begin
      if Assigned (frmFilterAbandonReason.ActiveObject) then
      begin
        if AbandonReasons.Count = 0 then
        begin
          ar := TAbandonReasonWell(frmFilterAbandonReason.ActiveObject);
          AbandonReasons.Add(ar);
        end
        else AbandonReason.Assign(frmFilterAbandonReason.ActiveObject);

         if not chbxLicDate.Checked then
          AbandonReason.DtLiquidation := DateOf(dtmLiquidation.Date)
        else
          AbandonReason.DtLiquidation := 0;
      end
      else AbandonReasons.Clear;
    end
    else
    begin
      for i := AbandonReasons.Count - 1 downto 0 do
        AbandonReasons.Delete(i);
    end;    

    // фактическа€ стоимость
    if trim (edtFactCost.Text) <> '' then
      TrueCost := StrToFloat(trim(edtFactCost.Text));

    // профиль
    Profile := frmFilterProfileName.ActiveObject as TProfile;
  end;
end;

procedure TfrmInfoWellParametrs.frmFilterStatecbxActiveObjectChange(
  Sender: TObject);
begin
  inherited;

  if Assigned (frmFilterState.ActiveObject) then
  begin
    if frmFilterState.ActiveObject.ID = WELL_STATE_LIQIUDATED then
    begin
      frmFilterAbandonReason.Enabled := true;
      dtmLiquidation.Enabled := True;
      chbxLicDate.Enabled := True;
    end
    else
    begin
      frmFilterAbandonReason.Enabled := false;
      dtmLiquidation.Enabled := False;
      chbxLicDate.Enabled := False;
    end;
  end;
end;

procedure TfrmInfoWellParametrs.frmFilterTrueAltitudecbxActiveObjectButtonClick(
  Sender: TObject);
begin
  frmEditWellAltitude := TfrmEditWellAltitude.Create(Self);

  frmEditWellAltitude.frmAltitudesWell.Well := Well;
  frmEditWellAltitude.frmAltitudesWell.Reload;

  frmEditWellAltitude.ShowModal;
  frmEditWellAltitude.Free;

  if Well.Altitudes.Count > 0 then
  begin
    frmFilterTrueAltitude.cbxActiveObject.Text := '” ј«јЌј';
    frmFilterTrueAltitude.cbxActiveObject.Font.Style := [fsBold];
  end
  else
  begin
    frmFilterTrueAltitude.cbxActiveObject.Text := '<отсутствует>';
    frmFilterTrueAltitude.cbxActiveObject.Font.Style := [];
  end;
end;

procedure TfrmInfoWellParametrs.chbxLicDateClick(Sender: TObject);
begin
  dtmLiquidation.Enabled := not chbxLicDate.Checked;
  if dtmLiquidation.Enabled then
    dtmLiquidation.Date := Now;
end;

procedure TfrmInfoWellParametrs.LoadDynamics;
var i: integer;
    li: TListItem;
begin
  lwDynamics.Items.Clear;
  with Well do
  for i := 0 to WellDynamicParametersSet.Count - 1 do
  begin
    li := lwDynamics.Items.Add;
    li.Data := WellDynamicParametersSet.Items[i];
    with WellDynamicParametersSet.Items[i] do
    begin
      if Assigned(WellCategory) then
        li.Caption := WellCategory.Name
      else
        li.Caption := '';

      li.SubItems.Add(Format('%.2f', [TrueDepth]));

      if Assigned(TrueStraton) then
        li.SubItems.Add(TrueStraton.Name)
      else
        li.SubItems.Add('');

      if Assigned(TrueFluidType) then
        li.SubItems.Add(TrueFluidType.Name)
      else
        li.SubItems.Add('');

      if Assigned(State) then
        li.SubItems.Add(State.Name)
      else
        li.SubItems.Add('');

      if Assigned(Version) then
        li.SubItems.Add(Version.List())
      else
        li.SubItems.Add('');
    end;

  end;

end;

function TfrmInfoWellParametrs.GetActiveParameters: TWellDynamicParameters;
begin
  if Assigned(lwDynamics.Selected) then
    Result := TWellDynamicParameters(lwDynamics.Selected.Data)
  else
    Result := nil;
end;

procedure TfrmInfoWellParametrs.actnStartEditExecute(Sender: TObject);
begin
  EditingStarted := true;
  lwDynamics.Enabled := false;
  with ActiveParameters do
  begin
    frmFilterCategory.ActiveObject := WellCategory;
    // фактическа€ глубина забо€
    edtTrueDepth.Text := FloatToStr(TrueDepth);

    // фактический возраст пород на забое
    if Assigned (TrueStraton) then
    begin
      frmFilterTrueAge.ActiveObject := TrueStraton;
      frmFilterTrueAge.cbxActiveObject.Text := TrueStraton.List;
    end;


    // результат бурени€
    if Assigned (TrueFluidType) then
    begin
      frmFilterTrueResult.ActiveObject := TrueFluidType;
      frmFilterTrueResult.cbxActiveObject.Text := TrueFluidType.Name;
    end;

    // состо€ние скважины
    if Assigned (WellState) then
    begin
      frmFilterState.ActiveObject := WellState;
      frmFilterState.cbxActiveObject.Text := WellState.Name;

      if WellState.ID = WELL_STATE_LIQIUDATED then
      begin
        frmFilterAbandonReason.Enabled := True;
        dtmLiquidation.Enabled := True;
      end;
    end;

    // причина и дата ликвидации
    if Assigned (AbandonReason) then
    begin
      frmFilterAbandonReason.ActiveObject := AbandonReason;
      frmFilterAbandonReason.cbxActiveObject.Text := AbandonReason.Name;

      if not chbxLicDate.Checked then
        dtmLiquidation.Date := AbandonDate
      else
        dtmLiquidation.Date := 0;
    end;


     // профиль
    if Assigned (WellProfile) then
    begin
      frmFilterProfileName.ActiveObject := WellProfile;
      frmFilterProfileName.cbxActiveObject.Text := WellProfile.Name;
    end;

    // фактическа€ стоимость
    edtFactCost.Text := FloatToStr(TrueCost);
  end;
end;

procedure TfrmInfoWellParametrs.actnStartEditUpdate(Sender: TObject);
begin
  actnStartEdit.Enabled := Assigned(ActiveParameters) and not FEditingStarted;
end;

procedure TfrmInfoWellParametrs.actnFinishEditExecute(Sender: TObject);
begin
  with ActiveParameters do
  begin
    WellCategory := frmFilterCategory.ActiveObject as TWellCategory;
    // фактическа€ глубина забо€
    if trim (edtTrueDepth.Text) <> '' then
      TrueDepth := StrToFloat(edtTrueDepth.Text);


    // результат бурени€
    TrueFluidType := frmFilterTrueResult.ActiveObject as TFluidType;

    // фактический возраст пород на забое
    TrueStraton := frmFilterTrueAge.ActiveObject as TSimpleStraton;

    // состо€ние скважины
    WellState := frmFilterState.ActiveObject as TState;

    // причина ликвидации
    if Assigned(WellState) and (WellState.ID = WELL_STATE_LIQIUDATED) then
    begin

      if Assigned (frmFilterAbandonReason.ActiveObject) then
      begin
        AbandonReason := frmFilterAbandonReason.ActiveObject as TAbandonReason;
        if not chbxLicDate.Checked then
          AbandonDate := DateOf(dtmLiquidation.Date)
        else
          AbandonDate := 0;
      end
    end;

    // фактическа€ стоимость
    if trim (edtFactCost.Text) <> '' then
      TrueCost := StrToFloat(trim(edtFactCost.Text));

    // профиль
    WellProfile := frmFilterProfileName.ActiveObject as TProfile;
  end;

  lwDynamics.Enabled := true;
  FillControls(Well);

  EditingStarted := false;
end;

procedure TfrmInfoWellParametrs.actnFinishEditUpdate(Sender: TObject);
begin
  actnFinishEdit.Enabled := Assigned(ActiveParameters) and FEditingStarted;
end;

procedure TfrmInfoWellParametrs.SetActiveParameters(
  const Value: TWellDynamicParameters);
var li: TListItem;
begin
  li := ListItemByObject(Value);
  if Assigned(li) then li.Selected := true;

end;

function TfrmInfoWellParametrs.ListItemByObject(
  AObject: TObject): TListItem;
var i: integer;
begin
  Result := nil;
  for i := 0 to lwDynamics.Items.Count - 1 do
  if TObject(lwDynamics.Items[i].Data) = AObject then
  begin
    result := lwDynamics.Items[i];
    break;
  end;

end;

procedure TfrmInfoWellParametrs.SetEditingStarted(const Value: boolean);
begin
  if FEditingStarted <> Value then
  begin
    FEditingStarted := Value;

    frmFilterCategory.Enabled := FEditingStarted;
    edtTrueDepth.Enabled := FEditingStarted;
    frmFilterTrueAge.Enabled := FEditingStarted;
    frmFilterTrueResult.Enabled := FEditingStarted;
    frmFilterState.Enabled := FEditingStarted;
    if not FEditingStarted then
    begin
      frmFilterAbandonReason.Enabled := FEditingStarted;
      gbxDateLiq.Enabled := FEditingStarted;
    end
    else
    begin
      frmFilterAbandonReason.Enabled := FEditingStarted and Assigned(frmFilterState.ActiveObject) and (frmFilterState.ActiveObject.ID = WELL_STATE_LIQIUDATED);
      gbxDateLiq.Enabled := FEditingStarted and Assigned(frmFilterState.ActiveObject) and (frmFilterState.ActiveObject.ID = WELL_STATE_LIQIUDATED);
    end;
    frmFilterProfileName.Enabled := FEditingStarted;
    edtFactCost.Enabled := FEditingStarted;
    Check;


  end;
end;

procedure TfrmInfoWellParametrs.actnDeleteHistoryItemExecute(
  Sender: TObject);
begin
  Well.WellDynamicParametersSet.MarkDeleted(ActiveParameters);
  lwDynamics.Selected.Delete;
  lwDynamics.Selected := nil;
end;

procedure TfrmInfoWellParametrs.actnDeleteHistoryItemUpdate(
  Sender: TObject);
begin
  actnDeleteHistoryItem.Enabled := not EditingStarted and Assigned(ActiveParameters) and ((Assigned(ActiveParameters.Version) and (ActiveParameters.Version.ID <> 0)) or not Assigned(ActiveParameters.Version));
end;

procedure TfrmInfoWellParametrs.actnAddHistoryItemUpdate(Sender: TObject);
begin
  actnAddHistoryItem.Enabled := not EditingStarted;
end;

procedure TfrmInfoWellParametrs.actnAddHistoryItemExecute(Sender: TObject);
var p: TWellDynamicParameters;
begin
  if not Assigned(frmSelectVersion) then frmSelectVersion := TfrmSelectVersion.Create(Self);

  if frmSelectVersion.ShowModal = mrOk then
  begin
    p := Well.WellDynamicParametersSet.GetParametersByVersion(frmSelectVersion.ActiveVersion);
    if not Assigned(p) then
    begin
      p := Well.WellDynamicParametersSet.Add as TWellDynamicParameters;
      p.Version := frmSelectVersion.ActiveVersion;
      LoadDynamics;
    end;

    ActiveParameters := p;
    actnStartEdit.Execute;
  end;
end;

function TfrmInfoWellParametrs.InternalCheck: boolean;
begin
  Result := not EditingStarted;
  if not Result then
  begin
    StatusBar.Panels[0].Text := '«авершите редакцию параметров';
    exit;
  end;

  StatusBar.Panels[0].Text := '';
end;

end.

