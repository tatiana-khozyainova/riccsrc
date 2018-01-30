unit CoreDescriptionPoster;

interface

uses PersistentObjects, DBGate, BaseObjects, DB, Slotting, SlottingPoster,
     Variants, Windows, Dialogs, Lithology, CoreDescription, Employee;

type
  TDescriptionFileDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TLithologyDescrDataPoster = class(TImplementedDataPoster)
  private
    FAllLithologies: TLithologies;
    procedure SetAllLithologies(const Value: TLithologies);
  public
    property AllLithologies: TLithologies read FAllLithologies write SetAllLithologies;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;

    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function PostToDB(ACollection: TIDObjects; AOwner: TIDObject): integer; overload; override;

    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TAuthorDataPoster = class(TImplementedDataPoster)
  private
    FAllEmployee: TEmployees;
    procedure SetAllEmployee(const Value: TEmployees);
  public
    property AllEmployee: TEmployees read FAllEmployee write SetAllEmployee;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;

    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function PostToDB(ACollection: TIDObjects; AOwner: TIDObject): integer; overload; override;

    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TDescriptionDataPoster = class(TImplementedDataPoster)
  private
    FActiveWell: TDescriptedWell;
    FActiveSlotting: TSlotting;
    procedure SetActiveWell(const Value: TDescriptedWell);
    procedure SetActiveSlotting(const Value: TSlotting);
  public
    property ActiveWell: TDescriptedWell read FActiveWell write SetActiveWell;
    property ActiveSlotting: TSlotting read FActiveSlotting write SetActiveSlotting;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TListWordsDataPoster = class(TImplementedDataPoster)
  private
    FAllWords: TDictionaryWords;
    procedure SetAllWords(const Value: TDictionaryWords);
  public
    property AllWords: TDictionaryWords read FAllWords write SetAllWords;
    
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;

    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function PostToDB(ACollection: TIDObjects; AOwner: TIDObject): integer; overload; override;

    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TDictionaryDataPoster = class(TImplementedDataPoster)
  public
    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TRootDataPoster = class(TImplementedDataPoster)
  private
    FAllDicts: TDictionaries;
    procedure SetAllDicts(const Value: TDictionaries);
  public
    property AllDicts: TDictionaries read FAllDicts write SetAllDicts;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TWordDataPoster = class(TImplementedDataPoster)
  private
    FAllRoots: TRoots;
    procedure SetAllRoots(const Value: TRoots);
  public
    property AllRoots: TRoots read FAllRoots write SetAllRoots;

    function GetFromDB(AFilter: string; AObjects: TIdObjects): integer; override;
    function PostToDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;
    function DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer; override;

    constructor Create; override;
  end;

  TDescriptedSlottingDataPoster = class(TSlottingDataPoster)
  public
    constructor Create; override;
  end;
  

implementation

uses Facade, SysUtils, Classes, Graphics;



{ TWordDataPoster }

constructor TWordDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_WORD_KERN_DICT';
  //DataPostString := 'SPD_ADD_WORD';
  //DataDeletionString :=  'SPD_DELETE_WORD_DICT';

  KeyFieldNames := 'KERN_VALUE_ID';
  FieldNames := 'KERN_VALUE_ID, VCH_KERN_VALUE_NAME, ROOT_ID, VCH_KERN_COMMENT';

  AccessoryFieldNames := 'KERN_VALUE_ID, VCH_KERN_VALUE_NAME, ROOT_ID, VCH_KERN_COMMENT';
  AutoFillDates := false;

  Sort := 'VCH_KERN_VALUE_NAME';
end;

function TWordDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TWordDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TDictionaryWord;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TDictionaryWord;

      o.ID := ds.FieldByName('KERN_VALUE_ID').AsInteger;
      o.Name := AnsiLowerCase(trim(ds.FieldByName('VCH_KERN_VALUE_NAME').AsString));
      o.Comment := trim(ds.FieldByName('VCH_KERN_COMMENT').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TWordDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TDictionaryWord;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TDictionaryWord;

  if ds.Locate('KERN_VALUE_ID', o.ID, []) then
    ds.Edit
  else ds.Append;

  ds.FieldByName('KERN_VALUE_ID').Value := o.ID;
  ds.FieldByName('VCH_KERN_VALUE_NAME').Value := trim(o.Name);
  ds.FieldByName('ROOT_ID').Value := o.Owner.ID;
  ds.FieldByName('VCH_KERN_COMMENT').Value := o.Comment;

  ds.Post;

  o.ID := ds.FieldByName('KERN_VALUE_ID').Value;
end;



procedure TWordDataPoster.SetAllRoots(const Value: TRoots);
begin
  if FAllRoots <> Value then
    FAllRoots := Value;
end;

{ TDictionaryDataPoster }

constructor TDictionaryDataPoster.Create;
begin
  inherited;
  Options := [soKeyInsert];
  DataSourceString := 'TBL_DICTS_WORDS_DICT';
  DataPostString := 'SPD_ADD_KERN_DICT';
  DataDeletionString := 'TBL_DICTS_WORDS_DICT';

  KeyFieldNames := 'DESCRIPTION_KERN_ID';
  FieldNames := 'DESCRIPTION_KERN_ID, VCH_DESCRIPTION_KERN_NAME';

  AccessoryFieldNames := '';
  AutoFillDates := false;

  Sort := 'VCH_DESCRIPTION_KERN_NAME';
end;

function TDictionaryDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := -1;
  if (AObject as TDictionary).Roots.Count = 0 then
    Result := inherited DeleteFromDB(AObject, ACollection)
end;

function TDictionaryDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TDictionary;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TDictionary;

      o.ID := ds.FieldByName('DESCRIPTION_KERN_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_DESCRIPTION_KERN_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TDictionaryDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TDictionary;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TDictionary;

  ds.FieldByName('DESCRIPTION_KERN_ID').Value := o.ID;
  ds.FieldByName('VCH_DESCRIPTION_KERN_NAME').Value := trim(o.Name);

  ds.Post;

  o.ID := ds.FieldByName('DESCRIPTION_KERN_ID').AsInteger;
end;

{ TDescriptionDataPoster }

constructor TDescriptionDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_DESCRIPTION_KERN';

  KeyFieldNames := 'DESCRIPTION_ID';
  FieldNames := 'DESCRIPTION_ID, DESCRIPTION_TEXT, DTM_DATE_CREATION, SLOTTING_UIN, LAYER_SLOTTING_ID';

  AccessoryFieldNames := 'DESCRIPTION_ID, DESCRIPTION_TEXT, DTM_DATE_CREATION, SLOTTING_UIN, LAYER_SLOTTING_ID';
  AutoFillDates := false;

  Sort := 'DESCRIPTION_ID';
end;

function TDescriptionDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TDescriptionDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TDescription;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then                     
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TDescription;

      o.ID := ds.FieldByName('DESCRIPTION_ID').AsInteger;
      o.AllText := ds.FieldByName('DESCRIPTION_TEXT').AsVariant;

      o.DateCreate := ds.FieldByName('DTM_DATE_CREATION').AsDateTime;
      if ds.FieldByName('SLOTTING_UIN').AsInteger <> null then
        o.Slotting := TSlotting(ActiveWell.Slottings.ItemsByID[ds.FieldByName('SLOTTING_UIN').AsInteger]);
      if Assigned (ActiveSlotting) then
        o.LayerSlotting := TDescriptedLayer(ActiveSlotting.LayerSlottings.ItemsByID[ds.FieldByName('LAYER_SLOTTING_ID').AsInteger]);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TDescriptionDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TDescription;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TDescription;

  if ds.Locate('DESCRIPTION_ID', o.ID, []) then
    ds.Edit
  else ds.Append;

  ds.FieldByName('DESCRIPTION_ID').Value := o.ID;
  ds.FieldByName('DESCRIPTION_TEXT').Value := o.AllText;
  ds.FieldByName('DTM_DATE_CREATION').Value := o.DateCreate;
  ds.FieldByName('SLOTTING_UIN').Value := o.LayerSlotting.Collection.Owner.ID;
  ds.FieldByName('LAYER_SLOTTING_ID').Value := o.LayerSlotting.ID;

  ds.Post;

  if o.ID = 0 then o.ID := ds.FieldByName('DESCRIPTION_ID').AsInteger;

  o.Words.Owner := o;
  o.Words.Update(o.Words);//Poster.PostToDB(o.Words, o);

  o.Authors.Owner := o;
  o.Authors.Update(o.Authors);//Poster.PostToDB(o.Authors, o);

  o.Lithologies.Owner := o;
  o.Lithologies.Update(o.Lithologies); //Poster.PostToDB(o.Lithologies, o);
end;


{ TDescriptedSlottingPoster }

constructor TDescriptedSlottingDataPoster.Create;
begin
  inherited;

end;



procedure TDescriptionDataPoster.SetActiveSlotting(
  const Value: TSlotting);
begin
  if FActiveSlotting <> Value then
    FActiveSlotting := Value;
end;

procedure TDescriptionDataPoster.SetActiveWell(
  const Value: TDescriptedWell);
begin
  if FActiveWell <> Value then
    FActiveWell := Value;
end;

{ TListWordsDataPoster }

constructor TListWordsDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource];
  DataSourceString := 'TBL_LIST_WORDS';

  KeyFieldNames := 'DESCRIPTION_ID; KERN_VALUE_ID; INT_NUMBER_PP';
  FieldNames := 'DESCRIPTION_ID, KERN_VALUE_ID, INT_NUMBER_PP';

  AccessoryFieldNames := 'DESCRIPTION_ID, KERN_VALUE_ID, INT_NUMBER_PP';
  AutoFillDates := false;

  Sort := 'DESCRIPTION_ID, INT_NUMBER_PP';
end;

function TListWordsDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TListWordsDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TListWord;
    oSourse: TDictionaryWord;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      try
        oSourse := AllWords.ItemsByID[ds.FieldByName('KERN_VALUE_ID').AsInteger] as TDictionaryWord;

        if Assigned (oSourse) then
        begin
          o := AObjects.Add as TListWord;

          o.Assign(oSourse);

          if Assigned (oSourse.Owner) then
            o.Root := oSourse.Owner as TRoot;

          o.SelStart := ds.FieldByName('INT_NUMBER_PP').AsInteger;

          AObjects.Add(o, false, false);
        end;  
      except

      end;

      ds.Next;
    end;

    ds.First;
  end;
end;

function TListWordsDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TListWord;
begin
  Result := 0;
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TListWord;

  if ds.Locate('DESCRIPTION_ID; KERN_VALUE_ID; INT_NUMBER_PP', VarArrayOf([o.Collection.Owner.ID, o.ID, o.SelStart]), []) then
    ds.Edit
  else ds.Append;

  ds.FieldByName('DESCRIPTION_ID').Value := o.Collection.Owner.ID;
  ds.FieldByName('KERN_VALUE_ID').Value := o.ID;
  ds.FieldByName('INT_NUMBER_PP').Value := o.SelStart;

  ds.Post;
end;

function TListWordsDataPoster.PostToDB(ACollection: TIDObjects;
  AOwner: TIDObject): integer;
var ds: TDataSet;
    o: TDescription;
    os: TDictionaryWords;
    i: integer;
begin
  Result := 0;

  ds := TMainFacade.GetInstance.DBGates.Add(Self);
  if not ds.Active then ds.Open;

  o := AOwner as TDescription;
  os := ACollection as TDictionaryWords;

  ds.First;
  while ds.Locate('DESCRIPTION_ID', o.ID, []) do
  begin
    ds.Delete;
    ds.First;
  end;

  for i := 0 to os.Count - 1 do
  begin
    ds.Append;

    while not varIsNull(ds.FieldByName('DESCRIPTION_ID').Value) do ds.Append;

    ds.FieldByName('DESCRIPTION_ID').Value := o.ID;
    ds.FieldByName('KERN_VALUE_ID').Value := os.Items[i].ID;
    ds.FieldByName('INT_NUMBER_PP').Value := os.Items[i].SelStart;

    ds.Post;
  end
end;

procedure TListWordsDataPoster.SetAllWords(const Value: TDictionaryWords);
begin
  if FAllWords <> Value then
    FAllWords := Value;
end;

{ TRootDataPoster }

constructor TRootDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_ROOTS_DICT';

  KeyFieldNames := 'ROOT_ID';
  FieldNames := 'ROOT_ID, VCH_ROOT_NAME, DESCRIPTION_KERN_ID';

  AccessoryFieldNames := 'ROOT_ID, VCH_ROOT_NAME, DESCRIPTION_KERN_ID';
  AutoFillDates := false;

  Sort := 'VCH_ROOT_NAME';
end;

function TRootDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TRootDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TRoot;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TRoot;

      o.ID := ds.FieldByName('ROOT_ID').AsInteger;
      o.Name := trim(ds.FieldByName('VCH_ROOT_NAME').AsString);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TRootDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TRoot;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TRoot;

  if ds.Locate('ROOT_ID', o.ID, []) then
    ds.Edit
  else ds.Append;

  ds.FieldByName('ROOT_ID').Value := o.ID;
  ds.FieldByName('VCH_ROOT_NAME').Value := trim(o.Name);
  ds.FieldByName('DESCRIPTION_KERN_ID').Value := o.Collection.Owner.ID;

  ds.Post;

  o.ID := ds.FieldByName('ROOT_ID').AsInteger;
end;

{ TAuthorsDescriptionDataPoster }

constructor TAuthorDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource];
  DataSourceString := 'TBL_AUTHORS_DESCRIPTION';

  KeyFieldNames := 'DESCRIPTION_ID; EMPLOYEE_ID';
  FieldNames := 'DESCRIPTION_ID, EMPLOYEE_ID';

  AccessoryFieldNames := 'DESCRIPTION_ID, EMPLOYEE_ID';
  AutoFillDates := false;
  Sort := '';
