unit RRManagerCreateReportFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RRManagerBaseObjects, RRManagerReport, ExtCtrls, ComCtrls, StdCtrls,
  RRManagerPersistentObjects, Mask, ToolEdit, ImgList, RRManagerBaseGUI;

type
{
  Фрэйм, ответственный за создание SQL-запросов
  для отчетов. Предоставляет возможность набирать столбцы
  для кросстабличных отчетов,
  сохранять созданные запросы в tbl_Report.
  Позволяет пользователю видеть свои запросы
  в интерфейсе и редактировать их, а так же и удалять.
  Создания шаблонов файлов отчетов пока (а возможно и вообще) не будет.
}

  TQueryLoadAction = class;
  TReportTablesLoadAction = class;  
  
//  TfrmCreateReport = class(TFrame)
  TfrmCreateReport = class(TBaseFrame)
    trwQuery: TTreeView;
    pnl: TPanel;
    cmbxLevel: TComboBox;
    Label1: TLabel;
    edtReportName: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edtTemplateName: TFilenameEdit;
    imgLst: TImageList;
    procedure trwQueryMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure trwQueryGetImageIndex(Sender: TObject; Node: TTreeNode);
    procedure cmbxLevelChange(Sender: TObject);
    procedure cmbxLevelMeasureItem(Control: TWinControl; Index: Integer;
      var Height: Integer);
    procedure cmbxLevelDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure cmbxLevelDropDown(Sender: TObject);
  private
    { Private declarations }
    FCopyReports: TReports;
    FQueryLoadAction: TQueryLoadAction;
    FTableLoadAction: TReportTablesLoadAction;
    FOnChangeLevel: TNotifyEvent;
    function  GetReport: TCommonReport;
    procedure CheckChildState(AParent: TTreeNode);
    procedure DeriveParentState(AParent: TTreeNode);
    function  GetCheckedCount: integer;
  protected
    procedure FillControls(ABaseObject: TBaseObject); override;
    procedure ClearControls; override;
    procedure RegisterInspector; override;
  public
    { Public declarations }
    property  CommonReport: TCommonReport read GetReport;
    property  CheckedCount: integer read GetCheckedCount;
    procedure Save; override;
    procedure CancelEdit; override;
    property    OnChangeLevel: TNotifyEvent read FOnChangeLevel write FOnChangeLevel;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure   GetSelectedColumns(AColumns: TReportColumns);
  end;

  TQueryLoadAction = class(TBaseAction)
  public
    function Execute: boolean; override;
    function Execute(ABaseObject: TBaseObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;


  TReportTablesLoadAction = class(TReportTablesBaseLoadAction)
  public
    function Execute: boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.DFM}

{ TfrmCreateReport }

procedure TfrmCreateReport.trwQueryMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var Node: TTreeNode;
    Rect: TRect;
begin
  Node:=trwQuery.GetNodeAt(X,Y);
  if (Node<>nil)
  and (Node.Level*trwQuery.Indent + ord(Node.StateIndex > -1)*16 + 20 <=X)
  and (X<=(Node.Level*trwQuery.Indent+ ord(Node.StateIndex > -1)*16 + 32)) then
  begin
    Rect := Node.DisplayRect(False);
    if (Rect.Top<=Y) and (Y<=Rect.Bottom) then
    begin
      if Node.SelectedIndex<2 then
        Node.SelectedIndex:= 1 - Node.SelectedIndex
      else
        Node.SelectedIndex := 0;

      CheckChildState(Node.Parent);
      DeriveParentState(Node);
      InvalidateRect(trwQuery.Handle, @Rect, true);
    end;
  end;
  Check;
end;

function TfrmCreateReport.GetCheckedCount: integer;
var i: integer;
begin
  Result := 0;
  for i := 0 to trwQuery.Items.Count - 1 do
    Result := Result + ord(trwQuery.Items[i].SelectedIndex = 1);
end;


procedure TfrmCreateReport.CheckChildState(AParent: TTreeNode);
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
      if (Child.SelectedIndex = 2) then
      begin
        bChildGrayed:=true;
        break;
      end;
      // сложение статусов дочерних элементов
      // и последующее сравнение суммы и общего
      // количества элементов
      // позволяет выяснить выделены ли все элементы
      iSelectedNumber:=iSelectedNumber+ord(Child.SelectedIndex < 3)*(Child.SelectedIndex);
      Child:=AParent.GetNextChild(Child);
    until(Child=nil);

    if not(bChildGrayed) then
      // если ни один дочерний элемент не выделен,
      // то родительский также не должен быть выделен
      case iSelectedNumber of
        0: AParent.SelectedIndex := 0;
      else
        // если выделены не все дочерние элементы,
        // то родительский должен быть затенен
        if (iSelectedNumber<AParent.Count) then AParent.SelectedIndex:= 2
        else
          // если выделены все дочерние элементы,
          // то родительский должен быть выделен
          if (iSelectedNumber=AParent.Count) then AParent.SelectedIndex:=1;
      end
    else
      // если есть затененные элементы среди дочерних,
      // то затеняем родительский
      AParent.SelectedIndex:=2;
    end;
   if (AParent<>nil) then  CheckChildState(AParent.Parent);
