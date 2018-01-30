unit RRManagerEditCommands;

interface

uses Classes, RRManagerBaseObjects, RRManagerObjects, ClientCommon, ComCtrls,
     RRmanagerPersistentObjects, RRManagerDataPosters, SysUtils, RRManagerBaseGUI,
     Controls, Windows;


type
  TVersionBaseSaveAction = class(TBaseAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; overload; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TStructureBaseSaveAction = class(TBaseAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; overload; override;
    constructor Create(AOwner: TComponent); override;
  end;

  THorizonBaseSaveAction = class(TBaseAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; overload; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TSubstructureBaseSaveAction = class(TBaseAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; overload; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TLayerBaseSaveAction = class(TBaseAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; overload; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TBedBaseSaveAction = class(TBaseAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; overload; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TLicenseZoneBaseSaveAction = class(TBaseAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; overload; override;
    constructor Create(AOwner: TComponent); override;
  end;






  TStructureBaseEditAction = class(TBaseAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; overload; override;
    constructor Create(AOwner: TComponent); override;
  end;


  TStructureBaseDeleteAction = class(TBaseAction)
  public
    function    Execute(ABaseObject: TBaseObject): boolean; overload; override;
    constructor Create(AOwner: TComponent); override;
  end;





implementation

uses RRManagerStructureInfoForm, ClientProgressBarForm, Forms, BaseDicts, Facade, LicenseZonePoster, BaseObjects;

{ TStructureBaseEditAction }

constructor TStructureBaseEditAction.Create(AOwner: TComponent);
begin
  inherited;
  Caption := '������������� ���������';
  CanUndo := false;
end;

function TStructureBaseEditAction.Execute(
  ABaseObject: TBaseObject): boolean;
var  actn: TStructureBaseSaveAction;
begin
  Result := true;
  if not Assigned(frmStructureInfo) then frmStructureInfo := TfrmStructureInfo.Create(Self);
  frmStructureInfo.Prepare;
  frmStructureInfo.EditingObject := ABaseObject;


  if frmStructureInfo.ShowModal = mrOK then
  begin
    frmStructureInfo.Save;

    ABaseObject := (frmStructureInfo.Dlg.Frames[0] as TbaseFrame).EditingObject;
    actn := TStructureBaseSaveAction.Create(nil);
    actn.Execute(ABaseObject);
    actn.Free;
  end;
end;

{ TStructureBaseDeleteAction }

constructor TStructureBaseDeleteAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  Caption := '������� ���������';
  Visible := false;
end;

function TStructureBaseDeleteAction.Execute(
  ABaseObject: TBaseObject): boolean;
var dp: RRManagerPersistentObjects.TDataPoster;
begin
  Result := false;
  if MessageBox(0, PChar('�� ������������� ������ ������� ��������� ' + #13#10 +
                         ABaseObject.List(AllOpts.Current.ListOption, false, false) + '?'), '������',
                         MB_YESNO+MB_APPLMODAL+MB_DEFBUTTON2+MB_ICONQUESTION) = ID_YES then
  begin
    dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TStructureDataPoster];
    dp.DeleteFromDB(ABaseObject);
    Result := true;
  end;
end;

{ TStructureBaseSaveAction }

constructor TStructureBaseSaveAction.Create(AOwner: TComponent);
begin
  inherited;
  Caption := '��������� ���������';
  CanUndo := false;
end;

function TStructureBaseSaveAction.Execute(
  ABaseObject: TBaseObject): boolean;
var s: TOldStructure;
    iSecondStructureTypeID: integer;
    dp: RRManagerPersistentObjects.TDataPoster;
    cls: RRManagerPersistentObjects.TDataPosterClass;
    d: TDict;
    i: integer;
begin
  // ���������� �����
  FreeAndNil(frmProgressBar);
  frmProgressBar := TfrmProgressBar.Create(Application.MainForm);
  frmProgressBar.FormStyle := fsStayOnTop;
  frmProgressBar.InitProgressBar('��������� ������ � ���� ������', aviCopyFile);

  s := ABaseObject as TOldStructure;
  iSecondStructureTypeID := s.StructureTypeID;


  // ����� ������
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TStructureDataPoster];
  // �������������� ���������
  dp.PostToDB(ABaseObject);

  s.PetrolRegions.Update(s.PetrolRegions);
  s.Districts.Update(s.Districts);
  s.TectonicStructs.Update(s.TectonicStructs);

  // ����� ������ �������
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TStructureHistoryDataPoster];
  // ���������� �������(��������) �������
  dp.PostToDB(s.History);

  cls := nil;

  case iSecondStructureTypeID of
    // ����������
    1: cls := TDiscoveredStructureDataPoster;
    // �������������
    2: cls := TPreparedStructureDataPoster;
    // � �������
    3: cls := TDrilledStructureDataPoster;
    // �������������
    4: cls := TFieldDataPoster;
  end;

  if Assigned(cls) then
  begin
    // ����� ������
    dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[cls];
    // �������������� ���������
    dp.PostToDB(ABaseObject);
  end;

  d := (TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName[UpperCase('spd_get_report_authors')];
  d.Update(false, true);
  d := (TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName[UpperCase('spd_get_seismogroup_number')];
  d.Update(false, true);


  // ���������� �������� - ��� �������� � �������
  if iSecondStructureTypeID = 3 then
  begin
    dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TDrilledStructureWellDataPoster];
    dp.PostToDB((ABaseObject as TOldDrilledStructure).Wells);
  end
  else if iSecondStructureTypeID = 4 then
    s.LicenseZones.Update(s.LicenseZones);

  // ����� ������ � ��������� ���������
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TAccountVersionDataPoster];
  // �������� ������ � ��������� ������
  dp.PostToDB(s.Versions);

  // ���������� ���������
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TParameterDataPoster];
  for i := 0 to s.Versions.Count - 1 do
    dp.PostToDB(s.Versions.Items[i].Parameters);

  Result := true;
  FreeAndNil(frmProgressBar);
end;

{ TLayerBaseBaseSaveAction }

constructor TLayerBaseSaveAction.Create(AOwner: TComponent);
begin
  inherited;
  Caption := '��������� ������������ �����';
  CanUndo := false;
end;

function TLayerBaseSaveAction.Execute(
  ABaseObject: TBaseObject): boolean;
var dp, dpParam: RRManagerPersistentObjects.TDataPoster;
    lr: TOldLayer;
    i: integer;
begin
  // ���������� �����
  FreeAndNil(frmProgressBar);
  frmProgressBar := TfrmProgressBar.Create(Application.MainForm);
  frmProgressBar.FormStyle := fsStayOnTop;
  frmProgressBar.InitProgressBar('��������� ������ � ���� ������', aviCopyFile);


  // ����� ������
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TLayerDataPoster];
  // ��������� ������������
  dp.PostToDB(ABaseObject);

  lr := ABaseObject as TOldLayer;

  // ����� ������ � ��������� ���������
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TAccountVersionDataPoster];
  // ��������� ����� ������, �� �� �������� ������
  dp.PostToDB(lr.Versions, false);

  if assigned(lr.Substructure) then
  begin
    // �������� ���
    // �������, ������ � ���������
    // � ��������� ������

    // ����� ��� ���� ������ � ��������� �������
    // �� ������� �� ����������
    dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TResourceDataPoster];
    dpParam := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TParameterDataPoster];

    for i := 0 to lr.Versions.Count - 1 do
    begin
      dp.PostToDB(lr.Versions.Items[i].Resources);
      dpParam.PostToDB(lr.Versions.Items[i].Parameters);
    end;
  end
  else
  if Assigned(lr.Bed) then
  begin
    // �������� ���
    // �������, ������ � ���������
    // � ��������� ������
    // ����� ��� ���� ������ � ��������� �������
    // �� ������� �� ����������
    dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TReserveDataPoster];
    dpParam := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TParameterDataPoster];

    for i := 0 to lr.Versions.Count - 1 do
    begin
      dp.PostToDB(lr.Versions.Items[i].Reserves);
      dpParam.PostToDB(lr.Versions.Items[i].Parameters);
    end;
  end;
  Result := true;
  FreeAndNil(frmProgressBar);  
