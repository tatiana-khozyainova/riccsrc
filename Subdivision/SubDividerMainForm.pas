unit SubDividerMainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ActnList, ToolWin, ComCtrls, Menus, ComObj, StdCtrls, Buttons, ExtCtrls,
  SubDividerEditFrame, SubDividerCommonObjects, CommonFilter, ImgList,
  OleServer, Excel2000, Variants, ExcelXP;

type
  TfrmSubDividerMain = class(TForm)
    mnu: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    tbbr: TToolBar;
    actnlst: TActionList;
    TryToConnect: TAction;
    CloseForm: TAction;
    Convert: TAction;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    gbxAllSubDivision: TGroupBox;
    pnlLeft: TPanel;
    pnlSearch: TPanel;
    Label1: TLabel;
    spdbtnDeselectAll: TSpeedButton;
    edtName: TEdit;
    pnlButtons: TPanel;
    prg: TProgressBar;
    lswSearch: TListView;
    pnlRight: TPanel;
    lwWells: TListView;
    splt: TSplitter;
    ReloadAction: TAction;
    N8: TMenuItem;
    EditSelected: TAction;
    SelectAll: TAction;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    About: TAction;
    frmEditSubDivision1: TfrmEditSubDivision;
    DeselectAll: TAction;
    imgLst: TImageList;
    ExcelReport: TAction;
    N12: TMenuItem;
    MSExcel1: TMenuItem;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton8: TToolButton;
    Gather: TAction;
    Excel: TExcelApplication;
    N13: TMenuItem;
    pmn: TPopupMenu;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    MSExcel2: TMenuItem;
    ExcelReportWithTops: TAction;
    ExcelReportWithTops1: TMenuItem;
    ToolButton7: TToolButton;
    actnNGRExcelExport: TAction;
    N20: TMenuItem;
    actnNGRExcelExport1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure TryToConnectExecute(Sender: TObject);
    procedure CloseFormExecute(Sender: TObject);
    procedure ConvertExecute(Sender: TObject);
    procedure ConvertUpdate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SetActiveButton (Value: TSpeedButton);
    procedure lswSearchKeyPress(Sender: TObject; var Key: Char);
    procedure lswSearchMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure spdbtnDeselectAllClick(Sender: TObject);
    procedure edtNameChange(Sender: TObject);
    procedure ReloadActionExecute(Sender: TObject);
    procedure AboutExecute(Sender: TObject);
    procedure EditSelectedExecute(Sender: TObject);
    procedure SelectAllExecute(Sender: TObject);
    procedure DeselectAllExecute(Sender: TObject);
    procedure WordReportExecute(Sender: TObject);
    procedure ExcelReportExecute(Sender: TObject);
    procedure lswSearchInfoTip(Sender: TObject; Item: TListItem;
      var InfoTip: String);
    procedure GatherExecute(Sender: TObject);
    procedure ExcelReportUpdate(Sender: TObject);
    procedure lwWellsCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure lwWellsColumnClick(Sender: TObject; Column: TListColumn);
    procedure SelectAllUpdate(Sender: TObject);
    procedure DeselectAllUpdate(Sender: TObject);
    procedure ExcelReportWithTopsExecute(Sender: TObject);
    procedure lwWellsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure actnNGRExcelExportExecute(Sender: TObject);
    procedure actnNGRExcelExportUpdate(Sender: TObject);
  private
    FLastWorkBookFileName: string;
  private
    { Private declarations }
    Filters:  TWellFilters;
    FActiveButton: TSpeedButton;
    vWells: variant;
    FChanged: boolean;
    property  ActiveButton: TSpeedButton read FActiveButton write SetActiveButton;
    procedure ClearWells;
    procedure ReloadWells(const AFilterID: integer; Output: boolean);
    procedure ReloadStratons;
    procedure CreateButtons(FilterTable: variant);
    procedure btnClickAction(Sender: TObject);
    procedure FormsFree;
    procedure CreateAll;
    procedure actnListDisable;
    //procedure ResendMesage(var Message: TMessage); message WM_SELECTION_CHANGED;
    function  GetCurrentlySelected: string;
    function  CheckedCount: integer;
    property  LastWorkBookFileName: string read FLastWorkBookFileName write FLastWorkBookFileName;
    procedure MakeExcelReport;
  public
    { Public declarations }
    ColumnToSort: integer;

    property  Changed: boolean read FChanged write FChanged;
  end;

  TVisibleWell = class(TWell)
  public
    function  UpdateWell(AWellUIN: integer; AAreaName, AWellNum: string; const AAltitude, ADepth: single; DB: boolean): integer; override;
  end;

  TVisibleWells = class(TWells)
  public
    function  AddWell(AWellUIN: integer; AAreaName, AWellNum: string; const AAltitude, ADepth: single; const WithSubdivisions: boolean): TWell; override;
    function  DeleteWell(const Index: integer; DB: boolean): integer; override;
  end;


