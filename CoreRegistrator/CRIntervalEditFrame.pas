unit CRIntervalEditFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonFrame, ComCtrls, StdCtrls, CommonComplexCombo, ExtCtrls,
  Slotting, Well, BaseObjects, CommonComplexIDCombo,
  WellStratonByDepthFrame, ClientCommon, CheckLst, CommonObjectSelectFrame,
  StratonSelectForm, CoreInterfaces;

type
  TfrmCoreIntervalEdit = class(TfrmCommonFrame)
    gbxIntervalProperties: TGroupBox;
    edtIntervalNumber: TLabeledEdit;
    edtTopDepth: TLabeledEdit;
    edtBottomDepth: TLabeledEdit;
    Bevel1: TBevel;
    edtCoreYield: TLabeledEdit;
    edtFinalCoreYield: TLabeledEdit;
    Bevel2: TBevel;
    Bevel3: TBevel;
    edtDiameter: TLabeledEdit;
    chlbxMechState: TCheckListBox;
    Label1: TLabel;
    dtmTakeDate: TDateTimePicker;
    Label2: TLabel;
    frmStratigraphyName: TfrmIDObjectSelect;
    Label3: TLabel;
    mmComment: TMemo;
  private
    { Private declarations }
    function GetSlotting: TSlotting;
    function GetWell: TWell;
    function GetCurrentBottom: double;
    function GetCurrentTop: double;
    procedure SaveMechanicalStates;
    procedure LoadMechanicalStates;
  protected
    procedure FillControls(ABaseObject: TIDObject); override;
    procedure ClearControls; override;
    procedure FillParentControls; override;
    procedure RegisterInspector; override;
    function  GetParentCollection: TIDObjects; override;
    procedure CopyEditingValues(Dest: TIDObject); override;
    function  InternalCheck: Boolean; override;
  public
    { Public declarations }
    property CurrentTop: double read GetCurrentTop;
    property CurrentBottom: double read GetCurrentBottom;


    property Slotting: TSlotting read GetSlotting;
    property Well: TWell read GetWell;

    constructor Create(AOwner: TComponent); override;
    procedure   Save(AObject: TIDObject = nil);  override;
    destructor Destroy; override;
  end;

var
  frmCoreIntervalEdit: TfrmCoreIntervalEdit;

implementation

uses BaseGUI, Facade, Straton, CoreMechanicalState,
     CommonIDObjectListForm, DateUtils, BaseWellInterval;

{$R *.dfm}

type

  EIncorrectDepth = class(Exception)
  public
    constructor Create(ADepth: string);
  end;

{ TfrmCoreIntervalEdit }

procedure TfrmCoreIntervalEdit.ClearControls;
begin
  inherited;
  //edtIntervalNumber.Clear;
  edtTopDepth.Clear;
  edtBottomDepth.Clear;
  edtCoreYield.Clear;
  edtFinalCoreYield.Clear;
  frmStratigraphyName.Clear;
  //cmpFactStraton.Clear;
  edtDiameter.Text := '80';
  //dtmTakeDate.DateTime := Now;
  chlbxMechState.ClearSelection;
end;

procedure TfrmCoreIntervalEdit.CopyEditingValues(Dest: TIDObject);
begin
  inherited;
  with Dest as TSlotting do
  begin
    Name := Slotting.Name;
    Bottom := Slotting.Bottom;
    Top := Slotting.Top;
    CoreFinalYield := Slotting.CoreFinalYield;
    CoreYield := Slotting.CoreYield;
    TrueDescription := Slotting.TrueDescription;
    Diameter := Slotting.Diameter;
    CoreTakeDate := Slotting.CoreTakeDate;
    CoreMechanicalStates.Clear;
    CoreMechanicalStates.AddObjects(Slotting.CoreMechanicalStates, true, true);
    Straton := Slotting.Straton;
  end;
end;

constructor TfrmCoreIntervalEdit.Create(AOwner: TComponent);
begin
  inherited;

  EditingClass := TSlotting;
  ParentClass := TWell;

  frmStratigraphyName.LabelCaption := 'Возраст';
  frmStratigraphyName.SelectiveFormClass := TfrmStratonSelect;
  frmStratigraphyName.ObjectSelector := (frmStratigraphyName.SelectorForm as TfrmStratonSelect);

  (TMainFacade.GetInstance as TMainFacade).AllMechanicalStates.MakeList(chlbxMechState.Items, true, false);
  dtmTakeDate.DateTime := Now;
  edtDiameter.Text := '80';
end;

destructor TfrmCoreIntervalEdit.Destroy;
begin
  inherited;
end;

procedure TfrmCoreIntervalEdit.FillControls(ABaseObject: TIDObject);
var s: TSlotting;
begin
  inherited;

  s := ShadeEditingObject as TSlotting;

  if Assigned(s) then
  begin
    edtIntervalNumber.Text := s.Number;
    edtTopDepth.Text := Format('%.2f', [s.Top]);
    edtBottomDepth.Text := Format('%.2f', [s.Bottom]);


    edtCoreYield.Text := Format('%.2f', [s.CoreYield]);
    edtFinalCoreYield.Text := Format('%.2f', [s.CoreFinalYield]);
    edtDiameter.Text := Format('%.2f', [s.Diameter]);
    dtmTakeDate.Date := s.CoreTakeDate;
    mmComment.Text := s.Comment;

    frmStratigraphyName.SelectedObject := s.Straton;
    LoadMechanicalStates;
  end;
  //FillParentControls;
