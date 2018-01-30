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
  Caption := 'Редактировать структуру';
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
  Caption := 'Удалить структуру';
  Visible := false;
end;

function TStructureBaseDeleteAction.Execute(
  ABaseObject: TBaseObject): boolean;
var dp: RRManagerPersistentObjects.TDataPoster;
begin
  Result := false;
  if MessageBox(0, PChar('Вы действительно хотите удалить структуру ' + #13#10 +
                         ABaseObject.List(AllOpts.Current.ListOption, false, false) + '?'), 'Вопрос',
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
  Caption := 'Сохранить структуру';
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
  // показываем форму
  FreeAndNil(frmProgressBar);
  frmProgressBar := TfrmProgressBar.Create(Application.MainForm);
  frmProgressBar.FormStyle := fsStayOnTop;
  frmProgressBar.InitProgressBar('сохраняем объект в базу данных', aviCopyFile);

  s := ABaseObject as TOldStructure;
  iSecondStructureTypeID := s.StructureTypeID;


  // берем постер
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TStructureDataPoster];
  // инициализируем коллекцию
  dp.PostToDB(ABaseObject);

  s.PetrolRegions.Update(s.PetrolRegions);
  s.Districts.Update(s.Districts);
  s.TectonicStructs.Update(s.TectonicStructs);

  // берем постер истории
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TStructureHistoryDataPoster];
  // записываем элемент(элементы) истории
  dp.PostToDB(s.History);

  cls := nil;

  case iSecondStructureTypeID of
    // Выявленные
    1: cls := TDiscoveredStructureDataPoster;
    // подгтовленные
    2: cls := TPreparedStructureDataPoster;
    // в бурении
    3: cls := TDrilledStructureDataPoster;
    // месторождения
    4: cls := TFieldDataPoster;
  end;

  if Assigned(cls) then
  begin
    // берем постер
    dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[cls];
    // инициализируем коллекцию
    dp.PostToDB(ABaseObject);
  end;

  d := (TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName[UpperCase('spd_get_report_authors')];
  d.Update(false, true);
  d := (TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName[UpperCase('spd_get_seismogroup_number')];
  d.Update(false, true);


  // записываем скважины - для структур в бурении
  if iSecondStructureTypeID = 3 then
  begin
    dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TDrilledStructureWellDataPoster];
    dp.PostToDB((ABaseObject as TOldDrilledStructure).Wells);
  end
  else if iSecondStructureTypeID = 4 then
    s.LicenseZones.Update(s.LicenseZones);

  // берем постер и сохраняем документы
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TAccountVersionDataPoster];
  // затираем версии и добавляем заново
  dp.PostToDB(s.Versions);

  // записываем параметры
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
  Caption := 'Сохранить продуктивный пласт';
  CanUndo := false;
end;

function TLayerBaseSaveAction.Execute(
  ABaseObject: TBaseObject): boolean;
var dp, dpParam: RRManagerPersistentObjects.TDataPoster;
    lr: TOldLayer;
    i: integer;
begin
  // показываем форму
  FreeAndNil(frmProgressBar);
  frmProgressBar := TfrmProgressBar.Create(Application.MainForm);
  frmProgressBar.FormStyle := fsStayOnTop;
  frmProgressBar.InitProgressBar('сохраняем объект в базу данных', aviCopyFile);


  // берем постер
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TLayerDataPoster];
  // сохраняем подструктуру
  dp.PostToDB(ABaseObject);

  lr := ABaseObject as TOldLayer;

  // берем постер и сохраняем документы
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TAccountVersionDataPoster];
  // добавляем новые версии, но не затираем старые
  dp.PostToDB(lr.Versions, false);

  if assigned(lr.Substructure) then
  begin
    // затираем все
    // ресурсы, запасы и параметры
    // и добавляем заново

    // берем еще один постер и сохраняем ресурсы
    // по каждому из документов
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
    // затираем все
    // ресурсы, запасы и параметры
    // и добавляем заново
    // берем еще один постер и сохраняем ресурсы
    // по каждому из документов
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
  Caption := 'Сохранить подструктуру';
  CanUndo := false;
end;

function TSubstructureBaseSaveAction.Execute(
  ABaseObject: TBaseObject): boolean;
var dp: RRManagerPersistentObjects.TDataPoster;
    s: TOldSubstructure;
    i: integer;
