unit Organization;

interface

uses BaseObjects, Classes, Registrator;

type
  // статус организации
  TOrganizationStatus = class (TRegisteredIDObject)
  public
    constructor Create (ACollection: TIDObjects); override;
  end;

  TOrganizationStatuses = class (TRegisteredIDObjects)
  private
    function GetItems(Index: Integer): TOrganizationStatus;
  public
    property    Items[Index: Integer]: TOrganizationStatus read GetItems;

    Constructor Create; override;
  end;

  // организация
  TOrganization = class (TRegisteredIDObject)
  private
    FRealName: string;
    procedure SplitOrgName;
    function GetRealName: string;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    function    List(ListOption: TListOption = loBrief): string; override;
    property    RealName: string read GetRealName;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TOrganizations = class(TRegisteredIDObjects)
  private
    function GetItems(Index: Integer): TOrganization;
  public
    procedure Assign (Sourse: TIDObjects; NeedClearing: boolean = true); override;
    property  Items[Index: Integer]: TOrganization read GetItems;

    procedure SortByRealName;


    constructor Create; override;
  end;


implementation

uses Facade, OrganizationPoster, ClientCommon, SysUtils, StringUtils;

{ TOrganization }

function CompareOrganizationsByRealName(o1, o2: Pointer): integer;
var s1, s2: string;
begin
  s1 := TOrganization(o1).RealName;
  s2 := TOrganization(o2).RealName;
  Result := CompareStr(s1, s2);
end;

procedure TOrganization.AssignTo(Dest: TPersistent);
begin
  inherited;

end;

constructor TOrganization.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Организация';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TOrganizationDataPoster];
end;


function TOrganization.GetRealName: string;
begin
  if (FRealName = '') then SplitOrgName;
  Result := FRealName;
end;

function TOrganization.List(ListOption: TListOption): string;
begin
  Result := Name;
end;

procedure TOrganization.SplitOrgName;
var lst: TStringList;
    delimiters: TSetOfChar;
begin
  lst := TStringList.Create;
  delimiters := ['"',''''];
  Split(Name, delimiters, lst);

  if (lst.Count > 0) then
    FRealName := lst[lst.Count - 1]
  else
    FRealName := '';
end;

{ TOrganizations }

procedure TOrganizations.Assign(Sourse: TIDObjects; NeedClearing: boolean = true);
begin
  inherited;

end;

constructor TOrganizations.Create;
begin
  inherited;
  FObjectClass := TOrganization;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TOrganizationDataPoster];
end;

function TOrganizations.GetItems(Index: Integer): TOrganization;
begin
  Result := inherited Items[Index] as TOrganization;
end;


procedure TOrganizations.SortByRealName;
begin
  Sort(CompareOrganizationsByRealName);
end;

{ TOrganizationStatus }

constructor TOrganizationStatus.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Статус организации';
end;

{ TOrganizationStatuses }

constructor TOrganizationStatuses.Create;
begin
  inherited;
  FObjectClass := TOrganizationStatus;
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TOrganizationStatusDataPoster];
end;

function TOrganizationStatuses.GetItems(
  Index: Integer): TOrganizationStatus;
begin
  Result := inherited Items[Index] as TOrganizationStatus;
end;

end.
