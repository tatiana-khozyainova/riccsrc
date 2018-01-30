unit SeismicObject;

interface
{
uses BaseObjects, Registrator, Classes, Organization, Area, Structure, PetrolRegion, District,
     LicenseZone, SysUtils, Topolist, ComCtrls;
}

uses BaseObjects, Registrator, Classes, SysUtils;

type
  TSeismicObjectType = class;
  TSeismicObjectTypes = class;
  TSeismicWorkType = class;
  TSeismicWorkTypes = class;
  TSeismicCrew = class;
  TSeismicCrews = class;
  TSeismicReport = class;
  TSeismicReports = class;
  TSeismicProfileType = class;
  TSeismicProfileTypes = class;
  TSeismicProfile = class;
  TSeismicProfiles = class;


  //тип сейсмопрофиля
  TSeismicProfileType = class(TRegisteredIDObject)
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TSeismicProfileTypes = class(TRegisteredIDObjects)
  private
    function GetItems(Index: Integer): TSeismicProfileType;
  public
    property    Items[Index: Integer]: TSeismicProfileType read GetItems;
    constructor Create; override;
  end;

  // тип объекта - площадь или региональный профиль
  TSeismicObjectType = class(TRegisteredIDObject)
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TSeismicObjectTypes = class(TRegisteredIDObjects)
  private
    function GetItems(Index: Integer): TSeismicObjectType;
  public
    property    Items[Index: Integer]: TSeismicObjectType read GetItems;
    constructor Create; override;
  end;

  // тип сейсмопрофиля
  TSeismicWorkType = class(TRegisteredIDObject)
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TSeismicWorkTypes = class(TRegisteredIDObjects)
  private
    function GetItems(Index: Integer): TSeismicWorkType;
  public
    property    Items[Index: Integer]: TSeismicWorkType read GetItems;
    constructor Create; override;
  end;

  // сейсмопартия
  TSeismicCrew = class(TRegisteredIDObject)
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TSeismicCrews = class(TRegisteredIDObjects)
  private
    function GetItems(Index: Integer): TSeismicCrew;
  public
    property    Items[Index: Integer]: TSeismicCrew read GetItems;
    constructor Create; override;
  end;

  TSeismicReport = class(TRegisteredIDObject)
  private
    FSeismicReports: TSeismicReports;
    FInvNumber: string;
    FComment: string;
    FEndReportDate: TDateTime;
    FSendDate: TDateTime;
    FRejReason: string;
    FBeginWorkDate: TDateTime;
    FEndWorkDate: TDateTime;
    FCustomer: string;
    FWorker: string;
    FSeismicWorkType: TSeismicWorkType;
    FSeismicCrew: TSeismicCrew;

    function GetSeismicReports: TSeismicReports;
  public
    //function    List(AListOption: TListOption = loBrief): string; override;
    property SeismicReports: TSeismicReports read GetSeismicReports;
    property InvNumber: string read FInvNumber write FInvNumber;
    property Comment: string read FComment write FComment;
    property EndReportDate: TDateTime read FEndReportDate write FEndReportDate;
    property SendDate: TDateTime read FSendDate write FSendDate;
    property RejReason: string read FRejReason write FRejReason ;
    property BeginWorkDate: TDateTime read FBeginWorkDate write FBeginWorkDate;
    property EndWorkDate: TDateTime read FEndWorkDate write FEndWorkDate;
    property Customer: string read FCustomer write FCustomer;
    property Worker: string read FWorker write FWorker;
    property SeismicWorkType: TSeismicWorkType read FSeismicWorkType write FSeismicWorkType;
    property SeismicCrew: TSeismicCrew read FSeismicCrew write FSeismicCrew;

    constructor Create(ACollection: TIDObjects); override;
  end;

  TSeismicReports = class (TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TSeismicReport;
  public
    property    Items[Index: integer]: TSeismicReport read GetItems;
    constructor Create; override;
  end;

  //сейсмопрофиль
  TseismicProfile = class(TRegisteredIDObject)
  private
    FSeismicProfiles : TSeismicProfiles;
    FSeismicProfileNum : Integer;
    FSeismicProfileType : TSeismicProfileType;
    FSeismicReport : TSeismicReport;
    function GetSeismicProfiles : TSeismicProfiles;
  public
    property SeismicProfiles : TSeismicProfiles read GetSeismicProfiles;
    property SeismicProfileNum : Integer Read FSeismicProfileNum write FSeismicProfileNum;
    property SeismicProfileType : TSeismicProfileType read FSeismicProfileType write FSeismicProfileType;
    property SeismicReport : TSeismicReport read FSeismicReport write FSeismicReport;
    constructor Create(ACollection : TIDObjects); override;
   end;

  TSeismicProfiles = class(TRegisteredIDObjects)
  private
    function GetItems(Index : Integer):TSeismicProfile;
  public
    property Items[Index:Integer]: TSeismicProfile read GetItems;
    constructor Create; override;
  end;
implementation

uses SeismicObjectDataPoster, Facade;

{ TSeismicObjectType }

constructor TSeismicObjectType.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Тип объекта сейсморазведочных работ';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TSeismicObjectTypeDataPoster];
end;

{ TSeismicObjectTypes }

constructor TSeismicObjectTypes.Create;
begin
  inherited;
  FObjectClass := TSeismicObjectType;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TSeismicObjectTypeDataPoster];