end;

{ TSubstructureBaseSaveAction }

constructor TSubstructureBaseSaveAction.Create(AOwner: TComponent);
begin
  inherited;
  Caption := '��������� ������������';
  CanUndo := false;
end;

function TSubstructureBaseSaveAction.Execute(
  ABaseObject: TBaseObject): boolean;
var dp: RRManagerPersistentObjects.TDataPoster;
    s: TOldSubstructure;
    i: integer;
begin
  // ���������� �����
  FreeAndNil(frmProgressBar);
  frmProgressBar := TfrmProgressBar.Create(Application.MainForm);
  frmProgressBar.FormStyle := fsStayOnTop;
  frmProgressBar.InitProgressBar('��������� ������ � ���� ������', aviCopyFile);


  // ����� ������
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TSubstructureDataPoster];
  // ��������� ������������
  dp.PostToDB(ABaseObject);

  s := ABaseObject as TOldSubstructure;
  // ����� ������ � ��������� ���������
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TAccountVersionDataPoster];
  // �������� ������ � ��������� ������
  dp.PostToDB(s.Versions);

  // ���������� ���������
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TParameterDataPoster];
  for i := 0 to s.Versions.Count - 1 do
    dp.PostToDB(s.Versions.Items[i].Parameters);
  Result := true;
  FreeAndNil(frmProgressBar);  
end;

{ THorizonBaseSaveAction }

constructor THorizonBaseSaveAction.Create(AOwner: TComponent);
begin
  inherited;
  Caption := '��������� ��������';
  CanUndo := false;
end;

function THorizonBaseSaveAction.Execute(ABaseObject: TBaseObject): boolean;
var dp: RRManagerPersistentObjects.TDataPoster;
    h: TOldHorizon;
    i: integer;
