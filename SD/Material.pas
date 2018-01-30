unit Material;

interface

uses Registrator, BaseObjects, Classes, ComCtrls, Table, Organization, Employee,
LasFile;


type
  TDocumentType = class;
  TDocumentTypes = class;
  TSimpleDocument = class;
  TSimpleDocuments = class;
  //hgdfghdfghdfghfdghdfgdhtfdhfg
    // уровень доступа
  TLevelAccess = class (TRegisteredIDObject)
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TLevelAccesss = class (TRegisteredIDObjects)
  private
    function GetItems(Index: Integer): TLevelAccess;
  public
    property    Items[Index: Integer]: TLevelAccess read GetItems;

    constructor Create; override;
  end;

  // место хранения
  TMaterialLocation = class (TRegisteredIDObject)
  
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TMaterialLocations = class (TRegisteredIDObjects)
  private
    function    GetItems(Index: Integer): TMaterialLocation;
  public
    property    Items[Index: Integer]: TMaterialLocation read GetItems;

    constructor Create; override;
  end;

    // тип документа
  TDocumentType = class(TRegisteredIDObject)
  private
    FLevelAccess: TLevelAccess;
    FSubDocTypes: TDocumentTypes;
    FDocuments: TSimpleDocuments;

    function GetSubDocTypes: TDocumentTypes;
    function GetDocuments: TSimpleDocuments;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
      // уровень доступа к документу
    property LevelAccess: TLevelAccess read FLevelAccess write FLevelAccess;
      // коллекция подтипов
    property SubDocTypes: TDocumentTypes read GetSubDocTypes;
      // коллекция документов и материалов
    property Documents: TSimpleDocuments read GetDocuments;

    constructor Create(ACollection: TIDObjects); override;
  end;

  TDocumentTypes = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TDocumentType;
  public
    procedure Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property    Items[Index: integer]: TDocumentType read GetItems;

    procedure   MakeList(ANodeParent: TTreeNode; NeedsRegistering: boolean = true; NeedsClearing: boolean = false; CreateFakeNode: Boolean = true); override;

    constructor Create; override;
  end;

    // документ
  TSimpleDocument = class (TRegisteredIDObject)
  private
    FDocType: TDocumentType;
    FMaterialLocation: TMaterialLocation;
    FOrganization:TOrganization;
    FEmployee:TEmployee;
    FLocationPath: string;
    FInventNumber:Integer;
    FTGFNumber:Integer;
    FAuthors:string;
    FCreationDate:TDateTime;
    FEnteringDate:TDateTime;
    FMaterialComment:string;
    FVCHLocation:string;
    FBindings:string;

  protected
    procedure AssignTo(Dest: TPersistent); override;
  public


      // тип документа
    property    DocType: TDocumentType read FDocType write FDocType;
    property    MaterialLocation:TMaterialLocation read FMaterialLocation write FMaterialLocation;
    property    Organization:TOrganization read FOrganization write FOrganization;
    property    Employee:TEmployee read FEmployee write FEmployee;
      // путь к документу
    property    LocationPath: string read FLocationPath write FLocationPath;

    property    InventNumber: Integer read FInventNumber write FInventNumber;
    property    TGFNumber: Integer read FTGFNumber write FTGFNumber;
    property    Authors:string read FAuthors write FAuthors;
    property    CreationDate:TDateTime read FCreationDate write FCreationDate;
    property    EnteringDate:TDateTime read FEnteringDate write FEnteringDate;
    property    MaterialComment:string read FMaterialComment write FMaterialComment;
    property    VCHLocation:string read FVCHLocation write FVCHLocation;
    property    Bindings:string read FBindings write FBindings;
    function    List(AListOption: TListOption = loBrief): string; override;
    constructor Create(ACollection: TIDObjects); override;
    destructor  Destroy; override;
  end;

  TSimpleDocuments = class (TRegisteredIDObjects)
  private
    function GetItems(Index: Integer): TSimpleDocument;
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property    Items[Index: Integer]: TSimpleDocument read GetItems;

    constructor Create; override;
  end;

  TDescriptionDocument = class (TSimpleDocument)
  public
    function    List(AListOption: TListOption = loBrief): string; override;

    constructor Create(ACollection: TIDObjects); override;
    destructor  Destroy; override;
  end;

  TDescriptionDocuments = class (TSimpleDocuments)
  public

    constructor Create; override;
  end;

  // тип объекта привязки
  TObjectBindType = class (TRegisteredIDObject)
  private
    FRiccTable:TRiccTable;
    FRiccAttribute:TRICCAttribute;
  public
    property RiccTable:TRiccTable read FRiccTable write FRiccTable;
    property RiccAttribute:TRICCAttribute read FRiccAttribute write FRiccAttribute;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TObjectBindTypes = class (TRegisteredIDObjects)
  private
    function    GetItems(Index: Integer): TObjectBindType;
  public
    property    Items[Index: Integer]: TObjectBindType read GetItems;

    constructor Create; override;
  end;

  // привязка материала
  TMaterialBinding = class (TRegisteredIDObject)
  private
    FSimpleDocument:TSimpleDocument;
    FObjectBindType:TObjectBindType;
    //FObjectBindID:Integer;
  public
    property SimpleDocument:TSimpleDocument read FSimpleDocument write FSimpleDocument;
    property ObjectBindType:TObjectBindType read FObjectBindType write FObjectBindType;
    //property ObjectBindID:Integer read FObjectBindID write FObjectBindID;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TMaterialBindings = class (TRegisteredIDObjects)
  private
    function    GetItems(Index: Integer): TMaterialBinding;
  public
    property    Items[Index: Integer]: TMaterialBinding read GetItems;

    constructor Create; override;
  end;

  //тип объекта привязки по типу материала
  TObjectBindMaterialType = class (TRegisteredIDObject)
  private
    FObjectBindType:TObjectBindType;
    FDocumentType:TDocumentType;
  public
    property ObjectBindType:TObjectBindType read FObjectBindType write FObjectBindType;
    property DocumentType:TDocumentType read FDocumentType write FDocumentType;
    constructor Create(ACollection: TIDObjects); override;
  end;


 TMaterialCurve = class (TRegisteredIDObject)
  private
    FSimpleDocument:TSimpleDocument;
    FCurveCategory: TCurveCategory;

  public
    property SimpleDocument:TSimpleDocument read FSimpleDocument write FSimpleDocument;
    property CurveCategory: TCurveCategory read FCurveCategory write FCurveCategory;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TMaterialCurves = class (TRegisteredIDObjects)
  private
    function    GetItems(Index: Integer): TMaterialCurve;
  public
    property    Items[Index: Integer]: TMaterialCurve read GetItems;

    constructor Create; override;
  end;


  TObjectBindMaterialTypes = class (TRegisteredIDObjects)
  private
    function    GetItems(Index: Integer): TObjectBindMaterialType;
  public
    property    Items[Index: Integer]: TObjectBindMaterialType read GetItems;

    constructor Create; override;
  end;


  TAuthorRole = (arInner, arOuter); 
  //авторы материала
  TMaterialAuthor = class (TRegisteredIDObject)
  private
    FSimpleDocument:TSimpleDocument;
    FRole: TAuthorRole;

  public
    property SimpleDocument:TSimpleDocument read FSimpleDocument write FSimpleDocument;
    property Role: TAuthorRole read FRole write FRole;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TMaterialAuthors = class (TRegisteredIDObjects)
  private
    function    GetItems(Index: Integer): TMaterialAuthor;
  public
    property    Items[Index: Integer]: TMaterialAuthor read GetItems;

    constructor Create; override;
  end;



