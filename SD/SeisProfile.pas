unit SeisProfile;

interface

uses BaseObjects, Registrator, Classes, SeisMaterial;

type

  // тип профиля
  TSeismicProfileType = class (TRegisteredIDObject)
  
  public
    constructor Create(ACollection: TIDObjects); override; 
  end;

  TSeismicProfileTypes = class (TRegisteredIDObjects)
  private
    function    GetItems(Index: Integer): TSeismicProfileType;
  public
    property    Items[Index: Integer]: TSeismicProfileType read GetItems;

    constructor Create; override;
  end;

  // сейсмический профиль
  TSeismicProfile = class (TRegisteredIDObject)
  private
    FSeismicMaterial: TSeismicMaterial;
    FSeismicProfileType: TSeismicProfileType;
    FSeisProfileNumber:Integer;
    FPiketBegin:Integer;
    FPiketEnd:Integer;
    FSeisProfileLenght:Double;
    FDateEntry:TDateTime;
    FSeisProfileComment:string;

  protected
  procedure AssignTo(Dest: TPersistent); override;
  public
    property    SeismicMaterial: TSeismicMaterial read FSeismicMaterial write FSeismicMaterial;
    property    SeismicProfileType: TSeismicProfileType read FSeismicProfileType write FSeismicProfileType;
    property    SeisProfileNumber: Integer read FSeisProfileNumber write FSeisProfileNumber;
    property    PiketBegin: Integer read FPiketBegin write FPiketBegin;
    property    PiketEnd: Integer read FPiketEnd write FPiketEnd;
    property    SeisProfileLenght: Double read FSeisProfileLenght write FSeisProfileLenght;
    property    DateEntry: TDateTime read FDateEntry write FDateEntry;
    property    SeisProfileComment: string read FSeisProfileComment write FSeisProfileComment;
    function    List(AListOption: TListOption = loBrief): string; override;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TSeismicProfiles = class (TRegisteredIDObjects)
  private
    function    GetItems(Index: Integer): TSeismicProfile;
  public
    property    Items[Index: Integer]: TSeismicProfile read GetItems;

    constructor Create; override;
  end;

  // координаты сейсмического профиля
  TSeismicProfileCoordinate = class (TRegisteredIDObject)
  private
    FSeismicProfile: TSeismicProfile;
    FCoordNumber:Integer;
    FCoordX:Double;
    FCoordY:Double;

  protected
  procedure AssignTo(Dest: TPersistent); override;
  public
    property    SeismicProfile: TSeismicProfile read FSeismicProfile write FSeismicProfile;
    property    CoordNumber: Integer read FCoordNumber write FCoordNumber;
    property    CoordX: Double read FCoordX write FCoordX;
    property    CoordY: Double read FCoordY write FCoordY;
    function    List(AListOption: TListOption = loBrief): string; override;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TSeismicProfileCoordinates = class (TRegisteredIDObjects)
  private
    function    GetItems(Index: Integer): TSeismicProfileCoordinate;
  public
    property    Items[Index: Integer]: TSeismicProfileCoordinate read GetItems;

    constructor Create; override;
  end;

implementation

uses Facade, SeisProfilePoster,SysUtils;
{ TSeismicProfileType }



constructor TSeismicProfileType.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Тип профиля';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TSeismicProfileTypeDataPoster];
end;

{ TSeismicProfileTypes }



constructor TSeismicProfileTypes.Create;
begin
  inherited;
  FObjectClass := TSeismicProfileType;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TSeismicProfileTypeDataPoster];
end;

function TSeismicProfileTypes.GetItems(Index: Integer): TSeismicProfileType;
begin
  Result := inherited Items[Index] as TSeismicProfileType;
end;

{ TProfileSeismic }



procedure TSeismicProfile.AssignTo(Dest: TPersistent);
var o:TSeismicProfile;
begin
  inherited;
  o := Dest as TSeismicProfile;

  o.FSeisProfileNumber:=SeisProfileNumber;
  o.FPiketBegin:=PiketBegin;
  o.FPiketEnd:=PiketEnd;
  o.FSeisProfileLenght:=SeisProfileLenght;
  o.FDateEntry:=DateEntry;
  o.FSeisProfileComment:=SeisProfileComment;
  o.FSeismicMaterial:=SeismicMaterial;
  o.FSeismicProfileType:=SeismicProfileType;
end;

constructor TSeismicProfile.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Сейсмический профиль';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TSeismicProfileDataPoster];
end;



{ TSeismicProfiles }



constructor TSeismicProfiles.Create;
begin
  inherited;
  FObjectClass := TSeismicProfile;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TSeismicProfileDataPoster];
end;

function TSeismicProfiles.GetItems(Index: Integer): TSeismicProfile;
begin
  Result := inherited Items[Index] as TSeismicProfile;
end;



{ TSeismicProfile }

function TSeismicProfile.List(AListOption: TListOption): string;
begin
Result:=IntToStr(SeisProfileNumber);
end;

procedure TSeismicProfileCoordinate.AssignTo(Dest: TPersistent);
var o:TSeismicProfileCoordinate;
begin
  inherited;
  o := Dest as TSeismicProfileCoordinate;

  o.FSeismicProfile:=SeismicProfile;
  o.FCoordNumber:=CoordNumber;
  o.FCoordX:=CoordX;
  o.FCoordY:=CoordY;

end;

constructor TSeismicProfileCoordinate.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Координаты профиля';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TSeismicProfileCoordinateDataPoster];
end;

{ TSeismicProfiles }



constructor TSeismicProfileCoordinates.Create;
begin
  inherited;
  FObjectClass := TSeismicProfileCoordinate;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TSeismicProfileCoordinateDataPoster];
end;

function TSeismicProfileCoordinates.GetItems(Index: Integer): TSeismicProfileCoordinate;
begin
  Result := inherited Items[Index] as TSeismicProfileCoordinate;
end;

function TSeismicProfileCoordinate.List(AListOption: TListOption): string;
begin
Result:='№'+IntToStr(CoordNumber)+' X:'+FloatToStr(CoordX)+' Y:'+FloatToStr(CoordY);
end;

end.
