unit ResearchGroup;

interface

uses BaseObjects, BaseReport, CommonReport, LasFile, Classes, Material, Encoder;

type
  TInfoGroup = class(TIDObject)
  private
    FTestQuery: string;
    FTag: string;
    FTestQueryResult: OleVariant;
    FPlace: string;
    FIsSingle: Boolean;
  protected
    function  PrepareTestQuery: string; virtual;
    procedure InternalRetrieveObjectInfo(AObject: TIDObject; ADestinationPath: string = ''; AObjectList: TIDObjects = nil); virtual;
    procedure InternalRetrieveObjectsInfo(AObjects: TIDObjects; ADestinationPath: string = ''; AObjectList: TIDObjects = nil); virtual;
    procedure InitializeInfoGroup; virtual;
    function GetUserFolderName: string; virtual;
  public
    property  TestQuery: string read FTestQuery write FTestQuery;
    property  TestQueryResult: OleVariant read FTestQueryResult;
    property  UserFolderName: string read GetUserFolderName;

    function  ObjectInfoExists(AObject: TIDObject): Boolean;
    property  Tag: string read FTag write FTag;
    property  Place: string read FPlace write FPlace;
    property  IsSingle: Boolean read FIsSingle write FIsSingle;

    procedure RetrieveObjectInfo(AObject: TIDObject; ADestinationPath: string = ''; AObjectList: TIDObjects = nil);
    procedure RetrieveObjectsInfo(AObjects: TIDObjects; ADestinationPath: string = ''; AObjectList: TIDObjects = nil);
    constructor Create(ACollection: TIDObjects); override;
  end;

  TInfoGroupClassType = class of TInfoGroup;

  TReportInfoGroup = class(TInfoGroup)
  private
    FReport: TBaseReport;
    FReportClass: TBaseReportClass;
  protected
    procedure InternalRetrieveObjectInfo(AObject: TIDObject; ADestinationPath: string = ''; AObjectList: TIDObjects = nil); override;
    procedure InternalRetrieveObjectsInfo(AObjects: TIDObjects; ADestinationPath: string = ''; AObjectList: TIDObjects = nil); override;
    function  GetUserFolderName: string; override;
  public
    property ReportClass: TBaseReportClass read FReportClass write FReportClass;
    property Report: TBaseReport read FReport;
  end;

  TFileInfoGroup = class(TInfoGroup)
  private
    FSourceBaseDir: string;
    FOldFileName: string;
    FNewFilename: string;
    FDefaultExt: string;
  protected
    procedure DoAfterCopy(); virtual;
    procedure InternalRetrieveObjectInfo(AObject: TIDObject; ADestinationPath: string = ''; AObjectList: TIDObjects = nil); override;
  public
    property  DefaultExt: string read FDefaultExt write FDefaultExt; 
    property  FileName: string read FNewFilename write FNewFileName;
    property  OldFileName: string read FOldFileName write FOldFileName;
    property  SourceBaseDir: string read FSourceBaseDir write FSourceBaseDir;
  end;

  TLasFileInfoGroup = class(TFileInfoGroup)
  private
    FLasFileContent: TLasFileContent;
    FCurvesToCrop: TStringList;
    FCropCurves: boolean;
    FCropBlocks: Boolean;
    FEncoding: TEncoding;
    FMakeReplacements: boolean;
    FReplacementList: TReplacementList;
    FBlocksToLeave: TStringList;
    function GetCurvesToCrop: TStringList;
    function GetBlocksToLeave: TStringList;
 protected
    procedure InitializeInfoGroup; override;
    procedure DoAfterCopy(); override;
    procedure InternalRetrieveObjectInfo(AObject: TIDObject; ADestinationPath: string = ''; AObjectList: TIDObjects = nil); override;
    function  GetUserFolderName: string; override;
  public
    property Encoding: TEncoding read FEncoding write FEncoding;
    property LasFileContent: TLasFileContent read FLasFileContent;

    property CropCurves: Boolean read FCropCurves write FCropCurves;
    property CurvesToLeave: TStringList read GetCurvesToCrop;

    property CropBlocks: boolean read FCropBlocks write FCropBlocks;
    property BlocksToLeave: TStringList read GetBlocksToLeave;

    property MakeReplacements: boolean read FMakeReplacements write FMakeReplacements;
    property Replacements: TReplacementList read FReplacementList write FReplacementList;

    destructor Destroy; override;
  end;

  TAllLasFileCopyAnsi = class(TLasFileInfoGroup)
  protected
    procedure InitializeInfoGroup; override;
  end;

  TAllLasFileCopyAscii = class(TLasFileInfoGroup)
  protected
    procedure InitializeInfoGroup; override;
  end;

  TDMFileInfoGroup = class(TFileInfoGroup)
  private
    FDocTypeName: string;

  protected
    FDocumentTypes: TDocumentTypes;
    procedure DoAfterCopy; override;
    procedure InternalRetrieveObjectInfo(AObject: TIDObject;
      ADestinationPath: string = ''; AObjectList: TIDObjects = nil); override;

    function  GetDocumentTypes: TDocumentTypes; virtual;
    procedure InitializeInfoGroup; override;
    function  PrepareTestQuery: string; override;
  public
    property   DocTypeName: string read FDocTypeName write FDocTypeName;
    property   DocumentTypes: TDocumentTypes read GetDocumentTypes;
    destructor Destroy; override;
  end;


  TLasReplacements = class(TReplacementList)
  public
    constructor Create; override;
  end;

  TGKNGKLasFileInfoGroup = class(TLasFileInfoGroup)
  protected
    procedure InitializeInfoGroup; override;
  end;

  TStLasFileInfoGroup = class(TLasFileInfoGroup)
  protected
    procedure InitializeInfoGroup; override;
  end;

  TAKLasFileInfoGroup = class(TLasFileInfoGroup)
  protected
    procedure InitializeInfoGroup; override;
  end;




  TPetrophisicsReportInfoGroup = class(TReportInfoGroup)
  protected
    procedure InitializeInfoGroup; override;
  end;

  TGranulometryReportInfoGroup = class(TReportInfoGroup)
  protected
    procedure InitializeInfoGroup; override;
  end;

  TCentrifugingReportInfoGroup = class(TReportInfoGroup)
  protected
    procedure InitializeInfoGroup; override;
  end;

  TCoreDescriptionFileInfoGroup = class(TDMFileInfoGroup)
  protected
    procedure InitializeInfoGroup; override;
  end;

  TSchlamDescriptionFileInfoGroup = class(TDMFileInfoGroup)
  protected
    procedure InitializeInfoGroup; override;
  end;


  TSchlifDescriptionFileInfoGroup = class(TDMFileInfoGroup)
  protected
    procedure InitializeInfoGroup; override;
  end;

  TInclinometrFileInfoGroup = class(TDMFileInfoGroup)
  protected
    procedure InitializeInfoGroup; override;
  end;

  TDMPetrofisicsFileInfoGroup = class(TDMFileInfoGroup)
  protected
    procedure InitializeInfoGroup; override;
    function GetUserFolderName: string; override;    
  end;

  TStandardSubdivisionReportInfoGroup = class(TReportInfoGroup)
  protected
    procedure InitializeInfoGroup; override;
  end;



  TInfoGroups = class(TIDObjects)
  private
    function GetItems(const Index: Integer): TInfoGroup;
  public
    function AreSingle: Boolean;
    function HaveSingle: Boolean;
    function AddInfoGroupClass(AInfoGroupClassType: TInfoGroupClassType): TInfoGroup;
    property Items[const Index: Integer]: TInfoGroup read GetItems;
    constructor Create; override;
  end;

