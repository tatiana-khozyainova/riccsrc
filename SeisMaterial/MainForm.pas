unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,ShellAPI,
  Dialogs, CommonObjectSelectFilter, ComCtrls, ToolWin, ImgList, ActnList,
  Menus, FrameTestGridView, FrameSeisMateralList, FormEditSeisMaterial, FormReports,
  SeisMaterial, SeisExemple,SeisProfile,Material, Structure, Table, FormEvent,
  FormEditProfile, FormEditExemple;

type
  TfrmMain = class(TForm)
    frmObjectSelect: TfrmObjectSelect;
    MainMnu: TMainMenu;
    Start: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    nDicts: TMenuItem;
    N5: TMenuItem;
    N10: TMenuItem;
    N4: TMenuItem;
    actnLst: TActionList;
    actnTryConnect: TAction;
    actnCloseMainForm: TAction;
    actnHelp: TAction;
    actnEditSimpleDicts: TAction;
    imgLst: TImageList;
    ToolBar: TToolBar;
    ToolButton2: TToolButton;
    ToolButton1: TToolButton;
    ToolButton6: TToolButton;
    ToolButton8: TToolButton;
    ToolButton4: TToolButton;
    actnSeisMethod: TAction;
    actnSeisType: TAction;
    actnProfileType: TAction;
    actnSeisCrew: TAction;
    actnExempleType: TAction;
    actnElementType: TAction;
    actnSeisType1: TMenuItem;
    actnSeisCrew1: TMenuItem;
    actnProfileType1: TMenuItem;
    actnExempleType1: TMenuItem;
    actnElementType1: TMenuItem;
    actnMatLocation: TAction;
    actnMatLocation1: TMenuItem;
    frmSeisMaterialList1: TFrame2;
    Frame11: TFrame1;
    btnAddMaterial: TToolButton;
    actAddMaterial: TAction;
    actOpenList: TAction;
    actSelectList: TAction;
    actAddProfile: TAction;
    btn1: TToolButton;
    btnAddProfile: TToolButton;
    btn2: TToolButton;
    btnReports: TToolButton;
    actReports: TAction;
    pmSelectSeisMatList: TPopupMenu;
    H1: TMenuItem;
    actEditSelectList: TAction;
    btn3: TToolButton;
    btn4: TToolButton;
    btn5: TToolButton;
    btnAddExemple: TToolButton;
    actAddExemple: TAction;
    procedure actAddExempleExecute(Sender: TObject);
    procedure actnTryConnectExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure actnSeisMethodExecute(Sender: TObject);
    procedure actnSeisTypeExecute(Sender: TObject);
    procedure actnProfileTypeExecute(Sender: TObject);
    procedure actnSeisCrewExecute(Sender: TObject);
    procedure actnExempleTypeExecute(Sender: TObject);
    procedure actnElementTypeExecute(Sender: TObject);
    procedure actnMatLocationExecute(Sender: TObject);
    procedure actnExempleLocExecute(Sender: TObject);
    procedure actAddMaterialExecute(Sender: TObject);
    procedure actAddProfileExecute(Sender: TObject);
    procedure actEditSelectListExecute(Sender: TObject);
    procedure actnCloseMainFormExecute(Sender: TObject);
    procedure actOpenListExecute(Sender: TObject);
    procedure actReportsExecute(Sender: TObject);
    procedure actSelectListExecute(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure frmSeisMaterialList1tvSeisMaterialMouseDown(Sender: TObject; Button:
        TMouseButton; Shift: TShiftState; X, Y: Integer);

    procedure ListShortLine(Lw:TListView;LItem:TListItem;Str:String);

  private
    { Private declarations }
  public
    { Public declarations }
    procedure   ReloadData(Sender: TObject);
    procedure EventReload(Sender: TObject);
    constructor Create(AOwner: TComponent); override;

  end;

var
  frmMain: TfrmMain;

implementation

uses PasswordForm, Facade, FormSeisDict, CommonFilterContentForm;

{$R *.dfm}

procedure TfrmMain.actnTryConnectExecute(Sender: TObject);
begin
  if TMainFacade.GetInstance.Authorize then
  begin
    TMainFacade.GetInstance.DBGates.FetchPriorities(actnLst);
    frmObjectSelect.Prepare;
  end;
end;

constructor TfrmMain.Create(AOwner: TComponent);
begin
  inherited;
  (TMainFacade.GetInstance as TMainFacade).Filter := '';
  frmObjectSelect.OnReloadData := ReloadData;
end;

procedure TfrmMain.actAddExempleExecute(Sender: TObject);
begin
frmEditExemple := TfrmEditExemple.Create(Self);
frmEditExemple.OnMyEvent:=actOpenListExecute;
  with frmEditExemple do
  begin
   //забиваем данные в контроллеры на фреймах
   TMainFacade.GetInstance.AllSimpleDocuments.MakeList(frmEditExemple.frmEditSMExemple.cbbSelectMaterial.Items);
   TMainFacade.GetInstance.AllExempleTypes.MakeList(frmEditExemple.frmEditSMExemple.cbbTypeExemple.Items);
   TMainFacade.GetInstance.AllElementTypes.MakeList(frmEditExemple.frmEditSMExemple.cbbTypeElement.Items);
   TMainFacade.GetInstance.AllExempleLocations.MakeList(frmEditExemple.frmEditSMExemple.cbbLocExemple.Items);

   Caption := 'Редактирование экземпляров отчета';

  end;

  frmEditExemple.ShowModal;
  frmEditExemple.Free;
end;



procedure TfrmMain.ReloadData(Sender: TObject);
begin
  // здесь перезагружаем куда следует, что следует
  TMainFacade.GetInstance.Filter := frmObjectSelect.SQL;
  TMainFacade.GetInstance.SkipSimpleDocuments;
  actOpenListExecute(Self);
end;

procedure TfrmMain.FormActivate(Sender: TObject);
begin
  frmMain.WindowState:=wsMaximized;
  frmSeisMaterialList1.pbLoadDict.Max:=22;
  frmSeisMaterialList1.pbLoadDict.Position:=1;
  if not TMainFacade.GetInstance.DBGates.Autorized then actnTryConnect.Execute;
  //TMainFacade.GetInstance.AllSeisWorkMethods;
  //TMainFacade.GetInstance.AllSeisWorkTypes;
  ActivateKeyboardLayout(68748313, 0); //rus
  //ActivateKeyboardLayout(67699721, 0); //eng
  frmSeisMaterialList1.pbLoadDict.Position:=frmSeisMaterialList1.pbLoadDict.Position+1;
  TMainFacade.GetInstance.AllSimpleDocuments;
  frmSeisMaterialList1.pbLoadDict.Position:=frmSeisMaterialList1.pbLoadDict.Position+1;
   TMainFacade.GetInstance.AllOrganizations;
   frmSeisMaterialList1.pbLoadDict.Position:=frmSeisMaterialList1.pbLoadDict.Position+1;
   TMainFacade.GetInstance.AllMaterialLocations;
   frmSeisMaterialList1.pbLoadDict.Position:=frmSeisMaterialList1.pbLoadDict.Position+1;
   TMainFacade.GetInstance.AllEmployees;
   frmSeisMaterialList1.pbLoadDict.Position:=frmSeisMaterialList1.pbLoadDict.Position+1;
   TMainFacade.GetInstance.AllEmployeeOuts;
   frmSeisMaterialList1.pbLoadDict.Position:=frmSeisMaterialList1.pbLoadDict.Position+1;
   TMainFacade.GetInstance.AllSeisWorkTypes;
   frmSeisMaterialList1.pbLoadDict.Position:=frmSeisMaterialList1.pbLoadDict.Position+1;
   TMainFacade.GetInstance.AllSeisWorkMethods;
   frmSeisMaterialList1.pbLoadDict.Position:=frmSeisMaterialList1.pbLoadDict.Position+1;
   TMainFacade.GetInstance.AllSeisCrews;
   frmSeisMaterialList1.pbLoadDict.Position:=frmSeisMaterialList1.pbLoadDict.Position+1;
   TMainFacade.GetInstance.AllExempleTypes;
   frmSeisMaterialList1.pbLoadDict.Position:=frmSeisMaterialList1.pbLoadDict.Position+1;
   TMainFacade.GetInstance.AllElementTypes;
   frmSeisMaterialList1.pbLoadDict.Position:=frmSeisMaterialList1.pbLoadDict.Position+1;
   TMainFacade.GetInstance.AllExempleLocations;
   frmSeisMaterialList1.pbLoadDict.Position:=frmSeisMaterialList1.pbLoadDict.Position+1;
   TMainFacade.GetInstance.ALLSeismicProfiles;
   frmSeisMaterialList1.pbLoadDict.Position:=frmSeisMaterialList1.pbLoadDict.Position+1;
   TMainFacade.GetInstance.AllObjectBindTypes;
   frmSeisMaterialList1.pbLoadDict.Position:=frmSeisMaterialList1.pbLoadDict.Position+1;
   TMainFacade.GetInstance.AllObjectBindMaterialTypes;
   frmSeisMaterialList1.pbLoadDict.Position:=frmSeisMaterialList1.pbLoadDict.Position+1;
   TMainFacade.GetInstance.AllMaterialBindings;
   frmSeisMaterialList1.pbLoadDict.Position:=frmSeisMaterialList1.pbLoadDict.Position+1;
   //TMainFacade.GetInstance.AllSeismicMaterials;
   //frmSeisMaterialList1.pbLoadDict.Position:=frmSeisMaterialList1.pbLoadDict.Position+1;
   TMainFacade.GetInstance.ALLExempleSeismicMaterials;
   frmSeisMaterialList1.pbLoadDict.Position:=frmSeisMaterialList1.pbLoadDict.Position+1;
   TMainFacade.GetInstance.ALLElementExemples;
   frmSeisMaterialList1.pbLoadDict.Position:=frmSeisMaterialList1.pbLoadDict.Position+1;
   //TMainFacade.GetInstance.AllMaterialAuthors;
   //frmSeisMaterialList1.pbLoadDict.Position:=frmSeisMaterialList1.pbLoadDict.Position+1;
   TMainFacade.GetInstance.DocumentTypes;
   frmSeisMaterialList1.pbLoadDict.Position:=frmSeisMaterialList1.pbLoadDict.Position+1;
   actOpenListExecute(Self.frmSeisMaterialList1);
   frmSeisMaterialList1.pbLoadDict.Position:=frmSeisMaterialList1.pbLoadDict.Position+1;
   frmSeisMaterialList1.pbLoadDict.Visible:=false;
end;



procedure TfrmMain.actnSeisMethodExecute(Sender: TObject);
begin
frmSeisDict := TfrmSeisDict.Create(Self);
frmSeisDict.flags:=1;//определает какой справочник открывается
  with frmSeisDict do
  begin
   TMainFacade.GetInstance.AllSeisWorkMethods.MakeList(frmSeisDict.lvSeisDict.Items);
    Caption := 'Справочник "Метод сейс.работ"';
  end;

  frmSeisDict.ShowModal;
  frmSeisDict.Free;
end;

procedure TfrmMain.actnSeisTypeExecute(Sender: TObject);
begin
frmSeisDict := TfrmSeisDict.Create(Self);
frmSeisDict.flags:=2;
  with frmSeisDict do
  begin
   TMainFacade.GetInstance.AllSeisWorkTypes.MakeList(frmSeisDict.lvSeisDict.Items);
    Caption := 'Справочник "Тип сейс.работ"';
  end;
  frmSeisDict.ShowModal;
  frmSeisDict.Free;
end;

procedure TfrmMain.actnProfileTypeExecute(Sender: TObject);
begin
frmSeisDict := TfrmSeisDict.Create(Self);
frmSeisDict.flags:=4;
  with frmSeisDict do
  begin
   TMainFacade.GetInstance.AllSeismicProfileTypes.MakeList(frmSeisDict.lvSeisDict.Items);
    Caption := 'Справочник "Тип сейс.профиля"';
  end;
  frmSeisDict.ShowModal;
  frmSeisDict.Free;
end;

procedure TfrmMain.actnSeisCrewExecute(Sender: TObject);
begin
frmSeisDict := TfrmSeisDict.Create(Self);
frmSeisDict.flags:=3;
  with frmSeisDict do
  begin

   TMainFacade.GetInstance.AllSeisCrews.MakeList(frmSeisDict.lvSeisDict.Items);
   Caption := 'Справочник "Сейсмопартия"';
  end;

  frmSeisDict.ShowModal;
  frmSeisDict.Free;
end;

procedure TfrmMain.actnExempleTypeExecute(Sender: TObject);
begin
frmSeisDict := TfrmSeisDict.Create(Self);
frmSeisDict.flags:=5;
  with frmSeisDict do
  begin
   TMainFacade.GetInstance.AllExempleTypes.MakeList(frmSeisDict.lvSeisDict.Items);
    Caption := 'Справочник "Тип экземпляра отчета"';
  end;

  frmSeisDict.ShowModal;
  frmSeisDict.Free;
end;

procedure TfrmMain.actnElementTypeExecute(Sender: TObject);
begin
frmSeisDict := TfrmSeisDict.Create(Self);
frmSeisDict.flags:=6;
  with frmSeisDict do
  begin
   TMainFacade.GetInstance.AllElementTypes.MakeList(frmSeisDict.lvSeisDict.Items);
    Caption := 'Справочник "Тип элемента экземпляра"';
  end;

  frmSeisDict.ShowModal;
  frmSeisDict.Free;
end;

procedure TfrmMain.actnMatLocationExecute(Sender: TObject);
begin
frmSeisDict := TfrmSeisDict.Create(Self);
frmSeisDict.flags:=7;
  with frmSeisDict do
  begin
   TMainFacade.GetInstance.AllMaterialLocations.MakeList(frmSeisDict.lvSeisDict.Items);
    Caption := 'Справочник "Место хранения материала"';
  end;

  frmSeisDict.ShowModal;
  frmSeisDict.Free;
end;



procedure TfrmMain.actnExempleLocExecute(Sender: TObject);
begin
frmSeisDict := TfrmSeisDict.Create(Self);
frmSeisDict.flags:=7;
  with frmSeisDict do
  begin
   TMainFacade.GetInstance.AllExempleLocations.MakeList(frmSeisDict.lvSeisDict.Items);
    Caption := 'Справочник "Место хранения материала"';
  end;

  frmSeisDict.ShowModal;
  frmSeisDict.Free;
end;





procedure TfrmMain.actAddMaterialExecute(Sender: TObject);
var i,j,o:Integer;
begin
frmSMEdit := TfrmSMEdit.Create(Self);
frmSMEdit.OnMyEvent:=actOpenListExecute;

  with frmSMEdit do
  begin
   //забиваем данные в контроллеры на фреймах
   TMainFacade.GetInstance.AllSimpleDocuments.MakeList(frmSMEdit.frmEditSMSimpleDocument.cbbSelectMaterial.Items);
   TMainFacade.GetInstance.AllSimpleDocuments.MakeList(frmSMEdit.frmEditSMMaterialBind.cbbSelectMaterial.Items);
   TMainFacade.GetInstance.AllSimpleDocuments.MakeList(frmSMEdit.frmEditSMSeisMaterial.cbbSelectMaterial.Items);
   TMainFacade.GetInstance.AllSimpleDocuments.MakeList(frmSMEdit.frmEditSMExemple.cbbSelectMaterial.Items);
   TMainFacade.GetInstance.AllOrganizations.MakeList(frmSMEdit.frmEditSMSimpleDocument.cbbOrganization.Items);
   TMainFacade.GetInstance.AllMaterialLocations.MakeList(frmSMEdit.frmEditSMSimpleDocument.cbbLocation.Items);
   TMainFacade.GetInstance.AllEmployees.MakeList(frmSMEdit.frmEditSMSimpleDocument.chklstAuthorOurs.Items);
   TMainFacade.GetInstance.AllEmployeeOuts.MakeList(frmSMEdit.frmEditSMSimpleDocument.chklstAuthorOutsides.Items);
   TMainFacade.GetInstance.AllSeisWorkTypes.MakeList(frmSMEdit.frmEditSMSeisMaterial.cbbTypeWorks.Items);
   TMainFacade.GetInstance.AllSeisWorkMethods.MakeList(frmSMEdit.frmEditSMSeisMaterial.cbbMethodWorks.Items);
   TMainFacade.GetInstance.AllSeisCrews.MakeList(frmSMEdit.frmEditSMSeisMaterial.cbbSeisCrews.Items);
   TMainFacade.GetInstance.AllExempleTypes.MakeList(frmSMEdit.frmEditSMExemple.cbbTypeExemple.Items);
   TMainFacade.GetInstance.AllElementTypes.MakeList(frmSMEdit.frmEditSMExemple.cbbTypeElement.Items);
   TMainFacade.GetInstance.AllExempleLocations.MakeList(frmSMEdit.frmEditSMExemple.cbbLocExemple.Items);
   //забиваем только профили не имеющие привязки к отчету
   for i:=0 to TMainFacade.GetInstance.ALLSeismicProfiles.Count-1 do
   if (not Assigned(TMainFacade.GetInstance.ALLSeismicProfiles.Items[i].SeismicMaterial)) then
   frmSMEdit.frmEditSMSeisMaterial.cbbProfile.Items.AddObject(TMainFacade.GetInstance.ALLSeismicProfiles.Items[i].List,TMainFacade.GetInstance.ALLSeismicProfiles.Items[i] as TSeismicProfile);
   //забиваем только те типы привязок, которые соответствуют типу материала(можно короче если указать сразу тип ИД=70)
   for i:=0 to TMainFacade.GetInstance.AllObjectBindTypes.Count-1 do
   for j:=0 to TMainFacade.GetInstance.AllObjectBindMaterialTypes.Count-1 do
   if (TMainFacade.GetInstance.AllObjectBindTypes.Items[i].ID=TMainFacade.GetInstance.AllObjectBindMaterialTypes.Items[j].ObjectBindType.ID) then
   begin
   frmSMEdit.frmEditSMMaterialBind.lstMaterialBind.Items.AddObject(TMainFacade.GetInstance.AllObjectBindTypes.Items[i].List, TMainFacade.GetInstance.AllObjectBindTypes.Items[i]);
   end;
   Caption := 'Редактирование отчета о сейсморазведочных работах';
   //прячем 2 и 3-й шаги на форме
   frmEditSMMaterialBind.Visible:=False;
   frmEditSMSeisMaterial.Visible:=False;
   frmEditSMExemple.Visible:=False;
  end;

  if (Sender is TSimpleDocument) then
  for i:=0 to frmSMEdit.frmEditSMSimpleDocument.cbbSelectMaterial.Items.Count-1 do
  if (frmSMEdit.frmEditSMSimpleDocument.cbbSelectMaterial.Items.Objects[i] as TSimpleDocument).ID=(Sender as TSimpleDocument).ID then
  begin
  frmSMEdit.frmEditSMSimpleDocument.Refresh;
  frmSMEdit.frmEditSMSimpleDocument.cbbSelectMaterial.ItemIndex:=i;
  frmSMEdit.frmEditSMSeisMaterial.cbbSelectMaterial.ItemIndex:=i;
  frmSMEdit.frmEditSMMaterialBind.cbbSelectMaterial.ItemIndex:=i;
  frmSMEdit.frmEditSMExemple.cbbSelectMaterial.ItemIndex:=i;
  Break;
  end;


  frmSMEdit.ShowModal;
  frmSMEdit.Free;

end;

procedure TfrmMain.actAddProfileExecute(Sender: TObject);
var i,j,o:Integer;
begin
frmEditProfile := TfrmEditProfile.Create(Self);
frmEditProfile.OnMyEvent:=actOpenListExecute;
  with frmEditProfile do
  begin
   //забиваем данные в контроллеры на фреймах
   TMainFacade.GetInstance.AllSeismicMaterials.MakeList(frmEditProfile.frmEditAllProfile.cbbSeisMaterial.Items);
   TMainFacade.GetInstance.AllSeismicProfileTypes.MakeList(frmEditProfile.frmEditAllProfile.cbbTypeProfile.Items);
   for i:=0 to TMainFacade.GetInstance.ALLSeismicProfiles.Count-1 do
   if (not Assigned(TMainFacade.GetInstance.ALLSeismicProfiles.Items[i].SeismicMaterial)) then
   frmEditProfile.frmEditAllProfile.cbbSelectProfile.Items.AddObject(TMainFacade.GetInstance.ALLSeismicProfiles.Items[i].List,TMainFacade.GetInstance.ALLSeismicProfiles.Items[i] as TSeismicProfile);


   Caption := 'Редактирование сейсмических профилей';

  end;

  frmEditProfile.ShowModal;
  frmEditProfile.Free;
end;

procedure TfrmMain.actEditSelectListExecute(Sender: TObject);
var Node:TTreeNode;
begin
Node:=frmSeisMaterialList1.tvSeisMaterial.Selected;
if  TObject(frmSeisMaterialList1.tvSeisMaterial.Selected.Data) is TSimpleDocument then
actAddMaterialExecute(TObject(frmSeisMaterialList1.tvSeisMaterial.Selected.Data))
else
begin
Repeat
Node:=Node.Parent;
Until (TObject(Node.Data) is  TSimpleDocument);
frmSeisMaterialList1.tvSeisMaterial.Selected:=Node;
actAddMaterialExecute(TObject(frmSeisMaterialList1.tvSeisMaterial.Selected.Data));
end;
end;

procedure TfrmMain.actnCloseMainFormExecute(Sender: TObject);
begin
frmMain.Close;
end;

procedure TfrmMain.actOpenListExecute(Sender: TObject);
var i0,i1,i2,i3,step1,step2,step3:Integer;
begin
step1:=-1;
step2:=-1;
step3:=-1;
with frmSeisMaterialList1 do
begin
lvSeisMaterialProperty.Clear;
tvSeisMaterial.Items.Clear;
tvSeisMaterial.Items.BeginUpdate;
tvSeisMaterial.Items.Add(nil,'Отчеты сейсморазведочных работ');//делаем корень


  for i0:=0 to TMainFacade.GetInstance.AllSimpleDocuments.Count-1 do
  begin
    //if (TMainFacade.GetInstance.AllSimpleDocuments.Items[i0].DocType.ID=70) then
    //begin
    tvSeisMaterial.Items.AddChildObject(tvSeisMaterial.Items.Item[0],IntToStr(TMainFacade.GetInstance.AllSimpleDocuments.Items[i0].InventNumber)+' '+TMainFacade.GetInstance.AllSimpleDocuments.Items[i0].Name,TMainFacade.GetInstance.AllSimpleDocuments.Items[i0]);

    Inc(step1);
    tvSeisMaterial.Items.Item[0].Item[step1].ImageIndex:=7;
    tvSeisMaterial.Items.Item[0].Item[step1].SelectedIndex:=7;
      for i1:=0 to TMainFacade.GetInstance.AllSeismicMaterials.Count-1 do
      begin
      if (TMainFacade.GetInstance.AllSeismicMaterials.Items[i1].SimpleDocument.ID=TMainFacade.GetInstance.AllSimpleDocuments.Items[i0].ID) then
        begin
        tvSeisMaterial.Items.AddChildObject(tvSeisMaterial.Items.Item[0].Item[step1],'Подробно',TMainFacade.GetInstance.AllSeismicMaterials.Items[i1]);
        tvSeisMaterial.Items.Item[0].Item[step1].Item[0].ImageIndex:=12;
        tvSeisMaterial.Items.Item[0].Item[step1].Item[0].SelectedIndex:=12;
          tvSeisMaterial.Items.AddChild(tvSeisMaterial.Items.Item[0].Item[step1].Item[0],'Сейсмопрофиля');
          tvSeisMaterial.Items.Item[0].Item[step1].Item[0].Item[0].ImageIndex:=19;
          tvSeisMaterial.Items.Item[0].Item[step1].Item[0].Item[0].SelectedIndex:=19;
          tvSeisMaterial.Items.AddChild(tvSeisMaterial.Items.Item[0].Item[step1].Item[0],'Экземпляры отчета');
          tvSeisMaterial.Items.Item[0].Item[step1].Item[0].Item[1].ImageIndex:=3;
          tvSeisMaterial.Items.Item[0].Item[step1].Item[0].Item[1].SelectedIndex:=3;

          for i2:=0 to TMainFacade.GetInstance.ALLSeismicProfiles.Count-1 do
          if Assigned(TMainFacade.GetInstance.ALLSeismicProfiles.Items[i2].SeismicMaterial) then
          if (TMainFacade.GetInstance.ALLSeismicProfiles.Items[i2].SeismicMaterial.ID=TMainFacade.GetInstance.AllSeismicMaterials.Items[i1].ID) then
            begin
            inc(step2);
            tvSeisMaterial.Items.AddChildObject(tvSeisMaterial.Items.Item[0].Item[step1].Item[0].Item[0],'№'+IntToStr(TMainFacade.GetInstance.ALLSeismicProfiles.Items[i2].SeisProfileNumber),TMainFacade.GetInstance.ALLSeismicProfiles.Items[i2]);
            tvSeisMaterial.Items.Item[0].Item[step1].Item[0].Item[0].Item[step2].ImageIndex:=-1;
            tvSeisMaterial.Items.Item[0].Item[step1].Item[0].Item[0].Item[step2].SelectedIndex:=-1;
           // tvSeisMaterial.Items.AddChild(tvSeisMaterial.Items.Item[0].Item[step1].Item[0].Item[0].Item[step2],'Координаты');

           // for i3:=0 to TMainFacade.GetInstance.AllSeismicProfileCoordinates.Count-1 do
           // if (TMainFacade.GetInstance.AllSeismicProfileCoordinates.Items[i3].SeismicProfile.ID=TMainFacade.GetInstance.ALLSeismicProfiles.Items[i2].ID) then
           // tvSeisMaterial.Items.AddChildObject(tvSeisMaterial.Items.Item[0].Item[step1].Item[0].Item[0].Item[step2].Item[0],'№'+IntToStr(TMainFacade.GetInstance.AllSeismicProfileCoordinates.Items[i3].CoordNumber)+' X:'+FloatToStr(TMainFacade.GetInstance.AllSeismicProfileCoordinates.Items[i3].CoordX)+' Y:'+FloatToStr(TMainFacade.GetInstance.AllSeismicProfileCoordinates.Items[i3].CoordY),TMainFacade.GetInstance.AllSeismicProfileCoordinates.Items[i3]);
            end;
          step2:=-1;//обнуляем порядок номеров листьев для нового корня

          for i2:=0 to TMainFacade.GetInstance.ALLExempleSeismicMaterials.Count-1 do
          if (TMainFacade.GetInstance.ALLExempleSeismicMaterials.Items[i2].SeismicMaterial.ID=TMainFacade.GetInstance.AllSeismicMaterials.Items[i1].ID) then
            begin
            inc(step2);
            tvSeisMaterial.Items.AddChildObject(tvSeisMaterial.Items.Item[0].Item[step1].Item[0].Item[1],'№'+IntToStr(TMainFacade.GetInstance.ALLExempleSeismicMaterials.Items[i2].ID)+' '+TMainFacade.GetInstance.ALLExempleSeismicMaterials.Items[i2].ExempleType.Name,TMainFacade.GetInstance.ALLExempleSeismicMaterials.Items[i2]);
            tvSeisMaterial.Items.Item[0].Item[step1].Item[0].Item[1].Item[step2].ImageIndex:=-1;
            tvSeisMaterial.Items.Item[0].Item[step1].Item[0].Item[1].Item[step2].SelectedIndex:=-1;
            tvSeisMaterial.Items.AddChild(tvSeisMaterial.Items.Item[0].Item[step1].Item[0].Item[1].Item[step2],'Элементы экземпляра');
            tvSeisMaterial.Items.Item[0].Item[step1].Item[0].Item[1].Item[step2].Item[0].ImageIndex:=8;
            tvSeisMaterial.Items.Item[0].Item[step1].Item[0].Item[1].Item[step2].Item[0].SelectedIndex:=8;
            for i3:=0 to TMainFacade.GetInstance.ALLElementExemples.Count-1 do
            if (TMainFacade.GetInstance.ALLElementExemples.Items[i3].ExempleSeismicMaterial.ID=TMainFacade.GetInstance.ALLExempleSeismicMaterials.Items[i2].ID) then
            begin
            inc(step3);
            tvSeisMaterial.Items.AddChildObject(tvSeisMaterial.Items.Item[0].Item[step1].Item[0].Item[1].Item[step2].Item[0],'№'+IntToStr(TMainFacade.GetInstance.ALLElementExemples.Items[i3].ElementNumber)+' '+TMainFacade.GetInstance.ALLElementExemples.Items[i3].ElementType.Name,TMainFacade.GetInstance.ALLElementExemples.Items[i3]);
            tvSeisMaterial.Items.Item[0].Item[step1].Item[0].Item[1].Item[step2].Item[0].Item[step3].ImageIndex:=-1;
            tvSeisMaterial.Items.Item[0].Item[step1].Item[0].Item[1].Item[step2].Item[0].Item[step3].SelectedIndex:=-1;
            end;
            step3:=-1;
            end;
          step2:=-1;//обнуляем порядок номеров листьев для нового корня
        end;
      //end;
    end;
  end;

  //открываем все узлы, а затем закрываем все кроме корневого
  tvSeisMaterial.Items.Item[0].Expand(true);
  for i0:=0 to TMainFacade.GetInstance.AllSimpleDocuments.Count-1 do
  begin
  tvSeisMaterial.Items.Item[0].Item[i0].Collapse(true);
  end;
  tvSeisMaterial.Items.EndUpdate;
  end;
end;

procedure TfrmMain.actReportsExecute(Sender: TObject);
var i,j,o:Integer;
begin

frmReports := TfrmReports.Create(Self);
frmReports.frmReportsAtrtribute.Flag:=1;
frmReports.frmReportsAtrtribute.AddList();
frmReports.OnMyEvent:=actOpenListExecute;
frmReports.frmReportsView.Visible:=False;
frmReports.frmReportsAtrtribute.Refresh;
frmReports.frmbjctslct.Refresh;

  frmReports.ShowModal;

  frmReports.Free;
end;

procedure TfrmMain.actSelectListExecute(Sender: TObject);
var ListItem:TListItem;Column:TListColumn;
i3:Integer;
begin
//lvSeisMaterialProperty.Items.BeginUpdate;

with frmSeisMaterialList1 do
begin
lvSeisMaterialProperty.Clear;
ListItem:=TListItem.Create(lvSeisMaterialProperty.Items);//создаем Items  для ListView
if TObject(tvSeisMaterial.Selected.Data) is TSimpleDocument then //если в дереве выбран лист "материал"
begin
//далее выводим информацию из объекта записанного в TreeView
//цвет строк зависит от того заполнено поле DATA в ListView или нет(обработчик на фрейме)
lvSeisMaterialProperty.Items.BeginUpdate;
 lvSeisMaterialProperty.Column[0].Caption:='Сейсмический отчет';
 ListItem:=lvSeisMaterialProperty.Items.Add;
 ListItem.Caption:='Инвентарный номер';
ListShortLine(lvSeisMaterialProperty,ListItem,IntToStr((TObject(tvSeisMaterial.Selected.Data) as TSimpleDocument).InventNumber));
ListItem:=lvSeisMaterialProperty.Items.Add;
 ListItem.Caption:='Номер ТГФ';
ListShortLine(lvSeisMaterialProperty,ListItem,IntToStr((TObject(tvSeisMaterial.Selected.Data) as TSimpleDocument).TGFNumber));
ListItem:=lvSeisMaterialProperty.Items.Add;
 ListItem.Caption:='Название отчета';
ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TSimpleDocument).Name);
ListItem:=lvSeisMaterialProperty.Items.Add;
 ListItem.Caption:='Дата создания отчета';
