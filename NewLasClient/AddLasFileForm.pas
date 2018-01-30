unit AddLasFileForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, Menus;

type
  TfrmAddLasFile = class(TForm)
    MainMenu: TMainMenu;
    N1: TMenuItem;
    OpnDlg: TMenuItem;
    ActLst: TActionList;
    actOpenDialog: TAction;
    OpenDialog: TOpenDialog;
    procedure OpnDlgClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAddLasFile: TfrmAddLasFile;

implementation

{$R *.dfm}

procedure TfrmAddLasFile.OpnDlgClick(Sender: TObject);
begin
openDialog := TOpenDialog.Create(self);
openDialog.InitialDir := GetCurrentDir;
openDialog.Filter :='Las-פאיכû|*.las|ֲסו פאיכû|*.*';
openDialog.FilterIndex := 1;
if openDialog.Execute
  then ShowMessage('File : '+openDialog.FileName)
  else ShowMessage('Open file was cancelled');
end;

end.
