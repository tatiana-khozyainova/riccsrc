unit RockSample;

interface

uses Registrator, BaseObjects, ComCtrls, Classes, TypeResearch,
     Lithology, BaseWellInterval;

type
  TRockSampleType = class(TRegisteredIDObject)
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TRockSampleTypes = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TRockSampleType;
  public
    property Items[Index: integer]: TRockSampleType read GetItems;
    constructor Create; override;
  end;

  TRockSampleSizeType = class(TRegisteredIDObject)
  private
    FYSize: single;
    FDiameter: single;
    FZSize: single;
    FXSize: single;
    FOrder: smallint;
    FRockSampleType: TRockSampleType;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property Diameter: single read FDiameter write FDiameter;
    property XSize: single read FXSize write FXSize;
    property YSize: single read FYSize write FYSize;
    property ZSize: single read FZSize write FZSize;

    property RockSampleType: TRockSampleType read FRockSampleType write FRockSampleType;

    property Order: smallint read FOrder write FOrder;

    constructor Create(ACollection: TIDObjects); override;
  end;

  TRockSampleSizeTypes = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TRockSampleSizeType;
  public
    property Items[Index: integer]: TRockSampleSizeType read GetItems;
    constructor Create; override;
  end;

  TRockSampleSizeTypePresence = class(TRegisteredIDObject)
  private
    FRockSampleSizeType: TRockSampleSizeType;
    FCount: integer;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property RockSampleSizeType: TRockSampleSizeType read FRockSampleSizeType write FRockSampleSizeType;
    property Count: integer read FCount write FCount;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TRockSampleSizeTypePresences = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TRockSampleSizeTypePresence;
  public
    function GetPresenseBySizeType(ARockSampleSizeType: TRockSampleSizeType): TRockSampleSizeTypePresence;
    // считает совокупное количество образцов
    function GetSampleCount: integer;

    property Items[Index: integer]: TRockSampleSizeTypePresence read GetItems;
    constructor Create; override;
  end;

  TSimpleRockSample = class (TRegisteredIDObject)
  private
    FLitology: TLithology;
    FFromBegining: double;
    FDiameter: single;
    FRockSampleType: TRockSampleType;
    FSize: single;
    FRockSampleSizeType: TRockSampleSizeType;
    FOwner:        TIDObject;
    FChanging: boolean;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    // от начала
    property    FromBegining: double read FFromBegining write FFromBegining;
    // слой - а если без слоя? (Т.)
    // это что ль слой? сделала тип образца - цилиндр, куб, шлиф и пр.
    property    RockSampleType: TRockSampleType read FRockSampleType write FRockSampleType;
    // типоразмер образца
    property    RockSampleSizeType: TRockSampleSizeType read  FRockSampleSizeType write FRockSampleSizeType;
    // диаметр
    property    Diameter: single read FDiameter write FDiameter;
    // размер на самом деле Size*Size
    property    Size: single read FSize write FSize;
    // флаг изменился объект в процессе или нет
    property    Changing: boolean read FChanging write FChanging;
    // литология
    property    Lithology: TLithology read FLitology write FLitology;

    constructor Create(ACollection: TIDObjects); override;
  end;

  TSimpleRockSamples = class (TRegisteredIDObjects)
  private
    function    GetItems(Index: integer): TSimpleRockSample;
  public
    property    Items [Index: integer] : TSimpleRockSample read GetItems;

    constructor Create; override;
  end;

  TRockSample = class (TSimpleRockSample)
  private
    FResearchs:    TRockSampleResearchs;
    function    GetResearchs: TRockSampleResearchs;
  protected
    procedure   AssignTo(Dest: TPersistent); override;
  public
    // коллекция типов исследований
    property    Researchs: TRockSampleResearchs read GetResearchs write FResearchs;

    constructor Create(ACollection: TIDObjects); override;
  end;

  TRockSamples = class (TSimpleRockSamples)
  private
    function GetItems(Index: integer): TRockSample;
  public
    procedure   Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property    Items [Index: integer] : TRockSample read GetItems;

    constructor Create; override;
  end;

implementation

uses Facade, RockSamplePoster, LayerSlotting, SysUtils, Contnrs,
     BaseFacades, BaseConsts;

{ TSimpleRockSamples }


constructor TSimpleRockSamples.Create;
begin
  inherited;

  FObjectClass := TSimpleRockSample;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TRockSampleDataPoster];
end;

function TSimpleRockSamples.GetItems(Index: integer): TSimpleRockSample;
begin
  Result := inherited Items[Index] as TSimpleRockSample;
end;

{ TSimpleRockSample }

procedure TSimpleRockSample.AssignTo(Dest: TPersistent);
var o: TSimpleRockSample;
begin
  inherited;
  o := Dest as TSimpleRockSample;
  o.FromBegining := FromBegining;
  o.Diameter := Diameter;
  o.Lithology := Lithology;
  o.Size := Size;
  
  o.RockSampleType := RockSampleType;
  o.RockSampleSizeType := RockSampleSizeType;
end;

constructor TSimpleRockSample.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Простой образец';
  //FLitology := TLithology.Create(nil);
