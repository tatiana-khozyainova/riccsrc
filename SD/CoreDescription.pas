unit CoreDescription;

interface

uses Registrator, Classes, BaseObjects, ComCtrls, Graphics,
     Employee, Dialogs, Windows, Lithology, StdCtrls, Slotting,
     Well, LayerSlotting, LayerSlottingPoster, Material;

type
  TInVisibleKey = (VK_TAB, VK_RETURN);
  TInVisibleKeys = set of TInVisibleKey;

  TDictionary = class;
  TDictionaries = class;
  TDescription = class;
  TDescriptions = class;
  TDictionaryWord = class;
  TDictionaryWords = class;
  TListWord = class;
  TListWords = class;

  TDescriptionFile = class (TDescriptionDocument)
  private
    FFullName: string;
    FDocuments: TDescriptionDocuments;
    function    GetDocument: TDescriptionDocument;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    property    FullName: string read FFullName write FFullName;

    property    Document: TDescriptionDocument read GetDocument;
    property    Documents: TDescriptionDocuments read FDocuments write FDocuments;

    function    List(AListOption: TListOption = loBrief): string; override;

    constructor Create(ACollection: TIDObjects); override;
  end;

  TDescriptionFiles = class (TDescriptionDocuments)
  private
    function GetItems(index: Integer): TDescriptionFile;
  public
    property Items[index: Integer]: TDescriptionFile read GetItems;

    constructor Create; override;
  end;

  TDescriptedLayer = class(TLayerRockSample)
  private
    FDescriptions: TDescriptions;
    FDescription: TDescription;

    function    GetDescription: TDescription;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    // описание керна
    property    Descriptions: TDescriptions read FDescriptions write FDescriptions;
    property    Description: TDescription read GetDescription write FDescription;

    procedure   ClearDescription;

    procedure   MakeList(AListView: TListItems; NeedsClearing: boolean = false); override;

    constructor Create(ACollection: TIDObjects); override;
  end;

  TDescriptedLayers = class(TLayerRockSamples)
  private
    function    GetItems(Index: integer): TDescriptedLayer;
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property    Items [Index: integer] : TDescriptedLayer read GetItems;

    function    GetNextNumber: integer;
    function    GetItemsByNumber(Number: double): TDescriptedLayer;
    function    ExistsDescription: boolean;

    constructor Create; override;
  end;

  {
  TDescriptedSlotting = class(TSlotting)
  private
    FDescriptions: TDescriptions;
    FDescription: TDescription;

    function    GetDescription: TDescription;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    // описание керна
    property    Descriptions: TDescriptions read FDescriptions write FDescriptions;
    property    Description: TDescription read GetDescription;
    procedure   ClearDescription;

    procedure   MakeList(AListView: TListItems; NeedsClearing: boolean = false); override;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TDescriptedSlottings = class(TSlottings)
  private
    function    GetItems(Index: integer): TDescriptedSlotting;
  protected
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
  public
    property    Items [Index: integer] : TDescriptedSlotting read GetItems;

    function    ExistsDescription: boolean;

    constructor Create; override;

  end;
  }
  
  // авторы описания
  TAuthor = class (TEmployee)
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TAuthors = class(TEmployees)
  private
    function    GetItems(Index: Integer): TAuthor;
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property    Items[Index: Integer]: TAuthor read GetItems;

    function    ObjectsToStr (AAuthors: string): string; override;
    procedure   RemoveDuplicate;

    constructor Create; override;
  end;

  // литология описания
  TLithologyDescr = class (TRegisteredIDObject)
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TLithologiesDescr = class(TRegisteredIDObjects)
  private
    function    GetItems(Index: Integer): TLithologyDescr;
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property    Items[Index: Integer]: TLithologyDescr read GetItems;

    constructor Create; override;
  end;

  // корень слова
  TRoot = class (TRegisteredIDObject)
  private
    FWords:     TDictionaryWords;
    function    GetWords: TDictionaryWords;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    property    Words: TDictionaryWords read GetWords;

    function    Update(ACollection: TIDObjects = nil): integer; override;

    constructor Create(ACollection: TIDObjects); override;
  end;

  TRoots = class(TRegisteredIDObjects)
  private
    function    GetItems(Index: Integer): TRoot;
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property    Items[Index: Integer]: TRoot read GetItems;

    // получение конкретного слова по его ID
    function    GetWord (AID: integer): TDictionaryWord;
    procedure   GetAddWords(AAllRoots: TRoots; AAllLiths: TLithologies);
    procedure   MakeList(AListView: TListItems; NeedsRegistering: boolean = true; NeedsClearing: boolean = false); override;

    constructor Create; override;
  end;

  TDictionaryWord = class (TRegisteredIDObject)
  private
    FSelStart: integer;
    FComment: string;
    FCorrect: boolean;
    FListWords: TListWords;
    FAllWords: TDictionaryWords;
    procedure   SetAllWords(const Value: TDictionaryWords);
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    property    SelStart: integer read FSelStart write FSelStart;
    property    Comment: string read FComment write FComment;
    property    Correct: boolean read FCorrect write FCorrect;

    property    ListWords: TListWords read FListWords write FListWords;
    property    AllWords: TDictionaryWords read FAllWords write SetAllWords;

    function    Update(ACollection: TIDObjects = nil): integer; override;

    constructor Create(ACollection: TIDObjects); override;
  end;

  TDictionaryWords = class(TRegisteredIDObjects)
  private
    FChangeMade: boolean;
    function    GetItems(Index: Integer): TDictionaryWord;
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;

    property    Items[Index: Integer]: TDictionaryWord read GetItems;
    property    ChangeMade: boolean read FChangeMade write FChangeMade;

    procedure   SortWords;

    procedure   SetCorrectWords (AObjects: TDictionaryWords);

    procedure   MakeList(AListView: TListItems; NeedsRegistering: boolean = true; NeedsClearing: boolean = false); override;
    procedure   MakeList(ALst: TStrings; NeedsRegistering: boolean = true; NeedsClearing: boolean = true); override;
    procedure   MakeList(AREdt: TRichEdit; NeedsRegistering: boolean = true; NeedsClearing: boolean = true); overload;

    function    Add(AObject: TObject; Copy: boolean = true; NeedsCheck: boolean = true): TIDObject; override;

    constructor Create; override;
  end;

    // слова описаний керна
  TListWord = class (TDictionaryWord)
  private
    FRoot: TRoot;
    procedure   SetRoot(const Value: TRoot);
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    property    Root: TRoot read FRoot write SetRoot;

    constructor Create(ACollection: TIDObjects); override;
  end;

  TListWords = class (TDictionaryWords)
  private
    function GetItems(Index: Integer): TListWord;
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property    Items[Index: Integer]: TListWord read GetItems;

    function    Checking(ACountDicts: integer): boolean;
    procedure   MakeList(ATreeView: TTreeView; NeedsRegistering: boolean = true; NeedsClearing: boolean = false; CreateFakeNode: Boolean = true); override;

    constructor Create; override;
  end;

    // справочники-словари
  TDictionary = class (TRegisteredIDObject)
  private
    FFont:   TFont;
    FRoots:  TRoots;
    function GetRoots: TRoots;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
      // коллекция слов словаря
    property Roots: TRoots read GetRoots;
      // шрифт
    property Font: TFont read FFont write FFont;

    constructor Create(ACollection: TIDObjects); override;
  end;

  TDictionaries = class(TRegisteredIDObjects)
  private
    function GetItems(Index: Integer): TDictionary;
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property    Items[Index: Integer]: TDictionary read GetItems;

    // установка, сохранение настроек
    procedure   SetFont(ADicts: TDictionaries);
    procedure   SaveFont(ADicts: TDictionaries);

    procedure   MakeList(ACbx: TComboBox; NeedsRegistering: boolean = true; NeedsClearing: boolean = true); override;

    constructor Create; override;
  end;

    // описание керна
  TDescription = class (TRegisteredIDObject)
  private
    FDateCreate: TDateTime;
    FWords: TListWords;
    FAllText: AnsiString;

    FLithologies: TLithologiesDescr;
    FAuthors: TAuthors;

    FHeader: string;
    FSlotting: TSlotting;
    FLayerSlotting: TDescriptedLayer;
    FFiles : TDescriptionFiles;

    function    GetWords: TListWords;
    function    GetAuthors: TAuthors;
    function    GetLithologies: TLithologiesDescr;
    function    GetFiles: TDescriptionFiles;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    property    Words: TListWords read GetWords;
    property    DateCreate: TDateTime read FDateCreate write FDateCreate;
    property    Header: string read FHeader write FHeader;
    property    AllText: AnsiString read FAllText write FAllText;

    property    Authors: TAuthors read GetAuthors;
    property    Lithologies: TLithologiesDescr read GetLithologies;

    property    Slotting: TSlotting read FSlotting write FSlotting;
    property    LayerSlotting: TDescriptedLayer read FLayerSlotting write FLayerSlotting;

    property    Files: TDescriptionFiles read GetFiles;

    procedure   Clear;
    procedure   Reload;
    function    GetModelDescription: string;
    function    CheckAllText (AString: string): string;

    function    CheckInVisibleKeys(CheckText: string): integer;

    procedure   CheckDoubleWords;

    constructor Create(ACollection: TIDObjects); override;
  end;

  TDescriptions = class(TRegisteredIDObjects)
  private
    function    GetItems(Index: Integer): TDescription;
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property    Items[Index: Integer]: TDescription read GetItems;

    function    GetItemsByOwner(AOwner: TIDObject): TDescription;

    constructor Create; override;
  end;

  TDescriptedWell = class(TWell)
  protected
    function    GetSlottings: TSlottings; override;
  end;

  TDescriptedWells = class(TWells)
  private
    function GetItems(Index: integer): TDescriptedWell;
  public
    property Items[Index: integer]: TDescriptedWell read GetItems;

    constructor Create; override;
  end;

