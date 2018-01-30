program SubDivider;

{%ToDo 'SubDivider.todo'}

uses
  Forms,
  SubDividerMainForm in 'SubDividerMainForm.pas' {frmSubDividerMain},
  SubDividerCommonObjects in 'SubDividerCommonObjects.pas',
  SubDividerCommon in 'SubDividerCommon.pas',
  ClientCommon in 'Common\ClientCommon.pas',
  SubDividerConvertingForm in 'SubDividerConvertingForm.pas' {frmConvert},
  PasswordForm in 'Common\PasswordForm.pas' {frmPassword},
  ChangePasswordForm in 'Common\ChangePasswordForm.pas' {frmChangePassword},
  ClientProgressBarForm in 'Common\ClientProgressBarForm.pas' {frmProgressBar},
  SubDividerWellConfirm in 'SubDividerWellConfirm.pas' {frmWellConfirm},
  SubDividerStratonVerifyingForm in 'SubDividerStratonVerifyingForm.pas' {frmVerifyStratons},
  SubDividerEditFrame in 'SubDividerEditFrame.pas' {frmEditSubDivision: TFrame},
  CommonFilter in 'Common\CommonFilter.pas',
  DNRClientAboutForm in 'Common\DNRClientAboutForm.pas' {frmAbout},
  SubDividerEditForm in 'SubDividerEditForm.pas' {frmSubDivisionComponentEdit},
  SubDividerTectonicBlockForm in 'SubDividerTectonicBlockForm.pas' {frmTectBlock},
  SubDividerComponentEditFrame in 'SubDividerComponentEditFrame.pas' {frmSubComponentEdit: TFrame},
  SubDividerComponentEditForm in 'SubDividerComponentEditForm.pas' {frmEditAll},
  SubDividerProgressForm in 'SubDividerProgressForm.pas' {frmProgress},
  SubDividerNGRExportForm in 'SubDividerNGRExportForm.pas' {frmNGRExport};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Редактор стратиграфических разбивок';
  Application.CreateForm(TfrmSubDividerMain, frmSubDividerMain);
  Application.CreateForm(TfrmNGRExport, frmNGRExport);
  Application.Run;
end.
