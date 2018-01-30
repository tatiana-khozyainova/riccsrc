unit Facade;

interface

uses BaseFacades, Registrator, Classes, DBGate, Material, SDFacade;

type
  TMainFacade = class (TSDFacade)
  private
    FAllDocumentTypes: TDocumentTypes;
    FAllDocuments: TSimpleDocuments;

    FFilter: string;
    FRegistrator: TRegistrator;
    FActiveDocType: TDocumentType;

    function GetDocumentTypes: TDocumentTypes;
    function GetAllDocuments:  TSimpleDocuments;
  protected
    function GetRegistrator: TRegistrator; override;
  public
    // фильтр
    property Filter: string read FFilter write FFilter;

    property ActiveDocType: TDocumentType read FActiveDocType write FActiveDocType;

    // типы документов
    property AllDocumentTypes: TDocumentTypes read GetDocumentTypes;
    // материалы
    property AllDocuments: TSimpleDocuments read GetAllDocuments;

    constructor Create(AOwner: TComponent); override;
  end;

  TConcreteRegistrator = class(TRegistrator)
  public
    constructor Create; override;
  end;



implementation

{ TMDFacade }

constructor TMainFacade.Create(AOwner: TComponent);
begin
  inherited;
  // настройка соединения с бд
  //DBGates.ServerClassString := 'RiccServerTest.CommonServerTest';
  //DBGates.ServerClassString := 'RiccServer.CommonServer';

  DBGates.AutorizationMethod := amEnum;
  DBGates.NewAutorizationMode := false;

 // DBGates.ClientAppTypeID := 14;
 // DBGates.ClientName := 'Редактор материалов';
end;

function TMainFacade.GetAllDocuments: TSimpleDocuments;
begin
  if not Assigned (FAllDocuments) then
  begin
    FAllDocuments := TSimpleDocuments.Create;
    
  end;

  Result := FAllDocuments;
end;

function TMainFacade.GetDocumentTypes: TDocumentTypes;
begin
  if not Assigned (FAllDocumentTypes) then
  begin
    FAllDocumentTypes := TDocumentTypes.Create;
    FAllDocumentTypes.Reload('', True);
  end;

  Result := FAllDocumentTypes;
end;

function TMainFacade.GetRegistrator: TRegistrator;
begin
  if not Assigned(FRegistrator) then
    FRegistrator := TConcreteRegistrator.Create;
  Result := FRegistrator;
end;

{ TConcreteRegistrator }

constructor TConcreteRegistrator.Create;
begin
  inherited;
  AllowedControlClasses.Add(TStringsRegisteredObject);
  AllowedControlClasses.Add(TTreeViewRegisteredObject);
end;

end.
