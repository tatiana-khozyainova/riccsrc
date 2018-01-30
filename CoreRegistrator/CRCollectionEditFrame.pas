unit CRCollectionEditFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonIDObjectEditFrame, StdCtrls, ExtCtrls, ComCtrls,
  CoreCollection, BaseObjects;

type
  TfrmCollectionEditFrame = class(TfrmIDObjectEditFrame)
    cmbxCollectionType: TComboBox;
    cmbxFossilType: TComboBox;
    cmbxCollectionAuthor: TComboBox;
    cmbxCollectionOwner: TComboBox;
    cmbxTopStrat: TComboBox;
    cmbxBottomStrat: TComboBox;
    txtCollectionType: TStaticText;
    txtFossilType: TStaticText;
    txtStratigraphy: TStaticText;
    txtAuthorName: TStaticText;
    txtCollectionOwner: TStaticText;
    procedure cmbxCollectionTypeCloseUp(Sender: TObject);
  private
    { Private declarations }
    function getCoreCollection: TCoreCollection;
  protected
    procedure FillControls(ABaseObject: TIDObject); override;
    procedure ClearControls; override;
    procedure RegisterInspector; override;
  public
    { Public declarations }
    property CoreCollection: TCoreCollection read GetCoreCollection;
    procedure   Save(AObject: TIDObject = nil);  override;
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmCollectionEditFrame: TfrmCollectionEditFrame;

implementation

uses Facade, CommonFrame, Straton, Employee, BaseGUI, BaseConsts;

{$R *.dfm}

{ TfrmCollectionEditFrame }

procedure TfrmCollectionEditFrame.ClearControls;
begin
  inherited;
  edtName.Clear;
  cmbxCollectionType.ItemIndex := -1;
  cmbxFossilType.ItemIndex := -1;
  cmbxCollectionAuthor.Text := '';
  cmbxCollectionOwner.Text := '';
  cmbxTopStrat.ItemIndex := -1;
  cmbxBottomStrat.ItemIndex := -1;
end;

constructor TfrmCollectionEditFrame.Create(AOwner: TComponent);
begin
  inherited;
  EditingClass := TCoreCollection;

  ShowShortName := false;
  NeedsShadeEditing := false;
  
  (TMainFacade.GetInstance as TMainFacade).AllCollectionTypes.MakeList(cmbxCollectionType.Items, true, false);
  (TMainFacade.GetInstance as TMainFacade).AllFossilTypes.MakeList(cmbxFossilType.Items, true, false);
  TMainFacade.GetInstance.Employees.MakeList(cmbxCollectionAuthor.Items, True, false);
  TMainFacade.GetInstance.Employees.MakeList(cmbxCollectionOwner.Items, True, false);
  TMainFacade.GetInstance.AllSimpleStratons.MakeMainStratonList(cmbxTopStrat.Items, true, false);
  TMainFacade.GetInstance.AllSimpleStratons.MakeMainStratonList(cmbxBottomStrat.Items, true, false);
  //TMainFacade.GetInstance.AllSimpleStratons.MakeList(cmbxTopStrat.Items, true, false);
  //TMainFacade.GetInstance.AllSimpleStratons.MakeList(cmbxBottomStrat.Items, true, false);
end;

procedure TfrmCollectionEditFrame.FillControls(ABaseObject: TIDObject);
begin
  inherited;
  edtName.Text := CoreCollection.Name;
  cmbxCollectionType.ItemIndex :=  cmbxCollectionType.Items.IndexOfObject(CoreCollection.CoreCollectionType);
  cmbxFossilType.ItemIndex := cmbxFossilType.Items.IndexOfObject(CoreCollection.FossilType);
  cmbxCollectionAuthor.Text := CoreCollection.AuthorName;
  cmbxCollectionOwner.Text := CoreCollection.OwnerName;
  cmbxTopStrat.ItemIndex := cmbxTopStrat.Items.IndexOfObject(CoreCollection.TopStraton);
  cmbxBottomStrat.ItemIndex := cmbxBottomStrat.Items.IndexOfObject(CoreCollection.BaseStraton);