end;

{ TRockSamples }

procedure TRockSamples.Assign(Sourse: TIDObjects; NeedClearing: boolean = true);
begin
  inherited;

end;

constructor TRockSamples.Create;
begin
  inherited;
  FObjectClass := TRockSample;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TRockSampleDataPoster];

  OwnsObjects := true;
end;

function TRockSamples.GetItems(Index: integer): TRockSample;
begin
  Result := inherited Items[Index] as TRockSample;
end;

{ TRockSample }

procedure TRockSample.AssignTo(Dest: TPersistent);
var o: TRockSample;
begin
  inherited;
  o := Dest as TRockSample;

  o.FromBegining := FromBegining;
  o.FOwner := Owner;
  o.Diameter := Diameter;
  o.Size := Size;
  o.Changing := Changing;

  o.Researchs.Assign(Researchs);
end;

constructor TRockSample.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Образец';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TRockSampleDataPoster];

  Changing := false;

  //FResearchs := TRockSampleResearchs.Create;
  //FResearchs.Owner := Self;
end;

(* function TRockSample.GetOwner: TIDObject;
var os: TLayerRockSamples;
begin
  //!!!! нельзя просто так взять и создать владельца
  // особенно если сначала создается коллекция, п потом в ней владелец...
  // овнер - это вообще не для записи
  // он из коллекции должен читаться
  {if not Assigned (FOwner) then
  begin
    os := TLayerRockSamples.Create;
    os.Poster.GetFromDB('ROCK_SAMPLE_UIN = ' + IntToStr(ID), os);

    FOwner := TLayerRockSample.Create(os);

    if os.Count > 0 then FOwner := os.Items[0];
  end;

  Result := FOwner;}
end; *)

{ TRockSampleTypes }

constructor TRockSampleTypes.Create;
begin
  inherited;
  FObjectClass := TRockSampleType;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TRockSampleTypeDataPoster];
end;

function TRockSampleTypes.GetItems(Index: integer): TRockSampleType;
begin
  Result := inherited Items[Index] as TRockSampleType;
end;

{ TRockSampleSizeType }

procedure TRockSampleSizeType.AssignTo(Dest: TPersistent);
var rst: TRockSampleSizeType;
begin
  inherited;

  rst := Dest as TRockSampleSizeType;
  rst.Diameter := Diameter;
  rst.XSize := XSize;
  rst.YSize := YSize;
  rst.ZSize := ZSize;
  rst.Order := Order;
  rst.RockSampleType := RockSampleType;
end;

constructor TRockSampleSizeType.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Типоразмер образца';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TRockSampleSizeTypePoster];
end;

{ TRockSampleSizeTypes }

constructor TRockSampleSizeTypes.Create;
begin
  inherited;
  FObjectClass := TRockSampleSizeType;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TRockSampleSizeTypePoster];
end;


function TRockSampleSizeTypes.GetItems(
  Index: integer): TRockSampleSizeType;
begin
  Result := inherited Items[Index] as TRockSampleSizeType;
end;

{ TRockSampleType }

constructor TRockSampleType.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Тип образца';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TRockSampleTypeDataPoster];
end;

{ TRockSampleSizeTypePresences }

constructor TRockSampleSizeTypePresences.Create;
begin
  inherited;
  FObjectClass := TRockSampleSizeTypePresence;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TRockSampleSizeTypePresencePoster];
end;

function TRockSampleSizeTypePresences.GetItems(
  Index: integer): TRockSampleSizeTypePresence;
begin
  Result := inherited Items[Index] as TRockSampleSizeTypePresence;
end;

function TRockSampleSizeTypePresences.GetPresenseBySizeType(
  ARockSampleSizeType: TRockSampleSizeType): TRockSampleSizeTypePresence;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if Items[i].RockSampleSizeType = ARockSampleSizeType then
  begin
    Result := Items[i];
    break;
  end;
end;

function TRockSampleSizeTypePresences.GetSampleCount: integer;
var i: integer;
begin
  Result := 0;
  for i := 0 to Count - 1 do
  begin
    if Items[i].ID <> CORE_SAMPLE_TYPE_COMMON_ID then
      Result := Result + Items[i].Count
    else
    begin
      Result := Items[i].Count;
      exit;
    end;
  end;
end;

{ TRockSampleSizeTypePresence }

procedure TRockSampleSizeTypePresence.AssignTo(Dest: TPersistent);
var rstp: TRockSampleSizeTypePresence;
begin
  inherited;

  rstp := Dest as TRockSampleSizeTypePresence;
  rstp.RockSampleSizeType := RockSampleSizeType;
  rstp.Count := Count;
end;

constructor TRockSampleSizeTypePresence.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Наличие образцов';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TRockSampleSizeTypePresencePoster];
end;

function TRockSample.GetResearchs: TRockSampleResearchs;
begin
  if not Assigned(FResearchs) then
  begin
    FResearchs := TRockSampleResearchs.Create;
    FResearchs.Owner := Self;
    FResearchs.Reload('ROCK_SAMPLE_UIN = ' + InttoStr(ID));
  end;

  Result := FResearchs;
end;

end.
