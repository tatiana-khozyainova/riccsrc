unit LasFile;

interface

uses Registrator, Organization, Employee, Classes, BaseObjects, Contnrs,
Variants, RegExpr, windows, Encoder;

type
  TLasFile = class;
  TLasFiles = class;
  TLasCurve = class;
  TLasCurves = class;
  TCurve = class;
  TCurves = class;
  TLasFileContent = class;
  TCurveCategory = class;
  TStringInBlock = class;
  TDelimiterStringList = class;
  {TStringsInBlock = class;
  TStringBlock = class;
  TStringBlocks = class;}

  TStates = (Detected, NotDetected, Warning);

  TDelimiterStringList = class(TStringList)
  protected
    constructor Create; virtual; 
  public
    class function GetIstance: TDelimiterStringList; 
  end;

  TStringInBlock = class
  private
    FBlockName : String;
    FName : String;
    FValue : String;
    FComment : String;
    FFullString : String;
    FIsCommentString : Boolean;
    FState : TStates;
    function  GetName : String;
    function  GetValue : String;
    function  GetComment : String;
  public
    property BlockName : String read FBlockName write FBlockName;
    property Name: string read GetName write FName;
    property Value: string read GetValue write FValue;
    property Comment: string read GetComment write FComment;
    property FullString: string read FFullString write FFullString;
    property IsCommentString: Boolean read FIsCommentString write FIsCommentString;
    property State: TStates read FState write FState;
    procedure VerifyValue;
    function ConvertToFloat : Double;
    function GetCurve : String;
  end;

    TStringsInBlock = class(TObjectList)
  private
    FMaxName  : integer;
    FMaxValue : integer;
    function GetItems(const Index: integer): TStringInBlock;

  public
    function GetStringByName(AName : string) : TStringInBlock;
    property Items[const Index: integer]: TStringInBlock read GetItems;
    function Add(AFullString: string; ABlockName: String; AIsCommentString: Boolean): TStringInBlock;
    function AddToPos(AFullString: string; ABlockName: String; AIsCommentString: Boolean): TStringInBlock;
    procedure MakeFullStrings;
    constructor Create;   virtual;
  end;



  TReplacement = class
  private
    FForWhat: string;
    FWhat: string;
    FField: string;
    FPart: string;
  public
    property BlockName: string read FPart write FPart;
    property Field: string read FField write FField;
    property What: string read FWhat write FWhat;
    property ForWhat: string read FForWhat write FForWhat;
  end;

  TReplacementList = class(TObjectList)
  private
    function GetItems(const Index: integer): TReplacement;
  public
    property Items[const Index: integer]: TReplacement read GetItems;
    function AddReplacement(APart, AField, AWhat, AForWhat: string): TReplacement;
    procedure CopyFrom(AReplacementList: TReplacementList);
    constructor Create;   virtual;
  end;


  TStringTableRow = class(TStringList)
  private
    FDelimitersRow: TStringTableRow;
    function  GetCols(const Index: integer): String;
    function  GetColCount: integer;
    procedure SetCols(const Index: integer; const Value: String);
    function  GetDelimitersRow: TStringTableRow;
  public
    property DelimitersRow: TStringTableRow read GetDelimitersRow;
    property ColCount: integer read GetColCount;
    property Cols[const Index: integer]: String read GetCols write SetCols;
    function  MakeDelimitedRow(ADelimiter: string): string; overload;
    function  MakeDelimitedRow: string; overload;
    destructor Destroy; override;
  end;

  TStringTable = class(TObjectList)
  private
    function GetRows(const Index: Integer): TStringTableRow;
    function GetRowCount: integer;
    function GetRowByName(const RowName: string): TStringTableRow;
  public
    property  Rows[const Index: Integer]: TStringTableRow read GetRows;
    property  RowByName[const RowName: string]: TStringTableRow read GetRowByName;
    property  RowCount: integer read GetRowCount;

    function  AddRow: TStringTableRow;
    procedure DeleteRow(ARow: Integer);
    procedure DeleteColumn(ACol: integer; ACurveName: string = '');
    procedure ReadTable(AStringList: TStringList; AColumnDelimiters: TStringList); overload;

    procedure WriteTable(AStringList: TStringList); overload;
    function  GetRowIndex(S: string; AColumn: Integer): integer;
    constructor Create;
  end;

  TLasFileBlock = class(TStringList)
  private
    FName: string;
    FRealContent: TLasFileBlock;
    FTableContent: TStringTable;
    FDefaultTableDelimiter: string;
    FIsRealContent: boolean;
    function GetRealContent: TLasFileBlock;
    function GetTableContent: TStringTable;
  public
    property  RealContent: TLasFileBlock read GetRealContent;
    property  IsRealContent: boolean read FIsRealContent;
    property  TableContent: TStringTable read GetTableContent;
    property  DefaultTableDelimiter: string read FDefaultTableDelimiter write FDefaultTableDelimiter;
    procedure SaveTableContent;
    procedure DeleteString(S: string; AStart: integer = 0);

    function  GetAbsoluteStringIndex(S: string; AStart: integer = 0; SearchForward: boolean = false): integer;
    function  GetStringIndex(S: string; AStart: integer = 0; SearchForward: boolean = false): integer;
    procedure MakeReplacement(AReplacement: TReplacement);

    procedure Delete(Index: Integer); override;
    function  GetFieldValue(AFieldname: string): string;

    property  Name: string read FName write FName;
    constructor Create;
  end;

  TLasFileBlocks = class(TObjectList)
  private
    FLasFileContent: TLasFileContent;
    function GetItems(const Index: integer): TLasFileBlock;
    function GetItemByName(const Name: string): TLasFileBlock;
  public
    function Add(AName: string): TLasFileBlock;
    property LasFileContent: TLasFileContent read FLasFileContent;
    property Items[const Index: integer]: TLasFileBlock read GetItems;
    property ItemByName[const Name: string]: TLasFileBlock read GetItemByName;
    constructor Create(ALasFileContent: TLasFileContent);
  end;


  TLasFileContent = class(TObject)
  private
    FEncoding: TEncoding;
    FLasFile: TLasFile;
    FLasFileName: string;
    FBlocks: TLasFileBlocks;
    FContent: TLasFileBlock;
    FmaxName:  Integer;
    FmaxValue: Integer;
    FStringsInBlock : TStringsInBlock;
    function GetBlocks: TLasFileBlocks;
    function GetWellBlock: TLasFileBlock;
    function GetStringsInBlock : TStringsInBlock;
    function GetFromDepth: single;
    function GetToDepth: Single;
    function GetCurveList: string;
    function GetAreaName: string;
    function GetWellNum: string;
    function GetEncoding: TEncoding;
  public
    property Content: TLasFileBlock read FContent;
    property maxName: Integer  read FmaxName write FmaxName;
    property maxValue: Integer  read FmaxValue write FmaxValue;
    property Encoding: TEncoding read GetEncoding write FEncoding;

    property  LasFile: TLasFile read FLasFile write FLasFile;
    property  LasFileName: string read FLasFileName write FLasFileName;
    property  Blocks: TLasFileBlocks read GetBlocks;
    property  StringsInBock : TStringsInBlock read GetStringsInBlock;
    procedure MakeStrings;
    function  IsTrue : Boolean;


    procedure CropCurve(ACurveName: string);
    procedure CropAllExceptListedCurves(ACurveList: TStringList);
    procedure CropAllExceptListedBlocks(ABlockList: TStringList);

    procedure CropByDepths(AStartDepth: Single; AFinishDepth: Single);

    procedure MakeReplacements(AReplacements: TReplacementList);
    procedure MakeReplacement(AReplacement: TReplacement);

    property  WellBlock: TLasFileBlock read GetWellBlock;
    property  FromDepth: single read GetFromDepth;
    property  ToDepth: Single read GetToDepth;
    property  CurveList: string read GetCurveList;
    property  WellNum: string read GetWellNum;
    property  AreaName: string read GetAreaName;  

    procedure ReadFile;
    procedure SaveFile(const AFileName: string = '');
    procedure SaveFile2(const AFileName: string = '');


    function StrAnsiToOem (const S : AnsiString ):AnsiString;
    function StrOemToAnsi (const S : AnsiString ):AnsiString;

    constructor Create(AFileName: string); overload;
    constructor Create(ALasFile: TLasFile); overload;

    destructor Destroy; override;

  end;

  TLasFileContents = class(TObjectList)
  private
    function GetItems(const Index: integer): TLasFileContent;
  public
    function GetContentByFile(ALasFile: TObject): TLasFileContent; 
    property Items[const Index: Integer]: TLasFileContent read GetItems;
    constructor Create;
  end;



  TLasFile = class(TRegisteredIDObject)
  private
    FStop: double;
    FStart: double;
    FFileDate: string;
    FDate: TDateTime;
    FCDNumber: SmallInt;
    FOldFileName: string;
    FEmployee: TEmployee;
    FOrganization: TOrganization;
    FDebased: smallint;
    FHeader: smallInt;
    FStep: double;
    FWellID: Integer;
    FLasCurves: TLasCurves;
    FIsChanged: Boolean;
    FIsAssigned :Boolean;  ///показывает привязалась ли скважина
    function GetCurves: TLasCurves;
    function  GetFileName: string;
    procedure SetFileName(const Value: string);

  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property Start: double read FStart write FStart;
    property Stop: double read FStop write FStop;
    property Step: double read FStep write FStep;
    property FileDate: string read FFileDate write FFileDate;
    property Date: TDateTime read FDate write FDate;
    property WellID: integer read FWellID write FWellID;

    property IsChanged: Boolean read FIsChanged write FIsChanged;
    property IsAssigned: Boolean read FIsAssigned write FIsAssigned;


    property FileName: string read GetFileName write SetFileName;
    property OldFileName: string read FOldFileName write FOldFileName;
    property CDNumber: SmallInt read FCDNumber write FCDNumber;
    property Organization: TOrganization read FOrganization write FOrganization;
    property Employee: TEmployee read FEmployee write FEmployee;
    property Debased: smallint read FDebased write FDebased;
    property Header: smallint read FHeader write FHeader;

    property   LasCurves: TLasCurves read GetCurves;

    function   Update(ACollection: TIDObjects = nil): integer; override;

    function    List(AListOption: TListOption = loBrief): string; override;

    constructor Create(ACollection: TIDObjects); override;
    destructor  Destroy; override;
  end;


  TLasFiles = class(TRegisteredIDObjects)
  private
    function GetItems(const Index: Integer): TLasFile;
  public
    property Items[const Index: Integer]: TLasFile read GetItems;
    constructor Create; override;
  end;

  TLasCurve = class(TRegisteredIDObject)
  private
    FCurve: TCurve;
    function GetLasFile: TLasFile;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property LasFile: TLasFile read GetLasFile;
    property Curve: TCurve read FCurve write FCurve;
    constructor Create(ACollection: TIDObjects); override;
    destructor  Destroy; override;
  end;

  TLasCurves = class(TRegisteredIDObjects)
  private
    function GetItems(const Index: Integer): TLasCurve;
  public
    property Items[const Index: Integer]: TLasCurve read GetItems;
    constructor Create; override;
  end;

  TCurve = class(TRegisteredIDObject)
  private
    FUnit: string;
    FCurveCategory : TCurveCategory;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    function List(AListOption: TListOption = loBrief): string; override;
    property CurveUnit: string read FUnit write FUnit;
    property CurveCategory :TCurveCategory read FCurveCategory write FCurveCategory;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TCurves = class(TRegisteredIDObjects)
  private
    function GetItems(const Index: Integer): TCurve;
  public
    property Items[const Index: Integer]: TCurve read GetItems;
    constructor Create; override;
  end;

  TCurveCategory = class(TRegisteredIDObject)
  private
  protected
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TCurveCategories = class(TRegisteredIDObjects)
  private
    function GetItems(const Index: Integer): TCurveCategory;
  public
    property Items[const Index: Integer]: TCurveCategory read GetItems;
    constructor Create; override;
  end;




