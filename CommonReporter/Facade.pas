unit Facade;

interface

uses BaseFacades, Registrator, Classes, DBGate, SDFacade, Well, ResearchGroup, Material, BaseObjects;



type


  TMainFacade = class (TSDFacade)
  private
    FRegistrator: TRegistrator;
    FSelectedWells: TSimpleWells;
    FOnAfterDownload: TNotifyEvent;
    FOnBeforeDownload: TNotifyEvent;
    FInfoGroups: TInfoGroups;
    function GetSelectedWells: TSimpleWells;
    function GetInfoGroups: TInfoGroups;
    procedure CreateDirectory(ADirName: string; DeleteIfExists: boolean);
  protected
    function GetRegistrator: TRegistrator; override;
    function GetDataPosterByClassType(
      ADataPosterClass: TDataPosterClass): TDataPoster; override;
  public
    property SelectedWells: TSimpleWells read GetSelectedWells;


    function  AddSelectedWell(AWell: TSimpleWell): TSimpleWell;
    procedure AddSelectedWells(AWells: TSimpleWells);
    procedure RemoveSelectedWell(AWell: TSimpleWell);
    procedure RemoveSelectedWells(AWells: TSimpleWells);

    procedure SaveSettings; override;
    procedure LoadSettings; override;

    procedure DownloadFiles(ABaseDir: string; DeleteIfExists: boolean);
    property  OnBeforeDownload: TNotifyEvent read FOnBeforeDownload write FOnBeforeDownload;
    property  OnAfterDownload: TNotifyEvent read FOnAfterDownload write FOnAfterDownload;

    property  InfoGroups: TInfoGroups read GetInfoGroups;
    procedure ApplyInfoGroup(AInfoGroup: TInfoGroup);
    procedure ApplyInfoGroups(AInfoGroups: TInfoGroups);


    class function GetInstance: TMainFacade;
    // в конструкторе создаются и настраиваются всякие
    // необходимые в скором времени вещи
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TConcreteRegistrator = class(TRegistrator)
  public
    constructor Create; override;
  end;

implementation

uses Options, SysUtils, Windows, FileUtils, WellPoster;

{ TMDFacade }

function TMainFacade.AddSelectedWell(AWell: TSimpleWell): TSimpleWell;
begin
  Result := SelectedWells.Add(AWell, True, True) as TSimpleWell;
end;

procedure TMainFacade.AddSelectedWells(AWells: TSimpleWells);
var i: integer;
begin
  for i := 0 to AWells.Count - 1 do
    AddSelectedWell(AWells.Items[i]); 
end;

constructor TMainFacade.Create(AOwner: TComponent);
begin
  inherited;
  SettingsFileName :=  ExtractFilePath(ParamStr(0))+'CRepSettings.ini';
  // настройка соединения с бд
  DBGates.ServerClassString := 'RiccServer.CommonServer';
  DBGates.AutorizationMethod := amEnum;
  DBGates.NewAutorizationMode := false;
  // обязательно также тип клиента прям здесь указать
end;

destructor TMainFacade.Destroy;
begin
  inherited;
end;

class function TMainFacade.GetInstance: TMainFacade;
begin
  Result := inherited GetInstance as TMainFacade;
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


function TMainFacade.GetSelectedWells: TSimpleWells;
begin
  if not Assigned(FSelectedWells) then
  begin
    FSelectedWells := TSimpleWells.Create;
    FSelectedWells.OwnsObjects := true;
    FSelectedWells.Poster := nil;
  end;

  Result := FSelectedWells;
end;

procedure TMainFacade.LoadSettings;
var fs: TFileSection;
    i: integer;
    sFilter: string;
begin
  // загружаем выбранные скважины
  fs := SystemSettings.SectionByName['SelectedWells'];

  sFilter := '';
  for i := 0 to fs.SectionValues.Count - 1 do
    sFilter := sFilter + ',' + fs.SectionValues.Values[fs.SectionValues.Names[i]];

  sFilter  := Format('WELL_UIN in (%s)', [copy(sFilter, 2, Length(sFilter))]);

  TMainFacade.GetInstance.SkipWells;
  TMainFacade.GetInstance.Filter := sFilter;
  AddSelectedWells(TMainFacade.GetInstance.AllWells);

  inherited;
end;

procedure TMainFacade.DownloadFiles(ABaseDir: string; DeleteIfExists: boolean);
var i, j: integer;
    sDirName, sInfoDirName: string;
    FGroups: TInfoGroups;
