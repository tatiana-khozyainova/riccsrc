unit CRCollectionSampleEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonFrame, ComCtrls, CoreCollection, StdCtrls, ExtCtrls;

type
  TfrmCollectionSampleEdit = class(TfrmCommonFrame)
    gbxAllProperties: TGroupBox;
    txtWell: TStaticText;
    edtSampleNum: TLabeledEdit;
    edtSlottingNumber: TLabeledEdit;
    edtAdditionalNum: TLabeledEdit;
    edtLabNumber: TLabeledEdit;
    edtTopDepth: TLabeledEdit;
    edtBottomDepth: TLabeledEdit;
    edtFromTopDepth: TLabeledEdit;
    edtFromBottomDepth: TLabeledEdit;
    edtAbsDepth: TLabeledEdit;
    txtNum: TStaticText;
    txtIntervals: TStaticText;
    txtStrat: TStaticText;
    txtTopStrat: TStaticText;
    cmbxTopStraton: TComboBox;
    txtBottom: TStaticText;
    cmbxStratBottom: TComboBox;
    chbxStratChecked: TCheckBox;
    txtDates: TStaticText;
    dtpSamplingDate: TDateTimePicker;
    txtSamplingDate: TStaticText;
    txtDesc: TStaticText;
    chbxIsDescripted: TCheckBox;
    chbxIsElDescripted: TCheckBox;
    txtSampleType: TStaticText;
    cmbxSampleType: TComboBox;
    txtPlacing: TStaticText;
    edtRoom: TLabeledEdit;
    edtBox: TLabeledEdit;
  private
    FWell: TCollectionWell;
    procedure SetWell(const Value: TCollectionWell);
    { Private declarations }
  public
    { Public declarations }
    property Well: TCollectionWell read FWell write SetWell;
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmCollectionSampleEdit: TfrmCollectionSampleEdit;

implementation

uses Facade;

{$R *.dfm}

{ TfrmCollectionSampleEdit }

constructor TfrmCollectionSampleEdit.Create(AOwner: TComponent);
begin
  inherited;
  (TMainFacade.GetInstance as TMainFacade).CollectionSampleTypes.MakeList(cmbxSampleType.Items);
  TMainFacade.GetInstance.AllSimpleStratons.MakeMainStratonList(cmbxTopStraton.Items);
  TMainFacade.GetInstance.AllSimpleStratons.MakeMainStratonList(cmbxStratBottom.Items);
end;

procedure TfrmCollectionSampleEdit.SetWell(
  const Value: TCollectionWell);
begin
  FWell := Value;
  txtWell.Caption := FWell.List;
end;

end.
