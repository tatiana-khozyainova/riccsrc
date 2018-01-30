unit RRManagerQuickMapViewFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RRManagerObjects, OleCtrls, ComCtrls,
  ActnList, ToolWin, DB, ADODB, ImgList, StdCtrls, Menus, RRManagerBaseGUI,
  RRManagerBaseObjects, BaseObjects;

type
  TFoundType = (ftByUIN, ftByName, ftNotFound);

  TfrmQuickViewMap = class(TFrame, IConcreteVisitor)
    tlbr: TToolBar;
    actnLst: TActionList;
    actnUIN: TAction;
    tlbtnUIN: TToolButton;
    ToolButton2: TToolButton;
    actnFund: TAction;
    actnComment: TAction;
    imgLst: TImageList;
    ToolButton3: TToolButton;
    actnSave: TAction;
    actnUndo: TAction;
    tlbrEdit: TToolBar;
    edtComment: TEdit;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    pmnStructs: TPopupMenu;
    procedure actnUINExecute(Sender: TObject);
    procedure actnUINUpdate(Sender: TObject);
    procedure mgmFundMaponSelectionChanged(ASender: TObject;
      const Map: IDispatch);
    procedure actnFundExecute(Sender: TObject);
    procedure actnCommentExecute(Sender: TObject);
    procedure actnFundUpdate(Sender: TObject);
    procedure actnCommentUpdate(Sender: TObject);
    procedure actnSaveExecute(Sender: TObject);
    procedure actnUndoExecute(Sender: TObject);
  private
    { Private declarations }
    //FLayer: IMapLayer3;
    FLayerName: string;
    FUpdateByName, FUpdateByObjectID, FSelectQry, FUpdateUINed, FSelectUINed: string;
    FFoundType: TFoundType;
    FSelItemName: string;
    FConnString: string;
    FLastNote, FLastKlass: string;
    FQuickViewObject: TBaseObject;
    FMapPath: string;
    FZoomGoToUINed: string;
    FZoomGotoNamed: string;


    function  GetMapObject(AUIN: string; ForceZoom: boolean): integer;
    function  GetMapNamedObject(AName: string): integer;
    procedure SetQuickViewObject(const Value: TBaseObject);
    procedure SetMapPath(const Value: string);
//    procedure PrepareForDuplicatesArranging;
//    procedure UnprepareForDuplicatesArranging;
  protected
    function  GetActiveObject: TIDObject;
    procedure SetActiveObject(const Value: TIDObject);
  public
    { Public declarations }
    procedure VisitVersion(AVersion: TOldVersion);
    procedure VisitStructure(AStructure: TOldStructure);

    procedure VisitDiscoveredStructure(ADiscoveredStructure: TOldDiscoveredStructure);
    procedure VisitPreparedStructure(APreparedStructure: TOldPreparedStructure);
    procedure VisitDrilledStructure(ADrilledStructure: TOldDrilledStructure);
    procedure VisitField(AField: RRManagerObjects.TOldField);

    procedure VisitHorizon(AHorizon: TOldHorizon);

    procedure VisitSubstructure(ASubstructure: TOldSubstructure);

    procedure VisitLayer(ALayer: TOldLayer);

    procedure VisitBed(ABed: TOldBed);
    procedure VisitAccountVersion(AAccountVersion: TOldAccountVersion);
    procedure VisitStructureHistoryElement(AHistoryElement: TOldStructureHistoryElement);
    procedure VisitOldLicenseZone(ALicenseZone: TOldLicenseZone);
    
    procedure Clear;


    property  QuickViewObject: TBaseObject read FQuickViewObject write SetQuickViewObject;


    property    LayerName: string read FLayerName write FLayerName;
    property    UpdateByName: string read FUpdateByName write FUpdateByName;
    property    UpdateByObjectID: string read FUpdateByObjectID write FUpdateByObjectID;
    property    SelectQry: string read FSelectQry write FSelectQry;
    property    SelectUINed: string read FSelectUINed write FSelectUINed;
    property    UpdateUINed: string read FUpdateUINed write FUpdateUINed;
    property    ZoomGoToUINed: string read FZoomGoToUINed write FZoomGoToUINed;
    property    ZoomGoToNamed: string read FZoomGotoNamed write FZoomGotoNamed;

    property    MapPath: string read FMapPath write SetMapPath;

    procedure VisitWell(AWell: TIDObject);
    procedure VisitTestInterval(ATestInterval: TIDObject);
    procedure VisitLicenseZone(ALicenseZone: TIDObject);
    procedure VisitSlotting(ASlotting: TIDObject);

    procedure VisitCollectionWell(AWell: TIDObject);
    procedure VisitCollectionSample(ACollectionSample: TIDObject);
    procedure VisitDenudation(ADenudation: TIDObject);
    procedure VisitWellCandidate(AWellCandidate: TIDObject);
    


    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses ClientCommon, Facade;