ListShortLine(lvSeisMaterialProperty,ListItem,DateToStr((TObject(tvSeisMaterial.Selected.Data) as TSimpleDocument).CreationDate));
ListItem:=lvSeisMaterialProperty.Items.Add;
 ListItem.Caption:='Авторы отчета';
ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TSimpleDocument).Authors);
ListItem:=lvSeisMaterialProperty.Items.Add;
 ListItem.Caption:='Привязки отчета';
ListShortLine(lvSeisMaterialProperty,ListItem,AnsiLowerCase((TObject(tvSeisMaterial.Selected.Data) as TSimpleDocument).Bindings));
ListItem:=lvSeisMaterialProperty.Items.Add;
 ListItem.Caption:='Организация-заказчик';
if not Assigned((TObject(tvSeisMaterial.Selected.Data) as TSimpleDocument).Organization) then
ListShortLine(lvSeisMaterialProperty,ListItem,'<нет данных>')
else ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TSimpleDocument).Organization.Name);
ListItem:=lvSeisMaterialProperty.Items.Add;
ListItem.Caption:='Местонахождение отчета';
if not Assigned((TObject(tvSeisMaterial.Selected.Data) as TSimpleDocument).MaterialLocation) then
ListShortLine(lvSeisMaterialProperty,ListItem,'<нет данных>')
else ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TSimpleDocument).MaterialLocation.Name);
ListItem:=lvSeisMaterialProperty.Items.Add;
 ListItem.Caption:='Комментарий';
ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TSimpleDocument).MaterialComment);
ListItem:=lvSeisMaterialProperty.Items.Add;
 ListItem.Caption:='Сотрудник внесший отчет';
