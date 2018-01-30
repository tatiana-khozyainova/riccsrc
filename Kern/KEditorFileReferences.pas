unit KEditorFileReferences;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, KListFilesFrame;

type
  TfrmEditorReferences = class(TForm)
    frmLstFiles: TfrmLstFiles;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEditorReferences: TfrmEditorReferences;

implementation

{$R *.dfm}

end.
