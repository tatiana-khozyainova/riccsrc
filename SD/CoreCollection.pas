unit CoreCollection;

interface

uses Registrator, Slotting, BaseObjects, ComCtrls, TestInterval,
     Classes, Organization, SlottingPlacement, PetrolRegion, District,
     Straton, Employee, Well, BaseWellInterval;

type
  TCollectionSample = class;
  TCollectionSamples = class;
  TCollectionWell = class;
  TCollectionWells = class;
  TCollectionSampleType = class;
  TCollectionSampleTypes = class;
  TDenudation = class;
  TDenudations = class;
  TWellCandidate = class;
  TWellCandidates = class;


  TCollectionSampleType = class(TRegisteredIDObject)
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TCollectionSampleTypes = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TCollectionSampleType;
  public
    property Items[Index: integer]: TCollectionSampleType read GetItems;
    constructor Create; override;
  end;

  TCoreCollectionType = class(TRegisteredIDObject)
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TCoreCollectionTypes = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TCoreCollectionType;
  public
    property Items[Index: integer]: TCoreCollectionType read GetItems;
    constructor Create; override;
  end;

  TFossilType = class(TRegisteredIDObject)
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TFossilTypes = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TFossilType;
  public
    property Items[Index: integer]: TFossilType read GetItems;
    constructor Create; override;
  end;


  TCoreCollection = class(TRegisteredIDObject)
  private
    FOwnerName: string;
    FAuthorName: string;
    FCoreCollectionType: TCoreCollectionType;
    FFossilType: TFossilType;
    FBaseStraton: TSimpleStraton;
    FTopStraton: TSimpleStraton;
    FOwnerEmployee: TEmployee;
    FAuthorEmployee: TEmployee;
    FCollectionWells: TCollectionWells;
    FAllDenudations: TDenudations;
    FWellCandidates: TWellCandidates;
    function GetAuthorName: string;
    function GetOwnerName: string;
    function GetCollectionWells: TCollectionWells;
    function GetAllDenudations: TDenudations;
    function GetWellCandidates: TWellCandidates;
  protected
    procedure AssignTo(Dest: TPersistent); override;
    procedure SetName(const Value: string); override;
  public
    // скважины коллекции
    property    CollectionWells: TCollectionWells read GetCollectionWells;
    // тип органических остатков
    property    FossilType: TFossilType read FFossilType write FFossilType;
    // тип коллекции
    property    CoreCollectionType: TCoreCollectionType read FCoreCollectionType write FCoreCollectionType;
    // имя владельца
    property    OwnerName: string read GetOwnerName write FOwnerName;
    // имя автора
    property    AuthorName: string read GetAuthorName write FAuthorName;
    // имя владельца-сотрудника ТП НИЦ
    property    OwnerEmp: TEmployee read FOwnerEmployee write FOwnerEmployee;
    // имя автора-сотрудника ТП НИЦ
    property    AuthorEmp: TEmployee read FAuthorEmployee write FAuthorEmployee;
    // охват стратиграфических подразделений
    property    TopStraton: TSimpleStraton read FTopStraton write FTopStraton;
    property    BaseStraton: TSimpleStraton read FBaseStraton write FBaseStraton;
    // метод записи коллекции в БД
    function    Update(ACollection: TIDObjects = nil): integer; override;
    // все обнажения
    property    Denudations: TDenudations read GetAllDenudations;
    // все скважины-кандидаты
    property    WellCandidates: TWellCandidates read GetWellCandidates;

    // метод самоописания коллекции
    function    List(AListOption: TListOption = loBrief): string; override;
    constructor Create(ACollection: TIDObjects); override;
    destructor  Destroy; override;
  end;


  TCoreCollections = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TCoreCollection;
  public

    property Items[Index: integer]: TCoreCollection read GetItems;
    constructor Create; override;
  end;


  TCollectionWell = class(TWell)
  private
    FIsSamplesPresent: boolean;
    FCollectionSamples: TCollectionSamples;
    function GetCollectionSamples: TCollectionSamples;
    function GetCoreCollection: TCoreCollection;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property CoreCollection: TCoreCollection read GetCoreCollection;
    property CollectionSamples: TCollectionSamples read GetCollectionSamples;
    property IsSamplesPresent: boolean read FIsSamplesPresent write FIsSamplesPresent;
    procedure Accept(Visitor: IVisitor); override;    
  end;

  TCollectionWells = class(TWells)
  private
    function GetItems(Index: integer): TCollectionWell;
    function GetCoreCollection: TCoreCollection;
  public
    property CoreCollection: TCoreCollection read GetCoreCollection;
    property Items[Index: integer]: TCollectionWell read GetItems;
    constructor Create; override;
  end;


  TCollectionSample = class(TSimpleWellInterval)
  private
    FIsStratChecked: boolean;
    FIsElectroDescription: boolean;
    FIsDescripted: boolean;
    FPlacingComment: string;
    FRoomNum: integer;
    FAbsoluteDepth: single;
    FDepthFromBottom: single;
    FDepthFromTop: single;
    FBoxNumber: string;
    FSlottingNumber: string;
    FBindingComment: string;
    FAdditionalNumber: string;
    FSampleNumber: string;
    FLabNumber: string;
    FComment: string;
    FEnteringDate: TDateTime;
    FSamplingDate: TDateTime;
    FBottomStraton: TSimpleStraton;
    FTopStraton: TSimpleStraton;
    FCollectionSampleType: TCollectionSampleType;
    function GetWell: TCollectionWell;
    function GetRealDepth: Double;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property Well: TCollectionWell read GetWell;

    property Comment: string read FComment write FComment;
    property BindingComment: string read FBindingComment write FBindingComment;

    property SampleNumber: string read FSampleNumber write FSampleNumber;
    property DepthFromTop: single read FDepthFromTop write FDepthFromTop;
    property DepthFromBottom: single read FDepthFromBottom write FDepthFromBottom;
    property AbsoluteDepth: single read FAbsoluteDepth write FAbsoluteDepth;

    property SlottingNumber: string read FSlottingNumber write FSlottingNumber;
    property AdditionalNumber: string read FAdditionalNumber write FAdditionalNumber;
    property LabNumber: string read FLabNumber write FLabNumber;
    property IsDescripted: boolean read FIsDescripted write FIsDescripted;
    property IsElectroDescription: boolean read FIsElectroDescription write FIsElectroDescription;

    property EnteringDate: TDateTime read FEnteringDate write FEnteringDate;
    property SamplingDate: TDateTime read FSamplingDate write FSamplingDate;

    property TopStraton: TSimpleStraton read FTopStraton write FTopStraton;
    property BottomStraton: TSimpleStraton read FBottomStraton write FBottomStraton;
    property IsStratChecked: boolean read FIsStratChecked write FIsStratChecked;


    property RoomNum: integer read FRoomNum write FRoomNum;
    property BoxNumber: string read FBoxNumber write FBoxNumber;
    property PlacingComment: string read FPlacingComment write FPlacingComment;

    function List(AListOption: TListOption = loBrief): string; override;
    function ListStrat: string;
    property RealDepth: Double read GetRealDepth;

    // тип образца
    property SampleType: TCollectionSampleType read FCollectionSampleType write FCollectionSampleType;

    procedure Accept(Visitor: IVisitor); override;
  end;

  TCollectionSamples = class(TBaseWellIntervals)
  private
    function GetItems(Index: integer): TCollectionSample;
    function GetWell: TCollectionWell;
  public
    property Well: TCollectionWell read GetWell;
    property Items[Index: integer]: TCollectionSample read GetItems;
    constructor Create; override;
  end;

  TDenudation = class(TRegisteredIDObject)
  private
    FNumber: string;
    FCollectionSamples: TCollectionSamples;
    FIsSamplesPresent: boolean;
    function GetCollectionSamples: TCollectionSamples;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property IsSamplesPresent: boolean read FIsSamplesPresent write FIsSamplesPresent;
    property DenudationSamples: TCollectionSamples read GetCollectionSamples;
    property Number: string read FNumber write FNumber;
    procedure Accept(Visitor: IVisitor); override;
    function    List(AListOption: TListOption = loBrief): string; override;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TDenudations = class(TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TDenudation;
  public
    property Items[Index: integer]: TDenudation read GetItems;
    constructor Create; override;
  end;

  TWellCandidate = class(TRegisteredIDObject)
  private
    FAreaName: string;
    FWellNum: string;
    FReason: string;
    FPlacingDate: TDateTime;
    FIsSamplesPresent: boolean;
    FWellCandidateSamples: TCollectionSamples;
    function GetWellCandidateSamples: TCollectionSamples;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    property AreaName: string read FAreaName write FAreaName;
    property WellNum: string read FWellNum write FWellNum;
    property Reason: string read FReason write FReason;
    property PlacingDate: TDateTime read FPlacingDate write FPlacingDate;
    property IsSamplesPresent: boolean read FIsSamplesPresent write FIsSamplesPresent;
    property WellCandidateSamples: TCollectionSamples read GetWellCandidateSamples;
    procedure Accept(Visitor: IVisitor); override;    

    function List(AListOption: TListOption = loBrief): string; override;
    constructor Create(ACollection: TIDObjects); override;
    destructor Destroy; override;
  end;

  TWellCandidates = class(TRegisteredIDObjects)
  private
    function GetItems(Index: Integer): TWellCandidate;
  public
    property Items[Index: Integer]: TWellCandidate read GetItems;
    constructor Create; override;
  end;


implementation

uses SysUtils, Facade, CoreCollectionPoster, WellPoster;

{ TCoreCollction }

procedure TCoreCollection.AssignTo(Dest: TPersistent);
var c: TCoreCollection;
begin
  inherited;

  c := Dest as TCoreCollection;
  c.OwnerName := OwnerName;
  c.OwnerEmp := OwnerEmp;
  c.AuthorName := AuthorName;
  c.AuthorEmp := AuthorEmp;
  c.CoreCollectionType := CoreCollectionType;
  c.FossilType := FossilType;
  c.BaseStraton := BaseStraton;
  c.TopStraton := TopStraton;
end;

constructor TCoreCollection.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Коллекция';
  // устанавливаем ссылку на шлюз материализации
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TCoreCollectionPoster];
end;