implementation

uses Facade, SysUtils, Variants, Windows, PetrophisicsReports, SubdivisionReports, FileUtils;

{ TInfoGroups }

function TInfoGroups.AddInfoGroupClass(
  AInfoGroupClassType: TInfoGroupClassType): TInfoGroup;
begin
  Result := AInfoGroupClassType.Create(Self);
  inherited Add(Result, False, False);
end;

function TInfoGroups.AreSingle: Boolean;
var i: Integer;
begin
  Result := True;
  for i := 0 to Count - 1 do
    Result := Result and Items[i].IsSingle;
end;

constructor TInfoGroups.Create;
begin
  inherited;
  FObjectClass := TInfoGroup;
  FDataPoster := nil;
end;

function TInfoGroups.GetItems(const Index: Integer): TInfoGroup;
begin
  Result := inherited Items[index] as TInfoGroup;
end;

function TInfoGroups.HaveSingle: Boolean;
var i: Integer;
begin
  Result := false;
  for i := 0 to Count - 1 do
    Result := Result or Items[i].IsSingle;
end;

{ TInfoGroup }

constructor TInfoGroup.Create(ACollection: TIDObjects);
begin
  inherited;
  FDataPoster := nil;
  ClassIDString := 'Ãğóïïà èññëåäîâàíèé';

  InitializeInfoGroup;

end;

function TInfoGroup.GetUserFolderName: string;
begin
  Result := Name;
end;

procedure TInfoGroup.InitializeInfoGroup;
begin

end;

procedure TInfoGroup.InternalRetrieveObjectInfo(AObject: TIDObject; ADestinationPath: string = ''; AObjectList: TIDObjects = nil);
begin

end;

procedure TInfoGroup.InternalRetrieveObjectsInfo(AObjects: TIDObjects;
  ADestinationPath: string; AObjectList: TIDObjects);
begin

end;

function TInfoGroup.ObjectInfoExists(AObject: TIDObject): Boolean;
var sQuery: string;
begin
  sQuery := PrepareTestQuery;
  sQuery := Format(sQuery, [IntToStr(AObject.ID)]);
  Result := TMainFacade.GetInstance.ExecuteQuery(sQuery, FTestQueryResult) > 0;
end;

function TInfoGroup.PrepareTestQuery: string;
begin
  Result := TestQuery;
end;

procedure TInfoGroup.RetrieveObjectInfo(AObject: TIDObject; ADestinationPath: string = ''; AObjectList: TIDObjects = nil);
begin
  if ObjectInfoExists(AObject) then
    InternalRetrieveObjectInfo(AObject, ADestinationPath, AObjectList);
end;

procedure TInfoGroup.RetrieveObjectsInfo(AObjects: TIDObjects;
  ADestinationPath: string; AObjectList: TIDObjects);
begin
  InternalRetrieveObjectsInfo(AObjects, ADestinationPath, AObjectList);
end;

{ TFileInfoGroup }

procedure TFileInfoGroup.DoAfterCopy;
begin

end;

procedure TFileInfoGroup.InternalRetrieveObjectInfo(AObject: TIDObject; ADestinationPath: string = ''; AObjectList: TIDObjects = nil);
var i: integer;
    sLastFileName, sRealExt: string;
begin
  inherited;

  // êîïèğóåò ôàéëû èç BaseDir â ADestinationPath
  if (not varIsEmpty(FTestQueryResult)) and (not varIsNull(FTestQueryResult)) then
  begin
    sLastFileName := '';  
    for i := 0 to VarArrayHighBound(FTestQueryResult, 2) do
    begin
      FOldFileName := SourceBaseDir + varAsType(FTestQueryResult[0, i], varOleStr);

      sLastFileName := FNewFilename;
      if VarArrayHighBound(FTestQueryResult, 1) = 0 then
        FNewFileName := ADestinationPath + '\' + ExtractFileName(FOldFileName)
      else if VarArrayHighBound(FTestQueryResult, 1) > 0 then
        FNewFileName := ADestinationPath + '\' + ExtractFileName(varAsType(FTestQueryResult[1, i], varOleStr));

      if (i > 0) and (sLastFileName = FNewFilename) then
        FNewFilename := StringReplace(FNewFilename, '.', '(' + IntToStr(i + 1) + ').', []);

      if VarArrayHighBound(FTestQueryResult, 1) > 1 then // òğåòèé ñòîëáåö - èñòî÷íèê ğàñøèğåíèÿ
      begin
        sRealExt := ExtractFileExt(varAsType(FTestQueryResult[2, i], varOleStr));
        FNewFilename := ChangeFileExt(FNewFilename, sRealExt);
      end;

      FNewFilename := CorrectFileName(FNewFilename);

      if FileExists(FOldFileName) then
      begin
        //try
          CopyFile(PChar(FOldFileName), PChar(FNewFileName), False);
          DoAfterCopy();
        //except
          // !!
        //end;
      end;
    end;
  end;
end;

{ TGKNGKLasFileInfoGroup }