implementation

uses Facade, CoreDescriptionPoster, SysUtils, TypInfo, Contnrs, Math;

{ TDictionarys }

procedure TDictionaries.Assign(Sourse: TIDObjects; NeedClearing: boolean = true);
begin
  inherited;

end;

constructor TDictionaries.Create;
begin
  inherited;
  FObjectClass := TDictionary;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TDictionaryDataPoster];

  OwnsObjects := true;
end;

{ TDictionary }

procedure TDictionary.AssignTo(Dest: TPersistent);
var o: TDictionary;
begin
  inherited;
  o := Dest as TDictionary;

  o.Font := Font;

  o.Roots.Assign(Roots);
end;

constructor TDictionary.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Словарь';

  FFont := TFont.Create;
  FFont.Name := 'Arial';
  FFont.CharSet := DEFAULT_CHARSET;
  FFont.Color := clWindowText;
  FFont.Size := 10;
  FFont.Style := [fsBold];

  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TDictionaryDataPoster];
end;

function TDictionaries.GetItems(Index: Integer): TDictionary;
begin
  Result := inherited Items[Index] as TDictionary;
end;

procedure TDictionaries.MakeList(ACbx: TComboBox; NeedsRegistering,
  NeedsClearing: boolean);
var i: integer;
begin
  inherited;

  for i := 0 to Count - 1 do
  if Items[i].Name <> 'Литология (нередактируемый справочник)' then
    ACbx.Items.AddObject(Items[i].Name, Items[i]);