implementation

uses Facade, LasFileDataPoster, SysUtils, Math, StringUtils, ClientCommon, rxStrUtils;

{ TLasFiles }

constructor TLasFiles.Create;
begin
  inherited;
  FObjectClass := TLasFile;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TLasFileDataPoster];
end;

function TLasFiles.GetItems(const Index: Integer): TLasFile;
begin
  Result := inherited Items[index] as TLasFile;
end;

{ TLasFile }

procedure TLasFile.AssignTo(Dest: TPersistent);
var lf: TLasFile;
begin
  inherited;
  lf := Dest as TLasFile;

  lf.Start := Start;
  lf.Stop := Stop;
  lf.Step := Step;

  lf.Date := Date;
  lf.FileDate := FileDate;

  lf.FileName := FileName;
  lf.OldFileName := OldFileName;
  lf.CDNumber := CDNumber;
  lf.Organization := Organization;
  lf.Employee := Employee;
  lf.IsChanged := IsChanged;
  lf.IsAssigned := IsAssigned;
  
end;

constructor TLasFile.Create(ACollection: TIDObjects);
begin
  inherited;
  FClassIDString := 'LAS-файл';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TLasFileDataPoster];
end;

destructor TLasFile.Destroy;
begin
  FreeAndNil(FLasCurves);
  inherited;
end;