procedure TGKNGKLasFileInfoGroup.InitializeInfoGroup;
begin
  inherited;
  TestQuery := 'select distinct lf.vch_filename, lf.vch_old_filename from tbl_las_file lf, tbl_las_curve lc, tbl_curve_dict cc where cc.curve_id = lc.curve_id and lf.las_file_uin = lc.las_file_uin and cc.curve_category_id in (7,8,15,16) and lf.well_uin = %s';


  Name := 'ÃÊ, ÍÃÊ, ÃÃÊÏ';
  Encoding := encAnsi;
   
  CropCurves := True;
  CurvesToLeave.Add('DEPT');
  CurvesToLeave.Add('DEPTH');
  CurvesToLeave.Add('GGKp');
  CurvesToLeave.Add('GK');
  CurvesToLeave.Add('GK d_k');
  CurvesToLeave.Add('GKp_k');
  CurvesToLeave.Add('GR');
  CurvesToLeave.Add('GR2');
  CurvesToLeave.Add('NEUT');
  CurvesToLeave.Add('NGK');
  CurvesToLeave.Add('NGL');
  CurvesToLeave.Add('NGR');
  CurvesToLeave.Add('NKTB');
  CurvesToLeave.Add('NKTM');
  CurvesToLeave.Add('NKtb');
  CurvesToLeave.Add('NPHI');
  CurvesToLeave.Add('RHOB');
  CurvesToLeave.Add('TNNB');
  CurvesToLeave.Add('TNNS');
  CurvesToLeave.Add('ÃÃÊÏ');
  CurvesToLeave.Add('ÃÃÊÏ1');
  CurvesToLeave.Add('ÃÃÊï');
  CurvesToLeave.Add('ÃÃÊï_ê');
  CurvesToLeave.Add('ÃÊ');
  CurvesToLeave.Add('ÃÊ   ñâ1');
  CurvesToLeave.Add('ÃÊ  ñâ2');
  CurvesToLeave.Add('ÃÊ-áğàê');
  CurvesToLeave.Add('ÃÊ1');
  CurvesToLeave.Add('ÃÊ2');
  CurvesToLeave.Add('ÃÊÍ');
  CurvesToLeave.Add('ÃÊè');
  CurvesToLeave.Add('ÃÊê');
  CurvesToLeave.Add('ÃÊñâ');
  CurvesToLeave.Add('ÍÃÊ');
  CurvesToLeave.Add('ÍÃÊ  ñâ1');
  CurvesToLeave.Add('ÍÃÊ  ñâ2');
  CurvesToLeave.Add('ÍÊ');
  CurvesToLeave.Add('ÍÊÒ');
  CurvesToLeave.Add('ÍÊÒÁ');
  CurvesToLeave.Add('ÍÊÒÁê');
  CurvesToLeave.Add('ÍÊÒÌ');
  CurvesToLeave.Add('ÍÊÒÌê');
  CurvesToLeave.Add('ÍÊÒá');
  CurvesToLeave.Add('ÍÊÒì');
  CurvesToLeave.Add('ÍÍÊÒ');
  CurvesToLeave.Add('ÍÍÊÒÁ');
  CurvesToLeave.Add('ÍÍÊÒá');
  CurvesToLeave.Add('ÍÍÊÒì');
  CurvesToLeave.Add('ÍÍÊòÁÇ');
  CurvesToLeave.Add('ÍÍÊòÌÇ');
  CurvesToLeave.Add('ÍÍÍÁ');
  CurvesToLeave.Add('ÍÍÍÌ');
  CurvesToLeave.Add('ÍÍÒÁ');
  CurvesToLeave.Add('ÍÍÒÌ');

  FReplacementList := TLasReplacements.Create;
  ////1-------- ıòî äëÿ òàêîãî ñëó÷àÿ:   WeLL.     WELL:5----------------//
  Replacements.AddReplacement('~Well', 'WELL', '   WELL:2', '2_Saluk: ');
  Replacements.AddReplacement('~Well', 'FLD', 'FIELD:Ñàëşêèíñêàÿ (-îå)', '     :                 ');

  //Replacements.AddReplacement('~Well', 'WELL', '        91', '91_Yareyag');
  //Replacements.AddReplacement('~Well', 'FLD', 'ßğåéÿãèíñêàÿ', '            ');

  Replacements.AddReplacement('~Curve','À','À','A');
  Replacements.AddReplacement('~Curve','Á','Á','B');
  Replacements.AddReplacement('~Curve','Â','Â','V');
  Replacements.AddReplacement('~Curve','Ã','Ã','G');
  Replacements.AddReplacement('~Curve','Ä','Ä','D');
  Replacements.AddReplacement('~Curve','Å','Å','E');
  Replacements.AddReplacement('~Curve','Æ','Æ','J');
  Replacements.AddReplacement('~Curve','Ç','Ç','Z');
  Replacements.AddReplacement('~Curve','È','È','I');
  Replacements.AddReplacement('~Curve','Ê','Ê','K');
  Replacements.AddReplacement('~Curve','Ë','Ë','L');
  Replacements.AddReplacement('~Curve','Ì','Ì','M');
  Replacements.AddReplacement('~Curve','Í','Í','N');
  Replacements.AddReplacement('~Curve','Î','Î','O');
  Replacements.AddReplacement('~Curve','Ï','Ï','P');
  Replacements.AddReplacement('~Curve','Ğ','Ğ','R');
  Replacements.AddReplacement('~Curve','Ñ','Ñ','S');
  Replacements.AddReplacement('~Curve','Ò','Ò','T');
  Replacements.AddReplacement('~Curve','Ó','Ó','U');
  Replacements.AddReplacement('~Curve','Ô','Ô','F');
  Replacements.AddReplacement('~Curve','Õ','Õ','H');
  Replacements.AddReplacement('~Curve','Ö','Ö','C');
  Replacements.AddReplacement('~Curve','×','×','Ch');
  Replacements.AddReplacement('~Curve','Ø','Ø','Sh');
  Replacements.AddReplacement('~Curve','Ù','Ù','Sch');
  Replacements.AddReplacement('~Curve','İ','İ','A');
  Replacements.AddReplacement('~Curve','Ş','Ş','U');
  Replacements.AddReplacement('~Curve','ß','ß','Ya');  
end;

{ TLasFileInfoGroup }


