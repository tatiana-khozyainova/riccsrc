unit KOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, KDictOptions;

type
  TfrmOptions = class(TForm)
    pgctrl: TPageControl;
    TabSheet1: TTabSheet;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    frmDictOptions: TfrmDictOptions;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure   Reload;

    constructor Create(AOnwer: TComponent); override;
    destructor  Destroy; override;
  end;

var
  frmOptions: TfrmOptions;

implementation

{$R *.dfm}

{ TfrmOptions }

constructor TfrmOptions.Create(AOnwer: TComponent);
begin
  inherited;

end;

destructor TfrmOptions.Destroy;
begin

  inherited;
end;

procedure TfrmOptions.Reload;
begin

end;

end.
