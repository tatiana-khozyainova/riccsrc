unit RRManagerReportFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, RRManagerReport, RRManagerBaseObjects,
  RRManagerObjects, RRManagerCreateReportForm, RRManagerPersistentObjects, RRManagerBaseGUI,
  ToolWin, ImgList;

type
//  TfrmSelectReport = class(TFrame)
  TfrmSelectReport = class(TBaseFrame)
    gbxReport: TGroupBox;
    lbxAllReports: TListBox;
    pnlButtons: TPanel;
    chbxRemoveEmpties: TCheckBox;
    prg: TProgressBar;
    pnlEditReportButtons: TPanel;
    imgList: TImageList;
    tlbrReportMan: TToolBar;
    tlbtnEditReport: TToolButton;
    tlbtnAddReport: TToolButton;
    tlbtnDeleteReport: TToolButton;
    procedure lbxAllReportsClick(Sender: TObject);
    procedure btnCreateReportClick(Sender: TObject);
  private
    FReportFilters: TReportFilters;
    FReport: TCommonReport;
    FShowButtons: boolean;
    FShowRemoveEmpties: boolean;
    function GetReportFilter: TReportFilter;
    function GetStructures: TOldStructures;
    procedure SetShowButtons(const Value: boolean);
    procedure SetShowRemoveEmpties(const Value: boolean);
    { Private declarations }
  protected
    FReportLoadAction: TBaseAction;
    FReportEditAction: TBaseAction;
    FReportAddAction: TBaseAction;
    FReportDeleteAction: TBaseAction;
    procedure FillControls(ABaseObject: TBaseObject); override;
    procedure ClearControls; override;
    procedure FillParentControls; override;
    procedure RegisterInspector; override;
  public
    { Public declarations }
    property  Structures: TOldStructures read GetStructures;
    property  ReportFilter: TReportFilter read GetReportFilter;
    property  Report: TCommonReport read FReport;
    property  ShowButtons: boolean read FShowButtons write SetShowButtons;
    property  ShowRemoveEmpties: boolean read FShowRemoveEmpties write SetShowRemoveEmpties;
    procedure Reload;


    procedure   Save; override;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

implementation

uses Facade;


{$R *.DFM}