end;

function TAuthorDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TAuthorDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o, oSource: TAuthor;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TAuthor;

      oSource := TAuthor(FAllEmployee.ItemsByID[ds.FieldByName('EMPLOYEE_ID').AsInteger]);
      if Assigned (oSource) then
        o.Assign(oSource);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TAuthorDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TAuthor;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TAuthor;

  while not varIsNull(ds.FieldByName('DESCRIPTION_ID').Value) do ds.Append;

  ds.FieldByName('DESCRIPTION_ID').Value := o.Collection.Owner.ID;
  ds.FieldByName('EMPLOYEE_ID').Value := o.ID;

  ds.Post;
end;

function TAuthorDataPoster.PostToDB(ACollection: TIDObjects;
  AOwner: TIDObject): integer;
var ds: TDataSet;
    ob: TDescription;
    a: TIDObjects;
    i: integer;
begin
  Result := 0;
  ds := TMainFacade.GetInstance.DBGates.Add(Self);
  if not ds.Active then ds.Open;

  ob := AOwner as TDescription;
  a := ACollection as TIDObjects;

  try
    while ds.Locate('DESCRIPTION_ID', ob.ID, []) do
      ds.Delete;
  except
    on E: Exception do
    begin
      //
    end;
  end;

  for i := 0 to a.Count - 1 do
  begin
    ds.Append;

    while not varIsNull(ds.FieldByName('DESCRIPTION_ID').Value) do ds.Append;

    ds.FieldByName('DESCRIPTION_ID').Value := ob.ID;
    ds.FieldByName('EMPLOYEE_ID').Value := a.Items[i].ID;

    ds.Post;
  end;
