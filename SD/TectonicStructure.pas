unit TectonicStructure;

interface

uses Registrator, Classes, BaseObjects, ParentedObjects;

type
  // тектоническая структура
  TTectonicStructure = class (TRegisteredIDObject)
  private
    FTectonicStructureID: integer;
    function GetTectonicStructure: TTectonicStructure;
  protected
    procedure AssignTo(Dest: TPersistent); override;  
  public
    property MainTectonicStructure: TTectonicStructure read GetTectonicStructure;
    property MainTectonicStructureID: integer read FTectonicStructureID write FTectonicStructureID;

    constructor Create (ACollection: TIDObjects); override;
  end;

  TTectonicStructures = class (TRegisteredIDObjects)
  private
    function GetItems(Index: integer): TTectonicStructure;
  public
    property    Items[Index: integer]: TTectonicStructure read GetItems;
    constructor Create; override;
  end;

  // новая тектоническая структура
  TNewTectonicStructure = class (TTectonicStructure)
  private
    FOldStructID: Integer;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    // старая тектоническая структура
    property    OldStructID: Integer read FOldStructID write FOldStructID;

    constructor Create (ACollection: TIDObjects); override;
  end;

  TNewTectonicStructures = class (TTectonicStructures)
  private
    function GetItems(Index: integer): TNewTectonicStructure;
  public
    property    Items[Index: integer]: TNewTectonicStructure read GetItems;
    constructor Create; override;
  end;


implementation



uses Facade, TectonicStructurePoster;

{ TTectonicStructures }

constructor TTectonicStructures.Create;
begin
  inherited;
  FObjectClass := TTectonicStructure;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TTectonicStructureDataPoster];
end;

function TTectonicStructures.GetItems(Index: integer): TTectonicStructure;
begin
  Result := inherited Items[Index] as TTectonicStructure;
end;

{ TTectonicStructure }

procedure TTectonicStructure.AssignTo(Dest: TPersistent);
var o: TTectonicStructure;
begin
  inherited;
  o := Dest as TTectonicStructure;

  o.MainTectonicStructureID := MainTectonicStructureID;
end;

constructor TTectonicStructure.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Тектоническая структура';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TTectonicStructureDataPoster];
end;

function TTectonicStructure.GetTectonicStructure: TTectonicStructure;
begin
  Result := TMainFacade.GetInstance.AllTectonicStructures.ItemsByID[MainTectonicStructureID] as TTectonicStructure;
end;


{ TNewTectonicStructures }

constructor TNewTectonicStructures.Create;
begin
  inherited;
  FObjectClass := TNewTectonicStructure;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TNewTectonicStructureDataPoster];
end;

function TNewTectonicStructures.GetItems(
  Index: integer): TNewTectonicStructure;
begin
  Result := inherited Items[index] as TNewTectonicStructure;
end;

{ TNewTectonicStructure }

procedure TNewTectonicStructure.AssignTo(Dest: TPersistent);
var o : TNewTectonicStructure;
begin
  inherited;
  o := Dest as TNewTectonicStructure;

  o.FOldStructID := FOldStructID;
end;

constructor TNewTectonicStructure.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'Новая тектоническая структура';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TNewTectonicStructureDataPoster];
end;

end.
