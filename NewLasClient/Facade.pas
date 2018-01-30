unit Facade;

interface

uses BaseFacades, Registrator, Classes, DBGate, SDFacade, Well, Area, LasFile,
BaseObjects, LasFileDataPoster, Organization, Material, MaterialPoster, Employee;

type
  TMainFacade = class (TSDFacade)
  private
    FRegistrator: TRegistrator;
    FAllLasWells : TWells;
    FAllLasOrg : TOrganizations;
    FAllCurves : TCurves;
    FLasFilter : string;
    FFormFilter : string;
    FExportFilter : String;
    FSingleWellFilter : string;
    FOrgFilter : string;
    FAllCurveCategoryes : TCurveCategories;
    FAllLasFiles : TLasFiles;
    FUnAssignedWell:TWell;
    FAllFormWells : TWells;
    FSingleWell:TWells;
    FAllExportWells : TWells;
    FAllSimpleDocuments : TSimpleDocuments;
    FAllDocTypes : TDocumentTypes;
    FAllMaterialLocations : TMaterialLocations;
    FAllEmployees : TEmployees;
    FAllMaterialCurves : TMaterialCurves;
    FAllMaterialBindings : TMaterialBindings;
    FAllObjectBindTypes: TObjectBindTypes;

    FWellMaterialBindings : TMaterialBindings;
    FWellMaterialBindingFilter : String;
    FFolderContents: TLasFileContents;
    function GetLasFileContents: TLasFileContents;

  protected
    function GetRegistrator: TRegistrator; override;
    function GetAllLasWells: TWells;
    function GetAllLasOrg: TOrganizations;
    function GetAllCurves : TCurves;
    function GetAllCurveCategories : TCurveCategories;
    function GetAllLasFiles : TLasFiles;
    function GetUnAssignedWell : TWell;
    function GetAllFormWells : TWells;
    function GetDataPosterByClassType(ADataPosterClass: TDataPosterClass): TDataPoster; override;
    function GetSingleWell : TWells;
    function GetAllExportWells : TWells;
    function GetAllSimpleDocuments : TSimpleDocuments;
    function GetAllDocTypes : TDocumentTypes;
    function GetAllMaterialLocations : TMaterialLocations;
    function GetAllEmployees : TEmployees;
    function GetAllMaterialCurves : TMaterialCurves;
    function GetAllMaterialBindings : TMaterialBindings;
    function GetAllObjectBindTypes : TObjectBindTypes;
    function GetWellMaterialBindings : TMaterialBindings;

  public
    class function GetInstance: TMainFacade;
    property AllLasWells: TWells read GetAllLasWells;
    property AllLasOrg: TOrganizations read GetAllLasOrg;
    property AllCurves : TCurves read GetAllCurves;
    property AllCurveCategories : TCurveCategories read GetAllCurveCategories;
    property AllLasFiles : TLasFiles read GetAllLasFiles;
    property UnAssignedWell : TWell read  GetUnAssignedWell write FUnAssignedWell;
    property AllFormWells : TWells read GetAllFormWells;
    property LasFilter : string read FLasFilter write FLasFilter;
    property OrgFilter : string read FOrgFilter write FOrgFilter;
    property FormFilter : string read FFormFilter write FFormFilter;
    property ExportFilter : string read FExportFilter write FExportFilter;
    property AllExportWells : TWells read GetAllExportWells;
    property AllSimpleDocuments : TSimpleDocuments read GetAllSimpleDocuments;
    property AllDocTypes : TDocumentTypes read GetAllDocTypes;
    property AllMaterialLocations : TMaterialLocations read GetAllMaterialLocations;
    property AllEmployees : TEmployees read GetAllEmployees;
    property AllmaterialCurves : TMaterialCurves read  GetAllMaterialCurves;
    property AllMaterialBindings : TMaterialBindings read  GetAllMaterialBindings;
    property AllObjectBindTypes: TObjectBindTypes read GetAllObjectBindTypes;
    property AllWellMaterialBindings : TMaterialBindings read  GetWellMaterialBindings;
    property WellMaterialBindingFilter : string read FWellMaterialBindingFilter write FWellMaterialBindingFilter;
    procedure LoadDicts;



    procedure SkipLasWells;
    procedure SkipExportWells;
    procedure SkipFormWells;
    procedure SkipOrg;
    procedure SkipUnAssignedWell;
    procedure SkipCurveCategorys;
    procedure CreateFormWells (ALasFileContents :TLasFileContents);
    procedure AddToFormWells(Well: TWell; ALasFiles: TLasFiles; DeleteFromWell: TWell; LasFileContents :TLasFileContents);
    procedure SkipWellMaterialBinding;


    // чтение контентов
    procedure ReadContents(AFolder: string; ClearContents: boolean);
    property  FolderContents: TLasFileContents read GetLasFileContents;

    // в конструкторе создаютс€ и настраиваютс€ вс€кие
    // необходимые в скором времени вещи
    constructor Create(AOwner: TComponent); override;

  end;

  TConcreteRegistrator = class(TRegistrator)
  public
    constructor Create; override;
  end;

