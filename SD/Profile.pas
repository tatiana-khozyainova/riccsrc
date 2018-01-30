unit Profile;

interface

uses Registrator, BaseObjects;

type


  TProfile = class(TRegisteredIDObject)
  public
    constructor Create(ACollection: TIDObjects); override;
  end;

  TProfiles = class(TRegisteredIDObjects)
  private
    function    GetItems(Index: integer): TProfile;
  public
    property    Items[Index: integer]: TProfile read GetItems;
    constructor Create; override;
  end;


implementation

uses Facade, BaseFacades, ProfilePoster;

{ TProfiles }

constructor TProfiles.Create;
begin
  inherited;
  FObjectClass := TProfile;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TProfileDataPoster];
end;

function TProfiles.GetItems(Index: integer): TProfile;
begin
  Result := inherited Items[Index] as TProfile;
end;

{ TProfile }

constructor TProfile.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Профиль';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TProfileDataPoster];
end;

end.