function TCoreCollection.GetAuthorName: string;
begin
  // если имеется автор-сотрудник ТП НИЦ - то берем его
  if Assigned(AuthorEmp) then
    Result := AuthorEmp.List(loBrief)
  else // в противном случае записанного в поле имени автора
    Result := FAuthorName;
end;

function TCoreCollection.GetCollectionWells: TCollectionWells;
begin
  // в случае если обращения к набору скважин коллекции не было и он не создан
  if not Assigned(FCollectionWells) then
  begin
    // создаем указывая, что владельцем набора является данная коллекция
    FCollectionWells := TCollectionWells.Create;
    FCollectionWells.Owner := Self;
    // запрашиваем набор скважин из БД 
    FCollectionWells.Reload('Collection_ID = ' + IntToStr(ID));
  end;
  Result := FCollectionWells;  
end;

function TCoreCollection.GetOwnerName: string;
begin
  if Assigned(OwnerEmp) then
    Result := OwnerEmp.List(loBrief)
  else
    Result := FOwnerName;
end;

destructor TCoreCollection.Destroy;
begin
  FreeAndNil(FCollectionWells);
  FreeAndNil(FAllDenudations);
  FreeAndNil(FWellCandidates);
  inherited;
end;

function TCoreCollection.List(AListOption: TListOption): string;
begin
  Result := inherited List(AListOption);