begin
  // для индивидуальных инфогрупп
  for i := 0 to SelectedWells.Count - 1 do
  begin
    if Assigned(FOnBeforeDownload) then FOnBeforeDownload(SelectedWells.Items[i]);

    if ((SelectedWells.Items[i].InfoGroups.Count > 0) and (not SelectedWells.Items[i].InfoGroups.AreSingle)) then
    begin
      sDirName := ABaseDir + '\' + SelectedWells.Items[i].Area.List() + '-' + SelectedWells.Items[i].NumberWell;
      sDirName := CorrectFileName(sDirName);
      // создаем папку для скважины
      CreateDirectory(sDirName, DeleteIfExists);
      // создаем папку для вложенного исследования
      for j := 0 to SelectedWells.Items[i].InfoGroups.Count - 1 do
      if not SelectedWells.Items[i].InfoGroups.Items[j].IsSingle then
      begin
        sInfoDirName := sDirName + '\' + SelectedWells.Items[i].InfoGroups.Items[j].UserFolderName;
        CreateDirectory(sInfoDirName, DeleteIfExists);

        SelectedWells.Items[i].InfoGroups.Items[j].RetrieveObjectInfo(SelectedWells.Items[i], sInfoDirName, SelectedWells);
      end;
    end;

    if Assigned(FOnAfterDownload) then FOnAfterDownload(SelectedWells.Items[i]);
  end;


  FGroups := TInfoGroups.Create;
  FGroups.OwnsObjects := false;
  //для инфогрупп, которые для всех скважин
  for i := 0 to SelectedWells.Count - 1 do
  begin
    if ((SelectedWells.Items[i].InfoGroups.Count > 0) and (SelectedWells.Items[i].InfoGroups.HaveSingle)) then
    begin
      // создаем папку для вложенного исследования
      for j := 0 to SelectedWells.Items[i].InfoGroups.Count - 1 do
      if SelectedWells.Items[i].InfoGroups.Items[j].IsSingle then
        FGroups.Add(SelectedWells.Items[i].InfoGroups.Items[j], false, true);
    end;
  end;

  for i := 0 to FGroups.Count - 1 do
  begin
    sDirName := ABaseDir + '\' + FGroups.Items[i].UserFolderName;
    // создаем папку для инфогруппы
    CreateDirectory(sDirName, DeleteIfExists);

    FGroups.Items[i].RetrieveObjectsInfo(SelectedWells, sDirName, SelectedWells);
  end;

  FGroups.Free;

end;

procedure TMainFacade.RemoveSelectedWell(AWell: TSimpleWell);
var w: TSimpleWell;
begin
  if SelectedWells.IndexOf(AWell) > -1 then
    SelectedWells.Remove(AWell)
  else
  begin
    w := SelectedWells.ItemsByID[AWell.ID] as TSimpleWell;
    SelectedWells.Remove(w);
  end;
end;

procedure TMainFacade.RemoveSelectedWells(AWells: TSimpleWells);
var i: integer;
begin
  for i := AWells.Count - 1 downto 0 do
    RemoveSelectedWell(AWells.Items[i]);
end;

procedure TMainFacade.SaveSettings;
var fs: TFileSection;
    i: integer;
begin
  // сохраняем выбранные скважины
  fs := SystemSettings.SectionByName['SelectedWells'];
  fs.SectionValues.Clear;
  SystemSettings.SaveToFile(fs.SectionName, true);
  for i := 0 to SelectedWells.Count - 1 do
    fs.SectionValues.Add('WELL_UIN' + IntToStr(i) + '=' + IntToStr(SelectedWells.Items[i].ID));

  inherited;
end;

function TMainFacade.GetInfoGroups: TInfoGroups;
begin
  if not Assigned(FInfoGroups) then
  begin
    FInfoGroups := TInfoGroups.Create;
    FInfoGroups.AddInfoGroupClass(TGKNGKLasFileInfoGroup);
    FInfoGroups.AddInfoGroupClass(TPetrophisicsReportInfoGroup);
    FInfoGroups.AddInfoGroupClass(TCoreDescriptionFileInfoGroup);
    FInfoGroups.AddInfoGroupClass(TSchlifDescriptionFileInfoGroup);
    FInfoGroups.AddInfoGroupClass(TSchlamDescriptionFileInfoGroup);
    FInfoGroups.AddInfoGroupClass(TInclinometrFileInfoGroup);
    FInfoGroups.AddInfoGroupClass(TGranulometryReportInfoGroup);
    FInfoGroups.AddInfoGroupClass(TCentrifugingReportInfoGroup);
    FInfoGroups.AddInfoGroupClass(TDMPetrofisicsFileInfoGroup);
    FInfoGroups.AddInfoGroupClass(TStLasFileInfoGroup);
    FInfoGroups.AddInfoGroupClass(TAKLasFileInfoGroup);
    FInfoGroups.AddInfoGroupClass(TAllLasFileCopyAnsi);
    FInfoGroups.AddInfoGroupClass(TAllLasFileCopyAscii);
    FInfoGroups.AddInfoGroupClass(TStandardSubdivisionReportInfoGroup);
  end;

  Result := FInfoGroups;
end;

procedure TMainFacade.ApplyInfoGroup(AInfoGroup: TInfoGroup);
var i: integer;
begin
  for i := 0 to SelectedWells.Count - 1 do
  if AInfoGroup.ObjectInfoExists(SelectedWells.Items[i]) then
    SelectedWells.Items[i].InfoGroups.Add(AInfoGroup, false, true);
end;

procedure TMainFacade.ApplyInfoGroups(AInfoGroups: TInfoGroups);
var i: integer;
begin
  for i := 0 to AInfoGroups.Count - 1 do
    ApplyInfoGroup(AInfoGroups.Items[i]);
end;

procedure TMainFacade.CreateDirectory(ADirName: string; DeleteIfExists: boolean);
begin
  if DeleteIfExists then
    if DirectoryExists(ADirName) then
       DeletePath(ADirName);

  if not DirectoryExists(ADirName) then
    CreatePath(ADirName);
end;


function TMainFacade.GetDataPosterByClassType(
  ADataPosterClass: TDataPosterClass): TDataPoster;
begin
  Result := inherited GetDataPosterByClassType(ADataPosterClass);
  if Result is TWellDynamicParametersDataPoster then
  begin
    (Result as TWellDynamicParametersDataPoster).AllCategories := AllCategoriesWells;
    (Result as TWellDynamicParametersDataPoster).AllStates := AllStatesWells;
    (Result as TWellDynamicParametersDataPoster).AllProfiles := AllProfiles;
    (Result as TWellDynamicParametersDataPoster).AllFluidTypes := AllFluidTypes;
    (Result as TWellDynamicParametersDataPoster).AllStratons := AllSimpleStratons;
    (Result as TWellDynamicParametersDataPoster).AllVersions := AllVersions;
  end;

end;

end.