{$R *.dfm}

type

   TPutUINByObjectID = class(TBaseAction)
   public
     function Execute: boolean; override;
   end;

{ TfrmQuickViewMap }

procedure TfrmQuickViewMap.Clear;
//var sel: ISelection;
begin
//  FStructure := nil;
  {sel := mgmFundMap.getSelection;
  if Assigned(Sel) then
  begin
    sel.clear;
    if not mgmFundMap.isBusy then mgmFundMap.zoomOut;
    actnComment.Checked := false;
    edtComment.Clear;
  end;}
end;

constructor TfrmQuickViewMap.Create(AOwner: TComponent);
begin
  inherited;
  FSelItemName := 'empty';
  FConnString := 'Provider=MSDASQL.1;Persist Security Info=False;Data Source=FundStruct';
  FFoundType := ftNotFound;
end;

function TfrmQuickViewMap.GetMapNamedObject(AName: string): integer;
//var mObjs: ICollection;
//    qry: TADOQuery;
begin
  (*
  Result := 0;
  //if not mgmFundMap.isBusy then
  begin
    if not Assigned(FLayer) then
      FLayer := mgmFundMap.GetMapLayer(FLayerName);

    {if not Assigned(FFieldLayer) then
      FFieldLayer := mgmFundMap.GetMapLayer(FFieldLayerName);}


    if Assigned(FLayer) then
    begin
      FLayer.setVisibility(true);
      mObjs := FLayer.getMapObjects;

      // вычищаем ое, ая и скобки
      AName := trim(StringReplace(AName, '(ОЕ)', '', []));
      AName := trim(StringReplace(AName, '(-ОЕ)', '', []));
      // отрезаем 4 последних
      AName := copy(AName, 1, Length(AName) - 4);
      // проверяем есть ли такое имя
      qry := TADOQuery.Create(nil);
      qry.ConnectionString := FConnString;
      qry.SQL.Text := Format(FSelectQry , [QuickViewObject.List(loMapAttributes, false, false)]);
      qry.Open;
      Result := qry.RecordCount;
      qry.Close;
      qry.Free;

      if Result > 0 then mgmFundMap.zoomGotoLocation('Структуры', AName, 2000);
    end;
  end; *)
end;

function TfrmQuickViewMap.GetMapObject(AUIN: string; ForceZoom: boolean): integer;
var qry: TADOQuery;
begin
  Result := 0;
  (* if not mgmFundMap.isBusy then
  begin
    if not Assigned(FLayer) then
      FLayer := mgmFundMap.GetMapLayer(FLayerName);

    {if not Assigned(FFieldLayer) then
      FFieldLayer := mgmFundMap.GetMapLayer(FFieldLayerName)};

    if Assigned(FLayer) then
    begin
      FLayer.setVisibility(true);
      // сразу готовим
      qry := TADOQuery.Create(nil);
      qry.ConnectionString := FConnString;


      qry.SQL.Text := Format(FSelectUINed, [IntToStr(QuickViewObject.ID)]);
      qry.Prepared := true;
      qry.Open;
      qry.First;



      if qry.Recordset.RecordCount > 0 then
      begin
        Result := qry.RecordCount;
        mgmFundMap.zoomGotoLocation(ZoomGoToUINed, AUIN, 2000);

        FLastNote := trim(qry.Fields[0].AsString);
        FLastKlass := trim(qry.Fields[1].AsString);
      end
      else if ForceZoom then
      begin
        mgmFundMap.zoomGotoLocation(ZoomGoToUINed, AUIN, 2000);
        Result := 0;
      end;

      qry.Close;
      qry.Free;
    end;
  end; *)
