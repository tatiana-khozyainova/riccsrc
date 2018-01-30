unit RRManagerEditParamsFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ToolWin, ImgList, ActnList, CommonComplexCombo,
  ExtCtrls, RRManagerEditVersionFrame, RRManagerBaseObjects, RRManagerObjects,
  ClientCommon, RRManagerBaseGUI, FramesWizard
  {$IFDEF VER150}
  , Variants, RRManagerVersionsFrame
  {$ENDIF}
  ;


type
//  TfrmParams = class(TFrame)
  TfrmParams = class(TBaseFrame)
    gbxProperties: TGroupBox;
    frmVersions1: TfrmVersions;
    Splitter1: TSplitter;
    pnlParams: TPanel;
    cmplxParam: TfrmComplexCombo;
    cmplxFluidType: TfrmComplexCombo;
    lblValue: TLabel;
    edtValue: TEdit;
    btnSave: TButton;
    Bevel1: TBevel;
    cmplxReserveCategory: TfrmComplexCombo;
    cmplxRelationship: TfrmComplexCombo;
    cmplxReservesValueType: TfrmComplexCombo;
    cmbxLicenseZone: TComboBox;
    Label2: TLabel;
    chbxUseInterval: TCheckBox;
    edtNextValue: TEdit;
    lblOrganization: TLabel;
    procedure trwParamsChange(Sender: TObject; Node: TTreeNode);
    procedure edtValueChange(Sender: TObject);
    procedure trwParamsChanging(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure frmVersions1tlbtnAddReserveClick(Sender: TObject);
    procedure frmVersions1AddSubElementExecute(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure cmplxParamcmbxNameChange(Sender: TObject);
    procedure cmplxFluidTypecmbxNameChange(Sender: TObject);
    procedure frmVersions1ToolButton2Click(Sender: TObject);
    procedure cmplxReserveCategorycmbxNameChange(Sender: TObject);
    procedure cmplxParamcmbxNameSelect(Sender: TObject);
    procedure cmplxFluidTypecmbxNameSelect(Sender: TObject);
    procedure cmplxReserveCategorycmbxNameSelect(Sender: TObject);
    procedure frmVersions1tlbtnAddVersionClick(Sender: TObject);
    procedure cmplxReservesValueTypecmbxNameChange(Sender: TObject);
    procedure cmplxRelationshipcmbxNameChange(Sender: TObject);
    procedure chbxUseIntervalClick(Sender: TObject);
    procedure edtValueKeyPress(Sender: TObject; var Key: Char);
    procedure edtNextValueKeyPress(Sender: TObject; var Key: Char);
    procedure cmbxLicenseZoneChange(Sender: TObject);
  private
    { Private declarations }
    FParam: TOldParam;
    FVersions: TOldAccountVersions;
    function GetBed: TOldBed;
    function GetHorizon: TOldHorizon;
    function GetLayer: TOldLayer;
    function GetStructure: TOldStructure;
    function GetSubstructure: TOldSubstructure;
    function GetVersions: TOldAccountVersions;
    procedure SetParam(const Value: TOldParam);
    function  GetFirstAssignedObject: TBaseObject;
    procedure ClearOnlyControls;
    procedure SaveParam;
    procedure ExecuteLoadAction;
//    procedure FindSelection(const ADocID, ATypeID, AParamID: integer);
    procedure Arrange;
    procedure OnSaveVersion(Sender: TObject);
    procedure OnChangeVersion(Sender: TObject);
    function  GetTempBed: TOldBed;
    function  GetTempHorizon: TOldHorizon;
    function  GetTempLayer: TOldLayer;
    function  GetTempStructure: TOldStructure;
    function  GetTempSubstructure: TOldSubstructure;
    function  GetVersion: TOldAccountVersion;
    procedure SetVersion(const Value: TOldAccountVersion);
  protected
    procedure FillControls(ABaseObject: TBaseObject); override;
    procedure ClearControls; override;
    procedure FillParentControls; override;
    procedure RegisterInspector; override;
    procedure LocalRegisterInspector;
  private
    FTempObject: TBaseObject;
    FAction:  TBaseAction;
    FCreatedCollection: TBaseCollection;
    FCreatedObject: TBaseObject;
    procedure AddParam(Sender: TObject);
    procedure DeleteParam(Sender: TObject);
    procedure AddVersion(Sender: TObject);
    procedure DeleteVersion(Sender: TObject);
    procedure SaveCurrentChecked(Sender: TObject);
    procedure MakeClear(Sender: TObject);
    procedure MakeUndo(Sender: TObject);
    procedure ViewChange(Sender: TObject);
  public
    { Public declarations }
    // парамытры могут принадлежать всему, чему только можно
    property Structure: TOldStructure read GetStructure;
    property Horizon: TOldHorizon read GetHorizon;
    property Bed: TOldBed read GetBed;
    property Substructure: TOldSubstructure read GetSubstructure;
    property Layer: TOldLayer read GetLayer;

    property TempStructure: TOldStructure read GetTempStructure;
    property TempHorizon: TOldHorizon read GetTempHorizon;
    property TempBed: TOldBed read GetTempBed;
    property TempSubstructure: TOldSubstructure read GetTempSubstructure;
    property TempLayer: TOldLayer read GetTempLayer;

    property FirstAssignedObject: TBaseObject read GetFirstAssignedObject;
    function Check: boolean; override;



    property Versions: TOldAccountVersions read GetVersions;
    property Version: TOldAccountVersion read GetVersion write SetVersion;
    property Param: TOldParam read FParam write SetParam;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure   Save; override;
  end;

implementation

uses RRManagerLoaderCommands, Facade, LicenseZone, Registrator;

{$R *.DFM}

{ TfrmParams }

type

{ TODO :
В этой версии редакция параметров отключена.
Чего то глючит Arrange. Разберёмся. Наверное. }

  TParamVersionLoadAction = class(TVersionBaseLoadAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; overload; override;
    function Execute(AStructure: TOldStructure): boolean; overload;
    function Execute(ABed: TOldBed): boolean; overload;
    function Execute(ALayer: TOldLayer): boolean; overload;
    function Execute(ASubstructure: TOldSubstructure): boolean; overload;
    function Execute(AHorizon: TOldHorizon): boolean; overload;
  end;

  TParamByVersionLoadAction = class(TParamByVersionBaseLoadAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
  end;



procedure TfrmParams.ClearControls;
begin
  FVersions.Free;
  FVersions := nil;
  Version := nil;
  FParam := nil;
//  frmVersion1.SaveCurrent := SaveCurrent.Checked;
  ClearOnlyControls;
end;

procedure TfrmParams.ClearOnlyControls;
begin
  cmplxFluidType.Clear;
  edtValue.Clear;
  edtNextValue.Clear;
  cmplxParam.Clear;
  chbxUseInterval.Checked := false;
end;

constructor TfrmParams.Create(AOwner: TComponent);
begin
  inherited;
  FCreatedCollection := TBaseCollection.Create(TBaseObject);
  FCreatedObject := FCreatedCollection.Add;

  NeedCopyState := false;
  FAction := TParamByVersionLoadAction.Create(Self);
  frmVersions1.Prepare(Versions, 'параметры', TOldParam, FAction);
  frmVersions1.OnAddSubElement := AddParam;
  frmVersions1.OnDeleteSubElement :=  DeleteParam;
  frmVersions1.OnAddVersion := AddVersion;
  frmVersions1.OnDeleteVersion := DeleteVersion;
  frmVersions1.OnViewChanged := ViewChange;
  frmVersions1.OnSaveVersion := OnSaveVersion;
  frmVersions1.OnSaveCurrentChecked := SaveCurrentChecked;
  frmVersions1.OnUndo := MakeUndo;
  frmVersions1.OnClear := MakeClear;



  cmplxFluidType.Caption := 'Тип флюида';
  cmplxFluidType.FullLoad := true;
  cmplxFluidType.DictName := 'TBL_FLUID_TYPE_DICT';

  cmplxParam.Caption := 'Наименование параметра';
  cmplxParam.FullLoad := true;
  cmplxParam.DictName := 'TBL_RRCOUNT_PARAM_DICT';


  cmplxReserveCategory.Caption := 'Категория запасов (ресурсов)';
  cmplxReserveCategory.FullLoad := true;
  cmplxReserveCategory.DictName := 'TBL_RESOURCES_CATEGORY_DICT';

  cmplxRelationship.Caption := 'Отношение';
  cmplxRelationship.FullLoad := true;
  cmplxRelationship.DictName := 'TBL_RELATIONSHIP_TYPE_DICT';
  //cmplxRelationship.AddItem(1, '=');

end;

procedure TfrmParams.FillControls(ABaseObject: TBaseObject);
var node: TTreeNode;
begin
  FVersions.Free;
  FVersions := nil;
  FTempObject := ABaseObject;

  ExecuteLoadAction;

  if frmVersions1.trw.Items.Count > 0 then
    frmVersions1.trw.Selected := frmVersions1.trw.Items[0];


  Node := frmVersions1.trw.Items.GetFirstNode;
  if Assigned(Node) then
    Node.Expand(true);

  FTempObject := nil;

  cmbxLicenseZone.Clear;
  cmbxLicenseZone.AddItem('<в целом по объекту(структуре/месторождению/продуктивному пласту/залежи)>', nil);
  Structure.LicenseZones.MakeList(cmbxLicenseZone.Items, true, false);
  cmbxLicenseZone.ItemIndex := 0;
end;

procedure TfrmParams.FillParentControls;
begin
  // по идее нужно указывать тот тип флюида, который задан для месторождения
  
end;

function TfrmParams.GetBed: TOldBed;
begin
  if EditingObject is TOldBed then
    Result := EditingObject as TOldBed
  else
  if Assigned(Layer) then
    Result := Layer.Bed
  else Result := nil;
end;

function TfrmParams.GetFirstAssignedObject: TBaseObject;
begin
  Result := nil;
  if Assigned(Layer) then
    Result := Layer
  else if Assigned(Substructure) then
    Result := Substructure
  else if Assigned(Bed) then
    Result := Bed
  else if Assigned(Horizon) then
    Result := Horizon
  else if Assigned(Structure) then
    Result := Structure;
end;

function TfrmParams.GetHorizon: TOldHorizon;
begin
  if EditingObject is TOldHorizon then
    Result := EditingObject as TOldHorizon
  else if EditingObject is TOldSubstructure then
    Result := Substructure.Horizon
  else Result := nil;
end;

function TfrmParams.GetLayer: TOldLayer;
begin
  if EditingObject is TOldLayer then
    Result := EditingObject as TOldLayer
  else Result := nil;
end;

function TfrmParams.GetStructure: TOldStructure;
begin
  if EditingObject is TOldStructure then
    Result := EditingObject as TOldStructure
  else if Assigned(Horizon) then
    Result := Horizon.Structure
  else if Assigned(Bed) then
    Result := Bed.Field
  else Result := nil;
end;

function TfrmParams.GetSubstructure: TOldSubstructure;
begin
  if EditingObject is TOldSubstructure then
    Result := EditingObject as TOldSubstructure
  else
  if EditingObject is TOldLayer then
    Result := Layer.Substructure
  else Result := nil;
end;

function TfrmParams.GetVersions: TOldAccountVersions;
var bo: TBaseObject;
begin
  if not Assigned(FVersions) then
  begin
    FVersions := TOldAccountVersions.Create(nil);

    if Assigned(Layer) then
    begin
      Result := Layer.Versions;
      bo := Layer;
    end
    else if Assigned(Substructure) then
    begin
      result := Substructure.Versions;
      bo := Substructure;
    end
    else if Assigned(Bed) then
    begin
      Result := Bed.Versions;
      bo := Bed;
    end
    else if Assigned(Horizon) then
    begin
      Result := Horizon.Versions;
      bo := Horizon;
    end
    else if Assigned(Structure) then
    begin
      Result := Structure.Versions;
      bo := Structure;
    end
    else if Assigned(TempStructure) then
    begin
      Result := TempStructure.Versions;
      bo := TempStructure;
    end
    else if Assigned(TempHorizon) then
    begin
      Result := TempHorizon.Versions;
      bo := TempHorizon;
    end
    else if Assigned(TempSubstructure) then
    begin
      Result := TempSubstructure.Versions;
      bo := TempSubstructure;
    end
    else if Assigned(TempLayer) then
    begin
      Result := TempLayer.Versions;
      bo := TempLayer;
    end
    else if Assigned(TempBed) then
    begin
      Result := TempBed.Versions;
      bo := TempBed;
    end
    else  Result := nil;

    if Assigned(Result) then
    begin
      FVersions.Assign(Result);
      FVersions.Owner := bo;
    end
    else FVersions.Owner := FCreatedObject;    
  end;
  Result := FVersions;
end;

procedure TfrmParams.Save;
var i: integer;
    actn: TBaseAction;
begin
  inherited;

  if Assigned(FVersions) then
  begin
    actn := TParamByVersionLoadAction.Create(Self);
    for i := 0 to FVersions.Count - 1 do
    begin
      if FVersions.Items[i].Parameters.NeedsUpdate then
        actn.Execute(FVersions.Items[i]);
      // копируем отсюда только параметры
      FVersions.Items[i].Resources.CopyCollection := false;
      FVersions.Items[i].Reserves.CopyCollection := false;
      FVersions.Items[i].Parameters.CopyCollection := true;
    end;

    actn.Free;

    if not Assigned(EditingObject) then
      // если что берем объект из предыдущего фрэйма
      FEditingObject := ((Owner as tDialogFrame).Frames[0] as TBaseFrame).EditingObject;

    // сохраняем
    if Assigned(Layer) then
    begin
      Layer.Versions.ParametersClear;
      Layer.Versions.AddItems(Versions)
    end
    else if Assigned(Substructure) then
    begin
      Substructure.Versions.ParametersClear;
      Substructure.Versions.AddItems(Versions)
    end
    else if Assigned(Bed) then
    begin
      Bed.Versions.ParametersClear;
      Bed.Versions.AddItems(Versions)
    end
    else if Assigned(Horizon) then
    begin
      Horizon.Versions.ParametersClear;
      Horizon.Versions.AddItems(Versions)
    end
    else if Assigned(Structure) then
    begin
      Structure.Versions.ParametersClear;
      Structure.Versions.AddItems(Versions);
    end;
  end;
end;

procedure TfrmParams.SaveParam;
begin
  if Assigned(Param) then
  begin
    Param.FluidTypeID := cmplxFluidType.SelectedElementID;
    Param.FluidType := cmplxFluidType.SelectedElementName;


    Param.ParamID := cmplxParam.SelectedElementID;
    Param.ParamName := cmplxParam.SelectedElementName;
    Param.ParamSign := GetObjectName((TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName['TBL_RRCOUNT_PARAM_DICT'].Dict, Param.ParamID, 3);

    Param.ParamTypeID := GetObjectName((TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName['TBL_RRCOUNT_PARAM_DICT'].Dict, Param.ParamID, 4);
    Param.ParamType := GetObjectName((TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName['TBL_RRCOUNT_PARAM_TYPE_DICT'].Dict, Param.ParamTypeID, 1);

    Param.ResourceCategoryID := cmplxReserveCategory.SelectedElementID;
    Param.ResourceCategory := cmplxReserveCategory.SelectedElementName;

    Param.RelationshipID := cmplxRelationship.SelectedElementID;
    Param.RelationshipName := cmplxRelationship.SelectedElementName;
    Param.IsRange := chbxUseInterval.Checked;

    try
      Param.Value := StrToFloatEx(edtValue.Text);
    except
      Param.Value := 0;
    end;

    if chbxUseInterval.Checked then
    try
      Param.NextValue := StrToFloatEx(edtNextValue.Text);
    except
      Param.NextValue := 0;
    end;


    if cmbxLicenseZone.ItemIndex > -1 then
      Param.LicenseZone := TLicenseZone(cmbxLicenseZone.Items.Objects[cmbxLicenseZone.ItemIndex])
    else
      Param.LicenseZone := nil;


    if TBaseObject(frmVersions1.trw.Selected.Data) is TOldParam then
      frmVersions1.trw.Selected.Text := Param.List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false);
  end;
end;


procedure TfrmParams.SetParam(const Value: TOldParam);
begin
  FParam := Value;
  if Assigned(Fparam) then
  begin
    cmplxParam.AddItem(FParam.ParamId, FParam.ParamName);

    if FParam.FluidTypeID > 0 then
      cmplxFluidType.AddItem(FParam.FluidTypeID, FParam.FluidType);

    if FParam.ResourceCategoryID > 0 then
      cmplxReserveCategory.AddItem(FParam.ResourceCategoryID, FParam.ResourceCategory);

    if FParam.RelationshipID > 0 then
      cmplxRelationship.AddItem(FParam.RelationshipID, FParam.RelationshipName);

    if Assigned(FParam.LicenseZone) then
      cmbxLicenseZone.ItemIndex := cmbxLicenseZone.Items.IndexOfObject(FParam.LicenseZone); 


    chbxUseInterval.Checked := FParam.IsRange;
    edtValue.Text := Trim(Format('%7.3f', [FParam.Value]));
    if FParam.IsRange then
      edtNextValue.Text := Trim(Format('%7.3f', [FParam.NextValue]))
    else
      edtNextValue.Clear;



    LocalRegisterInspector;
  end
  else ClearOnlyControls;
end;

procedure TfrmParams.ExecuteLoadAction;
var actn: TParamVersionLoadAction;
    Node: TTreeNode;
begin
  actn := TParamVersionLoadAction.Create(Self);

  if Assigned(Layer) then
    actn.Execute(Layer)
  else if Assigned(Substructure) then
    actn.Execute(Substructure)
  else if Assigned(Bed) then
    actn.Execute(Bed)
  else if Assigned(Horizon) then
    actn.Execute(Horizon)
  else if Assigned(Structure) then
    actn.Execute(Structure)
  else actn.Execute(FTempObject);


  Node := frmVersions1.trw.Items.GetFirstNode;
  if Assigned(Node) then
  begin
    Node.Selected := true;
    if Node.Level = 0 then
      frmVersions1.ElementLoadAction.Execute(TOldAccountVersion(Node.Data));
  end;

  actn.Free;
end;

{procedure TfrmParams.FindSelection(const ADocID, ATypeID,
  AParamID: integer);
var Node, Child, GrandChild: TTreeNode;
begin
  Node := frmVersions.trw.Items.GetFirstNode;

  while Assigned(Node) do
  begin
    // ищем документ который был выделен
    if TOldAccountVersion(Node.Data).UIN = ADocID then
    begin
      Node.Selected := true;
      // загружаем параметры для него
      Node.Expand(true);
      // ищем тип параметра который был выделен
      Child := Node.getFirstChild;

      while Assigned(Child) do
      begin
        if TValue(Child.Data).Value = ATypeID then
        begin
          // ищем параметр, который был выделен
          GrandChild := Child.GetFirstChild;
          while Assigned(GrandChild) do
          begin
            if TOldParam(GrandChild.Data).ParamID = AParamID then
            begin
              GrandChild.Selected := true;
              exit;
            end;
            GrandChild := Child.GetNextChild(GrandChild)
          end;
        end;
        Child := Node.GetNextChild(Child);
      end;
    end;
    Node := Node.GetNext;
  end;
  // до сюда вряд ли доберемся, просто на всякий случай
end;}

procedure TfrmParams.Arrange;
var iID, iTypeID, iDocID: integer;
    p: TOldParam;
begin
  // сохраняем выделенный элемент перегружаем дерево
  // чтобы переместить элемент в нужную категорию

{  if  Assigned(frmVersions1.trw.Selected)
  and (frmVersions1.trw.Selected.Level = 2) then
  begin
    p := TOldParam(frmVersions1.trw.Selected.Data);
    if TValue(frmVersions1.trw.Selected.Parent.Data).Value <> p.ParamTypeID then
    begin
      iID := p.ParamID;
      iTypeID := p.ParamTypeID;
      iDocID := ((p.Collection as TBaseCollection).Owner as TOldAccountVersion).UIN;

      ExecuteLoadAction;
      // восстанавливаем выделение
      frmVersions1.FindSelection(iDocID, iTypeID, iID);
    end;
  end;}
end;

procedure TfrmParams.RegisterInspector;
begin
  inherited;
end;

procedure TfrmParams.LocalRegisterInspector;
begin
  Inspector.Clear;
  // возвращаем исходное состояние
  // здесь не так как на других фрэймах
  // инспектор регистрится при добавлении нового параметра

  Inspector.Add(cmplxParam.cmbxName, nil, ptString, 'наименование параметра', false);
  Inspector.Add(cmplxFluidType.cmbxName, nil, ptString, 'тип флюида', false);
  Inspector.Add(cmplxReserveCategory.cmbxName, nil, ptString, 'наименование категории', false);
  Inspector.Add(edtValue, nil, ptFloat, 'значение параметра', false);
{  cmplxParam.cmbxName.OnChange := cmplxParamcmbxNameChange;
  cmplxFluidType.cmbxName.OnChange := cmplxFluidTypecmbxNameChange;
  cmplxFluidType.cmbxName.OnChange := cmplx}

  edtValue.OnChange := edtValueChange;

  Check;
end;

procedure TfrmParams.OnSaveVersion(Sender: TObject);
begin
end;

procedure TfrmParams.OnChangeVersion(Sender: TObject);
var v: TOldAccountVersion;
    Node: TTreeNode;
begin
  v := Versions.Items[Versions.Count - 1];

  Node := frmVersions1.trw.Items.AddObject(nil, v.List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false), v);
  Node.SelectedIndex := 10;
  //frmVersions1.trw.Items.AddChildObject(Node, '<без категории>', TValue.Create(0));

  Version := v;
  v.Parameters.NeedsUpdate := false;
end;

function TfrmParams.GetTempBed: TOldBed;
begin
  if Assigned(FTempObject) and (FTempObject is TOldBed) then
    Result := FTempObject as TOldBed
  else Result := nil;
end;

function TfrmParams.GetTempHorizon: TOldHorizon;
begin
  if Assigned(FTempObject) and (FTempObject is TOldHorizon) then
    Result := FTempObject as TOldHorizon
  else Result := nil;
end;

function TfrmParams.GetTempLayer: TOldLayer;
begin
  if Assigned(FTempObject) and (FTempObject is TOldLayer) then
    Result := FTempObject as TOldLayer
  else Result := nil;
end;

function TfrmParams.GetTempStructure: TOldStructure;
begin
  if Assigned(FTempObject) and (FTempObject is TOldStructure) then
    Result := FTempObject as TOldStructure
  else Result := nil;
end;

function TfrmParams.GetTempSubstructure: TOldSubstructure;
begin
  if Assigned(FTempObject) and (FTempObject is TOldSubstructure) then
    Result := FTempObject as TOldSubstructure
  else Result := nil;
end;

procedure TfrmParams.AddParam(Sender: TObject);
var p: TOldParam;
    Node: TTreeNode;
    i: integer;
begin
  p := Version.Parameters.Add;
  //p.FluidTypeID := Integer(cmplxFluidType.cmbxName.Items.Objects[0]);
  //p.FluidType := cmplxFluidType.cmbxName.Items[0];

  p.RelationshipID := Integer(cmplxRelationship.cmbxName.Items.Objects[2]);
  p.RelationshipName := cmplxRelationship.cmbxName.Items[2];



  if TObject(frmVersions1.trw.Selected.Data) is TOldParam then
     frmVersions1.trw.Selected.Parent.Selected := true;


  Node := frmVersions1.trw.Items.AddChildObject(frmVersions1.trw.Selected, p.List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false), p);
  frmVersions1.trw.Selected.Expand(true);
  frmVersions1.trw.Selected := nil;

  Node.SelectedIndex := 11;
  Node.Selected := true;

  LocalRegisterInspector;
  Param := p;

  i := frmVersions1.FindObject(Param);
  if i > -1 then
    frmVersions1.trw.Items[i].Selected := true;  
end;

procedure TfrmParams.DeleteParam(Sender: TObject);
var Node: TTreeNode;
begin
  Node := frmVersions1.trw.Selected.Parent;

  frmVersions1.Version.Parameters.Remove(TBaseObject(frmVersions1.trw.Selected.Data));
  frmVersions1.trw.Selected.Delete;
  Param := nil;
  frmVersions1.trw.Selected := nil;
  Node.Selected := true;
  // после этого происходит проверка,
  // результаты которой надо отменить
  UnCheck;
end;

procedure TfrmParams.AddVersion(Sender: TObject);
begin
  Version := frmVersions1.Version;
  Version.Parameters.NeedsUpdate := false;
end;

procedure TfrmParams.DeleteVersion(Sender: TObject);
begin
  Version := nil;
  frmVersions1.trw.Selected := nil; 
end;


procedure TfrmParams.SaveCurrentChecked(Sender: TObject);
begin
  SaveParam;
end;

procedure TfrmParams.MakeClear(Sender: TObject);
begin
  ClearOnlyControls;
end;

procedure TfrmParams.MakeUndo(Sender: TObject);
begin
end;

procedure TfrmParams.ViewChange(Sender: TObject);
begin
  Version := nil;
  Param := nil;

  ExecuteLoadAction;
end;

destructor TfrmParams.Destroy;
begin
  FCreatedCollection.Free;
  inherited;
end;

function TfrmParams.GetVersion: TOldAccountVersion;
begin
  Result := frmVersions1.Version;
end;

procedure TfrmParams.SetVersion(const Value: TOldAccountVersion);
begin
end;



function TfrmParams.Check: boolean;
var i: integer;
begin
  Result := inherited Check;

  if pnlParams.Visible then
  for i := 0 to Versions.Count - 1 do
    Result := Result and Versions.Items[i].Parameters.Check;
end;


{ TParamVersionLoadAction }

function TParamVersionLoadAction.Execute(
  ABaseObject: TBaseObject): boolean;
var node: TTreeNode;
    i: integer;
begin

  if Assigned(LastCollection) and LastCollection.NeedsUpdate then
    Result := inherited Execute(ABaseObject)
  else Result := true;

  if Result then
  begin
    // загружаем в интерфейс
    if Assigned(LastCollection) then
    with Owner as TfrmParams do
    begin
      // получаем версии на форму
      Versions;

      frmVersions1.trw.Items.BeginUpdate;
      frmVersions1.trw.Selected := nil;
      // чистим

      try
        frmVersions1.trw.Items.Clear;
      except

      end;


      // добавляем в дерево не реальные версии
      // а их копии, чтобы потом сохранять изменения
      for i := 0 to Versions.Count - 1 do
      begin
        if (((frmVersions1.cmbxView.ItemIndex = 0) and Versions.Items[i].ContainsParams)
        or  (frmVersions1.cmbxView.ItemIndex = 1)) then
        begin
          // загружаем только те в которых есть запасы
          Node := frmVersions1.trw.Items.AddObject(nil, Versions.Items[i].List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false), Versions.Items[i]);
          Node.SelectedIndex := 10;

          frmVersions1.trw.Items.AddChildObject(Node, 'Будут параметры', nil);
        end;
      end;

      frmVersions1.trw.Items.EndUpdate;
    end;
  end;
end;

function TParamVersionLoadAction.Execute(ABed: TOldBed): boolean;
var b: TBaseObject;
begin
  LastCollection := ABed.Versions;
  b := ABed as TbaseObject;
  Result := Execute(b);
end;

function TParamVersionLoadAction.Execute(AStructure: TOldStructure): boolean;
var b: TBaseObject;
begin
  LastCollection := AStructure.Versions;
  b := AStructure as TBaseObject;
  Result := Execute(b);
end;

function TParamVersionLoadAction.Execute(ALayer: TOldLayer): boolean;
var b: TBaseObject;
begin
  LastCollection := ALayer.Versions;
  b := ALayer as TBaseObject;
  Result := Execute(b);
end;

function TParamVersionLoadAction.Execute(AHorizon: TOldHorizon): boolean;
var b: TBaseObject;
begin
  LastCollection := AHorizon.Versions;
  b := AHorizon as TBaseObject;
  result := Execute(b);
end;

function TParamVersionLoadAction.Execute(
  ASubstructure: TOldSubstructure): boolean;
var b: TBaseObject;
begin
  LastCollection := (Asubstructure as TOldSubstructure).Versions;
  b := ASubstructure as TBaseObject;
  result := Execute(b);
end;

{function TParamVersionLoadAction.Execute: boolean;
begin
  with Owner as TfrmParams do
    LastCollection :=  Versions;
  result := Execute(TBaseObject(nil));
end;}

{ TParamByVersionLoadAction }

function TParamByVersionLoadAction.Execute(
  ABaseObject: TBaseObject): boolean;
var Node, ParentNode: TTreeNode;
    i: integer;
    p: TOldParam;
begin
   LastCollection := (ABaseObject as TOldAccountVersion).Parameters;
  if LastCollection.NeedsUpdate then
    Result := inherited Execute(ABaseObject)
  else Result := true;

  if Result then
  begin
    // загружаем в интерфейс
    if Assigned(LastCollection) then
    with Owner as TfrmParams do
    begin
      frmVersions1.trw.Items.BeginUpdate;
      (ABaseObject as TOldAccountVersion).ContainsParams := LastCollection.Count > 0;

      // загружаем уровень дерева
      // соответствующий самому параметру
      i := frmVersions1.FindObject(ABaseObject);
      if i > -1 then
      begin
        ParentNode := frmVersions1.trw.Items[i];
        ParentNode.DeleteChildren;
        for i := 0 to LastCollection.Count - 1 do
        begin
          p := LastCollection.Items[i] as TOldParam;


          Node := frmVersions1.trw.Items.AddChildObject(ParentNode, LastCollection.Items[i].List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false), LastCollection.Items[i]);
          Node.SelectedIndex  := 11;
        end;

        frmVersions1.trw.Items.EndUpdate;
      end;
    end;
  end;  
end;

procedure TfrmParams.trwParamsChange(Sender: TObject; Node: TTreeNode);
begin
  if Assigned(Node) then
  begin
    if TObject(Node.data) is TOldAccountVersion then
    begin
      Version := TBaseObject(Node.data) as TOldAccountVersion;
      pnlParams.Visible := false;
    end
    else
    if TObject(Node.data) is TOldParam then
    begin
      Version := TOldAccountVersion(Node.Parent.Data);
      Param := TBaseObject(Node.data) as TOldParam;
      pnlParams.Visible := true;
    end
  end;
end;

procedure TfrmParams.edtValueChange(Sender: TObject);
begin

end;


{ TValue }

procedure TfrmParams.trwParamsChanging(Sender: TObject; Node: TTreeNode;
  var AllowChange: Boolean);
begin
  if Assigned(frmVersions1.trw.Selected) and Assigned(Node) then
  begin
    if (frmVersions1.trw.Selected.Level = 2) then
      AllowChange := Check
  end;
end;

procedure TfrmParams.frmVersions1tlbtnAddReserveClick(Sender: TObject);
begin
  frmVersions1.AddSubElementExecute(Sender);

end;

procedure TfrmParams.frmVersions1AddSubElementExecute(Sender: TObject);
begin
  frmVersions1.AddSubElementExecute(Sender);

end;

procedure TfrmParams.btnSaveClick(Sender: TObject);
begin
  SaveParam;
end;


procedure TfrmParams.cmplxParamcmbxNameChange(Sender: TObject);
begin
  cmplxParam.cmbxNameChange(Sender);
  if frmVersions1.SaveCurrent.Checked then SaveParam;
  // перемещаем в другую категорию
  Arrange;
end;

procedure TfrmParams.cmplxFluidTypecmbxNameChange(Sender: TObject);
begin
  cmplxFluidType.cmbxNameChange(Sender);
  if frmVersions1.SaveCurrent.Checked then SaveParam;
end;

procedure TfrmParams.frmVersions1ToolButton2Click(Sender: TObject);
begin
  frmVersions1.ClearExecute(Sender);

end;

procedure TfrmParams.cmplxReserveCategorycmbxNameChange(Sender: TObject);
begin
  cmplxReserveCategory.cmbxNameChange(Sender);
  if frmVersions1.SaveCurrent.Checked then SaveParam;
end;

procedure TfrmParams.cmplxParamcmbxNameSelect(Sender: TObject);
begin
  cmplxParam.cmbxNameSelect(Sender);
  if frmVersions1.SaveCurrent.Checked then SaveParam;
end;

procedure TfrmParams.cmplxFluidTypecmbxNameSelect(Sender: TObject);
begin
  cmplxFluidType.cmbxNameSelect(Sender);
  if frmVersions1.SaveCurrent.Checked then SaveParam;
end;

procedure TfrmParams.cmplxReserveCategorycmbxNameSelect(Sender: TObject);
begin
  cmplxReserveCategory.cmbxNameSelect(Sender);
  if frmVersions1.SaveCurrent.Checked then SaveParam;
end;

procedure TfrmParams.frmVersions1tlbtnAddVersionClick(Sender: TObject);
begin
  frmVersions1.AddVersionExecute(Sender);

end;

procedure TfrmParams.cmplxReservesValueTypecmbxNameChange(Sender: TObject);
begin
  cmplxReservesValueType.cmbxNameChange(Sender);

end;

procedure TfrmParams.cmplxRelationshipcmbxNameChange(Sender: TObject);
begin
  cmplxRelationship.cmbxNameChange(Sender);

end;

procedure TfrmParams.chbxUseIntervalClick(Sender: TObject);
begin
  if not chbxUseInterval.Checked then
  begin
    lblValue.Caption := 'Значение';
    edtNextValue.Enabled := false;
    Inspector.RemoveByName('следующее значение параметра');
  end
  else
  begin
    lblValue.Caption := 'Значение в диапазоне от - до';
    edtNextValue.Enabled := True;
    Inspector.Add(edtNextValue, nil, ptFloat, 'следующее значение параметра', false);
  end;
end;

procedure TfrmParams.edtValueKeyPress(Sender: TObject; var Key: Char);
begin
  if frmVersions1.SaveCurrent.Checked then SaveParam;
end;

procedure TfrmParams.edtNextValueKeyPress(Sender: TObject; var Key: Char);
begin
  if frmVersions1.SaveCurrent.Checked then SaveParam;
end;

procedure TfrmParams.cmbxLicenseZoneChange(Sender: TObject);
var lz: TSimpleLicenseZone;
begin
  SaveParam;

  lz := nil;
  if cmbxLicenseZone.ItemIndex > -1 then
    lz := cmbxLicenseZone.Items.Objects[cmbxLicenseZone.ItemIndex] as TSimpleLicenseZone;

  if Assigned(lz) and Assigned(lz.OwnerOrganization) then
    lblOrganization.Caption := lz.OwnerOrganization.List
  else
    lblOrganization.Caption := '';
end;

end.