begin
  // показываем форму
  FreeAndNil(frmProgressBar);
  frmProgressBar := TfrmProgressBar.Create(Application.MainForm);
  frmProgressBar.FormStyle := fsStayOnTop;
  frmProgressBar.InitProgressBar('сохраняем объект в базу данных', aviCopyFile);


  // берем постер
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TSubstructureDataPoster];
  // сохраняем подструктуру
  dp.PostToDB(ABaseObject);

  s := ABaseObject as TOldSubstructure;
  // берем постер и сохраняем документы
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TAccountVersionDataPoster];
  // затираем версии и добавляем заново
  dp.PostToDB(s.Versions);

  // записываем параметры
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
  Caption := 'Сохранить горизонт';
  CanUndo := false;
end;

function THorizonBaseSaveAction.Execute(ABaseObject: TBaseObject): boolean;
var dp: RRManagerPersistentObjects.TDataPoster;
    h: TOldHorizon;
    i: integer;
begin
  // показываем форму
  FreeAndNil(frmProgressBar);
  frmProgressBar := TfrmProgressBar.Create(Application.MainForm);
  frmProgressBar.FormStyle := fsStayOnTop;
  frmProgressBar.InitProgressBar('сохраняем объект в базу данных', aviCopyFile);


  // берем постер
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[THorizonDataPoster];
  // инициализируем коллекцию
  dp.PostToDB(ABaseObject);

  h := ABaseObject as TOldHorizon;

  // записываем коллекцию фондов
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[THorizonFundTypeDataPoster];
  dp.PostToDB(h.FundTypes, true);

  // берем постер и сохраняем документы
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TAccountVersionDataPoster];
  // затираем версии и добавляем заново
  dp.PostToDB(h.Versions);

  // записываем параметры
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
  Caption := 'Сохранить залежь';
  CanUndo := false;
end;

function TBedBaseSaveAction.Execute(ABaseObject: TBaseObject): boolean;
var dp, dpd: RRManagerPersistentObjects.TDataPoster;
    b: TOldBed;
    i: integer;
begin
  // показываем форму
  FreeAndNil(frmProgressBar);
  frmProgressBar := TfrmProgressBar.Create(Application.MainForm);
  frmProgressBar.FormStyle := fsStayOnTop;
  frmProgressBar.InitProgressBar('сохраняем объект в базу данных', aviCopyFile);


  // берем постер
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TBedDataPoster];
  // сохраняем подструктуру
  dp.PostToDB(ABaseObject);

  b := ABaseObject as TOldBed;
  // сохраняем слои
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TLayerDataPoster];
  dp.PostToDB(b.Layers);
  // берем постер и сохраняем документы
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TAccountVersionDataPoster];
  // затираем версии и добавляем заново
  dp.PostToDB(b.Versions);

  // записываем параметры
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
  Caption := 'Сохранить версию';
  CanUndo := false;
end;

function TVersionBaseSaveAction.Execute(ABaseObject: TBaseObject): boolean;
var dp: RRManagerPersistentObjects.TDataPoster;
begin
  Result := true;
  // берем постер
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TVersionDataPoster];
  // инициализируем коллекцию
  dp.PostToDB(ABaseObject);
end;

{ TLicenseZoneBaseSaveAction }

constructor TLicenseZoneBaseSaveAction.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Сохранить лицензионный участок';
  CanUndo := false;
end;


function TLicenseZoneBaseSaveAction.Execute(
  ABaseObject: TBaseObject): boolean;
var dp: RRManagerPersistentObjects.TDataPoster;
    ndp: TDataPoster;
    lz: TOldLicenseZone;
    i: integer;
begin
  // показываем форму
  FreeAndNil(frmProgressBar);
  frmProgressBar := TfrmProgressBar.Create(Application.MainForm);
  frmProgressBar.FormStyle := fsStayOnTop;
  frmProgressBar.InitProgressBar('сохраняем объект в базу данных', aviCopyFile);


  // берем постер
  dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TLicenseZoneDataPoster];
  // сохраняем подструктуру
  dp.PostToDB(ABaseObject);

  lz := ABaseObject as TOldLicenseZone;

{  lz := ABaseObject as TOldLicenseZone;
  dp := AllPosters.Posters[TAccountVersionDataPoster];
  // затираем версии и добавляем заново
  dp.PostToDB(lz.Versions);

  // записываем параметры
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

