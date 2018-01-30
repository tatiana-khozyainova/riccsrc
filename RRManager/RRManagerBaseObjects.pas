unit RRManagerBaseObjects;

interface

uses SysUtils, Classes, ActnList, ClientCommon, Forms, BaseObjects;

type
  TBaseObject = class;
  TBaseObjectClass = class of TBaseObject;
  TBaseCollection = class;
  TBaseClass = class of TBaseObject;

 

  TBaseObject = class(TIDObject)
  private
    FNeedsUpdate: boolean;
  protected
    function GetObjectType: integer; virtual;
    function GetMaterialBindType: integer; virtual;
    function GetSubObjectsCount: integer; virtual;
  public
    procedure   AssignCollections(Source: TPersistent); virtual;
    procedure   Accept(Visitor: IVisitor); virtual;
    // идентификатор типа объекта в БД
    // 0 - cтруктура и пр.
    property    ObjectType: integer read GetObjectType;
    // идентификатор типа объекта по привязке материала
    property    MaterialBindType: integer read GetMaterialBindType;
    function    List(ListOption: TListOption; IncludeKey: boolean; Recource: boolean): string; overload; virtual;
    property    NeedsUpdate: boolean read FNeedsUpdate write FNeedsUpdate;
    property    SubObjectsCount: integer read GetSubObjectsCount;
    function    Check: boolean; virtual;

    constructor Create(ACollection: TIDObjects); override;


    destructor  Destroy; override;
  end;

  TBaseCollection = class(TIDObjects)
  private
    FUIN: integer;
    FNeedsUpdate: boolean;
    FRenewable: boolean;
    FCopyCollection: boolean;
    function GetItems(const Index: integer): TBaseObject;
    function GEtItemsByUIN(const UIN: integer): TBaseObject;
  protected
    FOwner: TBaseObject;
    procedure Accept(Visitor: IVisitor); virtual;
  public
    procedure Assign(Source: TIDObjects; NeedClearing: boolean = true); override;

    property UIN: integer read FUIN write FUIN;
    // владелец коллекции
    property Owner: TBaseObject read FOwner write FOwner;
    // надо обновлять или нет при следующем обращении
    property    NeedsUpdate: boolean read FNeedsUpdate write FNeedsUpdate;
    // возможно ли пополнение - или это счетная коллекция
    property    Renewable: boolean read FRenewable write FRenewable;

    property Items[const Index: integer]: TBaseObject read GetItems;
    // разные переборы
    property ItemsByUIN[const UIN: integer]: TBaseObject read GEtItemsByUIN;
    function IndexOfUIN(const UIN: integer): integer;

    // добавляет новые элементы коллекции,
    // у старых дополняет (заменяет) подчиненные коллекции
    // возвращает новое общее количество элементов в коллекции
    function AddItems(AItems: TBaseCollection): integer;

    function  Add: TBaseObject; overload; 
    function  Add(AObject: TObject; Copy: boolean = true; NeedsCheck: boolean = true): TIDObject; overload; virtual;

    // копировать коллекцию в вызове Assign или оставлять новую пустой
    property CopyCollection: boolean read FCopyCollection write FCopyCollection;
    constructor Create(ItemClass: TBaseObjectClass); overload; virtual;
    constructor Create(AOwner: TBaseObject); overload; virtual; abstract;
    // выгружает коллекцию в список строк
    procedure  MakeList(ALst: TStrings; ListOption: TListOption; IncludeKey: boolean);
    // делает строку
    function   List(ListOption: TListOption; IncludeKey: boolean; Recource: boolean): string; virtual;
    function   Last: TBaseObject;

    function    Check: boolean;     
    destructor Destroy; override;
  end;



implementation

{ TBaseObject }

procedure TBaseObject.Accept(Visitor: IVisitor);
begin

end;

procedure TBaseObject.AssignCollections;
begin

end;

function TBaseObject.Check: boolean;
begin
  Result := true;  