if not Assigned((TObject(tvSeisMaterial.Selected.Data) as TSimpleDocument).Employee) then
ListShortLine(lvSeisMaterialProperty,ListItem,'<нет данных>')
else ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TSimpleDocument).Employee.Name);
ListItem:=lvSeisMaterialProperty.Items.Add;
 ListItem.Caption:='Дата внесения отчета';
ListShortLine(lvSeisMaterialProperty,ListItem,DateToStr((TObject(tvSeisMaterial.Selected.Data) as TSimpleDocument).EnteringDate));

lvSeisMaterialProperty.Items.EndUpdate;
end
else
if TObject(tvSeisMaterial.Selected.Data) is TSeismicMaterial then
begin
 lvSeisMaterialProperty.Items.BeginUpdate;
 lvSeisMaterialProperty.Column[0].Caption:='Сейсмический материал(подробно)';
 ListItem:=lvSeisMaterialProperty.Items.Add;
 ListItem.Caption:='№Сейсмопартии';
ListShortLine(lvSeisMaterialProperty,ListItem,IntToStr((TObject(tvSeisMaterial.Selected.Data) as TSeismicMaterial).SeisCrew.SeisCrewNumber));
 ListItem:=lvSeisMaterialProperty.Items.Add;
 ListItem.Caption:='Метод сейсморазведочных работ:';
ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TSeismicMaterial).SeisWorkMethod.Name);
 ListItem:=lvSeisMaterialProperty.Items.Add;
 ListItem.Caption:='Тип сейсморазведочных работ:';
ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TSeismicMaterial).SeisWorkType.Name);
 ListItem:=lvSeisMaterialProperty.Items.Add;
 ListItem.Caption:='Дата начала работ:';