end;

function TCoreCollection.Update(ACollection: TIDObjects = nil): integer;
begin
  Result := inherited Update;
end;

{ TCoreCollections }

constructor TCoreCollections.Create;
begin
  inherited;
  FObjectClass := TCoreCollection;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TCoreCollectionPoster];
end;

function TCoreCollections.GetItems(Index: integer): TCoreCollection;
begin
  Result := inherited Items[Index] as TCoreCollection;
end;

{ TFossilTypes }

constructor TFossilTypes.Create;
begin
  inherited;
  FObjectClass := TFossilType;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TFossilTypePoster];
end;

function TFossilTypes.GetItems(Index: integer): TFossilType;
begin
  Result := inherited Items[Index] as TFossilType;
end;

{ TCoreCollectionTypes }

constructor TCoreCollectionTypes.Create;
begin
  inherited;
  FObjectClass := TCoreCollectionType;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TCollectionTypePoster];
end;

function TCoreCollectionTypes.GetItems(
  Index: integer): TCoreCollectionType;
begin
  Result := inherited Items[Index] as TCoreCollectionType; 
end;



{ TCollectionWells }

constructor TCollectionWells.Create;
begin
  inherited;
  FObjectClass := TCollectionWell;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TCollectionWellPoster];
  OwnsObjects := true;
end;

function TCollectionWells.GetCoreCollection: TCoreCollection;
begin
  Result := Owner as TCoreCollection;
end;

function TCollectionWells.GetItems(Index: integer): TCollectionWell;
begin
  Result := inherited Items[Index] as TCollectionWell;
end;

{ TCollectionWell }

procedure TCollectionWell.Accept(Visitor: IVisitor);
begin
  Visitor.VisitCollectionWell(Self);
end;

