unit Options;

interface

uses Classes, IniFiles, SysUtils, FileUtils, Contnrs;

type

  TFileSection = class
  private
    FSectionName: string;
    FSectionValues: TStringList;
    FLoaded: boolean;
    function GetSectionValues: TStringList;
  public
    property Loaded: boolean read FLoaded write FLoaded;
    property SectionName: string read FSectionName write FSectionName;
    property SectionValues: TStringList read GetSectionValues;
    destructor Destroy; override;
  end;

  TFileSections = class(TObjectList)
  private
    function GetItems(Index: integer): TFileSection;
  public
    function Add(ASectionName: string): TFileSection;
    function GetSectionByName(ASectionName: string): TFileSection;
    property Items[Index: integer]: TFileSection read GetItems; default;
    constructor Create;
  end;

  // класс для опций
  TSystemSettings = class
  private
    FIniFile:  TIniFile;
    FFileName: string;
    FFileSections: TFileSections;
    function GetSections: TFileSections;
    function GetCount: integer;
    function GetSectionByName(const ASectionName: string): TFileSection;
  public
    // файл из которого грузим
    property    FileName: string read FFileName write FFileName;
    // список секций
    property    Sections: TFileSections read GetSections;
    // индексатор по имени
    property    SectionByName[const ASectionName: string]: TFileSection read GetSectionByName;

    // чтобы сохранить конкретные настройки эти методы надо переопределить
    // в потомках
    procedure   LoadFromFile(const NameSection: string); reintroduce;
    procedure   SaveToFile(const NameSection: string; const ImmediatelyUpdate: boolean);
    procedure   SaveAllToFile;

    

    constructor Create(const AFileName: string);
    destructor  Destroy; override;
  end;

implementation

uses Facade;

{ TSystemSettings }

constructor TSystemSettings.Create(const AFileName: string);
begin
  inherited Create;
  FFileName := AFileName;
end;

destructor TSystemSettings.Destroy;
begin
  FreeAndNil(FIniFile);
  FreeAndNil(FFileSections);
  inherited;
end;


function TSystemSettings.GetCount: integer;
var i: integer;
begin
  result := 0;
  for i := 0 to Sections.Count - 1 do
    Result := Result + Sections.Items[i].SectionValues.Count;
end;

function TSystemSettings.GetSectionByName(
  const ASectionName: string): TFileSection;
begin
  Result := Sections.Add(ASectionName);
  if not Result.Loaded then
  begin
    LoadFromFile(ASectionName);
    Result.Loaded := true;
  end;
end;

function TSystemSettings.GetSections: TFileSections;
begin
  if not Assigned(FFileSections) then
    FFileSections := TFileSections.Create;
  Result := FFileSections;
end;

procedure TSystemSettings.LoadFromFile(const NameSection: string);
var Path: string;
begin
  if not Assigned(FIniFile) then
  begin
    Path := ExtractFilePath(FileName);
    if (not DirectoryExists(Path)) and (Trim(Path) <> '') then CreatePath(Path);

    if not FileExists(FileName) then
      FileClose(FileCreate(FileName));

    FIniFile := TIniFile.Create(FileName);
  end;



  FIniFile.ReadSectionValues(NameSection, Sections.Add(NameSection).SectionValues);
end;

procedure TSystemSettings.SaveAllToFile;
var i: integer;
begin
  for i := 0 to Sections.Count - 1 do
    SaveToFile(Sections.Items[i].SectionName, true);
end;

procedure TSystemSettings.SaveToFile(const NameSection: string; const ImmediatelyUpdate: boolean);
var i: integer;
begin
  FIniFile.EraseSection(NameSection);
  
  for i := 0 to SectionByName[NameSection].SectionValues.Count - 1 do
    FIniFile.WriteString(NameSection, SectionByName[NameSection].SectionValues.Names[i], SectionByName[NameSection].SectionValues.Values[SectionByName[NameSection].SectionValues.Names[i]]);

  if ImmediatelyUpdate then
    FIniFile.UpdateFile;
end;

{ TFileSection }

destructor TFileSection.Destroy;
begin
  FreeAndNil(FSectionValues);
  inherited;
end;

function TFileSection.GetSectionValues: TStringList;
begin
  if not Assigned(FSectionValues) then
    FSectionValues := TStringList.Create;

  Result := FSectionValues;
end;

{ TFileSections }

function TFileSections.Add(ASectionName: string): TFileSection;
begin
  Result := GetSectionByName(ASectionName);
  if not Assigned(result) then
  begin
    Result := TFileSection.Create;
    Result.SectionName := ASectionName;
    inherited Add(Result);
  end;
end;

constructor TFileSections.Create;
begin
  inherited Create(true);
end;

function TFileSections.GetItems(Index: integer): TFileSection;
begin
  result := inherited Items[Index] as TFileSection;
end;

function TFileSections.GetSectionByName(
  ASectionName: string): TFileSection;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if Items[i].SectionName = ASectionName then
  begin
    Result := Items[i];
    break;
  end;
end;

end.
