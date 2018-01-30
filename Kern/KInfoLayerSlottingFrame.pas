unit KInfoLayerSlottingFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, RXSpin, CoreDescription,
  KInfoRockSampleFrame, Slotting;

type
  TfrmInfoLayerSlotting = class(TFrame)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    frmRockSample: TfrmRockSample;
    cbxDummy: TCheckBox;
    edtNumber: TRxSpinEdit;
    edtBegin: TRxSpinEdit;
    edtEnd: TRxSpinEdit;
    edtCapacity: TRxSpinEdit;
    procedure cbxDummyClick(Sender: TObject);

    procedure AppControlChange(Sender: TObject);
    function  CheckError (ANeedAllCheck: boolean = false) : boolean;
    procedure frmRockSampleToolButton1Click(Sender: TObject);
  private
    FLayer: TDescriptedLayer;
    FSlotting: TSlotting;
    FActiveControl: string;
  public
    property    Layer: TDescriptedLayer read FLayer write FLayer;
    property    Slotting: TSlotting read FSlotting write FSlotting;
    property    ActiveControl: string read FActiveControl write FActiveControl;

    procedure   Clear;
    procedure   Reload;
    function    Save: boolean;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

implementation

uses LayerSlotting, Math, BaseWellInterval, RockSample;

{$R *.dfm}

{ TfrmInfoLayerSlotting }

procedure TfrmInfoLayerSlotting.Clear;
begin
  frmRockSample.Clear;
end;

constructor TfrmInfoLayerSlotting.Create(AOwner: TComponent);
begin
  inherited;
  ActiveControl := '';
  Screen.OnActiveControlChange := AppControlChange;
end;

destructor TfrmInfoLayerSlotting.Destroy;
begin

  inherited;
end;

procedure TfrmInfoLayerSlotting.Reload;
begin
  try
    if FLayer.ID <> 0 then
    begin
      edtNumber.Value := StrToInt(FLayer.Name);
      edtEnd.Value := FLayer.EndingLayer;
      edtBegin.Value := FLayer.BeginingLayer;
      edtCapacity.Value := FLayer.Capacity;
      cbxDummy.Checked := FLayer.DummyLayer;
    end
    else
    begin
      edtNumber.Value := 1;
      edtEnd.Value := Slotting.Bottom;
      edtBegin.Value := Slotting.Top;
      edtCapacity.Value := Slotting.Bottom - Slotting.Top;
      cbxDummy.Checked := True;
    end;
  except

  end;

  frmRockSample.ActiveLayer := FLayer;
  frmRockSample.Reload;
end;

function TfrmInfoLayerSlotting.Save: boolean;
begin
  Result := false;

  if edtNumber.Value > 0 then
  begin
    if CheckError(true) then
    begin
      FLayer.Name := FloatToStr(edtNumber.Value);
      FLayer.BeginingLayer := edtBegin.Value;
      FLayer.EndingLayer := edtEnd.Value;
      FLayer.Capacity := RoundTo(edtCapacity.Value, -2);

      if cbxDummy.Checked then Layer.DummyLayer := true
      else Layer.DummyLayer := false;

      if frmRockSample.Save then Result := true
      else if MessageBox(0, 'Информация по образцам заполнена неполностью.' + #10#13 + 'Все равно продолжить?',
                         'Предупреждение', MB_SYSTEMMODAL + MB_YESNO + MB_ICONWARNING + MB_DEFBUTTON2) = ID_YES then Result := true;
    end;
  end
  else MessageBox(0, 'Не указан номер слоя.', 'Ошибка', MB_OK + MB_ICONERROR + MB_APPLMODAL);
end;

procedure TfrmInfoLayerSlotting.cbxDummyClick(Sender: TObject);
begin
  if (Sender as TCheckBox).Checked then
    Layer.DummyLayer := true
  else Layer.DummyLayer := false;
end;

procedure TfrmInfoLayerSlotting.AppControlChange(Sender: TObject);
begin
  {
  try
    if (ActiveControl <> '') and (ActiveControl <> TScreen(Sender).ActiveForm.ActiveControl.name) then
    begin
      if Sender is TScreen then
        ActiveControl := TScreen(Sender).ActiveForm.ActiveControl.name;

      CheckError(false);
    end;

    if ActiveControl = '' then
    if Sender is TScreen then
      ActiveControl := TScreen(Sender).ActiveForm.ActiveControl.name;
  except

  end;
  }
end;

function TfrmInfoLayerSlotting.CheckError(ANeedAllCheck: boolean): boolean;
var temp: Double;
begin
  try
    Result := true;

    if Assigned((FLayer.Collection as TDescriptedLayers).GetItemsByNumber(StrToFloat(edtNumber.Text))) and (FLayer.ID = 0) then
    begin
      MessageBox(0, 'Слой с таким номером уже существует в данном долблении', 'Ошибка', MB_ICONERROR + MB_SYSTEMMODAL + MB_OK);
      edtNumber.Value := StrToInt(Layer.Name);
      Result := false;
    end;

    temp := edtBegin.Value;
    if (temp >= ((Layer.Collection as TDescriptedLayers).Owner as TSlotting).Top) and
       (temp <= ((Layer.Collection as TDescriptedLayers).Owner as TSlotting).Bottom) then
    begin
      if edtEnd.Value >= edtBegin.Value then
        edtCapacity.Value := edtEnd.Value - edtBegin.Value
      else if edtEnd.Value > 0 then
      begin
        MessageBox(0, 'Значение "Начало слоя" не может быть больше значения "Окончание слоя"', 'Ошибка', MB_OK + MB_SYSTEMMODAL + MB_ICONERROR);
        edtBegin.Value := Layer.BeginingLayer;
        Result := false;
      end;
    end
    else
    if ((edtBegin.Value > 0) and (not ANeedAllCheck)) or (ANeedAllCheck) then
    begin
      MessageBox(0, 'Значение "Начало слоя" не попадает в интервал долбления', 'Ошибка', MB_OK + MB_SYSTEMMODAL + MB_ICONERROR);
      edtBegin.Value := Layer.BeginingLayer;
      Result := false;
    end;

    temp := edtEnd.Value;
    if (temp <= ((Layer.Collection as TDescriptedLayers).Owner as TSlotting).Bottom) and
       (temp >= ((Layer.Collection as TDescriptedLayers).Owner as TSlotting).Top) then
    begin
      if edtEnd.Value >= edtBegin.Value then
        edtCapacity.Value := edtEnd.Value - edtBegin.Value
      else
      begin
        MessageBox(0, 'Значение "Окончание слоя" не может быть меньше значения "Начало слоя"', 'Ошибка', MB_OK + MB_SYSTEMMODAL + MB_ICONERROR);
        edtEnd.Value := Layer.EndingLayer;
        Result := false;
      end
    end
    else
    if ((edtEnd.Value > 0) and (not ANeedAllCheck)) or (ANeedAllCheck) then
    begin
      MessageBox(0, 'Значение "Окончание слоя" не попадает в интервал долбления', 'Ошибка', MB_OK + MB_SYSTEMMODAL + MB_ICONERROR);
      edtEnd.Value := Layer.EndingLayer;
      Result := false;
    end;
  except

  end;
end;

procedure TfrmInfoLayerSlotting.frmRockSampleToolButton1Click(
  Sender: TObject);
begin
  frmRockSample.actnAddExecute(Sender);

end;

end.
