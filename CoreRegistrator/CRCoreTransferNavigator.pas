unit CRCoreTransferNavigator;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, CoreTransfer, ActnList, ComCtrls, ToolWin, ImgList,
  Menus;

type
  TfrmCoreTransferNavigator = class(TFrame)
    gbxTransfers: TGroupBox;
    tlbrNavigator: TToolBar;
    btnFirst: TButton;
    btnPrev: TButton;
    cmbxCoreTransfer: TComboBox;
    btnNext: TButton;
    btnLast: TButton;
    btnSep: TToolButton;
    btnAdd: TToolButton;
    btnEdit: TToolButton;
    btnDelete: TToolButton;
    actnlst: TActionList;
    actnAdd: TAction;
    actnEdit: TAction;
    actnDelete: TAction;
    imglst: TImageList;
    btnReport: TToolButton;
    actnReportKruchinin: TAction;
    pmReport: TPopupMenu;
    actnReportRogov: TAction;
    N1: TMenuItem;
    N2: TMenuItem;
    actnReportComay: TAction;
    N3: TMenuItem;
    procedure cmbxCoreTransferChange(Sender: TObject);
    procedure btnFirstClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnLastClick(Sender: TObject);
    procedure actnAddExecute(Sender: TObject);
    procedure actnEditExecute(Sender: TObject);
    procedure actnDeleteExecute(Sender: TObject);
    procedure actnEditUpdate(Sender: TObject);
    procedure actnDeleteUpdate(Sender: TObject);
    procedure actnReportKruchininExecute(Sender: TObject);
    procedure actnReportKruchininUpdate(Sender: TObject);
    procedure actnReportRogovExecute(Sender: TObject);
    procedure actnReportRogovUpdate(Sender: TObject);
    procedure actnReportComayExecute(Sender: TObject);
  private
    { Private declarations }
    FActiveCoreTransfer: TCoreTransfer;
    FActiveCoreTransferChanged: TNotifyEvent;
    procedure SetActiveCoreTransfer(const Value: TCoreTransfer);
    procedure RefreshButtonStates;
  public
    { Public declarations }
    property ActiveCoreTransferChanged: TNotifyEvent read FActiveCoreTransferChanged write FActiveCoreTransferChanged;
    property ActiveCoreTransfer: TCoreTransfer read FActiveCoreTransfer write SetActiveCoreTransfer;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses Facade, CRCoreTransferEditForm, Registrator, CRReport, BaseConsts;

{$R *.dfm}

{ TfrmCoreTransferNavigator }

constructor TfrmCoreTransferNavigator.Create(AOwner: TComponent);
begin
  inherited;
  TMainFacade.GetInstance.AllCoreTransfers.MakeList(cmbxCoreTransfer.Items, True, True);
  RefreshButtonStates;
end;

procedure TfrmCoreTransferNavigator.SetActiveCoreTransfer(
  const Value: TCoreTransfer);
begin
  if FActiveCoreTransfer <> Value then
  begin
    FActiveCoreTransfer := Value;
    if Assigned(FActiveCoreTransferChanged) then FActiveCoreTransferChanged(FActiveCoreTransfer);
  end;
end;

procedure TfrmCoreTransferNavigator.cmbxCoreTransferChange(
  Sender: TObject);
begin
  ActiveCoreTransfer := cmbxCoreTransfer.Items.Objects[cmbxCoreTransfer.ItemIndex] as TCoreTransfer;

  RefreshButtonStates;
end;

procedure TfrmCoreTransferNavigator.RefreshButtonStates;
begin
  with TMainFacade.GetInstance.AllCoreTransfers do
  begin
    btnFirst.Enabled := IndexOf(ActiveCoreTransfer) > 0;
    btnPrev.Enabled := IndexOf(ActiveCoreTransfer) > 0;
    btnNext.Enabled := (IndexOf(ActiveCoreTransfer) > -1) and (IndexOf(ActiveCoreTransfer) < Count - 1);
    btnLast.Enabled := (IndexOf(ActiveCoreTransfer) > -1) and (IndexOf(ActiveCoreTransfer) < Count - 1);
  end;
end;

procedure TfrmCoreTransferNavigator.btnFirstClick(Sender: TObject);
begin
  cmbxCoreTransfer.ItemIndex := 1;

  cmbxCoreTransferChange(cmbxCoreTransfer);
end;

procedure TfrmCoreTransferNavigator.btnPrevClick(Sender: TObject);
begin
  cmbxCoreTransfer.ItemIndex := cmbxCoreTransfer.ItemIndex - 1;
  cmbxCoreTransferChange(cmbxCoreTransfer);
end;