end;

function TDictionary.GetRoots: TRoots;
begin
  if not Assigned (FRoots) then
  begin
    FRoots := TRoots.Create;
    FRoots.Owner := Self;
    FRoots.Reload('DESCRIPTION_KERN_ID = ' + IntToStr(ID));
  end;

  Result := FRoots;
end;

{ TDescription }

procedure TDescription.AssignTo(Dest: TPersistent);
var o: TDescription;
begin
  inherited;
  o := Dest as TDescription;

  o.DateCreate := DateCreate;
  o.AllText := AllText;
  o.Slotting := Slotting;

  if Assigned (Authors) then o.Authors.Assign(Authors);
  if Assigned (Lithologies) then o.Lithologies.Assign(Lithologies);
  if Assigned (Words) then o.Words.Assign(Words);
  //if Assigned (Files) then o.Files.Assign(Files);
end;

function TDescription.CheckAllText(AString: string): string;
var i : integer;
begin
  for i := 1 to Length (AString) do
  if ord(AString[i]) = 173 then Delete(AString, i, 1);

  Result := AString;
end;

procedure TDescription.CheckDoubleWords;
var i, j: integer;
    lw: TListWords;
    l: TListWord;
begin
  lw := TListWords.Create;

  // находим двойные слова
  for i := 0 to FWords.Count - 1 do
  if Pos(' ', FWords.Items[i].Name) > 0 then
  begin
    l := FWords.Items[i];
    lw.Add(l, false, false);
  end;

  // найти в списке слов слова с одинаковым началом слова
  for i := 0 to lw.Count - 1 do
  for j := 0 to FWords.Count - 1 do
  if (lw.Items[i].SelStart = FWords.Items[j].SelStart) and (pos(FWords.Items[j].Name, lw.Items[i].Name) > 0) then
  begin
    FWords.Remove(FWords.Items[j]);
    break;
  end;

  lw.Free;
end;