implementation

uses SysUtils, CommonStepForm, Forms;


{ TMDFacade }

constructor TMainFacade.Create(AOwner: TComponent);
begin
  inherited;
  // настройка соединени€ с бд
  //DBGates.ServerClassString := 'RiccServer.CommonServer';
  DBGates.AutorizationMethod := amEnum;
  DBGates.NewAutorizationMode := false;
  // об€зательно также тип клиента пр€м здесь указать
end;

function TMainFacade.GetRegistrator: TRegistrator;
begin
  if not Assigned(FRegistrator) then
    FRegistrator := TConcreteRegistrator.Create;
  Result := FRegistrator;
end;


{ TConcreteRegistrator }

constructor TConcreteRegistrator.Create;
begin
  inherited;
  AllowedControlClasses.Add(TStringsRegisteredObject);
  AllowedControlClasses.Add(TTreeViewRegisteredObject);
end;

class function TMainFacade.GetInstance: TMainFacade;
const FInstance: TMainFacade = nil;
begin
  if FInstance = nil then
    FInstance :=  Create(nil);
  Result := FInstance;
end;


function TMainFacade.GetAllLasWells: TWells;
begin
  if not Assigned (FAllLasWells) then
  begin
    FAllLasWells := TWells.Create;
    FAllLasWells.Reload(FLasFilter, true);
  end;
  Result := FAllLasWells;
end;





procedure TMainFacade.SkipLasWells;
begin
  FreeAndNil(FAllLasWells);
end;

function TMainFacade.GetAllCurves: TCurves;
begin
  if not Assigned (FAllCurves) then
  begin
    FAllCurves := TCurves.Create;
    FAllCurves.Reload('', true);
  end;
  Result:=FAllCurves;
end;

function TMainFacade.GetDataPosterByClassType(
  ADataPosterClass: TDataPosterClass): TDataPoster;
begin

  Result := inherited GetDataPosterByClassType(ADataPosterClass);

  if Result is TCurveDataPoster then
    (Result as TCurveDataPoster).AllCurveCategories := AllCurveCategories;

  if Result is TLasFileDataPoster then
  begin
    (Result as TLasFileDataPoster).AllOrganizations := AllOrganizations;
    (Result as TLasFileDataPoster).AllEmployees := AllEmployees;
  end;

  if Result is TLasCurveDataPoster then
    (Result as TLasCurveDataPoster).AllCurves := AllCurves;

  if Result is TSimpleDocumentDataPoster then
  begin
    (Result as TSimpleDocumentDataPoster).AllDocTypes := AllDocTypes;
    (Result as TSimpleDocumentDataPoster).AllMaterialLocations := AllMaterialLocations;
    (Result as TSimpleDocumentDataPoster).AllOrganizations := AllOrganizations;
    (Result as TSimpleDocumentDataPoster).AllEmployees := AllEmployees;
  end;

  if Result is TMaterialCurveDataPoster then
  begin
    (Result as TMaterialCurveDataPoster).AllSimpleDocuments := AllSimpleDocuments;
    (Result as TMaterialCurveDataPoster).AllCurveCategoryes := AllCurveCategories;
  end;

  if Result is TMaterialBindingDataPoster then
  begin
    (Result as TMaterialBindingDataPoster).AllSimpleDocuments := AllSimpleDocuments;
    (Result as TMaterialBindingDataPoster).AllObjectBindTypes := AllObjectBindTypes;
  end;
end;

function TMainFacade.GetAllCurveCategories: TCurveCategories;
begin
   if not Assigned (FAllCurveCategoryes) then
  begin
    FAllCurveCategoryes := TCurveCategories.Create;
    FAllCurveCategoryes.Reload('', true);
  end;
  Result:=FAllCurveCategoryes;
end;

function TMainFacade.GetAllLasFiles: TLasFiles;
begin
  if not Assigned (FAllLasFiles) then
  begin
    FAllLasFiles := TLasFiles.Create;
    FAllLasFiles.Reload('', true);
  end;
  Result:=FAllLasFiles;
end;

function TMainFacade.GetAllLasOrg: TOrganizations;
begin
  if not Assigned (FAllLasOrg) then
  begin
    FAllLasOrg := TOrganizations.Create;
    FAllLasOrg.Reload(FOrgFilter, true);
  end;
  Result := FAllLasOrg;
end;

procedure TMainFacade.SkipOrg;
begin
  FreeAndNil(FAllLasOrg);
end;