var
  frmSubDividerMain: TfrmSubDividerMain;

implementation

uses ClientCommon, SubDividerCommon, PasswordForm,
  ClientProgressBarForm, SubDividerConvertingForm, DNRClientAboutForm,
  SubDividerEditForm, SubDividerComponentEditFrame,
  SubDividerComponentEditForm, SubDividerProgressForm,
  SubDividerNGRExportForm;

{$R *.DFM}

function CompareFloat(const F1, F2: single): integer;
begin
  Result := 0;
  if F1 > F2 then Result := 1
  else if F1 = F2 then Result := 0
  else if F1 < F2 then Result := -1;
end;


function   TVisibleWells.AddWell(AWellUIN: integer; AAreaName, AWellNum: string; const AAltitude, ADepth: single; const WithSubdivisions: boolean): TWell;
var P: PWell;
    W, w1: TWell;
    lstItem: TListItem;
begin
  Result := inherited AddWell(AWellUIN, AAreaName, AWellNum, AAltitude, ADepth, WithSubdivisions);
  if Assigned(Result) then
  begin
    w1 := AllWells.WellByUIN(Result.WellUIN);
    w  := AllWells.AddWell(Result, true);
    if not Assigned(w1) then
    with Result do
    begin
      lstItem := frmSubDividerMain.lwWells.Items.Add;
      lstItem.Caption := w.WellNum;
      lstItem.SubItems.Add(w.AreaName);
      lstItem.SubItems.Add(Format('%5.2f', [w.Depth]));
      lstItem.SubItems.Add(Format('%5.2f', [w.Altitude]));

      lstItem.ImageIndex := 5;
      New(P);
      P^ := w;
      lstItem.Data := P;
      lstItem.Checked := true;
    end;
  end;
end;


function   TVisibleWells.DeleteWell(const Index: integer; DB: boolean): integer;
var i, iWellUIN: integer;
    w: TWell;
begin
  iWellUIN := Self.Items[Index].WellUIN;
  Result := inherited DeleteWell(Index, DB);
  if Result >= 0 then
  with frmSubDividerMain.lwWells do
  for i := 0 to Items.Count - 1 do
  if iWellUIN = PWell(Items[i].Data)^.WellUIN then
  begin
    PWell(Items[i].Data)^.Free;
    Dispose(Items[i].Data);
    Items.Delete(i);
    break;
  end;
end;

function  TVisibleWell.UpdateWell(AWellUIN: integer; AAreaName, AWellNum: string; const AAltitude, ADepth: single; DB: boolean): integer;
var i, iWellUIn: integer;
    w: TWell;
begin
  iWellUIN := Self.WellUIN;
  Result := inherited UpdateWell(AWellUIN, AAreaName, AWellNum, AAltitude, ADepth, DB);
  w := AllWells.AddWell(Self, false);
  if Result >= 0 then
  begin
    if Assigned(w) then w.UpdateWell(AWellUIN, AAreaName, AWellNum, AAltitude, ADepth, false);
    with frmSubDividerMain.lwWells do
    for i := 0 to Items.Count - 1 do
    if WellUIN = PWell(Items[i].Data)^.WellUIN then
    begin
      Items[i].Caption := WellNum;
      Items[i].SubItems.Add(AreaName);
      Items[i].SubItems.Add(Format('%5.2f', [Depth]));
      Items[i].SubItems.Add(Format('%5.2f', [Altitude]));
      break;
    end;
  end;
end;


