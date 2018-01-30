unit PasswordForm;

interface

uses
  Classes, Forms,
  StdCtrls,Graphics, Controls, ExtCtrls, Variants;

type
  TfrmPassword = class(TForm)
    edtUserName: TEdit;
    lblUserName: TLabel;
    lblPassword: TLabel;
    btnOk: TButton;
    btnCancel: TButton;
    imgPassportIcon: TImage;
    lblTitle: TLabel;
    edtPassword: TEdit;
    btnChangePassword: TButton;
    procedure edtUserNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtPasswordKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure btnChangePasswordClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPassword: TfrmPassword;

implementation

uses ClientCommon, ChangePasswordForm;

{$R *.DFM}

procedure TfrmPassword.edtUserNameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 40 then edtPassword.SetFocus();
end;

procedure TfrmPassword.edtPasswordKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 38 then edtUserName.SetFocus();
end;

procedure TfrmPassword.FormCreate(Sender: TObject);
begin
  if varIsEmpty(IServer) then btnChangePassword.Enabled:=false;
  Self.imgPassportIcon.Picture.Icon:= Application.Icon;
end;

procedure TfrmPassword.btnChangePasswordClick(Sender: TObject);
begin
  frmChangePassword:=TfrmChangePassword.Create(Self);
  frmChangePassword.ShowModal();
  frmChangePassword.Free();
  frmChangePassword:=nil;
end;


end.