function TMainFacade.GetUnAssignedWell: TWell;
begin
  if not Assigned (FUnAssignedWell) then
  begin
    FUnAssignedWell:= TWell.Create(nil);
    FUnAssignedWell.NumberWell:='Ќеприв€заны';
    FUnAssignedWell.ID:=-1;
  end;
  Result := FUnAssignedWell;
end;

procedure TMainFacade.SkipUnAssignedWell;
begin
  FreeAndNil(FUnAssignedWell);
end;

function TMainFacade.GetAllFormWells: TWells;
begin
  if not Assigned (FAllFormWells) then
  begin
    FAllFormWells:= TWells.Create;
    FAllFormWells.Reload(FFormFilter, True);
  end;
  Result := FAllFormWells;
end;

procedure TMainFacade.SkipFormWells;
begin
  FreeAndNil(FAllFormWells);
end;

procedure TMainFacade.CreateFormWells(ALasFileContents: TLasFileContents);
  var
  i,j:Integer;
begin
  for i:=0 to AllFormWells.Count-1 do
  begin
    for j:=0 to ALasFileContents.Count-1  do
    begin
      If ( IntToStr(AllFormWells.Items[i].ID) = ALasFileContents.Items[j].StringsInBock.GetStringByName('UWI').Value) then
        begin
          ALasFileContents.Items[j].LasFile.WellID:=AllFormWells.Items[i].ID;
          AllFormWells.Items[i].LasFiles.Add(ALasFileContents.Items[j].LasFile, false, false);
          ALasFileContents.Items[j].LasFile.IsAssigned:= True;
        end;
    end;
  end;
  if (ALasFileContents.Count>0) then
  for i:=0 to ALasFileContents.Count-1 do
    if (ALasFileContents.Items[i].LasFile.IsAssigned=False) then
    UnAssignedWell.LasFiles.Add(ALasFileContents.Items[i].LasFile, False, False);

  AllFormWells.Add(UnAssignedWell, False, False );
end;

function TMainFacade.GetSingleWell: TWells;
begin
  if not Assigned (FSingleWell) then
  begin
    FSingleWell := TWells.Create;
    FSingleWell.Reload(FSingleWellFilter, true);
  end;
  Result := FSingleWell;
end;

procedure TMainFacade.AddToFormWells(Well: TWell;
  ALasFiles: TLasFiles; DeleteFromWell: TWell; LasFileContents : TLasFileContents);
var
  i,j,k, fpos:Integer;
  lf:TLasFile;
  w:TWell;
begin
  w := AllFormWells.ItemsByID[Well.ID] as TWell;
  if not Assigned(w) then
  begin
    w := AllFormWells.Add as TWell;
    w.Assign(Well);
  end;

  ALasFiles.OwnsObjects:=false;

  w.LasFiles.AddObjects(ALasFiles, False, False);
  for i:=0 to LasFileContents.Count-1 do
    begin
      for j:=0 to ALasFiles.Count-1 do
        if (LasFileContents.Items[i].LasFile.OldFileName=ALasFiles.Items[j].OldFileName) then
          begin
            LasFileContents.Items[i].StringsInBock.GetStringByName('WELL').Value:=w.NumberWell;
            LasFileContents.Items[i].StringsInBock.GetStringByName('WELL').State:=Detected;
            LasFileContents.Items[i].StringsInBock.GetStringByName('FLD').Value:=w.Area.Name;
            LasFileContents.Items[i].StringsInBock.GetStringByName('FLD').State:=Detected;
            LasFileContents.Items[i].StringsInBock.GetStringByName('UWI').Value:=IntToStr(w.ID);
            LasFileContents.Items[i].StringsInBock.GetStringByName('UWI').State:=Detected;

          end;
    end;

  DeleteFromWell.LasFiles.OwnsObjects := false;

  for i := 0 to ALasFiles.Count - 1 do
    DeleteFromWell.LasFiles.Remove(ALasFiles.Items[i]);

  DeleteFromWell.LasFiles.OwnsObjects := true;

end;



function TMainFacade.GetAllExportWells: TWells;
begin
  if not Assigned (FAllExportWells) then
  begin
    FAllExportWells:= TWells.Create;
    FAllExportWells.Reload(FExportFilter, True);
  end;
  Result := FAllExportWells;
end;

function TMainFacade.GetAllSimpleDocuments: TSimpleDocuments;
begin
   if not Assigned (FAllSimpleDocuments) then
  begin
    FAllSimpleDocuments := TSimpleDocuments.Create;
    FAllSimpleDocuments.Reload('MATERIAL_TYPE_ID IN (41,42)', true);
  end;
  Result := FAllSimpleDocuments;
end;

function TMainFacade.GetAllDocTypes: TDocumentTypes;
begin
    if not Assigned (FAllDocTypes) then
  begin
    FAllDocTypes := TDocumentTypes.Create;
    FAllDocTypes.Reload('', true);
  end;
  Result := FAllDocTypes;