end;

procedure TfrmCreateReport.DeriveParentState(AParent: TTreeNode);
var Child: TTreeNode;
begin
  with trwQuery do
  begin
    Child:=AParent.GetFirstChild;
    // для всех дочерних элементов
    while (Child<>nil) do
    begin
      if (Child<>nil) and (Child.SelectedIndex<3) then
      begin
        // присваивается статус родительского
        Child.SelectedIndex:=AParent.SelectedIndex;
        DeriveParentState(Child);
      end;
      Child:=AParent.GetNextChild(Child);
    end;
  end;
end;


procedure TfrmCreateReport.CancelEdit;
begin
  inherited;

end;

procedure TfrmCreateReport.ClearControls;
var Node: TTreeNode;
begin
  edtReportName.Clear;
  edtTemplateName.Clear;
  edtTemplateName.Text := ExtractFilePath(ParamStr(0)) + 'blank.xlt';

  cmbxLevel.ItemIndex := 0;
  cmbxLevelChange(cmbxLevel);

  Node := trwQuery.Items.GetFirstNode;
  if Assigned(Node) then
  begin
    Node.SelectedIndex := 0;
    Node.ImageIndex := 0;
  end;
end;

constructor TfrmCreateReport.Create(AOwner: TComponent);
begin
  inherited;
  FCopyReports := TReports.Create(nil);

  EditingClass := TCommonReport;



  FTableLoadAction := TReportTablesLoadAction.Create(Self);
  FTableLoadAction.Execute;

  cmbxLevel.Clear;

  cmbxLevel.Items.AddObject('структуры', AllConcreteTables.GetTableByName('VW_STRUCTURE'));
  FCopyReports.Add;
  cmbxLevel.Items.AddObject('горизонта', AllConcreteTables.GetTableByName('VW_HORIZON'));
  FCopyReports.Add;
  cmbxLevel.Items.AddObject('залежи', AllConcreteTables.GetTableByName('VW_BED'));
  FCopyReports.Add;
  cmbxLevel.Items.AddObject('подструктуры', AllConcreteTables.GetTableByName('VW_SUBSTRUCTURE'));
  FCopyReports.Add;
  cmbxLevel.Items.AddObject('продуктивного горизонта', AllConcreteTables.GetTableByName('VW_CONCRETE_LAYER'));
  FCopyReports.Add;
  
  FQueryLoadAction := TQueryLoadAction.Create(Self);
  NeedCopyState := false;
end;

destructor TfrmCreateReport.Destroy;
begin
  if Assigned(FCopyReports) then FCopyReports.Free;
  FQueryLoadAction.Free;
  FTableLoadAction.Free;
  inherited;
end;

procedure TfrmCreateReport.FillControls(ABaseObject: TBaseObject);
var R: TCommonReport;
begin
  if not Assigned(ABaseObject) then R := CommonReport
  else R := ABaseObject as TCommonReport;

  FCopyReports.Items[0].Assign(R);
  with R do
  begin
    edtReportName.Text := ReportName;
    edtTemplateName.Text := TemplateName;
    cmbxLevel.ItemIndex := Level;
    FCopyReports.Items[cmbxLevel.ItemIndex].Assign(R);
    cmbxLevelChange(cmbxLevel);
  end;
end;

function TfrmCreateReport.GetReport: TCommonReport;
begin
  Result := EditingObject as TCommonReport;
end;

procedure TfrmCreateReport.Save;
begin
  inherited;
  if not Assigned(EditingObject) then
     FEditingObject := AllReports.Add;

  FCopyReports.Items[cmbxLevel.ItemIndex].ReportName := edtReportName.Text;
  FCopyReports.Items[cmbxLevel.ItemIndex].TemplateName := edtTemplateName.Text;
  FCopyReports.Items[cmbxLevel.ItemIndex].Level := cmbxLevel.ItemIndex;

  CommonReport.Assign(FCopyReports.Items[cmbxLevel.ItemIndex]);
end;