procedure TfrmCoreTransferNavigator.btnNextClick(Sender: TObject);
begin
  cmbxCoreTransfer.ItemIndex := cmbxCoreTransfer.ItemIndex + 1;
  cmbxCoreTransferChange(cmbxCoreTransfer);
end;

procedure TfrmCoreTransferNavigator.btnLastClick(Sender: TObject);
begin
  cmbxCoreTransfer.ItemIndex := cmbxCoreTransfer.Items.Count - 1;
  cmbxCoreTransferChange(cmbxCoreTransfer);
end;

procedure TfrmCoreTransferNavigator.actnAddExecute(Sender: TObject);
begin
  if not Assigned(frmCoreTransferForm) then frmCoreTransferForm := TfrmCoreTransferForm.Create(Self);

  frmCoreTransferForm.EditingObject := nil;
  if frmCoreTransferForm.ShowModal = mrOk then
  begin
    frmCoreTransferForm.Save();
    TMainFacade.GetInstance.Registrator.Update(frmCoreTransferForm.EditingObject, nil, ukUpdate);
    cmbxCoreTransfer.ItemIndex := cmbxCoreTransfer.Items.IndexOfObject(frmCoreTransferForm.EditingObject);
    cmbxCoreTransferChange(cmbxCoreTransfer);
  end;
end;

procedure TfrmCoreTransferNavigator.actnEditExecute(Sender: TObject);
begin
  if not Assigned(frmCoreTransferForm) then frmCoreTransferForm := TfrmCoreTransferForm.Create(Self);

  frmCoreTransferForm.EditingObject := ActiveCoreTransfer;
  if frmCoreTransferForm.ShowModal = mrOk then
  begin
    frmCoreTransferForm.Save();
    cmbxCoreTransfer.ItemIndex := cmbxCoreTransfer.Items.IndexOfObject(ActiveCoreTransfer);
    cmbxCoreTransferChange(cmbxCoreTransfer);
 
  end;
end;

procedure TfrmCoreTransferNavigator.actnDeleteExecute(Sender: TObject);
begin
  TMainFacade.GetInstance.AllCoreTransfers.Remove(ActiveCoreTransfer);
  TMainFacade.GetInstance.AllCoreTransfers.Update(nil);
  ActiveCoreTransfer := nil;
  ActiveCoreTransferChanged(nil);
end;

procedure TfrmCoreTransferNavigator.actnEditUpdate(Sender: TObject);
begin
  actnEdit.Enabled := Assigned(ActiveCoreTransfer);
end;

procedure TfrmCoreTransferNavigator.actnDeleteUpdate(Sender: TObject);
begin
  actnDelete.Enabled := Assigned(ActiveCoreTransfer);
end;

procedure TfrmCoreTransferNavigator.actnReportKruchininExecute(Sender: TObject);
begin
  with (TMainFacade.GetInstance.AllReports.ReportByClassType[TCoreTransferReport] as TCoreTransferReport) do
  begin
    SilentMode := false;
    ResponsibleName := CoreDirector1;
    ReportingObject := ActiveCoreTransfer;


    //SaveReport := frmSlottingReportSettings.SaveResult;
    //ReportPath := frmSlottingReportSettings.SavingPath;
    Execute;
  end;
end;

procedure TfrmCoreTransferNavigator.actnReportKruchininUpdate(Sender: TObject);
begin
  actnReportKruchinin.Enabled := Assigned(ActiveCoreTransfer);
end;

procedure TfrmCoreTransferNavigator.actnReportRogovExecute(
  Sender: TObject);
begin
  with (TMainFacade.GetInstance.AllReports.ReportByClassType[TCoreTransferReport] as TCoreTransferReport) do
  begin
    SilentMode := false;
    ResponsibleName := CoreDirector2;
    ReportingObject := ActiveCoreTransfer;


    //SaveReport := frmSlottingReportSettings.SaveResult;
    //ReportPath := frmSlottingReportSettings.SavingPath;
    Execute;
  end;
end;

procedure TfrmCoreTransferNavigator.actnReportRogovUpdate(Sender: TObject);
begin
  actnReportRogov.Enabled := Assigned(ActiveCoreTransfer);
end;

procedure TfrmCoreTransferNavigator.actnReportComayExecute(
  Sender: TObject);
begin
  with (TMainFacade.GetInstance.AllReports.ReportByClassType[TCoreTransferReport] as TCoreTransferReport) do
  begin
    SilentMode := false;
    ResponsibleName := CoreDirector3;
    ReportingObject := ActiveCoreTransfer;


    //SaveReport := frmSlottingReportSettings.SaveResult;
    //ReportPath := frmSlottingReportSettings.SavingPath;
    Execute;
  end;
end;

end.
