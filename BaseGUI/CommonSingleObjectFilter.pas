unit CommonSingleObjectFilter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, BaseObjectType, BaseObjects, ActnList, Registrator,
  ExtCtrls;

type
  {$DEFINE DEBUG}


  TfrmSingleObjectFilter = class(TFrame)
    gbxSingleObjectFilter: TGroupBox;
    cmbxObjectType: TComboBox;
    cmbxObject: TComboBox;
    cmbxVersion: TComboBox;
    edtFilter: TEdit;
    gbx1: TGroupBox;
    gbx2: TGroupBox;
    gbxObjectSelector: TGroupBox;
    btnFilter: TButton;
    actnLst: TActionList;
    actnApplyFilter: TAction;
    splt1: TSplitter;
    splt2: TSplitter;
    procedure cmbxObjectTypeChange(Sender: TObject);
    procedure cmbxObjectChange(Sender: TObject);
    procedure actnApplyFilterExecute(Sender: TObject);
    procedure cmbxVersionChange(Sender: TObject);
  private
    FOnSelectedObjectChanged: TNotifyEvent;
    FFilterObjects: TRegisteredIDObjects;
    FCurrentObjectList: TIDObjects;

    function GetSelectedObject: TIDObject;
    function GetSelectedObjectType: TObjectType;
    function GetFilter: string;
    function GetSelectedVersion: TIDObject;
  public

    property    OnSelectedObjectChanged: TNotifyEvent read FOnSelectedObjectChanged write FOnSelectedObjectChanged;
    property    SelectedObjectType: TObjectType read GetSelectedObjectType;
    property    CurrentObjectList: TIDObjects read FCurrentObjectList;
    property    SelectedObject: TIDObject read GetSelectedObject;
    property    SelectedVersion: TIDObject read GetSelectedVersion;
    property    Filter: string read GetFilter;

    // отфильтрованные объекты
    property    FilterObjects: TRegisteredIDObjects read FFilterObjects write FFilterObjects;

    // сохранить свойства фильтра
    procedure   SaveFilterSettings;

    procedure   Prepare;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;


implementation

uses Facade, BaseConsts, Version;

{$R *.dfm}

{ TfrmSingleObjectFilter }

constructor TfrmSingleObjectFilter.Create(AOwner: TComponent);
begin
  inherited;

end;

function TfrmSingleObjectFilter.GetSelectedObject: TIDObject;
begin
  if cmbxObject.ItemIndex > -1 then
    Result := TIDObject(cmbxObject.Items.Objects[cmbxObject.ItemIndex])
  else
    Result := nil;
end;

function TfrmSingleObjectFilter.GetSelectedObjectType: TObjectType;
begin
  if cmbxObjectType.ItemIndex > -1 then
    Result := TObjectType(cmbxObjectType.Items.Objects[cmbxObjectType.ItemIndex])
  else
    Result := nil;
end;

procedure TfrmSingleObjectFilter.Prepare;
var o: TIDObject;
begin
  cmbxObjectType.Enabled := true;
  cmbxObject.Enabled := true;
  edtFilter.Enabled := true;
  cmbxVersion.Enabled := true;

  (TMainFacade.GetInstance as TMainFacade).AllObjectTypes.MakeList(cmbxObjectType.Items, false);

  (TMainFacade.GetInstance as TMainFacade).ClearGRRVersions;
  (TMainFacade.GetInstance as TMainFacade).GRRVersions.MakeList(cmbxVersion.Items, false);
  if Assigned(TMainFacade.GetInstance.ActiveVersion) then
    cmbxVersion.ItemIndex := cmbxVersion.Items.IndexOfObject(TMainFacade.GetInstance.ActiveVersion)
  else
    cmbxVersion.ItemIndex := cmbxVersion.Items.IndexOfObject(TMainFacade.GetInstance.AllVersions.ItemsByID[0]);
  cmbxVersionChange(cmbxVersion);


  try
    o := TMainFacade.GetInstance.AllObjectTypes.ItemsByID[StrToInt(TMainFacade.GetInstance.SystemSettings.SectionByName['FilterState'].SectionValues.Values['SelectedObjectType'])];
    cmbxObjectType.ItemIndex := cmbxObjectType.Items.IndexOfObject(o);
    cmbxObjectTypeChange(cmbxObjectType);

    if Assigned(FCurrentObjectList) then
    begin
      o := FCurrentObjectList.ItemsByID[StrToInt(TMainFacade.GetInstance.SystemSettings.SectionByName['FilterState'].SectionValues.Values['SelectedObject'])];
      cmbxObject.ItemIndex := cmbxObject.Items.IndexOfObject(o);
      cmbxObjectChange(cmbxObject);
    end;
  except

  end;
