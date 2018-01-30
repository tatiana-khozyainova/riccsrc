unit GRRObligation;

interface

uses Registrator, BaseObjects, Classes, MeasureUnits, Version,
       State, Well, SeismicObject,Area, SeismWorkType;

type

   TSeismicObligationPlaces = class;
   TNirObligationPlaces = class;
   TDrillingObligationWells = class;
   TNIRObligations = class;
   TNirTypes = class;

   TNIRState = class (TRegisteredIDObject)
   public
     constructor Create(ACollection: TIDObjects); override;
   end;
   
   TNIRStates = class (TRegisteredIDObjects)
   private
     function GetItems(Index: integer): TNIRState;
   public
     property Items[Index: integer]: TNIRState read GetItems;
     constructor Create; override;
   end;

   TNIRType = class(TRegisteredIDObject)
   private
     FMain: TNIRType;
   public
     property Main: TNIRType read FMain write FMain;
     constructor Create(ACollection: TIDObjects); override;
   end;

   TNIRTypes = class (TRegisteredIDObjects)
   private
     function GetItems(Index: integer): TNIRType;
   public
     property Items[Index: integer]: TNIRType read GetItems;
     constructor Create; override;
   end;

   TObligation = class(TRegisteredIDObject)
   private
     FStartDate: TDateTime;
     FFinishDate: TDateTime;
     FComment: string;
     FNIRState: TNIRState;
     FNirType : TNirType;
    function GetDoneString: string;
   protected
     function GetDone: boolean; virtual;
     procedure AssignTo(Dest: TPersistent); override;
   public
     property StartDate: TDateTime read FStartDate write FStartDate;
     property FinishDate: TDateTime read FFinishDate write FFinishDate;
     property Comment: string read FComment write FComment;
     property NIRState: TNIRState read FNIRState write FNIRState;
     property NirType: TNirType read FNirType write FNirType;
     property Done: boolean read GetDone;
     property DoneString: string read GetDoneString;
     constructor Create(ACollection: TIDObjects); override;
   end;

   TObligations = class(TRegisteredIDObjects)
   private
     function GetItems(Index: integer): TObligation;
   public
     function GetSimilarObligation(AObligation: TObligation): TObligation; virtual;
     procedure Copy(ASourceObligations: TObligations);
     procedure Sort;
     property Items[Index: integer]: TObligation read GetItems;
     constructor Create; override;
   end;

   TObligationsClass = class of TObligations;

   TNIRObligation = class(TObligation)
   private
   
      FDateCondition: string;
      FFactCost: Double;
      FVolume: Double;
      FMainObligation: TNIRObligation;
      FForFieldOnly: Integer;
      FMeasureUnit: TMeasureUnit;

      FNirObligationPlaces:  TNirObligationPlaces;
      function GetNirObligationPlaces:  TNirObligationPlaces;
   protected
      function GetDone: Boolean; override;
      procedure AssignTo(Dest: TPersistent); override;      
   public
      property ObligationPlaces:  TNirObligationPlaces read GetNirObligationPlaces;

      property DateCondition: string read FDateCondition write FDateCondition;
      property FactCost: Double read FFactCost write FFactCost;
      property Volume: Double read FVolume write FVolume;
      property MainObligation: TNIRObligation read FMainObligation  write FMainObligation;
      property ForFieldOnly: integer read FForFieldOnly write FForFieldOnly;
      property MeasureUnit: TMeasureUnit read FMeasureUnit write FMeasureUnit;

      constructor Create(ACollection: TIDObjects); override;
   end;

   TNIRObligations = class(TObligations)
   private
     function GetItems(Index: integer): TNIRObligation;
   public
     function GetSimilarObligation(AObligation: TObligation): TObligation; override;   
     property Items[Index: integer]: TNIRObligation read GetItems;
     constructor Create; override;
   end;

   TSeismicObligation = class (TObligation)
   private
     FSeismWorkType: TSeismWorkType;
     FVolume: Double;
     FVolumeInGRRProgram: boolean;
     FFactVolume: Double;
     FCost: Double;
     FSeismicObligationPlaces: TSeismicObligationPlaces;
     function GetSeismicObligationPlaces: TSeismicObligationPlaces;
   protected
     function GetDone: boolean; override;
     procedure AssignTo(Dest: TPersistent); override;
   public
     property ObligationPlaces: TSeismicObligationPlaces read GetSeismicObligationPlaces;

     property SeisWorkType: TSeismWorkType read FSeismWorkType write FSeismWorkType;
     property Volume: Double read FVolume write FVolume;
     property VolumeInGRRProgram: boolean read FVolumeInGRRProgram write FVolumeInGRRProgram;
     property FactVolume: Double read FFactVolume write FFactVolume;
     property Cost: Double read FCost write FCost;
     constructor Create(ACollection: TIDObjects); override;
   end;

   TSeismicObligations = class (TObligations)
   private
     function GetItems(Index: integer): TSeismicObligation;
   public
     function GetSimilarObligation(AObligation: TObligation): TObligation; override;   
     property Items[Index: integer]: TSeismicObligation read GetItems;
     constructor Create; override;
   end;

   TDrillObligation = class(TObligation)
   private
     FWellState: TState;
     FWellCategory: TWellCategory;
     FWellCount: Integer;
     FWellCountIsUndefined: Integer;
     FFactCost: Double;
     FDrillObligationWells: TDrillingObligationWells;
     
     function GetDrillObligationWells: TDrillingObligationWells;
     function GetWellCategory: TWellCategory;
   protected
     function GetDone: boolean; override;
     procedure AssignTo(Dest: TPersistent); override;     
   public
     property ObligationWells: TDrillingObligationWells read GetDrillObligationWells;

     
     property WellCategory: TWellCategory read GetWellCategory write FWellCategory;
     property WellCount: Integer read FWellCount write FWellCount;
     property WellCountIsUndefined: Integer read FWellCountIsUndefined write FWellCountIsUndefined;
     property WellState: TState read FWellState write FWellState;
     property FactCost: Double read FFactCost write FFactCost;
     constructor Create(ACollection: TIDObjects); override;
   end;

   TDrillObligations = class (TObligations)
   private
     function GetItems(Index: integer): TDrillObligation;
   public
     function GetSimilarObligation(AObligation: TObligation): TObligation; override;
     property Items[Index: integer]: TDrillObligation read GetItems;
     constructor Create; override;
   end;

   TNirObligationPlace = class (TRegisteredIDObject)
   private
     FStructure : TIDObject;
   public
     property Structure: TIDObject read FStructure write FStructure;
     constructor Create(ACollection: TIDObjects); override;
   end;

   TNirObligationPlaces = class (TRegisteredIDObjects)
   private
     function GetItems(Index: integer): TNirObligationPlace;
   public
     property Items[Index: integer]: TNirObligationPlace read GetItems;
     constructor Create; override;
   end;

   TSeismicObligationPlace = class (TRegisteredIDObject)
   private
     FStructure : TIDObject;
     FArea : TSimpleArea;
   public
     property Structure: TIDObject read FStructure write FStructure;
     property Area: TSimpleArea read FArea write FArea;
     constructor Create(ACollection: TIDObjects); override;
   end;

   TSeismicObligationPlaces = class (TRegisteredIDObjects)
   private
     function GetItems(Index: integer): TSeismicObligationPlace;
   public
     property Items[Index: integer]: TSeismicObligationPlace read GetItems;
     constructor Create; override;
   end;

   TDrillingObligationWell = class (TRegisteredIDObject)
   private
     FStructure : TIDObject;
     FWell : TWell;
     FNirState : TNIRState;
     FDrillingRate : Double;
     FFactCost : Double;
     FDrillingComment : string;
   public
     property Structure: TIDObject read FStructure write FStructure;
     property Well: TWell read FWell write FWell;
     property NirState: TNirState read FNirState write FNirState;
     property DrillingRate: Double read FDrillingRate write FDrillingRate;
     property FactCost: Double read FFactCost write FFactCost;
     property DrillingComment: string read FDrillingComment write FDrillingComment;
     constructor Create(ACollection: TIDObjects); override;
   end;

   TDrillingObligationWells = class (TRegisteredIDObjects)
   private
     function GetItems(Index: integer): TDrillingObligationWell;
   public
     property Items[Index: integer]: TDrillingObligationWell read GetItems;
     constructor Create; override;
   end;