ListShortLine(lvSeisMaterialProperty,ListItem,DateToStr((TObject(tvSeisMaterial.Selected.Data) as TSeismicMaterial).BeginWorksDate));
 ListItem:=lvSeisMaterialProperty.Items.Add;
 ListItem.Caption:='Дата окончания работ:';
ListShortLine(lvSeisMaterialProperty,ListItem,DateToStr((TObject(tvSeisMaterial.Selected.Data) as TSeismicMaterial).EndWorksDate));
 ListItem:=lvSeisMaterialProperty.Items.Add;
 ListItem.Caption:='Состав отчета:';
ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TSeismicMaterial).ReferenceComposition);
 ListItem:=lvSeisMaterialProperty.Items.Add;
 ListItem.Caption:='Масштаб работ:';
 ListShortLine(lvSeisMaterialProperty,ListItem,'1 : '+IntToStr((TObject(tvSeisMaterial.Selected.Data) as TSeismicMaterial).SeisWorkScale));
 ListItem:=lvSeisMaterialProperty.Items.Add;
 ListItem.Caption:='Структурная карта ОГ:';
ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TSeismicMaterial).StructMapReflectHorizon);
 ListItem:=lvSeisMaterialProperty.Items.Add;
 ListItem.Caption:='Разломы:';
 ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TSeismicMaterial).CrossSection);
 lvSeisMaterialProperty.Items.EndUpdate;
