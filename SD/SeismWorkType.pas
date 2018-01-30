unit SeismWorkType;

interface

uses BaseObjects, Registrator, SeismicObject, Work, Classes, SysUtils;

type
  TSimpleSeismWorkType = class (TRegisteredIDObject)
  private
    FWorks: TSeismicWorkTypes;

    function GetWorks: TSeismicWorkTypes;
  public
    function    List(AListOption: TListOption = loBrief): string; override;
    property    Works: TSeismicWorkTypes read GetWorks;

    constructor Create(ACollection: TIDObjects); override;
  end;

  TSimpleSeismWorkTypes = class (TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TSimpleSeismWorkType;
  public
    property    Items[Index: integer]: TSimpleSeismWorkType read GetItems;
    constructor Create; override;
  end;

  TSeismWorkType = class (TSimpleSeismWorkType)
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TSeismWorkTypes = class (TSimpleSeismWorkTypes)
  private
    function GetItems(Index: integer): TSeismWorkType;
  public
    property    Items[Index: integer]: TSeismWorkType read GetItems;

    constructor Create; override;
  end;

implementation

uses Facade, BaseFacades, SeismWorkTypePoster, Math;

{ TSeismWorkTypes }

constructor TSeismWorkTypes.Create;
begin
  inherited;
  FObjectClass := TSeismWorkType;
end;

function TSeismWorkTypes.GetItems(Index: integer): TSeismWorkType;
begin
  Result := inherited Items[Index] as TSeismWorkType;
end;

{ TSeismWorkType }

constructor TSeismWorkType.Create(ACollection: TIDObjects);
begin
  inherited;
  FClassIDString := 'Тип сейсмических работ';
end;



{ TSimpleSeismWorkTypes }

constructor TSimpleSeismWorkTypes.Create;
begin
  inherited;
  FObjectClass := TSimpleSeismWorkType;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TSeismWorkTypeDataPoster];
end;

function TSimpleSeismWorkTypes.GetItems(Index: integer): TSimpleSeismWorkType;
begin
  Result := inherited Items[Index] as TSimpleSeismWorkType;
end;

{ TSimpleSeismWorkType }

constructor TSimpleSeismWorkType.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Простой тип сейсмических работ';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TSeismWorkTypeDataPoster];
end;

function TSimpleSeismWorkType.GetWorks: TSeismicWorkTypes;
begin
  If not Assigned (FWorks) then
  begin
    FWorks := TSeismicWorkTypes.Create;
    FWorks.OwnsObjects := true;
    FWorks.Owner := Self;
    FWorks.Reload('SEISMWORK_TYPE_ID = ' + IntToStr(ID));
  end;

  Result := FWorks;
end;

function TSimpleSeismWorkType.List(AListOption: TListOption): string;
begin
  Result := StringReplace(inherited List(AListOption), '(-ое)', '', [rfReplaceAll]);
end;

end.