end;

procedure TfrmSingleObjectFilter.cmbxObjectTypeChange(Sender: TObject);
begin
  FCurrentObjectList := nil;
  if Assigned(SelectedObjectType) then
  case SelectedObjectType.ID of
    DISTRICT_OBJECT_TYPE_ID:
    begin
      TMainFacade.GetInstance.AllDistricts.MakeList(cmbxObject.Items, false, true);
      FCurrentObjectList := TMainFacade.GetInstance.AllDistricts;
    end;
    PETROL_REGION_OBJECT_TYPE_ID:
    begin
      TMainFacade.GetInstance.AllPetrolRegions.MakeList(cmbxObject.Items, false, true);
      FCurrentObjectList := TMainFacade.GetInstance.AllPetrolRegions;
    end;
    ORGANIZATION_OBJECT_TYPE_ID:
    begin
      (TMainFacade.GetInstance as TMainFacade).GRROrganizations.MakeList(cmbxObject.Items, True, true);
      FCurrentObjectList := (TMainFacade.GetInstance as TMainFacade).GRROrganizations;
    end;
  end;

  if cmbxObjectType.ItemIndex > -1 then
    gbxObjectSelector.Caption := cmbxObjectType.Items[cmbxObjectType.ItemIndex];

  SaveFilterSettings;
end;

function TfrmSingleObjectFilter.GetFilter: string;
var mi: TObjectTypeMapperItem;
begin
  if Assigned(SelectedObjectType) and Assigned(SelectedObject) then
  begin
    mi := TMainFacade.GetInstance.ObjectTypeMapper.GetItemByID(SelectedObjectType.ID);
    if Assigned(mi) then
      Result := mi.FilterColumnName + ' = ' + IntToStr(SelectedObject.ID);
  end;
end;

procedure TfrmSingleObjectFilter.cmbxObjectChange(Sender: TObject);
begin
  if Assigned(FOnSelectedObjectChanged) then
    FOnSelectedObjectChanged(Self);

  SaveFilterSettings;
end;

procedure TfrmSingleObjectFilter.actnApplyFilterExecute(Sender: TObject);
var i : integer;
    o : TRegisteredIDObject;
begin
  cmbxObjectTypeChange(Sender);

  FFilterObjects := TRegisteredIDObjects.Create;

  for i := 0 to cmbxObject.Items.Count - 1 do
  if pos (edtFilter.Text, cmbxObject.Items[i]) > 0 then
  begin
    o := TRegisteredIDObject.Create(FFilterObjects);
    o := cmbxObject.Items.Objects[i] as TRegisteredIDObject;
    FFilterObjects.Add(o);
  end;

  FFilterObjects.MakeList(cmbxObject.Items, true, true);

  if FFilterObjects.Count > 0 then cmbxObject.ItemIndex := 0;

  FFilterObjects.Free;
end;

procedure TfrmSingleObjectFilter.cmbxVersionChange(Sender: TObject);
begin
  TMainFacade.GetInstance.ActiveVersion := SelectedVersion as TVersion;
  cmbxObjectTypeChange(Sender);
end;

function TfrmSingleObjectFilter.GetSelectedVersion: TIDObject;
begin
  if cmbxVersion.ItemIndex > -1 then
    Result := TIDObject(cmbxVersion.Items.Objects[cmbxVersion.ItemIndex])
  else
    Result := nil;
end;

destructor TfrmSingleObjectFilter.Destroy;
begin
  inherited;
end;

procedure TfrmSingleObjectFilter.SaveFilterSettings;
begin
  if TMainFacade.GetInstance.DBGates.Autorized then
  begin
    if Assigned(SelectedObjectType) then
      TMainFacade.GetInstance.SystemSettings.SectionByName['FilterState'].SectionValues.Values['SelectedObjectType'] := IntToStr(SelectedObjectType.ID);
    if Assigned(SelectedObject) then
      TMainFacade.GetInstance.SystemSettings.SectionByName['FilterState'].SectionValues.Values['SelectedObject'] := IntToStr(SelectedObject.ID);
    TMainFacade.GetInstance.SystemSettings.SaveToFile('FilterState', true);  
  end;
end;

end.