procedure TCollectionWell.AssignTo(Dest: TPersistent);
begin
  inherited;
  (Dest as TCollectionWell).IsSamplesPresent := IsSamplesPresent;
end;

function TCollectionWell.GetCollectionSamples: TCollectionSamples;
begin
  if not Assigned(FCollectionSamples) then
  begin
    FCollectionSamples := TCollectionSamples.Create;
    FCollectionSamples.Owner := Self;
    FCollectionSamples.Reload('Collection_ID = ' + IntToStr(CoreCollection.ID) + ' and ' +
                              'Well_UIN = ' + IntToStr(ID));
  end;

  Result := FCollectionSamples;
end;

function TCollectionWell.GetCoreCollection: TCoreCollection;
begin
  Result := (Collection as TCollectionWells).CoreCollection;
end;

{ TCollectionSamples }

constructor TCollectionSamples.Create;
begin
  inherited;
  FObjectClass := TCollectionSample;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TCollectionSamplePoster];
  OwnsObjects := true;
end;

function TCollectionSamples.GetItems(Index: integer): TCollectionSample;
begin
  Result := inherited Items[Index] as TCollectionSample;
end;

function TCollectionSamples.GetWell: TCollectionWell;
begin
  Result := Owner as TCollectionWell;
end;

{ TCollectionSample }

procedure TCollectionSample.Accept(Visitor: IVisitor);
begin
  Visitor.VisitCollectionSample(Self);
end;

procedure TCollectionSample.AssignTo(Dest: TPersistent);
var cs: TCollectionSample;
begin
  inherited;
  cs := Dest as TCollectionSample;

  cs.Comment := Comment;
  cs.BindingComment := BindingComment;
  cs.SampleNumber := SampleNumber;
  cs.DepthFromTop := DepthFromTop;
  cs.DepthFromBottom := DepthFromBottom;
  cs.AbsoluteDepth  := AbsoluteDepth;
  cs.SlottingNumber := SlottingNumber;
  cs.AdditionalNumber := AdditionalNumber;
  cs.LabNumber := LabNumber;
  cs.IsDescripted := IsDescripted;
  cs.IsElectroDescription := IsElectroDescription;
  cs.EnteringDate := EnteringDate;
  cs.SamplingDate := SamplingDate;
  cs.TopStraton := TopStraton;
  cs.BottomStraton := BottomStraton;
  cs.IsStratChecked := IsStratChecked;
  cs.RoomNum := RoomNum;
  cs.BoxNumber := BoxNumber;
  cs.PlacingComment := PlacingComment;
  cs.SampleType := SampleType;
end;

function TCollectionSample.GetRealDepth: Double;
begin
  Result := 0; 
  if AbsoluteDepth > 0 then
    Result := AbsoluteDepth
  else
  begin
    if DepthFromTop > 0 then
      Result := Top + DepthFromTop + (Owner as TCollectionWell).Altitude
    else if DepthFromBottom > 0 then
      Result := Bottom - DepthFromBottom + (Owner as TCollectionWell).Altitude;
  end;

  if Result = 0 then
    Result := Top;
end;

function TCollectionSample.GetWell: TCollectionWell;
begin
  Result := (Collection as TCollectionSamples).Well;
end;

function TCollectionSample.List(AListOption: TListOption): string;
begin
  Result := SlottingNumber + '/' + SampleNumber;

  if Trim(AdditionalNumber) <> '' then
    Result := Result + '(' + AdditionalNumber + ')';

  Result := Result  + ' [' + Format('%.2f', [RealDepth]) + ' м]';
end;

function TCollectionSample.ListStrat: string;
begin
  Result := '';
  if Assigned(TopStraton) then
    Result := TopStraton.List;

  if Assigned(BottomStraton) then
  begin
    if trim(Result) <> '' then Result := Result + ' - ';

    Result := Result + BottomStraton.List;
  end;
end;

{ TCollectionSampleTypes }

constructor TCollectionSampleTypes.Create;
begin
  inherited;
  FObjectClass := TCollectionSampleType;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TCollectionSampleTypePoster];
end;

function TCollectionSampleTypes.GetItems(Index: integer): TCollectionSampleType;
begin
  result := inherited Items[index] as TCollectionSampleType;
end;

{ TCollectionSampleType }

constructor TCollectionSampleType.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Тип образца в коллекции';
  // устанавливаем ссылку на шлюз материализации
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TCollectionSampleTypePoster];
end;

{ TCoreCollectionType }

