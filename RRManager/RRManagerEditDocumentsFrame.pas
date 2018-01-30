unit RRManagerEditDocumentsFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ToolWin, ComCtrls, ExtCtrls, ToolEdit, Mask,
  CommonComplexCombo, RRManagerEditVersionFrame, ImgList, ActnList, RRManagerObjects,
  ClientCommon, RRManagerBaseGUI, RRManagerBaseObjects, FramesWizard,
  RRManagerVersionsFrame;

type
//  TfrmDocuments = class(TFrame)
  TfrmDocuments = class(TBaseFrame)
    pnlLeft: TPanel;
    gbxEditor: TGroupBox;
    pgctl: TPageControl;
    tshDocs: TTabSheet;
    frmVersions: TfrmVersions;
    pgctlDoc: TPageControl;
    tshComment: TTabSheet;
    mmComment: TMemo;
    tshCommonDocInfo: TTabSheet;
    gbxMaterial: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    edtMaterialName: TEdit;
    cmplxAuthors: TfrmComplexCombo;
    cmplxMaterialType: TfrmComplexCombo;
    dtEdtCreationDate: TDateEdit;
    cmplxTheme: TfrmComplexCombo;
    cmplxOrganization: TfrmComplexCombo;
    pnlFile: TPanel;
    Label3: TLabel;
    edtFileName: TFilenameEdit;
    cmplxMedium: TfrmComplexCombo;
    Label4: TLabel;
    procedure frmVersionstrwChange(Sender: TObject; Node: TTreeNode);
    procedure frmVersionstrwChanging(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure cmplxAuthorscmbxNameChange(Sender: TObject);
    procedure cmplxMaterialTypecmbxNameChange(Sender: TObject);
    procedure cmplxMediumcmbxNameChange(Sender: TObject);
    procedure cmplxThemecmbxNameChange(Sender: TObject);
    procedure cmplxOrganizationcmbxNameChange(Sender: TObject);
    procedure edtMaterialNameKeyPress(Sender: TObject; var Key: Char);
    procedure mmCommentKeyPress(Sender: TObject; var Key: Char);
    procedure edtFileNameAfterDialog(Sender: TObject; var Name: String;
      var Action: Boolean);
    procedure dtEdtCreationDateAcceptDate(Sender: TObject;
      var ADate: TDateTime; var Action: Boolean);
    procedure edtFileNameChange(Sender: TObject);
  private
    { Private declarations }
    FVersions: TOldAccountVersions;
    FTempObject: TBaseObject;
    FCreatedCollection: TBaseCollection;
    FCreatedObject: TBaseObject;
    FDocument: TOldDocument;
    FAction: TBaseAction;
    function  GetVersions: TOldAccountVersions;
    function  GetBed: TOldBed;
    function  GetHorizon: TOldHorizon;
    function  GetLayer: TOldLayer;
    function  GetStructure: TOldStructure;
    function  GetSubstructure: TOldSubstructure;
    function  GetTempBed: TOldBed;
    function  GetTempHorizon: TOldHorizon;
    function  GetTempLayer: TOldLayer;
    function  GetTempStructure: TOldStructure;
    function  GetTempSubstructure: TOldSubstructure;
    function  GetFirstAssignedObject: TBaseObject;
    procedure ExecuteLoadAction;
    procedure ClearOnlyControls;
    procedure SetDocument(const Value: TOldDocument);
    procedure SaveDocument;
    procedure OnSaveVersion(Sender: TObject);
    procedure OnChangeVersion(Sender: TObject);
    procedure AddDocument(Sender: TObject);
    procedure DeleteDocument(Sender: TObject);
    procedure AddVersion(Sender: TObject);
    procedure DeleteVersion(Sender: TObject);
    procedure SaveCurrentChecked(Sender: TObject);
    procedure MakeClear(Sender: TObject);
    procedure MakeUndo(Sender: TObject);
    procedure ViewChange(Sender: TObject);
    function GetVarsion: TOldAccountVersion;
    procedure SetVersion(const Value: TOldAccountVersion);
  protected
    procedure FillControls(ABaseObject: TBaseObject); override;
    procedure ClearControls; override;
    procedure FillParentControls; override;
    procedure RegisterInspector; override;
    procedure LocalRegisterInspector;
  public
    { Public declarations }
    property Versions: TOldAccountVersions read GetVersions;

    // документы могут принадлежать всему, чему только можно
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

    property Document: TOldDocument read FDocument write SetDocument;
    property Version: TOldAccountVersion read GetVarsion write SetVersion;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure   Save; override;
  end;

implementation

{$R *.dfm}
uses RRManagerLoaderCommands;

type

  TDocumentVersionLoadAction = class(TVersionBaseLoadAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; overload; override;
    function Execute(AStructure: TOldStructure): boolean; overload;
    function Execute(ABed: TOldBed): boolean; overload;
    function Execute(ALayer: TOldLayer): boolean; overload;
    function Execute(ASubstructure: TOldSubstructure): boolean; overload;
    function Execute(AHorizon: TOldHorizon): boolean; overload;
  end;

  TDocumentByVersionLoadAction = class(TDocumentByVersionBaseLoadAction)
  public
    function Execute(ABaseObject: TBaseObject): boolean; override;
  end;



procedure TfrmDocuments.AddDocument(Sender: TObject);
var d: TOldDocument;
    Node: TTreeNode;
begin
  d := Version.Documents.Add;


  Node := frmVersions.trw.Items.AddChildObject(frmVersions.trw.Selected, d.List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false), d);
  frmVersions.trw.Selected.Expand(true);
  frmVersions.trw.Selected := nil;

  Node.SelectedIndex := 11;
  Node.Selected := true;

  LocalRegisterInspector;
  Check;
  Document := d;
//  Node.Parent.Selected := true;
end;

procedure TfrmDocuments.AddVersion(Sender: TObject);
begin
  Version := frmVersions.Version;
  Version.Documents.NeedsUpdate := false;
end;

procedure TfrmDocuments.ClearControls;
begin
  FVersions.Free;
  FVersions := nil;
  Version := nil;
  FDocument := nil;
  ClearOnlyControls;
end;

procedure TfrmDocuments.ClearOnlyControls;
begin
  edtMaterialName.Clear;
  cmplxAuthors.Clear;
  cmplxMaterialType.Clear;
  cmplxTheme.Clear;
  cmplxOrganization.Clear;
  edtFileName.Clear;
  mmComment.Clear;
end;

constructor TfrmDocuments.Create(AOwner: TComponent);
begin
  inherited;
  NeedCopyState := false;
  FCreatedCollection := TBaseCollection.Create(TBaseObject);
  FCreatedObject := FCreatedCollection.Add as TBaseObject;

  FAction := TDocumentByVersionLoadAction.Create(Self);
  frmVersions.Prepare(Versions, 'документы', TOldDocument, FAction);
  frmVersions.OnAddSubElement := AddDocument;
  frmVersions.OnDeleteSubElement :=  DeleteDocument;
  frmVersions.OnAddVersion := AddVersion;
  frmVersions.OnDeleteVersion := DeleteVersion;
  frmVersions.OnViewChanged := ViewChange;
  frmVersions.OnSaveCurrentChecked := SaveCurrentChecked;
  frmVersions.OnSaveVersion := OnSaveVersion;
  frmVersions.OnUndo := MakeUndo;
  frmVersions.OnClear := MakeClear;




  cmplxAuthors.Caption := 'Авторы';
  cmplxAuthors.Style := csSimple;
  cmplxAuthors.FullLoad := false;
  cmplxAuthors.DictName := 'TBL_EMPLOYEE';

  cmplxMaterialType.Caption := 'Тип материала';
  cmplxMaterialType.FullLoad := true;
  cmplxMaterialType.DictName := 'TBL_MATERIAL_TYPE';

  cmplxMedium.Caption := 'Форма представления';
  cmplxMedium.FullLoad := true;
  cmplxMedium.DictName := 'TBL_MEDIUM';

  cmplxTheme.Caption := 'Тема';
  cmplxTheme.FullLoad := true;
  cmplxTheme.DictName := 'TBL_THEME';

  cmplxOrganization.Caption := 'Организация';
  cmplxOrganization.FullLoad := true;
  cmplxOrganization.DictName := 'TBL_ORGANIZATION_DICT';


  tshDocs.TabVisible := false;



end;

procedure TfrmDocuments.DeleteDocument(Sender: TObject);
var Node: TTreeNode;
begin
  Node := frmVersions.trw.Selected.Parent;
  TBaseObject(frmVersions.trw.Selected.Data).Free;
  frmVersions.trw.Selected.Delete;
  Document := nil;
  frmVersions.trw.Selected := nil;
  Node.Selected := true;
  // после этого происходит проверка,
  // результаты которой надо отменить
  UnCheck;
end;

procedure TfrmDocuments.DeleteVersion(Sender: TObject);
begin
  Version := nil;
end;

procedure TfrmDocuments.ExecuteLoadAction;
var actn: TDocumentVersionLoadAction;
begin
  actn := TDocumentVersionLoadAction.Create(Self);

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


  actn.Free;
end;

procedure TfrmDocuments.FillControls(ABaseObject: TBaseObject);
var node: TTreeNode;
begin
  FVersions.Free;
  FVersions := nil;
  FTempObject := ABaseObject;

  ExecuteLoadAction;
  if frmVersions.trw.Items.Count > 0 then
    frmVersions.trw.Selected := frmVersions.trw.Items[0];

  
  Node := frmVersions.trw.Items.GetFirstNode;
  if Assigned(Node) then
    Node.Expand(true);

  FTempObject := nil;     
end;

procedure TfrmDocuments.FillParentControls;
begin
end;

function TfrmDocuments.GetBed: TOldBed;
begin
  if EditingObject is TOldBed then
    Result := EditingObject as TOldBed
  else
  if Assigned(Layer) then
    Result := Layer.Bed
  else Result := nil;
end;

function TfrmDocuments.GetFirstAssignedObject: TBaseObject;
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

function TfrmDocuments.GetHorizon: TOldHorizon;
begin
  if EditingObject is TOldHorizon then
    Result := EditingObject as TOldHorizon
  else if EditingObject is TOldSubstructure then
    Result := Substructure.Horizon
  else Result := nil;
end;

function TfrmDocuments.GetLayer: TOldLayer;
begin
  if EditingObject is TOldLayer then
    Result := EditingObject as TOldLayer
  else Result := nil;
end;

function TfrmDocuments.GetStructure: TOldStructure;
begin
  if EditingObject is TOldStructure then
    Result := EditingObject as TOldStructure
  else if Assigned(Horizon) then
    Result := Horizon.Structure
  else if Assigned(Bed) then
    Result := Bed.Field
  else Result := nil;
end;

function TfrmDocuments.GetSubstructure: TOldSubstructure;
begin
  if EditingObject is TOldSubstructure then
    Result := EditingObject as TOldSubstructure
  else
  if EditingObject is TOldLayer then
    Result := Layer.Substructure
  else Result := nil;
end;

function TfrmDocuments.GetTempBed: TOldBed;
begin
  if Assigned(FTempObject) and (FTempObject is TOldBed) then
    Result := FTempObject as TOldBed
  else Result := nil;
end;

function TfrmDocuments.GetTempHorizon: TOldHorizon;
begin
  if Assigned(FTempObject) and (FTempObject is TOldHorizon) then
    Result := FTempObject as TOldHorizon
  else Result := nil;
end;

function TfrmDocuments.GetTempLayer: TOldLayer;
begin
  if Assigned(FTempObject) and (FTempObject is TOldLayer) then
    Result := FTempObject as TOldLayer
  else Result := nil;
end;

function TfrmDocuments.GetTempStructure: TOldStructure;
begin
  if Assigned(FTempObject) and (FTempObject is TOldStructure) then
    Result := FTempObject as TOldStructure
  else Result := nil;
end;

function TfrmDocuments.GetTempSubstructure: TOldSubstructure;
begin
  if Assigned(FTempObject) and (FTempObject is TOldSubstructure) then
    Result := FTempObject as TOldSubstructure
  else Result := nil;
end;

function TfrmDocuments.GetVersions: TOldAccountVersions;
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


{ TDocumentVersionLoadAction }

function TDocumentVersionLoadAction.Execute(ABed: TOldBed): boolean;
var b: TBaseObject;
begin
  LastCollection := ABed.Versions;
  b := ABed as TbaseObject;
  Result := Execute(b);
end;

function TDocumentVersionLoadAction.Execute(
  AStructure: TOldStructure): boolean;
var b: TBaseObject;
begin
  LastCollection := AStructure.Versions;
  b := AStructure as TBaseObject;
  Result := Execute(b);
end;

function TDocumentVersionLoadAction.Execute(
  ABaseObject: TBaseObject): boolean;
var i: integer;
    Node: TTreeNode;
begin
  if Assigned(LastCollection) and LastCollection.NeedsUpdate then
    Result := inherited Execute(ABaseObject)
  else Result := true;

  if Result then
  begin
    // загружаем в интерфейс
    if Assigned(LastCollection) then
    with Owner as TfrmDocuments do
    begin
      // получаем версии на форму
      Versions;

      frmVersions.trw.Items.BeginUpdate;
      frmVersions.trw.Selected := nil;
      // чистим

      try
        frmVersions.trw.Items.Clear;
      except

      end;


      // добавляем в дерево не реальные версии
      // а их копии, чтобы потом сохранять изменения
      for i := 0 to Versions.Count - 1 do
      begin
        if (((frmVersions.cmbxView.ItemIndex = 0) and Versions.Items[i].ContainsDocuments)
        or  (frmVersions.cmbxView.ItemIndex = 1)) then
        begin
          // загружаем только те в которых есть запасы
          Node := frmVersions.trw.Items.AddObject(nil, Versions.Items[i].List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false), Versions.Items[i]);
          Node.SelectedIndex := 10;

          //frmVersions.trw.Items.AddChildObject(Node, '<без категории>', TValue.Create(0));
        end;
      end;

      frmVersions.trw.Items.EndUpdate;
    end;
  end;
