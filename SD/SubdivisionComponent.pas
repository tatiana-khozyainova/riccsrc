unit SubdivisionComponent;

interface

uses Registrator, BaseObjects, Classes, Straton, Contnrs, Ex_Grid, Theme, Employee, BaseConsts;

type
  TBlockSubdivisionComponents = class;
  TSubdivisionComponents = class;

  TSubdivision = class(TregisteredIdObject)
  private
    FSigningDate: TDateTime;
    FEmployee: TEmployee;
    FTheme: TTheme;
    FSubdivisionComponents: TSubdivisionComponents;
    function GetSubdivisionComponents: TSubdivisionComponents;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property Theme: TTheme read FTheme write FTheme;
    property SingingDate: TDateTime read FSigningDate write FSigningDate;
    property SigningEmployee: TEmployee read FEmployee write FEmployee;
    function    Update(ACollection: TIDObjects = nil): integer; override;
    property SubdivisionComponents: TSubdivisionComponents read GetSubdivisionComponents;
    constructor Create (ACollection: TIDObjects); override;
    destructor  Destroy; override;
  end;

  TSubdivisions = class(TRegisteredIDObjects)
  private
    function GetItems(const Index: integer): TSubdivision;
  public
    property Items[const Index: integer]: TSubdivision read GetItems;
    function GetSubdivisionByTheme(ATheme: TTheme): TSubdivision;
    constructor Create; override;
  end;

  TTectonicBlock = class(TRegisteredIDObject)
  private
    FOrder: integer;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    function    List(AListOption: TListOption = loBrief): string; override;
    property    Order: integer read FOrder write FOrder;
    constructor Create (ACollection: TIDObjects ); override;
  end;

  TTectonicBlocks = class(TRegisteredIDObjects)
  private
    function GetItems (Index: integer) : TTectonicBlock;
  public
    property  Items [Index:integer]: TTectonicBlock read GetItems;
    constructor Create;override;
  end;

  TSubdivisionComment = class (TRegisteredIDObject)
 // protected
  //  procedure AssignTo (Dest: TPersistent); override;
  public
    function    List(AListOption: TListOption = loBrief): string; override;
    constructor Create (ACollection: TIDObjects); override;
  end;

  TSubdivisionComments = class (TRegisteredIDObjects)
  private
    function GetItems (index : Integer) : TSubdivisionComment;
  public
    property Items [Items:Integer]: TSubdivisionComment read GetItems;
    constructor Create;override;
  end;

  TSubdivisionComponent = class (TRegisteredIDObject)
  private
    FStraton : TSimpleStraton;
    FBlock: TTectonicBlock;
    FNextStraton: TSimpleStraton;
    FComment: TSubdivisionComment;
    FDepth: Single;
    FVerified: Integer;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property Straton: TSimpleStraton read FStraton write FStraton;
    property Block: TTectonicBlock read FBlock write FBlock;
    property NextStraton: TSimpleStraton read FNextStraton write FNextStraton;
    property Comment: TSubdivisionComment read FComment write FComment;
    property Depth: Single read FDepth write FDepth;
    property Verified: Integer read FVerified write FVerified;
    function    List(AListOption: TListOption = loBrief): string; override;


    constructor Create (ACollection: TIDObjects); override;

  end;

  TSubdivisionComponents = class (TRegisteredIDObjects)
  private
    FBSCList: TObjectList;
    procedure SeparateIntoBlocks;
    function GetItems(Index: integer): TSubdivisionComponent;
    function GetBlockSubdivisionComponents(
      Index: Integer): TBlockSubdivisionComponents;
    function GetBlockCount: integer;
  public
    property  BlockSubdivisionComponents[Index: Integer]: TBlockSubdivisionComponents read GetBlockSubdivisionComponents;
    property  BlockCount: integer read GetBlockCount;
    function  GetComponentByStratonAndBlock(ABlock: TTectonicBlock; AStraton: TSimpleStraton): TSubdivisionComponent;
    property  Items[Index: integer]: TSubdivisionComponent read GetItems;
    constructor Create; override;
  end;


  TBlockSubdivisionComponents = class(TSubdivisionComponents)
  private
    FBlock: TTectonicBlock;
  public
    function GetComponentByStraton(AStraton: TSimpleStraton): TSubdivisionComponent;
    property Block: TTectonicBlock read FBlock write FBlock;
    constructor Create;  override;
  end;

