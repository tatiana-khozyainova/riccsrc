unit DNRClientAllSamplesFrame;

interface

uses
  SysUtils, Forms,
  ImgList, Controls, ComCtrls,
  StdCtrls, Classes, Windows, Menus, ExtCtrls, Buttons, Dialogs,
  CommonFilter, DNRClientResearchViewFrame, SamplesTree;

// здесь будет загрузка из уже полученного массива образцов
type
  TframeAllSamples = class(TFrame)
    gbxSearch: TGroupBox;
    pnlSearch: TPanel;
    Label1: TLabel;
    edtName: TEdit;
    lswSearch: TListView;
    pnlButtons: TPanel;
    imgLst: TImageList;
    split: TSplitter;
    prg: TProgressBar;
    spdbtnDeselectAll: TSpeedButton;
    pnlSamples: TPanel;
    gbxAllSamples: TGroupBox;
    trwAllSamples: TTreeView;
    frameResearchResultsView1: TframeResearchResultsView;
    split2: TSplitter;
    procedure trwAllSamplesGetImageIndex(Sender: TObject; Node: TTreeNode);
    procedure trwAllSamplesChanging(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure lswSearchMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lswSearchKeyPress(Sender: TObject; var Key: Char);
    procedure trwAllSamplesClick(Sender: TObject);
    procedure edtNameChange(Sender: TObject);
    procedure lswSearchInfoTip(Sender: TObject; Item: TListItem;
      var InfoTip: String);
    procedure spdbtnDeselectAllClick(Sender: TObject);
    procedure trwAllSamplesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure trwAllSamplesExpanding(Sender: TObject; Node: TTreeNode;
      var AllowExpansion: Boolean);
    procedure trwAllSamplesDeletion(Sender: TObject; Node: TTreeNode);
  private
    { Private declarations }
    FState: variant;
    FSelectedItemsCount: integer;
    FFrameType: integer;
    FChangeable: boolean;
    FActiveButton: TSpeedButton;
    FResultsPreview: boolean;
    FRockSamples: variant;
    procedure SetRockSamples(Value: variant);
    procedure SetResultsPreview(const Value: boolean);
    procedure SetFrameType(Value: integer);
    //procedure ClearItems;
    procedure CheckChildState(ATree:TTreeView; AParent:TTreeNode);
    procedure DeriveParentState(ATree: TTreeView; AParent: TTreeNode);
    function  GetSelectedItemsCount: integer;
    procedure SetChangeable(const Value: boolean);
    procedure SaveState;
    procedure RestoreState;
    procedure SetActiveButton (Value: TSpeedButton);
  public
    { Public declarations }
    Wells:  TWells;
    Filter:     integer;
    Query:      string;
    Filters:    TWellFilters;
    //pRockSamples: PVariant;
    WellsOnly:  boolean;
    property    ResultsPreview: boolean read FResultsPreview write SetResultsPreview default true;
    property    ActiveButton: TSpeedButton read FActiveButton write SetActiveButton;
    property    Changeable: boolean read FChangeable write SetChangeable;
    property    FrameType: integer read FFrameType write SetFrameType;
    property    SelectedItemsCount: integer read GetSelectedItemsCount write FSelectedItemsCount;
    property    vRockSamples: variant read FRockSamples write SetRockSamples;
    procedure   ClearSelection;
    procedure   ReplaceImages; overload;
    procedure   ReplaceImages(ANode: TTreeNode); overload;
    procedure   ReplaceImagesBack;
    procedure   ReloadWells(ClearFirst: boolean = true);
    procedure   CreateResultArray(out ARockSampleUINs: OleVariant);
    procedure   CollapseAll;
    procedure   CheckSamples(ASampleIds: OleVariant);
    procedure   ChangeSampleType(const ASampleType: integer);
    procedure   CreateButtons(FilterTable: variant);
    procedure   btnClickAction(Sender: TObject);
    function    GetCurrentlySelected: string;
    procedure   ReloadFilteredSamples(const AFilterID: integer; Output: boolean);
    procedure   ReloadSamples(WellNode: TTreeNode);
    procedure   AddNewSample(ASlottingNode: TTreeNode; ARockSampleUIN, ASampleType, ASampleChecked: integer; ASampleNum, ALithology: string; AFromDepth: single);
    procedure   RemoveSample(ANode: TTreeNode);
    procedure   CountObjects(LowFilter, HighFilter: integer; out WellCount, SlottingCount, SampleCount: integer);
    constructor Create(AOwner: TComponent);override;
    destructor  Destroy; override;
  end;

implementation

uses ClientCommon, DNRClientSetData, DNRClientMainForm, DNRClientCommon;



{$R *.DFM}

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
  Result[2,0] := 'DTM_ENTERING_DATE';
  Result[3,0] := 'Время';
  Result[4,0] := '';
  Result[5,0] := 9;
  Result[6,0] := '';


  Result[0,1] := 1;
  Result[1,1] := 'SPD_GET_AREA_DICT';
  Result[2,1] := 'AREA_ID';
  Result[3,1] := 'Площади';
  Result[4,1] := '';
  Result[5,1] := 10;
  Result[6,1] := '';


  Result[0,2] := 2;
  Result[1,2] := 'SPD_GET_PETROL_REGION_DICT';
  Result[2,2] := 'PETROL_REGION_ID';
  Result[3,2] := 'НГР';
  Result[4,2] := 'NUM_REGION_TYPE=3';
  Result[5,2] := 11;
  Result[6,2] := '';


  Result[0,3] := 3;
  Result[1,3] := 'SPD_GET_TECTONIC_STRUCT_DICT';
  Result[2,3] := 'STRUCT_ID';
  Result[3,3] := 'Тектонические структуры';
  Result[4,3] := 'NUM_STRUCT_TYPE=3 OR NUM_STRUCT_TYPE=4';
  Result[5,3] := 13;
  Result[6,3] := 'vch_Struct_Full_Name';

  Result[0,4] := 4;
  Result[1,4] := 'TBL_DISTRICT_DICT';
  Result[2,4] := 'DISTRICT_ID';
  Result[3,4] := 'Географические регионы';
  Result[4,4] := '';
  Result[5,4] := 12;
  Result[6,4] := '';

end;

procedure ChangeStateIndex(Node:TTreeNode; const ANewIndex: integer = 0);
begin
  if (Node.StateIndex<0) then
    Node.StateIndex:=Node.SelectedIndex;
  Node.SelectedIndex:=ANewIndex;
  Node.ImageIndex:=ANewIndex;
end;



procedure TFrameAllSamples.CollapseAll;
var Node: TTreeNode;
begin
  trwAllSamples.Selected:=nil;
  Node:=trwAllSamples.Items.GetFirstNode;
  while (Node<>nil) do
  begin
    Node.Collapse(true);
    Node:=Node.getNextSibling;
  end;
end;

procedure TFrameAllSamples.SetChangeable(const Value: boolean);
begin
  if (FChangeable<>Value) then
    FChangeable:=Value;
end;

procedure TFrameAllSamples.SetFrameType(Value: integer);
begin
  if (FFrameType<>Value) then
  begin
    FFrameType:=Value;
    if Changeable then
    case FFrameType of
      0: ReplaceImagesBack;
      1: ReplaceImages;
    end;
  end;
end;

procedure TFrameAllSamples.ClearSelection;
var Node: TTreeNode;
begin
  with trwAllSamples do
  begin
    Node:=Items.GetFirstNode;
    while (Node<>nil) do
    begin
      if Node.SelectedIndex<=2 then ChangeStateIndex(Node);
      Node:=Node.GetNext;
    end;
  end;
end;

function TFrameAllSamples.GetSelectedItemsCount: integer;
var i: integer;
    Node: TTreeNode;
begin
  with trwAllSamples do
  begin
    i:=0;
    Node:=Items.GetFirstNode;
    while (Node<>nil) do
    begin
      if (Node.SelectedIndex=1) then inc(i);
      Node:=Node.GetNext;
    end;
    Result:=i;
  end;
end;

procedure TFrameAllSamples.CreateResultArray(out ARockSampleUINs: OleVariant);
var Node: TTreeNode;
    iHb: integer;
begin
  with trwAllSamples do
  begin
    Node:=Items.GetFirstNode;
    while (Node<>nil) do
    begin
      if (Node.Level = 2) and (Node.SelectedIndex=1) and Assigned(Node.Data) then
      begin
        if varIsEmpty(ARockSampleUINs) then
        begin
          ARockSampleUINs:=varArrayCreate([0,0],varOleStr);
          iHB:=0;
        end
        else
        begin
          iHB:=varArrayHighBound(ARockSampleUIns,1);
          inc(iHB);
          varArrayRedim(ARockSampleUINs,iHB);
        end;
        ARockSampleUINs[iHB]:=inttostr(PSample(Node.Data)^.SampleUIN);
      end;
      Node:=Node.GetNext;
    end;
  end;
end;

procedure TFrameAllSamples.DeriveParentState(ATree: TTreeView; AParent: TTreeNode);
var Child: TTreeNode;
begin
  with ATree do
  begin
    Child:=AParent.GetFirstChild;
    // для всех дочерних элементов
    while (Child<>nil) do
    begin
      if (Child<>nil) and (Child.SelectedIndex<3) then
      begin
        // присваивается статус родительского
        Child.SelectedIndex:=AParent.SelectedIndex;
        DeriveParentState(ATree,Child);
      end;
      Child:=AParent.GetNextChild(Child);
    end;
  end;
end;


procedure TFrameAllSamples.CheckChildState(ATree:TTreeView; AParent:TTreeNode);
var Child: TTreeNode;
    iSelectedNumber:Integer;
    bChildGrayed:boolean;
begin
  iSelectedNumber:=0;
  bChildGrayed:=false;
  if (AParent<>nil) then
  begin
    Child:=AParent.getFirstChild;
    // просмотр статуса
    // для всех дочерних элементов
    if (Child<>nil) then
    repeat
      // обнаружение затененного элемента
      // среди дочерних означает,
      // что надо затенить родительский
      if (Child.SelectedIndex=2) then
      begin
        bChildGrayed:=true;
        break;
      end;
      // сложение статусов дочерних элементов
      // и последующее сравнение суммы и общего
      // количества элементов
      // позволяет выяснить выделены ли все элементы
      iSelectedNumber:=iSelectedNumber+ord(Child.SelectedIndex<3)*Child.SelectedIndex;
      Child:=AParent.GetNextChild(Child);
    until(Child=nil);

    if not(bChildGrayed) then
      // если ни один дочерний элемент не выделен,
      // то родительский также не должен быть выделен
      case iSelectedNumber of
        0: AParent.SelectedIndex:=0;
      else
        // если выделены не все дочерние элементы,
        // то родительский должен быть затенен
        if (iSelectedNumber<AParent.Count) then AParent.SelectedIndex:=2
        else
          // если выделены все дочерние элементы,
          // то родительский должен быть выделен
          if (iSelectedNumber=AParent.Count) then AParent.SelectedIndex:=1
      end
    else
      // если есть затененные элементы среди дочерних,
      // то затеняем родительский
      AParent.SelectedIndex:=2
    end;
   if (AParent<>nil) then  CheckChildState(ATree,AParent.Parent);
end;


procedure TFrameAllSamples.RemoveSample(ANode: TTreeNode);
begin
  Wells.RemoveSample(PSample(ANode.Data)^);
end;

procedure TFrameAllSamples.CountObjects(LowFilter, HighFilter: integer; out WellCount, SlottingCount, SampleCount: integer);
var Node: TTreeNode;
begin
  if Filter<0 then Filter := 10000;
  Node := trwAllSamples.Items.GetFirstNode;
  while Node <> nil do
  begin
    WellCount := WellCount + ord(Node.Level = 0)*ord(Node.SelectedIndex in [LowFilter .. HighFilter]);
    SlottingCount := SlottingCount + ord(Node.Level = 1)*ord(Node.SelectedIndex in [LowFilter .. HighFilter]);
    SampleCount := SampleCount + ord (Node.Level = 2)*ord(Node.SelectedIndex in [LowFilter .. HighFilter]);
    Node := Node.GetNext;
  end;
end;

procedure TFrameAllSamples.AddNewSample(ASlottingNode: TTreeNode; ARockSampleUIN,ASampleType, ASampleChecked: integer; ASampleNum, ALithology: string; AFromDepth: single);
var //Well: TWell;
    Slotting: TSlotting;
begin
  //Well := PWell(ASlottingNode.Parent.Data)^;
  Slotting := PSlotting(ASlottingNode.Data)^;
  Slotting.AddSample (ARockSampleUIN, ASampleNum, FloatToStr(AFromDepth), ALithology, ASampleType, ASampleChecked, Date);
end;

procedure TFrameAllSamples.ReloadSamples(WellNode: TTreeNode);
var iLastSlotting, i, iLastWell, iHB: integer;
    S:string;
    Well: TWell;
    Slotting: TSlotting;
begin
  Well := PWell(WellNode.Data)^;
  iLastWell := Well.WellUIN;
  iHB := varArrayHighBound(vRockSamples,2);
  // находим строку в которой начинается текущая скважина
  i := Well.ArrayIndex;
  // добавляем долбление в дерево
  iLastSlotting := 0;
  Slotting := nil;
  with trwAllSamples do
  begin
    Items.BeginUpdate;
    while (iLastWell = Well.WellUIN) and (i<=iHB) do
    begin
      if (iLastSlotting<>vRockSamples[17,i]) then
      begin
        Slotting := Well.AddSlotting (vRockSamples[17,i], varAsType(vRockSamples[3, i],varOleStr),
                                      varAsType(vRockSamples[4,i], varOleStr),
                                      varAsType(vRockSamples[5,i], varOleStr));

        iLastSlotting:=vRockSamples[17,i];
      end;

      if varIsEmpty(vLithologyDict) then
         vLithologyDict:=GetDictEx('TBL_LITHOLOGY_DICT');
      S:=GetObjectName(vLithologyDict,strtoint(vRockSamples[6,i]));

      Slotting.AddSample(vRockSamples[0,i],vRockSamples[7,i],vRockSamples[8,i],S,vRockSamples[9,i],vRockSamples[15,i], vRockSamples[10,i]);

      iLastWell := vRockSamples[16, i];
      if FrameType = 1 then ReplaceImages(Slotting.SlottingNode);
      inc(i);      
    end;
    Items.EndUpdate;
  end;
end;


procedure TFrameAllSamples.ReloadWells(ClearFirst: boolean = true);
var i, iRockSampleCount: integer;
    iLastWell: integer;
    Well: TWell;
    Slotting: TSlotting;
    S: string;
begin
  with trwAllSamples do
  begin
    Items.BeginUpdate;
    if ClearFirst and Assigned(Wells) then
    begin
      Wells.Free;
      Wells := nil;
    end;

    if not Assigned(Wells) then Wells := TWells.Create(trwAllSamples);

    iLastWell:=0;
    if not varIsEmpty(vRockSamples) then
    begin
      iRockSampleCount:=varArrayHighBound(vRockSamples,2);
      with prg do
      begin
        Min := 0;
        Max := iRockSampleCount;
        Position := 0;
      end;
      for i:=0 to iRockSampleCount do
      begin
        // добавляем скважину в дерево
        if (iLastWell<>vRockSamples[16,i]) then
        begin
          Well := Wells.AddWell (vRockSamples[16,i], i, vRockSamples[2,i],vRockSamples[1,i]);
          if WellsOnly then
          begin
            Well.WellNode.StateIndex := Well.WellNode.SelectedIndex;
            Well.WellNode.SelectedIndex := 0;
            Well.WellNode.ImageIndex := 0;
          end;

          iLastWell := vRockSamples[16,i];
          if not WellsOnly then
          begin
            Slotting := Well.AddSlotting (0, varAsType(vRockSamples[3, i],varOleStr),
                                          varAsType(vRockSamples[4,i], varOleStr),
                                          varAsType(vRockSamples[5,i], varOleStr));

            if varIsEmpty(vLithologyDict) then vLithologyDict:=GetDictEx('TBL_LITHOLOGY_DICT');
            S:=GetObjectName(vLithologyDict,strtoint(vRockSamples[6,i]));
            Slotting.AddSample(0,vRockSamples[7,i],vRockSamples[8,i],S,1,vRockSamples[15,i],vRockSamples[10,i]);
          end;
        end;
        prg.StepBy(1);
      end;
    end;
    Items.EndUpdate;
  end;
end;

procedure TFrameAllSamples.SetResultsPreview(const Value: boolean);
begin
  frameResearchResultsView1.Visible := Value;
  Split2.Visible :=  Value;
  if not Value then gbxAllSamples.Align := alClient;
  FResultsPreview := Value;
end;

procedure TFrameAllSamples.SetRockSamples(Value: variant);
begin
  fRockSamples := value;
  if varIsEmpty(FRockSamples) then
  begin
    Wells.Free;
    Wells := nil;
  end;
end;

{procedure TFrameAllSamples.ClearItems;
var Node: TTreeNode;
begin
  with trwAllSamples do
  begin
    Node:=Items.GetFirstNode;
    while Assigned(Node) do
    begin
      if Assigned(Node.Data) then Dispose(Node.Data);
      Node:=Node.GetNext;
    end;
    Items.Clear;
  end;
end;}


destructor TFrameAllSamples.Destroy;
begin
  //ClearItems;
  if Assigned(Wells) then Wells.Free;
  Filters.Free;
  inherited Destroy;
end;

procedure TframeAllSamples.ReplaceImagesBack;
var Node: TTreeNode;
begin
  with trwAllSamples do
  begin
    Node:=Items.GetFirstNode;
    while (Node<>nil) do
    begin
      if Node.StateIndex<>-1 then
      begin
        Node.SelectedIndex:=Node.StateIndex;
        Node.StateIndex:=-1;
      end;
      Node.ImageIndex:=Node.SelectedIndex;
      Node:=Node.GetNext;
    end;
  end;
end;


procedure TframeAllSamples.ReplaceImages(ANode: TTreeNode);
var Node: TTreeNode;
    iChildChange:  integer;
begin
  with trwAllSamples do
  begin
    Node:=ANode.GetFirstChild;
    iChildChange := 0;
    while (Node<>nil) do
    begin
      if (Node.Level=2) and (Node.SelectedIndex<=Filter) then
      begin
        ChangeStateIndex(Node,ord(Node.Parent.Parent.SelectedIndex in [1,2]));
        iChildChange := iChildChange + 1;
      end;
      Node:=ANode.GetNextChild(Node);
    end;

    ChangeStateIndex(ANode.Parent, ord(ANode.Parent.SelectedIndex in [1,2]));
    if (iChildChange>0) then
        ChangeStateIndex(ANode, ord(ANode.SelectedIndex in [1,2]));
  end
end;

procedure TframeAllSamples.ReplaceImages;
var Node: TTreeNode;
begin
  //pmiMultipleSelect.Checked:=true;
  with trwAllSamples do
  begin
    Node:=Items.GetFirstNode;
    while (Node<>nil) do
    begin
      if (Node.Level=2) and (Node.SelectedIndex<=Filter) then
      begin
        ChangeStateIndex(Node);
        ChangeStateIndex(Node.Parent);
        ChangeStateIndex(Node.Parent.Parent);
      end;
      Node:=Node.GetNext;
    end;
  end
end;


procedure TframeAllSamples.SaveState;
var Node: TTreeNode;
    i: integer;
begin
  FState := varArrayCreate([0,trwAllSamples.Items.Count-1],varInteger);
  i := 0;
  Node := trwAllSamples.Items.GetFirstNode;
  while Node<>nil do
  begin
    FState[i] := ord(Node.StateIndex>-1)*Node.ImageIndex;
    inc(i);
    Node := Node.GetNext;
  end;
end;

procedure TframeAllSamples.RestoreState;
var i: integer;
begin
  for i := 0 to trwAllSamples.Items.Count - 1 do
  if (trwAllSamples.Items[i].Level=2) and (trwAllSamples.Items[i].StateIndex>-1) then
  begin
    trwAllSamples.Items[i].ImageIndex := FState[i];
    trwAllSamples.Items[i].SelectedIndex := FState[i];
    CheckChildState(trwAllSamples,trwAllSamples.Items[i].Parent);
  end;
end;


procedure   TframeAllSamples.ChangeSampleType(const ASampleType: integer);
var OldFrameType: integer;
begin
  with trwAllSamples do
  if Assigned(Selected)
     and ((Selected.SelectedIndex<>ASampleType+4)
          and (Selected.StateIndex<>ASampleType+4)) then
  begin
    OldFrameType := FFrameType;
    if OldFrameType>0 then SaveState;
    FrameType := 0;
    Selected.StateIndex :=-1;
    Selected.SelectedIndex := ASampleType+4;
    Selected.ImageIndex := Selected.SelectedIndex;
    FrameType := OldFrameType;
    if OldFrameType>0 then RestoreState;
    OrdersChanged := true; 
  end;
end;

procedure   TframeAllSamples.CheckSamples(ASampleIds: OleVariant);
var i, iHB: integer;
    Node: TTreeNode;
begin
  iHB := varArrayHighBound(ASampleIds,2);
  // убираем отметки у всех
  ClearSelection;
  // отмечаем заданные
  Node := trwAllSamples.Items.GetFirstNode;
  while Node<>nil do
  begin
    if Node.Level=2 then
    for i:=0 to iHB do
    if PSample(Node.Data)^.SampleUIN = ASampleIds[0,i] then
    begin
      Node.ImageIndex := 1;
      Node.SelectedIndex :=1;
      CheckChildState(trwAllSamples,Node.Parent);
    end;
    Node := Node.GetNext;
  end;
  trwAllSamples.Refresh;
end;

procedure TframeAllSamples.btnClickAction(Sender: TObject);
begin
  ActiveButton := (Sender as TSpeedButton);
end;

procedure TframeAllSamples.CreateButtons(FilterTable: variant);
var i, iHB,iTop: integer;
    btn: TSpeedButton;
begin
  iHB := varArrayHighBound(FilterTable,2);
  pnlButtons.Height := (iHB+1)*21+14;
  iTop := 7;
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
end;

procedure TframeAllSamples.SetActiveButton (Value: TSpeedButton);
begin
  if (FActiveButton<>Value) then
  begin
    if Assigned(Filters.CurrentFilter) then
      Filters.CurrentFilter.SearchText := edtName.Text;
    ReloadFilteredSamples(Value.Tag, true);
    if Assigned(Filters.CurrentFilter) then
      edtName.Text := Filters.CurrentFilter.SearchText;
    edtName.SelectAll;
    FActiveButton := Value;
    FActiveButton.Down := true;
  end;
end;


procedure TframeAllSamples.ReloadFilteredSamples(const AFilterID: integer; Output: boolean);
var sSQL: string;
    vCheckedSamples: variant;
begin
  if AFilterID>-1 then Filters.LoadFilter(AFilterID);
  sSQL := Filters.CreateSQLFilter;
  if (sSQL<>'') and (IServer.ExecuteQuery(sSQL)>=0) then
    vRockSamples := IServer.QueryResult
  else if not varIsEmpty(vRockSamples) then
    vRockSamples := Unassigned;
  
  if Output and not varIsEmpty(vRockSamples) then
  begin
    ReloadWells;
    // отмечаем образцы,
    // для которых заказан
    // гран. состав или центрифугирование
    if (FrameType=1)  then
    begin
      ReplaceImages;
      sSQL := Wells.GetRockSampleFilter;
      //GetRockSampleFilter(vRockSamples,sSQL);
      if IServer.ExecuteQuery(Query+' and '+sSQL)>=0 then
      begin
        vCheckedSamples := IServer.QueryResult;
        if not varIsEmpty(vCheckedSamples) then CheckSamples(vCheckedSamples);
      end;
    end;
  end;
end;

function    TframeAllSamples.GetCurrentlySelected: string;
var i: integer;
begin
  Result := '';
  with lswSearch do
  for i:=0 to Items.Count - 1 do
  if Items[i].Checked then
    Result := Result + #13 + #10 + Items[i].Caption+',';
  if Result<>'' then Result := 'Выбраны: '+Copy (Result, 0, Length(Result)-1);
end;

constructor TframeAllSamples.Create(AOwner: TComponent);
var vFilterTable: variant;
    sFrom: string;
begin
  inherited Create(AOwner);
  vFilterTable := CreateFilterTable;
  sFrom :=  'select vw_rock_samples.ROCK_SAMPLE_UIN, VCH_AREA_NAME, VCH_WELL_NUM, VCH_SLOTTING_NUMBER, '+
            'NUM_SLOTTING_TOP, NUM_SLOTTING_BOTTOM,ROCK_ID, VCH_GENERAL_NUMBER,NUM_FROM_SLOTTING_TOP, TBL_DNR_sAMPLE.dnr_sample_type_id, '+
            'DTM_ENTERING_DATE,AREA_ID,DISTRICT_ID,STRUCT_ID,PETROL_REGION_ID,NUM_SAMPLE_CHECKED,WELL_UIN,SLOTTING_UIN '+
            'from vw_rock_samples,  TBL_DNR_SAMPLE '+
            'where vw_rock_samples.rock_sample_uin = TBL_DNR_SAMPLE.rock_sample_uin ';
  Filters := TWellFilters.Create(sFrom,vFilterTable,lswSearch, prg);
  imgLst.GetBitmap(0,spdbtnDeselectAll.Glyph);
  CreateButtons(vFilterTable);
  Changeable:=true;
  FrameType:=0;
  FResultsPreview := true;
  WellsOnly := false;
end;

procedure TframeAllSamples.trwAllSamplesGetImageIndex(Sender: TObject;
  Node: TTreeNode);
begin
  with Node do ImageIndex:=SelectedIndex;
end;

procedure TframeAllSamples.trwAllSamplesChanging(Sender: TObject;
  Node: TTreeNode; var AllowChange: Boolean);
var bTemp: boolean;
begin
  if Node<>nil then
  begin
    bTemp:=(FFrameType=1) or not Node.HasChildren;
    if not bTemp and (trwAllSamples.Selected<>nil) then
      frmDNRClientMain.btnNextClick.Enabled:=not trwAllSamples.Selected.HasChildren
    else
      frmDNRClientMain.btnNextClick.Enabled:=not Node.HasChildren;
    if Assigned(Node.Data) and FResultsPreview then
    case Node.Level of
    0: begin
         frameResearchResultsView1.WellUIN := PWell(Node.Data)^.WellUIN;
         frameResearchResultsView1.SlottingUIN := 0;
         frameResearchResultsView1.RockSample := nil;
       end;
    1: begin
         frameResearchResultsView1.WellUIN := PWell(Node.Parent.Data)^.WellUIN;
         frameResearchResultsView1.SlottingUIN := PSlotting(Node.Data)^.SlottingUIN;
         frameResearchResultsView1.RockSample := nil;
       end;
    2: begin
         frameResearchResultsView1.WellUIN := PWell(Node.Parent.Parent.Data)^.WellUIN;
         frameResearchResultsView1.SlottingUIN := PSlotting(Node.Parent.Data)^.SlottingUIN;
         frameResearchResultsView1.RockSample := PSample(Node.Data)^;
       end;
    end
    else frameResearchResultsView1.ClearAll;
  end
  else
  begin
    AllowChange:=false;
    frameResearchResultsView1.ClearAll;
    frmDNRClientMain.btnNextClick.Enabled:=false;
  end;
end;

procedure TframeAllSamples.lswSearchMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var Item: TListItem;
begin
  if ((Button = mbLeft) or (Button = mbRight)) and (X<=20)then
  begin
    Item := lswSearch.GetItemAt(X,Y);
    if Item<>nil then
      ReloadFilteredSamples(-1, true);
  end;
end;

procedure TframeAllSamples.lswSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Key=#32) and (lswSearch.Selected<>nil) then
    ReloadFilteredSamples(-1, true);
end;

procedure TframeAllSamples.trwAllSamplesClick(Sender: TObject);
//var Node: TTreeNode;
begin
  {if Assigned(trwAllSamples.Selected)
     and (trwAllSamples.Selected.Level = 0)
     and not(trwAllSamples.Selected.HasChildren) then
  with trwAllSamples.Items do
  begin
    // сначала посто чтобы подождали
    BeginUpdate;
    Node := AddChild(trwAllSamples.Selected,'Минуточку :))');
    Node.ImageIndex := 0; Node.SelectedIndex := 0;
    trwAllSamples.Selected.Expand(true);
    // добавляем долбления и образцы
    ReloadSamples(trwAllSamples.Selected);
    Node.Delete;
    EndUpdate;
  end;}
end;

procedure TframeAllSamples.edtNameChange(Sender: TObject);
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

procedure TframeAllSamples.lswSearchInfoTip(Sender: TObject;
  Item: TListItem; var InfoTip: String);
begin
  InfoTip := GetCurrentlySelected;
  if Assigned(Item) and (lswSearch.StringWidth(Item.Caption)>lswSearch.Width-60) then
    InfoTip := Item.Caption+#13+#10+InfoTip;
end;

procedure TframeAllSamples.spdbtnDeselectAllClick(Sender: TObject);
var i: integer;
begin
  for i:=0 to lswSearch.Items.Count - 1 do
    lswSearch.Items[i].Checked := false;
  ReloadFilteredSamples(-1, true);
end;

procedure TframeAllSamples.trwAllSamplesMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var Node: TTreeNode;
    Rect: TRect;
    bAllow: boolean;
begin
  Node:=trwAllSamples.GetNodeAt(X,Y);

  if (Node<>nil)
     and (Node.StateIndex>-1)
     and ((Node.Level+1)*trwAllSamples.Indent+16<=X)
     and (X<=((Node.Level+1)*trwAllSamples.Indent+26)) then
  begin
    Rect:=Node.DisplayRect(False);
    if (Rect.Top<=Y) and (Y<=Rect.Bottom) then
    begin
      if Node.SelectedIndex<2 then
        Node.SelectedIndex:=1-Node.SelectedIndex
      else
        Node.SelectedIndex:=0;
      trwAllSamplesExpanding(trwAllSamples, Node, bAllow);
      CheckChildState(trwAllSamples,Node.Parent);
      DeriveParentState(trwAllSamples,Node);
      InvalidateRect(trwAllSamples.Handle, @Rect, true);
    end;
  end
end;

procedure TframeAllSamples.trwAllSamplesExpanding(Sender: TObject;
  Node: TTreeNode; var AllowExpansion: Boolean);
var Child: TTreeNode;
begin
  Child := Node.GetFirstChild;
  if Assigned(Node) and not(WellsOnly)
     and (Node.Level = 0)
     and (PSlotting(Child.Data)^.SlottingUIN = 0) then
  with trwAllSamples.Items do
  begin
    // сначала посто чтобы подождали
    BeginUpdate;
    PSlotting(Child.Data)^.Well.RemoveSlotting(PSlotting(Child.Data)^);
    Child.Delete;
    ReloadSamples(Node);
    EndUpdate;
  end;
end;

procedure TframeAllSamples.trwAllSamplesDeletion(Sender: TObject;
  Node: TTreeNode);
begin
  frameResearchResultsView1.ClearAll;
end;

end.