function TLasFile.GetCurves: TLasCurves;
begin
  if not Assigned(FLasCurves) then
  begin
    FLasCurves := TLasCurves.Create;
    FLasCurves.Owner := Self;
    FLasCurves.Reload('LAS_FILE_UIN = ' + IntToStr(Id));
  end;
  Result := FLasCurves;
end;



function TLasFile.GetFileName: string;
begin
  Result := Name;
end;


function TLasFile.List(AListOption: TListOption): string;
begin
  Result :=  Format( '%s (%.2f - %.2f)', [OldFileName, Start, Stop]); 
end;

procedure TLasFile.SetFileName(const Value: string);
begin
  Name := Value;
end;

function TLasFile.Update(ACollection: TIDObjects): integer;
begin
  Result := inherited Update(ACollection);
  LasCurves.Update(nil);
end;

{ TLasCurve }

procedure TLasCurve.AssignTo(Dest: TPersistent);
begin
  inherited;
  (Dest as TLasCurve).Curve := Curve;
end;

constructor TLasCurve.Create(ACollection: TIDObjects);
begin
  inherited;
  FClassIDString := 'Кривая в Las-файле';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TLasCurveDataPoster];
end;

destructor TLasCurve.Destroy;
begin

  inherited;
end;

function TLasCurve.GetLasFile: TLasFile;
begin
  Result := Owner as TLasFile;
end;

{ TLasCurves }

constructor TLasCurves.Create;
begin
  inherited;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TLasCurveDataPoster];
  FObjectClass := TLasCurve;
end;

function TLasCurves.GetItems(const Index: Integer): TLasCurve;
begin
  Result := inherited Items[index] as TLasCurve;
end;

{ TCurve }

procedure TCurve.AssignTo(Dest: TPersistent);
begin
  inherited;
  (Dest as TCurve).CurveUnit := CurveUnit;
end;

constructor TCurve.Create(ACollection: TIDObjects);
begin
  inherited;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TCurveDataPoster];
  FClassIDString := 'Кривая';


end;

function TCurve.List(AListOption: TListOption): string;
begin
  Result := Trim(ShortName + ' ' + Name);
end;

{ TCurves }

constructor TCurves.Create;
begin
  inherited;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TCurveDataPoster];
  FObjectClass := TCurve;
end;

function TCurves.GetItems(const Index: Integer): TCurve;
begin
  Result := inherited Items[Index] as TCurve;
end;

{ TLasFileContent }

constructor TLasFileContent.Create(AFileName: string);
begin
  inherited Create();
  FLasFileName := AFileName;
  FContent := TLasFileBlock.Create;
  FContent.Name := 'LasFile';
end;

constructor TLasFileContent.Create(ALasFile: TLasFile);
begin
  Create(ALasFile.OldFileName);
  FLasFile := ALasFile;
end;

procedure TLasFileContent.CropCurve(ACurveName: string);
var iAbsCurveIndex, iCurveIndex: Integer;
    CurveBlock, DataBlock: TLasFileBlock;
begin
  CurveBlock := Blocks.ItemByName['~Curve'];
  DataBlock := Blocks.ItemByName['~A'];

  if Assigned(CurveBlock) then
  begin
    if CurveBlock.TableContent.RowCount > 0 then
    begin
      iAbsCurveIndex := CurveBlock.TableContent.GetRowIndex(ACurveName, 0);
      iCurveIndex := CurveBlock.RealContent.TableContent.GetRowIndex(ACurveName, 0);
    end
    else
    begin
      iAbsCurveIndex := CurveBlock.GetAbsoluteStringIndex(ACurveName, 0);
      iCurveIndex := CurveBlock.GetStringIndex(ACurveName, 0);
    end;

    if iCurveIndex > -1 then
    begin
      CurveBlock.Delete(iAbsCurveIndex);
      DataBlock.TableContent.DeleteColumn(iCurveIndex, ACurveName);
      DataBlock.SaveTableContent;
    end;
  end;
end;

destructor TLasFileContent.Destroy;
begin
  FContent.Free;
  inherited;
end;

function TLasFileContent.GetBlocks: TLasFileBlocks;
begin
  if not Assigned(FBlocks) then
    FBlocks := TLasFileBlocks.Create(Self);

  Result := FBlocks;
end;

procedure TLasFileContent.ReadFile;
begin
  FContent.LoadFromFile(LasFileName);

  Blocks.Add('~Version');
  Blocks.Add('~Well');
  Blocks.Add('~Curve');
  Blocks.Add('~Param');
  Blocks.Add('~Other');
  Blocks.Add('~A').DefaultTableDelimiter := ' ';
end;

procedure TLasFileContent.SaveFile(const AFileName: string);
var lst: TStringList;
    i, j: integer;
begin
  lst := TStringList.Create;
  for i := 0 to Blocks.Count - 1 do
  for j := 0 to Blocks.Items[i].Count - 1 do
    lst.Add(Blocks.Items[i].Strings[j]);

  if trim(AFileName) <> '' then
  begin
    DeleteFile(PChar(AFileName));
    lst.SaveToFile(AFileName)
  end
  else
  begin
    DeleteFile(PChar(LasFileName));
    lst.SaveToFile(LasFileName);
  end;

  lst.Free;
end;

procedure TLasFileContent.CropAllExceptListedCurves(ACurveList: TStringList);
var i: integer;
    CurveBlock: TLasFileBlock;
    sCurve: string;

begin
  if ACurveList = nil then Exit;

  CurveBlock := Blocks.ItemByName['~Curve'];
  if Assigned(CurveBlock) then
  begin
    CurveBlock.TableContent.ReadTable(CurveBlock, TDelimiterStringList.GetIstance);
    CurveBlock.RealContent.TableContent.ReadTable(CurveBlock.RealContent, TDelimiterStringList.GetIstance);

    for i := CurveBlock.TableContent.RowCount - 1 downto 0 do
    begin
      sCurve := CurveBlock.TableContent.Rows[i].Cols[0];
      if (ACurveList.IndexOf(sCurve) = -1) and
         (pos('#', sCurve) <= 0) and
         (pos('~', sCurve) <= 0) then
        CropCurve(sCurve);
    end;
  end;
end;

procedure TLasFileContent.CropAllExceptListedBlocks(
  ABlockList: TStringList);
var i: integer;
    b: TLasFileBlock;
    lst: TObjectList;
begin
  lst := TObjectList.Create(false);

  for i := ABlockList.Count - 1 downto 0 do
  begin
    b := Blocks.ItemByName[ABlockList[i]];
    if Assigned(b) then lst.Add(b);
  end;

  for i := Blocks.Count - 1 downto 0 do
  if lst.IndexOf(Blocks.Items[i]) = -1 then
    Blocks.Delete(i);

  lst.Free;
end;

procedure TLasFileContent.MakeReplacements(
  AReplacements: TReplacementList);