end
else
if TObject(tvSeisMaterial.Selected.Data) is TSeismicProfile then
begin
lvSeisMaterialProperty.Items.BeginUpdate;
lvSeisMaterialProperty.Column[0].Caption:='Сейсмический профиль';
ListItem:=lvSeisMaterialProperty.Items.Add;
ListItem.Caption:='№Сейсмопрофиля';
ListShortLine(lvSeisMaterialProperty,ListItem,IntToStr((TObject(tvSeisMaterial.Selected.Data) as TSeismicProfile).SeisProfileNumber));
ListItem:=lvSeisMaterialProperty.Items.Add;
ListItem.Caption:='Тип сейсмопрофиля';
ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TSeismicProfile).SeismicProfileType.Name);
ListItem:=lvSeisMaterialProperty.Items.Add;
ListItem.Caption:='Начальный пикет';
ListShortLine(lvSeisMaterialProperty,ListItem,IntToStr((TObject(tvSeisMaterial.Selected.Data) as TSeismicProfile).PiketBegin));
ListItem:=lvSeisMaterialProperty.Items.Add;
ListItem.Caption:='Конечный пикет';
ListShortLine(lvSeisMaterialProperty,ListItem,IntToStr((TObject(tvSeisMaterial.Selected.Data) as TSeismicProfile).PiketEnd));
ListItem:=lvSeisMaterialProperty.Items.Add;
ListItem.Caption:='Длина сейсмопрофиля';
ListShortLine(lvSeisMaterialProperty,ListItem,FloatToStr((TObject(tvSeisMaterial.Selected.Data) as TSeismicProfile).SeisProfileLenght));
ListItem:=lvSeisMaterialProperty.Items.Add;
ListItem.Caption:='Дата внесения сейсмопрофиля';
ListShortLine(lvSeisMaterialProperty,ListItem,DateToStr((TObject(tvSeisMaterial.Selected.Data) as TSeismicProfile).DateEntry));
ListItem:=lvSeisMaterialProperty.Items.Add;
ListItem.Caption:='Комментарий';
ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TSeismicProfile).SeisProfileComment);
ListItem:=lvSeisMaterialProperty.Items.Add;
ListItem.Caption:='Координаты сейсмопрофиля';
for i3:=0 to TMainFacade.GetInstance.AllSeismicProfileCoordinates.Count-1 do
if (TMainFacade.GetInstance.AllSeismicProfileCoordinates.Items[i3].SeismicProfile.ID=(TObject(tvSeisMaterial.Selected.Data) as TSeismicProfile).ID) then
ListShortLine(lvSeisMaterialProperty,ListItem,'№'+IntToStr(TMainFacade.GetInstance.AllSeismicProfileCoordinates.Items[i3].CoordNumber)+'  X: '+FloatToStr(TMainFacade.GetInstance.AllSeismicProfileCoordinates.Items[i3].CoordX)+'  Y: '+FloatToStr(TMainFacade.GetInstance.AllSeismicProfileCoordinates.Items[i3].CoordY));