function CreateFilterTable: variant;
begin
  // таблица задействованных таблиц
  // 0 - идентификатор
  // 1 - аглицкое название
  // 2 - название ключа
  // 3 - русское название
  // 4 - ограничение при скачивании справочника
  // 5 - индекс картинки
  // 6 - строка сортировки
  Result := varArrayCreate([0,6,0,4],varVariant);

  Result[0,0] := 0;
  Result[1,0] := 'TBL_TIME';
  Result[2,0] := 's.DTM_ENTERING_DATE';
  Result[3,0] := 'Время';
  Result[4,0] := '';
  Result[5,0] := 0;
  Result[6,0] := '';

  Result[0,1] := 1;
  Result[1,1] := 'SPD_GET_AREA_DICT';
  Result[2,1] := 'A.AREA_ID';
  Result[3,1] := 'Площади';
  Result[4,1] := '';
  Result[5,1] := 1;
  Result[6,1] := '';

  Result[0,2] := 2;
  Result[1,2] := 'SPD_GET_PETROL_REGION_DICT';
  Result[2,2] := 'PETROL_REGION_ID';
  Result[3,2] := 'НГР';
  Result[4,2] := 'NUM_REGION_TYPE=3';
  Result[5,2] := 2;
  Result[6,2] := '';


  Result[0,3] := 3;
  Result[1,3] := 'SPD_GET_TECTONIC_STRUCT_DICT';
  Result[2,3] := 'STRUCT_ID';
  Result[3,3] := 'Тектонические структуры';
  Result[4,3] := 'NUM_STRUCT_TYPE=3 OR NUM_STRUCT_TYPE=4';
  Result[5,3] := 3;
  Result[6,3] := 'vch_Struct_Full_Name';

  Result[0,4] := 4;
  Result[1,4] := 'TBL_DISTRICT_DICT';
  Result[2,4] := 'DISTRICT_ID';
  Result[3,4] := 'Географические регионы';
  Result[4,4] := '';
  Result[5,4] := 4;
  Result[6,4] := '';

end;

{procedure TfrmSubDividerMain.ResendMesage(var Message: TMessage);
begin
  SendMessage(frmEditAll.Handle, WM_SELECTION_CHANGED, Message.WParam, Message.LParam);
end;}


procedure TfrmSubDividerMain.actnListDisable;
var i: integer;
begin
  for i:=0 to actnLst.ActionCount - 1 do
  with actnLst.Actions[i] as TAction do
  if Tag>0 then
  begin
    Visible:=false;
    Enabled:=false;
  end;
end;

procedure TfrmSubDividerMain.CreateAll;
var vFilterTable: variant;
    sFrom: string;
begin
  AllDicts := TDicts.Create;
  AllStratons := TStratons.Create(true);
  AllSynonyms := TSynonymStratons.Create(AllStratons);
  AllRegions := TRegions.Create(true);
  AllWells := TWells.Create(TWell);
  ActiveWells := TVisibleWells.Create(TVisibleWell);
  
  gbxAllSubDivision.Enabled := true;

  vFilterTable := CreateFilterTable;

  sFrom :=  'select distinct w.Well_UIN, vch_Well_Num, a.vch_Area_Name, num_Rotor_Altitude,' +
            ' num_True_Depth from tbl_Well w, tbl_subdivision_component s, tbl_well_position p,'+
            ' tbl_Area_Dict a where w.Well_UIN = s.Well_UIN' +
            ' and p.well_uin = w.Well_UIN and a.area_id = w.Area_ID';
  Filters := TWellFilters.Create(sFrom,vFilterTable,lswSearch, prg);
  //imgLst.GetBitmap(0,spdbtnDeselectAll.Glyph);
  CreateButtons(vFilterTable);
end;

procedure TfrmSubDividerMain.btnClickAction(Sender: TObject);
begin
  ActiveButton := (Sender as TSpeedButton);
end;

procedure TfrmSubDividerMain.ClearWells;
var i: integer;
begin
  with lwWells do
  begin
    frmEditSubDivision1.ClearAll;
    for i := 0 to Items.Count - 1 do
    begin
      if Assigned(PWell(Items[i].Data)^) then
         PWell(Items[i].Data)^.Free;
      Dispose(Items[i].Data);
    end;
    Items.Clear;
    AllWells.Clear;
  end;
end;

procedure TfrmSubDividerMain.ReloadWells(const AFilterID: integer; Output: boolean);
var sSQL: string;
    i: integer;
    w: TWell;
    iWellUIN: integer;
    sWellNum, sAreaName: string;
    fAltitude, fDepth: single;
    P: PWell;
    lstItem: TListItem;
