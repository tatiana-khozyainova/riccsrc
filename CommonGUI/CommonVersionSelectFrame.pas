unit CommonVersionSelectFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Version, ActnList, Buttons;

type
  TfrmSelectVersion = class(TFrame)
    gbxSelect: TGroupBox;
    cmbxVersion: TComboBox;
    edtVSeach: TEdit;
    actlstVSeach: TActionList;
    actVSeach: TAction;
    actnPrev: TAction;
    actnNext: TAction;
    btnPrev: TSpeedButton;
    btnNext: TSpeedButton;
    btnSearch: TSpeedButton;
    procedure actnPrevExecute(Sender: TObject);
    procedure actnPrevUpdate(Sender: TObject);
    procedure actnNextExecute(Sender: TObject);
    procedure actnNextUpdate(Sender: TObject);
    procedure cmbxVersionChange(Sender: TObject);
    procedure actVSeachExecute(Sender: TObject);
    procedure edtVSeachEnter(Sender: TObject);
    procedure actVSeachUpdate(Sender: TObject);
  private
    { Private declarations }
    CurrentIndex: Integer;
    NewFrame: boolean;
    
    function  GetVersion: TVersion;
    procedure SetVersion(const Value: TVersion);
    procedure DoActiveVersionChange;
  public
    { Public declarations }
    procedure   PrepareVersions;
    property    ActiveVersion: TVersion read GetVersion write SetVersion;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses Facade;

{$R *.dfm}

{ TfrmSelectVersion }

constructor TfrmSelectVersion.Create(AOwner: TComponent);
begin
  inherited;
end;

function TfrmSelectVersion.GetVersion: TVersion;
begin
  Result := cmbxVersion.Items.Objects[cmbxVersion.ItemIndex] as TVersion;
end;

procedure TfrmSelectVersion.PrepareVersions;
begin
  TMainFacade.GetInstance.AllVersions.MakeList(cmbxVersion.Items);
  cmbxVersion.ItemIndex := cmbxVersion.Items.IndexOfObject(TMainFacade.GetInstance.AllVersions.ItemsByID[0]);
  NewFrame := true;
  edtVSeach.Text := '¬ведите название версии';
end;

procedure TfrmSelectVersion.SetVersion(const Value: TVersion);
begin
  cmbxVersion.ItemIndex := cmbxVersion.Items.IndexOfObject(Value);
end;

procedure TfrmSelectVersion.actnPrevExecute(Sender: TObject);
begin
  cmbxVersion.ItemIndex := cmbxVersion.ItemIndex - 1;

end;

procedure TfrmSelectVersion.actnPrevUpdate(Sender: TObject);
begin
  actnPrev.Enabled := cmbxVersion.ItemIndex > 0;
end;

procedure TfrmSelectVersion.actnNextExecute(Sender: TObject);
begin
  cmbxVersion.ItemIndex := cmbxVersion.ItemIndex + 1;
end;

procedure TfrmSelectVersion.actnNextUpdate(Sender: TObject);
begin
  actnNext.Enabled := cmbxVersion.ItemIndex  < cmbxVersion.Items.Count - 1;
end;

procedure TfrmSelectVersion.DoActiveVersionChange;
begin
  TMainFacade.GetInstance.ActiveVersion := ActiveVersion;
end;

procedure TfrmSelectVersion.cmbxVersionChange(Sender: TObject);
begin
  DoActiveVersionChange;
end;

procedure TfrmSelectVersion.actVSeachExecute(Sender : TObject);
var
    i: integer;
    b: boolean;
begin
  b := false;
  for i := CurrentIndex to  cmbxVersion.Items.Count - 1 do
  begin
    if Pos(edtVSeach.Text, AnsiLowerCase(cmbxVersion.Items[i])) > 0 then
    begin
      cmbxVersion.ItemIndex := i;
      CurrentIndex := i + 1;
      b := true;
      break;
    end;
  end;

  if not b then CurrentIndex := 0;
end;

procedure TfrmSelectVersion.edtVSeachEnter(Sender: TObject);
begin
if NewFrame then
  begin
    edtVSeach.Text := '';
    edtVSeach.Font.Color := clBlack;
    NewFrame := false;
  end;
end;
procedure TfrmSelectVersion.actVSeachUpdate(Sender: TObject);
begin
  actVSeach.Enabled := (edtVSeach.Font.Color = clBlack) and (edtVSeach.Text <> '') ;
end;
end.
