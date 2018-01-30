unit ChangePasswordForm;

interface

uses
  Classes, Forms, Controls, StdCtrls, Windows, Variants;

type
  TfrmChangePassword = class(TForm)
    lblOldUserName: TLabel;
    edtOldUserName: TEdit;
    lblOldPassword: TLabel;
    edtOldPassword: TEdit;
    lblNewPassword: TLabel;
    edtNewPassword: TEdit;
    lblConfrimNewPassword: TLabel;
    edtConfirmNewPassword: TEdit;
    lblNewUserName: TLabel;
    edtNewUserName: TEdit;
    btnOk: TButton;
    btnCancel: TButton;
    procedure btnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmChangePassword: TfrmChangePassword;

implementation
  uses ClientCommon;

{$R *.DFM}

procedure TfrmChangePassword.btnOkClick(Sender: TObject);
var iRes: integer;
begin
  if edtOldUserName.Text = '' then
  begin
    MessageBox(Self.Handle,
               '�� �� ����� ��� ������������',
               '��������������',
               mb_OK + mb_IconWarning);
    edtOldUserName.SetFocus();
    exit;
  end;
  if edtNewUserName.Text = '' then
  begin
    MessageBox(Self.Handle,
               '�� �� ����� ����� ��� ������������',
               '��������������',
               mb_OK + mb_IconWarning);
    edtNewUserName.SetFocus();
    exit;
  end;
  if edtNewPassword.Text <> edtConfirmNewPassword.Text then
  begin
    MessageBox(Self.Handle,
               '�������� ���� ������ �� ���������!',
               '��������������',
               mb_OK + mb_IconWarning);
    edtNewPassword.Text:='';
    edtConfirmNewPassword.Text:='';
    exit;
  end;
  if not varIsEmpty(IServer) then
  begin
    iRes:= IServer.InsertRow('spd_Change_Login_Password',
                             null,
                             varArrayOf([iClientAppType,
                                         edtOldUserName.Text,
                                         edtOldPassword.Text,
                                         edtNewUserName.Text,
                                         edtNewPassword.Text,
                                         iEmployeeID]));
    if iRes < 0
    then MessageBox(Self.Handle,
                    '�� ������� �������� ���� ������!' + #10 + #13 + '��������� �� ������������.',
                    '������', mb_OK + mb_IconExclamation)
    else MessageBox(Self.Handle, '���� ������ ���� ������� ��������', '�������������', mb_OK + mb_IconInformation);
    Self.CLose();
  end;
end;

procedure TfrmChangePassword.FormCreate(Sender: TObject);
begin
  if varIsEmpty(IServer) then btnOK.Enabled:= false; 
end;

procedure TfrmChangePassword.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then Close();
end;

end.