lvSeisMaterialProperty.Items.EndUpdate;
end
else
if TObject(tvSeisMaterial.Selected.Data) is TExempleSeismicMaterial then
begin
lvSeisMaterialProperty.Items.BeginUpdate;
lvSeisMaterialProperty.Column[0].Caption:='Экземпляр отчета';
ListItem:=lvSeisMaterialProperty.Items.Add;
ListItem.Caption:='№Экземпляра';
ListShortLine(lvSeisMaterialProperty,ListItem,IntToStr((TObject(tvSeisMaterial.Selected.Data) as TExempleSeismicMaterial).ID));
ListItem:=lvSeisMaterialProperty.Items.Add;
ListItem.Caption:='Количество экземпляров';
ListShortLine(lvSeisMaterialProperty,ListItem,IntToStr((TObject(tvSeisMaterial.Selected.Data) as TExempleSeismicMaterial).ExempleSum));
ListItem:=lvSeisMaterialProperty.Items.Add;
ListItem.Caption:='Тип экземпляра';
ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TExempleSeismicMaterial).ExempleType.Name);
ListItem:=lvSeisMaterialProperty.Items.Add;
ListItem.Caption:='Местонахождение экземпляра';
ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TExempleSeismicMaterial).ExempleLocation.Name+' '+(TObject(tvSeisMaterial.Selected.Data) as TExempleSeismicMaterial).ExempleLocation.MaterialLocation.Name);
ListItem:=lvSeisMaterialProperty.Items.Add;
ListItem.Caption:='Комментарий';
ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TExempleSeismicMaterial).ExempleComment);
lvSeisMaterialProperty.Items.EndUpdate;
end
else
if TObject(tvSeisMaterial.Selected.Data) is TElementExemple then
begin
lvSeisMaterialProperty.Items.BeginUpdate;
lvSeisMaterialProperty.Column[0].Caption:='Элемент экземпляра';
ListItem:=lvSeisMaterialProperty.Items.Add;
ListItem.Caption:='Порядковый № элемента';
ListShortLine(lvSeisMaterialProperty,ListItem,IntToStr((TObject(tvSeisMaterial.Selected.Data) as TElementExemple).ElementNumber));
ListItem:=lvSeisMaterialProperty.Items.Add;
ListItem.Caption:='Тип элемента';
ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TElementExemple).ElementType.Name);
ListItem:=lvSeisMaterialProperty.Items.Add;
ListItem.Caption:='Описание';
ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TElementExemple).Name);
ListItem:=lvSeisMaterialProperty.Items.Add;
ListItem.Caption:='Уточненное местонахождение';
ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TElementExemple).ElementLocation);
ListItem:=lvSeisMaterialProperty.Items.Add;
ListItem.Caption:='Комментарий';
ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TElementExemple).ElementComment);
lvSeisMaterialProperty.Items.EndUpdate;
end;
//lvSeisMaterialProperty.Items.EndUpdate;
end;
end;