implementation

uses SubdivisionComponentPoster, Facade, SysUtils;

procedure TTectonicBlock.AssignTo(Dest: TPersistent);
begin
  inherited;
  (Dest as TTectonicBlock).Order := Order;
end;

constructor TTectonicBlock.Create(ACollection: TIDObjects);
begin
  inherited;
  ID := -1;
  ClassIDString := 'Тектонический блок';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TTectonicBlockDataPoster];
end;

constructor TTectonicBlocks.Create;
begin
  inherited;
  FObjectClass := TTectonicBlock;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TTectonicBlockDataPoster];
end;

function TTectonicBlocks.GetItems(Index: integer): TTectonicBLock;
begin
  Result := inherited Items[Index] as TTectonicBlock;
end;





{ TSubdivisionComment }

constructor TSubdivisionComment.Create(ACollection: TIDObjects);
begin
  inherited;
  ID:= -1;
  ClassIDString := '' ;
  FDataPoster :=TMainFacade.GetInstance.DataPosterByClassType[TSubdivisionCommentDataPoster];
end;



function TSubdivisionComment.List(AListOption: TListOption): string;
begin
  if AListOption = loBrief then
    Result := ShortName
  else
    Result := Inherited List(AListOption);
end;

{ TSubdivisionComments }

constructor TSubdivisionComments.Create;
begin
   inherited;
  FObjectClass := TSubdivisionComment;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TSubdivisionCommentDataPoster];

end;

function TSubdivisionComments.GetItems(
  index: Integer): TSubdivisionComment;
begin
Result := inherited Items[Index] as TSubdivisionComment;
end;

{ TSubdivisionComponent }

procedure TSubdivisionComponent.AssignTo(Dest: TPersistent);
var sct: TSubdivisionComponent;
begin
  inherited;

  sct := Dest as TSubdivisionComponent;
  sct.Straton :=Straton;
  sct.Block := Block;
  sct.NextStraton := NextStraton;
  sct.Comment :=Comment;
  sct.Depth := Depth;
  sct.Verified := Verified;

end;

constructor TSubdivisionComponent.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Состав разбивки';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TSubdivisionComponentDataPoster];
end;

function TSubdivisionComponent.List(AListOption: TListOption): string;
begin
  Assert(Assigned(Straton), 'Стратиграфическое подразделение для разбивки не определено');
  if AListOption = loBrief then
  begin
    if Assigned(Comment) and (Comment.ID <> SUBDIVISION_COMMENT_NULL)  then
      Result := Comment.List()
    else
      Result := Format('%.2f', [Depth]);
  end
  else
  begin
    if Assigned(Comment) then
      Result := Straton.Name + ' = ' + Comment.List()
    else
      Result := Straton.Name + ' = ' + Format('%.2f', [Depth])
  end;
end;

{ TSubdivisionComponents }

constructor TSubdivisionComponents.Create;
begin
  inherited;
  FObjectClass := TSubdivisionComponent;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TsubdivisionComponentDataPoster];
end;

function TSubdivisionComponents.GetBlockCount: integer;
begin
  if not Assigned(FBSCList) then
  begin
    FBSCList := TObjectList.Create(True);
    SeparateIntoBlocks;
  end;

  Result := FBSCList.Count;
end;

function TSubdivisionComponents.GetBlockSubdivisionComponents(
  Index: Integer): TBlockSubdivisionComponents;
begin
  if not Assigned(FBSCList) then
  begin
    FBSCList := TObjectList.Create(True);
    SeparateIntoBlocks;
  end;

  if FBSCList.Count > Index then Result := FBSCList[Index] as TBlockSubdivisionComponents
  else Result := nil;
end;