begin
  Changed := true;
  if AFilterID>-1 then Filters.LoadFilter(AFilterID);
  sSQL := Filters.CreateSQLFilter;
  if (sSQL<>'') and (IServer.ExecuteQuery(sSQL)>=0) then
    vWells := IServer.QueryResult
  else if not varIsEmpty(vWells) then
    vWells := Unassigned;

  ClearWells;  

  if Output and not varIsEmpty(vWells) then
  begin
    // загружаем скважины
    for i := 0 to varArrayHighBound(vWells, 2) do
    begin
      iWellUIN := vWells[0, i];
      sAreaName := vWells[2, i];
      sWellNum := vWells[1, i];
      fAltitude := vWells[3, i];
      fDepth := vWells[4, i];
      w := AllWells.AddWell(iWellUIN, sAreaName, sWellNum, fAltitude, fDepth, false);
      with w do
      begin
        lstItem := lwWells.Items.Add;
        lstItem.Caption := w.WellNum;
        lstItem.SubItems.Add(w.AreaName);
        lstItem.SubItems.Add(Format('%5.2f', [w.Depth]));
        lstItem.SubItems.Add(Format('%5.2f', [w.Altitude]));
        lstItem.ImageIndex := 5;
        New(P);
        P^ := w;
        lstItem.Data := P;
      end;
    end;
  end;
end;

procedure TfrmSubDividerMain.CreateButtons(FilterTable: variant);
var i, iHB,iTop: integer;
    btn: TSpeedButton;
begin
  iHB := varArrayHighBound(FilterTable,2);
  pnlButtons.Height := (iHB+1)*21+14;
  iTop := 7; //btn := nil;
  for i:=iHB downto 0 do
  begin
    btn := TSpeedButton.Create(pnlButtons);
    with btn do
    begin
      btn.Parent := pnlButtons;
      Width := pnlButtons.Width - 2; Height:= 21;
      Top := pnlButtons.Height - 21 - iTop;
      Left := 1; Visible:=true; GroupIndex:=1;
      Caption := FilterTable[3,i];
      Tag := FilterTable[0,i]; Margin := 3; Spacing := 7;
      Anchors := [akTop, akLeft, akRight];
      if (FilterTable[5,i]>-1) and (FilterTable[5,i]<ImgLst.Count) then
        ImgLst.GetBitmap(FilterTable[5,i],Glyph);
      OnClick := btnClickAction;
    end;
    inc(iTop,21);
  end;
  FActiveButton := nil;
  ActiveButton := (pnlButtons.Controls[3] as TSpeedButton);
end;


procedure TfrmSubDividerMain.FormsFree;
begin
  gbxAllSubDivision.Enabled := false;
  if Assigned(AllRegions) then
  begin
    AllRegions.Free;
    AllRegions := nil;
  end;

  if Assigned(AllSynonyms) then
  begin
    AllSynonyms.Free;
    AllSynonyms := nil;
  end;

  if Assigned(AllStratons) then
  begin
    AllStratons.Free;
    AllStratons := nil;
  end;

  if Assigned(AllWells) then
  begin
    AllWells.Free;
    AllWells := nil;
  end;

  if Assigned(AllDicts) then
  begin
    AllDicts.Free;
    AllDicts := nil;
  end;

  if Assigned(frmConvert) then
  begin
    frmConvert.Free;
    frmConvert := nil;
  end;

  if Assigned(Filters) then
  begin
    Filters.Free;
    Filters := nil;
  end;

  if Assigned(frmEditAll) then
  begin
    frmEditAll.Free;
    frmEditAll := nil;
  end;

  if Assigned(ActiveWells) then
  begin
    ActiveWells.Free;
    ActiveWells := nil;
  end;
end;

procedure TfrmSubDividerMain.FormCreate(Sender: TObject);
begin
  iClientAppType:=9;
  frmEditSubDivision1.ReadOnly := true;
end;

procedure TfrmSubDividerMain.TryToConnectExecute(Sender: TObject);
var iPriority, iErrorCode: integer;
    bDumb:WordBool;