implementation

uses SysUtils, Facade, BaseFacades, MaterialPoster;

{ TSimpleDocument }

procedure TSimpleDocument.AssignTo(Dest: TPersistent);
var o: TSimpleDocument;
begin
  inherited;
  o := Dest as TSimpleDocument;

  o.FDocType := DocType;
  o.FLocationPath := LocationPath;
  o.FMaterialLocation:=MaterialLocation;
  o.FOrganization:=Organization;
  o.FEmployee:=FEmployee;
  o.FInventNumber:=InventNumber;
  o.FTGFNumber:=TGFNumber;
  o.FAuthors:=Authors;
  o.FCreationDate:=CreationDate;
  o.FEnteringDate:=EnteringDate;
  o.FMaterialComment:=MaterialComment;
  o.FVCHLocation:=VCHLocation;
  o.FBindings:=Bindings;
  
end;

constructor TSimpleDocument.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Простой документ';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TSimpleDocumentDataPoster];
end;

destructor TSimpleDocument.Destroy;
begin

  inherited;
end;

function TSimpleDocument.List(AListOption: TListOption): string;
var i : Integer;
    NewName : string;
begin
  NewName := '';

  //удаляем лишние пробелмы и символы
  for i := 1 to Length(Name) do
    if (not (Name[i] in [#10, #13])) then NewName := NewName + Name[i]
    else NewName := NewName + ' ';

  while (NewName <> '') and (pos('  ', NewName) <> 0) do
    NewName := StringReplace(NewName, '  ', ' ', [rfreplaceall]);


  Result :=IntToStr(InventNumber)+' '+Trim(NewName);
end;

{ TDocumentType }

procedure TDocumentType.AssignTo(Dest: TPersistent);
var o: TDocumentType;
begin
  inherited;
  o := Dest as TDocumentType;

  o.FLevelAccess := LevelAccess;
end;

constructor TDocumentType.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Тип документа';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TDocTypeDataPoster];
end;

function TDocumentType.GetDocuments: TSimpleDocuments;
begin
  if not Assigned (FDocuments) then
  begin
    FDocuments := TSimpleDocuments.Create;
    FDocuments.Owner := Self;
    FDocuments.Reload('MATERIAL_TYPE_ID = ' + IntToStr(ID));
  end;

  Result := FDocuments;
end;

function TDocumentType.GetSubDocTypes: TDocumentTypes;
begin
  if not Assigned (FSubDocTypes) then
  begin
    FSubDocTypes := TDocumentTypes.Create;
    FSubDocTypes.Owner := Self;
    FSubDocTypes.Reload('PARENTS_MATERIAL_TYPE_ID = ' + IntToStr(ID));
  end;

  Result := FSubDocTypes;
end;

{ TLevelAccesss }

constructor TLevelAccesss.Create;
begin
  inherited;
  FObjectClass := TLevelAccess;
  
end;

function TLevelAccesss.GetItems(Index: Integer): TLevelAccess;
begin
  Result := inherited Items[Index] as TLevelAccess;
end;

{ TDocumentTypes }

procedure TDocumentTypes.Assign(Sourse: TIDObjects; NeedClearing: boolean);
begin
  inherited;

end;

constructor TDocumentTypes.Create;
begin
  inherited;
  FObjectClass := TDocumentType;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TDocTypeDataPoster];
end;

function TDocumentTypes.GetItems(Index: integer): TDocumentType;
begin
  Result := inherited Items[Index] as TDocumentType;
end;

procedure TDocumentTypes.MakeList(ANodeParent: TTreeNode; NeedsRegistering,
  NeedsClearing, CreateFakeNode: boolean);
var i: integer;
    Node: TTreeNode;
begin
  if NeedsClearing then
    ANodeParent.DeleteChildren;

  for i := 0 to Count - 1 do
  begin
    Node := (ANodeParent.TreeView as TTreeView).Items.AddChildObject(ANodeParent, Items[i].List, Items[i]);

    if Items[i].SubDocTypes.Count > 0 then
      Items[i].SubDocTypes.MakeList(Node);
  end;

  if Assigned(Registrator) and NeedsRegistering then Registrator.Add(TTreeViewRegisteredObject, ANodeParent.TreeView, Self);
end;

{ TSimpleDocuments }

procedure TSimpleDocuments.Assign(Sourse: TIDObjects;
  NeedClearing: boolean);
begin
  inherited;
  
end;

constructor TSimpleDocuments.Create;
begin
  inherited;
  FObjectClass := TSimpleDocument;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TSimpleDocumentDataPoster];
end;

function TSimpleDocuments.GetItems(Index: Integer): TSimpleDocument;
begin
  Result := inherited Items[index] as TSimpleDocument;
end;

{ TLevelAccess }

constructor TLevelAccess.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Уровень доступа';
  
end;

{ TDescriptionDocuments }

constructor TDescriptionDocuments.Create;
begin
  inherited;
  FObjectClass := TDescriptionDocument;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TSimpleDocumentDataPoster];
