unit PWSelectVersionForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Version;

type
  TfrmSelectVersion = class(TForm)
    gbxAll: TGroupBox;
    pnlButtons: TPanel;
    btnSelect: TButton;
    btnClose: TButton;
    cmbxVersion: TComboBox;
  private
    function GetVersion: TVersion;
    { Private declarations }
  public
    { Public declarations }
    property ActiveVersion: TVersion read GetVersion;
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmSelectVersion: TfrmSelectVersion;

implementation

uses Facade;

{$R *.dfm}

{ TfrmSelectVersion }

constructor TfrmSelectVersion.Create(AOwner: TComponent);
begin
  inherited;

  TMainFacade.GetInstance.AllVersions.MakeList(cmbxVersion.Items);
  cmbxVersion.ItemIndex := cmbxVersion.Items.IndexOfObject(TMainFacade.GetInstance.AllVersions.ItemsByID[0]);
end;

function TfrmSelectVersion.GetVersion: TVersion;
begin
  Result := cmbxVersion.Items.Objects[cmbxVersion.ItemIndex] as TVersion;
end;

end.
