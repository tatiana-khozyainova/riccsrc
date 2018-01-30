unit CRRockSampleSizeTypeEditFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonIDObjectEditFrame, StdCtrls, ExtCtrls, ComCtrls,
  CommonObjectSelectFrame, BaseObjects, RockSample, ClientCommon;

type
  TfrmRockSampleSizeTypeEditFrame = class(TfrmIDObjectEditFrame)
    edtDiameter: TLabeledEdit;
    frmSampleType: TfrmIDObjectSelect;
    edtX: TLabeledEdit;
    edtY: TLabeledEdit;
    edtZ: TLabeledEdit;
  private
    { Private declarations }
  protected
    procedure FillControls(ABaseObject: TIDObject); override;
    procedure ClearControls; override;
    procedure RegisterInspector; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure   Save(AObject: TIDObject = nil);  override;
  end;

var
  frmRockSampleSizeTypeEditFrame: TfrmRockSampleSizeTypeEditFrame;

implementation

uses BaseGUI, CRSampleTypeListForm;

{$R *.dfm}

{ TfrmSizeTypeEdit }

procedure TfrmRockSampleSizeTypeEditFrame.ClearControls;
begin
  inherited;
  edtDiameter.Clear;
  edtX.Clear;
  edtY.Clear;
  edtZ.Clear;
  frmSampleType.Clear;
end;

constructor TfrmRockSampleSizeTypeEditFrame.Create(AOwner: TComponent);
begin
  inherited;
  EditingClass := TRockSampleSizeType;
  ParentClass := nil;

  frmSampleType.LabelCaption := 'Тип образца';
  frmSampleType.SelectiveFormClass := TfrmSampleTypeList;
  frmSampleType.ObjectSelector := (frmSampleType.SelectorForm as TfrmSampleTypeList);
end;

procedure TfrmRockSampleSizeTypeEditFrame.FillControls(ABaseObject: TIDObject);
begin
  inherited;
  edtDiameter.Text := Format('%.2f', [(EditingObject as TRockSampleSizeType).Diameter]);
  edtX.Text := Format('%.2f', [(EditingObject as TRockSampleSizeType).XSize]);
  edtY.Text := Format('%.2f', [(EditingObject as TRockSampleSizeType).YSize]);
  edtZ.Text := Format('%.2f', [(EditingObject as TRockSampleSizeType).ZSize]);
  frmSampleType.SelectedObject := (EditingObject as TRockSampleSizeType).RockSampleType;
end;

procedure TfrmRockSampleSizeTypeEditFrame.RegisterInspector;
begin
  inherited;
  Inspector.Add(frmSampleType.edtObject, nil, ptString, 'тип образца', false)
end;

procedure TfrmRockSampleSizeTypeEditFrame.Save;
begin
  inherited;
  with IDObject as TRockSampleSizeType do
  begin
    Diameter := StrToFloatEx(edtDiameter.Text);
    XSize := StrToFloatEx(edtX.Text);
    YSize := StrToFloatEx(edtY.Text);
    ZSize := StrToFloatEx(edtZ.Text);
    RockSampleType := frmSampleType.SelectedObject as TRockSampleType;
  end;
end;

end.