begin
  iErrorCode:=0;
  frmPassword:=TfrmPassword.Create(Self);
  try
    iErrorCode:=1;
    if (frmPassword.ShowModal()=mrOk) then
    begin
      FormsFree;
      actnListDisable();
      iErrorCode:=2;

      case iServerType of
      0: IServer:=CreateOleObject('RICCServer.CommonServer');
      1: IServer:=CreateOleObject('RICCServerTest.CommonServerTest');
      end;
      iErrorCode:=3;

      frmProgressBar:=TfrmProgressBar.Create(Self);
      frmProgressBar.InitProgressBar ('Идёт проверка прав', aviFindComputer);

      // пытаемся соединиться
      iGroupID:=IServer.InitializeServer(
                frmPassword.edtUserName.Text,
                frmPassword.edtPassword.Text,
                iClientAppType,
                '', '', '',
                iPriority,
                sEmployeeName, iEmployeeID,
                bDumb);
      iErrorCode:=4;

      if iGroupId>=0 then
      begin
        iErrorCode:=5;

        // вызываем процедуру, которая
        // разрешает экшены в соответствии с приоритетом
        if (iPriority>0) then
        begin
          FetchPriorities(iPriority, Self.actnLst);
          frmProgressBar.Hide;
          Self.Update;
          // создаем  условия для работы
          CreateAll;
        end;
      end
      else //if x<0
      begin
        MessageBox(Handle,
                   'Ваши пользовательское имя и пароль не опознаны системой.'
                     +#10+#13+'Попробуйте ещё раз.',
                   'Вы не опознаны системой!',
                   MB_APPLMODAL+MB_OK+MB_ICONSTOP);
      end;
      frmProgressBar.Free();
      frmProgressBar:=nil;
    end;
    except
      on EConvertError{xception} do
      begin
        MessageBox(Handle,
                   PChar('Произошла общая ошибка идентификации пользователя.'+#10+#13+'Пожалуйста, обратитесь к разработчикам.'
                     +#10+#13+Format('Код ошибки :0x%s.',[IntToStr(iErrorCode)])),
                   'Общая ошибка.',
                   MB_APPLMODAL+MB_OK+MB_ICONWARNING);
      end;
  end;
  frmPassword.Free();
  frmPassword :=nil;
end;
procedure TfrmSubDividerMain.CloseFormExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmSubDividerMain.ConvertExecute(Sender: TObject);
begin
  // убиваем форму редактирования стратона,
  // поскольку там могут остаться неправильные ссылки
  // после обновления стратонов
  // в форме приема разбивок
  if Assigned(frmEditAll) then
  begin
    frmEditAll.Free;
    frmEditAll := nil;
  end;
  if not Assigned(frmConvert) then frmConvert := TFrmConvert.Create(Self);
  frmConvert.ShowModal;
end;

procedure TfrmSubDividerMain.ConvertUpdate(Sender: TObject);
begin
  Convert.Enabled := not varIsEmpty(IServer) and Assigned(AllStratons);
end;

procedure TfrmSubDividerMain.SetActiveButton (Value: TSpeedButton);
begin
  if (FActiveButton<>Value) then
  begin
    if Assigned(Filters.CurrentFilter) then
      Filters.CurrentFilter.SearchText := edtName.Text;
    ReloadWells(Value.Tag, true);
    if Assigned(Filters.CurrentFilter) then
      edtName.Text := Filters.CurrentFilter.SearchText;
    edtName.SelectAll;
    FActiveButton := Value;
    FActiveButton.Down := true;
  end;
end;


procedure TfrmSubDividerMain.FormDestroy(Sender: TObject);
begin
  FormsFree;
  IServer := null;
end;

procedure TfrmSubDividerMain.lswSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Key=#32) and (lswSearch.Selected<>nil) then
    ReloadWells(-1, true);
end;

procedure TfrmSubDividerMain.lswSearchMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var Item: TListItem;
begin
  if ((Button = mbLeft) or (Button = mbRight)) and (X<=20)then
  begin
    Item := lswSearch.GetItemAt(X,Y);
    if Item<>nil then
      ReloadWells(-1, true);
  end;
end;

procedure TfrmSubDividerMain.spdbtnDeselectAllClick(Sender: TObject);
var i: integer;
begin
  for i:=0 to lswSearch.Items.Count - 1 do
    lswSearch.Items[i].Checked := false;
  ReloadWells(-1, true);
end;

procedure TfrmSubDividerMain.edtNameChange(Sender: TObject);
var Item: TListItem;
begin
  Item:=lswSearch.FindCaption(0, AnsiUpperCase(trim(edtName.Text)), true,true,true);
  if Item<>nil then
  begin
    Item.Focused:=true;
    Item.Selected:=true;
    lswSearch.Scroll(0,Item.Position.Y);
  end;
end;


procedure TfrmSubDividerMain.ReloadActionExecute(Sender: TObject);
var i: integer;
    Found: boolean;
begin
  if Changed then
  begin
    frmEditSubDivision1.ShowProgress := true;
    ReloadStratons;
  end
end;

procedure TfrmSubDividerMain.AboutExecute(Sender: TObject);
begin
 if not Assigned(frmAbout) then frmAbout := TfrmAbout.Create(Self);
 frmAbout.ShowModal;
end;

procedure TfrmSubDividerMain.EditSelectedExecute(Sender: TObject);
var i, j, iTmp: integer;
    w: TWell;
    sb: TSubDivision;
begin
  if not Assigned(frmEditAll) then frmEditAll := TfrmEditAll.Create(Self);

  frmEditSubDivision1.ReportFormat := false;
  frmEditSubDivision1.ShowProgress := false;
  ReloadStratons;
  frmEditSubDivision1.ReportFormat := true;

  frmEditAll.frmEditSubDivision1.ShowProgress := false;
  frmEditAll.frmEditSubDivision1.Wells := ActiveWells;

  frmEditAll.ShowModal;

  Changed := frmEditAll.frmEditSubDivision1.ChangesMade;
  frmEditSubDivision1.ShowProgress := false;
  ReloadStratons;
end;

procedure TfrmSubDividerMain.SelectAllExecute(Sender: TObject);
var i: integer;
begin
  for i := 0 to lwWells.Items.Count - 1 do
    lwWells.Items[i].Checked := true;
end;

procedure TfrmSubDividerMain.DeselectAllExecute(Sender: TObject);
var i: integer;
begin
  for i := 0 to lwWells.Items.Count - 1 do
    lwWells.Items[i].Checked := false;
end;



procedure TfrmSubDividerMain.WordReportExecute(Sender: TObject);
begin
//
end;

procedure TfrmSubDividerMain.ExcelReportExecute(Sender: TObject);
var vReport: OleVariant;
    i, j, iHB, iRealIndex, iLastActiveSheet: integer;
    sPath: string;
    wb: _WorkBook;
    sh: OleVariant;
begin
  // отчет в Excel
  if not Assigned(frmProgressBar) then frmProgressBar:=TfrmProgressBar.Create(Self);
  frmProgressBar.InitProgressBar ('Идет передача данных', aviCopyFile);
  LastWorkBookFileName := '';
  MakeExcelReport;
  frmProgressBar.Free;
  frmProgressBar := nil;
end;

function  TfrmSubDividerMain.CheckedCount: integer;
var i: integer;
begin
  Result := 0;
  for i := 0 to lwWells.Items.Count - 1 do
    Result := Result + ord(lwWells.Items[i].Checked); 
end;

function TfrmSubDividerMain.GetCurrentlySelected: string;
var i: integer;
begin
  Result := '';
  with lswSearch do
  for i:=0 to Items.Count - 1 do
  if Items[i].Checked then
    Result := Result + #13 + #10 + Items[i].Caption+',';
  if Result<>'' then Result := 'Выбраны: '+Copy (Result, 0, Length(Result)-1);
end;

procedure TfrmSubDividerMain.lswSearchInfoTip(Sender: TObject;
 Item: TListItem; var InfoTip: String);
begin
  InfoTip := GetCurrentlySelected;
  if Assigned(Item) and (lswSearch.StringWidth(Item.Caption)>lswSearch.Width-60) then
    InfoTip := Item.Caption+#13+#10+InfoTip;
end;

procedure TfrmSubDividerMain.GatherExecute(Sender: TObject);
begin
  Gather.Checked := not Gather.Checked; 
  GatherComponents := Gather.Checked;

  ReloadAction.Execute;
end;

procedure TfrmSubDividerMain.ExcelReportUpdate(Sender: TObject);
begin
  ExcelReport.Enabled := CheckedCount > 0;
end;

procedure TfrmSubDividerMain.lwWellsCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
var i: integer;
begin
  i := ColumnToSort - 1;
  if ColumnToSort in [0, 1] then
    Compare := CompareText(Item1.Caption,Item2.Caption)
  else
  if ColumnToSort in [2, 3] then
    Compare := CompareFloat(StrToFloat(Item1.SubItems[i]), StrToFloat(Item2.SubItems[i]))
end;

procedure TfrmSubDividerMain.lwWellsColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  ColumnToSort := Column.Index;
  lwWells.AlphaSort;
end;

procedure TfrmSubDividerMain.SelectAllUpdate(Sender: TObject);
begin
  SelectAll.Enabled := lwWells.Items.Count > 0;
end;

procedure TfrmSubDividerMain.DeselectAllUpdate(Sender: TObject);
begin
  DeselectAll.Enabled := CheckedCount > 0;
end;

procedure TfrmSubDividerMain.ExcelReportWithTopsExecute(Sender: TObject);
var vReport: OleVariant;
    i, j, iHB, iRealIndex, iLastActiveSheet: integer;
    sPath: string;
    wb: _WorkBook;
    sh: OleVariant;
begin
  // отчет в Excel
  if not Assigned(frmProgressBar) then frmProgressBar:=TfrmProgressBar.Create(Self);
  frmProgressBar.InitProgressBar ('Идет передача данных', aviCopyFile);
  frmEditSubDivision1.ShowProgress := false;
  ReloadStratons;

  if Assigned(ActiveWells) and (ActiveWells.Count > 0) then
  begin
    try

      frmEditSubDivision1.MakeReport;
      frmEditSubDivision1.Update;
      vReport := frmEditSubDivision1.Report[true];
      Excel.Connect;
      sPath := ExtractFilePath(ParamStr(0))+'StratReport.xlt';
      wb := Excel.Workbooks.Add(sPath,0);
      wb.Activate(0);
      sh := wb.ActiveSheet;
      iHB := varArrayHighBound(vReport, 1);

      iRealIndex := 0; i := 0;
      iLastActiveSheet := 1;
      while i < iHB do
      begin
        j := 0;
        if iRealIndex > 250 then
        begin
          iRealIndex := 0;
          inc(iLastActiveSheet);
          sh := wb.Sheets.Item[iLastActiveSheet];
          sh.Select;

          for j := 0 to varArrayHighBound(vReport, 2) do
          begin
            if not (varIsEmpty(vReport[0,j])) then
              Excel.Cells.Item[j + 2,iRealIndex + 1].Value := vReport[0,j];

            if not (varIsEmpty(vReport[1,j])) then
              Excel.Cells.Item[j + 2,iRealIndex + 2].Value := vReport[1,j];
          end;

          iRealIndex := 2;
        end;

        for j := 0 to varArrayHighBound(vReport, 2) do
        begin
          if not (varIsEmpty(vReport[i,j])) then
             Excel.Cells.Item[j+2, iRealIndex+1].Value := vReport[i,j];
        end;

        sh.Columns.Item[iRealIndex + 1].AutoFit;
        inc(i);
        inc(iRealIndex);
      end;
    finally
      frmProgressBar.Free;
      frmProgressBar := nil;
      Excel.Visible[0] := true;
      Excel.Disconnect;
    end;
  end;
end;

procedure TfrmSubDividerMain.lwWellsChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin
  Changed := true;
end;

procedure TfrmSubDividerMain.ReloadStratons;
var i: integer;
begin
  if Changed then
  begin
    ActiveWells.Clear;

    for i := 0 to lwWells.Items.Count - 1 do
    if lwWells.Items[i].Checked then
      ActiveWells.AddWell(PWell(lwWells.Items[i].Data)^, true);


    frmEditSubDivision1.Wells := ActiveWells;
    Changed := false;
  end;
end;

procedure TfrmSubDividerMain.actnNGRExcelExportExecute(Sender: TObject);
var i, j: integer;
    fLastActiveButton: TSpeedButton;
begin
  if not Assigned(frmNGRExport) then frmNGRExport := TfrmNGRExport.Create(Self);

  if frmNGRExport.ShowModal = mrOK then
  begin
    // выбираем фильтр НГРов
    fLastActiveButton := ActiveButton;
    ActiveButton := pnlButtons.Controls[2] as TSpeedButton;
    frmSubDividerMain.Update;
    frmEditSubDivision1.ShowProgress := false;

    // очищаем предыдущее
    for j := 0 to lswSearch.Items.Count - 1 do
      lswSearch.Items[j].Checked := false;
    ReloadWells(-1, true);
    frmSubDividerMain.Update;


    // инициализируем прогресс
    if not Assigned(frmProgress) then frmProgress := TfrmProgress.Create(Self.Owner);
    frmProgress.SetParams(0, lswSearch.Items.Count - 1, 1, 'НГРов');
    frmProgress.Show;


    // последовательно проходим по
    for i := 0 to lswSearch.Items.Count - 1 do
    begin
      // выделяем НГР - перегружаем
      lswSearch.Items[i].Checked := true;
      ReloadWells(-1, true);
      frmSubDividerMain.Update;
      frmProgress.StepIt;

      // выделяем скважины - перегружаем стратоны
      for j := 0 to lwWells.Items.Count - 1 do
        lwWells.Items[j].Checked := true;
      ReloadStratons;
      frmSubDividerMain.Update;
      frmProgress.Update;


      // скидываем отчет
      LastWorkBookFileName := frmNGRExport.edtDirectory.Text + '\' + StringReplace(lswSearch.Items[i].Caption, ' ', '_', [rfReplaceAll]) + '.xls';
      MakeExcelReport;
      frmSubDividerMain.Update;
      frmProgress.Update;

      // убираем выделение
      lswSearch.Items[i].Checked := false;
      ReloadWells(-1, true);
      frmSubDividerMain.Update;
      frmProgress.Update;      
    end;

    ActiveButton := fLastActiveButton;
    frmProgress.Free;
  end;
end;

procedure TfrmSubDividerMain.MakeExcelReport;
var vReport: OleVariant;
    i, j, iHB, iRealIndex, iLastActiveSheet: integer;
    sPath: string;
    wb: _WorkBook;
    sh: OleVariant;
begin
  // отчет в Excel
  frmEditSubDivision1.ShowProgress := false;
  ReloadStratons;

  if Assigned(ActiveWells) and (ActiveWells.Count > 0) then
  begin
    try
      frmEditSubDivision1.MakeReport;
      frmEditSubDivision1.Update;
      vReport := frmEditSubDivision1.Report[false];
      Excel.Connect;
      sPath := ExtractFilePath(ParamStr(0))+'StratReport.xlt';
      wb := Excel.Workbooks.Add(sPath,0);
      wb.Activate(0);
      sh := wb.ActiveSheet;
      iHB := varArrayHighBound(vReport, 1);


      iRealIndex := 0; i := 0;
      iLastActiveSheet := 1;
      while i < iHB do
      begin
        j := 0;
        if iRealIndex > 250 then
        begin
          iRealIndex := 0;
          inc(iLastActiveSheet);
          sh := wb.Sheets.Item[iLastActiveSheet];
          sh.Select;

          for j := 0 to varArrayHighBound(vReport, 2) do
          begin
            if not (varIsEmpty(vReport[0,j])) then
              Excel.Cells.Item[j + 2,iRealIndex + 1].Value := vReport[0,j];

            if not (varIsEmpty(vReport[1,j])) then
              Excel.Cells.Item[j + 2,iRealIndex + 2].Value := vReport[1,j];
          end;

          iRealIndex := 2;
        end;

        for j := 0 to varArrayHighBound(vReport, 2) do
        begin
          if not (varIsEmpty(vReport[i,j])) then
             Excel.Cells.Item[j + 2,iRealIndex + 1].Value := vReport[i,j];
          //if VarAsType(vReport[iHB,j], varInteger) = 1 then sh.Rows.Item[j + 1].Interior.ColorIndex := 40;
        end;

        sh.Columns.Item[iRealIndex + 1].AutoFit;
        inc(i);
        inc(iRealIndex);
      end;

      if trim(LastWorkBookFileName) <> '' then
      begin
        if FileExists(LastWorkBookFileName) then DeleteFile(LastWorkBookFileName);
        wb.Close(true, LastWorkBookFileName, false, 0);
      end;
    finally
      Excel.Visible[0] := true;
      Excel.Disconnect;
    end;
  end;
end;

procedure TfrmSubDividerMain.actnNGRExcelExportUpdate(Sender: TObject);
begin
  ExcelReport.Enabled := not VarIsEmpty(IServer);
end;

end.
