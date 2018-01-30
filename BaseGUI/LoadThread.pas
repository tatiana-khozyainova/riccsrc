unit LoadThread;

interface

uses Classes, Contnrs;

type
  TLoadingThread = class (TThread)
  public
    procedure Execute; override;
  end;

  TLoadingThreads = class (TObjectList)
  private
    function GetItems(Index: integer): TThread;
  public
    property    Items [Index: integer] : TThread read GetItems;
  end;

implementation

uses Facade;

{ TLoadingThreads }

function TLoadingThreads.GetItems(Index: integer): TThread;
begin
  Result := inherited Items[Index] as TThread;
end;

{ TLoadingThread }

procedure TLoadingThread.Execute;
begin
  TMainFacade.GetInstance.AllNGOs.Reload;
  TMainFacade.GetInstance.AllNGPs.Reload;
  TMainFacade.GetInstance.AllNGRs.Reload;
  TMainFacade.GetInstance.AllFields.Reload;
  TMainFacade.GetInstance.AllLicenseZones.Reload;
  TMainFacade.GetInstance.AllTectonicStructures.Reload;
  TMainFacade.GetInstance.AllStructures.Reload;
  TMainFacade.GetInstance.AllDistricts.Reload;
end;

end.
 