implementation

uses Facade, GRRParameterPoster, SysUtils, Contnrs,
     SDFacade, SeismWorkTypePoster, GRRObligationPoster, LicenseZone, Structure,
  DateUtils;


function CompareObligations(Item1, Item2: Pointer): Integer;
var d1, d2: TObligation;
begin
  d1 := TObligation(Item1);
  d2 := TObligation(Item2);
  if (d1.FinishDate = 0) and (d2.FinishDate <> 0) then Result := 1
  else if (d2.FinishDate = 0) and (d1.FinishDate <> 0) then Result := -1
  else Result := CompareDateTime(d1.FinishDate, d2.FinishDate);
end;

{ TObligation }



procedure TObligation.AssignTo(Dest: TPersistent);
var o: TObligation;
begin
  inherited;

  o := Dest as TObligation;
  o.StartDate := StartDate;
  o.FinishDate := FinishDate;
  o.Comment := Comment;
  o.NIRState := NIRState;
  o.NirType := NirType;
end;

constructor TObligation.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Обязательство';
  //FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TDataPoster];
end;


function TObligation.GetDone: boolean;
begin
  Result := false;
end;

function TObligation.GetDoneString: string;
begin
  if Done then Result := 'Выполнено'
  else Result := 'Не выполнено';
end;

