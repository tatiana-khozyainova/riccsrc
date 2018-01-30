unit SubdivisionComponentPoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, STraton, SubdivisionComponent, Theme, Employee;// SubdivisionComponent;

type

  TSubdivisionDataPoster = class(TImplementedDataPoster)
  private
    FAllThemes: TThemes;
    FAllEmployees: TEmployees;
  public
    property AllThemes: TThemes read FAllThemes write FAllThemes;
    property AllEmployees: TEmployees read FAllEmployees write FAllEmployees;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;override;

    constructor Create; override;
  end;

  TTectonicBlockDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;override;

    constructor Create; override;
  end;

  TSubdivisionCommentDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;override;

    constructor Create; override;
  end;

    TSubdivisionComponentDataPoster = class (TImplementedDataPoster)
  private
    FAllStratons: TSimpleStratons;
    FAllTectonicBlocks: TTectonicBlocks;
    FAllSubdivisionComments: TSubdivisionComments;
    procedure SetAllStratons (const Value: TSimpleStratons);
    procedure SetAllTectonicBlocks (const Value: TTectonicBlocks);
    procedure SetAllSubdivisionComments (const Value: TSubdivisionComments);
  public
    property AllStratons: TSimpleStratons read FAllStratons write SetAllStratons;
    property AllTectonicBlocks: TTectonicBlocks read FAllTectonicBlocks write SetAllTectonicBlocks;
    property AllSubdivisionComments: TSubdivisionComments read FAllSubdivisionComments write SetAllSubdivisionComments;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;override;

    constructor Create;override;
  end;

implementation

uses Facade, SysUtils, Variants, Parameter, BaseFacades;

constructor TTectonicBlockDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_TECTONIC_BLOCK';

  KeyFieldNames := 'BLOCK_ID';
  FieldNames := 'BLOCK_ID, vch_BLOCK_Name, vch_SHORT_BLOCK_NAME, NUM_ORDER';
  AccessoryFieldNames := 'BLOCK_ID, vch_BLOCK_Name, vch_SHORT_BLOCK_NAME, NUM_ORDER';
  AutoFillDates := false;

  Sort := 'vch_BLOCK_NAME';
end;

//---------------------------------------------------------------------------
function TTectonicBlockDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

//----------------------------------------------------------------------------
function TTectonicBlockDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    s: TTectonicBlock;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;
    if Assigned(AObjects) then
    begin
      while not ds.Eof do
      begin
        s := AObjects.Add as TTectonicBlock;

        s.ID := ds.FieldByName('BLOCK_ID').AsInteger;
        s.Name := trim(ds.FieldByName('vch_BLOCK_NAME').AsString);
        s.ShortName := trim(ds.FieldByName('vch_SHORT_BLOCK_NAME').AsString);
        s.Order := ds.FieldByName('NUM_ORDER').AsInteger;

        ds.Next;
      end;

      ds.First;
    end;
  end;
end;

//--------------------------------------------------------------------------
function TTectonicBLockDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    s: TTectonicBLock;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  s := AObject as TTectonicBlock;

  ds.FieldByName('BLOCK_ID').AsInteger := s.ID;
  ds.FieldByName('vch_BLOCK_NAME').AsString := trim(s.Name);
  ds.FieldByName('vch_SHORT_BLOCK_NAME').AsString := trim(s.ShortName);
  ds.FieldByName('NUM_ORDER').AsInteger := s.Order;


  ds.Post;

  if s.ID <= 0 then
    s.ID := ds.FieldByName('BLOCK_ID').AsInteger;
end;


{ TSubdivisionCommentDataPoster }

constructor TSubdivisionCommentDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_SUBDIVISION_COMMENT';

  KeyFieldNames := 'COMMENT_ID';
  FieldNames := 'COMMENT_ID, vch_SUBDIVISION_COMMENT, vch_SHORT_SUBDIVISION_COMMENT';
  AccessoryFieldNames := 'COMMENT_ID, vch_SUBDIVISION_COMMENT, vch_SHORT_SUBDIVISION_COMMENT';
  AutoFillDates := false;

  Sort := 'vch_SUBDIVISION_COMMENT';
end;

function TSubdivisionCommentDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TSubdivisionCommentDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    sc: TSubdivisionComment;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;
    if Assigned(AObjects) then
    begin
      while not ds.Eof do
      begin
        sc := AObjects.Add as TSubdivisionComment;

        sc.ID := ds.FieldByName('COMMENT_ID').AsInteger;
        sc.Name := trim(ds.FieldByName('vch_SUBDIVISION_COMMENT').AsString);
        sc.ShortName := trim(ds.FieldByName('vch_SHORT_SUBDIVISION_COMMENT').AsString);

        ds.Next;
      end;

      ds.First;
    end;
  end;

