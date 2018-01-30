unit SeisExemple;

interface

uses BaseObjects, Registrator, Classes, SeisMaterial,Material;

type

  // тип экземпляра
  TExempleType = class (TRegisteredIDObject)
  
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TExempleTypes = class (TRegisteredIDObjects)
  private
    function    GetItems(Index: Integer): TExempleType;
  public
    property    Items[Index: Integer]: TExempleType read GetItems;

    constructor Create; override;
  end;

  // место хранения экземпляра
  TExempleLocation = class (TRegisteredIDObject)
  private
    FMaterialLocation:TMaterialLocation;
  public
    property MaterialLocation:TMaterialLocation read FMaterialLocation write FMaterialLocation;
    function    List(AListOption: TListOption = loBrief): string; override;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TExempleLocations = class (TRegisteredIDObjects)
  private
    function    GetItems(Index: Integer): TExempleLocation;
  public
    property    Items[Index: Integer]: TExempleLocation read GetItems;

    constructor Create; override;
  end;

  // тип элемента
  TElementType = class (TRegisteredIDObject)
  
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TElementTypes = class (TRegisteredIDObjects)
  private
    function    GetItems(Index: Integer): TElementType;
  public
    property    Items[Index: Integer]: TElementType read GetItems;

    constructor Create; override;
  end;

  // экземпляр отчета
  TExempleSeismicMaterial = class (TRegisteredIDObject)
  private
    FSeismicMaterial: TSeismicMaterial;
    FExempleType: TExempleType;
    FExempleLocation: TExempleLocation;
    FExempleSum:Integer;
    FExempleComment:string;

  protected
  procedure AssignTo(Dest: TPersistent); override;
  public
    property    SeismicMaterial: TSeismicMaterial read FSeismicMaterial write FSeismicMaterial;
    property    ExempleType: TExempleType read FExempleType write FExempleType;
    property    ExempleLocation: TExempleLocation read FExempleLocation write FExempleLocation;
    property    ExempleSum: Integer read FExempleSum write FExempleSum;
    property    ExempleComment: string read FExempleComment write FExempleComment;
    function    List(AListOption: TListOption = loBrief): string; override;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TExempleSeismicMaterials = class (TRegisteredIDObjects)
  private
    function    GetItems(Index: Integer): TExempleSeismicMaterial;
  public
    property    Items[Index: Integer]: TExempleSeismicMaterial read GetItems;

    constructor Create; override;
  end;

  // элемент экземпляра
  TElementExemple = class (TRegisteredIDObject)
  private
    FElementType: TElementType;
    FExempleSeismicMaterial: TExempleSeismicMaterial;
    FElementNumber:Integer;
    FElementComment:string;
    FElementLocation:string;

  protected
  procedure AssignTo(Dest: TPersistent); override;
  public
    property    ElementType: TElementType read FElementType write FElementType;
    property    ExempleSeismicMaterial: TExempleSeismicMaterial read FExempleSeismicMaterial write FExempleSeismicMaterial;
    property    ElementNumber: Integer read FElementNumber write FElementNumber;
    property    ElementComment: string read FElementComment write FElementComment;
    property    ElementLocation: string read FElementLocation write FElementLocation;
    function    List(AListOption: TListOption = loBrief): string; override;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TElementExemples = class (TRegisteredIDObjects)
  private
    function    GetItems(Index: Integer): TElementExemple;
  public
    property    Items[Index: Integer]: TElementExemple read GetItems;

    constructor Create; override;
  end;

implementation

uses Facade, SeisExemplePoster,SysUtils;
 { TExempleType }



constructor TExempleType.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Тип экзепляра';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TExempleTypeDataPoster];
end;

{ TExempleTypes }



constructor TExempleTypes.Create;
begin
  inherited;
  FObjectClass := TExempleType;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TExempleTypeDataPoster];
end;

function TExempleTypes.GetItems(Index: Integer): TExempleType;
begin
  Result := inherited Items[Index] as TExempleType;
end;

{ TExempleLocation }



constructor TExempleLocation.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Место хранения экзепляра';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TExempleLocationDataPoster];
end;

function TExempleLocation.List(AListOption: TListOption): string;
begin
Result:=MaterialLocation.Name+' '+Name;
end;

{ TExempleLocations }



constructor TExempleLocations.Create;
begin
  inherited;
  FObjectClass := TExempleLocation;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TExempleLocationDataPoster];
end;

function TExempleLocations.GetItems(Index: Integer): TExempleLocation;
begin
  Result := inherited Items[Index] as TExempleLocation;
end;

 { TElementType }



constructor TElementType.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Тип элемента';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TElementTypeDataPoster];
end;

{ TElementTypes }



constructor TElementTypes.Create;
begin
  inherited;
  FObjectClass := TElementType;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TElementTypeDataPoster];
end;

function TElementTypes.GetItems(Index: Integer): TElementType;
begin
  Result := inherited Items[Index] as TElementType;
end;


{ TExempleSeismicMaterial }



procedure TExempleSeismicMaterial.AssignTo(Dest: TPersistent);
var o:TExempleSeismicMaterial;
begin
  inherited;
  o := Dest as TExempleSeismicMaterial;

  o.FSeismicMaterial:=SeismicMaterial;
  o.FExempleSum:=ExempleSum;
  o.FExempleType:=ExempleType;
  o.FExempleLocation:=ExempleLocation;
  o.FExempleComment:=ExempleComment;

end;

constructor TExempleSeismicMaterial.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Экземпляр отчета';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TExempleSeismicMaterialDataPoster];
end;

function TExempleSeismicMaterial.List(AListOption: TListOption): string;
begin
Result:='№:'+IntToStr(ID)+' '+ExempleType.Name
end;

{ TExempleSeismicMaterials }



constructor TExempleSeismicMaterials.Create;
begin
  inherited;
  FObjectClass := TExempleSeismicMaterial;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TExempleSeismicMaterialDataPoster];
end;

function TExempleSeismicMaterials.GetItems(Index: Integer): TExempleSeismicMaterial;
begin
  Result := inherited Items[Index] as TExempleSeismicMaterial;
end;

{ TElementExemple }



procedure TElementExemple.AssignTo(Dest: TPersistent);
var o:TElementExemple;
begin
  inherited;
  o := Dest as TElementExemple;

  o.FExempleSeismicMaterial:=ExempleSeismicMaterial;
  o.FElementType:=ElementType;
  o.FElementNumber:=ElementNumber;
  o.FElementComment:=ElementComment;
  o.FElementLocation:=ElementLocation;
end;

constructor TElementExemple.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Элемент экземпляра';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TElementExempleDataPoster];
end;

function TElementExemple.List(AListOption: TListOption): string;
begin
Result:='№:'+IntToStr(ElementNumber)+' '+ElementType.Name;
end;

{ TElementExemples }



constructor TElementExemples.Create;
begin
  inherited;
  FObjectClass := TElementExemple;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TElementExempleDataPoster];
end;

function TElementExemples.GetItems(Index: Integer): TElementExemple;
begin
  Result := inherited Items[Index] as TElementExemple;
end;

end.
