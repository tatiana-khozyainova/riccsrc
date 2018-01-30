unit RRManagerMapViewFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RRManagerBaseGUI, ToolWin, ComCtrls, OleCtrls,
  RRManagerObjects, ActnList, ImgList, Menus, RRManagerCommon, OleServer,
  RRManagerBaseObjects;

type
//  TfrmMapView = class(TFrame)
  TfrmMapView = class(TBaseFrame)
    tlbrMapEdit: TToolBar;
    actnLst: TActionList;
    actnAgglomerateSelection: TAction;
    actnClearSlelection: TAction;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    imgLst: TImageList;
    tlbtnSelectedStructures: TToolButton;
    pmnStructures: TPopupMenu;
    actnStructures: TAction;
    ToolButton3: TToolButton;
    pmnStructuresFoundByName: TPopupMenu;
    pmnNotFoundStructures: TPopupMenu;
    actStructuresFoundByName: TAction;
    actnNotFoundStructures: TAction;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    actnZoomSelected: TAction;
    ToolButton7: TToolButton;
    procedure actnAgglomerateSelectionExecute(Sender: TObject);
    procedure actnClearSlelectionExecute(Sender: TObject);
    procedure actnStructuresUpdate(Sender: TObject);
    procedure actStructuresFoundByNameUpdate(Sender: TObject);
    procedure actnNotFoundStructuresUpdate(Sender: TObject);
    procedure actnZoomSelectedExecute(Sender: TObject);
    procedure mgmFundMaponSelectionChanged(ASender: TObject;
      const Map: IDispatch);
  private
    { Private declarations }
    FLayerName, FFieldLayerName: string;
    //FLayer, FFieldLayer: IMapLayer3;
    FNGRID: integer;
    FSelectedStructure: TOldStructure;
    FLoadSelectedStructAction: TBaseAction;
    function  GetMapObject(AUIN: string; PreserveSelection: boolean): boolean;
    function  GetMapNamedObject(AName: string; PreserveSelection: boolean): boolean;
    function  GetBufferedObjectsMap: boolean;
    function  GetStructure: TOldStructure;
    procedure MenuItemClick(Sender: TObject);
  protected
    procedure FillControls(ABaseObject: TBaseObject); override;
    procedure ClearControls; override;
    procedure FillParentControls; override;
  public
    { Public declarations }
    property    Structure: TOldStructure read GetStructure;
    property    SelectedStructure: TOldStructure read FSelectedStructure;
    constructor Create(AOwner: TComponent); override;

  end;

implementation

uses RRManagerLoaderCommands, RRManagerPersistentObjects, RRManagerDataPosters,
     RRManagerEditCommands, Facade;

{$R *.dfm}