destructor TLasFileInfoGroup.Destroy;
begin
  FreeAndNil(FReplacementList);
  FreeAndNil(FBlocksToLeave);
  FreeAndNil(FCurvesToCrop);  
  inherited;
end;


procedure TLasFileInfoGroup.DoAfterCopy;
var
    sFileName: string;
begin
  inherited;
  sFileName := FileName + '_';
  TEncoder.GetInstance.DecodeFile(FileName, sFileName);
  FLasFileContent := TLasFileContent.Create(sFileName);
 // FLasFileContent.ReadFile;

  if CropCurves then
    FLasFileContent.CropAllExceptListedCurves(CurvesToLeave);

  if CropBlocks then
    FLasFileContent.CropAllExceptListedBlocks(BlocksToLeave);
  if MakeReplacements then
    {FLasFileContent.MakeReplacements(Replacements);   }

  case Encoding of
  encAscii:
  begin
    FLasFileContent.SaveFile();
    TEncoder.GetInstance.EncodeFile(sFileName, FileName);
  end;
  encAnsi:
    FLasFileContent.SaveFile(FileName);
  end;

  DeleteFile(PChar(sFileName));
end;

function TLasFileInfoGroup.GetBlocksToLeave: TStringList;
begin
  if not Assigned(FBlocksToLeave) then
    FBlocksToLeave := TStringList.Create;
  Result := FBlocksToLeave;
end;



function TLasFileInfoGroup.GetCurvesToCrop: TStringList;
begin
  if not Assigned(FCurvesToCrop) then
    FCurvesToCrop := TStringList.Create;
  Result := FCurvesToCrop;
end;




function TLasFileInfoGroup.GetUserFolderName: string;
begin
  Result := Tag + '\' + Name;
end;

procedure TLasFileInfoGroup.InitializeInfoGroup;
begin
  inherited;
  Tag := 'LAS-ôàéëû';
  SourceBaseDir := '\\SRVDB.TPRC\LasBank\LasBank';
  Place := 'ĞÁÖÃÈ';
  DefaultExt := '.las';

  CropCurves := true;
  MakeReplacements := true;
  CropBlocks := true;
  Encoding := encAnsi;

  BlocksToLeave.Add('~Version');
  BlocksToLeave.Add('~Well');
  BlocksToLeave.Add('~Curve');
  BlocksToLeave.Add('~A');  
end;

procedure TLasFileInfoGroup.InternalRetrieveObjectInfo(AObject: TIDObject;
  ADestinationPath: string = ''; AObjectList: TIDObjects = nil);
begin
  inherited;
end;       

{ TPetrophisicsReportInfoGroup }

procedure TPetrophisicsReportInfoGroup.InitializeInfoGroup;
begin
  inherited;
  TestQuery := 'select * from tbl_dnr_research d, tbl_rock_sample rs, tbl_slotting s where d.rock_sample_uin = rs.rock_sample_uin and s.slotting_uin = rs.slotting_uin and d.research_id >= 100 and d.research_id < 200 and s.Well_UIN = %s';
  Name := 'Îáùèå ïåòğîôèçè÷åñêèå ñâîéñòâà';
  Tag := 'Ïåòğîôèçèêà';
  Place := 'ĞÁÖÃÈ';
  ReportClass := TPetrophisicsReport;
end;

{ TReportInfoGroup }

function TReportInfoGroup.GetUserFolderName: string;
begin
  Result := Tag;
end;

procedure TReportInfoGroup.InternalRetrieveObjectInfo(AObject: TIDObject;
  ADestinationPath: string = ''; AObjectList: TIDObjects = nil);
begin
  inherited;
  FReport := ReportClass.Create(nil);
  FReport.ReportPath := ADestinationPath;
  FReport.MakeVisible := false;
  FReport.ReportingObjects.Clear;
  FReport.ReportingObjects.Add(AObject, False, False);

  // âñå îáúåêòû
  if Assigned(AObjectList) then
  begin
    FReport.AllObjects.Clear;
    FReport.AllObjects.AddObjects(AObjectList, False, False);
  end;

  FReport.Execute;
  FReport.Free;
end;

procedure TReportInfoGroup.InternalRetrieveObjectsInfo(
  AObjects: TIDObjects; ADestinationPath: string; AObjectList: TIDObjects);
begin
  FReport := ReportClass.Create(nil);
  FReport.ReportPath := ADestinationPath;
  FReport.MakeVisible := false;
  FReport.ReportingObjects.Clear;
  FReport.ReportingObjects.AddObjects(AObjects, False, False);

  // âñå îáúåêòû
  if Assigned(AObjectList) then
  begin
    FReport.AllObjects.Clear;
    FReport.AllObjects.AddObjects(AObjectList, False, False);
  end;

  FReport.Execute;
  FReport.Free;
end;

{ TDMFileInfoGroup }

destructor TDMFileInfoGroup.Destroy;
begin
  FreeAndNil(FDocumentTypes);
  inherited;
end;

procedure TDMFileInfoGroup.DoAfterCopy;
begin
  inherited;
  
end;

function TDMFileInfoGroup.GetDocumentTypes: TDocumentTypes;
begin
  if not Assigned(FDocumentTypes) then
  begin
    FDocumentTypes := TDocumentTypes.Create;
    FDocumentTypes.Poster := nil;
    FDocumentTypes.OwnsObjects := false;
  end;
  Result := FDocumentTypes;
end;

procedure TDMFileInfoGroup.InitializeInfoGroup;
begin
  inherited;
  Tag := 'Äîêóìåíòû è ìàòåğèàëû';
  SourceBaseDir := '';
  Place := 'ĞÁÖÃÈ';

  TestQuery := 'select m.vch_location, rf_trim(rf_strreplace(' + '''' + ':DOC_TYPE_NAME ' + '''' + '||w.vch_well_num||' + '''' + ' - ' + '''' + '||a.vch_area_name,' + '''' + '(-îå)' + '''' + ',' + '''' + '''' + '))||' + '''' + DefaultExt + '''' +  
               'from tbl_material m, tbl_material_binding mb, tbl_well w, tbl_area_dict a ' +
               'where m.material_type_id in (:MATERIAL_TYPES_ID) and m.material_id = mb.material_id and mb.object_bind_type_id = 1 ' +
               'and w.area_id = a.area_id and mb.object_bind_id = w.well_uin ' +
               'and mb.object_bind_id = %s';