end;

{ TLithologyDataPoster }

constructor TLithologyDescrDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource];
  DataSourceString := 'TBL_LITHOLOGY_DESCR';

  KeyFieldNames := 'DESCRIPTION_ID; ROCK_ID';
  FieldNames := 'DESCRIPTION_ID, ROCK_ID';

  AccessoryFieldNames := 'DESCRIPTION_ID, ROCK_ID';

  AutoFillDates := false;
  Sort := '';
end;

function TLithologyDescrDataPoster.DeleteFromDB(AObject: TIDObject; ACollection: TIDObjects): integer;
begin
  Result := 0;
end;

function TLithologyDescrDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o, oSource: TLithologyDescr;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TLithologyDescr;

      oSource := TLithologyDescr(AllLithologies.ItemsByID[ds.FieldByName('ROCK_ID').AsInteger]);
      if Assigned (oSource) then o.Assign(oSource);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TLithologyDescrDataPoster.PostToDB(ACollection: TIDObjects;
  AOwner: TIDObject): integer;
var ds: TDataSet;
    ob: TDescription;
    ls: TIDObjects;
    i: integer;
begin
  Result := 0;
  ds := TMainFacade.GetInstance.DBGates.Add(Self);
  if not ds.Active then ds.Open;

  ob := AOwner as TDescription;
  ls := ACollection as TIDObjects;

  try
    while ds.Locate('DESCRIPTION_ID', ob.ID, []) do
      ds.Delete;
  except
    on E: Exception do
    begin
      //
    end;
  end;

  for i := 0 to ls.Count - 1 do
  begin
    ds.Append;

    while not varIsNull(ds.FieldByName('DESCRIPTION_ID').Value) do ds.Append;

    ds.FieldByName('DESCRIPTION_ID').Value := ob.ID;
    ds.FieldByName('ROCK_ID').Value := ls.Items[i].ID;

    ds.Post;
  end;
