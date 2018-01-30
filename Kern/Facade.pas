unit Facade;

interface

uses SDFacade, Registrator, Classes, DBGate, Well, CoreDescription, Employee,
     Organization, Slotting, Graphics, Windows, Lithology, TypeResearch,
     LayerSlotting, BaseObjects, CoreDescriptionPoster, TypeResearchPoster,
     RockSamplePoster, LayerSlottingPoster, SysUtils;

type
  TMainFacade = class (TSDFacade)
  private
    FFilter: string;
    FAllDescriptions: TDescriptions;
    FDicts: TDictionaries;
    FAllWells: TDescriptedWells;
    FAllSlottings: TSlottings;
    FActiveWell: TDescriptedWell;
    FAllRoots: TRoots;
    FFont: TFont;
    FLithologies: TLithologies;
    FTypeResearchs: TTypeResearchs;
    FAllLayers: TSimpleLayerSlottings;
    FActiveSlotting: TSlotting;

    function GetAllDescriptions: TDescriptions;
    function GetDicts: TDictionaries;
    function GetAllWords: TDictionaryWords;
    function GetAllWells: TDescriptedWells;
    function GetAllSlottings: TSlottings;
    function GetAllRoots: TRoots;
    function GetFont: TFont;
    function GetAllLithologies: TLithologies;
    function GetTypeResearchs: TTypeResearchs;
    function GetAllLayers: TSimpleLayerSlottings;
  protected
    function GetRegistrator: TRegistrator; override;

    function GetDataPosterByClassType(ADataPosterClass: TDataPosterClass): TDataPoster; override;
  public
    FAllWords: TDictionaryWords;
      // все словари
    property Dicts: TDictionaries read GetDicts;
      // все слова в словаре
    property AllWords: TDictionaryWords read GetAllWords;

      // все слова в словаре
    property AllRoots: TRoots read GetAllRoots;
      // литология
    property AllLithologies: TLithologies read GetAllLithologies;

      // все скважины по фильтру
    property AllWells: TDescriptedWells read GetAllWells;
      // выбранная скважина
    property ActiveWell: TDescriptedWell read FActiveWell write FActiveWell;
      // выбранное долбление
    property ActiveSlotting: TSlotting read FActiveSlotting write FActiveSlotting;
      // все долбления по скважине
    property AllSlottings: TSlottings read GetAllSlottings;

      // все описания керна
    property AllDescriptions: TDescriptions read GetAllDescriptions;
      // font по умолчанию
    property Font: TFont read GetFont;

      // виды исследований для керна
    property TypeResearchs: TTypeResearchs read GetTypeResearchs;
      // слои описания керна
    property AllLayers: TSimpleLayerSlottings read GetAllLayers;

    // фильтр
    property Filter: string read FFilter write FFilter;

    procedure   ClearWords;

    // в конструкторе создаются и настраиваются всякие
    // необходимые в скором времени вещи
    constructor Create(AOwner: TComponent); override;
  end;

  TConcreteRegistrator = class(TRegistrator)
  public
    constructor Create; override;
  end;


implementation

uses EmployeePoster;

{ TMDFacade }

constructor TMainFacade.Create(AOwner: TComponent);
begin
  inherited;
  // настройка соединения с бд
  //Gates.ServerClassString := 'RiccServerTest.CommonServerTest';
  //DBGates.ServerClassString := 'RiccServer.CommonServer';

  //DBGates.AutorizationMethod := amInitialize;
  DBGates.AutorizationMethod := amEnum;
  DBGates.NewAutorizationMode := false;
  //DBGates.ClientAppTypeID := 17;
  //DBGates.ClientName := 'Описание керна';
end;

function TMainFacade.GetAllDescriptions: TDescriptions;
begin
  if not Assigned (FAllDescriptions) then
  begin
    FAllDescriptions := TDescriptions.Create();
    FAllDescriptions.Reload ('', True);
  end;

  Result := FAllDescriptions;
end;

function TMainFacade.GetDicts: TDictionaries;
begin
  if not Assigned(FDicts) then
  begin
    FDicts := TDictionaries.Create();
    FDicts.Reload('', true);

    FDicts.SetFont(FDicts);
  end;

  Result := FDicts;
end;


function TMainFacade.GetAllLayers: TSimpleLayerSlottings;
begin
  if not Assigned (FAllLayers) then
  begin
    FAllLayers := TSimpleLayerSlottings.Create;
    FAllLayers.Reload ('', True);
  end;

  Result := FAllLayers;
end;

function TMainFacade.GetAllLithologies: TLithologies;
begin
  if not Assigned(FLithologies) then
  begin
    FLithologies := TLithologies.Create;
    FLithologies.Reload('', true);
  end;

  Result := FLithologies;
end;

function TMainFacade.GetAllRoots: TRoots;
var i, j: integer;
    r: TRoot;