var i: integer;
begin
  for i := 0 to AReplacements.Count - 1 do
  begin
    MakeReplacement(AReplacements.Items[i]);
  end;
end;

procedure TLasFileContent.MakeReplacement(AReplacement: TReplacement);
var b: TLasFileBlock;
begin
  b := Blocks.GetItemByName(AReplacement.BlockName);
  if Assigned(b) then
    b.MakeReplacement(AReplacement);
end;

function TLasFileContent.GetWellBlock: TLasFileBlock;
begin
  Result := Blocks.ItemByName['~Well'];
  Assert(Assigned(Result), 'Не найден заголовочный блок с описанием скважины');
end;



function TLasFileContent.GetStringsInBlock: TStringsInBlock;
const
  Numbers = '0123456789-';
var
    i,k:Integer;
    NewString,BlockName:String;
    SIB:TStringInBlock;
begin
  if not Assigned(FStringsInBlock) then
  begin
    BlockName:='';
    FStringsInBlock := TStringsInBlock.Create;
    for i:=0 to FContent.Count-1 do
      begin
        if (FEncoding = encAnsi) then NewString:=StrAnsiToOem(trim(FContent.Strings[i]))
        else NewString:=StrOemToAnsi(trim(FContent.Strings[i]));

        if (Pos('~Version',NewString)>0) then
          begin
            BlockName:='~Version Information';
            FStringsInBlock.Add(NewString, BlockName, true);
            Continue;
          end;
        if (Pos('~Well',NewString)>0) then
          begin
            BlockName:='~Well Information';
            FStringsInBlock.Add(NewString, BlockName, true);
            Continue;
          end;
        if (Pos('~Curve',NewString)>0) then
          begin
            BlockName:='~Curve Information';
            FStringsInBlock.Add(NewString, BlockName, true);
            Continue;
          end;
        if (Pos('~ASCII',NewString)>0) then
          begin
            BlockName:='~ASCII Log Data';
            FStringsInBlock.Add(NewString, BlockName, true);
            Continue;
          end;
        if ((StrScan(Numbers, NewString[1])<>nil) and (StrScan(Numbers, NewString[2])<>nil)) then
          begin
            BlockName:='~ASCII Log Data';
            FStringsInBlock.Add(NewString, BlockName, true);
            Continue;
          end;
        if (Pos('~',NewString)>0) then
          begin
            FStringsInBlock.Add(NewString, BlockName, true);
            Continue;
          end;
        if (Pos('#',NewString)>0) then
          FStringsInBlock.Add(NewString, BlockName, true)
        else
          begin
            SIB:=FStringsInBlock.Add(NewString, BlockName, false);
            if (length(SIB.Name)>FStringsInBlock.FMaxName) then FStringsInBlock.FMaxName:=length(SIB.Name);
            if (length(SIB.Value)>FStringsInBlock.FmaxValue) then FStringsInBlock.FmaxValue:=length(SIB.Value);
            //if (BlockName='~Well Information') then FStringsInBlock.Items[k].VerifyValue;
          end;
      end;
    Result := FStringsInBlock;
  end
  else Result := FStringsInBlock;
end;

procedure TLasFileContent.MakeStrings;
var
  i,k:integer;
  temp:string;
begin
  maxName:=0;
  maxValue:=0;
  for i:=0 to StringsInBock.Count-1 do
    begin
      if (maxName<Length(trim(StringsInBock.Items[i].Name))) then
        maxName:=Length(trim(StringsInBock.Items[i].Name));
      if (maxValue<Length(trim(StringsInBock.Items[i].Value))) then
        maxValue:=Length(trim(StringsInBock.Items[i].Value));
    end;

  for i:=0 to StringsInBock.Count-1 do
    begin
      if ((StringsInBock.Items[i].BlockName<>'~ASCII Log Data') and (StringsInBock.Items[i].IsCommentString=false)) then
        begin
          temp:=StringsInBock.Items[i].Name;

          {if ((maxName-Length(StringsInBock.Items[i].Name))>0) then
            for k:=0 to (maxName-Length(StringsInBock.Items[i].Name)) do
              temp:=temp+' ';   }

          //temp:=temp+' ';

          {if ((maxValue-Length(StringsInBock.Items[i].Value))>0) then
            for k:=0 to (maxValue-Length(StringsInBock.Items[i].Value)) do
              temp:=temp+' ';
            }
            for k:=0 to 1 do
              temp:=temp+' ';

          temp:=temp+StringsInBock.Items[i].Value;
          temp:=temp+'  : '+StringsInBock.Items[i].Comment;
          StringsInBock.Items[i].FullString:=temp;
        end;
    end;
end;

procedure TLasFileContent.SaveFile2(const AFileName: string);
var lst: TStringList;
    i, j: integer;
    temp:string;
begin
  lst := TStringList.Create;
  for i:=0 to StringsInBock.Count-1 do
    begin
      temp:=StrAnsiToOem(StringsInBock.Items[i].FullString);
      lst.Add(StringsInBock.Items[i].FullString);
    end;

  if trim(AFileName) <> '' then
  begin
    DeleteFile(PChar(AFileName));
    lst.SaveToFile(AFileName)
  end
  else
  begin
    DeleteFile(PChar(LasFileName));
    lst.SaveToFile(LasFileName);
  end;

  lst.Free;
end;

function TLasFileContent.IsTrue: Boolean;
var
  i:Integer;
begin
  Result:=True;
  for i:=0 to StringsInBock.Count-1 do
    if StringsInBock.Items[i].State=NotDetected then
      begin
        Result:=False;
        Break;
      end;
end;

function TLasFileContent.StrAnsiToOem(const S : AnsiString): AnsiString;
begin
  Result:='';
  SetLength(Result, Length(S));
  AnsiToOemBuff(@S[1], @Result[1], Length(S));
end;

function TLasFileContent.StrOemToAnsi(const S: AnsiString): AnsiString;
begin
  Result:='';
  SetLength(Result, Length(S));
  OemToAnsiBuff(@S[1], @Result[1], Length(S));
end;

procedure TLasFileContent.CropByDepths(AStartDepth, AFinishDepth: Single);
var wb, db: TLasFileBlock;
    r: TStringTableRow;
    iLen, i, iPos, iStart, iStop, iStep, iPrecision: integer;
    S: string;
    fRealStart, fRealStop, fTemp: single;