end;

function TLithologyDescrDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TLithologyDescr;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TLithologyDescr;

  while not varIsNull(ds.FieldByName('DESCRIPTION_ID').Value) do ds.Append;

  ds.FieldByName('DESCRIPTION_ID').Value := o.Collection.Owner.ID;
  ds.FieldByName('ROCK_ID').Value := o.ID;

  ds.Post;
end;

procedure TLithologyDescrDataPoster.SetAllLithologies(
  const Value: TLithologies);
begin
  if FAllLithologies <> Value then
    FAllLithologies := Value;
end;

procedure TRootDataPoster.SetAllDicts(const Value: TDictionaries);
begin
  if FAllDicts <> Value then
    FAllDicts := Value;
end;

procedure TAuthorDataPoster.SetAllEmployee(const Value: TEmployees);
begin
  if FAllEmployee <> Value then
    FAllEmployee := Value;
end;

{ TDescriptionFileDataPoster }

constructor TDescriptionFileDataPoster.Create;
begin
  inherited;
  Options := [soSingleDataSource, soGetKeyValue];
  DataSourceString := 'TBL_REFERENCE_FILE';

  //KeyFieldNames := 'SLOTTING_UIN; MATERIAL_ID';
  KeyFieldNames := 'SLOTTING_UIN';
  FieldNames := 'SLOTTING_UIN, MATERIAL_ID';

  AccessoryFieldNames := 'SLOTTING_UIN, MATERIAL_ID';
  AutoFillDates := false;

  Sort := 'SLOTTING_UIN';
end;

function TDescriptionFileDataPoster.DeleteFromDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
begin
  Result := inherited DeleteFromDB(AObject, ACollection);
end;

function TDescriptionFileDataPoster.GetFromDB(AFilter: string;
  AObjects: TIdObjects): integer;
var ds: TDataSet;
    o: TDescriptionFile;
begin
  Result := inherited GetFromDB(AFilter, AObjects);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  if not ds.Eof then
  begin
    ds.First;

    while not ds.Eof do
    begin
      o := AObjects.Add as TDescriptionFile;

      o.ID := ds.FieldByName('SLOTTING_UIN').AsInteger;
      o.Name := IntToStr(ds.FieldByName('MATERIAL_ID').AsInteger);

      ds.Next;
    end;

    ds.First;
  end;
end;

function TDescriptionFileDataPoster.PostToDB(AObject: TIDObject;
  ACollection: TIDObjects): integer;
var ds: TDataSet;
    o: TDescriptionFile;
begin
  Result := inherited PostToDB(AObject, ACollection);
  ds := TMainFacade.GetInstance.DBGates.Add(Self);

  o := AObject as TDescriptionFile;

  {
  ob := AOwner as TDescription;
  a := ACollection as TIDObjects;

  try
    while ds.Locate('DESCRIPTION_ID', ob.ID, []) do
      ds.Delete;
  except
    on E: Exception do
    begin
      //
    end;
  end;
  }

  ds.FieldByName('SLOTTING_UIN').AsInteger := o.ID;
  ds.FieldByName('MATERIAL_ID').AsInteger := StrToInt(o.Name);

  ds.Post;

  if o.ID = 0 then o.ID := ds.FieldByName('SLOTTING_UIN').Value;
end;

end.