end;

function TDocumentVersionLoadAction.Execute(AHorizon: TOldHorizon): boolean;
var b: TBaseObject;
begin
  LastCollection := AHorizon.Versions;
  b := AHorizon as TBaseObject;
  result := Execute(b);
end;

function TDocumentVersionLoadAction.Execute(
  ASubstructure: TOldSubstructure): boolean;
var b: TBaseObject;
begin
  LastCollection := (Asubstructure as TOldSubstructure).Versions;
  b := ASubstructure as TBaseObject;
  result := Execute(b);
end;

function TDocumentVersionLoadAction.Execute(ALayer: TOldLayer): boolean;
var b: TBaseObject;
begin
  LastCollection := ALayer.Versions;
  b := ALayer as TBaseObject;
  Result := Execute(b);
end;

procedure TfrmDocuments.LocalRegisterInspector;
begin
  Inspector.Clear;
  // возвращаем исходное состояние
  // здесь не так как на других фрэймах
  // инспектор регистрится при добавлении нового параметра
  cmplxAuthors.cmbxName.OnChange := cmplxAuthorscmbxNameChange;
  cmplxMaterialType.cmbxName.OnChange := cmplxMaterialTypecmbxNameChange;
  cmplxTheme.cmbxName.OnChange := cmplxThemecmbxNameChange;
  cmplxOrganization.cmbxName.OnChange := cmplxOrganizationcmbxNameChange;
  cmplxMedium.cmbxName.OnChange := cmplxMediumcmbxNameChange;


  Inspector.Add(edtMaterialName, nil, ptString, 'название документа', false);
  Inspector.Add(cmplxAuthors.cmbxName, nil, ptString, 'авторы документа', false);
  Inspector.Add(cmplxMaterialType.cmbxName, nil, ptString, 'тип материала', false);
  Inspector.Add(cmplxTheme.cmbxName, nil, ptString, 'название темы', false);
  Inspector.Add(cmplxMedium.cmbxName, nil, ptString, 'форма представления', false);  
  Inspector.Add(edtFileName, nil, ptString, 'путь к файлу', false);