end;

function TSubdivisionCommentDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    sc: TSubdivisionComment;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  sc := AObject as TSubdivisionComment;

  ds.FieldByName('COMMENT_ID').AsInteger := sc.ID;
  ds.FieldByName('vch_SUBDIVISION_COMMENT').AsString := trim(sc.Name);
  ds.FieldByName('vch_SHORT_SUBDIVISION_COMMENT').AsString := trim(sc.ShortName);

  ds.Post;

  if sc.ID <= 0 then
    sc.ID := ds.FieldByName('COMMENT_ID').AsInteger;

end;

{ TSubdivisionComponentDataPoster }

constructor TSubdivisionComponentDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource];
  DataSourceString := 'TBL_SUBDIVISION_COMPONENT';

  KeyFieldNames := 'STRATON_ID; SUBDIVISION_ID; BLOCK_ID; NEXT_STRATON_ID';
  FieldNames := 'STRATON_ID, SUBDIVISION_ID, BLOCK_ID, NEXT_STRATON_ID, EDGE_COMMENT_ID, COMMENT_ID, NUM_DEPTH, NUM_VERIFIED';
  AccessoryFieldNames := 'STRATON_ID, SUBDIVISION_ID, BLOCK_ID, NEXT_STRATON_ID, EDGE_COMMENT_ID, COMMENT_ID, NUM_DEPTH, NUM_VERIFIED';
  AutoFillDates := false;

  Sort := 'NUM_DEPTH';

end;

function TSubdivisionComponentDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    sc: TSubdivisionComponent;
    iBlockID, iNextStratonID: Integer;
begin
  Assert(DataDeletionString <> '', 'Не задан приемник данных ' + ClassName);
  Result := 0;
  try
    ds := TMainFacade.GetInstance.DBGates.Add(Self);
    sc := AObject as TSubdivisionComponent;

    if not ds.Active then
      ds.Open;


    if Assigned(sc.Block) then iBlockID := sc.Block.ID
    else iBlockID := 0;

    if Assigned(sc.NextStraton) then iNextStratonID := sc.NextStraton.ID
    else iNextStratonID := 0;

    if ds.Locate(KeyFieldNames, VarArrayOf([sc.Straton.ID, sc.Owner.ID, iBlockID, iNextStratonID]), []) then
      ds.Delete
  except
    Result := -1;
  end;
end;

function TSubdivisionComponentDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    sc: TSubdivisionComponent;
begin
  Assert(Assigned(AllStratons), 'Не задана коллекция стратонов');
  Assert(Assigned(AllTectonicBlocks), 'Не задана коллекция тектонических блоков');
  Assert(Assigned(AllSubdivisionComments), 'Не задана коллекция комментариев глубин');

  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;
    if Assigned(AObjects) then
    begin
      while not ds.Eof do
      begin
        sc := AObjects.Add as TSubdivisionComponent;

        sc.Straton := AllStratons.ItemsByID[ds.FieldByName('STRATON_ID').AsInteger] as TSimpleStraton;

        sc.Block := AllTectonicBlocks.ItemsByID[ds.FieldByName('BLOCK_ID').AsInteger] as TTectonicBlock;

        sc.NextStraton := AllStratons.ItemsByID[ds.FieldByName('NEXT_STRATON_ID').AsInteger] as TSimpleStraton;
        sc.Comment := AllSubdivisionComments.ItemsByID[ds.FieldByName('COMMENT_ID').AsInteger] as TSubdivisionComment;
        sc.Depth := ds.FieldByName('NUM_DEPTH').AsFloat;
        sc.Verified := ds.FieldByName('NUM_VERIFIED').AsInteger;

        ds.Next;
      end;

      ds.First;
    end;
  end;
end;

function TSubdivisionComponentDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    sc: TSubdivisionComponent;
    iBlockID, iNextStratonID: Integer;
