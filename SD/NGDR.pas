unit NGDR;

interface

uses Registrator, Classes, BaseObjects, ParentedObjects;

type

  TNGDR = class(TRegisteredIDObject)
  protected
    function    _AddRef: integer; stdcall;
    function    _Release: Integer; stdcall;
  public
    function    List(AListOption: TListOption = loBrief): string; override;
    constructor Create(ACollection: TIDObjects); override;
  end;

  TNGDRs = class(TRegisteredIDObjects)
  private
    function GetItems(Index: Integer): TNGDR;
  public
    property Items[Index: Integer]: TNGDR read GetItems;
    constructor Create; override;    

  end;


implementation

uses Facade, NGDRDataPoster;

{ TNGDRs }

constructor TNGDRs.Create;
begin
  inherited;
  FObjectClass := TNGDR;
  Poster := TMainFacade.GetInstance.DataPosterByClassType[TNGDRRegionDataPoster];
end;

function TNGDRs.GetItems(Index: Integer): TNGDR;
begin
  Result := inherited Items[index] as TNGDR;
end;

{ TNGDR }

constructor TNGDR.Create(ACollection: TIDObjects);
begin
  inherited;
  ClassIDString := 'ÍÃÄÐ';
  FDataPoster := TMainFacade.GetInstance.DataPosterByClassType[TNGDRRegionDataPoster];
end;

function TNGDR.List(AListOption: TListOption): string;
begin
  Result := ShortName;
end;

function TNGDR._AddRef: integer;
begin
  Result := -1;
end;

function TNGDR._Release: Integer;
begin
  Result := -1;
end;

end.