end;

procedure TfrmDocuments.MakeClear(Sender: TObject);
begin
  ClearOnlyControls;
end;

procedure TfrmDocuments.MakeUndo(Sender: TObject);
begin
  with pgctl do
  case ActivePageIndex of
  0:
  begin
    Version := nil;
    Version := TOldAccountVersion(frmVersions.trw.Selected.Data);
  end;
  1:
  begin
    Document := nil;
    Document := TOldDocument(frmVersions.trw.Selected.Data);
  end;
  end;
end;

procedure TfrmDocuments.OnChangeVersion(Sender: TObject);
var v: TOldAccountVersion;
    Node: TTreeNode;
begin
  v := Versions.Items[Versions.Count - 1];

  Node := frmVersions.trw.Items.AddObject(nil, v.List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false), v);
  Node.SelectedIndex := 10;
  //frmVersions.trw.Items.AddChildObject(Node, '<без категории>', TValue.Create(0));

  Version := v;
  v.Documents.NeedsUpdate := false;
end;

procedure TfrmDocuments.OnSaveVersion(Sender: TObject);
begin
end;

procedure TfrmDocuments.RegisterInspector;
begin
  inherited;

end;

procedure TfrmDocuments.Save;
var i: integer;
    actn: TBaseAction;
begin
  inherited;


  if Assigned(FVersions) then
  begin
    actn := TDocumentByVersionLoadAction.Create(Self);
    for i := 0 to FVersions.Count - 1 do
    begin
      if FVersions.Items[i].Parameters.NeedsUpdate then
        actn.Execute(FVersions.Items[i]);
      // копируем отсюда только параметры
      FVersions.Items[i].Resources.CopyCollection := false;
      FVersions.Items[i].Reserves.CopyCollection := false;
      FVersions.Items[i].Parameters.CopyCollection := false;
      FVersions.Items[i].Documents.CopyCollection := true;
    end;

    actn.Free;

    if not Assigned(EditingObject) then
      // если что берем объект из предыдущего фрэйма
      FEditingObject := ((Owner as TDialogFrame).Frames[0] as TBaseFrame).EditingObject;

    // сохраняем
    if Assigned(Layer) then
      Layer.Versions.AddItems(Versions)
    else if Assigned(Substructure) then
      Substructure.Versions.AddItems(Versions)
    else if Assigned(Bed) then
      Bed.Versions.AddItems(Versions)
    else if Assigned(Horizon) then
      Horizon.Versions.AddItems(Versions)
    else if Assigned(Structure) then
      Structure.Versions.AddItems(Versions);
  end;