end;


procedure TfrmQuickViewMap.VisitBed(ABed: TOldBed);
begin
  QuickViewObject := ABed;
end;

procedure TfrmQuickViewMap.VisitDiscoveredStructure(
  ADiscoveredStructure: TOldDiscoveredStructure);
begin
  QuickViewObject := ADiscoveredStructure;
end;

procedure TfrmQuickViewMap.VisitDrilledStructure(
  ADrilledStructure: TOldDrilledStructure);
begin
  QuickViewObject := ADrilledStructure;
end;

procedure TfrmQuickViewMap.VisitField(AField: RRManagerObjects.TOldField);
begin
  QuickViewObject := AField;
end;

procedure TfrmQuickViewMap.VisitHorizon(AHorizon: TOldHorizon);
begin
  QuickViewObject := AHorizon.Structure;
end;

procedure TfrmQuickViewMap.VisitLayer(ALayer: TOldLayer);
begin
  if Assigned(ALayer.Substructure) then
    QuickViewObject := ALayer.Substructure.Horizon.Structure
  else
  if Assigned(ALayer.Bed) then
    QuickViewObject := ALayer.Bed.Structure;
end;

procedure TfrmQuickViewMap.VisitPreparedStructure(
  APreparedStructure: TOldPreparedStructure);
begin
  QuickViewObject := APreparedStructure;
end;

procedure TfrmQuickViewMap.VisitStructure(AStructure: TOldStructure);
begin
  QuickViewObject := AStructure;
end;

procedure TfrmQuickViewMap.VisitSubstructure(ASubstructure: TOldSubstructure);
begin
  QuickViewObject := ASubstructure.Horizon.Structure;
end;

procedure TfrmQuickViewMap.actnUINExecute(Sender: TObject);
var qry: TADOQuery;
begin
  qry := TADOQuery.Create(nil);
  qry.ConnectionString := FConnString;
  if  FSelItemName = 'empty' then
    qry.SQL.Text := Format(FUpdateByName, [IntToStr(QuickViewObject.ID), QuickViewObject.List(loMapAttributes, false, false), QuickViewObject.List(loMapAttributes, false, false) + '\n' + IntToStr(QuickViewObject.ID), QuickViewObject.List(loMapAttributes, false, false)])
  else
  begin
    FSelItemName := copy(FSelItemName, 1, pos('\n', FSelItemName)-1);
    qry.SQL.Text := Format(FUpdateByName, [IntToStr(QuickViewObject.ID), QuickViewObject.List(loMapAttributes, false, false), QuickViewObject.List(loMapAttributes, false, false) + '\n' + IntToStr(QuickViewObject.ID), FSelItemName]);
  end;
  qry.Prepared := true;
  qry.ExecSQL;
  qry.Close;
 
  qry.Free;
  //FLayer.Rebuild := true;
  if GetMapObject(IntToStr(QuickViewObject.ID), true) > 0 then FFoundType := ftByUIN;
end;


procedure TfrmQuickViewMap.actnUINUpdate(Sender: TObject);
begin
//
  actnUIN.Enabled := Assigned(QuickViewObject) and ((FFoundType <> ftNotFound) or (FSelItemName <> 'empty'));
end;

procedure TfrmQuickViewMap.mgmFundMaponSelectionChanged(ASender: TObject;
  const Map: IDispatch);
var sel: OleVariant;
    selObjs: OleVariant;