{ TObligations }

procedure TObligations.Copy(ASourceObligations: TObligations);
var i: Integer;
    o: TObligation;
begin
  o := nil;
  for i := 0 to ASourceObligations.Count - 1 do
  begin
    if ASourceObligations.Items[i].ID <> 0 then o := ItemsById[ASourceObligations.Items[i].ID] as TObligation;
    if not Assigned(o) then o := GetSimilarObligation(ASourceObligations.Items[i]);
    if not Assigned(o) then o := Add as TObligation;

    o.Assign(ASourceObligations.Items[i]);
  end;
end;

constructor TObligations.Create;
begin
  inherited;
  FObjectClass := TObligation;
end;

function TObligations.GetItems(Index: integer): TObligation;
begin
  Result := inherited Items[Index] as TObligation;
end;

function TObligations.GetSimilarObligation(
  AObligation: TObligation): TObligation;
begin
  Result := nil;
end;

procedure TObligations.Sort;
begin
  inherited Sort(CompareObligations);
end;

{ TNIRType }

constructor TNIRType.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Тип обязательства по НИР';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TNIRTypeDataPoster];
end;

{ TNIRTypes }

constructor TNIRTypes.Create;
begin
  inherited;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TNIRTypeDataPoster];
  FObjectClass := TNIRType;
end;

function TNIRTypes.GetItems(Index: integer): TNIRType;
begin
  Result := inherited Items[Index] as TNIRType;
end;

{ TNIRState }

constructor TNIRState.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Этап НИР';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TNIRStateDataPoster];
end;

{ TNIRStates }

constructor TNIRStates.Create;
begin
  inherited;
  FObjectClass := TNirState;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TNIRStateDataPoster];
end;

function TNIRStates.GetItems(Index: integer): TNIRState;
begin
  Result := inherited Items[Index] as TNIRState;
end;

{ TNIRObligation }

procedure TNIRObligation.AssignTo(Dest: TPersistent);
var o: TNIRObligation;
begin
  inherited;

  o := Dest as TNIRObligation;
  o.DateCondition := DateCondition;
  o.FactCost := FactCost;
  o.Volume := Volume;
  o.MainObligation := o.MainObligation;
  o.ForFieldOnly := ForFieldOnly;
  o.MeasureUnit := MeasureUnit;
  //o.ObligationPlaces.Assign(ObligationPlaces);
end;

constructor TNIRObligation.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'обязательство по НИР';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TNIRDataPoster];
  Name := '';
end;


function TNIRObligation.GetDone: Boolean;
begin
  Result := FactCost > 0;
end;

function TNIRObligation.GetNirObligationPlaces: TNirObligationPlaces;
begin
   if not Assigned(FNirObligationPlaces) then
  begin
    FNirObligationPlaces := TNirObligationPlaces.Create;
    FNirObligationPlaces.Owner := Self;
    FNirObligationPlaces.Reload(Format('Obligation_ID = %s and Version_ID = %s',[IntToStr(Id), TMainFacade.GetInstance.ActiveVersion.ID]));
  end;
  Result :=  FNirObligationPlaces;
end;

{ TNIRObligations }

constructor TNIRObligations.Create;
begin
  inherited;
  FObjectClass := TNirObligation;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TNIRDataPoster];
end;

function TNIRObligations.GetItems(Index: integer): TNIRObligation;
begin
   Result := inherited Items[Index] as TNIRObligation;
end;


function TNIRObligations.GetSimilarObligation(
  AObligation: TObligation): TObligation;
var i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if (Items[i].Name = AObligation.Name) and (Items[i].FinishDate = AObligation.FinishDate) then
  begin
    Result := Items[i];
    Break;
  end;
end;

{ TSeismicObligation }

procedure TSeismicObligation.AssignTo(Dest: TPersistent);
var o: TSeismicObligation;
begin
  inherited;

  o := Dest as TSeismicObligation;
  o.SeisWorkType := SeisWorkType;
  o.Volume := Volume;
  o.VolumeInGRRProgram := VolumeInGRRProgram;
  o.FactVolume := FactVolume;
  o.Cost := Cost;
  //o.ObligationPlaces.Assign(ObligationPlaces);
end;

constructor TSeismicObligation.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'обязательство по сейсморазведочным работам';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TSeismicObligationDataPoster];
end;

function TSeismicObligation.GetDone: boolean;
begin
  Result := Cost > 0;
end;

function TSeismicObligation.GetSeismicObligationPlaces: TSeismicObligationPlaces;
begin
  if not Assigned(FSeismicObligationPlaces) then
  begin
    FSeismicObligationPlaces := TSeismicObligationPlaces.Create;
    FSeismicObligationPlaces.Owner := Self;
    FSeismicObligationPlaces.Reload(Format('Obligation_ID = %s and Version_ID = %s',[IntToStr(Id), TMainFacade.GetInstance.ActiveVersion.ID]));
  end;

  Result := FSeismicObligationPlaces;
