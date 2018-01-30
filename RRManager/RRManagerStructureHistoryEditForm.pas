unit RRManagerStructureHistoryEditForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, RRManagerEditHistoryFrame, RRManagerObjects,
  RRManagerBaseGUI, FramesWizard, RRManagerDiscoveredStructureInfo, RRManagerPreparedStructureInfo,
  RRManagerDrilledStructureInfo, RRManagerEditMainFieldInfoFrame, RRManagerPersistentObjects, RRManagerDataPosters;

type
//  TfrmStructureHistoryEdit = class(TSingleFramedForm)
  TfrmStructureHistoryEdit = class(TCommonForm)
    DialogFrame1: TDialogFrame;
  private
    FStructure: TOldStructure;
    function GetStructureHistoryElement: TOldStructureHistoryElement;
    function GetStructure: TOldStructure;
    { Private declarations }
  protected
    function  GetDlg: TDialogFrame; override;
    procedure NextFrame(Sender: TObject); override;
    function  GetEditingObjectName: string; override;
  public
    { Public declarations }
    property    RealStructure: TOldStructure read FStructure write FStructure;
    procedure   Prepare(AStructureFundTypeID: integer);
    property    HistoryElement: TOldStructureHistoryElement read GetStructureHistoryElement;
    property    Structure: TOldStructure read GetStructure;
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmStructureHistoryEdit: TfrmStructureHistoryEdit;

implementation

uses Facade;

{$R *.dfm}

{ TfrmStructureHistoryEdit }

constructor TfrmStructureHistoryEdit.Create(AOwner: TComponent);
begin
  inherited;
//  FrameClass := TfrmHistory;
  Prepare(1);
end;

function TfrmStructureHistoryEdit.GetDlg: TDialogFrame;
begin
  Result := DialogFrame1;
end;

function TfrmStructureHistoryEdit.GetEditingObjectName: string;
begin
  if Assigned(HistoryElement) then
  begin
    if dlg.ActiveFrameIndex = 0 then
      Result := HistoryElement.List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false)
    else
      Result := Structure.List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false);
  end;
end;

function TfrmStructureHistoryEdit.GetStructure: TOldStructure;
begin
  if Assigned(HistoryElement) then
    Result := HistoryElement.HistoryStructure
  else Result := RealStructure;  
end;

function TfrmStructureHistoryEdit.GetStructureHistoryElement: TOldStructureHistoryElement;
begin
  if EditingObject is TOldStructureHistoryElement then
    Result := EditingObject as TOldStructureHistoryElement
  else Result := nil;
end;

procedure TfrmStructureHistoryEdit.NextFrame(Sender: TObject);
var cls: TBaseFrameClass;
    i: integer;
    dp: TDataPoster;
    frm: TBaseFrame;
begin
  if dlg.ActiveFrameIndex = 0 then
  begin
    cls := TfrmDiscoveredStructureInfo;
    dp := nil;
    case HistoryElement.FundTypeID of
    // Выявленные
    1: begin
         cls := TfrmDiscoveredStructureInfo;
         dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TDiscoveredStructureDataPoster];
       end;
    // подгтовленные
    2: begin
         cls := TfrmPreparedStructureInfo;
         dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TPreparedStructureDataPoster];
       end;
    // в бурении
    3: begin
         cls := TfrmDrilledStructureInfo;
         dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TDrilledStructureDataPoster];
       end;
    // месторождения
    4: begin
         cls := TfrmMainFieldInfo;
         dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TFieldDataPoster];
       end;
    end;

    if not (dlg.Frames[1] is cls) then
    begin
      // добавяляем нормальные фрэймы
      for i := dlg.FrameCount - 1 downto 1 do
        dlg.Delete(i);

      frm := dlg.AddFrame(cls) as TBaseFrame;
      frm.NeedCopyState := false;
    end;
    // скачать информацию о структуре
    if Assigned(dp) then
    begin
      dp.GetFromDB(RealStructure.ID);
      
      if Assigned(dp.LastGotObject) then
        Structure.Assign(dp.LastGotObject);

      Structure.StructureMainParamsAssign(RealStructure);
      (dlg.Frames[dlg.ActiveFrameIndex + 1] as TBaseFrame).EditingObject := Structure;
    end;
    // проверить правильность
    (dlg.Frames[dlg.ActiveFrameIndex + 1] as TBaseFrame).Check;
  end
  else inherited;
end;

procedure TfrmStructureHistoryEdit.Prepare(AStructureFundTypeID: integer);
var frm: TBaseFrame;
begin
  dlg.Clear;
  dlg.CloseAfterFinish := true;
  if AStructureFundTypeID in [1, 2, 3, 4] then
  begin
    frm := dlg.AddFrame(TfrmHistory) as TBaseFrame;
    frm.NeedCopyState := false;
  end;

  frm := dlg.AddFrame(TfrmHistory) as TBaseFrame;
  frm.NeedCopyState := false;
    
  dlg.ActiveFrameIndex := 0;
  dlg.FinishEnableIndex := dlg.FrameCount - 1;
end;

end.

