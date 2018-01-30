unit KDictOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, CheckLst, ExtCtrls;

type
  TfrmDictOptions = class(TFrame)
    GroupBox1: TGroupBox;
    lstShowingDicts: TCheckListBox;
    Panel1: TPanel;
    ckAll: TCheckBox;
    ckNonAll: TCheckBox;
    procedure ckAllClick(Sender: TObject);
    procedure ckNonAllClick(Sender: TObject);
  private
    { Private declarations }

    procedure   CheckAll (AValue: boolean);

  public
    { Public declarations }
    constructor Create(AOnwer: TComponent); override;
    destructor  Destroy; override;
  end;

implementation

uses Facade;

{$R *.dfm}

{ TfrmDictOptions }

constructor TfrmDictOptions.Create(AOnwer: TComponent);
begin
  inherited;

  (TMainFacade.GetInstance as TMainFacade).Dicts.MakeList(lstShowingDicts.Items);


end;

destructor TfrmDictOptions.Destroy;
begin

  inherited;
end;

procedure TfrmDictOptions.ckAllClick(Sender: TObject);
begin
  if ckAll.Checked then CheckAll(true);
end;

procedure TfrmDictOptions.ckNonAllClick(Sender: TObject);
begin
  if ckNonAll.Checked then CheckAll(false);
end;

procedure TfrmDictOptions.CheckAll(AValue: boolean);
var i: integer;
begin
  ckAll.Checked := AValue;
  ckNonAll.Checked := not AValue;

  for i := 0 to lstShowingDicts.Count - 1 do
    lstShowingDicts.Checked[i] := AValue;
end;

end.