begin
  if not Assigned(FAllRoots) then
  begin
    FAllRoots := TRoots.Create;

    for i := 0 to FDicts.Count - 1 do
    for j := 0 to FDicts.Items[i].Roots.Count - 1 do
    begin
      r := FDicts.Items[i].Roots.Items[j];
      FAllRoots.Add(r, false, false);
    end;
  end;

  Result := FAllRoots;
end;

function TMainFacade.GetAllSlottings: TSlottings;
begin
  if not Assigned(FAllSlottings) then
  begin
    FAllSlottings := TSlottings.Create;
    FAllSlottings.Reload('', true);
  end;

  Result := FAllSlottings;
end;

function TMainFacade.GetAllWells: TDescriptedWells;
begin
  if not Assigned(FAllWells) then
  begin
    FAllWells := TDescriptedWells.Create;
    FAllWells.Reload ('', True);
  end;

  Result := FAllWells;
end;

function TMainFacade.GetAllWords: TDictionaryWords;
var i, j, k: integer;
    w: TDictionaryWord;
begin
  if not Assigned(FAllWords) then
  begin
    FAllWords := TDictionaryWords.Create;
    //FAllWells.OwnsObjects := false;

    for i := 0 to FDicts.Count - 1 do
    if FDicts.Items[i].Name <> 'Литология (нередактируемый справочник)' then
    begin
      for j := 0 to FDicts.Items[i].Roots.Count - 1 do
      for k := 0 to FDicts.Items[i].Roots.Items[j].Words.Count - 1 do
      begin
        FDicts.Items[i].Roots.Items[j].Words.Items[k].AllWords := AllWords;
        w := FDicts.Items[i].Roots.Items[j].Words.Items[k];
        FAllWords.Add(w, false, false);
        //FAllWords.Assign(FDicts.Items[i].Roots.Items[j].Words, False);
      end
    end
    else
    begin
      // добавляем слова из справочника литологий
      for j := 0 to (TMainFacade.GetInstance as TMainFacade).AllLithologies.Count - 1 do
      begin
        w := TDictionaryWord.Create(FAllWords);
        w.ID := (TMainFacade.GetInstance as TMainFacade).AllLithologies.Items[j].ID;
        w.Name := (TMainFacade.GetInstance as TMainFacade).AllLithologies.Items[j].Name;
        w.Correct := true;
        FDicts.Items[i].Roots.Items[0].Words.Add(w);
        FAllWords.Add(w, false, false);
      end;
    end;
  end;

  Result := FAllWords;
end;

function TMainFacade.GetDataPosterByClassType(
  ADataPosterClass: TDataPosterClass): TDataPoster;
begin
  Result := inherited GetDataPosterByClassType(ADataPosterClass);

  if Result is TListWordsDataPoster then
    (Result as TListWordsDataPoster).AllWords := AllWords
  else if Result is TLithologyDescrDataPoster then
         (Result as TLithologyDescrDataPoster).AllLithologies := AllLithologies
       else if Result is TRootDataPoster then
         (Result as TRootDataPoster).AllDicts := Dicts
       else if Result is TDescriptionDataPoster then
       begin
         (Result as TDescriptionDataPoster).ActiveWell := ActiveWell;
         (Result as TDescriptionDataPoster).ActiveSlotting := ActiveSlotting;
       end
       else if Result is TRockSampleResearchDataPoster then
         (Result as TRockSampleResearchDataPoster).TypeResearchs := TypeResearchs
       ELSE if Result is TWordDataPoster then
         (Result as TWordDataPoster).AllRoots := AllRoots
       else if Result is TRockSampleDataPoster then
         (Result as TRockSampleDataPoster).AllLithologies := AllLithologies
       else if Result is TLayerRockSampleDataPoster then
         (Result as TLayerRockSampleDataPoster).AllLayers := AllLayers
       else if Result is TEmployeeDataPoster then
         (Result as TEmployeeDataPoster).AllPosts := AllPosts
       else if Result is TAuthorDataPoster then
         (Result as TAuthorDataPoster).AllEmployee := Employees;
end;

function TMainFacade.GetFont: TFont;
begin
  if not Assigned (FFont) then
  begin
    FFont := TFont.Create;
    FFont.Name := 'Arial';
    FFont.CharSet := DEFAULT_CHARSET;
    FFont.Color := clWindowText;
    FFont.Size := 10;
    FFont.Style := [fsBold];
  end;

  Result := FFont;
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


function TMainFacade.GetTypeResearchs: TTypeResearchs;
begin
  if not Assigned(FTypeResearchs) then
  begin
    FTypeResearchs := TTypeResearchs.Create;
    FTypeResearchs.Reload ('DEPARTMENT_ID = 7 and MAIN_RESEARCH_ID <> 0');
  end;

  Result := FTypeResearchs;
end;

procedure TMainFacade.ClearWords;
begin
  FreeAndNil(FAllWords);
end;

end.
