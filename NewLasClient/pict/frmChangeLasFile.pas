unit frmChangeLasFile;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ComCtrls, StdCtrls, ActnList;

type
  TfrmAddChangeSaveLasFiles = class(TFrame)
    pgcMain: TPageControl;
    tsLink: TTabSheet;
    tsChange: TTabSheet;
    tsSave: TTabSheet;
    lstBxArea: TListBox;
    lstBxWells: TListBox;
    btnAddToWell: TButton;
    actlstPgcMain: TActionList;
    actLstBxAreaClick: TAction;
    procedure lstBxAreaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TfrmAddChangeSaveLasFiles.lstBxAreaClick(Sender: TObject);
begin
////
end;

end.
