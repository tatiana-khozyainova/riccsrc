program CommonClient;

uses
  Forms,
  MainForm in '..\MainForm.pas' {frmMain},
  CommonObjects in 'CommonObjects.pas',
  CommonFilter in 'CommonFilter.pas',
  ClientCommon in 'ClientCommon.pas',
  PasswordForm in 'PasswordForm.pas' {frmPassword},
  ChangePasswordForm in 'ChangePasswordForm.pas' {frmChangePassword},
  ClientProgressBarForm in 'ClientProgressBarForm.pas' {frmProgressBar},
  AboutForm in 'AboutForm.pas' {frmAbout};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Некий проект';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