end;

{ TDescriptionDocument }

constructor TDescriptionDocument.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Электронные описания керна';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TSimpleDocumentDataPoster];
end;

destructor TDescriptionDocument.Destroy;
begin

  inherited;
end;

function TDescriptionDocument.List(AListOption: TListOption): string;
begin
  Result := LocationPath + ' (' + Name + ')';
end;

{ TLocation }

constructor TMaterialLocation.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Место хранения материала';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TMaterialLocationDataPoster];

end;

{ TMaterialLocations }

constructor TMaterialLocations.Create;
begin
  inherited;
FObjectClass := TMaterialLocation;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TMaterialLocationDataPoster];

end;

function TMaterialLocations.GetItems(Index: Integer): TMaterialLocation;
begin
  Result := inherited Items[Index] as TMaterialLocation;
end;

{ TObjectBindType }

constructor TObjectBindType.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Тип объекта привязки';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TObjectBindTypeDataPoster];

end;

{ TObjectBindTypes }

constructor TObjectBindTypes.Create;
begin
  inherited;
   FObjectClass := TObjectBindType;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TObjectBindTypeDataPoster];
end;

function TObjectBindTypes.GetItems(Index: Integer): TObjectBindType;
begin
   Result := inherited Items[Index] as TObjectBindType;
