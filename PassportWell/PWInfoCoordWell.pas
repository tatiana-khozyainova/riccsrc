unit PWInfoCoordWell;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonFrame, StdCtrls, Buttons, ExtCtrls, ComCtrls, Well, BaseObjects,
  Mask, CommonValueDictFrame;

type
  TfrmInfoCoordWell = class(TfrmCommonFrame)
    lbl5: TLabel;
    lbl6: TLabel;
    lbl7: TLabel;
    lbl8: TLabel;
    rb1: TRadioButton;
    rbtn: TRadioButton;
    edtY: TEdit;
    edtX: TEdit;
    edtGradX: TMaskEdit;
    edtGradY: TMaskEdit;
    frmFilterSource: TfrmFilter;
    grp1: TGroupBox;
    pnl: TPanel;
    grp: TGroupBox;
    dtmEnteringDate: TDateTimePicker;
  private
    function GetValueCoord (i, j: Integer; s : string) : string; 

    function GetWell: TWell;
  protected
    procedure FillControls(ABaseObject: TIDObject); override;
    procedure ClearControls; override;
    procedure FillParentControls; override;
    procedure RegisterInspector; override;
    function  GetParentCollection: TIDObjects; override;
  public
    property  Well: TWell read GetWell;

    procedure Save(AObject: TIDObject = nil); override;
    procedure Remove;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  frmInfoCoordWell: TfrmInfoCoordWell;

implementation

uses facade, Coord, MaskUtils;

{$R *.dfm}

{ TfrmInfoCoordWell }

procedure TfrmInfoCoordWell.ClearControls;
begin
  inherited;

  edtGradX.Clear;
  edtGradY.Clear;

  edtX.Clear;
  edtY.Clear;

  dtmEnteringDate.DateTime := Date;

  frmFilterSource.AllObjects := (TMainFacade.GetInstance as TMainFacade).AllSourcesCoord;
  frmFilterSource.cbxActiveObject.Text := '<не указан>';
end;

constructor TfrmInfoCoordWell.Create(AOwner: TComponent);
begin
  inherited;

  edtGradX.EditMask := '00\°00\' + '''' + '00' + DecimalSeparator + '00\' + '''' + '''' + ';1;_';
  edtGradY.EditMask := '00\°00\' + '''' + '00' + DecimalSeparator + '00\' + '''' + '''' + ';1;_';

  //edtGradX.Text := '__°__' + '''' + '__' + DecimalSeparator + '00' + '''' + '''';
end;

destructor TfrmInfoCoordWell.Destroy;
begin

  inherited;
end;

procedure TfrmInfoCoordWell.FillControls(ABaseObject: TIDObject);
var tempX: Double;
begin
  inherited;

  if Assigned (Well) then
  with Well do
  begin
    if Assigned (Coord) then
    begin
      edtGradX.Text := IntToStr(Coord.X_grad) + '\°' + IntToStr(Coord.X_min) + '\' + '''' + FloatToStrF(Coord.X_sec, ffFixed, 4, 2) + '\';
      edtGradY.Text := IntToStr(Coord.Y_grad) + '\°' + IntToStr(Coord.Y_min) + '\' + '''' + FloatToStrF(Coord.Y_sec, ffFixed, 4, 2) + '\';

      dtmEnteringDate.DateTime := Coord.dtmEnteringDate;

      if Assigned (Coord.SourceCoord) then
      begin
        frmFilterSource.ActiveObject := Coord.SourceCoord;
        frmFilterSource.cbxActiveObject.Text := Coord.SourceCoord.Name;
      end;
    end;
  end;
end;

procedure TfrmInfoCoordWell.FillParentControls;
begin
  inherited;

end;

function TfrmInfoCoordWell.GetParentCollection: TIDObjects;
begin

end;

function TfrmInfoCoordWell.GetValueCoord(i, j: Integer; s: string): string;
var k : Integer;
begin
  Result := '';

  for k := i to j do
    Result := Result + s[k];
end;

function TfrmInfoCoordWell.GetWell: TWell;
begin
  Result := EditingObject as TWell;
end;

procedure TfrmInfoCoordWell.RegisterInspector;
begin
  inherited;

end;

procedure TfrmInfoCoordWell.Remove;
begin
  if MessageBox(0, 'Вы действительно хотите удалить координаты выбранной скважины?', 'Предупреждение', MB_YESNO + MB_ICONWARNING + MB_APPLMODAL) = ID_YES then
  begin
    Well.Coords.Remove(Well.Coord);

    //66°48'33,828''
    //59°54'50,609''

    ShowMessage('Координаты были удалены.');
  end;
end;

procedure TfrmInfoCoordWell.Save(AObject: TIDObject = nil);
var o : TWellCoord;
begin
  inherited;

  with Well do
  begin
    // 3-Южно-Шапкинская (-ое)

    if Not Assigned (Coord) then
      o := Well.Coords.Add as TWellCoord;

    Coord.coordX := 3600 * StrToInt(GetValueCoord(1, 2, edtGradX.Text)) +
                    60 * StrToInt(GetValueCoord(4, 5, edtGradX.Text)) +
                    StrToFloat(GetValueCoord(7, Length(edtGradX.Text) - 2, edtGradX.Text));

    Coord.coordY := 3600 * StrToInt(GetValueCoord(1, 2, edtGradY.Text)) +
                    60 * StrToInt(GetValueCoord(4, 5, edtGradY.Text)) +
                    StrToFloat(GetValueCoord(7, Length(edtGradY.Text) - 2, edtGradY.Text));

    if Assigned (frmFilterSource.ActiveObject) then
      Coord.SourceCoord := frmFilterSource.ActiveObject as TSourceCoord;
  end;
end;

end.
