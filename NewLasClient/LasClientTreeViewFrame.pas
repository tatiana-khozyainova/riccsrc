unit LasClientTreeViewFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Facade, ComCtrls, Well, VirtualTrees, LasFile, BaseObjects,
  ShellAPI, ImgList, Material, RXSlider, CheckLst, ExtCtrls, ActnList;

type
  TTreeRecord = record
    NodeObject: TIDObject;
  end;
  PTreeRecord = ^TTreeRecord;

  TfrmWellsTree= class(TFrame)
    gbxAll: TGroupBox;
    il1: TImageList;
    trwWell: TVirtualStringTree;
    gbxFilter: TGroupBox;
    btnFilter: TButton;
    lbl1: TLabel;
    pnl1: TPanel;
    trckFrom: TTrackBar;
    trckTo: TTrackBar;
    pnl2: TPanel;
    actlst1: TActionList;
    actGetPositions: TAction;
    cmbx1: TComboBox;
    rg1: TRadioGroup;
    rbAnd: TRadioButton;
    rbOr: TRadioButton;
    procedure trwWellGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure trwWellExpanded(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure trwWellMeasureItem(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
    procedure trwWellGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);

    procedure actGetPositionsExecute(Sender: TObject);
    procedure cmbx1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure cmbx1Select(Sender: TObject);
    procedure btnFilterClick(Sender: TObject);
  private
    function GetWell : TWell;
    procedure LoadLasFiles(Node: PVirtualNode);
    function GetCurrentFrom : integer;
    function GetCurrentTo : integer;
    Function GetCurrentIf : boolean;
    function GetCurrentFilter : string;


    { Private declarations }
  public
    { Public declarations }
    procedure LoadWells;
    procedure LoadCurves;
    property CurrentWell: TWell read GetWell;
    property CurrentFrom : integer read GetCurrentFrom;
    property CurrentTo : integer read GetCurrentTo;
    property CurrentIf : boolean read GetCurrentIf;
    property CurrentFilter : string read GetCurrentFilter;
  end;

implementation

uses SDFacade, CurveDictForm;
var
Selected: array of Boolean;


{$R *.dfm}



function TfrmWellsTree.GetWell : TWell;
var
  Node : PVirtualNode;
  Data : PTreeRecord;
{ Node:TTreeNode;}
begin
  if Assigned(trwWell.FocusedNode) then
  begin
    Data := trwWell.GetNodeData(trwWell.FocusedNode);
    if Assigned(Data.NodeObject) and (Data.NodeObject is TWell)   then
    Result :=Data.NodeObject as TWell;
  end
  else Result := nil;
end;

procedure TfrmWellsTree.LoadLasFiles(Node: PVirtualNode);
var
i,count,start,stop: integer;
NewNode : PVirtualNode;
pr: PTreeRecord;
sd : TSimpleDocument;
query: string;
AResult:OleVariant;
begin
start:=CurrentFrom;
stop:=CurrentTo;

  if Assigned(CurrentWell) then
  begin
      count:=0;
      if (length(Selected)>0) then
        for i := 0 to TComboBox(cmbx1).Items.Count - 1 do
          if Selected[i] then inc(count);
      trwWell.DeleteChildren(Node);
      for i := 0 to CurrentWell.LasFiles.Count - 1 do
      begin

        if ((start=0) and (stop=0)) then
        begin

          if (count>0) then
            begin
              query:='select COUNT(*) from tbl_las_curve lc inner join tbl_curve_dict cd on lc.curve_id=cd.curve_id where las_file_uin='+IntTostr(CurrentWell.LasFiles.Items[i].ID)+' and curve_category_id in ('+CurrentFilter+')';
              TMainFacade.GetInstance.DBGates.ExecuteQuery(query, AResult);
              if (CurrentIf) then
                begin
                  If (integer(AResult[0,0])>0) then
                    begin
                      NewNode:=trwWell.AddChild (Node);
                      pr := trwWell.GetNodeData(NewNode);
                      pr^.NodeObject := CurrentWell.LasFiles.Items[i];
                    end;
                end
              else
                begin
                  If (integer(AResult[0,0])=count) then
                    begin
                      NewNode:=trwWell.AddChild (Node);
                      pr := trwWell.GetNodeData(NewNode);
                      pr^.NodeObject := CurrentWell.LasFiles.Items[i];
                    end;
                end;
            end
          else
            begin
              NewNode:=trwWell.AddChild (Node);
              pr := trwWell.GetNodeData(NewNode);
              pr^.NodeObject := CurrentWell.LasFiles.Items[i];
            end;
        end
        else
        if ((start<=CurrentWell.LasFiles.Items[i].Start) and (stop>=CurrentWell.LasFiles.Items[i].Stop)) then
        begin
          if (count>0) then
            begin
            query:='select COUNT(*) from tbl_las_curve lc inner join tbl_curve_dict cd on lc.curve_id=cd.curve_id where las_file_uin='+IntTostr(CurrentWell.LasFiles.Items[i].ID)+' and curve_category_id in ('+CurrentFilter+')';
            TMainFacade.GetInstance.DBGates.ExecuteQuery(query, AResult);
            if (CurrentIf) then
              begin
                If (integer(AResult[0,0])>0) then
                  begin
                    NewNode:=trwWell.AddChild (Node);
                    pr := trwWell.GetNodeData(NewNode);
                    pr^.NodeObject := CurrentWell.LasFiles.Items[i];
                  end;
              end
            else
              begin
                If (integer(AResult[0,0])=count) then
                  begin
                    NewNode:=trwWell.AddChild (Node);
                    pr := trwWell.GetNodeData(NewNode);
                    pr^.NodeObject := CurrentWell.LasFiles.Items[i];
                  end;
              end;
            end
          else
            begin
              NewNode:=trwWell.AddChild (Node);
              pr := trwWell.GetNodeData(NewNode);
              pr^.NodeObject := CurrentWell.LasFiles.Items[i];
            end;
        end;

      end;
      for i:=0 to TMainFacade.GetInstance.AllWellMaterialBindings.Count-1 do
          if ( (Assigned (TMainFacade.GetInstance.AllWellMaterialBindings.Items[i].SimpleDocument)) and (TMainFacade.GetInstance.AllWellMaterialBindings.Items[i].ID=CurrentWell.ID)) then
            begin
              NewNode:=trwWell.AddChild (Node);
              pr := trwWell.GetNodeData(NewNode);
              pr^.NodeObject := TMainFacade.GetInstance.AllWellMaterialBindings.Items[i].SimpleDocument;
            end;


  end;
end;


procedure TfrmWellsTree.LoadWells;
var i,j: integer;
    Node: PVirtualNode;
   pr, pr2 : PTreeRecord;
   fil : string;
begin
  trwWell.BeginUpdate;
  trwWell.Clear();
  trwWell.NodeDataSize:=SizeOf(TObject);
  fil:='(';
  with TMainFacade.GetInstance do
  for i := 0 to AllWells.Count - 1 do
  begin
    Node := trwWell.AddChild(nil);
    pr := trwWell.GetNodeData(Node);
    pr^.NodeObject := AllWells.Items[i];
    Node:=trwWell.AddChild(Node);
    pr2:=trwWell.GetNodeData(Node);
    pr2^.NodeObject:=nil;
    fil:=fil+IntToStr(AllWells.Items[i].ID)+',';
  end;
  trwWell.EndUpdate;
  fil[Length(fil)]:=')';
    TMainFacade.GetInstance.SkipWellMaterialBinding;
  TMainFacade.GetInstance.WellMaterialBindingFilter:='OBJECT_BIND_ID in '+fil ;

end;

procedure TfrmWellsTree.trwWellGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  Data : PTreeRecord;
  WellData : TWell;
  LasData : TLasFile;
  query : string;
  AResult:OleVariant;
  m : TSimpleDocument;
  i:integer;
begin
  Data:=Sender.GetNodeData(Node);
  if Assigned(Data) and Assigned(Data^.NodeObject) then
    begin
      if (Data^.NodeObject is TWell) then
      begin
      WellData:=Data.NodeObject as TWell;
        case Column of
        0:  CellText:=WellData.List;
        1: CellText:='Забой: '+FloatToStr(WellData.TrueDepth)+'м';
        2: CellText:='';

        end;
      end;
      if (Data^.NodeObject is TLasFile) then
      begin
      LasData:=Data.NodeObject as TLasFile;
        case Column of
        0: CellText:=  ExtractFileName(LasData.OldFileName);
        1: CellText:='Интервал: '+ FloatToStr(LasData.Start) + '-'+ FloatToStr(LasData.Stop);
        2:
          begin
            query:='select * from spd_get_las_methods_by_file('+inttostr(LasData.ID)+')';
            if (TMainFacade.GetInstance.DBGates.ExecuteQuery(query, AResult)>=0) then CellText:=AResult[0,0] else CellText:='';
          end;
        end;
      end;
      if (Data^.NodeObject is TSimpleDocument) then
      begin
        m:=Data.NodeObject as TSimpleDocument;
          case Column of
          0: CellText:= m.Name;
          1: CellText:='';
          2:
           begin
            CellText:='';
            end;
          end;
      end;
  end;
end;

procedure TfrmWellsTree.trwWellExpanded(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  i,count:integer;
begin
  trwWell.BeginUpdate;
    if (Node.ChildCount=1) then
    begin
      trwWell.DeleteNode(Node.FirstChild);
      trwWell.FocusedNode:=Node;
      LoadLasFiles(Node);
    end;
  trwWell.EndUpdate;
end;

procedure TfrmWellsTree.trwWellMeasureItem(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
begin
 if Sender.MultiLine[Node] then
begin
   TargetCanvas.Font := Sender.Font;
   NodeHeight := trwWell.ComputeNodeHeight(TargetCanvas, Node, 0);
end;
end;

procedure TfrmWellsTree.trwWellGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  Data : PTreeRecord;
begin
  Data:=Sender.GetNodeData(Node);
  if (Assigned(Data) and Assigned(Data^.NodeObject) and (Column=0)) then
    begin
      if (Data^.NodeObject is TWell) then
      begin
        ImageIndex:=0;
      end;
      if (Data^.NodeObject is TLasFile) then
      begin
        ImageIndex:=1;
      end;
      if (Data^.NodeObject is TSimpleDocument) then
      begin
        ImageIndex:=2;
      end;
    end;
end;

function TfrmWellsTree.GetCurrentFrom: integer;
begin
  Result:= trckFrom.Position;
end;

function TfrmWellsTree.GetCurrentTo: integer;
begin
  Result:= trckTo.Position;
end;

procedure TfrmWellsTree.actGetPositionsExecute(Sender: TObject);
begin
  pnl1.Caption:='Глубина: '+IntToStr(GetCurrentFrom)+'m - '+IntToStr(GetCurrentTo)+'m';
end;

procedure TfrmWellsTree.LoadCurves;
var
  i:integer;
begin
  cmbx1.Items.Clear;
  for i:=0 to TMainFacade.GetInstance.AllCurveCategories.Count-1 do
    begin
      cmbx1.Items.AddObject(TMainFacade.GetInstance.AllCurveCategories.Items[i].ShortName,TMainFacade.GetInstance.AllCurveCategories.Items[i]);
    end;
end;



procedure TfrmWellsTree.cmbx1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
   SetLength(Selected, TComboBox(Control).Items.Count);
  with TComboBox(Control).Canvas do
  begin
    FillRect(rect);

    Rect.Left := Rect.Left + 1;
    Rect.Right := Rect.Left + 13;
    Rect.Bottom := Rect.Bottom;
    Rect.Top := Rect.Top;

    if not (odSelected in State) and (Selected[Index]) then
      DrawFrameControl(Handle, Rect, DFC_BUTTON,
        DFCS_BUTTONCHECK or DFCS_CHECKED or DFCS_FLAT)
    else if (odFocused in State) and (Selected[Index]) then
      DrawFrameControl(Handle, Rect, DFC_BUTTON,
        DFCS_BUTTONCHECK or DFCS_CHECKED or DFCS_FLAT)
    else if (Selected[Index]) then
      DrawFrameControl(Handle, Rect, DFC_BUTTON,
        DFCS_BUTTONCHECK or DFCS_CHECKED or DFCS_FLAT)
    else if not (Selected[Index]) then
      DrawFrameControl(Handle, Rect, DFC_BUTTON, DFCS_BUTTONCHECK or DFCS_FLAT);

    TextOut(Rect.Left + 15, Rect.Top, TComboBox(Control).Items[Index]);
  end;
end;

procedure TfrmWellsTree.cmbx1Select(Sender: TObject);
var
  i: Integer;
  Sel: string;
begin
  Sel := EmptyStr;
  Selected[TComboBox(Sender).ItemIndex] := not Selected[TComboBox(Sender).ItemIndex];
  for i := 0 to TComboBox(Sender).Items.Count - 1 do
    if Selected[i] then
      Sel := Sel + TComboBox(Sender).Items[i] + ' ';
end;


procedure TfrmWellsTree.btnFilterClick(Sender: TObject);
begin
 trwWell.Clear;
 LoadWells;
end;

function TfrmWellsTree.GetCurrentIf: boolean;
var
  b:boolean;
begin
  if (rbAnd.Checked) then b:=False else b:=true;
  Result:=b;
end;



function TfrmWellsTree.GetCurrentFilter: string;
var
  i,count:integer;
  filter : string;
  cc:TCurveCategory;
begin
  count:=0;
  filter:='';
  for i := 0 to TComboBox(cmbx1).Items.Count - 1 do
  if Selected[i] then
    begin
      cc:=cmbx1.Items.Objects[i]  as TCurveCategory;
      filter:=filter+intTostr(cc.ID)+' , ';
      inc(count);
    end;
  if (count>0) then
    begin
      Delete(filter,length(filter)-2,2);
      {if (CurrentIf) then filter:=StringReplace(filter, ',', 'OR', [rfReplaceAll, rfIgnoreCase])
      else filter:=StringReplace(filter, ',', 'AND',[rfReplaceAll, rfIgnoreCase]);}
    end;
  Result:=filter;
end;

end.
