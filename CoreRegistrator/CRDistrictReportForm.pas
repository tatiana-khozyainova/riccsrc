unit CRDistrictReportForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, CommonFrame, CommonParentChildTreeFrame, District,
  BaseObjects, Mask, ToolEdit;

type
  TfrmDistrictReportForm = class(TForm)
    pnlButtons: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    frmDistricts: TfrmParentChild;
    gbxSettings: TGroupBox;
    chbxAreaTotals: TCheckBox;
    chbxDistrictTotals: TCheckBox;
    chbxOverallTotal: TCheckBox;
    chbxSaveFiles: TCheckBox;
    edtReportPath: TDirectoryEdit;
    procedure chbxSaveFilesClick(Sender: TObject);
  private
    FDistrict: TDistrict;
    function GetSelectedObject: TIDObject;
    function GetSelectedObjects: TIDObjects;
    procedure SetDistrict(const Value: TDistrict);
    function GetAreaTotals: boolean;
    function GetDistrictTotals: boolean;
    function GetOverallTotal: boolean;
    function GetSaveResult: boolean;
    function GetSavingPath: string;
    { Private declarations }
  public
    { Public declarations }
    property MainDistrict: TDistrict read FDistrict write SetDistrict;
    property SelectedObject: TIDObject read GetSelectedObject;
    property SelectedObjects: TIDObjects read GetSelectedObjects;

    property AreaTotals: boolean read GetAreaTotals;
    property DistrictTotals: boolean read GetDistrictTotals;
    property OverallTotal: boolean read GetOverallTotal;
    property SaveResult: boolean read GetSaveResult;
    property SavingPath: string read GetSavingPath;
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmDistrictReportForm: TfrmDistrictReportForm;

implementation

uses Facade, SDFacade;

{$R *.dfm}

{ TfrmDistrictReportForm }

constructor TfrmDistrictReportForm.Create(AOwner: TComponent);
begin
  inherited;
  MainDistrict := TMainFacade.GetInstance.AllDistricts.ItemsByID[0] as TDistrict;
  frmDistricts.MultiSelect := true;
  frmDistricts.SelectableLayers := [1,2];
end;

function TfrmDistrictReportForm.GetAreaTotals: boolean;
begin
  Result := chbxAreaTotals.Checked;
end;

function TfrmDistrictReportForm.GetDistrictTotals: boolean;
begin
  Result := chbxDistrictTotals.Checked;
end;

function TfrmDistrictReportForm.GetOverallTotal: boolean;
begin
  Result := chbxOverallTotal.Checked;
end;

function TfrmDistrictReportForm.GetSaveResult: boolean;
begin
  Result := chbxSaveFiles.Checked;
end;

function TfrmDistrictReportForm.GetSavingPath: string;
begin
  Result := edtReportPath.Text;
end;

function TfrmDistrictReportForm.GetSelectedObject: TIDObject;
begin
  Result := frmDistricts.SelectedObject;
end;

function TfrmDistrictReportForm.GetSelectedObjects: TIDObjects;
begin
  Result := frmDistricts.SelectedObjects;
end;

procedure TfrmDistrictReportForm.SetDistrict(const Value: TDistrict);
begin
  if FDistrict <> Value then
  begin
    FDistrict := Value;
    frmDistricts.Root := FDistrict;
  end;

end;

procedure TfrmDistrictReportForm.chbxSaveFilesClick(Sender: TObject);
begin
  edtReportPath.Enabled := chbxSaveFiles.Checked;
end;

end.
