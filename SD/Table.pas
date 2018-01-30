unit Table;

interface

uses BaseObjects, Registrator, Classes, SysUtils, Forms;

type
  TFrameClass = class of TFrame;

  TRiccTable = class(TRegisteredIDObject)
  private
    FRusTableName: string;
    FEditorClass: TFrameClass;
    FCollection: TIDObjects;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property    RusTableName: string read FRusTableName write FRusTableName;
    property    Collection: TIDObjects read FCollection write FCollection;
    property    EditorClass: TFrameClass read FEditorClass write FEditorClass;

    function    Update(ACollection: TIDObjects = nil): integer; override;
    function    List(AListOption: TListOption = loBrief): string; override;
    constructor Create(ACollection: TIDObjects); override;
    destructor  Destroy; override;
  end;

  TRICCTables = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TRICCTable;
  public
    function  RiccTableByName(AName: string): TRiccTable;
    procedure BindToCollection(ADictTableName: string; ACollection: TIDObjects; AEditorClass: TFrameClass);
    property  Items[Index: integer]: TRICCTable read GetItems;
    constructor Create; override;
  end;

  TRICCDicts = class(TRICCTables)
  public
    procedure Reload; override;
  end;

  TRICCAttribute = class (TRegisteredIDObject)
  private
    FRusAttributeName:string;
  public
    property RusAttributeName:string read FRusAttributeName write FRusAttributeName;
    function    List(AListOption: TListOption = loBrief): string; override;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TRICCAttributes = class (TRegisteredIDObjects)
  private
    function    GetItems(Index: Integer): TRICCAttribute;
  public
    property    Items[Index: Integer]: TRICCAttribute read GetItems;

    constructor Create; override;
  end;

implementation


uses Facade, TablePoster;

{ TRiccTable }

procedure TRiccTable.AssignTo(Dest: TPersistent);
begin
  inherited;
  (Dest as TRiccTable).RusTableName := RusTableName;
end;

constructor TRiccTable.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'таблица РБЦГИ';
end;

destructor TRiccTable.Destroy;
begin

  inherited;
end;

function TRiccTable.List(AListOption: TListOption): string;
begin
  if trim(RusTableName) <> '' then
    Result := RusTableName + '[' + Name + ']'
  else
    Result := Name;
end;

function TRiccTable.Update(ACollection: TIDObjects): integer;
begin
  Result := inherited Update;
end;

{ TRICCTables }

procedure TRICCTables.BindToCollection(ADictTableName: string;
  ACollection: TIDObjects; AEditorClass: TFrameClass);
var dict: TRiccTable;
begin
  Assert(Assigned(ACollection), 'Для справочника ' + ADictTableName + ' не задана коллекция');
  dict := RiccTableByName(ADictTableName);
  Assert(Assigned(dict), 'в списке справочников отсутствует искомый справочник ' + ADictTableName);
  dict.RusTableName := ADictTableName;
  dict.EditorClass := AEditorClass;
  dict.Collection := ACollection;
end;

constructor TRICCTables.Create;
begin
  inherited;

  FObjectClass := TRiccTable;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TRiccTableDataPoster];
end;

function TRICCTables.GetItems(Index: integer): TRICCTable;
begin
  Result := inherited Items[Index] as TRiccTable;
end;

function TRICCTables.RiccTableByName(AName: string): TRiccTable;
begin
  Result := GetItemByName(AName) as TRiccTable;
end;

{ TRICCDicts }

procedure TRICCDicts.Reload;
begin
  Reload('NUM_TABLE_TYPE = 2');
end;

{ TRICCAttribute }

constructor TRICCAttribute.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Аттрибут РЦБГИ';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TRICCAttributeDataPoster];
end;

function TRICCAttribute.List(AListOption: TListOption): string;
begin
  if trim(RusAttributeName) <> '' then
    Result := RusAttributeName + '[' + Name + ']'
  else
    Result := Name;
end;

{ TRICCAttributes }

constructor TRICCAttributes.Create;
begin
  inherited;
   FObjectClass := TRICCAttribute;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TRICCAttributeDataPoster];
end;

function TRICCAttributes.GetItems(Index: Integer): TRICCAttribute;
begin
   Result := inherited Items[Index] as TRICCAttribute;
end;

end.
