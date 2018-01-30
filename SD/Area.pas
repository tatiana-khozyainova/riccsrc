unit Area;

interface

uses BaseObjects, Registrator, SysUtils;

type
  TSimpleArea = class (TRegisteredIDObject)
  private
    FWells: TRegisteredIDObjects;

    function GetWells: TRegisteredIDObjects;
  public
    class function ShortenAreaName(AAreaName: string): string;
    function    List(AListOption: TListOption = loBrief): string; override;
    property    Wells: TRegisteredIDObjects read GetWells;

    constructor Create(ACollection: TIDObjects); override;
    destructor  Destroy; override;
  end;

  TSimpleAreas = class (TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TSimpleArea;
  public
    property    Items[Index: integer]: TSimpleArea read GetItems;
    constructor Create; override;
  end;

  TArea = class (TSimpleArea)
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TAreas = class (TSimpleAreas)
  private
    function GetItems(Index: integer): TArea;
  public
    property    Items[Index: integer]: TArea read GetItems;

    constructor Create; override;
  end;

implementation

uses Facade, BaseFacades, AreaPoster, Math, Well;

{ TAreas }

constructor TAreas.Create;
begin
  inherited;
  FObjectClass := TArea;
end;

function TAreas.GetItems(Index: integer): TArea;
begin
  Result := inherited Items[Index] as TArea;
end;

{ TArea }

constructor TArea.Create(ACollection: TIDObjects);
begin
  inherited;
  FClassIDString := 'Площадь';
end;



{ TSimpleAreas }

constructor TSimpleAreas.Create;
begin
  inherited;
  FObjectClass := TSimpleArea;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TAreaDataPoster];
end;

function TSimpleAreas.GetItems(Index: integer): TSimpleArea;
begin
  Result := inherited Items[Index] as TSimpleArea;
end;

{ TSimpleArea }

constructor TSimpleArea.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Простая площадь';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TAreaDataPoster];
end;

destructor TSimpleArea.Destroy;
begin
  FreeAndNil(FWells);
  inherited;
end;

function TSimpleArea.GetWells: TRegisteredIDObjects;
begin
  If not Assigned (FWells) then
  begin
    FWells := TSimpleWells.Create;
    FWells.OwnsObjects := true;
    FWells.Owner := Self;
    FWells.Reload('AREA_ID = ' + IntToStr(ID));
  end;

  Result := FWells;
end;

function TSimpleArea.List(AListOption: TListOption): string;
begin
  Result := trim(StringReplace(inherited List(AListOption), '(-ое)', '', [rfReplaceAll]));
end;

class function TSimpleArea.ShortenAreaName(AAreaName: string): string;
begin
  AAreaName := StringReplace(AAreaName, ' (-ое)', '', [rfReplaceAll]);

  AAreaName := StringReplace(AAreaName, 'Восточно-', 'В-', [rfReplaceAll]);
  AAreaName := StringReplace(AAreaName, 'Западно-', 'З-', [rfReplaceAll]);
  AAreaName := StringReplace(AAreaName, 'Северо-', 'С-', [rfReplaceAll]);
  AAreaName := StringReplace(AAreaName, 'Южно-', 'Ю-', [rfReplaceAll]);
  AAreaName := StringReplace(AAreaName, 'Усть-', 'У-', [rfReplaceAll]);
  AAreaName := StringReplace(AAreaName, 'Усть', 'У-', [rfReplaceAll]);
  AAreaName := StringReplace(AAreaName, 'Верхне', 'Вх', [rfReplaceAll]);
  AAreaName := StringReplace(AAreaName, 'Средне', 'Ср', [rfReplaceAll]);
  AAreaName := StringReplace(AAreaName, 'Нижне', 'Нж', [rfReplaceAll]);
  AAreaName := StringReplace(AAreaName, 'мыльк', '', [rfReplaceAll]);
  AAreaName := StringReplace(AAreaName, 'ьская', '', [rfReplaceAll]);
  AAreaName := StringReplace(AAreaName, 'ская', '', [rfReplaceAll]);
  AAreaName := StringReplace(AAreaName, 'ная', '', [rfReplaceAll]);
  AAreaName := StringReplace(AAreaName, 'ая', '', [rfReplaceAll]);
  Result := AAreaName;
end;

end.
 