end;

procedure TDMFileInfoGroup.InternalRetrieveObjectInfo(AObject: TIDObject;
  ADestinationPath: string = ''; AObjectList: TIDObjects = nil);
begin
  inherited;

end;

function TDMFileInfoGroup.PrepareTestQuery: string;
begin
  Result := inherited PrepareTestQuery;
  Result := StringReplace(Result, ':DOC_TYPE_NAME', DocTypeName, [rfReplaceAll]);
  Result := StringReplace(Result, ':MATERIAL_TYPES_ID', DocumentTypes.IDList(','), [rfReplaceAll]);
end;

{ TCoreDescriptionFileInfoGroup }

procedure TCoreDescriptionFileInfoGroup.InitializeInfoGroup;
begin
  DefaultExt := '.doc';

  inherited;
  Name := 'Îïèñàíèå êåğíà';
  Tag := 'Îïèñàíèå êåğíà';
  Place := 'Äîêóìåíòû è ìàòåğèàëû';

  DocTypeName := 'Îïèñàíèå êåğíà';
  DocumentTypes.Add(TMainFacade.GetInstance.DocumentTypes.ItemsByID[19], False, False);
  DocumentTypes.Add(TMainFacade.GetInstance.DocumentTypes.ItemsByID[39], False, False);
  DocumentTypes.Add(TMainFacade.GetInstance.DocumentTypes.ItemsByID[57], False, False);
  DocumentTypes.Add(TMainFacade.GetInstance.DocumentTypes.ItemsByID[58], False, False);
end;

{ TInclinometrFileInfoGroup }

procedure TInclinometrFileInfoGroup.InitializeInfoGroup;
begin
  inherited;
  Name := 'Äàííûå èíêëèíîìåòğèè';
  Tag := 'Äàííûå èíêëèíîìåòğèè';
  Place := 'Äîêóìåíòû è ìàòåğèàëû';
  DefaultExt := '.jpg';

  TestQuery := 'select m.vch_location, rf_trim(rf_strreplace(' + 'mt.vch_material_type_name||' + '''' + ' ' + '''' + '||w.vch_well_num||' + '''' + ' - ' + '''' + '||a.vch_area_name,' + '''' + '(-îå)' + '''' + ',' + '''' + '''' + '))||' + '''' + DefaultExt + '''' + ',' +
               'm.vch_location ' +
               'from tbl_material m, tbl_material_binding mb, tbl_well w, tbl_area_dict a, tbl_material_type mt ' +
               'where m.material_type_id in (:MATERIAL_TYPES_ID) and m.material_id = mb.material_id and mb.object_bind_type_id = 1 ' +
               'and w.area_id = a.area_id and mb.object_bind_id = w.well_uin ' +
               'and m.Material_type_id = mt.Material_Type_Id ' +
               'and mb.object_bind_id = %s';

  DocTypeName := 'Äàííûå èíêëèíîìåòğèè';
  DocumentTypes.Add(TMainFacade.GetInstance.DocumentTypes.ItemsByID[60], False, False);
  DocumentTypes.Add(TMainFacade.GetInstance.DocumentTypes.ItemsByID[61], False, False);
  DocumentTypes.Add(TMainFacade.GetInstance.DocumentTypes.ItemsByID[62], False, False);
end;

{ TGranulometryReportInfoGroup }

procedure TGranulometryReportInfoGroup.InitializeInfoGroup;
begin
  inherited;
  TestQuery := 'select * from tbl_dnr_research d, tbl_rock_sample rs, tbl_slotting s where d.rock_sample_uin = rs.rock_sample_uin and s.slotting_uin = rs.slotting_uin and d.research_id >= 300 and d.research_id < 400 and s.Well_UIN = %s';
  Name := 'Ãğàíóëîìåòğè÷åñêèé ñîñòàâ ïîğîä';
  Tag := 'Ïåòğîôèçèêà';
  Place := 'ĞÁÖÃÈ';
  ReportClass := TGranulometryReport;
end;

{ TCentrifugingReportInfoGroup }

procedure TCentrifugingReportInfoGroup.InitializeInfoGroup;
begin
  inherited;
  TestQuery := 'select * from tbl_dnr_research d, tbl_rock_sample rs, tbl_slotting s where d.rock_sample_uin = rs.rock_sample_uin and s.slotting_uin = rs.slotting_uin and d.research_id >= 200 and d.research_id < 300 and s.Well_UIN = %s';
  Name := 'Öåíòğèôóãèğîâàíèå';
  Tag := 'Ïåòğîôèçèêà';
  Place := 'ĞÁÖÃÈ';
  ReportClass := TCentrifugingReport;
end;

{ TDMPetrofisicsFileInfoGroup }

function TDMPetrofisicsFileInfoGroup.GetUserFolderName: string;
begin
  Result := Tag;
end;

procedure TDMPetrofisicsFileInfoGroup.InitializeInfoGroup;
begin
  inherited;
  Name := 'Ïåòğîôèçè÷åñêèå èññëåäîâàíèÿ ïğîøëûõ ëåò';
  Tag := 'Ïåòğîôèçèêà';
  Place := 'Äîêóìåíòû è ìàòåğèàëû';
  DefaultExt := '.xls';

  TestQuery := 'select m.vch_location, rf_trim(rf_strreplace(' + 'mt.vch_material_type_name||' + '''' + ' ' + '''' + '||w.vch_well_num||' + '''' + ' - ' + '''' + '||a.vch_area_name,' + '''' + '(-îå)' + '''' + ',' + '''' + '''' + '))||' + '''' + DefaultExt + '''' + ',' +
               'm.vch_location ' +
               'from tbl_material m, tbl_material_binding mb, tbl_well w, tbl_area_dict a, tbl_material_type mt ' +
               'where m.material_type_id in (:MATERIAL_TYPES_ID) and m.material_id = mb.material_id and mb.object_bind_type_id = 1 ' +
               'and w.area_id = a.area_id and mb.object_bind_id = w.well_uin ' +
               'and m.Material_type_id = mt.Material_Type_Id ' +
               'and mb.object_bind_id = %s';

  DocTypeName := 'Ïåòğîôèçè÷åñêèå èññëåäîâàíèÿ ïğîøëûõ ëåò';
  DocumentTypes.Add(TMainFacade.GetInstance.DocumentTypes.ItemsByID[32], False, False);
  DocumentTypes.Add(TMainFacade.GetInstance.DocumentTypes.ItemsByID[63], False, False);
  DocumentTypes.Add(TMainFacade.GetInstance.DocumentTypes.ItemsByID[64], False, False);
  DocumentTypes.Add(TMainFacade.GetInstance.DocumentTypes.ItemsByID[65], False, False);  