function TDescription.CheckInVisibleKeys(CheckText: string): integer;
var i: integer;
begin
  Result := 0;
  for i := 1 to Length(CheckText) do
  if (CheckText[i] = #9) or (CheckText[i] = #13) or (CheckText[i] = #10) then Result := Result + 2;
end;

procedure TDescription.Clear;
begin
  ID := 0;
  FName := '';
  FDateCreate := Date;
  FHeader := GetModelDescription;
  FAllText := '';

  FreeAndNil (FWords);
  FreeAndNil (FAuthors);
  FreeAndNil (FLithologies);
  FreeAndNil (FFiles);
end;

constructor TDescription.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Описание керна';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TDescriptionDataPoster];

  FDateCreate := Date;
end;

function TDescription.GetAuthors: TAuthors;
begin
  if not Assigned (FAuthors) then
  begin
    FAuthors := TAuthors.Create;
    FAuthors.Owner := Self;
    FAuthors.Reload('DESCRIPTION_ID = ' + IntToStr(ID));
  end;

  Result := FAuthors;
end;

function TDescription.GetFiles: TDescriptionFiles;
begin
  //Result := nil;

  if not Assigned (FFiles) then
  begin
    FFiles := TDescriptionFiles.Create;
    FFiles.Owner := Self;

    if Assigned (Collection) then
    if Assigned (Collection.Owner) then
    if Assigned (Collection.Owner.Collection) then
    if Assigned (Collection.Owner.Collection.Owner) then
      FFiles.Reload('SLOTTING_UIN = ' + IntToStr(Collection.Owner.Collection.Owner.ID));
  end;

  Result := FFiles;
end;

function TDescription.GetLithologies: TLithologiesDescr;
begin
  if not Assigned (FLithologies) then
  begin
    FLithologies := TLithologiesDescr.Create;
    FLithologies.Owner := Self;
    FLithologies.Reload('DESCRIPTION_ID = ' + IntToStr(ID));
  end;

  Result := FLithologies;
end;

function TDescription.GetModelDescription: string;
var lst: TStringList;
    i: integer;
    s: TSlotting;
begin
  Result := '';

  s := LayerSlotting.Collection.Owner as TSlotting;

  lst := TStringList.Create;
  // долбление
  lst.Add('Долбление ' + S.Name);
  // интервал
  lst.Add('Интервал ' + FloatToStr(S.Top) + '-' + FloatToStr(S.Bottom) + ' м');
  // проходка
  lst.Add('Проходка ' + FloatToStr(S.Digging) + ' м');
  // выход керна
  if S.CoreYield <> 0 then lst.Add('Выход керна ' + FloatToStr(S.CoreYield) + ' м');
  // пустая строка
  lst.Add(' ');

  for i := 0 to lst.Count - 1 do
    Result := Result + lst.Strings[i] + #13;

  lst.Free;
end;

function TDescription.GetWords: TListWords;
begin
  if not Assigned (FWords) then
  begin
    FWords := TListWords.Create;
    FWords.Owner := Self;
    FWords.Reload('DESCRIPTION_ID = ' + IntToStr(ID));
  end;

  Result := FWords;
end;

procedure TDescription.Reload;
begin
  if Assigned (FDataPoster) then
  begin
    FDataPoster.GetFromDB('LAYER_SLOTTING_ID = ' + IntToStr(Owner.id), Collection);
    //FDataPoster.SaveState(PosterState);
  end;
end;

{ TDescriptions }

procedure TDescriptions.Assign(Sourse: TIDObjects; NeedClearing: boolean = true);
begin
  inherited;

end;

constructor TDescriptions.Create;
begin
  inherited;
  FObjectClass := TDescription;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TDescriptionDataPoster];

  OwnsObjects := true;
end;

function TDescriptions.GetItems(Index: Integer): TDescription;
begin
  Result := inherited Items[Index] as TDescription;
end;

function TDescriptions.GetItemsByOwner(AOwner: TIDObject): TDescription;
var i: integer;
begin
  Result := nil;

  for i := 0 to Count - 1 do
  if Items[i].Owner = AOwner then
  begin
    Result := Items[i];
    break;
  end;
end;

{ TDictionaryWords }

function TDictionaryWords.Add(AObject: TObject; Copy,
  NeedsCheck: boolean): TIDObject;
begin
  Result := inherited Add(AObject, Copy, NeedsCheck);

  //if Copy then Registrator.Update(Result, Owner, ukAdd);
end;

procedure TDictionaryWords.Assign(Sourse: TIDObjects; NeedClearing: boolean = true);
var os: TDictionaryWords;
begin
  inherited;
  os := Sourse as TDictionaryWords;

  os.Owner := Owner;
end;

constructor TDictionaryWords.Create;
begin
  inherited;
  FObjectClass := TDictionaryWord;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TWordDataPoster];

  FChangeMade := false;
end;

function TDictionaryWords.GetItems(Index: Integer): TDictionaryWord;
begin
  Result := inherited Items[Index] as TDictionaryWord;
end;

procedure TDictionaryWords.MakeList(ALst: TStrings; NeedsRegistering,
  NeedsClearing: boolean);
var i: integer;
begin
  if (NeedsClearing) then ALst.Clear;
  for i := 0 to Count - 1 do
    ALst.AddObject(Items[i].FName, Items[i]);