end;

{ TSeismicObligations }
constructor TSeismicObligations.Create;
begin
  inherited;
  FObjectClass := TSeismicObligation;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TSeismicObligationDataPoster];
end;

function TSeismicObligations.GetItems(Index: integer): TSeismicObligation;
begin
    Result := inherited Items[Index] as TSeismicObligation;
end;


function TSeismicObligations.GetSimilarObligation(
  AObligation: TObligation): TObligation;
var i: Integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if (Items[i].SeisWorkType = (AObligation as TSeismicObligation).SeisWorkType) and (Items[i].StartDate = AObligation.StartDate) and (Items[i].FinishDate = AObligation.FinishDate) then
  begin
    Result := Items[i];
    Break;
  end;
end;

{ TDrillObligation }

procedure TDrillObligation.AssignTo(Dest: TPersistent);
var o: TDrillObligation;
begin
  inherited;
  o := Dest as TDrillObligation;

  o.WellState := WellState;
  o.WellCategory := WellCategory;
  o.WellCount := WellCount;
  o.WellCountIsUndefined := WellCountIsUndefined;
  o.FactCost := FactCost;
  //o.ObligationWells.Assign(ObligationWells);
end;

constructor TDrillObligation.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'обязательство по бурению';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TDrillingObligationDataPoster];
end;

function TDrillObligation.GetDone: boolean;
begin
  Result := FactCost > 0;
end;

function TDrillObligation.GetDrillObligationWells: TDrillingObligationWells;
begin
 if not Assigned(FDrillObligationWells) then
  begin
    FDrillObligationWells := TDrillingObligationWells.Create;
    FDrillObligationWells.Owner := Self;
    FDrillObligationWells.Reload(Format('Obligation_ID = %s and Version_ID = %s',[IntToStr(Id), TMainFacade.GetInstance.ActiveVersion.ID]));
  end;
  Result :=  FDrillObligationWells;
end;

function TDrillObligation.GetWellCategory: TWellCategory;
begin
  if not Assigned(FWellCategory) then FWellCategory := TNullWellCategory.GetInstance();
  Result := FWellCategory;
end;

{ TDrillObligations }
constructor TDrillObligations.Create;
begin
  inherited;
  FObjectClass := TDrillObligation;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TDrillingObligationDataPoster];
end;

function TDrillObligations.GetItems(Index: integer): TDrillObligation;
begin
  Result := inherited Items[Index] as TDrillObligation;
end;


function TDrillObligations.GetSimilarObligation(
  AObligation: TObligation): TObligation;
var i: integer;
begin
  Result := nil;
  for i := 0 to Count - 1 do
  if (Items[i].WellCategory = (AObligation as TDrillObligation).WellCategory) and (Items[i].StartDate = AObligation.StartDate) and (Items[i].FinishDate = AObligation.FinishDate) then
  begin
    Result := Items[i];
    break;
  end;
end;

{ TNirObligationPlace }

constructor TNirObligationPlace.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'место проведения обязательства по НИР';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TNirObligationPlaceDataPoster];
end;

{ TNirObligationPlaces }

constructor TNirObligationPlaces.Create;
begin
  inherited;
  FObjectClass := TNirObligationPlace;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TNirObligationPlaceDataPoster];
end;

function TNirObligationPlaces.GetItems(
  Index: integer): TNirObligationPlace;
begin
   Result := inherited Items[Index] as TNirObligationPlace;
end;

{ TSeismicObligationPlace }

constructor TSeismicObligationPlace.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'место проведения обязательства по сейсморазведочным работам';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TSeismicObligationPlaceDataPoster];
end;

{ TSeismicObligationPlaces }

constructor TSeismicObligationPlaces.Create;
begin
  inherited;
  FObjectClass := TSeismicObligationPlace;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TSeismicObligationPlaceDataPoster];
end;

function TSeismicObligationPlaces.GetItems(
  Index: integer): TSeismicObligationPlace;
begin
  Result := inherited Items[Index] as TSeismicObligationPlace;
end;

{ TDrillingObligationWell }

constructor TDrillingObligationWell.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'обязательство по бурению скважины';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TDrillingObligationWellDataPoster];
end;

{ TDrillingObligationWells }

constructor TDrillingObligationWells.Create;
begin
  inherited;
  FObjectClass := TDrillingObligationWell;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TDrillingObligationWellDataPoster];
end;

function TDrillingObligationWells.GetItems(
  Index: integer): TDrillingObligationWell;
begin
  Result := inherited Items[Index] as TDrillingObligationWell;
end;

end.
