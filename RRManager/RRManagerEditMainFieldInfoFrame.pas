unit RRManagerEditMainFieldInfoFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RRManagerBaseObjects, FramesWizard, CommonComplexCombo, StdCtrls, RRmanagerObjects,
  RRManagerBaseGUI, RRmanagerCommon, ExtCtrls;

type
  TfrmMainFieldInfo = class(TBaseFrame)
//  TfrmMainFieldInfo = class(TFrame)
    gbxAll: TGroupBox;
    cmplxFieldType: TfrmComplexCombo;
    cmplxDevelopingDegree: TfrmComplexCombo;
    edtDiscoveringYear: TLabeledEdit;
    edtConservationYear: TLabeledEdit;
    edtDevelopingStartYear: TLabeledEdit;
  private
    function GetField: TOldField;
    { Private declarations }
  protected
    procedure ClearControls; override;
    procedure FillControls(ABaseObject: TBaseObject); override;
    procedure RegisterInspector; override;
  public
    { Public declarations }
    function Check: boolean; override;
    constructor Create(AOwner: TComponent); override;
    property    Field: TOldField read GetField;
    procedure   Save; override;
  end;

implementation

uses DateUtils, Facade;

{$R *.DFM}

{ TfrmFieldInfo }

function TfrmMainFieldInfo.Check: boolean;
var iYear: integer;
begin
  Result := true;

  if trim(edtDiscoveringYear.Text) <> '' then
  begin
    try
      iYear := StrToInt(edtDiscoveringYear.Text);
    except
      Result := false;
      ReportStatus('Введите правильное значение года открытия или оставьте поле пустым.');
      exit;
    end;

    if not ((iYear > 1899) and (iYear <= YearOf(Now))) then
    begin
      Result := false;
      ReportStatus('Значение года открытия должно лежать в границах 1900-' + IntToStr(YearOf(Now)) + '.');
      exit;
    end;
  end;

  if trim(edtConservationYear.Text) <> '' then
  begin
    try
      iYear := StrToInt(edtConservationYear.Text);
    except
      Result := false;
      ReportStatus('Введите правильное значение года консервации или оставьте поле пустым.');
      exit;
    end;

    if not ((iYear > 1899) and (iYear <= YearOf(Now))) then
    begin
      Result := false;
      ReportStatus('Значение года консервации должно лежать в границах 1900-' + IntToStr(YearOf(Now)) + '.');
      exit;
    end;
  end;

  if trim(edtDevelopingStartYear.Text) <> '' then
  begin
    try
      iYear := StrToInt(edtDevelopingStartYear.Text);
    except
      Result := false;
      ReportStatus('Введите правильное значение года ввода в разработку или оставьте поле пустым.');
      exit;
    end;

    if not ((iYear > 1899) and (iYear <= YearOf(Now))) then
    begin
      Result := false;    
      ReportStatus('Значение года ввода в разработку должно лежать в границах 1900-' + IntToStr(YearOf(Now)) + '.');
      exit;
    end;
  end;

  ReportStatus('');
end;

procedure TfrmMainFieldInfo.ClearControls;
begin
  cmplxFieldType.Clear;
  cmplxDevelopingDegree.Clear;

  edtDiscoveringYear.Clear;
  edtConservationYear.Clear;
  edtDevelopingStartYear.Clear;

end;

constructor TfrmMainFieldInfo.Create(AOwner: TComponent);
begin
  inherited;

  cmplxFieldType.Caption := 'Тип месторождения';
  cmplxFieldType.FullLoad := true;
  cmplxFieldType.DictName := 'TBL_FIELD_TYPE_DICT';


  cmplxDevelopingDegree.Caption := 'Степень промышленного освоения';
  cmplxDevelopingDegree.FullLoad := true;
  cmplxDevelopingDegree.DictName := 'TBL_DEVELOPMENT_DEGREE_DICT';
end;

procedure TfrmMainFieldInfo.FillControls(ABaseObject: TBaseObject);
var f: TOldField;
begin
  if not Assigned(ABaseObject) then F := Field
  else if ABaseObject is TOldField then
    f := ABaseObject as TOldField
  else if (ABaseObject is TOldStructureHistoryElement)
       and ((ABaseObject as TOldStructureHistoryElement).HistoryStructure is TOldField) then
    f := (ABaseObject as TOldStructureHistoryElement).HistoryStructure as TOldField;


  if Assigned(f) then
  begin
    cmplxFieldType.AddItem(F.FieldTypeID, F.FieldType);
    cmplxDevelopingDegree.AddItem(F.DevelopingDegreeID, F.DevelopingDegree);

    if f.DiscoveringYear > 0 then
      edtDiscoveringYear.Text := IntToStr(f.DiscoveringYear);
    if f.ExploitationStartYear > 0 then
      edtDevelopingStartYear.Text := IntToStr(f.ExploitationStartYear);
    if f.ExploitationFinishYear > 0 then
      edtConservationYear.Text := IntToStr(f.ExploitationFinishYear);
  end;
end;

function TfrmMainFieldInfo.GetField: TOldField;
begin
  Result := EditingObject as TOldField;
end;

procedure TfrmMainFieldInfo.RegisterInspector;
begin
  inherited;
  //Inspector.Add(cmplxFieldType.cmbxName, nil, ptString, 'тип месторождения', false);
  Inspector.Add(edtDiscoveringYear, nil, ptInteger, 'Год открытия', false);
  Inspector.Add(edtDevelopingStartYear, nil, ptInteger, 'Год ввода в разработку', false);
  Inspector.Add(edtConservationYear, nil, ptInteger, 'Год консервации', false);
end;

procedure TfrmMainFieldInfo.Save;
var i: integer;
begin
  inherited;

  if not Assigned(EditingObject) then
    // если что берем последнюю добавленную структуру из их списка
    FEditingObject := (TMainFacade.GetInstance as TMainFacade).AllStructures.Items[(TMainFacade.GetInstance as TMainFacade).AllStructures.Count - 1];

  Field.FieldTypeID := cmplxFieldType.SelectedElementID;
  Field.FieldType := cmplxFieldType.SelectedElementName;



  Field.DevelopingDegreeID := cmplxDevelopingDegree.SelectedElementID;
  Field.DevelopingDegree := cmplxDevelopingDegree.SelectedElementName;

  if trim(edtDiscoveringYear.Text) <> '' then
    Field.DiscoveringYear := StrToInt(edtDiscoveringYear.Text);
  if trim(edtDevelopingStartYear.Text) <> '' then
    Field.ExploitationStartYear := StrToInt(edtDevelopingStartYear.Text);
  if trim(edtConservationYear.Text) <> '' then
    Field.ExploitationFinishYear := StrToInt(edtConservationYear.Text);
end;

end.
