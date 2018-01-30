unit WellStratonByDepthFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls;

type
  TfrmWellStratonByDepth = class(TFrame)
    Label1: TLabel;
  private
    FTop: double;
    FBottom: double;
    { Private declarations }
  public
    { Public declarations }
    procedure Clear;
    property Top: double read FTop write FTop;
    property Bottom: double read FBottom write FBottom;

  end;

implementation

{$R *.dfm}

{ TfrmWellStratonByDepth }

procedure TfrmWellStratonByDepth.Clear;
begin

end;

end.