type

  TLoadSelectedStructure = class(TStructureBaseLoadAction)
  private
    FLastUIN: integer;
  public
    function    Execute(AFilter: string): boolean; override;
    function    Execute(AUIN: integer): boolean; overload;
    constructor Create(AOwner: TComponent); override;
  end;


  TEditSelectedStructure = class(TStructureBaseEditAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; overload; override;
    function Execute: boolean; overload; override;
    function Update: boolean; override;

    constructor Create(AOwner: TComponent); override;
  end;

  // не работает - компонент глючит
  // Shape удаляется один, а строка в таблице - другая,
  // не соответствующая ему 
  TDeleteSelectedStructure = class(TStructureBaseDeleteAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; overload; override;
    function Execute: boolean; overload; override;
    function Update: boolean; override;

    constructor Create(AOwner: TComponent); override;
  end;

  

function FindMenuItem(ATag: integer; AMenu: TMenu): TMenuItem;
var i: integer;
begin
  Result := nil;
  for i := 0 to AMenu.Items.Count - 1 do
  if AMenu.Items[i].Tag = ATag then
  begin
    Result := AMenu.Items[i];
    break;
  end;
end;

function AddMenuItem(AMenu: TMenu; ACaption: string; AImageIndex, ATag: integer; AChacked: boolean; AOnClick: TNotifyEvent): TMenuItem;
begin
  Result := TMenuItem.Create(AMenu);
  Result.Caption := ACaption;
  Result.Tag := ATag;
  Result.Checked := true;
  Result.OnClick := AOnClick;
  Result.ImageIndex := AImageIndex;
  AMenu.Items.Add(Result);
end;


{ TfrmMapView }

procedure TfrmMapView.ClearControls;
begin
  inherited;
  actnClearSlelection.Execute;
end;

constructor TfrmMapView.Create(AOwner: TComponent);
var actn: TBaseAction;
begin
  inherited;

  FLayerName := 'struct';
  FFieldLayerName := 'месторождения';



  actn := TLoadSelectedStructure.Create(actnLst);
  actn.ActionList := actnLst;
  FLoadSelectedStructAction := actn;

{ actn := TDeleteSelectedStructure.Create(actnLst);
  actn.ActionList := actnLst;
  AddToolButton(tlbrMapEdit, actn);}

  actn := TEditSelectedStructure.Create(actnLst);
  actn.ActionList := actnLst;
  AddToolButton(tlbrMapEdit, actn)

end;

procedure TfrmMapView.FillControls(ABaseObject: TBaseObject);
var bObjectFound: boolean;
begin
  inherited;
  if Structure.PetrolRegions.Count > 0 then
    FNGRID := Structure.PetrolRegions.Items[0].ID;
  bObjectFound := GetMapObject(IntToStr(Structure.ID), actnAgglomerateSelection.Checked);


  if bObjectFound then
  begin
   {
     if not mgmFundMap.isBusy and actnZoomSelected.Checked then
     begin
       mgmFundMap.zoomSelected;
       if Assigned(mgmFundMap.Selection) then mgmFundMap.Selection.clear;
     end;
   }

    if  (actnAgglomerateSelection.Checked and  not Assigned(FindMenuItem(Structure.ID, pmnStructures))) then
      AddMenuItem(pmnStructures, Structure.Name, Structure.StructureTypeID + 1,  Structure.ID, true, MenuItemClick)
  end
  else
  begin
    bObjectFound := GetMapNamedObject(Structure.Name, actnAgglomerateSelection.Checked);
    if bObjectFound then
    begin
      {
      if not mgmFundMap.isBusy and actnZoomSelected.Checked then
      begin
        mgmFundMap.zoomSelected;
        if Assigned(mgmFundMap.Selection) then mgmFundMap.Selection.clear;
      end;
      }

      if  (actnAgglomerateSelection.Checked and  not Assigned(FindMenuItem(Structure.ID, pmnStructuresFoundByName))) then
        AddMenuItem(pmnStructuresFoundByName, Structure.Name, Structure.StructureTypeID + 1,  Structure.ID, true, MenuItemClick)
    end
    else
    begin
      // отзумить на НГР

      {
      if not mgmFundMap.isBusy and actnZoomSelected.Checked then
      begin
        if Assigned(mgmFundMap.Selection) then mgmFundMap.Selection.clear;
        mgmFundMap.zoomGotoLocation('НГР_uin', IntToStr(FNgrID), 2000);
      end;}

      if  (actnAgglomerateSelection.Checked and  not Assigned(FindMenuItem(Structure.ID, pmnNotFoundStructures))) then
        AddMenuItem(pmnNotFoundStructures, Structure.Name, Structure.StructureTypeID + 1,  Structure.ID, true, MenuItemClick)
    end;
  end;
end;

procedure TfrmMapView.FillParentControls;
begin
  inherited;

end;

function TfrmMapView.GetMapObject(AUIN: string; PreserveSelection:  boolean): boolean;
{var mObj: IMapObject2;
    sel: ISelection;}
begin
  Result := false;
  {if not mgmFundMap.isBusy then
  begin
    if not Assigned(FLayer) then
      FLayer := mgmFundMap.GetMapLayer(FLayerName);

    if not Assigned(FFieldLayer) then
      FFieldLayer := mgmFundMap.GetMapLayer(FFieldLayerName);

    if Assigned(FLayer) then
    begin
      FLayer.setVisibility(true);

      mObj := FLayer.getMapObject(AUIN);
      if Assigned(mObj) then
      begin
        Result := true;
        sel := mgmFundMap.getSelection;
        if not PreserveSelection then sel.clear;
        sel.addObject(mObj, true);
      end;
    end;
  end;}
end;

function TfrmMapView.GetStructure: TOldStructure;
begin
  Result := EditingObject as TOldStructure;
  FSelectedStructure := Result;
end;

procedure TfrmMapView.actnAgglomerateSelectionExecute(Sender: TObject);
begin
  actnAgglomerateSelection.Checked := not actnAgglomerateSelection.Checked; 
end;

procedure TfrmMapView.actnClearSlelectionExecute(Sender: TObject);
//var sel: ISelection;
begin
  {if not mgmFundMap.isBusy then
  begin
    sel := mgmFundMap.getSelection;
    sel.clear;
    if not mgmFundMap.isBusy and actnZoomSelected.Checked then
    pmnStructures.Items.Clear;
    pmnStructuresFoundByName.Items.Clear;
    pmnNotFoundStructures.Items.Clear;
  end;}
end;

procedure TfrmMapView.MenuItemClick(Sender: TObject);
var mni: TMenuItem;
begin
  mni := Sender as TMenuItem;

  mni.Checked := not mni.Checked;
  GetBufferedObjectsMap;

  { if not mgmFundMap.isBusy and actnZoomSelected.Checked then
     mgmFundMap.zoomSelected; }
end;

function TfrmMapView.GetBufferedObjectsMap: boolean;
{var i: integer;
    sel: ISelection;}
begin
  Result := false;
  {
  sel := mgmFundMap.getSelection;
  sel.Clear;

  for i := 0 to pmnStructures.Items.Count - 1 do
  if pmnStructures.Items[i].Checked then
    GetMapObject(IntToStr(pmnStructures.Items[i].Tag), true);

  for i := 0 to pmnStructuresFoundByName.Items.Count - 1 do
  if pmnStructuresFoundByName.Items[i].Checked then
    GetMapNamedObject(pmnStructuresFoundByName.Items[i].Caption, true);
  }
end;

procedure TfrmMapView.actnStructuresUpdate(Sender: TObject);
begin
  actnStructures.Enabled := actnAgglomerateSelection.Checked and (pmnStructures.Items.Count > 0);
end;

function TfrmMapView.GetMapNamedObject(AName: string;
  PreserveSelection:  boolean): boolean;
{var mObjs: ICollection;
    mObj: OleVariant;
    sel: OleVariant;
    i: integer;
    sName: string;}
begin
{
  Result := false;
  if not mgmFundMap.isBusy then
  begin
    if not Assigned(FLayer) then
      FLayer := mgmFundMap.GetMapLayer(FLayerName);

    if not Assigned(FFieldLayer) then
      FFieldLayer := mgmFundMap.GetMapLayer(FFieldLayerName);


    if Assigned(FLayer) then
    begin
      FLayer.setVisibility(true);
      mObjs := FLayer.getMapObjects;
      for i := 0 to mObjs.size - 1 do
      begin
        mObj := mObjs.item(i);
        sName := trim(AnsiUpperCase(mObj.getName));
        AName := trim(AnsiUpperCase(AName));

        // вычищаем ое, ая и скобки
        AName := trim(StringReplace(AName, '(ОЕ)', '', []));
        AName := trim(StringReplace(AName, '(-ОЕ)', '', []));



        if (pos(sName, AName) = 1) or (pos(AName, sName) = 1) then
        begin
          Result := true;
          sel := mgmFundMap.getSelection;

          if not PreserveSelection then sel.clear;
          sel.addObject(mObj, true);
          break;
        end;
      end;
    end;
  end;}
end;

procedure TfrmMapView.actStructuresFoundByNameUpdate(Sender: TObject);
begin
  actStructuresFoundByName.Enabled := actnAgglomerateSelection.Checked and (pmnStructuresFoundByName.Items.Count > 0);
end;

procedure TfrmMapView.actnNotFoundStructuresUpdate(Sender: TObject);
begin
  actnNotFoundStructures.Enabled := actnAgglomerateSelection.Checked and (pmnNotFoundStructures.Items.Count > 0);
end;

procedure TfrmMapView.actnZoomSelectedExecute(Sender: TObject);
begin
  actnZoomSelected.Checked := not actnZoomSelected.Checked;
  {if not mgmFundMap.isBusy and actnZoomSelected.Checked then
    mgmFundMap.zoomSelected
  else mgmFundMap.zoomOut;}
end;

procedure TfrmMapView.mgmFundMaponSelectionChanged(ASender: TObject;
  const Map: IDispatch);
{var Sel: OleVariant;
    SelObjs: OleVariant;
    SelItem: OleVariant;
    i, iKey: integer;}
begin
  //
  {
  FSelectedStructure := nil;
  sel := mgmFundMap.getSelection;

  if not Assigned(FLayer) then
    FLayer := mgmFundMap.GetMapLayer(FLayerName);

  if not Assigned(FFieldLayer) then
    FFieldLayer := mgmFundMap.GetMapLayer(FFieldLayerName);


  SelObjs := Sel.getMapObjects(FLayer);
  if SelObjs.Count = 0 then
    SelObjs := Sel.getMapObjects(FFieldLayer);

  for i := 0 to SelObjs.Count - 1 do
  begin
    SelItem := SelObjs.Item(i);
    iKey := SelItem.Key;

    if iKey > 0 then
    begin
      (FLoadSelectedStructAction as TLoadSelectedStructure).Execute(iKey);
    end;
  end;}
end;

{ TLoadSelectedStructure }

constructor TLoadSelectedStructure.Create(AOwner: TComponent);
begin
  inherited;
  Visible := false;
  Enabled := false;
end;

function TLoadSelectedStructure.Execute(AFilter: string): boolean;
var dp: TDataPoster;
    cls: TDataPosterClass;
begin
  with ActionList.Owner as TfrmMapView do
  begin
    FSelectedStructure := (TMainFacade.GetInstance as TMainFacade).AllStructures.ItemsByUIN[FLastUIN] as TOldStructure;
    if not Assigned(FSelectedStructure) then
    begin
      Result := false;
      LastCollection := (TMainFacade.GetInstance as TMainFacade).AllStructures;
      LastCollection.NeedsUpdate := (AFilter <> LastFilter) or (FLastUIN = 0);
      LastFilter := AFilter;
      if LastCollection.NeedsUpdate then
      begin
        dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[TStructureDataPoster] as TDataPoster;
        dp.ClearFirst := false;
        Result := inherited Execute(AFilter);

        FSelectedStructure := (TMainFacade.GetInstance as TMainFacade).AllStructures.ItemsByUIN[FLastUIN] as TOldStructure;
        dp.ClearFirst := true;

        if Assigned(FSelectedStructure) then
        begin
          cls := TStructureDataPoster;
          case FSelectedStructure.StructureTypeID of
            // Выявленные
            1: cls := TDiscoveredStructureDataPoster;
            // подгтовленные
            2: cls := TPreparedStructureDataPoster;
            // в бурении
            3: cls := TDrilledStructureDataPoster;
            // месторождения
            4: cls := TFieldDataPoster;
          end;

          if Assigned(cls) then
          begin
            // берем постер
            dp := (TMainFacade.GetInstance as TMainFacade).AllPosters.Posters[cls];
            // инициализируем коллекцию
            dp.LastGotObject := FSelectedStructure;
            // инициализируем коллекцию
            dp.GetFromDB(FSelectedStructure.ID);
            FSelectedStructure.NeedsUpdate := false;
          end;
        end;
      end;
    end;
  end;
end;

function TLoadSelectedStructure.Execute(AUIN: integer): boolean;
begin
  FLastUIN := AUIN;
  Result := Execute('Structure_ID = ' + IntToStr(AUIN));
end;

{ TEditSelectedStructure }

constructor TEditSelectedStructure.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Редактировать структуру';
  ImageIndex := 2;
  Visible := true;
  Enabled := true;
end;

function TEditSelectedStructure.Execute: boolean;
begin
  Result := Execute((ActionList.Owner as TfrmMapView).SelectedStructure);
end;

function TEditSelectedStructure.Execute(ABaseObject: TBaseObject): boolean;
begin
  Result := inherited Execute(ABaseObject);

end;

function TEditSelectedStructure.Update: boolean;
begin
  inherited Update;
  Result := Assigned((ActionList.Owner as TfrmMapView).SelectedStructure);

  Enabled := Result;
end;

{ TDeleteSelectedStructure }

constructor TDeleteSelectedStructure.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Удалить структуру';
  ImageIndex := 11;
  Visible := true;
  Enabled := true;
end;

function TDeleteSelectedStructure.Execute: boolean;
begin
  Result := Execute((ActionList.Owner as TfrmMapView).SelectedStructure);
end;

function TDeleteSelectedStructure.Execute(
  ABaseObject: TBaseObject): boolean;
{
var iUIN, iCurRecord: integer;
    frm: TfrmMapView;
    ShapeFiles: TShapeFiles;
    sName: OleVariant;

procedure CopyFiles(AFileName: string);
var sr: TSearchRec;
    sTimeStamp: string;
    fs, ss: TFileStream;
begin
  sTimeStamp := FormatDateTime('yyyy_m_d_hh_mm', Now);
  if FindFirst('\\srv3\fund$\' + AFileName + '.*', faAnyFile, Sr) = 0 then
  begin
    sTimeStamp :='\\srv3\fund$\ModifiedShapes\' + sTimeStamp + '\';
    repeat
      CreateDir(sTimeStamp);
      fs := TFileStream.Create(sTimeStamp + ExtractFileName(sr.Name), fmCreate or fmOpenWrite);
      ss := TFileStream.Create('D:\Work\NewClient\Struct\' + sr.Name, fmOpenRead);
      fs.CopyFrom(ss, ss.Size);
      fs.Free;
      SS.Free;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end
end;}

{procedure MoveFiles(AShapeFiles: TShapeFiles);
var NewSHP: TShapeFiles;
    i: integer;
    k: OleVariant;
begin
  NewSHP := TShapeFiles.Create(nil);
  NewSHP.OpenShape('D:\Work\NewClient\Struct\' + 'struct_.shp', shpCreate, shpPolygon);

  // добавляем поля
  for i := 0 to AShapeFiles.ShapeFields.Count - 1 do
  begin
    k := i;
    NewSHP.ShapeFields.CreateField(AShapeFiles.ShapeFields[k].FieldName,
                                   AShapeFiles.ShapeFields[k].FieldType,
                                   AShapeFiles.ShapeFields[k].FieldSize,
                                   AShapeFiles.ShapeFields[k].FieldDecimal);
  end;

  NewSHP.AppendFieldDefs;
  for i := 0 to AShapeFiles.RecordCount - 1 do
  begin
    NewSHP.CreateShape;
  end;
end;  }

begin
(*  iUIN := ABaseObject.ID;
//  Result := inherited Execute(ABaseObject);
  Result := true;

  if Result then
  begin
    frm := (ActionList.Owner as TfrmMapView);

    ShapeFiles := TShapeFiles.Create(nil);

    ShapeFiles.OpenShape('D:\Work\NewClient\Struct\struct.shp', shpOpen, shpPolygon);
    ShapeFiles.FindFirst('ID', '=', varAsType(iUIN, varInteger));

    While not ShapeFiles.NoMatch do
    begin
      // копируем ShapeFile в другое место
      CopyFiles('struct');
      // удаляем
      ShapeFiles.MoveTo(ShapeFiles.CurrentRecord - 2);
      ShowMessage(IntToStr(ShapeFiles.CurrentRecord));
      sName := 'ID';
      ShowMessage(varAsType(ShapeFiles.ShapeFields[sName].Value, varOleStr));
      sName := 'ID';
      ShowMessage(varAsType(ShapeFiles.ShapeFields[sName].Value, varOleStr));

      iCurRecord := ShapeFiles.CurrentRecord;


      ShapeFiles.OpenShape('D:\Work\NewClient\Struct\struct.shp', shpEdit, shpPolygon);
      ShapeFiles.Pack;

      ShapeFiles.OpenShape('D:\Work\NewClient\Struct\struct.shp', shpOpen, shpPolygon);
      ShapeFiles.FindNext;
      if not ShapeFiles.NoMatch then ShapeFiles.OpenShape('D:\Work\NewClient\Struct\struct.shp', shpEdit, shpPolygon);
    end;

    // переместить файлы
    ShapeFiles.Free;
  end;
  *)
end;


function TDeleteSelectedStructure.Update: boolean;
begin
  Result := Assigned((ActionList.Owner as TfrmMapView).SelectedStructure);
  Enabled := Result;
end;

end.
