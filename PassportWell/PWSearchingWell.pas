unit PWSearchingWell;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ActnList, ImgList, StdCtrls, Buttons, Well;

type
  TfrmFindWell = class(TForm)
    pnl1: TPanel;
    btnClear: TBitBtn;
    btnApply: TBitBtn;
    ilList: TImageList;
    actnList: TActionList;
    actnApply: TAction;
    actnClear: TAction;
    lbl2: TLabel;
    edtNameWell: TEdit;
    rgrpNameCondition: TRadioGroup;
    lbl3: TLabel;
    grp1: TGroupBox;
    edtNumWell: TEdit;
    procedure actnApplyExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FWells: TWells;
  public
    property    Wells : TWells read FWells write FWells;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

var
  frmFindWell: TfrmFindWell;

implementation

uses Math, InfoObjectFrame, MainForm;

{$R *.dfm}

{ TfrmFindWell }

constructor TfrmFindWell.Create(AOwner: TComponent);
begin
  inherited;
  FWells := TWells.Create;

  Left := Screen.Width div 2 + 100;
  Top := Screen.Height div 2 + 50;
end;

destructor TfrmFindWell.Destroy;
begin

  inherited;
end;

procedure TfrmFindWell.actnApplyExecute(Sender: TObject);
var Filter: String;
begin
  Filter := '';
  FWells.Clear;

  // по синониму
  if (Trim(edtNumWell.Text) <> '') then
  begin
    Filter := Filter + ' VCH_WELL_NUM = ' + '''' + Trim(edtNumWell.Text) + '''';
  end;

  // по номеру
  if (Trim(edtNameWell.Text) <> '') then
  begin
    if Filter <> '' then Filter := Filter + ' and ';

    case rgrpNameCondition.ItemIndex of
      0 : Filter := Filter + ' VCH_WELL_NAME like ' + '''' + Trim(edtNameWell.Text) + '%' + '''';
      1 : Filter := Filter + ' VCH_WELL_NAME like ' + '''' + '%' + Trim(edtNameWell.Text) + '%' + '''';
      2 : Filter := Filter + ' VCH_WELL_NAME = ' + '''' + Trim(edtNameWell.Text) + '''';
      3 : Filter := Filter + ' VCH_WELL_NAME not like ' + '''' + '%' + Trim(edtNameWell.Text) + '%' + '''';
    end;
  end;

  if Filter <> '' then
  begin
    FWells.Poster.GetFromDB(Filter, FWells);

    if FWells.Count > 0 then
    begin
      FWells.MakeList(frmMain.frmInfoObject.frmInfoWells.tvwWells, true, true);
      frmMain.frmInfoObject.frmInfoWells.SetIcons;
    end
    else MessageBox(0, PChar('Поиск не дал результатов.' + #10#13 + 'Проверьте параметры поиска.'), PChar('Сообщение'), MB_OK);
  end
end;

procedure TfrmFindWell.FormActivate(Sender: TObject);
begin
  SetWindowPos(Handle, HWND_TOPMOST, Left, Top, Width, Height, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
end;

procedure TfrmFindWell.FormDeactivate(Sender: TObject);
begin
  SetWindowPos(Handle, HWND_TOPMOST, Left, Top, Width, Height, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
end;

procedure TfrmFindWell.FormShow(Sender: TObject);
begin
  SetWindowPos(Handle, HWND_TOPMOST, Left, Top, Width, Height, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
end;

end.