begin
  Assert(DataPostString <> '', 'Не задан приемник данных ' + ClassName);
  Result := 0;
  try
    ds := TMainFacade.GetInstance.DBGates.Add(Self);
    sc := AObject as TSubdivisionComponent;

    if not ds.Active then
      ds.Open;


    if Assigned(sc.Block) then iBlockID := sc.Block.ID
    else iBlockID := 0;

    if Assigned(sc.NextStraton) then iNextStratonID := sc.NextStraton.ID
    else iNextStratonID := 0;

    if ds.Locate(KeyFieldNames, VarArrayOf([sc.Straton.ID, sc.Owner.ID, iBlockID, iNextStratonID]), []) then
      ds.Edit
    else ds.Append;
  except
  on E: Exception do
    begin
      raise;
    end;
  end;


  ds.FieldByName('STRATON_ID').Value := sc.Straton.ID;
  ds.FieldByName('BLOCK_ID').Value := iBlockID;
  if Assigned(sc.NextStraton) then
    ds.FieldByName('NEXT_STRATON_ID').Value := sc.NextStraton.ID
  else
    ds.FieldByName('NEXT_STRATON_ID').Value := 0;

  if Assigned(sc.Comment) then
    ds.FieldByName('COMMENT_ID').Value := sc.Comment.ID
  else
    ds.FieldByName('COMMENT_ID').Value := 0;

  ds.FieldByName('NUM_DEPTH').Value := sc.Depth;
  ds.FieldByName('NUM_VERIFIED').Value := sc.Verified;
  ds.FieldByName('SUBDIVISION_ID').Value := sc.Owner.ID;
  ds.FieldByName('EDGE_COMMENT_ID').Value := 0;



  ds.Post;
  sc.ID := sc.Straton.ID;
end;

procedure TSubdivisionComponentDataPoster.SetAllStratons(
  const Value: TSimpleStratons);
begin
  if FAllStratons <> Value then
    FAllStratons := Value;

end;

procedure TSubdivisionComponentDataPoster.SetAllSubdivisionComments(
  const Value: TSubdivisionComments);
begin
  if FAllSubdivisionComments <> Value then
    FAllSubdivisionComments := Value;
end;

procedure TSubdivisionComponentDataPoster.SetAllTectonicBlocks(
  const Value: TTectonicBlocks);
begin
  if FAllTectonicBlocks <> Value then
    FAllTectonicBlocks := Value;
end;

{ TSubdivisionDataPoster }

constructor TSubdivisionDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_SUBDIVISION';

  KeyFieldNames := 'SUBDIVISION_ID';
  FieldNames := 'SUBDIVISION_ID, WELL_UIN, THEME_ID, DTM_ENTERING_DATE, DTM_MODIFYING_DATE, DTM_SIGNING_DATE, SIGNED_BY_EMPLOYEE_ID, EMPLOYEE_ID, MODIFIER_ID';
  AccessoryFieldNames := 'SUBDIVISION_ID, WELL_UIN, THEME_ID, DTM_ENTERING_DATE, DTM_MODIFYING_DATE, DTM_SIGNING_DATE, SIGNED_BY_EMPLOYEE_ID, EMPLOYEE_ID, MODIFIER_ID';
  Sort := 'SUBDIVISION_ID';
end;

function TSubdivisionDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TSubdivisionDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    s: TSubdivision;
begin
  Assert(Assigned(AllThemes), 'Не задана коллекция тем');

  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;
    if Assigned(AObjects) then
    begin
      while not ds.Eof do
      begin
        s := AObjects.Add as TSubdivision;

        s.ID := ds.FieldByName('SUBDIVISION_ID').AsInteger;
        s.Theme := AllThemes.ItemsByID[ds.FieldByName('Theme_ID').AsInteger] as TTheme;
        s.SingingDate := ds.FieldByName('DTM_SIGNING_DATE').AsDateTime;
        s.SigningEmployee := AllEmployees.ItemsByID[ds.FieldByName('SIGNED_BY_EMPLOYEE_ID').AsInteger] as TEmployee;

        ds.Next;
      end;

      ds.First;
    end;
  end;
end;

function TSubdivisionDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    s: TSubdivision;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  s := AObject as TSubdivision;

  ds.FieldByName('Subdivision_ID').AsInteger := s.ID;
  ds.FieldByName('WELL_UIN').AsInteger := s.Owner.ID;
  ds.FieldByName('DTM_SIGNING_DATE').AsString := DateToStr(s.SingingDate);
  ds.FieldByName('SIGNED_BY_EMPLOYEE_ID').AsInteger := s.SigningEmployee.ID;
  ds.FieldByName('THEME_ID').AsInteger := s.Theme.ID;

  if s.ID = 0 then
  begin
    ds.FieldByName('DTM_Entering_DATE').AsString := DateToStr(Now);
    ds.FieldByName('DTM_MODIFYING_DATE').AsString := DateToStr(Now);
    ds.FieldByName('EMPLOYEE_ID').AsInteger := TMainFacade.GetInstance.DBGates.EmployeeID;
    ds.FieldByName('MODIFIER_ID').AsInteger := TMainFacade.GetInstance.DBGates.EmployeeID;
  end
  else
  begin
    ds.FieldByName('DTM_MODIFYING_DATE').AsString := DateToStr(Now);
    ds.FieldByName('MODIFIER_ID').AsInteger := TMainFacade.GetInstance.DBGates.EmployeeID;
  end;

  ds.Post;

  if s.ID <= 0 then
    s.ID := ds.FieldByName('SUBDIVISION_ID').AsInteger;
end;

end.