end;

procedure TfrmCoreIntervalEdit.FillParentControls;
begin
  inherited;
  edtIntervalNumber.Text := IntToStr(Well.Slottings.GetMaxSlottingNumber + 1);
end;


function TfrmCoreIntervalEdit.GetCurrentBottom: double;
begin
  try
    Result := StrToFloatEx(edtBottomDepth.Text);
  except
    raise EIncorrectDepth.Create(edtBottomDepth.Text);
  end;
end;

function TfrmCoreIntervalEdit.GetCurrentTop: double;
begin
  try
    Result := StrToFloatEx(edtTopDepth.Text);
  except
    raise EIncorrectDepth.Create(edtTopDepth.Text);
  end;
end;

function TfrmCoreIntervalEdit.GetParentCollection: TIDObjects;
begin
  Result := Well.Slottings;
end;

function TfrmCoreIntervalEdit.GetSlotting: TSlotting;
begin
  Result := EditingObject as TSlotting;
end;

function TfrmCoreIntervalEdit.GetWell: TWell;
begin
  if EditingObject is TWell then
    Result := EditingObject as TWell
  else if EditingObject is TSlotting then
    Result := (EditingObject as TSlotting).Collection.Owner as TWell
  else
    Result := nil;
end;

{ EUnknownDepth }

constructor EIncorrectDepth.Create(ADepth: string);
begin
  inherited Create(Format('Введено неверное значение глубины (%s)', [ADepth]));
end;


function TfrmCoreIntervalEdit.InternalCheck: Boolean;
var fTop, fBottom: single;
begin
  fTop := StrToFloatEx(edtTopDepth.Text);
  fBottom := StrToFloatEx(edtBottomDepth.Text);
  // глубина от не может быть больше глубины до
  Result := fTop < fBottom;
  if not Result then
  begin
    StatusBar.Panels[0].Text := 'Глубина от больше глубины до';
    exit;
  end;
  // глубина от и глубина до - меньше забоя

  Result := Assigned(Well) and (((Well.TrueDepth > 0) and (fTop < Well.TrueDepth) and (fBottom <= Well.TrueDepth)) or (Well.TrueDepth = 0));
  if not Result then
  begin
    StatusBar.Panels[0].Text := 'Интервал выходит за пределы забоя';
    exit;
  end;

  // длина долбления больше максимума для длины долблений
  // выход и факт выход больше длины долбления
  // эти пока под вопросом - их, возможно, лучше проверять отдельным отчетом

  StatusBar.Panels[0].Text := '';
end;

procedure TfrmCoreIntervalEdit.LoadMechanicalStates;
var i, iIndex: integer;
begin
  for i := 0 to chlbxMechState.Count - 1 do
    chlbxMechState.Checked[i] := false;

  for i := 0 to Slotting.CoreMechanicalStates.Count - 1 do
  begin
    iIndex := chlbxMechState.Items.IndexOfObject(Slotting.CoreMechanicalStates.Items[i].MechanicalState);
    if iIndex >= 0 then
      chlbxMechState.Checked[iIndex] := true;
  end;
end;

procedure TfrmCoreIntervalEdit.RegisterInspector;
begin
  inherited;
  Inspector.Add(edtIntervalNumber, nil, ptString, 'номер интервала', false);
  Inspector.Add(edtTopDepth, nil, ptFloat, 'глубина от (м)', false);
  Inspector.Add(edtBottomDepth, nil, ptFloat, 'глубина до (м)', false);
  Inspector.Add(edtCoreYield, nil, ptFloat, 'выход керна (м)', false);
  Inspector.Add(edtFinalCoreYield, nil, ptFloat, 'фактический выход керна (м)', false);
  //Inspector.Add(frmStratigraphyName.edtObject, nil, ptString, 'возраст', false);
  Inspector.Add(edtDiameter, nil, ptFloat, 'диаметр (мм)', false);
end;

procedure TfrmCoreIntervalEdit.Save;
begin
  inherited;

  if FEditingObject is TWell then
    FEditingObject := Well.Slottings.Add;

  Slotting.Name := edtIntervalNumber.Text;
  Slotting.Top := StrToFloatEx(edtTopDepth.Text);
  Slotting.Bottom := StrToFloatEx(edtBottomDepth.Text);
  Slotting.CoreYield := StrToFloatEx(edtCoreYield.Text);
  Slotting.CoreFinalYield := StrToFloatEx(edtFinalCoreYield.Text);
  Slotting.Straton := frmStratigraphyName.SelectedObject as TSimpleStraton;
  Slotting.Diameter := StrToFloatEx(edtDiameter.Text);
  Slotting.CoreTakeDate := dtmTakeDate.Date;
  Slotting.Comment := mmComment.Text;

  SaveMechanicalStates;
end;

procedure TfrmCoreIntervalEdit.SaveMechanicalStates;
var i: integer;
begin
  //Slotting.CoreMechanicalStates.Clear;
  for i := chlbxMechState.Count - 1 downto 0 do
  if not chlbxMechState.Checked[i] then
    Slotting.CoreMechanicalStates.RemoveCoreMechanicalState(chlbxMechState.Items.Objects[i] as TCoreMechanicalState);


  for i := 0 to chlbxMechState.Items.Count - 1 do
  if chlbxMechState.Checked[i] then
    Slotting.CoreMechanicalStates.AddCoreMechanicalState(chlbxMechState.Items.Objects[i] as TCoreMechanicalState)
end;

end.