end;

function TfrmCollectionEditFrame.getCoreCollection: TCoreCollection;
begin
  result := IDObject as TCoreCollection;
end;

procedure TfrmCollectionEditFrame.RegisterInspector;
begin
  Inspector.Add(edtName, nil, ptString, 'название коллекции', false);
  Inspector.Add(cmbxCollectionType, nil, ptString, 'тип коллекции', false);
  Inspector.Add(cmbxTopStrat, nil, ptString, 'стратиграфическая привязка', false);
  Inspector.Add(cmbxCollectionAuthor, nil, ptString, 'автор коллекции', false);
  Inspector.Add(cmbxCollectionOwner, nil, ptString, 'владелец коллекции', False);
end;

procedure TfrmCollectionEditFrame.Save(AObject: TIDObject);
begin
  if not Assigned(FEditingObject) then
    FEditingObject := (TMainFacade.GetInstance as TMainFacade).AllCoreCollections.Add;

  CoreCollection.Name := edtName.Text;

  if cmbxCollectionType.ItemIndex > -1 then
    CoreCollection.CoreCollectionType := TCoreCollectionType(cmbxCollectionType.Items.Objects[cmbxCollectionType.ItemIndex])
  else
    CoreCollection.CoreCollectionType := nil;

  if cmbxFossilType.ItemIndex > -1 then
    CoreCollection.FossilType := TFossilType(cmbxFossilType.Items.Objects[cmbxFossilType.ItemIndex])
  else
    CoreCollection.FossilType := nil;

  if cmbxTopStrat.ItemIndex > -1 then
    CoreCollection.TopStraton := TSimpleStraton(cmbxTopStrat.Items.Objects[cmbxTopStrat.ItemIndex])
  else
    CoreCollection.TopStraton := nil;

  if cmbxBottomStrat.ItemIndex > -1 then
    CoreCollection.BaseStraton := TSimpleStraton(cmbxBottomStrat.Items.Objects[cmbxBottomStrat.ItemIndex])
  else
    CoreCollection.BaseStraton := nil;

  if cmbxCollectionAuthor.Items.IndexOf(cmbxCollectionAuthor.Text) > -1 then
    CoreCollection.AuthorEmp := TEmployee(cmbxCollectionAuthor.Items.Objects[cmbxCollectionAuthor.Items.IndexOf(cmbxCollectionAuthor.Text)])
  else
  begin
    CoreCollection.AuthorEmp := nil;
    CoreCollection.AuthorName := cmbxCollectionAuthor.Text;
  end;

  if cmbxCollectionOwner.Items.IndexOf(cmbxCollectionOwner.Text) > -1 then
    CoreCollection.AuthorEmp := TEmployee(cmbxCollectionOwner.Items.Objects[cmbxCollectionOwner.Items.IndexOf(cmbxCollectionOwner.Text)])
  else
  begin
    CoreCollection.AuthorEmp := nil;
    CoreCollection.AuthorName := cmbxCollectionOwner.Text;
  end;
end;

procedure TfrmCollectionEditFrame.cmbxCollectionTypeCloseUp(
  Sender: TObject);
begin
  inherited;
  if cmbxCollectionType.ItemIndex > -1 then
  begin
    cmbxFossilType.Enabled := TCoreCollectionType(cmbxCollectionType.Items.Objects[cmbxCollectionType.ItemIndex]).ID = PALEONTHOLOGIC_COLLECTION_ID;
    txtFossilType.Enabled :=  TCoreCollectionType(cmbxCollectionType.Items.Objects[cmbxCollectionType.ItemIndex]).ID = PALEONTHOLOGIC_COLLECTION_ID;
  end;
end;

end.