begin
  (* sel := mgmFundMap.getSelection;

  if not Assigned(FLayer) then
    FLayer := mgmFundMap.GetMapLayer(FLayerName);

  {if not Assigned(FFieldLayer) then
    FFieldLayer := mgmFundMap.GetMapLayer(FFieldLayerName){};


  SelObjs := Sel.getMapObjects(FLayer);
  {if SelObjs.Count = 0 then
    SelObjs := Sel.getMapObjects(FFieldLayer);}

  if SelObjs.Count > 0 then
  begin
    FSelItemName := SelObjs.Item(0).getName;
//    if SelObjs.Count > 1 then
//      PrepareForDuplicatesArranging
//    else UnPrepareForDuplicatesArranging;
  end
  else FSelItemName := 'empty'; *)
end;

procedure TfrmQuickViewMap.actnFundExecute(Sender: TObject);
var qry: TADOQuery;
    sNewKlass: string;
begin
  sNewKlass := varAsType(GetObjectName((TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName['TBL_STRUCTURE_FUND_TYPE_DICT'].Dict, (QuickViewObject as TOldStructure).StructureTypeID, 2), varOleStr);
  if sNewKlass <> '' then
  begin
    qry := TADOQuery.Create(nil);
    qry.ConnectionString := FConnString;
    qry.SQL.Text := Format(FUpdateUINed, ['klass', sNewKlass, IntToStr(QuickViewObject.ID)]);
    qry.Prepared := true;
    qry.ExecSQL;
    qry.Close;
    qry.Free;
    //FLayer.Rebuild := true;
  end;
end;

procedure TfrmQuickViewMap.actnCommentExecute(Sender: TObject);
begin
  actnComment.Checked := not actnComment.Checked;

  tlbrEdit.Visible := actnComment.Checked;
  if tlbrEdit.Visible then
  begin
    // загружаем
    edtComment.Text := FLastNote;

    edtComment.SetFocus;
    edtComment.SelectAll;
  end;
end;

procedure TfrmQuickViewMap.actnFundUpdate(Sender: TObject);
var s: string;
begin
  if Assigned(QuickViewObject) and (QuickViewObject is TOldStructure) and (not(QuickViewObject is RRManagerObjects.TOldField)) then
  begin
    s := varAsType(GetObjectName((TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName['TBL_STRUCTURE_FUND_TYPE_DICT'].Dict, (QuickViewObject as TOldStructure).StructureTypeID, 2), varOleStr);
    actnFund.Enabled := (FFoundType = ftByUIN) and (FLastKlass <> s) and (FLastKlass <> '');
  end
  else actnFund.Enabled := false;
end;

procedure TfrmQuickViewMap.actnCommentUpdate(Sender: TObject);
begin
  actnComment.Enabled := (FFoundType = ftByUIN)
end;

procedure TfrmQuickViewMap.actnSaveExecute(Sender: TObject);
var qry: TADOQuery;
begin
  qry := TADOQuery.Create(nil);
  qry.ConnectionString := FConnString;
  qry.SQL.Text := Format(FUpdateUINed, ['note', edtComment.Text, IntToStr(QuickViewObject.ID)]);
  qry.Prepared := true;
  qry.ExecSQL;
  qry.Close;
  qry.Free;
  //FLayer.Rebuild := true;
end;

procedure TfrmQuickViewMap.actnUndoExecute(Sender: TObject);
begin
  edtComment.Text := FLastNote;
end;

{procedure TfrmQuickViewMap.PrepareForDuplicatesArranging;
var qry: TADOQuery;
    actn: TBaseAction;
    pmi: TMenuItem;
begin
  pmnStructs.Items.Clear;
  pmi := TMenuItem.Create(pmnStructs);
  pmi.Action := actnUIN;
  pmi.Caption := actnUIN.Caption + '(все)';
  pmnStructs.Items.Add(pmi);


  // выбираем дублированные
  // создаём пункты меню
  // привязываем их ID к пунктам меню
  qry := TADOQuery.Create(nil);
  qry.ConnectionString := FConnString;
  qry.SQL.Text := Format(FSelectQry , [Structure.Name]);
  qry.Open;
  qry.First;
  while not qry.Eof do
  begin
    actn := TPutUINByObjectID.Create(Self);
    actn.Tag := qry.Fields[0].AsInteger;
    actn.Caption := FSelItemName + '(' + IntToStr(actn.Tag) + ')';

    pmi := TMenuItem.Create(pmnStructs);
    pmnStructs.Items.Add(pmi);
    pmi.Action := actn;
    qry.Next;
  end;

  qry.Close;
  qry.Free;

  tlbtnUIN.Action := nil;
  tlbtnUIN.Style := tbsDropDown;
  tlbtnUIN.DropdownMenu := pmnStructs;
  tlbtnUIN.Enabled := true;
end;

procedure TfrmQuickViewMap.UnprepareForDuplicatesArranging;
begin
  tlbtnUIN.Action := actnUIN;
  tlbtnUIN.Style := tbsButton;
  tlbtnUIN.DropdownMenu := nil;
end;}

procedure TfrmQuickViewMap.VisitAccountVersion(
  AAccountVersion: TOldAccountVersion);
begin
  QuickViewObject := AAccountVersion.Structure;
end;

procedure TfrmQuickViewMap.VisitStructureHistoryElement(
  AHistoryElement: TOldStructureHistoryElement);
begin
  QuickViewObject := AHistoryElement.HistoryStructure;
end;

procedure TfrmQuickViewMap.VisitVersion(AVersion: TOldVersion);
begin
  { TODO : может быть тоже - подключение слоя в зависимости от версии }
end;

procedure TfrmQuickViewMap.SetQuickViewObject(const Value: TBaseObject);
var iObjectsFound: integer;
begin
  iObjectsFound := 0;
  FSelItemName := 'empty';
  if FQuickViewObject <> Value then
  begin
    FLastNote := '';
    FLastKlass := '';
    actnComment.Checked := false;
    tlbrEdit.Visible := false;
    edtComment.Clear;

    FQuickViewObject := Value;

    if Assigned(FQuickViewObject) then
    begin
      iObjectsFound := GetMapObject(IntToStr(FQuickViewObject.ID), false);
      FFoundType := ftByUIN;
      if iObjectsFound = 0 then
      begin
        iObjectsFound := GetMapNamedObject(FQuickViewObject.List(loMapAttributes, false, false));
        FFoundType := ftByName;
      end;
    end;  

    if iObjectsFound = 0 then
    begin
      Clear;
//      UnprepareForDuplicatesArranging;
      FFoundType := ftNotFound;
    end
//    else PrepareForDuplicatesArranging;
  end;
end;

procedure TfrmQuickViewMap.SetMapPath(const Value: string);
begin
  FMapPath := Value;
  //mgmFundMap.URL := FMapPath;
  //mgmFundMap.refresh;
  //mgmFundMap.

end;

procedure TfrmQuickViewMap.VisitOldLicenseZone(ALicenseZone: TOldLicenseZone);
begin
  QuickViewObject := ALicenseZone;
end;

function TfrmQuickViewMap.GetActiveObject: TIDObject;
begin
  Result := nil;  
end;

procedure TfrmQuickViewMap.SetActiveObject(const Value: TIDObject);
begin

end;


procedure TfrmQuickViewMap.VisitSlotting(ASlotting: TIDObject);
begin

end;

procedure TfrmQuickViewMap.VisitTestInterval(ATestInterval: TIDObject);
begin

end;

procedure TfrmQuickViewMap.VisitWell(AWell: TIDObject);
begin

end;

procedure TfrmQuickViewMap.VisitLicenseZone(ALicenseZone: TIDObject);
begin

end;

procedure TfrmQuickViewMap.VisitCollectionSample(
  ACollectionSample: TIDObject);
begin

end;

procedure TfrmQuickViewMap.VisitCollectionWell(AWell: TIDObject);
begin

end;

procedure TfrmQuickViewMap.VisitDenudation(ADenudation: TIDObject);
begin

end;

procedure TfrmQuickViewMap.VisitWellCandidate(AWellCandidate: TIDObject);
begin

end;

{ TPutUINByObjectID }

function TPutUINByObjectID.Execute: boolean;
var qry: TADOQuery;
    frm: TfrmQuickViewMap;
begin
  Result := true;
  qry := TADOQuery.Create(nil);
  frm := Owner as TfrmQuickViewMap;

  qry.ConnectionString := frm.FConnString;

  qry.SQL.Text := Format(frm.FUpdateByObjectID, [IntToStr(frm.QuickViewObject.ID), frm.QuickViewObject.List(loMapAttributes, false, false), frm.QuickViewObject.List(loMapAttributes, false, false) + '\n' + IntToStr(frm.QuickViewObject.ID), IntToStr(Tag)]);

  qry.Prepared := true;
  qry.ExecSQL;
  qry.Close;

  qry.Free;
  //frm.FLayer.Rebuild := true;
  if frm.GetMapObject(IntToStr(frm.QuickViewObject.ID), true) > 0 then frm.FFoundType := ftByUIN;
end;

end.



