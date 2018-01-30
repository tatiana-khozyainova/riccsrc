unit RRManagerEditNextSubstructureInfoFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RRManagerBaseObjects, RRManagerObjects,  StdCtrls,
  CommonComplexCombo, RRManagerBaseGUI;

type
//  TfrmNextSubstructureInfo = class(TFrame)
  TfrmNextSubstructureInfo = class(TBaseFrame)
    gbxAll: TGroupBox;
    Label1: TLabel;
    edtClosingIsogypse: TEdit;
    Label2: TLabel;
    EdtPerspectiveArea: TEdit;
    edtAmplitude: TEdit;
    Label4: TLabel;
    edtControlDensity: TEdit;
    Label5: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    edtMapError: TEdit;
  private
    function GetSubstructure: TOldSubstructure;
    { Private declarations }
  protected
    procedure FillControls(ABaseObject: TBaseObject); override;
    procedure ClearControls; override;
    procedure RegisterInspector; override;
  public
    { Public declarations }
    property Substructure: TOldSubstructure read GetSubstructure;
    procedure Save; override;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.DFM}

{ TfrmNextSubstructureInfo }

procedure TfrmNextSubstructureInfo.ClearControls;
begin
  edtClosingIsogypse.Clear;
  edtPerspectiveArea.Clear;
  edtControlDensity.Clear;
  edtAmplitude.Clear;
  edtMapError.Clear;

end;

constructor TfrmNextSubstructureInfo.Create(AOwner: TComponent);
begin
  inherited;

  EditingClass := TOldSubstructure;
end;

procedure TfrmNextSubstructureInfo.FillControls(ABaseObject: TBaseObject);
var S: TOldSubstructure;
begin
  if not Assigned(ABaseObject) then S := Substructure
  else S := ABaseObject as TOldSubstructure;

  edtClosingIsogypse.Text := trim(Format('%7.2f', [S.ClosingIsoGypse]));
  edtPerspectiveArea.Text := trim(Format('%7.2f', [S.PerspectiveArea]));
  edtControlDensity.Text  := trim(Format('%7.2f', [S.ControlDensity]));
  edtAmplitude.Text       := trim(Format('%7.2f', [S.Amplitude]));
  edtMapError.Text        := trim(Format('%7.2f', [S.MapError]));
end;


function TfrmNextSubstructureInfo.GetSubstructure: TOldSubstructure;
begin
  Result := EditingObject as TOldSubstructure;
end;

procedure TfrmNextSubstructureInfo.RegisterInspector;
begin
  inherited;
  // регистрируем контролы, которые под инспектором
  Inspector.Add(edtClosingIsogypse, nil, ptFloat, 'замыкающая изогипса', true);
  Inspector.Add(edtPerspectiveArea, nil, ptFloat, 'перспективная площадь', true);
  Inspector.Add(edtControlDensity,  nil, ptFloat, 'контрольная плотность', true);
  Inspector.Add(edtAmplitude, nil, ptFloat, 'амплитуда', true);
  Inspector.Add(edtMapError, nil, ptFloat, 'случайная ошибка карты', true);
end;

procedure TfrmNextSubstructureInfo.Save;
begin
  inherited;
  try
    Substructure.ClosingIsogypse := StrToFloat(edtClosingIsogypse.Text);
  except
    Substructure.ClosingIsogypse := 0;
  end;

  try
    Substructure.PerspectiveArea := StrToFloat(EdtPerspectiveArea.Text);
  except
    Substructure.PerspectiveArea := 0;
  end;

  try
    Substructure.ControlDensity  := StrToFloat(edtControlDensity.Text);
  except
    Substructure.ControlDensity  := 0;
  end;

  try
    Substructure.Amplitude       := StrToFloat(edtAmplitude.Text);
  except
    Substructure.Amplitude       := 0;
  end;

  try
    Substructure.MapError      := StrToFloat(edtMapError.Text);
  except
    Substructure.MapError      := 0;
  end;
end;

end.