end;

function TSeismicObjectTypes.GetItems(Index: Integer): TSeismicObjectType;
begin
  Result := inherited Items[Index] as TSeismicObjectType;
end;

{ TSeismicWorkTypes }

constructor TSeismicWorkTypes.Create;
begin
  inherited;
  FObjectClass := TSeismicWorkType;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TSeismicWorkTypeDataPoster];
end;

function TSeismicWorkTypes.GetItems(Index: Integer): TSeismicWorkType;
begin
  Result := inherited Items[Index] as TSeismicWorkType;
end;

{ TSeismicWorkType }

constructor TSeismicWorkType.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Вид сейсморазведочных работ';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TSeismicWorkTypeDataPoster];
end;

{ TSeismicCrew }

constructor TSeismicCrew.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Сейсмопартия';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TSeismicCrewDataPoster];
end;

{ TSeismicCrews }

constructor TSeismicCrews.Create;
begin
  inherited;
  FObjectClass := TSeismicCrew;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TSeismicCrewDataPoster];
end;

function TSeismicCrews.GetItems(Index: Integer): TSeismicCrew;
begin
  Result := inherited Items[Index] as TSeismicCrew;
end;

{ TSeismicReport }

constructor TSeismicReport.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Сейсмоотчет';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TSeismicReportDataPoster];
end;

{ TSeismicReport }

constructor TSeismicReports.Create;
begin
  inherited;
  FObjectClass := TSeismicReport;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TSeismicReportDataPoster];
end;

function TSeismicReports.GetItems(Index: Integer): TSeismicReport;
begin
  Result := inherited Items[Index] as TSeismicReport;
end;

function TSeismicReport.GetSeismicReports: TSeismicReports;
begin
  If not Assigned (FSeismicReports) then
  begin
    FSeismicReports := TSeismicReports.Create;
    FSeismicReports.OwnsObjects := true;
    FSeismicReports.Owner := Self;
    FSeismicReports.Reload('SEISMIC_REPORT_ID = ' + IntToStr(ID));
  end;

  Result := FSeismicReports;
end;

{ TSeismicProfileType }

constructor TSeismicProfileType.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Тип сейсмопрофиля';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TSeismicProfileTypeDataPoster];
end;

{ TSeismicProfileTypes }

constructor TSeismicProfileTypes.Create;
begin
  inherited;
  FObjectClass := TSeismicProfileType;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TSeismicProfileTypeDataPoster];
end;

function TSeismicProfileTypes.GetItems(
  Index: Integer): TSeismicProfileType;
begin
  Result := inherited Items[Index] as TSeismicProfileType;
end;

{ TseismicProfile }

constructor TseismicProfile.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Сейсмопрофиль';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TSeismicProfileDataPoster];
end;

function TseismicProfile.GetSeismicProfiles: TSeismicProfiles;
begin
  If not Assigned (FSeismicProfiles) then
  begin
    FSeismicProfiles := TSeismicProfiles.Create;
    FSeismicProfiles.OwnsObjects := true;
    FSeismicProfiles.Owner := Self;
    FSeismicProfiles.Reload('SEISMIC_PROFILE_ID = ' + IntToStr(ID));
  end;
  Result := FSeismicProfiles;
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

end.