end;

procedure TDictionaryWords.MakeList(AREdt: TRichEdit; NeedsRegistering,
  NeedsClearing: boolean);
begin
  if NeedsClearing then AREdt.Clear;


end;

procedure TDictionaryWords.MakeList(AListView: TListItems;
  NeedsRegistering, NeedsClearing: boolean);
var i: integer;
    o : TListItem;
begin
  if (NeedsClearing) then AListView.Clear;

  for i := 0 to Count - 1 do
  begin
    o := AListView.Add;
    o.Caption := Items[i].FName;
  end;
end;

procedure TDictionaryWords.SetCorrectWords(AObjects: TDictionaryWords);
var i, j: integer;
begin
  for j := 0 to AObjects.Count - 1 do
  for i := 0 to Count - 1 do
  if Items[i].ID = AObjects.Items[j].ID then
  begin
    Items[i].FCorrect := false;
    break;
  end;
end;

procedure TDictionaryWords.SortWords;
var i, j, Min, index: integer;
    w: TListWord;
begin
  // сортировка по FSelStart
  w := TListWord.Create(nil);
  for i := 0 to Count - 1 do
  begin
    Min := Items[i].FSelStart;
    index := i;
    for j := (i + 1) to Count - 1 do
    if Min > Items[j].FSelStart then
    begin
      w.Assign(Items[index]);
      Items[index].Assign(Items[j]);
      Items[j].Assign(w);
      index := j;
    end;
  end;
end;

{ TDictionaryWord }

procedure TDictionaryWord.AssignTo(Dest: TPersistent);
var o: TDictionaryWord;
begin
  inherited;
  o := Dest as TDictionaryWord;

  o.SelStart := SelStart;
  o.Comment := Comment;
  o.Correct := Correct;
  o.ListWords.Assign(ListWords);
end;

constructor TDictionaryWord.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Слово словаря';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TWordDataPoster];

  FSelStart := 0;
  FComment := '';
  FCorrect := true;
  FListWords := TListWords.Create;
end;

procedure TDictionaryWord.SetAllWords(const Value: TDictionaryWords);
begin
  if FAllWords <> Value then
    FAllWords := Value;
end;

function TDictionaryWord.Update(ACollection: TIDObjects = nil): integer;
begin
  Result := inherited Update;
end;

{ TListWords }

procedure TListWords.Assign(Sourse: TIDObjects; NeedClearing: boolean = true);
begin
  inherited;

end;

function TListWords.Checking(ACountDicts: integer): boolean;
var i: integer;
    d: TDictionary;
    ds: TDictionaries;
begin
  Result := false;

  ds := TDictionaries.Create;

  for i := 0 to Count - 1 do
  if Assigned (Items[i].Owner) then
  if Assigned (Items[i].Owner.Owner) then
  if not Assigned(ds.ItemsByID[Items[i].Owner.Owner.ID]) then
  begin
    d := Items[i].Owner.Owner as TDictionary;
    ds.Add(d);
  end;

  if ACountDicts = ds.Count then Result := true;

  ds.Free;
end;

constructor TListWords.Create;
begin
  inherited;
  FObjectClass := TListWord;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TListWordsDataPoster];

  OwnsObjects := false;
end;

function TListWords.GetItems(Index: Integer): TListWord;
begin
  Result := inherited Items[Index] as TListWord;
end;

procedure TListWords.MakeList(ATreeView: TTreeView; NeedsRegistering,
  NeedsClearing, CreateFakeNode: boolean);
begin
  ATreeView.Items.Clear;

  //for i := 0 to TMainFacade.GetInstance.Dicts.Count - 1 do
  //  ATreeView.Items.AddObject(nil, TMainFacade.GetInstance.Dicts.Items[i].Name, TMainFacade.GetInstance.Dicts.Items[i]);
end;

{ TListWord }

procedure TListWord.AssignTo(Dest: TPersistent);
var o: TListWord;
begin
  inherited;
  o := Dest as TListWord;

  if Assigned (Root) then o.Root := Root;
end;

constructor TListWord.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Слово описания керна';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TListWordsDataPoster];
end;

procedure TListWord.SetRoot(const Value: TRoot);
var w : TDictionaryWord;
begin
  FRoot := Value;

  //FRoot := (TMainFacade.GetInstance.AllWords.ItemsByID[ID] as TDictionaryWord).Owner as TRoot;

  w := FRoot.Words.ItemsByID[ID] as TDictionaryWord;
  // объекта может не быть из-за наличия справочника литологий
  if Assigned(w) then w.ListWords.Add(Self, false, false);
end;

{ TRoot }