procedure TfrmMain.btn4Click(Sender: TObject);
begin


ShellExecute (frmMain.Handle, nil, 'D:\riccsrc\wells10.mxd', nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmMain.ListShortLine(Lw: TListView; LItem: TListItem;
  Str: String);
var sz,poz:Integer;
stroka:String;
begin
sz:=9;//примерная длина символа в пикселях(для 12 размера шрифта)
stroka:=' ,.?!:;';//символы после которых можно переносить
if ((Length(Str)*sz)>Int(Lw.Width*0.95)) then //если длина строки в пикселях больше 95% длины ListView
begin
while ((Length(Str)*sz)>Int(Lw.Width*0.95)) do //нарезаем строку на подстроки
begin
 poz:=Trunc((Lw.Width*0.95)/sz);//получаем оптимальное количество сисмволов для подстроки
 while (Pos(Copy(Str,poz,1),stroka)=0) do
 begin
 if (poz=1) then
 begin
 poz:=Trunc((Lw.Width*0.95)/sz);
 Break;
 end;
 Dec(poz);//пока не найден символ переноса сокращаем подстроку справа на лево
 end;
 LItem:=Lw.Items.Add;
 LItem.Caption:=Copy(Str,0,poz);//вставляем подстроку
 LItem.Data:=TObject.Create;
 Str:=Copy(Str,poz+1,(Length(Str)-poz));//удаляем из строки подстроку
 //Delete(Str,0,poz);
end;
LItem:=Lw.Items.Add;//вставляем последнюю(короткую) подстроку
LItem.Caption:=Str;
LItem.Data:=TObject.Create;
end
else
begin
LItem:=Lw.Items.Add;//строка маленькая, поэтому вставляем сразу
LItem.Caption:=Str;
LItem.Data:=TObject.Create;
end;

end;

procedure TfrmMain.EventReload(Sender: TObject);
begin
ShowMessage('123');
end;

procedure TfrmMain.frmSeisMaterialList1tvSeisMaterialMouseDown(Sender: TObject;
    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i:integer;
begin
if (Button=mbRight) then
begin
frmSeisMaterialList1.tvSeisMaterial.Selected:=frmSeisMaterialList1.tvSeisMaterial.GetNodeAt(X,Y);
actSelectListExecute(frmSeisMaterialList1.tvSeisMaterial);
end;
end;



end.