end;

function TMainFacade.GetAllEmployees: TEmployees;
begin
  if not Assigned (FAllEmployees) then
  begin
    FAllEmployees := TEmployees.Create;
    FAllEmployees.Reload('', true);
  end;
  Result := FAllEmployees;
end;

function TMainFacade.GetAllMaterialLocations: TMaterialLocations;
begin
  if not Assigned (FAllMaterialLocations) then
  begin
    FAllMaterialLocations := TMaterialLocations.Create;
    FAllMaterialLocations.Reload('', true);
  end;
  Result := FAllMaterialLocations;
end;

procedure TMainFacade.LoadDicts;
begin

  frmStep.Free;
  frmStep := nil;

  try
    frmStep := TfrmStep.Create(Self);
    frmStep.Caption := '«агрузка справочников';
    frmStep.ShowLog := false;
    frmStep.InitProgress(1, 9, 1);

    frmStep.Show;
    frmStep.MakeStep('«агрузка скважин дл€ прив€зки');
    TMainFacade.GetInstance.AllExportWells;

    frmStep.MakeStep('«агрузка справочника организаций');
    TMainFacade.GetInstance.AllLasOrg;

    TMainFacade.GetInstance.AllCurves;
    TMainFacade.GetInstance.AllCurveCategories;
    TMainFacade.GetInstance.AllLasFiles;
    TMainFacade.GetInstance.AllSimpleDocuments;
    TMainFacade.GetInstance.AllDocTypes;
    TMainFacade.GetInstance.AllMaterialLocations;
    TMainFacade.GetInstance.AllEmployees;
  finally
    frmStep.Free;
    frmStep := nil;
  end;
end;



function TMainFacade.GetAllMaterialCurves: TMaterialCurves;
begin
  if not Assigned (FAllMaterialCurves) then
  begin
    FAllMaterialCurves := TMaterialCurves.Create;
    FAllMaterialCurves.Reload('', true);
  end;
  Result := FAllMaterialCurves;
end;

function TMainFacade.GetAllMaterialBindings: TMaterialBindings;
begin
  if not Assigned (FAllMaterialBindings) then
  begin
    FAllMaterialBindings := TMaterialBindings.Create;
    FAllMaterialBindings.Reload('OBJECT_BIND_TYPE_ID = 1', true);
  end;
  Result := FAllMaterialBindings;
end;

function TMainFacade.GetAllObjectBindTypes: TObjectBindTypes;
begin
   if not Assigned (FAllObjectBindTypes) then
  begin
    FAllObjectBindTypes := TObjectBindTypes.Create;
    FAllObjectBindTypes.Reload('OBJECT_BIND_TYPE_ID = 1', true);
  end;
  Result := FAllObjectBindTypes;
end;

procedure TMainFacade.SkipExportWells;
begin
  FreeAndNil(FAllExportWells);
end;

procedure TMainFacade.SkipCurveCategorys;
begin
  FreeAndNil (FAllCurveCategoryes);
end;

function TMainFacade.GetWellMaterialBindings: TMaterialBindings;
begin
   if not Assigned (FWellMaterialBindings) then
  begin
    FWellMaterialBindings := TMaterialBindings.Create;
    FWellMaterialBindingFilter:= FWellMaterialBindingFilter + ' and OBJECT_BIND_TYPE_ID = 1' ;
    FWellMaterialBindings.Reload(FWellMaterialBindingFilter, true);
  end;
  Result := FWellMaterialBindings;
end;

procedure TMainFacade.SkipWellMaterialBinding;
begin
 FreeAndNil(FWellMaterialBindings);
end;

function TMainFacade.GetLasFileContents: TLasFileContents;
begin
  if not Assigned(FFolderContents) then FFolderContents := TLasFileContents.Create;
  Result := FFolderContents;
end;

procedure TMainFacade.ReadContents(AFolder: string; ClearContents: boolean);
var i: Integer;
    sr: TSearchRec;
    cnt: TLasFileContent;
begin
  if ClearContents then FolderContents.Clear;
  try
    if FindFirst(AFolder + '\' + '*.*', faAnyFile, SR) = 0 then
    begin
      repeat
        if (sr.Attr and faDirectory) = 0 then
        begin
          if pos(AnsiUpperCase('.las'), AnsiUpperCase(sr.Name)) > 0 then
          begin
            cnt := TLasFileContent.Create(AFolder + '\' + sr.Name);
            FolderContents.Add(cnt);
          end;
        end
        else if (sr.Name  <> '.') and (sr.Name <> '..') then
          ReadContents(AFolder + '\' + sr.Name, false);

      until FindNext(SR) <> 0;
      FindClose(SR);
    end;
  except
    // так нельз€
  end;
end;

end.