procedure TRoot.AssignTo(Dest: TPersistent);
var o: TRoot;
begin
  inherited;
  o := Dest as TRoot;

  o.Words.Assign(Words);
end;

constructor TRoot.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Корень слова';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TRootDataPoster];
end;

function TRoot.GetWords: TDictionaryWords;
begin
  if not Assigned (FWords) then
  begin
    FWords := TDictionaryWords.Create;
    FWords.Owner := Self;
    FWords.OwnsObjects := true;
    FWords.Reload('ROOT_ID = ' + IntToStr(ID));
  end;

  Result := FWords;
end;

function TRoot.Update(ACollection: TIDObjects = nil): integer;
begin
  Result := inherited Update;
end;

{ TRoots }

procedure TRoots.Assign(Sourse: TIDObjects; NeedClearing: boolean = true);
begin
  inherited;

end;

constructor TRoots.Create;
begin
  inherited;
  FObjectClass := TRoot;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TRootDataPoster];

  OwnsObjects := true;
end;

procedure TRoots.GetAddWords(AAllRoots: TRoots; AAllLiths: TLithologies);
var i, index: integer;
    r: TRoot;
    w: TDictionaryWord;
begin
  index := -1;

  r := TRoot.Create(Self);

  for i := 0 to Count - 1 do
  if Items[i].Name = '<не указан>' then
  begin
    r := Items[i];
    index := i;
    break;
  end;

  if index = -1 then
  begin
    // desman - ввела параметр, потому что напрямую к фасаду нельзя обращаться
    r := AAllRoots.GetItemByName('<не указан>') as TRoot;
    if Assigned (r) then Add(r);
  end;

  if Assigned (r) then
  begin
    for i := 0 to AAllLiths.Count - 1 do
    begin
      w := TDictionaryWord.Create(r.FWords);
      w.Name := AAllLiths.Items[i].Name;
      w.FCorrect := true;
      r.FWords.Add(w, false, false);
    end;
  end;
end;

function TRoots.GetItems(Index: Integer): TRoot;
begin
  Result := inherited Items[Index] as TRoot;
end;

function TRoots.GetWord (AID: integer): TDictionaryWord;
var i, j: integer;
begin
  Result := nil;

  for i := 0 to count - 1 do
  for j := 0 to Items[i].Words.Count - 1 do
  if Items[i].Words.Items[j].ID = AID then
  begin
    Result := Items[i].Words.Items[j];
    break;
  end;
end;

procedure TRoots.MakeList(AListView: TListItems; NeedsRegistering,
  NeedsClearing: boolean);
var i, j, index : integer;
    o : TListItem;
begin
  if (NeedsClearing) then AListView.Clear;

  index := 1;
  for i := 0 to Count - 1 do
  for j := 0 to Items[i].Words.Count - 1 do
  begin
    o := AListView.Add;
    o.Caption := IntToStr(Items[i].Words.Items[j].ID);
    o.SubItems.AddObject(IntToStr(index), Items[i].Words.Items[j]);
    inc (index);
    o.SubItems.Add(Items[i].Words.Items[j].FName);
    o.SubItems.Add(Items[i].Words.Items[j].Owner.Name);
    o.SubItems.Add(IntToStr(Items[i].Words.Items[j].Owner.ID));
  end;
end;

{ TAuthors }

procedure TAuthors.Assign(Sourse: TIDObjects; NeedClearing: boolean = true);
begin
  inherited;
end;

constructor TAuthors.Create;
begin
  inherited;
  FObjectClass := TAuthor;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TAuthorDataPoster];

  OwnsObjects := true;
end;

function TAuthors.GetItems(Index: Integer): TAuthor;
begin
  Result := inherited Items[Index] as TAuthor;
end;

function TAuthors.ObjectsToStr(AAuthors: string): string;
var i: integer;
begin
  if AAuthors = '<нет данных>' then Result := ''
  else Result := AAuthors;

  for i := 0 to Count - 1 do
  if Pos(Items[i].Name, Result) = 0 then
  if Result = '' then Result := Result + Items[i].Name
  else Result := Result + ', ' + Items[i].Name;

  if Result = '' then Result := '<нет данных>';
end;

procedure TAuthors.RemoveDuplicate;
var i: integer;
    o: TAuthor;
    os: TAuthors;
begin
  os := TAuthors.Create;

  for i := 0 to Count - 1 do
  if not Assigned(os.ItemsByID[Items[i].ID]) then
  begin
    o := Items[i];
    os.Add(o);
  end;

  if Assigned(os) then
  begin
    Clear;
    Assign(os);
  end;

  os.Free;
end;

{ TAuthor }