end;

procedure TfrmDocuments.SaveCurrentChecked(Sender: TObject);
begin
  SaveDocument;
end;

procedure TfrmDocuments.SaveDocument;
begin
  if Assigned(Document) then
  begin
    Document.DocName := edtMaterialName.Text;
    Document.Authors := cmplxAuthors.cmbxName.Text;
    Document.CreationDate := dtEdtCreationDate.Date;
    Document.PreLocation := edtFileName.Text;
    Document.Comment := mmComment.Text;

    Document.ThemeID := cmplxTheme.SelectedElementID;
    Document.ThemeName := cmplxTheme.SelectedElementName;

    Document.OrganizationID := cmplxOrganization.SelectedElementID;
    Document.OrganizationName := cmplxOrganization.SelectedElementName;

    Document.MediumID := cmplxMedium.SelectedElementID;
    Document.MediumName := cmplxMedium.SelectedElementName;

    Document.MaterialTypeID := cmplxMaterialType.SelectedElementID;
    Document.MaterialType := cmplxMaterialType.SelectedElementName;

    if TBaseObject(frmVersions.trw.Selected.Data) is TOldDocument then
      frmVersions.trw.Selected.Text := Document.List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false);
  end;
end;

procedure TfrmDocuments.SetDocument(const Value: TOldDocument);
begin
  FDocument := Value;
  if Assigned(FDocument) then
  begin
    LocalRegisterInspector;      

    cmplxMaterialType.AddItem(FDocument.MaterialTypeID, FDocument.MaterialType);
    cmplxTheme.AddItem(FDocument.ThemeID, FDocument.ThemeName);
    cmplxOrganization.AddItem(FDocument.OrganizationID, FDocument.OrganizationName);
    cmplxMedium.AddItem(FDocument.MediumID, FDocument.MediumName);

    dtEdtCreationDate.Date := FDocument.CreationDate;
    edtMaterialName.Text := FDocument.DocName;
    edtFileName.Text := FDocument.PreLocation;
    cmplxAuthors.Text := FDocument.Authors;
    pgctlDoc.ActivePageIndex := 0;
  end
  else ClearOnlyControls;