procedure TfrmCreateReport.RegisterInspector;
begin
  inherited;
  Inspector.Add(edtReportName, nil, ptString, 'наименование отчёта', false);
  Inspector.Add(edtTemplateName, nil, ptString, 'путь к шаблону', false);
  Inspector.Add(trwQuery, nil, ptTreeMultiSelect, 'состав отчёта', false);
end;


procedure TfrmCreateReport.GetSelectedColumns(AColumns: TReportColumns);
var Node, tmp: TTreeNode;
    cl: TReportColumn;
    j, iOrder: integer;
    R: TCommonReport;
begin
  Node := trwQuery.Items.GetFirstNode;
  repeat
    if (Node.SelectedIndex > 0) and Node.HasChildren then
      Node := Node.getFirstChild
    else if Node.HasChildren then
    begin
      tmp := Node.getNextSibling;
      if Assigned(tmp) then
        Node := tmp
      else Node := Node.GetNext;
    end
    else if not Node.HasChildren then
    begin
      if (TObject(Node.Data) is TReportColumn) and (Node.SelectedIndex = 1) then
      begin
        cl := TReportColumn.Create;
        cl.Assign(TReportColumn(Node.Data));
        cl.Order := 1000;
        AColumns.Add(cl);
      end;
      Node := Node.GetNext;
    end;
  until not Assigned(Node);

  // пересортировываем по порядку
  R := FCopyReports.Items[cmbxLevel.ItemIndex];
  iOrder := 0;
  for j := 0 to R.ArrangedColumns.Count - 1 do
  begin
    cl := AColumns.ColByName(R.ArrangedColumns.Items[j].ColName);
    if Assigned(cl) then
    begin
      cl.Order := iOrder;
      inc(iOrder);
    end;
  end;

  AColumns.SortByOrder;
end;

{ TQueryLoadAction }

constructor TQueryLoadAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  Visible := false;
  Caption := 'Загрузить запрос в дерево';
end;

function TQueryLoadAction.Execute: boolean;
begin
  with (Owner as TfrmCreateReport) do 
  Result := Execute(FCopyReports.Items[cmbxLevel.ItemIndex]);

end;

function TQueryLoadAction.Execute(ABaseObject: TBaseObject): boolean;
var sp: TStringPoster;
    r: TCommonReport;
    pnm, nm: string;
    ParentNode, Node: TTreeNode;
    pt, t: TReportTable;
    AllIncluded: boolean;
    i, j, iIndex: integer;
    cl: TReportColumn;
    rts: TReportTables;
begin
  Result := false;
  r := ABaseObject as TCommonReport;
  rts := TReportTables.Create(nil);

  LastCollection := r.ReportTables;
  if LastCollection.NeedsUpdate then
  begin
    LastCollection.NeedsUpdate := false;

    Result := inherited Execute;
    // берем постер
    sp := TQueryTablesDataPoster.Create;
    // инициализируем коллекцию
    sp.LastGotCollection := LastCollection;


    LastCollection := sp.GetFromString(r.Query);

    // делаем чтобы столбцы шли в правильном порядке
    r.ArrangedColumns.Clear;
    for i := 0 to r.ReportTables.Count - 1 do
    for j := 0 to r.ReportTables.Items[i].ColumnCount - 1 do
    begin
      cl := TReportColumn.Create;
      cl.Assign(r.ReportTables.Items[i].Items[j]);
      r.ArrangedColumns.Add(cl);
    end;
    r.ArrangedColumns.SortByOrder;

    rts.Assign(r.ReportTables);
    for i := 0 to rts.Count - 1 do
      rts.Items[i].CopyColumns(r.ReportTables.Items[i]);

    // загружаем в интерфейс
    with (Owner as TfrmCreateReport) do
    begin
      trwQuery.Items.BeginUpdate;

      // проходим по готовому дереву
      Node := trwQuery.Items.GetFirstNode;
      t := nil;

      // сличаем его ветви с тем, что выбрано для запроса
      while Assigned(Node) do
      begin
        // если находим таблицу - отмечаем
        // узел с подчиненными узлами - соответствует таблице со столбцами
        if TObject(Node.Data) is TReportTable then
        begin
          nm := TReportTable(Node.Data).TableName;
          t := rts.GetTableByName(nm);
          if Assigned(t) then
          begin
            Node.SelectedIndex := 1;
            Node.ImageIndex := 1;
          end;
        end
        else
        begin
          // если находим колонки - тоже отмечаем;
          // в принципе нужно, чтобы все приходило в согласованное состояние,
          // то есть узел соответствующий таблице показывался в
          // grayed состоянии
          nm := TReportColumn(Node.Data).ColName;
          // чтобы не отмечались два раза одни и те же таблицы
          // провераем еще верхний уровень

          AllIncluded := true;
          ParentNode := Node.Parent.Parent;
          if Assigned(ParentNode) then
          while Assigned(ParentNode) do
          begin
            pnm := TReportTable(ParentNode.Data).TableName;
            pt := r.ReportTables.GetTableByName(pnm);
            if not Assigned(pt) then
            begin
              AllIncluded := false;
              break;
            end;
            ParentNode := ParentNode.Parent;
          end;

          if Assigned(t) and AllIncluded then
          begin
            cl := t.Columns[nm];
            if Assigned(cl) then
            begin
              Node.SelectedIndex := 1;
              Node.ImageIndex := 1;
              iIndex := t.IndexOfName(nm);
              while iIndex > -1 do
              begin
                t.Delete(iIndex);
                iIndex := t.IndexOfName(nm);                
              end;
              
            end;
          end;
        end;

        // согласовываем состояние предыдущего родителя со всеми потомками
        if Assigned(t) and Assigned(Node.Parent) then CheckChildState(Node.Parent);

        Node := Node.GetNext;
      end;

      trwQuery.Items.EndUpdate;
    end;

    sp.Free;
  end;
