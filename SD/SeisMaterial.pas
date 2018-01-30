unit SeisMaterial;

interface

uses BaseObjects, Registrator, Classes, Material, Structure, ComCtrls, Ex_Grid;

type 
    // тип сейс работ
  TSeisWorkType = class (TRegisteredIDObject)
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TSeisWorkTypes = class (TRegisteredIDObjects)
  private
    function    GetItems(Index: Integer): TSeisWorkType;
  public
    property    Items[Index: Integer]: TSeisWorkType read GetItems;

    constructor Create; override;
  end;



  // метод сейс работ
  TSeisWorkMethod = class (TRegisteredIDObject)

  public
    function Update(ACollection: TIDObjects=nil):Integer;override;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TSeisWorkMethods = class (TRegisteredIDObjects)
  private
    function    GetItems(Index: Integer): TSeisWorkMethod;
  public
    property    Items[Index: Integer]: TSeisWorkMethod read GetItems;
    constructor Create; override;
  end;

  // сейсмопартия
  TSeisCrew = class (TRegisteredIDObject)
  private
    FSeisCrewNumber:Integer;
  protected
  procedure AssignTo(Dest: TPersistent); override;
  public
    property    SeisCrewNumber: Integer read FSeisCrewNumber write FSeisCrewNumber;
    function    List(AListOption: TListOption = loBrief): string; override;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TSeisCrews = class (TRegisteredIDObjects)
  private
    function    GetItems(Index: Integer): TSeisCrew;
  public
    property    Items[Index: Integer]: TSeisCrew read GetItems;
    constructor Create; override;
  end;

  // отчет сейсморазведки
  TSeismicMaterial = class (TRegisteredIDObject)
  private
    FSeisWorkType: TSeisWorkType;
    FSeisWorkMethod: TSeisWorkMethod;
    FSeisCrew: TSeisCrew;
    FSimpleDocument:TSimpleDocument;
    //FStructure:TStructure;
    FBeginWorksDate:TDateTime;
    FEndWorksDate:TDateTime;
    FReferenceComposition:string;
    FSeisWorkScale:Integer;
    FStructMapReflectHorizon:string;
    FCrossSection:string;

  protected
  procedure AssignTo(Dest: TPersistent); override;
  public
    property    SeisWorkType: TSeisWorkType read FSeisWorkType write FSeisWorkType;
    property    SeisWorkMethod: TSeisWorkMethod read FSeisWorkMethod write FSeisWorkMethod;
    property    SeisCrew: TSeisCrew read FSeisCrew write FSeisCrew;
    property    SimpleDocument: TSimpleDocument read FSimpleDocument write FSimpleDocument;
    property    BeginWorksDate: TDateTime read FBeginWorksDate write FBeginWorksDate;
    property    EndWorksDate: TDateTime read FEndWorksDate write FEndWorksDate;
    property    ReferenceComposition: string read FReferenceComposition write FReferenceComposition;
    property    SeisWorkScale: Integer read FSeisWorkScale write FSeisWorkScale;
    property    StructMapReflectHorizon: string read FStructMapReflectHorizon write FStructMapReflectHorizon;
    property    CrossSection: string read FCrossSection write FCrossSection;
    //property    Structure:TStructure read FStructure write FStructure;
    function    List(AListOption: TListOption = loBrief): string; override;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TSeismicMaterials = class (TRegisteredIDObjects)
  private
    function    GetItems(Index: Integer): TSeismicMaterial;
  public
    property    Items[Index: Integer]: TSeismicMaterial read GetItems;

    constructor Create; override;
  end;

implementation

uses Facade, SeisMaterialPoster,SysUtils;

{ TSeisWorkType }



constructor TSeisWorkType.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Тип сейсморазведочных работ';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TSeisWorkTypeDataPoster];
end;

{ TTSeisWorkTypes }



constructor TSeisWorkTypes.Create;
begin
  inherited;
  FObjectClass := TSeisWorkType;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TSeisWorkTypeDataPoster];
end;

function TSeisWorkTypes.GetItems(Index: Integer): TSeisWorkType;
begin
  Result := inherited Items[Index] as TSeisWorkType;
end;




{ TSeisWorkMethod }



constructor TSeisWorkMethod.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Метод сейсморазведочных работ';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TSeisWorkMethodDataPoster];
end;

function TSeisWorkMethod.Update(ACollection: TIDObjects): Integer;
begin
Result:=inherited Update;
end;

{ TSeisWorkMethods }



constructor TSeisWorkMethods.Create;
begin
  inherited;
  FObjectClass := TSeisWorkMethod;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TSeisWorkMethodDataPoster];
end;

function TSeisWorkMethods.GetItems(Index: Integer): TSeisWorkMethod;
begin
  Result := inherited Items[Index] as TSeisWorkMethod;
end;

{ TSeisCrew }



procedure TSeisCrew.AssignTo(Dest: TPersistent);
var o:TSeisCrew;
begin
  inherited;
  o := Dest as TSeisCrew;

  o.FSeisCrewNumber:=SeisCrewNumber;
end;

constructor TSeisCrew.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Сейсмопартия';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TSeisCrewDataPoster];
end;

function TSeisCrew.List(AListOption: TListOption): string;
begin
Result:=IntToStr(SeisCrewNumber);
end;

{ TSeisCrews }



constructor TSeisCrews.Create;
begin
  inherited;
  FObjectClass := TSeisCrew;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TSeisCrewDataPoster];
end;

function TSeisCrews.GetItems(Index: Integer): TSeisCrew;
begin
  Result := inherited Items[Index] as TSeisCrew;
end;







{ TSeismicMaterial }

procedure TSeismicMaterial.AssignTo(Dest: TPersistent);
var o:TSeismicMaterial;
begin
  inherited;
  o := Dest as TSeismicMaterial;

  o.FSeisWorkType:=SeisWorkType;
  o.FSeisWorkMethod:=SeisWorkMethod;
  o.FSeisCrew:=SeisCrew;
  o.FSimpleDocument:=SimpleDocument;
  o.FBeginWorksDate:=BeginWorksDate;
  o.FEndWorksDate:=EndWorksDate;
  o.FReferenceComposition:=ReferenceComposition;
  o.FCrossSection:=CrossSection;
  o.FStructMapReflectHorizon:=StructMapReflectHorizon;
  o.FSeisWorkScale:=SeisWorkScale;

end;

constructor TSeismicMaterial.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Отчет о сейсморазведочных работах';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TSeismicMaterialDataPoster];
end;

function TSeismicMaterial.List(AListOption: TListOption): string;
begin
Result:=SimpleDocument.List;
end;

{ TSeismicMaterials }

constructor TSeismicMaterials.Create;
begin
  inherited;
  FObjectClass := TSeismicMaterial;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TSeismicMaterialDataPoster];
end;

function TSeismicMaterials.GetItems(Index: Integer): TSeismicMaterial;
begin
  Result := inherited Items[Index] as TSeismicMaterial;
end;


end.
