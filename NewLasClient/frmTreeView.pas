unit frmTreeView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, LasFile, LasFileDataPoster;

type
  TFrame123 = class(TFrame)
    Label1: TLabel;
    btn1: TButton;
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}


procedure TFrame123.btn1Click(Sender: TObject);
var
  lkm:TLasFileDataPoster;
begin
  //lkm.GetFromDB(null,TLasFile);

Label1.Caption:='qwe';
end;

end.