end;

procedure TfrmDocuments.ViewChange(Sender: TObject);
begin
  Version := nil;
  Document := nil;

  ExecuteLoadAction;
end;

procedure TfrmDocuments.frmVersionstrwChange(Sender: TObject;
  Node: TTreeNode);
begin
  if Assigned(Node) then
  begin
    if TBaseObject(Node.data) is TOldAccountVersion then
    begin
      Version := TBaseObject(Node.data) as TOldAccountVersion;
      tshDocs.TabVisible := false;
    end
    else
    if TBaseObject(Node.data) is TOldDocument then
    begin
      Version := TBaseObject(Node.Parent.data) as TOldAccountVersion;
      Document := TBaseObject(Node.data) as TOldDocument;
      tshDocs.TabVisible := true;
    end;
  end;
end;

procedure TfrmDocuments.frmVersionstrwChanging(Sender: TObject;
  Node: TTreeNode; var AllowChange: Boolean);
begin
  if Assigned(frmVersions.trw.Selected) and Assigned(Node) then
  begin
    if (frmVersions.trw.Selected.Level = 1) then
      AllowChange := Check
  end;
end;

{ TDocumentByVersionLoadAction }

function TDocumentByVersionLoadAction.Execute(
  ABaseObject: TBaseObject): boolean;
