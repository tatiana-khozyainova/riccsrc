unit formReplacement;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, LasFile;

type
  TReplacementFormType = (rftSimple, rftCurves);

  TformReplac = class(TForm)
    edtIn: TEdit;
    edtOut: TEdit;
    btnOk: TButton;
    cmbxCurves: TComboBox;
    procedure cmbxCurvesChange(Sender: TObject);
    procedure edtOutChange(Sender: TObject);
  private
    { Private declarations }
    FinputString : string;
    FOutputString: string;
    FFormType: TReplacementFormType;
    FCurve : TCurve;
    procedure SetinputString(const Value: string);
    procedure SetOutputString(const Value: string);
    procedure SetFormtype(const Value: TReplacementFormType);
    procedure SetCurve (const Value: TCurve);
    function GetCurve: TCurve;
  public
    { Public declarations }
    property FormType: TReplacementFormType read FFormType write SetFormtype;
    property InputString: string read FinputString write SetinputString;
    property OutputString: string read FOutputString write SetOutputString;
    property Curve : TCurve read GetCurve;
    constructor Create(AOwner: TComponent); override;
  end;

var
  formReplac: TformReplac;

implementation

uses Facade, StringUtils;

{$R *.dfm}

{ TformReplac }

constructor TformReplac.Create(AOwner: TComponent);
begin
  inherited;
  FormType := rftSimple;
end;

procedure TformReplac.SetFormtype(const Value: TReplacementFormType);
begin
  FFormType := Value;
  cmbxCurves.Visible := FormType = rftCurves;
end;

procedure TformReplac.SetinputString(const Value: string);
var i: integer;
  tempStr, up1, up2 : string;
begin
  FInputString := Value;
  edtIn.Text := FinputString;
  OutputString := FinputString;
  tempStr:= FinputString;
  for i:=1 to Length(tempStr) do
  if tempStr[i]='.' then
    begin
      Delete (tempStr, i, Length(tempStr)-i+1);
      Break;
    end;

  cmbxCurves.Clear;

  for i := 0 to TMainFacade.GetInstance.AllCurves.Count - 1 do
    begin
    up1 := AnsiUpperCase(TMainFacade.GetInstance.AllCurves.Items[i].ShortName);
    up2 := AnsiUpperCase(tempStr);
      if (Pos(up2, up1) <> 0) then
        begin
        cmbxCurves.AddItem(TMainFacade.GetInstance.AllCurves.Items[i].List(), TMainFacade.GetInstance.AllCurves.Items[i]);
        end;
    end;

    if cmbxCurves.Items.Count > 0 then
    cmbxCurves.ItemIndex := 0;
end;

procedure TformReplac.SetOutputString(const Value: string);
begin
  FOutputString := Value;
  edtOut.Text := FOutputString;
end;

procedure TformReplac.SetCurve(const Value: TCurve);
begin
  FCurve:=Value;
end;


function TformReplac.GetCurve: TCurve;
begin
  if cmbxCurves.ItemIndex > -1 then
    begin
    Result := TCurve(cmbxCurves.Items.Objects[cmbxCurves.ItemIndex]);
    end
  else
    Result := nil;
end;

procedure TformReplac.cmbxCurvesChange(Sender: TObject);
begin
SetOutputString(GetCurve.ShortName);
end;

procedure TformReplac.edtOutChange(Sender: TObject);
begin
SetOutputString(edtOut.Text);
end;

end.
