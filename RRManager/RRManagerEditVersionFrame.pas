unit RRManagerEditVersionFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Mask, ToolEdit, CommonComplexCombo,
  RRManagerObjects, RRManagerBaseGUI, ComCtrls, ClientCommon
  {$IFDEF VER150}
  , Variants, Buttons, RRManagerBasketForm, ImgList, RRManagerBaseObjects
  {$ENDIF}
  ;
  

type
  TfrmVersion = class(TFrame)
    cmplxDocType: TfrmComplexCombo;
    Label2: TLabel;
    cmplxCreatorOrganization: TfrmComplexCombo;
    Bevel3: TBevel;
    Label3: TLabel;
    cmbxAuthors: TComboBox;
    Bevel2: TBevel;
    Label5: TLabel;
    dtedtAffirmationDate: TDateEdit;
    chbxAffirmed: TCheckBox;
    cmplxAffirmatorOrganization: TfrmComplexCombo;
    sbr: TStatusBar;
    cmbxDocName: TComboBox;
    cmplxVersion: TfrmComplexCombo;
    Label1: TLabel;
    dtedtCreationDate: TDateEdit;
    sbtnBasket: TSpeedButton;
    imgLst: TImageList;
    procedure cmplxVersioncmbxNameChange(Sender: TObject);
    procedure cmplxDocTypecmbxNameChange(Sender: TObject);
    procedure cmplxCreatorOrganizationcmbxNameChange(Sender: TObject);
    procedure cmplxAffirmatorOrganizationcmbxNameChange(Sender: TObject);
    procedure edtDocNameChange(Sender: TObject);
    procedure dtedtCreationDateChange(Sender: TObject);
    procedure cmbxAuthorsChange(Sender: TObject);
    procedure dtedtAffirmationDateChange(Sender: TObject);
    procedure cmbxDocNameChange(Sender: TObject);
    procedure sbtnBasketClick(Sender: TObject);
  private
    FVersion: TOldAccountVersion;
    FSaveCurrent: boolean;
    FInspector: THintManager;
    FOnSaveVersion: TNotifyEvent;
    FOnChangeVersion: TNotifyEvent;
    FLastGetFromBasket: TNotifyEvent;
    procedure SetVersion(const Value: TOldAccountVersion);
    procedure OnGetFormBasket(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
    procedure   SaveVersion;
    procedure   ClearControls;
    property    Inspector: THintManager read FInspector;
    procedure   RegisterInspector;
    property    Version: TOldAccountVersion read FVersion write SetVersion;
    property    SaveCurrent: boolean read FSaveCurrent write FSaveCurrent;
    property    OnSaveVersion: TNotifyEvent read FOnSaveVersion write FOnSaveVersion;
    property    OnChangeVersion: TNotifyEvent read FOnChangeVersion write FOnChangeVersion;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

implementation

uses RRManagerBasketFrame, Facade, BaseDicts;

{$R *.DFM}

{ TfrmVersion }

procedure TfrmVersion.ClearControls;
begin
  cmplxVersion.Clear;
  cmplxDocType.Clear;
  cmbxDocName.Text := '';

  cmplxCreatorOrganization.Clear;
  cmplxAffirmatorOrganization.Clear;

  cmbxAuthors.Text := '';
end;

constructor TfrmVersion.Create(AOwner: TComponent);
begin
  inherited;
  FOnChangeVersion := nil;
  FOnSaveVersion := nil;
  FInspector := THintManager.Create(sbr);

  cmplxVersion.Caption := 'Версия подсчета';
  cmplxVersion.FullLoad := true;
  cmplxVersion.DictName := 'TBL_COUNT_VERSION_DICT';

  cmplxDocType.Caption := 'Вид документа';
  cmplxDocType.FullLoad := true;
  cmplxDocType.DictName := 'TBL_COUNT_DOCUMENT_TYPE_DICT';

  cmplxCreatorOrganization.Caption := 'Организация-создатель документа';
  cmplxCreatorOrganization.DictName := 'TBL_ORGANIZATION_DICT';
  cmplxCreatorOrganization.FullLoad := false;

  cmplxAffirmatorOrganization.Caption := 'Организация, осуществившая подсчет';
  cmplxAffirmatorOrganization.DictName := 'TBL_ORGANIZATION_DICT';
  cmplxAffirmatorOrganization.FullLoad := false;


  (TMainFacade.GetInstance as TMainFacade).AllDicts.MakeList(cmbxAuthors.Items, (TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName['TBL_EMPLOYEE'].Dict);
  (TMainFacade.GetInstance as TMainFacade).AllDicts.MakeList(cmbxDocName.Items, (TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName['VW_COUNT_DOCUMENT'].Dict);

end;

procedure TfrmVersion.SaveVersion;
begin
  if Assigned(Version) then
  begin
    Version.VersionID := cmplxVersion.SelectedElementID;
    Version.Version := cmplxVersion.SelectedElementName;

    Version.DocTypeID := cmplxDocType.SelectedElementID;
    Version.DocType := cmplxDocType.SelectedElementName;

    Version.DocName := cmbxDocName.Text;

    Version.CreatorOrganizationID := cmplxCreatorOrganization.SelectedElementId;
    Version.CreatorOrganization := cmplxCreatorOrganization.SelectedElementName;

    Version.AffirmatorOrganizationID := cmplxAffirmatorOrganization.SelectedElementId;
    Version.AffirmatorOrganization := cmplxAffirmatorOrganization.SelectedElementName;


    Version.Authors := cmbxAuthors.Text;

    Version.AffirmationDate := dtedtAffirmationDate.Date;
    Version.CreationDate := dtedtCreationDate.Date;
    Version.Affirmed := chbxAffirmed.Checked;
  end;
end;

procedure TfrmVersion.SetVersion(const Value: TOldAccountVersion);
begin
  FVersion := Value;
  if Assigned(FVersion) then
  begin
    cmplxVersion.AddItem(FVersion.VersionID, FVersion.Version);
    cmplxDocType.AddItem(FVersion.DocTypeID, FVersion.DocType);
    cmplxCreatorOrganization.AddItem(FVersion.CreatorOrganizationID, FVersion.CreatorOrganization);
    cmplxAffirmatorOrganization.AddItem(FVersion.AffirmatorOrganizationID, FVersion.AffirmatorOrganization);
    cmbxDocName.Text := FVersion.DocName;

    dtedtCreationDate.Date := FVersion.CreationDate;
    dtedtAffirmationDate.Date := FVersion.AffirmationDate;

    cmbxAuthors.Text := FVersion.Authors;
    chbxAffirmed.Checked := FVersion.Affirmed;

    if not Assigned(frmBasketView) then frmBasketView := TfrmBasketView.Create(Self);

    sbtnBasket.Caption := 'Документов в буфере ' + IntToStr(frmBasketView.frmBasket.ActiveClassObjectsCount);
    Version.Accept(IConcreteVisitor(frmBasketView.frmBasket));
  end
  else ClearControls;
end;

procedure TfrmVersion.cmplxVersioncmbxNameChange(Sender: TObject);
begin
  cmplxVersion.cmbxNameChange(Sender);
  if SaveCurrent then SaveVersion;
end;

procedure TfrmVersion.cmplxDocTypecmbxNameChange(Sender: TObject);
begin
  cmplxDocType.cmbxNameChange(Sender);
  if SaveCurrent then SaveVersion;
end;

procedure TfrmVersion.cmplxCreatorOrganizationcmbxNameChange(
  Sender: TObject);
begin
  cmplxCreatorOrganization.cmbxNameChange(Sender);
  if SaveCurrent then SaveVersion;
end;

procedure TfrmVersion.cmplxAffirmatorOrganizationcmbxNameChange(
  Sender: TObject);
begin
  cmplxAffirmatorOrganization.cmbxNameChange(Sender);
  if SaveCurrent then SaveVersion;
end;

destructor TfrmVersion.Destroy;
begin
  FInspector.Free;
  inherited;
end;

procedure TfrmVersion.edtDocNameChange(Sender: TObject);
begin
  if SaveCurrent then SaveVersion;
end;

procedure TfrmVersion.dtedtCreationDateChange(Sender: TObject);
begin
  if SaveCurrent then SaveVersion;
end;

procedure TfrmVersion.cmbxAuthorsChange(Sender: TObject);
begin
  if SaveCurrent then SaveVersion;
end;

procedure TfrmVersion.dtedtAffirmationDateChange(Sender: TObject);
begin
  if SaveCurrent then SaveVersion;
end;

procedure TfrmVersion.cmbxDocNameChange(Sender: TObject);
var iDictElementID: integer;
    d: TDict;
    vElement: variant;
begin
  // делаем так, чтобы при выборе из списка
  // загружались все свойства того самого документа
  if cmbxDocName.ItemIndex > -1 then
  begin
    iDictElementID := Integer(cmbxDocName.Items.Objects[cmbxDocName.ItemIndex]);
    d := (TMainFacade.GetInstance as TMainFacade).AllDicts.DictByName['VW_COUNT_DOCUMENT'];
    vElement := GetObject(d.Dict, iDictElementID);
    // загрузка
        {
         0 DOCUMENT_ID,
         1 VCH_DOC_NAME,
         2 DOC_TYPE_ID,
         3 VCH_DOC_TYPE_NAME,
         4 CREATOR_ORGANIZATION_ID,
         5 VCH_CREATOR_ORG_FULL_NAME,
         6 VERSION_ID,
         7 VCH_VERSION_NAME,
         8 VCH_AUTHORS,
         9 DTM_CREATION_DATE,
         10 ORGANIZATION_ID,
         11 VCH_ORG_FULL_NAME,
         12 DTM_AFFIRMATION_DATE,
         13 NUM_AFFIRMED
        }

     cmplxDocType.AddItem(vElement[2], vElement[3]);

     cmplxCreatorOrganization.AddItem(vElement[4], vElement[5]);

     cmplxVersion.AddItem(vElement[6], vElement[7]);

     cmbxAuthors.Text := varAsType(vElement[8], varOleStr);
     dtedtCreationDate.Date := varAsType(vElement[9], varDate);

     cmplxAffirmatorOrganization.AddItem(vElement[10], vElement[11]);

     dtedtAffirmationDate.Date := varAsType(vElement[12], varDate);

     chbxAffirmed.Checked := varAsType(vElement[13], varInteger) > 0;

     if SaveCurrent then SaveVersion;

     if Assigned(FOnSaveVersion) then FOnSaveVersion(Self);
  end;
end;

procedure TfrmVersion.sbtnBasketClick(Sender: TObject);
var bmp: TBitmap;
begin
  //
  Version.Accept(IConcreteVisitor(frmBasketView.frmBasket));
  FLastGetFromBasket := frmBasketView.frmBasket.OnGetFromBasket;
  frmBasketView.frmBasket.OnGetFromBasket := OnGetFormBasket;
  
  FVersion.Parameters.CopyCollection := true;
  FVersion.Resources.CopyCollection := true;
  FVersion.Reserves.CopyCollection := true;

  if frmBasketView.ShowModal <> mrNone then
  begin
    // перерисовать дерево
    if frmBasketView.ModalResult = mrOK then if Assigned(FOnChangeVersion) then FOnChangeVersion(nil);
    sbtnBasket.Caption := 'Документов в буфере ' + IntToStr(frmBasketView.frmBasket.ActiveClassObjectsCount);

    if frmBasketView.frmBasket.ActiveClassObjectsCount > 0 then
    begin
      try
        bmp := TBitMap.Create;
        imgLst.GetBitmap(1, bmp);
        sbtnBasket.Glyph.Assign(bmp);
        bmp.Free;
      except

      end;
    end
    else
    begin
      try
        bmp := TBitMap.Create;
        imgLst.GetBitmap(0, bmp);
        sbtnBasket.Glyph.Assign(bmp);
        bmp.Free;
      except

      end;
    end;
  end;

  frmBasketView.frmBasket.OnGetFromBasket := FLastGetFromBasket;  
end;

procedure TfrmVersion.OnGetFormBasket(Sender: TObject);
var bo: TBaseObject;
begin
  bo := frmBasketView.frmBasket.PuttingObject.Collection.Add as TBaseObject;
  bo.Assign(frmBasketView.frmBasket.GettingObject);
  bo.ID := 0;
end;

procedure TfrmVersion.RegisterInspector;
begin
  FInspector.Clear; 
end;

end.