procedure TAuthor.AssignTo(Dest: TPersistent);
begin
  inherited;

end;

constructor TAuthor.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Автор описания керна';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TAuthorDataPoster];
end;

{ TLithologiesDescr }

procedure TLithologiesDescr.Assign(Sourse: TIDObjects; NeedClearing: boolean = true);
var os: TLithologiesDescr;
begin
  inherited;

  os := Sourse as TLithologiesDescr;
  os.Owner := Owner;
end;

constructor TLithologiesDescr.Create;
begin
  inherited;
  FObjectClass := TLithologyDescr;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TLithologyDescrDataPoster];

  OwnsObjects := true;
end;

function TLithologiesDescr.GetItems(Index: Integer): TLithologyDescr;
begin
  Result := inherited Items[Index] as TLithologyDescr;
end;

{ TLithologyDescr }

procedure TLithologyDescr.AssignTo(Dest: TPersistent);
begin
  inherited;

end;

constructor TLithologyDescr.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Литология описания керна';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TLithologyDescrDataPoster];
end;

procedure TDescriptedLayer.AssignTo(Dest: TPersistent);
var o: TDescriptedLayer;
begin
  inherited;
  o := Dest as TDescriptedLayer;

  if Assigned(Descriptions) then
  begin
    if not Assigned (o.Descriptions) then o.Descriptions := TDescriptions.Create;
    o.Descriptions.Assign(Descriptions);
  end;

  if Assigned (o.FDescription) then
    o.FDescription := Description;
end;

procedure TDescriptedLayer.ClearDescription;
begin
  FreeAndNil(FDescription);
end;

constructor TDescriptedLayer.Create(ACollection: TIDObjects);
begin
  inherited;
  FClassIDString := 'Описание слоя';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TLayerSlottingDataPoster];

  FDescriptions := TDescriptions.Create;

  FName := '0';
end;

function TDescriptedLayer.GetDescription: TDescription;
begin
  if not Assigned (FDescription) then
  begin
    if Assigned (FDataPoster) then
    begin
      FDescriptions.Clear;
      FDescriptions.Owner := Self;
      FDescriptions.Poster.GetFromDB('LAYER_SLOTTING_ID = ' + IntToStr(ID), FDescriptions);
      if FDescriptions.Count > 0 then
      begin
        FDescription := TDescription.Create(FDescriptions);
        FDescriptions.Items[0].LayerSlotting := Self;
        FDescription := FDescriptions.Items[0];
      end;
    end
    else FDescription := nil;
  end;

  Result := FDescription;
end;


procedure TDescriptedLayer.MakeList(AListView: TListItems;
  NeedsClearing: boolean);
begin
  inherited;

end;

{ TDescriptedSlottings }

procedure TDescriptedLayers.Assign(Sourse: TIDObjects; NeedClearing: boolean = true);
begin
  inherited;

end;

constructor TDescriptedLayers.Create;
begin
  inherited;
  FObjectClass := TDescriptedLayer;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TLayerSlottingDataPoster];

  OwnsObjects := true;
end;

function TDescriptedLayers.ExistsDescription: boolean;
var i: integer;
begin
  // проверяем есть ли по выбранной скважине описания керна
  Result := false;
  for i := 0 to Count - 1 do
  if Assigned (Items[i].Description) then
  begin
    Result := true;
    Break;
  end;
end;

function TDescriptedLayers.GetItems(
  Index: integer): TDescriptedLayer;
begin
  Result := inherited Items[Index] as TDescriptedLayer;
end;

procedure TDictionaries.SaveFont(ADicts: TDictionaries);
var i: integer;
begin
  for i := 0 to ADicts.Count - 1 do
  begin
    TMainFacade.GetInstance.SystemSettings.SectionByName['Options'].SectionValues.Values['ID' + IntToStr(i)] := IntToStr(ADicts.Items[i].ID);
    TMainFacade.GetInstance.SystemSettings.SectionByName['Options'].SectionValues.Values['Name' + IntToStr(i)] := ADicts.Items[i].Name;
    TMainFacade.GetInstance.SystemSettings.SectionByName['Options'].SectionValues.Values['CharSet' + IntToStr(i)] := IntToStr(ADicts.Items[i].Font.Charset);
    TMainFacade.GetInstance.SystemSettings.SectionByName['Options'].SectionValues.Values['Color' + IntToStr(i)] := IntToStr(ADicts.Items[i].Font.Color);
    TMainFacade.GetInstance.SystemSettings.SectionByName['Options'].SectionValues.Values['Size' + IntToStr(i)] := IntToStr(ADicts.Items[i].Font.Size);
    TMainFacade.GetInstance.SystemSettings.SectionByName['Options'].SectionValues.Values['Style' + IntToStr(i)] := IntToStr(Byte(ADicts.Items[i].Font.Style));
  end;

  TMainFacade.GetInstance.SystemSettings.SaveToFile('Options', false);