end;

constructor TBaseObject.Create(ACollection: TIDObjects); 
begin
  inherited;

end;

destructor TBaseObject.Destroy;
begin
  inherited;

end;

function TBaseObject.GetMaterialBindType: integer;
begin
  Result := 0;  
end;

function TBaseObject.GetObjectType: integer;
begin
  Result := -1;
end;

function TBaseObject.GetSubObjectsCount: integer;
begin
  Result := 0;
end;

function TBaseObject.List(ListOption: TListOption;
  IncludeKey: boolean; Recource: boolean): string;
begin
  if IncludeKey then
    Result := '[' + IntToStr(ID) + ']'
  else Result := '';

  if ListOption = loBindAttributes then
  begin
    if Assigned(Collection) and Assigned((Collection as TBaseCollection).Owner) then
      Result := Result + ', ' + (Collection as TBaseCollection).Owner.List(ListOption, IncludeKey, Recource);
  end;
end;

{ TBaseCollection }


constructor TBaseCollection.Create(ItemClass: TBaseObjectClass);
begin
  inherited Create;
  FObjectClass := ItemClass;

  NeedsUpdate := true;
  Renewable := true;
  CopyCollection := true;
end;



destructor TBaseCollection.Destroy;
begin
  inherited;
end;


function TBaseCollection.GetItems(const Index: integer): TBaseObject;
begin
  Result := inherited Items[Index] as TBaseObject;
end;

function TBaseCollection.GEtItemsByUIN(
  const UIN: integer): TBaseObject;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if Items[i].ID = UIN then
  begin
    Result := Items[i];
    break;
  end;
end;

function TBaseCollection.IndexOfUIN(const UIN: integer): integer;
var i: integer;
begin
  Result := -1;
  for i := 0 to Count - 1 do
  if Items[i].ID = UIN then
  begin
    Result := i;
    break;
  end;
end;







procedure TBaseCollection.MakeList(ALst: TStrings; ListOption: TListOption; IncludeKey: boolean);
var i: integer;
begin
  for i := 0 to Count - 1 do
    ALst.AddObject(Items[i].List(ListOption, IncludeKey, False), Items[i]);
end;

function TBaseCollection.Last: TBaseObject;
begin
  if Count > 0 then
    Result := Items[Count - 1]
  else Result := nil;

end;





procedure TBaseCollection.Accept(Visitor: IVisitor);
begin

end;

{ TBaseAction }


function TBaseCollection.AddItems(AItems: TBaseCollection): integer;
var i: integer;
    origin, copy: TBaseObject;
begin
  for i := 0 to AItems.Count - 1 do
  begin
    origin := ItemsByUIN[AItems.Items[i].ID];
    if not Assigned(origin) then
    begin
      copy := Add as TBaseObject;
      copy.Assign(AItems.Items[i]);
    end
    else origin.Assign(AItems.Items[i]);
  end;

  Result := Count;
end;



function TBaseCollection.Add: TBaseObject;
begin
  Result := inherited Add as TBaseObject;
  NeedsUpdate := false;
end;

function TBaseCollection.List(ListOption: TListOption; IncludeKey,
  Recource: boolean): string;
var i: integer;
begin
  Result := '';
  for i := 0 to Count - 1 do
    Result := Result + Items[i].List(ListOption, IncludeKey, Recource) + ';';
end;

function TBaseCollection.Check: boolean;
var i: integer;
begin
  Result := true;
  for i := 0 to Count - 1 do
    Result := Result and Items[i].Check;
end;

function TBaseCollection.Add(AObject: TObject; Copy,
  NeedsCheck: boolean): TIDObject;
begin
  Result := inherited Add(AObject, Copy, NeedsCheck);
end;

procedure TBaseCollection.Assign(Source: TIDObjects;
  NeedClearing: boolean);
begin
  if CopyCollection then
    inherited;
end;

end.
