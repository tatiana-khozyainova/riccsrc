unit Encoder;

interface

uses SysUtils, Classes, Contnrs;


type
  TReplacement = class
  private
    FForWhat: string;
    FWhat: string;
    FField: string;
  public
    property Field: string read FField write FField;
    property What: string read FWhat write FWhat;
    property ForWhat: string read FForWhat write FForWhat;
  end;


  TEncoding = (encAnsi, encAscii);
  

  TEncoder = class
  private
    FFolder: string;
    FOnEncodingStarted: TNotifyEvent;
    FOnEncodingInProgress: TNotifyEvent;
    FOnEncodingFinished: TNotifyEvent;
    FFileList: TStringList;
    FOutFolder: string;
    FCurrentFile: string;

    procedure ReadFileList;
    function  GetFileCount: integer;
  public
    procedure EncodeFile(AFileName: string; AOutFileName: string); // в DOS
    procedure DecodeFile(AFileName: string; AOutFileName: string); // в Win


    property OnEncodingStarted: TNotifyEvent read FOnEncodingStarted write FOnEncodingStarted;
    property OnEncodingFinished: TNotifyEvent read FOnEncodingFinished write FOnEncodingFinished;
    property OnEncodingInProgress: TNotifyEvent read FOnEncodingInProgress write FOnEncodingInProgress;

    property Folder: string read FFolder;
    property OutFolder: string read FOutFolder;
    property CurrentFile: string read FCurrentFile;

    property  FileCount: integer read GetFileCount;
    procedure Execute;

    class function IsOemStr(S: string): boolean;
    class function GetInstance: TEncoder;
    constructor Create(AFolder, AOutFolder: string);
    destructor Destroy; override;
  end;



implementation

uses rxStrUtils, Math, FileUtils, Windows, JclWideStrings;

{ TEncoder }

constructor TEncoder.Create(AFolder, AOutFolder: string);
begin
  inherited Create;
  FFolder := AFolder;
  FOutFolder := AOutFolder;
end;

procedure TEncoder.DecodeFile(AFileName, AOutFileName: string);
var lstIn: TStringList;
    i: integer;
    sDir: string;
    T: TextFile;
begin
  lstIn := TStringList.Create;

  lstIn.LoadFromFile(AFileName);

  sDir := ExtractFilePath(AOutFileName);
  if not DirectoryExists(sDir) then CreateDir(sDir);
  AssignFile(T, AOutFileName); // начинаем работать с файлом
  ReWrite(T); // создаём новый пустой файл

  for i := 0 to lstIn.Count - 1 do
  begin
    Writeln(T, OemToAnsiStr(lstIn[i])); // вторую строку в досовской
  end;

  CloseFile(T); // закрываем файл

  FreeAndNil(lstIn);
end;

destructor TEncoder.Destroy;
begin
  FreeAndNil(FFileList);
  inherited;
end;

procedure TEncoder.EncodeFile(AFileName, AOutFileName: string);
var lstIn, lstOut: TStringList;
    i: integer;
    sDir: string;
begin
  lstIn := TStringList.Create;
  lstOut := TStringList.Create;

  lstIn.LoadFromFile(AFileName);

  for i := 0 to lstIn.Count - 1 do
    lstOut.Add(StrToOem(lstIn[i]));

  sDir := ExtractFilePath(AOutFileName);
  if not DirectoryExists(sDir) then CreateDir(sDir);

  lstOut.SaveToFile(AOutFileName);

  FreeAndNil(lstIn);
  FreeAndNil(lstOut);
end;

procedure TEncoder.Execute;
var i: integer;
begin
  // читаем список файлов
  ReadFileList;
  if Assigned(FOnEncodingStarted) then FOnEncodingStarted(Self);

  // перекодируем каждый файл
  for i := 0 to FFileList.Count - 1 do
  begin
    FCurrentFile := StringReplace(FFileList[i], FFolder, FOutFolder, [rfIgnoreCase]);
    if Assigned(FOnEncodingInProgress) then FOnEncodingInProgress(Self);
    EncodeFile(FFileList[i], FCurrentFile);
  end;

  if Assigned(FOnEncodingFinished) then FOnEncodingFinished(Self);
end;

function TEncoder.GetFileCount: integer;
begin
  Assert(Assigned(FFileList), 'Список файлов не сформирован');
  Result := FFileList.Count;
end;

class function TEncoder.GetInstance: TEncoder;
const enc: TEncoder = nil;
begin
  if not Assigned(enc) then
    enc := TEncoder.Create('', '');

  Result := enc;

end;

class function TEncoder.IsOemStr(S: string): boolean;
var i: integer;
begin
  Result := False;
  for i := 1 to Length(S) do
    Result := Result or ((Ord(S[i])  >= 128) and (Ord(S[i]) <= 175));

end;

procedure TEncoder.ReadFileList;

procedure ReadDirectoryList(ABaseFolder: string; ADirectoryList: TStrings);
var f, i: Integer;
    Found: TSearchRec;
begin
  f:=FindFirst(ABaseFolder + '\*.*', faDirectory, Found);
  while f=0 do
  begin
    if ADirectoryList.IndexOf(ABaseFolder + '\' + Found.Name) = -1 then
    begin
      if (Found.Name <> '.') and (Found.Name <> '..') and ((Found.Attr and faDirectory) <> 0) then
      begin
        i := ADirectoryList.Add(ABaseFolder + '\' + Found.Name);
        ReadDirectoryList(ADirectoryList[i], ADirectoryList);
      end;
    end;
    f := SysUtils.FindNext(Found);
  end;

  SysUtils.FindClose(Found);
end;

var f: integer;
    Found: TSearchRec;
    lstDir: TStringList;
    i: Integer;
begin
  FFileList := TStringList.Create;
  
  lstDir := TStringList.Create;
  ReadDirectoryList(Folder, lstDir);
  lstDir.Insert(0, Folder);

  for i := 0 to lstDir.Count - 1 do
  begin
    f := SysUtils.FindFirst(lstDir[i] + '\*.las', faAnyFile, Found);

    while (f = 0) do
    begin
      FFileList.Add(lstDir[i] + '\' + Found.Name);
      f := SysUtils.FindNext(Found);
    end;


    SysUtils.FindClose(Found);
  end;
end;

{ TReplacementList }


end.
