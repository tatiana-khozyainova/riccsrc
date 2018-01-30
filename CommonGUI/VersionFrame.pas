unit VersionFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseComponent, BaseObjects, Version, ToolWin, ComCtrls;

type
  TfrmVersion = class(TFrame, IBaseComponent)
    lwVersions: TListView;
    tlbrBtns: TToolBar;
  private
    { Private declarations }
    FImplementor: TBaseComponentImplementor;
    function GetBaseComponentImplementor: TBaseComponentImplementor;
    function GetVersions: TVersions;
  public
    { Public declarations }
    property  Versions: TVersions read GetVersions;
    property  Implementor: TBaseComponentImplementor read GetBaseComponentImplementor implements IBaseComponent;
    function  AddVersion(AVerstionName, AVersionReason: string; AVersionDate: TDateTime): TVersion;
    procedure Prepare; 
  end;


  TVersionImplementor = class(TBaseComponentImplementor)
  protected
    function  GetInputObjects: TIDObjects; override;
    procedure SetInputObjects(const Value: TIDObjects); override;



  end;

implementation

uses Facade, SDFacade, ExceptionExt;

{$R *.dfm}

{ TfrmVersion }

function TfrmVersion.AddVersion(AVerstionName, AVersionReason: string;
  AVersionDate: TDateTime): TVersion;
var li: TListItem;
begin
  // добавляем
  Result := Versions.Add;

  // инициализируем значениями
  with Result do
  begin
    VersionName := AVerstionName;
    VersionReason := AVersionReason;
    VersionDate := AVersionDate;
  end;

  // пишем в БД
  Result.Update();

  // обновляем представление
  Versions.MakeList(lwVersions.Items, true, true);
end;

function TfrmVersion.GetBaseComponentImplementor: TBaseComponentImplementor;
begin
  if not Assigned(FImplementor) then
    FImplementor := TVersionImplementor.Create;

  Result := FImplementor;
end;


function TfrmVersion.GetVersions: TVersions;
begin
  Result := IBaseComponent(Self).InputObjects as TVersions;
end;

procedure TfrmVersion.Prepare;
begin
  Versions.MakeList(lwVersions.Items, true, false);
end;

{ TVersionImplementor }

function TVersionImplementor.GetInputObjects: TIDObjects;
begin
  Result := TMainFacade.GetInstance.AllVersions;
end;

procedure TVersionImplementor.SetInputObjects(const Value: TIDObjects);
begin
  raise EReadonlyResetProhibited.Create;
end;

end.