end;

procedure TDictionaries.SetFont(ADicts: TDictionaries);
var i: integer;
    d: TDictionary;
begin
  for i := 0 to ADicts.Count - 1 do
  begin
    //try
      if Trim(TMainFacade.GetInstance.SystemSettings.SectionByName['Options'].SectionValues.Values['ID' + IntToStr(i)]) <> '' then
      begin
        d := (ADicts.ItemsByID[StrToInt(TMainFacade.GetInstance.SystemSettings.SectionByName['Options'].SectionValues.Values['ID' + IntToStr(i)])] as TDictionary);
        d.FFont.Name := TMainFacade.GetInstance.SystemSettings.SectionByName['Options'].SectionValues.Values['Name' + IntToStr(i)];
        d.FFont.Charset := StrToInt(TMainFacade.GetInstance.SystemSettings.SectionByName['Options'].SectionValues.Values['CharSet' + IntToStr(i)]);
        d.FFont.Color := StrToInt(TMainFacade.GetInstance.SystemSettings.SectionByName['Options'].SectionValues.Values['Color' + IntToStr(i)]);
        d.FFont.Size := StrToInt(TMainFacade.GetInstance.SystemSettings.SectionByName['Options'].SectionValues.Values['Size' + IntToStr(i)]);
        d.FFont.Style := TFontStyles(Byte(StrToInt(TMainFacade.GetInstance.SystemSettings.SectionByName['Options'].SectionValues.Values['Style' + IntToStr(i)])));
      end
      else
      begin
    //except
      d := ADicts.Items[i];
      { TODO : Вынести в объект настроек все настройки, а сюда пока запишем по умолчанию }
      d.FFont.Name := 'Arial';
      d.FFont.CharSet := DEFAULT_CHARSET;
      d.FFont.Color := clWindowText;
      d.FFont.Size := 10;
      d.FFont.Style := [fsBold];
    end;
  end;
end;


function TDescriptedWell.GetSlottings: TSlottings;
begin
  if not Assigned(FSlottings) then
  begin
    try
      FSlottings := TSlottings.Create;
      FSlottings.Owner := Self;
      FSlottings.Reload('well_uin = ' + IntToStr(id) + ' and dtm_kern_take_date is not null');
    except
      FSlottings := nil;
    end;
  end;

  Result := FSlottings;
end;

{ TDescriptedWells }

constructor TDescriptedWells.Create;
begin
  inherited;
  FObjectClass := TDescriptedWell;

  OwnsObjects := true;
end;

function TDescriptedWells.GetItems(Index: integer): TDescriptedWell;
begin
  Result := inherited Items[Index] as TDescriptedWell;
end;

function TDescriptedLayers.GetItemsByNumber(
  Number: double): TDescriptedLayer;
var i: integer;
begin
  Result := nil;

  for i := 0 to Count - 1 do
  if StrToInt(Items[i].Name) = Number then
  begin
    Result := Items[i];
    break;
  end;
end;

function TDescriptedLayers.GetNextNumber: integer;
var i: integer;
begin
  Result := 0;

  for i := 0 to Count - 1 do
    if StrToInt(Items[i].Name) > Result then Result := StrToInt(Items[i].Name);

  Result := Result + 1;
end;

{ TDescriptionFile }

procedure TDescriptionFile.AssignTo(Dest: TPersistent);
var o: TDescriptionFile;
begin
  inherited;
  o := dest as TDescriptionFile;

  o.FFullName := FFullName;
end;

constructor TDescriptionFile.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Ссылка на файл с описание керна';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TDescriptionFileDataPoster];
end;

function TDescriptionFile.GetDocument: TDescriptionDocument;
begin
  Result := nil;

  if not Assigned (FDocuments) then
  begin
    FDocuments := TDescriptionDocuments.Create;
    FDocuments.Reload('material_type_id = 19 and material_id = ' + Name);
  end;

  if FDocuments.Count > 0 then
    Result := FDocuments.Items[0] as TDescriptionDocument;
end;

function TDescriptionFile.List(AListOption: TListOption): string;
begin
  Result := LocationPath + ' (' + FullName + ')';
end;

{ TDescriptionFiles }

constructor TDescriptionFiles.Create;
begin
  inherited;
  FObjectClass := TDescriptionFile;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TDescriptionFileDataPoster];
end;

function TDescriptionFiles.GetItems(index: Integer): TDescriptionFile;
begin
  Result := inherited Items[Index] as TDescriptionFile;
end;

end.