var ParentNode, Node: TTreeNode;
    i: integer;  
begin
  LastCollection := (ABaseObject as TOldAccountVersion).Documents;
  if LastCollection.NeedsUpdate then
    Result := inherited Execute(ABaseObject)
  else Result := true;

  if Result then
  begin
    // загружаем в интерфейс
    if Assigned(LastCollection) then
    with Owner as TfrmDocuments do
    begin
      frmVersions.trw.Items.BeginUpdate;

      // чистим
      if Assigned(frmVersions.trw.Selected) then
      begin
        if (TBaseObject(frmVersions.trw.Selected.Data) is TOldAccountVersion) then
           ParentNode := frmVersions.trw.Selected
        else
           ParentNode := frmVersions.trw.Selected.Parent;


        Node := ParentNode.getFirstChild;
        while Assigned(Node) do
        begin
          Node.Delete;
          Node := ParentNode.getFirstChild;
        end;

        // добавляем
        (ABaseObject as TOldAccountVersion).ContainsDocuments := LastCollection.Count > 0;
        for i := 0 to LastCollection.Count - 1 do
        begin
          Node := frmVersions.trw.Items.AddChildObject(ParentNode, LastCollection.Items[i].List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false), LastCollection.Items[i]);
          Node.SelectedIndex  := 11;
        end;
      end;

      frmVersions.trw.Items.EndUpdate;
    end;
  end;
end;

procedure TfrmDocuments.cmplxAuthorscmbxNameChange(Sender: TObject);
begin
  cmplxAuthors.cmbxNameChange(Sender);
  if frmVersions.SaveCurrent.Checked then SaveDocument;
end;

procedure TfrmDocuments.cmplxMaterialTypecmbxNameChange(Sender: TObject);
begin
  cmplxMaterialType.cmbxNameChange(Sender);
  if frmVersions.SaveCurrent.Checked then SaveDocument;
end;

procedure TfrmDocuments.cmplxMediumcmbxNameChange(Sender: TObject);
begin
  cmplxMedium.cmbxNameChange(Sender);
  if frmVersions.SaveCurrent.Checked then SaveDocument;
end;

procedure TfrmDocuments.cmplxThemecmbxNameChange(Sender: TObject);
begin
  cmplxTheme.cmbxNameChange(Sender);
  if frmVersions.SaveCurrent.Checked then SaveDocument;
end;

procedure TfrmDocuments.cmplxOrganizationcmbxNameChange(Sender: TObject);
begin
  cmplxOrganization.cmbxNameChange(Sender);
  if frmVersions.SaveCurrent.Checked then SaveDocument;
end;

procedure TfrmDocuments.edtMaterialNameKeyPress(Sender: TObject;
  var Key: Char);
begin
  if frmVersions.SaveCurrent.Checked then SaveDocument;
end;

procedure TfrmDocuments.mmCommentKeyPress(Sender: TObject; var Key: Char);
begin
  if frmVersions.SaveCurrent.Checked then SaveDocument;
end;

procedure TfrmDocuments.edtFileNameAfterDialog(Sender: TObject;
  var Name: String; var Action: Boolean);
begin
  if frmVersions.SaveCurrent.Checked then SaveDocument;
  Document.PreLocation := Name;
end;

procedure TfrmDocuments.dtEdtCreationDateAcceptDate(Sender: TObject;
  var ADate: TDateTime; var Action: Boolean);
begin
  if frmVersions.SaveCurrent.Checked then SaveDocument;
end;

procedure TfrmDocuments.edtFileNameChange(Sender: TObject);
begin
  Check;
end;

destructor TfrmDocuments.Destroy;
begin
  FCreatedCollection.Free;
  inherited;
end;

function TfrmDocuments.GetVarsion: TOldAccountVersion;
begin
end;

procedure TfrmDocuments.SetVersion(const Value: TOldAccountVersion);
begin
end;

end.