end;

{ TStLasFileInfoGroup }

procedure TStLasFileInfoGroup.InitializeInfoGroup;
begin
  inherited;
  TestQuery := 'select distinct lf.vch_filename, lf.vch_old_filename from tbl_las_file lf, tbl_las_curve lc, tbl_curve_dict cc where cc.curve_id = lc.curve_id and lf.las_file_uin = lc.las_file_uin and cc.curve_category_id in (5,9,10,17,18,19) and lf.well_uin = %s';

  Name := 'Ñòàíäàğòíûé êàğîòàæ';
  CropCurves := True;
  Encoding := encAnsi;

  CurvesToLeave.Add('DEPT');
  CurvesToLeave.Add('DEPTH');
  CurvesToLeave.Add('1ÏĞ');
  CurvesToLeave.Add('2ÏĞ');
  CurvesToLeave.Add('A04M01N');
  CurvesToLeave.Add('A05M8N');
  CurvesToLeave.Add('A1M01N');
  CurvesToLeave.Add('A1M05N');
  CurvesToLeave.Add('A2M05N');
  CurvesToLeave.Add('A4M05N');
  CurvesToLeave.Add('A8M01N');
  CurvesToLeave.Add('A8M10N');
  CurvesToLeave.Add('A8M1N');
  CurvesToLeave.Add('BS');
  CurvesToLeave.Add('CAL');
  CurvesToLeave.Add('CAL1');
  CurvesToLeave.Add('CAL2');
  CurvesToLeave.Add('CALI');
  CurvesToLeave.Add('DS');
  CurvesToLeave.Add('DS1');
  CurvesToLeave.Add('DS2');
  CurvesToLeave.Add('DS_m');
  CurvesToLeave.Add('DSn');
  CurvesToLeave.Add('Dn');
  CurvesToLeave.Add('Dn_m');
  CurvesToLeave.Add('EL07');
  CurvesToLeave.Add('EN20');
  CurvesToLeave.Add('GZ');
  CurvesToLeave.Add('GZ1');
  CurvesToLeave.Add('GZ2');
  CurvesToLeave.Add('GZ3');
  CurvesToLeave.Add('GZ4');
  CurvesToLeave.Add('GZ5');
  CurvesToLeave.Add('GZ6');
  CurvesToLeave.Add('GZK');
  CurvesToLeave.Add('KC4');
  CurvesToLeave.Add('LES1');
  CurvesToLeave.Add('N05M2A');
  CurvesToLeave.Add('N11.0M0.5A');
  CurvesToLeave.Add('N11.0Ì0,5À');
  CurvesToLeave.Add('N11M05A');
  CurvesToLeave.Add('N6M05A');
  CurvesToLeave.Add('PR1');
  CurvesToLeave.Add('PR2');
  CurvesToLeave.Add('PS');
  CurvesToLeave.Add('PZ');
  CurvesToLeave.Add('PZ1');
  CurvesToLeave.Add('PZ3');
  CurvesToLeave.Add('PZ5');
  CurvesToLeave.Add('PZ6');
  CurvesToLeave.Add('R1ñêâ');
  CurvesToLeave.Add('R2ñêâ');
  CurvesToLeave.Add('R3ñêâ');
  CurvesToLeave.Add('R4ñêâ');
  CurvesToLeave.Add('Rñêâ1');
  CurvesToLeave.Add('Rñêâ2');
  CurvesToLeave.Add('Rñêâ3');
  CurvesToLeave.Add('Rñêâ4');
  CurvesToLeave.Add('SP');
  CurvesToLeave.Add('SPèñõ');
  CurvesToLeave.Add('pz');
  CurvesToLeave.Add('ÃÇ');
  CurvesToLeave.Add('ÄÑ');
  CurvesToLeave.Add('ÄÑ  ñâ1');
  CurvesToLeave.Add('ÄÑ  ñâ2');
  CurvesToLeave.Add('ÄÑ  ñâ3');
  CurvesToLeave.Add('ÄÑ1');
  CurvesToLeave.Add('ÄÑ2');
  CurvesToLeave.Add('ÄÑ3');
  CurvesToLeave.Add('ÄÑ_1');
  CurvesToLeave.Add('ÄÑ_2');
  CurvesToLeave.Add('ÄÑÍ');
  CurvesToLeave.Add('ÄÑí');
  CurvesToLeave.Add('ÄÑí  ñâ1');
  CurvesToLeave.Add('ÄÑí ñâ2');
  CurvesToLeave.Add('ÄÑí1');
  CurvesToLeave.Add('ÄÑí2');
  CurvesToLeave.Add('ÄÑíîì');
  CurvesToLeave.Add('Äñ1');
  CurvesToLeave.Add('Äñ2');
  CurvesToLeave.Add('ÊÀÂ');
  CurvesToLeave.Add('ÊÂ');
  CurvesToLeave.Add('ÊÂ1');
  CurvesToLeave.Add('ÊÂ2');
  CurvesToLeave.Add('ÊÂ3');
  CurvesToLeave.Add('ÊÑ1');
  CurvesToLeave.Add('ÊÑ2');
  CurvesToLeave.Add('ÊÑ2Âğ1');
  CurvesToLeave.Add('ÊÑ2Âğ2');
  CurvesToLeave.Add('ÊÑ2Âğ3');
  CurvesToLeave.Add('ÊÑ3');
  CurvesToLeave.Add('ÊÑ3Âğ1');
  CurvesToLeave.Add('ÊÑ3Âğ2');
  CurvesToLeave.Add('ÊÑ3Âğ3');
  CurvesToLeave.Add('ÊÑ3Âğ4');
  CurvesToLeave.Add('ÊÑ4');
  CurvesToLeave.Add('ÊÑ4_1');
  CurvesToLeave.Add('ÊÑ5');
  CurvesToLeave.Add('ÊÑ5   ñâ1');
  CurvesToLeave.Add('ÊÑ5  ñâ2');
  CurvesToLeave.Add('ÊÑ5  ñâ3');
  CurvesToLeave.Add('ÊÑ6');
  CurvesToLeave.Add('ÊÑ7');
  CurvesToLeave.Add('ÊÑ8');
  CurvesToLeave.Add('ÊÑ8ê');
  CurvesToLeave.Add('ÊÑ?');
  CurvesToLeave.Add('ÏÇ');
  CurvesToLeave.Add('ÏÇ ñâ1');
  CurvesToLeave.Add('ÏÇ ñâ2');
  CurvesToLeave.Add('ÏÇ ñâ3');
  CurvesToLeave.Add('ÏÇ1');
  CurvesToLeave.Add('ÏÇ2');
  CurvesToLeave.Add('ÏĞ1');
  CurvesToLeave.Add('ÏĞ2');
  CurvesToLeave.Add('ÏÑ');
  CurvesToLeave.Add('ÏÑ ñâ1');
  CurvesToLeave.Add('ÏÑ ñâ2');
  CurvesToLeave.Add('ÏÑ ñâ3');
  CurvesToLeave.Add('ÏÑ1');
  CurvesToLeave.Add('ÏÑñï');

  Replacements := TLasReplacements.Create;

  ////2-------- ıòî äëÿ òàêîãî ñëó÷àÿ:   WeLL.     WELL:5----------------//
  {
  Replacements.AddReplacement('~Well', 'WELL', '   WELL:2', '2_Saluk: ');
  Replacements.AddReplacement('~Well', 'FLD', 'FIELD:Ñàëşêèíñêàÿ (-îå)', '     :                 ');
  }


  Replacements.AddReplacement('~Well', 'WELL', '        91', '91_Yareyag');
  Replacements.AddReplacement('~Well', 'FLD', 'ßğåéÿãèíñêàÿ', '            ');


  Replacements.AddReplacement('~Curve','À','À','A');
  Replacements.AddReplacement('~Curve','Á','Á','B');
  Replacements.AddReplacement('~Curve','Â','Â','V');
  Replacements.AddReplacement('~Curve','Ã','Ã','G');
  Replacements.AddReplacement('~Curve','Ä','Ä','D');
  Replacements.AddReplacement('~Curve','Å','Å','E');
  Replacements.AddReplacement('~Curve','Æ','Æ','J');
  Replacements.AddReplacement('~Curve','Ç','Ç','Z');
  Replacements.AddReplacement('~Curve','È','È','I');
  Replacements.AddReplacement('~Curve','Ê','Ê','K');
  Replacements.AddReplacement('~Curve','Ë','Ë','L');
  Replacements.AddReplacement('~Curve','Ì','Ì','M');
  Replacements.AddReplacement('~Curve','Í','Í','N');
  Replacements.AddReplacement('~Curve','Î','Î','O');
  Replacements.AddReplacement('~Curve','Ï','Ï','P');
  Replacements.AddReplacement('~Curve','Ğ','Ğ','R');
  Replacements.AddReplacement('~Curve','Ñ','Ñ','S');
  Replacements.AddReplacement('~Curve','Ò','Ò','T');
  Replacements.AddReplacement('~Curve','Ó','Ó','U');
  Replacements.AddReplacement('~Curve','Ô','Ô','F');
  Replacements.AddReplacement('~Curve','Õ','Õ','H');
  Replacements.AddReplacement('~Curve','Ö','Ö','C');
  Replacements.AddReplacement('~Curve','×','×','Ch');
  Replacements.AddReplacement('~Curve','Ø','Ø','Sh');
  Replacements.AddReplacement('~Curve','Ù','Ù','Sch');
  Replacements.AddReplacement('~Curve','İ','İ','A');
  Replacements.AddReplacement('~Curve','Ş','Ş','U');
  Replacements.AddReplacement('~Curve','ß','ß','Ya');