begin
  ReadFile();
  // задаем значения так, как будто шаг всегда положительный
  if AStartDepth >= AFinishDepth then Exit;

  wb := WellBlock;
  db := Blocks.ItemByName['~A'];

  if Assigned(wb) and Assigned(db) then
  begin
    // проверяем надо ли резать и определяем знак шага
    r := wb.TableContent.RowByName['STRT'];
    if Assigned(r) and (r.ColCount > 2) then
      fRealStart := ExtractFloat(r.Cols[2])
    else Exit; // должно быть обработано как исключение


    r := wb.TableContent.RowByName['STOP'];
    if Assigned(r) and (r.ColCount > 2) then
      fRealStop := ExtractFloat(r.Cols[2])
    else Exit; // должно быть обработано как исключение

    // узнаем знак шага
    if fRealStart < fRealStop then iStep := 1
    else
    begin
      iStep := -1;
      fTemp := fRealStart;
      fRealStart := fRealStop;
      fRealStop := fTemp;
    end;

    // если резать надо
    if (fRealStart <= AStartDepth) or (fRealStop >= AFinishDepth) then
    begin
      iStart := -1; iStop := db.Count + 1;
      // заменяем старт и стоп
      if (fRealStart <= AStartDepth) then
      begin
        if iStep = 1 then r := wb.TableContent.RowByName['STRT'] else r := wb.TableContent.RowByName['STOP'];
        
        if Assigned(r) and (r.ColCount > 2) then
        begin
          iLen := Length(r.Cols[2]);
          iPrecision := iLen - Pos('.', r.Cols[2]);
          S := Format('%.'+ IntToStr(iPrecision) + 'f', [AStartDepth]);
          if iLen > Length(S) then S := PadSymbolL(S, ' ', iLen - Length(S))
          else if iLen < Length(S) then r.DelimitersRow.Objects[2] := TObject(Integer(r.DelimitersRow.Objects[2])-Abs(iLen - Length(s)));
          r.Cols[2] := S;
        end;

        // ищем строки в контенте данных ASCII
        if iStep = 1 then
        begin
          for i := 1 to db.Count - 1 do
          begin
            iPos := Pos(' ',trim(db.Strings[i]));
            if iPos > 0 then
            begin
              S := Copy(trim(db.Strings[i]), 1, iPos - 1);
              fRealStart := StrToFloatEx(S);
            end;

            if fRealStart <= AStartDepth then iStart := i else break;
          end;
        end
        else
        begin
          for i := db.Count - 1 downto 1 do
          begin
            iPos := Pos(' ',trim(db.Strings[i]));
            if iPos > 0 then
            begin
              S := Copy(trim(db.Strings[i]), 1, iPos - 1);
              fRealStart := StrToFloatEx(S);
            end;

            if fRealStart <= AStartDepth then iStop := i else break;
          end;
        end;
      end;

      if (fRealStop >= AFinishDepth) then
      begin
        if iStep = 1 then r := wb.TableContent.RowByName['STOP'] else r := wb.TableContent.RowByName['STRT'];
        if Assigned(r) and (r.ColCount > 2) then
        begin
          iLen := Length(r.Cols[2]);
          iPrecision := iLen - Pos('.', r.Cols[2]);
          S := Format('%.' + IntToStr(iPrecision) + 'f', [AFinishDepth]);
          if iLen > Length(S) then S := PadSymbolL(S, ' ', iLen - Length(S))
          else if iLen < Length(S) then r.DelimitersRow.Objects[2] := TObject(Integer(r.DelimitersRow.Objects[2])-Abs(iLen - Length(s)));
          r.Cols[2] := S;
        end;

        // ищем строки в контенте данных  ASCII
        if iStep = 1 then
        begin
          for i := db.Count - 1 downto 1 do
          begin
            iPos := Pos(' ',trim(db.Strings[i]));
            if iPos > 0 then
            begin
              S := Copy(trim(db.Strings[i]), 1, iPos - 1);
              fRealStop := StrToFloatEx(S);
            end;

            if fRealStop >= AFinishDepth  then iStop := i else break;
          end;
        end
        else
        begin
          for i := 1 to db.Count - 1 do
          begin
            iPos := Pos(' ',trim(db.Strings[i]));
            if iPos > 0 then
            begin
              S := Copy(trim(db.Strings[i]), 1, iPos - 1);
              fRealStop := StrToFloatEx(S);
            end;

            if fRealStop  >= AFinishDepth then iStart := i else break;
          end;
        end;
      end;

      wb.SaveTableContent;



      // очищаем контент от лишних строк

      for i := db.Count - 1 downto iStop + 1 do
        db.Delete(i);


      for i := 0 to iStart - 1 do
        db.Delete(0);
        
      SaveFile();
    end;
  end;
end;

function TLasFileContent.GetFromDepth: single;
var wb: TLasFileBlock;
    r: TStringTableRow;
begin
   Result := 0;
   wb := WellBlock;
   if Assigned(wb) then
   begin
     r := wb.TableContent.RowByName['STRT'];
     if Assigned(r) and (r.ColCount > 2) then
       Result := ExtractFloat(r.Cols[2]);
   end;
end;

function TLasFileContent.GetToDepth: Single;
var wb: TLasFileBlock;
    r: TStringTableRow;
begin
   Result := 0;
   wb := WellBlock;
   if Assigned(wb) then
   begin
     r := wb.TableContent.RowByName['STOP'];
     if Assigned(r) and (r.ColCount > 2) then
       Result := ExtractFloat(r.Cols[2]);
   end;
end;

function TLasFileContent.GetCurveList: string;
var cb: TLasFileBlock;
    r: TStringTableRow;
    i: integer;
begin
   Result := '';
   cb := Blocks.ItemByName['~Curve'];
   if Assigned(cb) then
   begin
     for i := 0 to cb.TableContent.RowCount - 1 do
     if  (Pos('~', cb.TableContent.Rows[i].Cols[0]) = 0)
     and (Pos('#', cb.TableContent.Rows[i].Cols[0]) = 0)
     and (Pos('DEPT', cb.TableContent.Rows[i].Cols[0]) = 0) then     
       Result := Result + Trim(cb.TableContent.Rows[i].Cols[0]) + '; ';
   end;

   Result := Trim(Result);
   if Encoding = encAscii then Result := AnsiUpperCase(OemToAnsiStr(Result));   
end;

function TLasFileContent.GetAreaName: string;
var wb: TLasFileBlock;
    r: TStringTableRow;
begin
   Result := '';
   wb := WellBlock;
   if Assigned(wb) then
   begin
     r := wb.TableContent.RowByName['FLD'];
     if Assigned(r) and (r.ColCount > 2) then
       Result := r.Cols[2];
   end;
   if Encoding = encAscii then Result := OemToAnsiStr(Result);   
end;

function TLasFileContent.GetWellNum: string;
var wb: TLasFileBlock;
    r: TStringTableRow;
begin
   Result := '';
   wb := WellBlock;
   if Assigned(wb) then
   begin
     r := wb.TableContent.RowByName['WELL'];
     if Assigned(r) and (r.ColCount > 2) then
       Result := r.Cols[2];
   end;

   if Encoding = encAscii then Result := OemToAnsiStr(Result); 
end;