function TSubdivisionComponents.GetComponentByStratonAndBlock(
  ABlock: TTectonicBlock; AStraton: TSimpleStraton): TSubdivisionComponent;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if (Items[i].Straton = AStraton) and (Items[i].Block = ABlock) then
  begin
    Result := Items[i];
    break;
  end;
end;

function TSubdivisionComponents.GetItems(
  Index: integer): TSubdivisionComponent;
begin
Result := inherited Items[Index] as TSubdivisionComponent;
end;



procedure TSubdivisionComponents.SeparateIntoBlocks;
var i,j:Integer;
    BlockSubdivisionComponents: TBlockSubdivisionComponents;
    bFound: boolean;
begin
  //  1. Перебираем компоненты коллекции
  for i:=0 to Count-1 do
  begin
    bFound := false;
    //  2. Для каждого - смотрим блок
    for j := 0 to FBSCList.Count - 1 do
    //  3. Проверяем есть ли в FBSCList коллекция TBlockSubdivisionComponent у которой Block = Block'у текущего компонента
    if (FBSCList.Items[j] as TBlockSubdivisionComponents).Block = Items[i].Block then
    begin
      bFound := true;
      BlockSubdivisionComponents := FBSCList.Items[j] as TBlockSubdivisionComponents;
      Break;
    end;

    if not bFound then
    begin
      //  4. Если нет - создаем такую TBlockSubdivisionComponent
      BlockSubdivisionComponents := TBlockSubdivisionComponents.Create;
      BlockSubdivisionComponents.Block := Items[i].Block;
      FBSCList.Add(BlockSubdivisionComponents);
    end;

    //  5. Добавляем в созданную или найденную колекцию текущий компонент
    BlockSubdivisionComponents.Add(Items[i], false, False);
  end;   //  6. Переходим к следующему
end;

{ TBlockSubdivisionComponents }

constructor TBlockSubdivisionComponents.Create;
begin
  inherited Create;
  OwnsObjects := false;
end;

function TBlockSubdivisionComponents.GetComponentByStraton(
  AStraton: TSimpleStraton): TSubdivisionComponent;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if Items[i].Straton.ID = AStraton.ID then
  begin
    Result := Items[i];
    break;
  end;
end;

{ TSubdivision }

procedure TSubdivision.AssignTo(Dest: TPersistent);
var s: TSubdivision;
begin
  inherited;

  s := Dest as TSubdivision;
  s.Theme := Theme;
  s.SigningEmployee := SigningEmployee;
  s.SingingDate := SingingDate;
end;

constructor TSubdivision.Create(ACollection: TIDObjects);
begin
  inherited;
  ID := -1;
  ClassIDString := 'Стратиграфическая разбивка';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TSubdivisionDataPoster];
end;

destructor TSubdivision.Destroy;
begin
  FreeAndNil(FSubdivisionComponents);

  inherited;
end;

function TSubdivision.GetSubdivisionComponents: TSubdivisionComponents;
begin
  if not Assigned(FSubdivisionComponents) then
  begin
    FSubdivisionComponents := TSubdivisionComponents.Create;
    FSubdivisionComponents.Owner := Self;
    FSubdivisionComponents.Reload('Subdivision_Id = ' + IntToStr(ID), false);
  end;

  result := FSubdivisionComponents;
end;

function TSubdivision.Update(ACollection: TIDObjects): integer;
begin
  inherited Update(ACollection);
  SubdivisionComponents.Update(nil);
end;

{ TSubdivisions }

constructor TSubdivisions.Create;
begin
  inherited;
  FObjectClass := TSubdivision;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TSubdivisionDataPoster];
end;

function TSubdivisions.GetItems(const Index: integer): TSubdivision;
begin
  result := inherited Items[Index] as TSubdivision;
end;

function TSubdivisions.GetSubdivisionByTheme(ATheme: TTheme): TSubdivision;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if Items[i].Theme.ID = ATheme.ID then
  begin
    Result := Items[i];
    break;
  end;
end;

function TTectonicBlock.List(AListOption: TListOption): string;
begin
  if AListOption = loBrief then
    Result := ShortName
  else
    Result := Inherited List(AListOption);
end;

end.