end;

{ TAKLasFileInfoGroup }

procedure TAKLasFileInfoGroup.InitializeInfoGroup;
begin
  inherited;
  TestQuery := 'select distinct lf.vch_filename, lf.vch_old_filename from tbl_las_file lf, tbl_las_curve lc, tbl_curve_dict cc where cc.curve_id = lc.curve_id and lf.las_file_uin = lc.las_file_uin and cc.curve_category_id in (2) and lf.well_uin = %s';

  Name := 'Àêóñòè÷åñêèé êàğîòàæ';
  CropCurves := True;

  CurvesToLeave.Add('DEPT');
  CurvesToLeave.Add('DEPTH');

  CurvesToLeave.Add('ÀÊÄÒ');
  CurvesToLeave.Add('ÀÊÒ1');
  CurvesToLeave.Add('ÀÊÒ2');
  CurvesToLeave.Add('ÀËÔ');
  CurvesToLeave.Add('À1');
  CurvesToLeave.Add('À2');
  CurvesToLeave.Add('ÀÊÄÒ');
  CurvesToLeave.Add('ÀÊÄÒ');
  CurvesToLeave.Add('ÀÊÒ1');
  CurvesToLeave.Add('ÀÊT2');
  CurvesToLeave.Add('A2');
  CurvesToLeave.Add('A1');
  CurvesToLeave.Add('A1Lí');
  CurvesToLeave.Add('A2Lí');
  CurvesToLeave.Add('ÀËÔLí');
  CurvesToLeave.Add('Ò1Lí');
  CurvesToLeave.Add('Ò2Lí');
  CurvesToLeave.Add('ÄÒLí');
  CurvesToLeave.Add('A1s');
  CurvesToLeave.Add('A1s');
  CurvesToLeave.Add('A2s');
  CurvesToLeave.Add('ÀËÔsí');
  CurvesToLeave.Add('A1sí');
  CurvesToLeave.Add('A2sí');
  CurvesToLeave.Add('ÄÒsí');
  CurvesToLeave.Add('Ò1sí');
  CurvesToLeave.Add('Ò2sí');
  CurvesToLeave.Add('A1pâ');
  CurvesToLeave.Add('A2pâ');
  CurvesToLeave.Add('ÀËÔğâ');
  CurvesToLeave.Add('ÄÒğâ');
  CurvesToLeave.Add('Ò1ğâ');
  CurvesToLeave.Add('Ò2ğâ');
  CurvesToLeave.Add('Ddol');
  CurvesToLeave.Add('DT');
  CurvesToLeave.Add('ÀÊÄÒ');
  CurvesToLeave.Add('ÄÒ');
  CurvesToLeave.Add('Ò1ğâ');
  CurvesToLeave.Add('BAT1');
  CurvesToLeave.Add('BAT2');
  CurvesToLeave.Add('DTCO');
  CurvesToLeave.Add('ÀÊÄÒ');
  CurvesToLeave.Add('DTL');
  CurvesToLeave.Add('DTLM');
  CurvesToLeave.Add('DTP');
  CurvesToLeave.Add('DTS');
  CurvesToLeave.Add('ÀËÔ2');
  CurvesToLeave.Add('ÀËÔ1');
  CurvesToLeave.Add('ÀÊT1');
  CurvesToLeave.Add('DTP1');
  CurvesToLeave.Add('T1');
  CurvesToLeave.Add('T2');
  CurvesToLeave.Add('ÀÊ');
  CurvesToLeave.Add('ÀÊÄÒ');
  CurvesToLeave.Add('AZT');
  CurvesToLeave.Add('DÒ');
  CurvesToLeave.Add('ÀÊ');
  CurvesToLeave.Add('DT');
  CurvesToLeave.Add('ALFA');

  Replacements := TLasReplacements.Create;