function TLasFileContent.GetEncoding: TEncoding;
var S1, S2: string;
    wb, cb: TLasFileBlock;
    r: TStringTableRow;
    i: integer;
begin
   S1 := '';
   wb := WellBlock;
   if Assigned(wb) then
   begin
     r := wb.TableContent.RowByName['FLD'];
     if Assigned(r) and (r.ColCount > 2) then
       S1 := r.Cols[2];
   end;

   S2 := '';
   cb := Blocks.ItemByName['~Curve'];
   if Assigned(cb) then
   begin
     for i := 0 to cb.TableContent.RowCount - 1 do
     if  (Pos('~', cb.TableContent.Rows[i].Cols[0]) = 0)
     and (Pos('#', cb.TableContent.Rows[i].Cols[0]) = 0)
     and (Pos('DEPT', cb.TableContent.Rows[i].Cols[0]) = 0) then
       S2 := S2 + cb.TableContent.Rows[i].Cols[0] + '; ';
   end;


  // три теста из разных блоков
  if TEncoder.IsOemStr(S1) or
     TEncoder.IsOemStr(S2) then
     FEncoding := encAscii
  else
     FEncoding := encAnsi;

  Result := FEncoding;
end;

{ TLasFileBlock }

constructor TLasFileBlock.Create;
begin
  inherited;
  FDefaultTableDelimiter := '';
end;

procedure TLasFileBlock.Delete(Index: Integer);
var iIndex: integer;
begin
  if Assigned(RealContent) then
  begin
    iIndex := RealContent.IndexOf(Strings[Index]);
    if iIndex > -1 then RealContent.Delete(iIndex);
  end;
  inherited Delete(index);

  if TableContent.RowCount > index then
    TableContent.DeleteRow(index);
end;

procedure TLasFileBlock.DeleteString(S: string; AStart: integer);
var iIndex: integer;
begin
  iIndex := GetAbsoluteStringIndex(S, AStart);
  if iIndex > -1 then inherited Delete(iIndex);
end;

function TLasFileBlock.GetAbsoluteStringIndex(S: string; AStart: integer = 0; SearchForward: boolean = false): integer;
var i: integer;
begin
  Result := -1;
  if not SearchForward then
  begin
    for i := Count - 1 downto AStart do
    if Pos(AnsiUpperCase(S), AnsiUpperCase(Strings[i])) > 0 then
    begin
      Result := i;
      break;
    end;
  end
  else
  begin
    for i := AStart to Count - 1 do
    if Pos(AnsiUpperCase(S), AnsiUpperCase(Strings[i])) > 0 then
    begin
      Result := i;
      break;
    end;
  end;
end;

function TLasFileBlock.GetFieldValue(AFieldname: string): string;
var
  dotPos, spacePos, dbldotPos:Integer;
  i:Integer;
  input: string;
begin

  input := '';
  for i := 0 to Count - 1 do
  begin
    if (pos(AFieldname,  Strings[i])>0) then
    begin
      input := Strings[i];
      Break;
    end;
  end;

  if Trim(input) <> '' then
  begin
    dotPos:=Pos('.', input);
    dbldotPos:=Pos(':',input);
    Result := trim(Copy(input, dotPos + 1, dbldotPos-dotPos - 1));
  end
  else Result := '';
end;

function TLasFileBlock.GetRealContent: TLasFileBlock;
var i: integer;
begin
  if (not IsRealContent) and (not Assigned(FRealContent)) then
  begin
    FRealContent := TLasFileBlock.Create;
    FRealContent.FIsRealContent := True;
    FRealContent.Name := Name;
    FRealContent.AddStrings(Self);

    for i := FRealContent.Count - 1 downto 0 do
    if (Pos('#', FRealContent[i]) > 0) or (Pos('~', FRealContent[i]) > 0) then
      FRealContent.Delete(i);
  end;
  Result := FRealContent;
end;

function TLasFileBlock.GetStringIndex(S: string; AStart: integer = 0; SearchForward: boolean = false): integer;
var i: integer;
begin
  Result := -1;
  if not SearchForward then
  begin
    for i := RealContent.Count - 1 downto 0 do
    if Pos(AnsiUpperCase(S), AnsiUpperCase(RealContent[i])) > 0 then
    begin
      Result := i;
      break;
    end;
  end
  else
  begin
    for i := AStart to RealContent.Count - 1 do
    if Pos(AnsiUpperCase(S), AnsiUpperCase(RealContent[i])) > 0 then
    begin
      Result := i;
      break;
    end;
  end;
end;

function TLasFileBlock.GetTableContent: TStringTable;
begin
  if not Assigned(FTableContent) then
  begin
    FTableContent := TStringTable.Create;
    FTableContent.ReadTable(Self, TDelimiterStringList.GetIstance);
  end;
  Result := FTableContent;
end;

procedure TLasFileBlock.MakeReplacement(AReplacement: TReplacement);
var i: integer;
begin
  for i := 0 to Count - 1 do
  if ((pos(AReplacement.Field, Strings[i]) > 0) or (AReplacement.Field = '')) then // ищем поле в котором будет производиться замена
    Strings[i] := StringReplace(Strings[i], AReplacement.What, AReplacement.ForWhat, [rfIgnoreCase]);
end;

procedure TLasFileBlock.SaveTableContent;
begin
  Clear;
  TableContent.WriteTable(Self);
end;

{ TLasFileBlocks }

function TLasFileBlocks.Add(AName: string): TLasFileBlock;
var i, iStart, iFin: integer;
begin
  Result := TLasFileBlock.Create;
  Result.Name := AName;
  inherited Add(Result);

  iStart := LasFileContent.Content.GetAbsoluteStringIndex(AName);
  if (iStart > -1) then
  begin
    iFin := LasFileContent.Content.GetAbsoluteStringIndex('~', iStart + 1, true);

    if (iFin = -1) then iFin := LasFileContent.Content.Count - 1;
    for i := iStart to iFin - 1 do
      Result.Add(LasFileContent.Content[i]);
  end;
end;

constructor TLasFileBlocks.Create(ALasFileContent: TLasFileContent);
begin
  inherited;
  FLasFileContent := ALasFileContent;
end;

function TLasFileBlocks.GetItemByName(const Name: string): TLasFileBlock;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if AnsiUpperCase(trim(Items[i].Name)) = AnsiUpperCase(Trim(Name)) then
  begin
    Result := Items[i];
    Break;
  end;
end;

function TLasFileBlocks.GetItems(const Index: integer): TLasFileBlock;
begin
  Result := inherited Items[Index] as TLasFileBlock; 
end;


{ TStringTable }

function TStringTable.AddRow: TStringTableRow;
begin
  Result := TStringTableRow.Create;
  inherited Add(Result);
end;

constructor TStringTable.Create;
begin
  inherited Create(True);
end;