constructor TCoreCollectionType.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Тип коллекции';
  // устанавливаем ссылку на шлюз материализации
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TCollectionTypePoster];
end;

{ TFossilType }

constructor TFossilType.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Тип органических остатков';
  // устанавливаем ссылку на шлюз материализации
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TFossilTypePoster];
end;

{ TDenudation }

procedure TDenudation.Accept(Visitor: IVisitor);
begin
  Visitor.VisitDenudation(Self);
end;

procedure TDenudation.AssignTo(Dest: TPersistent);
begin
  inherited;
  (Dest as TDenudation).Number := Number;
  (Dest as TDenudation).IsSamplesPresent := IsSamplesPresent;
end;

constructor TDenudation.Create(ACollection: TIDObjects);
begin
  inherited;
  FClassIDString := 'Обнажение';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TDenudationDataPoster];
end;

function TDenudation.GetCollectionSamples: TCollectionSamples;
begin
  if not Assigned(FCollectionSamples) then
  begin
    FCollectionSamples := TCollectionSamples.Create;
    FCollectionSamples.Owner := Self;
    //FCollectionSamples.Reload('Collection_ID = ' + IntToStr(TMainFacade.GetInstance.ActiveCollection.ID) + ' and ' +
    //                          'Denudation_ID = ' + IntToStr(ID));
  end;

  Result := FCollectionSamples;
end;


function TDenudation.List(AListOption: TListOption): string;
begin
  Result := Name;

  if Trim(Number) <> '' then
    Result := Result + ' - ' + Number;
end;

{ TDenudations }

constructor TDenudations.Create;
begin
  inherited;
  FObjectClass := TDenudation;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TDenudationDataPoster]; 
end;

function TDenudations.GetItems(Index: integer): TDenudation;
begin
  Result := inherited Items[Index] as TDenudation;
end;

function TCoreCollection.GetAllDenudations: TDenudations;
begin
  if not Assigned(FAllDenudations) then
  begin
    FAllDenudations := TDenudations.Create;
    FAllDenudations.Owner := Self;
    FAllDenudations.Reload('', True);
  end;

  Result := FAllDenudations;
end;

{ TWellCandidate }

procedure TWellCandidate.Accept(Visitor: IVisitor);
begin
  Visitor.VisitWellCandidate(Self);
end;

procedure TWellCandidate.AssignTo(Dest: TPersistent);
begin
  inherited;
  (Dest as TWellCandidate).AreaName := AreaName;
  (Dest as TWellCandidate).WellNum := WellNum;
  (Dest as TWellCandidate).Reason := Reason;
  (Dest as TWellCandidate).PlacingDate := PlacingDate;
  (Dest as TWellCandidate).IsSamplesPresent := IsSamplesPresent;
end;

constructor TWellCandidate.Create(ACollection: TIDObjects);
begin
  inherited;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TWellCandidateDataPoster];
  FClassIDString := 'Скважина-кандидат';
end;

destructor TWellCandidate.Destroy;
begin
  FreeAndNil(FWellCandidateSamples);
  inherited;
end;

function TWellCandidate.GetWellCandidateSamples: TCollectionSamples;
begin
  if not Assigned(FWellCandidateSamples) then
  begin
    FWellCandidateSamples := TCollectionSamples.Create;
    FWellCandidateSamples.Owner := Self;
    FWellCandidateSamples.Reload('Well_Candidate_UIN = ' + IntToStr(ID));
  end;

  Result := FWellCandidateSamples;
end;

function TWellCandidate.List(AListOption: TListOption): string;
begin
  Result := Trim(WellNum);

  if (Result <> '') then
  begin
    if (trim(AreaName) <> '') then
      Result := Result + ' - ' + AreaName;
  end
  else Result := trim(AreaName);
end;

{ TWellCandidates }

constructor TWellCandidates.Create;
begin
  inherited;
  FObjectClass := TWellCandidate;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TWellCandidateDataPoster];
end;

function TWellCandidates.GetItems(Index: Integer): TWellCandidate;
begin
  Result := inherited Items[Index] as TWellCandidate;
end;

function TCoreCollection.GetWellCandidates: TWellCandidates;
begin
  if not Assigned(FWellCandidates) then
  begin
    FWellCandidates := TWellCandidates.Create;
    FWellCandidates.Owner := Self;
    FWellCandidates.Reload('', true);
  end;

  result := FWellCandidates;
end;

procedure TCoreCollection.SetName(const Value: string);
begin
  inherited;
  Registrator.Update(Self, nil, ukUpdate);
end;

end.