end;

{ TMaterialBinding }

constructor TMaterialBinding.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Привязка материала';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TMaterialBindingDataPoster];

end;

{ TMaterialBindings }

constructor TMaterialBindings.Create;
begin
  inherited;
    FObjectClass := TMaterialBinding;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TMaterialBindingDataPoster];

end;

function TMaterialBindings.GetItems(Index: Integer): TMaterialBinding;
begin
   Result := inherited Items[Index] as TMaterialBinding;
end;

{ TMaterialAuthor }

constructor TMaterialAuthor.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Авторы материала';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TMaterialAuthorDataPoster];
end;

{ TMaterialAuthors }

constructor TMaterialAuthors.Create;
begin
  inherited;
  FObjectClass := TMaterialAuthor;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TMaterialAuthorDataPoster];
end;

function TMaterialAuthors.GetItems(Index: Integer): TMaterialAuthor;
begin
  Result := inherited Items[Index] as TMaterialAuthor;
end;

{ TObjectBindMaterialType }

constructor TObjectBindMaterialType.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Тип объекта привязки по типу материала';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TObjectBindMaterialTypeDataPoster];
end;

{ TObjectBindMaterialTypes }

constructor TObjectBindMaterialTypes.Create;
begin
  inherited;
  FObjectClass := TObjectBindMaterialType;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TObjectBindMaterialTypeDataPoster];
end;

function TObjectBindMaterialTypes.GetItems(
  Index: Integer): TObjectBindMaterialType;
begin
  Result := inherited Items[Index] as TObjectBindMaterialType;
end;





{ TMaterialCurve }

constructor TMaterialCurve.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Кривая в документе';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TMaterialCurveDataPoster];
end;

{ TMaterialCurves }

constructor TMaterialCurves.Create;
begin
  inherited;
  FObjectClass := TMaterialCurve;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TMaterialCurveDataPoster];
end;

function TMaterialCurves.GetItems(Index: Integer): TMaterialCurve;
begin
   Result := inherited Items[Index] as TMaterialCurve;
end;




end.