end;

{ TLasReplacements }

constructor TLasReplacements.Create;
begin
  inherited;
  AddReplacement('~Curve','','KC4','GZ4');
  AddReplacement('~Curve','','NGK','NGR');
  AddReplacement('~Curve','','ÍÃÊ','NGR');
  AddReplacement('~Curve','','PS','SP');
  AddReplacement('~Curve','','ÃÃÊÏ','GGRp');
  AddReplacement('~Curve','','ÃÃÊï','GGRp');
  AddReplacement('~Curve','','ÃÊè','GRi');
  AddReplacement('~Curve','','ÃÊ','GR');
  AddReplacement('~Curve','','ÄÑí1','Dn  ');
  AddReplacement('~Curve','','ÄÑí2','Dn  ');
  AddReplacement('~Curve','','ÄÑí','Dn ');
  AddReplacement('~Curve','','ÄÑ','DS');
  AddReplacement('~Curve','','ÊÑ4','GZ4');
  AddReplacement('~Curve','','ÍÍÊÒ','NNKT');
  AddReplacement('~Curve','','ÍÍÒÁ','NNTb');
  AddReplacement('~Curve','','ÍÍÒÌ','NNTm');
  AddReplacement('~Curve','','ÏÇ','PZ');
  AddReplacement('~Curve','','ÏÑ','SP');

  AddReplacement('~Curve','','ã/ñì3','g/cm3');
  AddReplacement('~Curve','','ìêğ/÷àñ','ur/h   ');
  AddReplacement('~Curve','','èìï/ìèí','imp/min');
  AddReplacement('~Curve','','ìì','mm');
  AddReplacement('~Curve','','Îìì','Omm');
  AddReplacement('~Curve','','ó.å.','u.e.');
  AddReplacement('~Curve','','óñ.å','u.e. ');
  AddReplacement('~Curve','','Îìì','Omm');
  AddReplacement('~Curve','','ìÂ','mv');
end;

{ TAllLasFileCopy }

procedure TAllLasFileCopyAnsi.InitializeInfoGroup;
begin
  inherited;
  CropCurves := false;
  MakeReplacements := false;
  CropBlocks := false;
  Encoding := encAnsi;

  TestQuery := 'select distinct lf.vch_filename, lf.vch_old_filename from tbl_las_file lf, tbl_las_curve lc where lf.las_file_uin = lc.las_file_uin and lf.well_uin = %s';

  Name := 'LAS(ANSI)';
end;

{ TAllLasFileCopyAscii }

procedure TAllLasFileCopyAscii.InitializeInfoGroup;
begin
  inherited;
  CropCurves := false;
  MakeReplacements := false;
  CropBlocks := false;
  Encoding := encAscii;

  TestQuery := 'select distinct lf.vch_filename, lf.vch_old_filename from tbl_las_file lf, tbl_las_curve lc where lf.las_file_uin = lc.las_file_uin and lf.well_uin = %s';

  Name := 'LAS(ASCII)';
end;

{ TStandardSubdivisionReport }

procedure TStandardSubdivisionReportInfoGroup.InitializeInfoGroup;
begin
  inherited;
  Name := 'Ñòğàòèãğàôè÷åñêèå ğàçáèâêè';
  Tag := 'Ñòğàòèãğàôèÿ';
  Place := 'ĞÁÖÃÈ';
  TestQuery := 'select * from tbl_subdivision_component sc, tbl_Subdivision s where s.subdivision_id = sc.subdivision_id and  s.well_uin in (%s)';
  IsSingle := True;
  ReportClass := TStandardSubdivisionReport;
end;

{ TSchlifDescriptionFileInfoGroup }

procedure TSchlifDescriptionFileInfoGroup.InitializeInfoGroup;
begin
  DefaultExt := '.doc';

  inherited;
  Name := 'Îïèñàíèå øëèôîâ';
  Tag := 'Îïèñàíèå øëèôîâ';
  Place := 'Äîêóìåíòû è ìàòåğèàëû';

  DocTypeName := 'Îïèñàíèå øëèôîâ';
  DocumentTypes.Add(TMainFacade.GetInstance.DocumentTypes.ItemsByID[38], False, False);
  DocumentTypes.Add(TMainFacade.GetInstance.DocumentTypes.ItemsByID[20], False, False);
  DocumentTypes.Add(TMainFacade.GetInstance.DocumentTypes.ItemsByID[48], False, False);
  DocumentTypes.Add(TMainFacade.GetInstance.DocumentTypes.ItemsByID[51], False, False);
end;

{ TSchlamDescriptionFileInfoGroup }

procedure TSchlamDescriptionFileInfoGroup.InitializeInfoGroup;
begin
  inherited;
  DefaultExt := '.doc';

  inherited;
  Name := 'Îïèñàíèå øëàìà';
  Tag := 'Îïèñàíèå øëàìà';
  Place := 'Îïèñàíèå øëàìà';

  DocTypeName := 'Îïèñàíèå êåğíà';
  DocumentTypes.Add(TMainFacade.GetInstance.DocumentTypes.ItemsByID[34], False, False);
end;

end.