type
  TReportLoadAction = class(TReportBaseLoadAction)
  public
    function Execute: boolean; override;
  end;


  
  TReportEditAction = class(TReportBaseEditAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; overload; override;
    function Execute: boolean; overload; override;
    function Update: boolean; override;

    constructor Create(AOwner: TComponent); override;
  end;

  TReportAddAction = class(TReportEditAction)
  public
    function Execute: boolean; overload; override;
    function Update: boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;


  TReportDeleteAction = class(TBaseAction)
  public
    function Execute: boolean; overload; override;
    function Execute(ABaseObject: TBaseObject): boolean; overload; override;
    function Update: boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;


{ TfrmSelectReport }



procedure TfrmSelectReport.ClearControls;
begin
  lbxAllReports.ItemIndex := -1;

end;

constructor TfrmSelectReport.Create(AOwner: TComponent);
begin
  inherited;
  FReportFilters := TReportFilters.Create(nil);

  FReportLoadAction := TReportLoadAction.Create(Self);
  FReportEditAction := TReportEditAction.Create(Self);
  FReportAddAction := TReportAddAction.Create(Self);
  FReportDeleteAction := TReportDeleteAction.Create(Self);

  tlbtnAddReport.Action := FReportAddAction;
  tlbtnEditReport.Action := FReportEditAction;
  tlbtnDeleteReport.Action := FReportDeleteAction;

  FReportLoadAction.Execute;

  NeedCopyState := false;
end;

procedure TfrmSelectReport.FillControls(ABaseObject: TBaseObject);
begin
  if Assigned(AllReports) then
  begin
    FReportLoadAction.Execute;
    lbxAllReports.ItemIndex := 0;
  end;
end;

procedure TfrmSelectReport.FillParentControls;
begin
  inherited;

end;

function TfrmSelectReport.GetReportFilter: TReportFilter;
begin
  Result := EditingObject as TReportFilter;
end;

function TfrmSelectReport.GetStructures: TOldStructures;
begin
  if Assigned(ReportFilter) then
    Result := ReportFilter.Structures
  else
    Result := nil;
end;

procedure TfrmSelectReport.Save;
begin
  inherited;
  ReportFilter.Report := Report;
end;

procedure TfrmSelectReport.lbxAllReportsClick(Sender: TObject);
begin
  if lbxAllReports.ItemIndex > -1 then
    FReport := TCommonReport(lbxAllReports.Items.Objects[lbxAllReports.ItemIndex])
  else FReport := nil;

  if Assigned(FReport) then
  begin
    FEditingObject := FReportFilters.GetFilterByReportID(FReport.ID);
    if not Assigned(FEditingObject) then
      FEditingObject := FReportFilters.Add;
    ReportFilter.Report := Report;
  end;
  Check;
end;

destructor TfrmSelectReport.Destroy;
begin
  FReportFilters.Free;
  FReportEditAction.Free;
  FReportLoadAction.Free;
  inherited;
end;

procedure TfrmSelectReport.RegisterInspector;
begin
  inherited;
//  Inspector.Add(lbxAllReports, nil, ptSelect, 'отчёт', false);
end;

procedure TfrmSelectReport.SetShowButtons(const Value: boolean);
begin
  FShowButtons := Value;
  pnlEditReportButtons.Visible := Value;
end;

procedure TfrmSelectReport.Reload;
begin
  if AllReports.NeedsUpdate then
    FReportLoadAction.Execute; 
end;

procedure TfrmSelectReport.SetShowRemoveEmpties(const Value: boolean);
begin
  FShowRemoveEmpties := Value;
  pnlButtons.Visible := Value;
end;

{ TReportLoadAction }

function TReportLoadAction.Execute: boolean;
begin
  AllReports := TReports.Create(nil);

  Result := inherited Execute;
  with Owner as TfrmSelectReport do
  begin
    lbxAllReports.Items.BeginUpdate;

    lbxAllReports.Clear;
    AllReports.MakeList(lbxAllReports.Items, AllOpts.Current.ListOption, false);
    lbxAllReports.Items.EndUpdate;
    FReport := nil;
  end;
end;

procedure TfrmSelectReport.btnCreateReportClick(Sender: TObject);
begin
//
end;

{ TReportEditAction }

constructor TReportEditAction.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Редактировать отчет';  
  CanUndo := false;
  Visible := true;
  ImageIndex := 1;
end;

function TReportEditAction.Execute: boolean;
begin
  Result := Execute((Owner as TfrmSelectReport).Report);
end;

function TReportEditAction.Execute(ABaseObject: TBaseObject): boolean;
var lbx: TListBox;
begin
  LastCollection := AllReports;
  Result := Inherited Execute(ABaseObject);

  // обновляем представление
  lbx := (Owner as TfrmSelectReport).lbxAllReports;
  if not LastCollection.NeedsUpdate and Assigned(ABaseObject) then
    lbx.Items[lbx.ItemIndex] := ABaseObject.List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false)
  else
  begin
    AllReports.NeedsUpdate := true;
    (Owner as TfrmSelectReport).FReportLoadAction.Execute;
  end;
end;

function TReportEditAction.Update: boolean;
begin
  inherited Update;
  Result :=  Assigned(AllReports) and Assigned((Owner as TfrmSelectReport).Report);

  Enabled := Result;
end;

{ TReportAddAction }

constructor TReportAddAction.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Добавить отчет';
  CanUndo := false;
  Visible := true;
  ImageIndex := 0;  
end;

function TReportAddAction.Execute: boolean;
begin
  Result := inherited Execute(nil);
end;

function TReportAddAction.Update: boolean;
begin
  inherited Update;

  Result := Assigned(AllReports);

  Enabled := Result;
end;

{ TReportDeleteAction }

constructor TReportDeleteAction.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Удалить отчет';
  CanUndo := false;
  Visible := true;
  ImageIndex := 2;
end;

function TReportDeleteAction.Execute: boolean;
begin
  Result := Execute((Owner as TfrmSelectReport).Report);
end;

function TReportDeleteAction.Execute(ABaseObject: TBaseObject): boolean;
var dp: TDataPoster;
    lbx: TListBox;
begin
  Result := true;
  if MessageBox(0, PChar('Вы действительно хотите удалить отчёт ' +  #13#10 +
                         ABaseObject.List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false) + '?'), 'Вопрос',
                         MB_YESNO+MB_APPLMODAL+MB_DEFBUTTON2+MB_ICONQUESTION) = ID_YES then
  begin
    dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TReportsDataPoster];
    dp.DeleteFromDB(ABaseObject);
    lbx := (Owner as TfrmSelectReport).lbxAllReports;

    lbx.Items.Delete(lbx.ItemIndex);
    (Owner as TfrmSelectReport).FReport := nil;

    AllReports.NeedsUpdate := true;
  end;
end;

function TReportDeleteAction.Update: boolean;
begin
  inherited Update;
  Result :=  Assigned(AllReports) and Assigned((Owner as TfrmSelectReport).Report);

  Enabled := Result;
end;

end.