end;

{ TReportTablesLoadAction }

constructor TReportTablesLoadAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  Visible := false;
  Caption := 'Загрузить досутпные таблицы в дерево';
end;

function TReportTablesLoadAction.Execute: boolean;
var Node: TTreeNode;
    rts: TReportTables;
    tbl: TReportTable;
procedure RecourseTable(ATree: TTreeView; ANode: TTreeNode; ATable: TReportTable);
var j: integer;
    Child: TTreeNode;
begin
  if Assigned(ANode) then ANode.SelectedIndex := 0;
  ANode := ATree.Items.AddChildObject(ANode, ATable.RusTableName, ATable);
  ANode.SelectedIndex := 0;
  // сортируем столбца по алфавиту
  ATable.SortColumnsByRusName;

  // добавляем столбцы
  for j := 0 to ATable.ColumnCount - 1 do
  if ATable.Items[j].RusColName <> '' then
  begin
    Child := ATree.Items.AddChildObject(ANode, ATable.Items[j].List, ATable.Items[j]);
    Child.SelectedIndex := 0;
  end;

//  ANode := Child;
  for j := 0 to ATable.Joins.Count - 1 do
  if Assigned(ATable.Joins.Items[j].RightTable) then
    RecourseTable(ATree, ANode, ATable.Joins.Items[j].RightTable);
end;
begin
  Result := inherited Execute;

  LastCollection := AllConcreteTables;
  rts := LastCollection as TReportTables;

  with (Owner as TfrmCreateReport) do
  begin
    trwQuery.Items.BeginUpdate;
    trwQuery.Items.Clear;
    Node := nil;
    if cmbxLevel.ItemIndex > -1 then
    begin
      tbl := TReportTable(cmbxLevel.Items.Objects[cmbxLevel.ItemIndex]);
      RecourseTable(trwQuery, Node, tbl);
    end;

    trwQuery.Items.EndUpdate;
  end;
end;


procedure TfrmCreateReport.trwQueryGetImageIndex(Sender: TObject;
  Node: TTreeNode);
begin
  with Node do ImageIndex:=SelectedIndex;
end;


procedure TfrmCreateReport.cmbxLevelChange(Sender: TObject);
begin
  FTableLoadAction.Execute;
  trwQuery.Items.GetFirstNode.StateIndex := cmbxLevel.ItemIndex + 3;
  FCopyReports.Items[cmbxLevel.ItemIndex].ReportTables.NeedsUpdate := true;
  FQueryLoadAction.Execute;
  Check;
end;

procedure TfrmCreateReport.cmbxLevelMeasureItem(Control: TWinControl;
  Index: Integer; var Height: Integer);
begin
  Height := 18;
end;

procedure TfrmCreateReport.cmbxLevelDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  imgLst.Draw(cmbxLevel.Canvas, Rect.Left + 1, Rect.Top + 1, Index + 3);
  cmbxLevel.Canvas.TextOut(Rect.Left + 22, Rect.Top + 2, cmbxLevel.Items[Index]);
end;

procedure TfrmCreateReport.cmbxLevelDropDown(Sender: TObject);
begin
  if Assigned(FCopyReports.Items[cmbxLevel.ItemIndex]) and Assigned(FOnChangeLevel) then FOnChangeLevel(Sender);
end;

end.