procedure TStringTable.DeleteColumn(ACol: integer; ACurveName: string = '');
var i, j: Integer;
begin
  for i := 0 to RowCount - 1 do
  begin
    if ACol < Rows[i].Count then
      Rows[i].Delete(ACol);

    if trim(ACurveName) <> '' then   
    for j := 0 to Rows[i].ColCount - 1 do
      Rows[i].Cols[j] := StringReplace(Rows[i].Cols[j], ACurveName, '', [rfReplaceAll]);
  end;
end;

procedure TStringTable.DeleteRow(ARow: Integer);
begin
  inherited Delete(ARow);
end;

function TStringTable.GetRowByName(const RowName: string): TStringTableRow;
var i: Integer;
begin
  Result := nil;
  for i := 0 to RowCount - 1 do
  if Trim(AnsiUpperCase(RowName)) = Trim(AnsiUpperCase(Rows[i].Cols[0])) then
  begin
    Result := Rows[i];
    break;
  end;
end;

function TStringTable.GetRowCount: integer;
begin
  Result := Count;
end;

function TStringTable.GetRowIndex(S: string; AColumn: Integer): integer;
var i: integer;
begin
  Result := -1;

  for i := 0 to RowCount - 1 do
  if AColumn < Rows[i].ColCount then
  if Trim(Rows[i].Cols[AColumn]) = trim(S) then
  begin
    Result := i;
    break;
  end;
end;

function TStringTable.GetRows(const Index: Integer): TStringTableRow;
begin
  Result := inherited Items[index] as TStringTableRow;
end;



procedure TStringTable.ReadTable(AStringList,
  AColumnDelimiters: TStringList);
var i, j, iDelimIndex, jR: integer;
    r: TStringTableRow;
    s, sTmp: string;
begin
  for i := 0 to AStringList.Count - 1 do
  begin
    r := AddRow;

    s := Trim(AStringList.Strings[i]);
    if (Pos('~', s) <= 0) and (Pos('#', s) <= 0) then
    begin
      iDelimIndex := 0;
      //while (iDelimIndex < AColumnDelimiters.Count - 1) do
      //  iDelimIndex := iDelimIndex + 1;

      jR := 0;
      while (Pos(AColumnDelimiters[iDelimIndex], s) > 0) or (AColumnDelimiters[iDelimIndex] <> ':') do
      begin
        j := Pos(AColumnDelimiters[iDelimIndex], s);
        if (j > 1) then
        begin
          if (AColumnDelimiters[iDelimIndex] <> ' ') or ((AColumnDelimiters[iDelimIndex] = ' ') and (j < 3)) then
          begin
            sTmp := copy(s, 1, j - 1);
            r.Add(Trim(sTmp));
            r.DelimitersRow.AddObject(AColumnDelimiters[iDelimIndex], TObject(jR));
          end
          else
          begin
            if r.ColCount > 0 then // первый столбик всегда непустой
            begin
              r.Add('');
              r.DelimitersRow.AddObject('', TObject(0));
            end;
            j := 0;
          end;
        end
        else
        begin
          // первый столбик всегда непустой
          if r.Count > 0 then
          begin
            r.Add('');
            r.DelimitersRow.AddObject('', TObject(0));
          end;
        end;

        s := Copy(s, j + 1, Length(S));
        jR := jR + Length(S);
        s := Trim(s);
        jR := jR - Length(S);

        iDelimIndex := iDelimIndex + 1;
        
        if iDelimIndex > AColumnDelimiters.Count - 1 then iDelimIndex := 0;
      end;
    end;

    if Trim(s) <> '' then r.Add(Trim(s));
  end;
end;

procedure TStringTable.WriteTable(AStringList: TStringList);
var i: integer;
begin
  AStringList.Clear;
  for i := 0 to RowCount - 1 do
    AStringList.Add(Rows[i].MakeDelimitedRow);
end;

{ TStringTableRow }

destructor TStringTableRow.Destroy;
begin
  FDelimitersRow.Free;
  inherited;
end;

function TStringTableRow.GetColCount: integer;
begin
  Result := Count;
end;

function TStringTableRow.GetCols(const Index: integer): String;
begin
  Result := inherited Strings[Index];
end;

function TStringTableRow.GetDelimitersRow: TStringTableRow;
begin
  if not Assigned(FDelimitersRow) then
    FDelimitersRow := TStringTableRow.Create;

  Result := FDelimitersRow;   
end;

function TStringTableRow.MakeDelimitedRow(ADelimiter: string): string;
var i: integer;
begin
  Result := '';
  for i := 0 to Count - 2 do
    Result := Result + Cols[i] + ADelimiter;

  Result := Result + Cols[Count - 1];
end;

function TStringTableRow.MakeDelimitedRow: string;
var i: integer;
begin
  Result := '';

  // здесь неправильно, нужно где-то брать этот разделитель по умолчанию
  if DelimitersRow.Count < Count - 1 then Result := MakeDelimitedRow('')
  else
  begin
    for i := 0 to Count - 2 do
    begin
      Result := Result +  PadSymbolL(Cols[i], ' ', Integer(DelimitersRow.Objects[i])+Length(Cols[i]));
      Result := Result +  DelimitersRow.Cols[i];
    end;

    Result := Result + Cols[Count - 1];
  end;
end;

procedure TStringTableRow.SetCols(const Index: integer;
  const Value: String);
begin
  inherited Strings[Index] := Value;
end;

{ TReplacementList }

function TReplacementList.AddReplacement(APart, AField, AWhat,
  AForWhat: string): TReplacement;
begin


  Result := TReplacement.Create;
  Result.BlockName := APart;
  Result.What := AWhat;
  Result.ForWhat := AForWhat;
  Result.Field := AField;

  inherited Add(Result);
end;

procedure TReplacementList.CopyFrom(AReplacementList: TReplacementList);
var i: integer;
begin
  OwnsObjects := false;
  for i := 0 to AReplacementList.Count - 1 do
   Add(AReplacementList.Items[i]);
end;

constructor TReplacementList.Create;
begin
  inherited Create(True);
end;

function TReplacementList.GetItems(const Index: integer): TReplacement;
begin
  Result := inherited Items[Index] as TReplacement;
end;



{ TCurveCategory }

constructor TCurveCategory.Create(ACollection: TIDObjects);
begin
  inherited;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TCurveCategoryDataPoster];
  FClassIDString := 'Категория кривой';
 end;

{ TCurveCategoryes }

constructor TCurveCategories.Create;
begin
  inherited;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TCurveCategoryDataPoster];
  FObjectClass := TCurveCategory;
end;

function TCurveCategories.GetItems(const Index: Integer): TCurveCategory;
begin
  Result := inherited Items[index] as TCurveCategory;
end;

{ TLasFileContents }

constructor TLasFileContents.Create;
begin
  inherited Create(true);