begin
  // ���������� �����
  FreeAndNil(frmProgressBar);
  frmProgressBar := TfrmProgressBar.Create(Application.MainForm);
  frmProgressBar.FormStyle := fsStayOnTop;
  frmProgressBar.InitProgressBar('��������� ������ � ���� ������', aviCopyFile);


  // ����� ������
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[THorizonDataPoster];
  // �������������� ���������
  dp.PostToDB(ABaseObject);

  h := ABaseObject as TOldHorizon;

  // ���������� ��������� ������
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[THorizonFundTypeDataPoster];
  dp.PostToDB(h.FundTypes, true);

  // ����� ������ � ��������� ���������
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TAccountVersionDataPoster];
  // �������� ������ � ��������� ������
  dp.PostToDB(h.Versions);

  // ���������� ���������
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TParameterDataPoster];
  for i := 0 to h.Versions.Count - 1 do
    dp.PostToDB(h.Versions.Items[i].Parameters);
  Result := true;
  FreeAndNil(frmProgressBar);  
end;

{ TBedBaseSaveAction }

constructor TBedBaseSaveAction.Create(AOwner: TComponent);
begin
  inherited;
  Caption := '��������� ������';
  CanUndo := false;
end;

function TBedBaseSaveAction.Execute(ABaseObject: TBaseObject): boolean;
var dp, dpd: RRManagerPersistentObjects.TDataPoster;
    b: TOldBed;
    i: integer;
begin
  // ���������� �����
  FreeAndNil(frmProgressBar);
  frmProgressBar := TfrmProgressBar.Create(Application.MainForm);
  frmProgressBar.FormStyle := fsStayOnTop;
  frmProgressBar.InitProgressBar('��������� ������ � ���� ������', aviCopyFile);


  // ����� ������
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TBedDataPoster];
  // ��������� ������������
  dp.PostToDB(ABaseObject);

  b := ABaseObject as TOldBed;
  // ��������� ����
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TLayerDataPoster];
  dp.PostToDB(b.Layers);
  // ����� ������ � ��������� ���������
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TAccountVersionDataPoster];
  // �������� ������ � ��������� ������
  dp.PostToDB(b.Versions);

  // ���������� ���������
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TParameterDataPoster];
  dpd := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TReserveDataPoster];
  for i := 0 to b.Versions.Count - 1 do
  begin
    dpd.PostToDB(b.Versions.Items[i].Reserves);
    dp.PostToDB(b.Versions.Items[i].Parameters);
  end;
  Result := true;
  FreeAndNil(frmProgressBar);    
end;

{ TVersionBaseSaveAction }

constructor TVersionBaseSaveAction.Create(AOwner: TComponent);
begin
  inherited;
  Caption := '��������� ������';
  CanUndo := false;
end;

function TVersionBaseSaveAction.Execute(ABaseObject: TBaseObject): boolean;
var dp: RRManagerPersistentObjects.TDataPoster;
begin
  Result := true;
  // ����� ������
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TVersionDataPoster];
  // �������������� ���������
  dp.PostToDB(ABaseObject);
end;

{ TLicenseZoneBaseSaveAction }

constructor TLicenseZoneBaseSaveAction.Create(AOwner: TComponent);
begin
  inherited;
  Caption := '��������� ������������ �������';
  CanUndo := false;
end;


function TLicenseZoneBaseSaveAction.Execute(
  ABaseObject: TBaseObject): boolean;
var dp: RRManagerPersistentObjects.TDataPoster;
    ndp: TDataPoster;
    lz: TOldLicenseZone;
    i: integer;
begin
  // ���������� �����
  FreeAndNil(frmProgressBar);
  frmProgressBar := TfrmProgressBar.Create(Application.MainForm);
  frmProgressBar.FormStyle := fsStayOnTop;
  frmProgressBar.InitProgressBar('��������� ������ � ���� ������', aviCopyFile);


  // ����� ������
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TLicenseZoneDataPoster];
  // ��������� ������������
  dp.PostToDB(ABaseObject);

  lz := ABaseObject as TOldLicenseZone;

{  lz := ABaseObject as TOldLicenseZone;
  dp := AllPosters.Posters[TAccountVersionDataPoster];
  // �������� ������ � ��������� ������
  dp.PostToDB(lz.Versions);

  // ���������� ���������
  dp := AllPosters.Posters[TParameterDataPoster];
  for i := 0 to lz.Versions.Count - 1 do
    dp.PostToDB(lz.Versions.Items[i].Parameters);}

  ndp := TMainFacade.GetInstance.DataPosterByClassType[TLicenseConditionValuePoster];
  for i := 0 to lz.LicenseConditionValues.DeletedObjects.Count - 1 do
    ndp.DeleteFromDB(lz.LicenseConditionValues.DeletedObjects.Items[i], lz.LicenseConditionValues);

  ndp.PostToDB(lz.LicenseConditionValues, nil);

  Result := true;
  FreeAndNil(frmProgressBar);  
end;


end.

