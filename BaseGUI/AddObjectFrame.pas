unit AddObjectFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ActnList, ExtCtrls, Registrator,
  CommonValueDictFrame;

type
  TfrmAddObject = class(TFrame)
    gbx: TGroupBox;
    Panel1: TPanel;
    actnLst: TActionList;
    actnSave: TAction;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    edtName: TEdit;
    Panel2: TPanel;
    frmFilterDicts: TfrmFilter;
  private
    FName: string;
    procedure SetName(const Value: string);
  public
    property    Name: string read FName write SetName;

    procedure   Clear;
    procedure   Reload;
    function    Save: boolean;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

implementation

{$R *.dfm}

{ TfrmAddObject }

procedure TfrmAddObject.Clear;
begin
  edtName.Text := '';
end;

constructor TfrmAddObject.Create(AOwner: TComponent);
begin
  inherited;

  if trim(edtName.Text) <> '' then edtName.SelText;
end;

destructor TfrmAddObject.Destroy;
begin

  inherited;
end;

procedure TfrmAddObject.Reload;
begin

end;

function TfrmAddObject.Save: boolean;
begin
  Result := false;

  if trim(edtName.Text) <> '' then
  begin
    FName := trim(edtName.Text);
    Result := true;
  end
  else MessageBox(0, 'Введите значение поля.', 'Ошибка', MB_OK + MB_ICONWARNING + MB_APPLMODAL);
end;

procedure TfrmAddObject.SetName(const Value: string);
begin
  if FName <> Value then
  begin
    FName := Value;
    edtName.Text := trim (FName);
  end;
end;

end.