end;

function TLasFileContents.GetContentByFile(
  ALasFile: TObject): TLasFileContent;
var i: integer;
begin
  Result := nil;

  for i := 0 to Count - 1 do
  if Items[i].LasFile = ALasFile then
  begin
    Result := Items[i];
    Break;
  end;
end;

function TLasFileContents.GetItems(const Index: integer): TLasFileContent;
begin
  Result := inherited Items[index] as TLasFileContent;
end;

{ TStringInBlock }

function TStringInBlock.ConvertToFloat: Double;
var
  i:Integer;
  temp:string;
begin
  temp:=Value;
  {for i:=1 to Length(temp) do
    if (temp[i]='.') then temp[i]:=',';}
  Result:=StrToFloat(temp);
end;

function TStringInBlock.GetComment: String;
begin
  if (FComment='') then
    Result:=copy(FFullString, Pos(':',FFullString)+1, length(FFullString)-Pos(':',FFullString))
  else Result:=FComment;
end;

function TStringInBlock.GetCurve: String;
begin
if ((BlockName='~Curve Information') and (IsCommentString=false)) then
  begin
    Result:=trim(copy(Name,1,Pos('.',Name)-1));
  end
else
  Result:='';
end;


function TStringInBlock.GetName: String;
  var
  pos1,pos2,i:Integer;
  temp:String;
begin
  if ((FBlockName<>'~ASCII Log Data') and (FIsCommentString<>true) and (FName='')) then
    if (FBlockName='~Curve Information') then
      begin
        pos1:=Pos('.', FFullString);
        temp:=copy(FFullString,1,pos1-1);
        while (Pos(' ',temp)>0) do
          begin
            Delete(temp,pos(' ',temp),1);
          end;
        Result:=temp+'.';
        for i:=pos1 to pos(':',FFullString) do
          begin
            if ((FullString[i]<>' ') and (FFullString[i+1]=' ')) then
              begin
                Result:=Result+trim(Copy(FFullString,pos1,i-pos1));
                break;
              end;
          end;
      end
    else
      begin
        pos1:=Pos('.', FFullString);
        if (FFullString[pos1+1]<>' ') then
          Result:=copy(FFullString, 1, pos1+1)
        else
          Result:=copy(FFullString, 1, pos1);
      end
  else Result:=FName;
end;

function TStringInBlock.GetValue: String;
  var
  pos1:Integer;
begin
  if ((FBlockName<>'~ASCII Log Data') and (FIsCommentString<>true) and (FValue='')) then
      begin
        pos1:=Pos('.', FFullString);
        if (FFullString[pos1+1]<>' ') then
          Result:=Trim(copy(FFullString, pos1+2, Pos(':',FFullString)-pos1-2))
        else
          Result:=Trim(copy(FFullString, pos1+1, Pos(':',FFullString)-pos1-1));
      end
  else Result:=FValue;
end;



procedure TStringInBlock.VerifyValue;
var
  RegExp: TRegExpr;
begin
  if (Pos('DATE', Name)>0)  then
    begin
      if (Value='') then State:=Detected
      else
        begin
          RegExp := TRegExpr.Create;
          RegExp.InputString:=Value;
          RegExp.Expression:='((0[1-9]|1[0-9]|2[0-9]|3[01]))(\.)(0[1-9]|1[012])(\.)([0-9]{4})';
          if RegExp.Exec then
            State:=Detected
          else
            State:=NotDetected;
          RegExp.Free;
        end;
    end;
  if ((Pos('STRT', Name)>0) or (Pos('STOP', Name)>0) or (Pos('STEP', Name)>0))  then
    begin
      if (Value='') then State:=NotDetected
      else
        begin
          State:=Detected
        end;
    end;
  if (Pos('NULL', Name)>0) then
    begin
      if (Value='') then
        begin
          Value:='-9999';
          State:=Detected;
        end
      else
        if ((Value='-9999') or (Value='-999.25')) then
          State:=Detected
        else
          State:=NotDetected;
    end;
end;

{ TStringsInBlock }

function TStringsInBlock.Add(AFullString: string; ABlockName: String; AIsCommentString: Boolean): TStringInBlock;
begin
  Result := TStringInBlock.Create;
  //A//nsiToOem(AFullString, AnsiString(Pchar(Result.FullString)));
  Result.FullString :=  AFullString;
  Result.BlockName := ABlockName;
  Result.FIsCommentString:=AIsCommentString;
  inherited Add(Result);
end;


constructor TStringsInBlock.Create;
begin
 inherited Create(True);
end;

function TStringsInBlock.GetStringByName(AName: String): TStringInBlock;
  var
    i: Integer;
begin
  Result:=nil;;
  for i:=0 to Count-1 do
    if (Pos(AName,Items[i].Name)>0) then result:=Items[i];
end;

function TStringsInBlock.GetItems(const Index: integer): TStringInBlock;
begin
 Result := inherited Items[Index] as TStringInBlock;
end;

function TStringsInBlock.AddToPos(AFullString, ABlockName: String;
  AIsCommentString: Boolean): TStringInBlock;
var
  i:integer;
begin
  Result := TStringInBlock.Create;
  Result.FullString := AFullString;
  Result.BlockName := ABlockName;
  Result.FIsCommentString:=AIsCommentString;
  for i:=0 to Count-1 do
    begin
      if ((Items[i].FBlockName=ABlockName) and (Items[i+1].FBlockName<>ABlockName))
      then
        begin
          Insert(i,Result);
          break;
        end;
    end;
end;

procedure TStringsInBlock.MakeFullStrings;
var
  i,k:integer;
  tName, tValue : String;
begin
  for i:=0 to Count-1 do
    if (Items[i].IsCommentString=False) then
      begin
        tName:=Items[i].Name;
        tValue:=Items[i].Value;
        if (length(tName)>=FMaxName) then
          begin
            FMaxName:=length(tName);
            tName:=tName+' ';
          end
        else
          begin
           for k:=0 to FMaxName-length(tName)+1 do
            tName:=tName+' ';
          end;
        if (length(tValue)>=FMaxValue) then
          begin
            FMaxValue:=length(tValue);
            tValue:=' '+tValue;
          end
        else
          begin
           for k:=0 to FMaxValue-length(tValue)+1 do
            tValue:=' '+tValue;
          end;
        Items[i].FullString:=tName+TValue+':'+Items[i].Comment;
      end;
end;

{ TDelimiterStringList }

constructor TDelimiterStringList.Create;
begin
  inherited;
  Add('.');
  Add(' ');
  Add(':');
end;

class function TDelimiterStringList.GetIstance: TDelimiterStringList;
const delim: TDelimiterStringList = nil;
begin
  if not Assigned(delim) then delim := TDelimiterStringList.Create;
  Result := delim;
end;

end.
