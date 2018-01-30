unit FormEditSeisMaterial;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrameEditSMSimpleDocument, StdCtrls, Material, Employee,Organization,SeisMaterial,SeisProfile,SeisExemple,
  ActnList, Area, FrameEditSMMaterialBind, ComCtrls, ToolWin, BaseObjects,
  ImgList, Menus, FrameEditSMSeisMaterial, FrameEditSMExemple, FormEvent;

type
  TfrmSMEdit = class(TForm)
    frmEditSMSimpleDocument: TFrame3;
    actlstEditMaterial: TActionList;
    actSMAddMaterial: TAction;
    actSMSelectMaterialSimpleDoc: TAction;
    actActiveForm: TAction;
    actCheckMaterial: TAction;
    actSMBindKeyDown: TAction;
    actSMSelectBindType: TAction;
    frmEditSMMaterialBind: TFrame4;
    actSMGo: TAction;
    actSMBack: TAction;
    actSMAddBind: TAction;
    actSMSelectBindTypes: TAction;
    il1: TImageList;
    actSelectAuthors: TAction;
    actSMAddAll: TAction;
    actSMAddObjBind: TAction;
    actDelObjBind: TAction;
    pmObjectBindCurrent: TPopupMenu;
    actDelObjBind1: TMenuItem;
    frmEditSMSeisMaterial: TFrame5;
    actSMSelectMaterialBind: TAction;
    actSMSelectMaterialSeisMat: TAction;
    actSMAddSeisMat: TAction;
    actCheckProfile: TAction;
    actSMAddProfile: TAction;
    pmProfileCurrent: TPopupMenu;
    actDelProfileCurrent: TAction;
    actDelProfileCurrent1: TMenuItem;
    frmEditSMExemple: TFrame6;
    actSMSelectMaterialExemple: TAction;
    actSelectExemple: TAction;
    actSelectElement: TAction;
    actSMAddExemple: TAction;
    actAddExemple: TAction;
    actUpExemple: TAction;
    actDelExemple: TAction;
    actAddElement: TAction;
    actUpElement: TAction;
    actDelElement: TAction;
    actSearchAuthor: TAction;
    actSearchSD: TAction;
    btnSMBack: TButton;
    btnSMGo: TButton;
    btnSMAddAll: TButton;
    btnSMClose: TButton;
    actSMClose: TAction;
    procedure actSMAddMaterialExecute(Sender: TObject);
    procedure actSMSelectMaterialSimpleDocExecute(Sender: TObject);
    procedure actActiveFormExecute(Sender: TObject);
    procedure actAddElementExecute(Sender: TObject);
    procedure actAddExempleExecute(Sender: TObject);
    procedure actSMAddAllExecute(Sender: TObject);
    procedure actSMAddObjBindExecute(Sender: TObject);
    procedure actCheckMaterialExecute(Sender: TObject);
    procedure actCheckProfileExecute(Sender: TObject);
    procedure actDelElementExecute(Sender: TObject);
    procedure actDelExempleExecute(Sender: TObject);
    procedure actDelObjBindExecute(Sender: TObject);
    procedure actDelProfileCurrentExecute(Sender: TObject);
    procedure actSearchAuthorExecute(Sender: TObject);
    procedure actSearchSDExecute(Sender: TObject);
    procedure actSelectAuthorsExecute(Sender: TObject);
    procedure actSelectElementExecute(Sender: TObject);
    procedure actSelectExempleExecute(Sender: TObject);
    procedure actSMAddBindExecute(Sender: TObject);
    procedure actSMAddExempleExecute(Sender: TObject);
    procedure actSMAddProfileExecute(Sender: TObject);
    procedure actSMAddSeisMatExecute(Sender: TObject);
    procedure actSMBackExecute(Sender: TObject);
    procedure actSMBindKeyDownExecute(Sender: TObject;Key: Word);
    procedure actSMCloseExecute(Sender: TObject);
    procedure actSMGoExecute(Sender: TObject);
    procedure actSMSelectMaterialExempleExecute(Sender: TObject);
    procedure actSMSelectBindTypeExecute(Sender: TObject);
    procedure actSMSelectBindTypesExecute(Sender: TObject);
    procedure actSMSelectMaterialBindExecute(Sender: TObject);
    procedure actSMSelectMaterialSeisMatExecute(Sender: TObject);
    procedure actUpElementExecute(Sender: TObject);
    procedure actUpExempleExecute(Sender: TObject);
    procedure frmEditSMMaterialBindedtMaterialBindKeyDown(Sender: TObject;
      var Key: Word; Shift: TShiftState);
    procedure frmEditSMMaterialBindedtMaterialBindKeyUp(Sender: TObject; var Key:
        Word; Shift: TShiftState);
    procedure frmEditSMMaterialBindlstObjectBindCurrentMouseDown(Sender: TObject;
        Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure frmEditSMSeisMateriallstProfileCurrentMouseDown(Sender: TObject;
        Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure frmEditSMSimpleDocumentcbbSelectMaterialKeyUp(Sender: TObject; var
        Key: Word; Shift: TShiftState);

    procedure frmEditSMSimpleDocumentedtSearhAuthorKeyUp(Sender: TObject; var Key:
        Word; Shift: TShiftState);

  private
  FCSD:TSimpleDocument;
  FCSM:TSeismicMaterial;
  FMatAuthors:TMaterialAuthors;
  FSeisExemples:TExempleSeismicMaterials;
  FSeisElements:TElementExemples;
  FOnMyEvent:TMyEvent;
  Flag:Boolean;
      { Private declarations }
  public
  property CSD:TSimpleDocument read FCSD write FCSD;//текущий материал
  property CSM:TSeismicMaterial read FCSM write FCSM;//текущий отчет(сейсм.материал)
  property MatAuthors:TMaterialAuthors read FMatAuthors write FMatAuthors;
  property SeisExemples:TExempleSeismicMaterials read FSeisExemples write FSeisExemples;
  property SeisElements:TElementExemples read FSeisElements write FSeisElements;
  property OnMyEvent:TMyEvent read FOnMyEvent write FOnMyEvent;
    { Public declarations }
  end;

var
  frmSMEdit: TfrmSMEdit;

implementation

uses Facade, SDFacade, Math;
{$R *.dfm}

procedure TfrmSMEdit.actSMAddMaterialExecute(Sender: TObject);
var SD:TSimpleDocument;ma:TMaterialAuthor;i,j:Integer;str_autors:string;Add,UpAuthor:Boolean;
begin
//определяем будем создавать или редактировать материал
if frmEditSMSimpleDocument.chkAddSimpleDoc.Checked then Add:=True else Add:=False;
if Add then SD:=TMainFacade.GetInstance.AllSimpleDocuments.Add as TSimpleDocument
else
begin
SD:=TSimpleDocument.Create(TMainFacade.GetInstance.AllSimpleDocuments) as TSimpleDocument;
SD.Assign(TMainFacade.GetInstance.AllSimpleDocuments.ItemsByID[Integer(TSimpleDocument(frmEditSMSimpleDocument.cbbSelectMaterial.Items.Objects[frmEditSMSimpleDocument.cbbSelectMaterial.ItemIndex]).ID)]);
end;
//вносим параметры материала в коллекцию и БД
SD.Name:=frmEditSMSimpleDocument.edtNameSimpleDoc.Text;
SD.InventNumber:=StrToInt(frmEditSMSimpleDocument.edtInventNumber.Text);
SD.TGFNumber:=StrToInt(frmEditSMSimpleDocument.edtTGFNumber.Text);
SD.MaterialComment:=frmEditSMSimpleDocument.edtCommentSimpleDoc.Text;
SD.CreationDate:=frmEditSMSimpleDocument.dtpCreationDate.Date;
SD.EnteringDate:=Now;
SD.VCHLocation:='fdhgsdfgjdsgf';
SD.MaterialLocation:=TMainFacade.GetInstance.AllMaterialLocations.ItemsByID[Integer(TMaterialLocation(frmEditSMSimpleDocument.cbbLocation.Items.Objects[frmEditSMSimpleDocument.cbbLocation.ItemIndex]).ID)] as TMaterialLocation;
SD.DocType:=TMainFacade.GetInstance.DocumentTypes.ItemsByID[70] as TDocumentType;
SD.Organization:=TMainFacade.GetInstance.AllOrganizations.ItemsByID[Integer(TOrganization(frmEditSMSimpleDocument.cbbOrganization.Items.Objects[frmEditSMSimpleDocument.cbbOrganization.ItemIndex]).ID)] as TOrganization;
SD.Employee:=TMainFacade.GetInstance.AllEmployees.ItemsByID[148] as TEmployee;

if Add then
SD.ID:=SD.Update()
else
SD.Update();

//удаляем все объекты в коллекции-удаления,после чего они удаляются в основной коллекции
for i:=0 to TMainFacade.GetInstance.AllMaterialAuthors.DeletedObjects.Count-1 do
TMainFacade.GetInstance.AllMaterialAuthors.DeletedObjects.Remove(TMainFacade.GetInstance.AllMaterialAuthors.DeletedObjects.Items[0] as TMaterialAuthor);
{i:=0;
while ((TMainFacade.GetInstance.AllMaterialAuthors.DeletedObjects.Count<>0) or (TMainFacade.GetInstance.AllMaterialAuthors.DeletedObjects.Count-1<>i)) do
begin
if TMainFacade.GetInstance.AllMaterialAuthors.DeletedObjects.Items[i].ID=CSD.ID then
begin
TMainFacade.GetInstance.AllMaterialAuthors.DeletedObjects.Remove(TMainFacade.GetInstance.AllMaterialAuthors.DeletedObjects.Items[i] as TMaterialAuthor);
dec(i);
end;
inc(i);
end;   }
TMainFacade.GetInstance.AllMaterialAuthors.DeletedObjects.Clear;//зачищаем коллекцию (на всякий случай)
//проверяем выбранных авторов в чеклистбокс
for i:=0 to frmEditSMSimpleDocument.chklstAuthorOurs.Count-1 do
begin
if frmEditSMSimpleDocument.chklstAuthorOurs.Checked[i] then
  begin
  UpAuthor:=false;
  for j:=0 to TMainFacade.GetInstance.AllMaterialAuthors.Count-1 do
  if Assigned(TMainFacade.GetInstance.AllMaterialAuthors.Items[j].SimpleDocument) then
  if (SD.ID=(TMainFacade.GetInstance.AllMaterialAuthors.Items[j] as TMaterialAuthor).SimpleDocument.ID) and (Integer(TEmployeeOur(frmEditSMSimpleDocument.chklstAuthorOurs.Items.Objects[i]).ID)=(TMainFacade.GetInstance.AllMaterialAuthors.Items[j] as TMaterialAuthor).ID) then 
  begin
  UpAuthor:=True;//если такой автор уже связан с материалом то пропускаем
  Break;
  end;
  if UpAuthor then
  str_autors:=str_autors+ ', '+TEmployeeOur(frmEditSMSimpleDocument.chklstAuthorOurs.Items.Objects[i]).Name//каждый раз поновой заполняем
  else
  begin//если автор еще не связан, то добавляем
  ma:=TMainFacade.GetInstance.AllMaterialAuthors.Add as TMaterialAuthor;
  ma.SimpleDocument:=TMainFacade.GetInstance.AllSimpleDocuments.ItemsById[SD.ID] as TSimpleDocument;
  ma.ID:=Integer(TEmployeeOur(frmEditSMSimpleDocument.chklstAuthorOurs.Items.Objects[i]).ID);
  ma.Role := arInner;
  ma.Update();
  str_autors:=str_autors+ ', '+TEmployeeOur(frmEditSMSimpleDocument.chklstAuthorOurs.Items.Objects[i]).Name;//и сюда добавляем
  end;
  UpAuthor:=False;
  end;
end;
//все тоже, только для второго чеклистбокса
for i:=0 to frmEditSMSimpleDocument.chklstAuthorOutsides.Count-1 do
begin
if frmEditSMSimpleDocument.chklstAuthorOutsides.Checked[i] then
  begin
  UpAuthor:=False;
  for j:=0 to TMainFacade.GetInstance.AllMaterialAuthors.Count-1 do
  if Assigned(TMainFacade.GetInstance.AllMaterialAuthors.Items[j].SimpleDocument) then
  if (SD.ID=(TMainFacade.GetInstance.AllMaterialAuthors.Items[j] as TMaterialAuthor).SimpleDocument.ID) and (Integer(TEmployeeOutside(frmEditSMSimpleDocument.chklstAuthorOutsides.Items.Objects[i]).ID)=(TMainFacade.GetInstance.AllMaterialAuthors.Items[j] as TMaterialAuthor).ID) then
  begin
  UpAuthor:=True;
  Break;
  end;
  if UpAuthor then
  str_autors:=str_autors+ ', '+TEmployeeOutside(frmEditSMSimpleDocument.chklstAuthorOutsides.Items.Objects[i]).Name
  else
  begin
  ma:=TMainFacade.GetInstance.AllMaterialAuthors.Add as TMaterialAuthor;
  ma.SimpleDocument:=TMainFacade.GetInstance.AllSimpleDocuments.ItemsById[SD.ID] as TSimpleDocument;
  ma.ID:=Integer(TEmployeeOutside(frmEditSMSimpleDocument.chklstAuthorOutsides.Items.Objects[i]).ID);
  ma.Role := arOuter;
  ma.Update();
  str_autors:=str_autors+ ', '+TEmployeeOutside(frmEditSMSimpleDocument.chklstAuthorOutsides.Items.Objects[i]).Name;
  end;
  UpAuthor:=False;
  end;
end;
if (str_autors='') then//если нет авторов пустую стоку вставляем(чтобы зачистить после удаления VCH_AUTHOR в БД)
begin
SD.Authors:=str_autors;
SD.Update();
end
else
begin//если есть авторы у материала, презаписываем
SD.Authors:=Copy(str_autors,3,Length(str_autors));
SD.Update();
end;

if Add=False then //если редактировали материал чистим комбобокс
begin
(TMainFacade.GetInstance.AllSimpleDocuments.ItemsByID[SD.ID] as TSimpleDocument).Assign(SD);
frmEditSMSimpleDocument.cbbSelectMaterial.Items.Delete(frmEditSMSimpleDocument.cbbSelectMaterial.Items.Count-1);
TMainFacade.GetInstance.AllSimpleDocuments.MakeList(frmEditSMSimpleDocument.cbbSelectMaterial.Items);
end;
//выбираем в комбобоксе текущий материал
for i:=0 to frmEditSMSimpleDocument.cbbSelectMaterial.Items.Count-1 do
if ((frmEditSMSimpleDocument.cbbSelectMaterial.Items.Objects[i] as TSimpleDocument).ID=SD.ID) then
frmEditSMSimpleDocument.cbbSelectMaterial.ItemIndex:=i;
frmEditSMSimpleDocument.chkAddSimpleDoc.Checked:=False;
actSMSelectMaterialSimpleDocExecute(frmEditSMSimpleDocument);
end;

procedure TfrmSMEdit.actSMSelectMaterialSimpleDocExecute(Sender: TObject);
var i,j:Integer;ma:TMaterialAuthors;
begin
//заносим в текущий материал, выбранный в комбобоксе
CSD.Assign(TMainFacade.GetInstance.AllSimpleDocuments.ItemsByID[Integer(TSimpleDocument(frmEditSMSimpleDocument.cbbSelectMaterial.Items.Objects[frmEditSMSimpleDocument.cbbSelectMaterial.ItemIndex]).ID)]);
//проверяем есть ли у материала связанный с ним отчет(сейс.материал)
for i:=0 to TMainFacade.GetInstance.AllSeismicMaterials.Count-1 do
if CSD.ID=TMainFacade.GetInstance.AllSeismicMaterials.Items[i].SimpleDocument.ID then
begin
CSM.Assign(TMainFacade.GetInstance.AllSeismicMaterials.Items[i] as TSeismicMaterial);//если есть заполняем текущий отчет
Break;
end
else CSM:=TSeismicMaterial.Create(TMainFacade.GetInstance.AllSeismicMaterials) as TSeismicMaterial;
//заполняем поля на форме
frmEditSMSimpleDocument.edtInventNumber.Text:=IntToStr(CSD.InventNumber);
frmEditSMSimpleDocument.edtTGFNumber.Text:=IntToStr(CSD.TGFNumber);
frmEditSMSimpleDocument.edtNameSimpleDoc.Text:=CSD.Name;
frmEditSMSimpleDocument.dtpCreationDate.Date:=CSD.CreationDate;

if Assigned(CSD.Organization) then //проверка указан ли для материала данный объект(далее аналогичено)
begin
for i:=0 to frmEditSMSimpleDocument.cbbOrganization.Items.Count do
if  (frmEditSMSimpleDocument.cbbOrganization.Items.Objects[i] as TOrganization).ID=CSD.Organization.ID then
begin
frmEditSMSimpleDocument.cbbOrganization.ItemIndex:=i;//если привязан, то выбираем его в комбобоксе(далее аналогичено)
Break;
end;
end
else
frmEditSMSimpleDocument.cbbOrganization.ItemIndex:=-1;
if Assigned(CSD.MaterialLocation) then
begin
for i:=0 to frmEditSMSimpleDocument.cbbOrganization.Items.Count do
if  (frmEditSMSimpleDocument.cbbLocation.Items.Objects[i] as TMaterialLocation).ID=CSD.MaterialLocation.ID then
begin
frmEditSMSimpleDocument.cbbLocation.ItemIndex:=i;
Break;
end;
end
else
frmEditSMSimpleDocument.cbbLocation.ItemIndex:=-1;

frmEditSMSimpleDocument.edtLocationPath.Text:=CSD.VCHLocation;
//чистим от "галок" чеклистбоксы
for i:=0 to frmEditSMSimpleDocument.chklstAuthorOurs.Items.Count-1 do frmEditSMSimpleDocument.chklstAuthorOurs.Checked[i]:=False;
for i:=0 to frmEditSMSimpleDocument.chklstAuthorOutsides.Items.Count-1 do frmEditSMSimpleDocument.chklstAuthorOutsides.Checked[i]:=False;
j:=0;
ma:=TMaterialAuthors.Create;
//определяем связи материала с авторами
for i:=0 to TMainFacade.GetInstance.AllMaterialAuthors.Count-1 do
if  Assigned(TMainFacade.GetInstance.AllMaterialAuthors.Items[i].SimpleDocument) then
begin
if  TMainFacade.GetInstance.AllMaterialAuthors.Items[i].SimpleDocument.ID=CSD.ID then
begin
ma.Insert(j,TMainFacade.GetInstance.AllMaterialAuthors.Items[i]);
inc(j);
end
end;
//заполняем чеклистбоксы авторами, через определнные ранее связи
for j:=0 to ma.Count-1 do
for i:=0 to frmEditSMSimpleDocument.chklstAuthorOurs.Count-1 do
begin
  if (Integer(TEmployeeOur(frmEditSMSimpleDocument.chklstAuthorOurs.Items.Objects[i]).ID)=TMaterialAuthor(ma.Items[j]).ID) then
  begin
  frmEditSMSimpleDocument.chklstAuthorOurs.Checked[i]:=True;Break;
  end;
end;
for j:=0 to ma.Count-1 do
for i:=0 to frmEditSMSimpleDocument.chklstAuthorOutsides.Count-1 do
begin
  if ((Integer(TEmployeeOutside(frmEditSMSimpleDocument.chklstAuthorOutsides.Items.Objects[i]).Id))=TMaterialAuthor(ma.Items[j]).ID) then
  begin
  frmEditSMSimpleDocument.chklstAuthorOutsides.Checked[i]:=True;Break;
  end;
end;

frmEditSMSimpleDocument.edtCommentSimpleDoc.Text:=CSD.MaterialComment;
end;

procedure TfrmSMEdit.actActiveFormExecute(Sender: TObject);
var i,j:Integer;
begin
//создаем текущий материал и текущий отчет
CSD:=TSimpleDocument.Create(TMainFacade.GetInstance.AllSimpleDocuments) as TSimpleDocument;
CSM:=TSeismicMaterial.Create(TMainFacade.GetInstance.AllSeismicMaterials) as TSeismicMaterial;
MatAuthors:=TMaterialAuthors.Create;
SeisExemples:=TExempleSeismicMaterials.Create;
SeisElements:=TElementExemples.Create;
if frmEditSMSimpleDocument.cbbSelectMaterial.ItemIndex<>-1 then
begin
frmSMEdit.actSMSelectMaterialSimpleDocExecute(frmSMEdit);
frmSMEdit.actSMSelectMaterialSeisMatExecute(frmSMEdit);
frmSMEdit.actSMSelectMaterialBindExecute(frmSMEdit);
if CSM<>nil then frmSMEdit.actSMSelectMaterialExempleExecute(frmSMEdit);
end;
Flag:=False;
end;

procedure TfrmSMEdit.actAddElementExecute(Sender: TObject);
var El:TElementExemple;i,m:Integer;
begin
EL:=SeisElements.Add as TElementExemple;
m:=SeisElements.Items[0].ID;
for i:=1 to SeisElements.Count-1 do
if SeisElements.Items[i].ID<m then m:=SeisElements.Items[i].ID;
if m>0 then El.ID:=-1 else El.ID:=m-1;
El.ExempleSeismicMaterial:=frmEditSMExemple.lstExempleCurrent.Items.Objects[frmEditSMExemple.lstExempleCurrent.ItemIndex] as TExempleSeismicMaterial;
EL.ElementNumber:=StrToInt(frmEditSMExemple.edtNumberElement.Text);
El.ElementComment:=frmEditSMExemple.edtCommentElement.Text;
El.Name:=frmEditSMExemple.edtNameElement.Text;
El.ElementLocation:=frmEditSMExemple.edtLocationElement.Text;
El.ElementType:=TMainFacade.GetInstance.AllElementTypes.ItemsById[(frmEditSMExemple.cbbTypeElement.Items.Objects[frmEditSMExemple.cbbTypeElement.ItemIndex] as TElementType).ID] as TElementType;
frmEditSMExemple.lstElement.Items.AddObject(EL.List,EL as TElementExemple);
end;

procedure TfrmSMEdit.actAddExempleExecute(Sender: TObject);
var EX:TExempleSeismicMaterial;i,m:Integer;
begin
EX:=SeisExemples.Add as TExempleSeismicMaterial;
m:=SeisExemples.Items[0].ID;
for i:=1 to SeisExemples.Count-1 do
if SeisExemples.Items[i].ID<m then m:=SeisExemples.Items[i].ID;
if m>0 then EX.ID:=-1 else EX.ID:=m-1;
EX.ExempleSum:=StrToInt(frmEditSMExemple.edtCountExemple.Text);
EX.ExempleComment:=frmEditSMExemple.edtCommentExemple.Text;
EX.ExempleLocation:=TMainFacade.GetInstance.AllExempleLocations.ItemsById[(frmEditSMExemple.cbbLocExemple.Items.Objects[frmEditSMExemple.cbbLocExemple.ItemIndex] as TExempleLocation).ID] as TExempleLocation;
EX.ExempleType:=TMainFacade.GetInstance.AllExempleTypes.ItemsById[(frmEditSMExemple.cbbTypeExemple.Items.Objects[frmEditSMExemple.cbbTypeExemple.ItemIndex] as TExempleType).ID] as TExempleType;
EX.SeismicMaterial:=TMainFacade.GetInstance.AllSeismicMaterials.ItemsById[CSM.ID] as TSeismicMaterial;
frmEditSMExemple.lstExempleCurrent.Items.AddObject(EX.List,EX as TExempleSeismicMaterial);
end;

procedure TfrmSMEdit.actSMAddAllExecute(Sender: TObject);
begin
//определяем в зависимости от фрейма что мы добавляем
if frmEditSMSimpleDocument.Visible=True then actSMAddMaterialExecute(frmEditSMSimpleDocument);
if frmEditSMSeisMaterial.Visible=True then
begin
actSMAddMaterialExecute(frmEditSMSimpleDocument);
actSMAddSeisMatExecute(frmEditSMSeisMaterial);
end;
if frmEditSMMaterialBind.Visible=True then
begin
actSMAddMaterialExecute(frmEditSMSimpleDocument);
actSMAddSeisMatExecute(frmEditSMSeisMaterial);
actSMAddBindExecute(frmEditSMMaterialBind);
if Assigned(FOnMyEvent) then FOnMyEvent(Sender);
end;
{if frmEditSMExemple.Visible=True then
begin
actSMAddMaterialExecute(frmEditSMSimpleDocument);
actSMAddSeisMatExecute(frmEditSMSeisMaterial);
actSMAddBindExecute(frmEditSMMaterialBind);
actSMAddExempleExecute(frmEditSMExemple); }



//if Assigned(FOnMyEvent) then FOnMyEvent(Sender);
if  Flag=False then frmSMEdit.Close;
end;

procedure TfrmSMEdit.actSMAddObjBindExecute(Sender: TObject);
var ob:TMaterialBinding;
begin
//добавляем из листбокса объектов привязок, объекты в листбокс текущих привязок
frmEditSMMaterialBind.lstObjectBindCurrent.Items.AddObject((frmEditSMMaterialBind.lstMaterialBind.Items.Objects[frmEditSMMaterialBind.lstMaterialBind.ItemIndex] as TIDObject).Name+':   '+(frmEditSMMaterialBind.lstObjectBindAll.Items.Objects[frmEditSMMaterialBind.lstObjectBindAll.ItemIndex] as TIDObject).List,(frmEditSMMaterialBind.lstObjectBindAll.Items.Objects[frmEditSMMaterialBind.lstObjectBindAll.ItemIndex] as TIDObject));
end;

procedure TfrmSMEdit.actCheckMaterialExecute(Sender: TObject);
var i:Integer;
begin
//в зависимости от преключения между созданием и редактирование материала чистим поля на форме
if (frmEditSMSimpleDocument.chkAddSimpleDoc.Checked=False) then
begin
frmEditSMSimpleDocument.cbbSelectMaterial.Enabled:=true;
end
else
begin
frmEditSMSimpleDocument.cbbSelectMaterial.ItemIndex:=-1;
frmEditSMMaterialBind.cbbSelectMaterial.ItemIndex:=-1;
frmEditSMSimpleDocument.cbbSelectMaterial.Enabled:=False;
frmEditSMSimpleDocument.edtInventNumber.Text:='';
frmEditSMSimpleDocument.edtTGFNumber.Text:='';
frmEditSMSimpleDocument.edtNameSimpleDoc.Text:='';
frmEditSMSimpleDocument.dtpCreationDate.Date:=Now;
frmEditSMSimpleDocument.edtLocationPath.Text:='';
frmEditSMSimpleDocument.edtCommentSimpleDoc.Text:='';
frmEditSMSimpleDocument.cbbOrganization.ItemIndex:=-1;
frmEditSMSimpleDocument.cbbLocation.ItemIndex:=-1;
for i:=0 to frmEditSMSimpleDocument.chklstAuthorOurs.Items.Count-1 do frmEditSMSimpleDocument.chklstAuthorOurs.Checked[i]:=False;
for i:=0 to frmEditSMSimpleDocument.chklstAuthorOutsides.Items.Count-1 do frmEditSMSimpleDocument.chklstAuthorOutsides.Checked[i]:=False;
frmEditSMMaterialBind.lstObjectBindAll.Clear;
frmEditSMMaterialBind.lstObjectBindCurrent.Clear;
end;
end;

procedure TfrmSMEdit.actCheckProfileExecute(Sender: TObject);
var i:Integer;
begin
//выбирам показать все профили или только не распределенные
if frmEditSMSeisMaterial.rgProfile.ItemIndex=1 then
begin
frmEditSMSeisMaterial.cbbProfile.Clear;
for i:=0 to TMainFacade.GetInstance.ALLSeismicProfiles.Count-1 do
if (not Assigned(TMainFacade.GetInstance.ALLSeismicProfiles.Items[i].SeismicMaterial)) then
frmEditSMSeisMaterial.cbbProfile.Items.AddObject(TMainFacade.GetInstance.ALLSeismicProfiles.Items[i].List,TMainFacade.GetInstance.ALLSeismicProfiles.Items[i] as TSeismicProfile);
end
else
begin
frmEditSMSeisMaterial.cbbProfile.Clear;
TMainFacade.GetInstance.ALLSeismicProfiles.MakeList(frmEditSMSeisMaterial.cbbProfile.Items);
end;
end;

procedure TfrmSMEdit.actDelElementExecute(Sender: TObject);
begin
if ((frmEditSMExemple.lstElement.Items.Objects[frmEditSMExemple.lstElement.ItemIndex] as TElementExemple).ID)<=0 then
SeisElements.MarkDeleted(SeisElements.ItemsByID[(frmEditSMExemple.lstElement.Items.Objects[frmEditSMExemple.lstElement.ItemIndex] as TElementExemple).ID] as TElementExemple)
else
begin
SeisElements.MarkDeleted(SeisElements.ItemsByID[(frmEditSMExemple.lstElement.Items.Objects[frmEditSMExemple.lstElement.ItemIndex] as TElementExemple).ID] as TElementExemple);
TMainFacade.GetInstance.ALLElementExemples.MarkDeleted(TMainFacade.GetInstance.ALLElementExemples.ItemsByID[(frmEditSMExemple.lstElement.Items.Objects[frmEditSMExemple.lstElement.ItemIndex] as TElementExemple).ID] as TElementExemple)
end;
frmEditSMExemple.lstElement.DeleteSelected;
end;

procedure TfrmSMEdit.actDelExempleExecute(Sender: TObject);
var i,j:Integer;
begin
if (frmEditSMExemple.lstExempleCurrent.Items.Objects[frmEditSMExemple.lstExempleCurrent.ItemIndex] as TExempleSeismicMaterial).ID>0 then
for i:=0 to TMainFacade.GetInstance.ALLExempleSeismicMaterials.Count-1 do
if TMainFacade.GetInstance.ALLExempleSeismicMaterials.Items[i].ID=(frmEditSMExemple.lstExempleCurrent.Items.Objects[frmEditSMExemple.lstExempleCurrent.ItemIndex] as TExempleSeismicMaterial).ID then
begin
TMainFacade.GetInstance.ALLExempleSeismicMaterials.MarkDeleted(i);
Break;
end;
frmEditSMExemple.lstExempleCurrent.DeleteSelected;
frmEditSMExemple.lstElement.Clear;
end;

procedure TfrmSMEdit.actDelObjBindExecute(Sender: TObject);
var j:Integer;
begin
for j:=0 to TMainFacade.GetInstance.AllMaterialBindings.Count-1 do
begin
if Assigned(TMainFacade.GetInstance.AllMaterialBindings.Items[j].SimpleDocument) then
if ((TMainFacade.GetInstance.AllMaterialBindings.Items[j].SimpleDocument.ID=CSD.ID) and (TMainFacade.GetInstance.AllMaterialBindings.Items[j].ObjectBindType.ID=TMainFacade.GetInstance.BindingObjectTypes[frmEditSMMaterialBind.lstObjectBindCurrent.Items.Objects[frmEditSMMaterialBind.lstObjectBindCurrent.ItemIndex] as TIDObject]) and (TMainFacade.GetInstance.AllMaterialBindings.Items[j].ID=(frmEditSMMaterialBind.lstObjectBindCurrent.Items.Objects[frmEditSMMaterialBind.lstObjectBindCurrent.ItemIndex] as TIDObject).ID)) then
begin
  TMainFacade.GetInstance.AllMaterialBindings.MarkDeleted(j);//добавляем в список объектов для удаления
  Break;
end;
end;
//удаляем объекты с формы(из листбокса)
frmEditSMMaterialBind.lstObjectBindCurrent.Items.Delete(frmEditSMMaterialBind.lstObjectBindCurrent.ItemIndex);
end;

procedure TfrmSMEdit.actDelProfileCurrentExecute(Sender: TObject);
begin
//отвязываем профили от отчета(только на уровне коллекции коллекции)
(TMainFacade.GetInstance.ALLSeismicProfiles.ItemsByID[(frmEditSMSeisMaterial.lstProfileCurrent.Items.Objects[frmEditSMSeisMaterial.lstProfileCurrent.ItemIndex] as TSeismicProfile).ID] as TSeismicProfile).SeismicMaterial:=nil;
actSMSelectMaterialSeisMatExecute(frmEditSMSeisMaterial);
end;

procedure TfrmSMEdit.actSearchAuthorExecute(Sender: TObject);
var i:Integer;
begin
for i:=0 to frmEditSMSimpleDocument.chklstAuthorOurs.Count-1 do
if (Pos(AnsiLowerCase(frmEditSMSimpleDocument.edtSearhAuthor.Text),AnsiLowerCase(frmEditSMSimpleDocument.chklstAuthorOurs.Items.Strings[i]))=1)  then
begin
frmEditSMSimpleDocument.chklstAuthorOurs.ItemIndex:=i;
Break;
end;
for i:=0 to frmEditSMSimpleDocument.chklstAuthorOutsides.Count-1 do
if (Pos(AnsiLowerCase(frmEditSMSimpleDocument.edtSearhAuthor.Text),AnsiLowerCase(frmEditSMSimpleDocument.chklstAuthorOutsides.Items.Strings[i]))=1)  then
begin
frmEditSMSimpleDocument.chklstAuthorOutsides.ItemIndex:=i;
Break;
end;
end;

procedure TfrmSMEdit.actSearchSDExecute(Sender: TObject);
var i:Integer;
begin
for i:=0 to frmEditSMSimpleDocument.cbbSelectMaterial.Items.Count-1 do
if (Pos(AnsiLowerCase(frmEditSMSimpleDocument.cbbSelectMaterial.Text),AnsiLowerCase(frmEditSMSimpleDocument.cbbSelectMaterial.Items.Strings[i]))>=1)  then
begin
frmEditSMSimpleDocument.cbbSelectMaterial.ItemIndex:=i;
Break;
end;
end;

procedure TfrmSMEdit.actSelectAuthorsExecute(Sender: TObject);
var ma:TMaterialAuthor;i,j:Integer;
begin
//зависимости от постановки или удаления чекеда в списке авторов
if (Sender=frmEditSMSimpleDocument.chklstAuthorOurs) then
begin
if frmEditSMSimpleDocument.chklstAuthorOurs.Checked[frmEditSMSimpleDocument.chklstAuthorOurs.ItemIndex]=true then
begin
//добавляем в коллекцию авторов(формы), правда не используем эту коллекцию потом нигде
{ma:=MatAuthors.Add as TMaterialAuthor;
ma.SimpleDocument:=CSD;
ma.ID:=Integer(TEmployeeOur(frmEditSMSimpleDocument.chklstAuthorOurs.Items.Objects[frmEditSMSimpleDocument.chklstAuthorOurs.ItemIndex]).ID);
ma.Role := arInner;}
end
else
begin
//находим связь автора с отчетом и заносим ее в список удаления
for j:=0 to (TMainFacade.GetInstance.AllMaterialAuthors.Count-1) do
if Assigned(TMainFacade.GetInstance.AllMaterialAuthors.Items[j].SimpleDocument) then
if (CSD.ID=(TMainFacade.GetInstance.AllMaterialAuthors.Items[j] as TMaterialAuthor).SimpleDocument.ID) and (Integer(TEmployeeOur(frmEditSMSimpleDocument.chklstAuthorOurs.Items.Objects[frmEditSMSimpleDocument.chklstAuthorOurs.ItemIndex]).ID)=(TMainFacade.GetInstance.AllMaterialAuthors.Items[j] as TMaterialAuthor).ID) then
begin
TMainFacade.GetInstance.AllMaterialAuthors.MarkDeleted(TMainFacade.GetInstance.AllMaterialAuthors.Items[j]);
Break;
end;
end;
end
else
begin
if frmEditSMSimpleDocument.chklstAuthorOutsides.Checked[frmEditSMSimpleDocument.chklstAuthorOutsides.ItemIndex]=true then
begin
{ma:=MatAuthors.Add as TMaterialAuthor;
ma.SimpleDocument:=CSD;
ma.ID:=Integer(TEmployeeOutside(frmEditSMSimpleDocument.chklstAuthorOutsides.Items.Objects[frmEditSMSimpleDocument.chklstAuthorOutsides.ItemIndex]).ID);
ma.Role := arOuter;}
end
else
begin
  for j:=0 to TMainFacade.GetInstance.AllMaterialAuthors.Count-1 do
  if Assigned(TMainFacade.GetInstance.AllMaterialAuthors.Items[j].SimpleDocument) then
  if (CSD.ID=(TMainFacade.GetInstance.AllMaterialAuthors.Items[j] as TMaterialAuthor).SimpleDocument.ID) and (Integer(TEmployeeOutside(frmEditSMSimpleDocument.chklstAuthorOutsides.Items.Objects[frmEditSMSimpleDocument.chklstAuthorOutsides.ItemIndex]).ID)=(TMainFacade.GetInstance.AllMaterialAuthors.Items[j] as TMaterialAuthor).ID) then 
begin
  TMainFacade.GetInstance.AllMaterialAuthors.MarkDeleted(TMainFacade.GetInstance.AllMaterialAuthors.Items[j]);
  Break;
end;
end;
end;
end;

procedure TfrmSMEdit.actSelectElementExecute(Sender: TObject);
var i:Integer;
begin
if frmEditSMExemple.lstElement.Count<>0 then
begin
for i:=0 to frmEditSMExemple.cbbTypeElement.Items.Count-1 do
if  (frmEditSMExemple.cbbTypeElement.Items.Objects[i] as TElementType).ID=(frmEditSMExemple.lstElement.Items.Objects[frmEditSMExemple.lstElement.ItemIndex] as TElementExemple).ElementType.ID then
begin
frmEditSMExemple.cbbTypeElement.ItemIndex:=i;
Break;
end;
frmEditSMExemple.edtNumberElement.Text:=IntToStr((frmEditSMExemple.lstElement.Items.Objects[frmEditSMExemple.lstElement.ItemIndex] as TElementExemple).ElementNumber);
frmEditSMExemple.edtCommentElement.Text:=(frmEditSMExemple.lstElement.Items.Objects[frmEditSMExemple.lstElement.ItemIndex] as TElementExemple).ElementComment;
frmEditSMExemple.edtNameElement.Text:=(frmEditSMExemple.lstElement.Items.Objects[frmEditSMExemple.lstElement.ItemIndex] as TElementExemple).Name;
frmEditSMExemple.edtLocationElement.Text:=(frmEditSMExemple.lstElement.Items.Objects[frmEditSMExemple.lstElement.ItemIndex] as TElementExemple).ElementLocation;
end;
end;

procedure TfrmSMEdit.actSelectExempleExecute(Sender: TObject);
var i:Integer;
begin
if frmEditSMExemple.lstExempleCurrent.Count<>0 then
begin
for i:=0 to frmEditSMExemple.cbbTypeExemple.Items.Count-1 do
if  (frmEditSMExemple.cbbTypeExemple.Items.Objects[i] as TExempleType).ID=(frmEditSMExemple.lstExempleCurrent.Items.Objects[frmEditSMExemple.lstExempleCurrent.ItemIndex] as TExempleSeismicMaterial).ExempleType.ID then
begin
frmEditSMExemple.cbbTypeExemple.ItemIndex:=i;
Break;
end;
for i:=0 to frmEditSMExemple.cbbLocExemple.Items.Count-1 do
if  (frmEditSMExemple.cbbLocExemple.Items.Objects[i] as TExempleLocation).ID=(frmEditSMExemple.lstExempleCurrent.Items.Objects[frmEditSMExemple.lstExempleCurrent.ItemIndex] as TExempleSeismicMaterial).ExempleLocation.ID then
begin
frmEditSMExemple.cbbLocExemple.ItemIndex:=i;
Break;
end;
frmEditSMExemple.edtCountExemple.Text:=IntToStr((frmEditSMExemple.lstExempleCurrent.Items.Objects[frmEditSMExemple.lstExempleCurrent.ItemIndex] as TExempleSeismicMaterial).ExempleSum);
frmEditSMExemple.edtCommentExemple.Text:=(frmEditSMExemple.lstExempleCurrent.Items.Objects[frmEditSMExemple.lstExempleCurrent.ItemIndex] as TExempleSeismicMaterial).ExempleComment;
frmEditSMExemple.lstElement.Clear;
frmEditSMExemple.cbbTypeElement.ItemIndex:=-1;
frmEditSMExemple.edtNumberElement.Text:='';
frmEditSMExemple.edtCommentElement.Text:='';
frmEditSMExemple.edtNameElement.Text:='';
frmEditSMExemple.edtLocationElement.Text:='';
for i:=0 to SeisElements.Count-1 do
if (frmEditSMExemple.lstExempleCurrent.Items.Objects[frmEditSMExemple.lstExempleCurrent.ItemIndex] as TExempleSeismicMaterial).ID=SeisElements.Items[i].ExempleSeismicMaterial.ID then
frmEditSMExemple.lstElement.Items.AddObject(SeisElements.Items[i].List,SeisElements.Items[i] as TElementExemple);
end;
end;


procedure TfrmSMEdit.actSMAddBindExecute(Sender: TObject);
var ob:TMaterialBinding;i,j:Integer;AddBind:Boolean;str_bind:string;
begin
//if (not Assigned(CSD)) then CSD.Assign(TMainFacade.GetInstance.AllSimpleDocuments.ItemsByID[Integer(TSimpleDocument(frmEditSMMaterialBind.cbbSelectMaterial.Items.Objects[frmEditSMMaterialBind.cbbSelectMaterial.ItemIndex]).ID)]);
for j:=0 to TMainFacade.GetInstance.AllMaterialBindings.DeletedObjects.Count-1 do //удаляем привязки материала
TMainFacade.GetInstance.AllMaterialBindings.DeletedObjects.Remove(TMainFacade.GetInstance.AllMaterialBindings.DeletedObjects.Items[0] as TMaterialBinding);
TMainFacade.GetInstance.AllMaterialBindings.DeletedObjects.Clear;

for i:=0 to frmEditSMMaterialBind.lstObjectBindCurrent.Items.Count-1 do//проходим по списку привязок в листбоксе
begin
AddBind:=True;
str_bind:=str_bind+', '+(frmEditSMMaterialBind.lstObjectBindCurrent.Items.Objects[i] as TIDObject).Name;
for j:=0 to TMainFacade.GetInstance.AllMaterialBindings.Count-1 do
begin
if Assigned(TMainFacade.GetInstance.AllMaterialBindings.Items[j].SimpleDocument) then
if ((TMainFacade.GetInstance.AllMaterialBindings.Items[j].SimpleDocument.ID=CSD.ID) and (TMainFacade.GetInstance.AllMaterialBindings.Items[j].ObjectBindType.ID=TMainFacade.GetInstance.BindingObjectTypes[frmEditSMMaterialBind.lstObjectBindCurrent.Items.Objects[i] as TIDObject]) and (TMainFacade.GetInstance.AllMaterialBindings.Items[j].ID=(frmEditSMMaterialBind.lstObjectBindCurrent.Items.Objects[i] as TIDObject).ID)) then
begin
  AddBind:=False;//если привязка есть пропускаем
  Break;
end;
end;
if AddBind then
begin
ob:=TMainFacade.GetInstance.AllMaterialBindings.Add as TMaterialBinding;
ob.SimpleDocument:=TMainFacade.getinstance.AllSimpleDocuments.itemsbyid[CSD.id] as TSimpleDocument;
ob.ObjectBindType:=TMainFacade.getinstance.AllObjectBindTypes.itemsbyid[TMainFacade.GetInstance.BindingObjectTypes[frmEditSMMaterialBind.lstObjectBindCurrent.Items.Objects[i] as TIDObject]] as TObjectBindType;
ob.ID:=(frmEditSMMaterialBind.lstObjectBindCurrent.Items.Objects[i] as TIDObject).ID;
ob.Update();//добавляем новую привязку
end;
end;

if (str_bind='') then//если нет авторов пустую стоку вставляем(чтобы зачистить после удаления VCH_AUTHOR в БД)
begin
(TMainFacade.GetInstance.AllSimpleDocuments.ItemsByID[CSD.ID] as TSimpleDocument).Bindings:=str_bind;
(TMainFacade.GetInstance.AllSimpleDocuments.ItemsByID[CSD.ID] as TSimpleDocument).Update();
end
else
begin//если есть авторы у материала, презаписываем
(TMainFacade.GetInstance.AllSimpleDocuments.ItemsByID[CSD.ID] as TSimpleDocument).Bindings:=Copy(str_bind,3,Length(str_bind));
(TMainFacade.GetInstance.AllSimpleDocuments.ItemsByID[CSD.ID] as TSimpleDocument).Update();
end;

//frmEditSMSimpleDocument.cbbSelectMaterial.Items.Delete(frmEditSMSimpleDocument.cbbSelectMaterial.Items.Count-1);
TMainFacade.GetInstance.AllSimpleDocuments.MakeList(frmEditSMSimpleDocument.cbbSelectMaterial.Items);
//выбираем в комбобоксе текущий материал
for i:=0 to frmEditSMSimpleDocument.cbbSelectMaterial.Items.Count-1 do
if ((frmEditSMSimpleDocument.cbbSelectMaterial.Items.Objects[i] as TSimpleDocument).ID=CSD.ID) then
frmEditSMSimpleDocument.cbbSelectMaterial.ItemIndex:=i;
actSMSelectMaterialSimpleDocExecute(frmEditSMSimpleDocument);

end;

procedure TfrmSMEdit.actSMAddExempleExecute(Sender: TObject);
var i,j,id:integer;EX:TExempleSeismicMaterial;EL:TElementExemple;AddEx,AddEl,Del:Boolean;
begin
for i:=0 to TMainFacade.GetInstance.ALLElementExemples.DeletedObjects.Count-1 do
TMainFacade.GetInstance.ALLElementExemples.DeletedObjects.Remove(TMainFacade.GetInstance.ALLElementExemples.DeletedObjects.Items[0] as TElementExemple);
TMainFacade.GetInstance.ALLElementExemples.DeletedObjects.Clear;
for i:=0 to TMainFacade.GetInstance.ALLExempleSeismicMaterials.DeletedObjects.Count-1 do
TMainFacade.GetInstance.ALLExempleSeismicMaterials.DeletedObjects.Remove(TMainFacade.GetInstance.ALLExempleSeismicMaterials.DeletedObjects.Items[0] as TExempleSeismicMaterial);
TMainFacade.GetInstance.ALLExempleSeismicMaterials.DeletedObjects.Clear;



for i:=0 to frmEditSMExemple.lstExempleCurrent.Count-1 do
begin
if (frmEditSMExemple.lstExempleCurrent.Items.Objects[i] as TExempleSeismicMaterial).ID<=0 then AddEx:=True else AddEx:=False;
if AddEx then
begin
EX:=TMainFacade.GetInstance.ALLExempleSeismicMaterials.Add as TExempleSeismicMaterial;
end
else
begin
EX:=TExempleSeismicMaterial.Create(TMainFacade.GetInstance.ALLExempleSeismicMaterials) as TExempleSeismicMaterial;
end;
EX.Assign(frmEditSMExemple.lstExempleCurrent.Items.Objects[i] as TExempleSeismicMaterial);
if AddEx then EX.ID:=EX.Update() else
begin
EX.Update();
TMainFacade.GetInstance.ALLExempleSeismicMaterials.ItemsByID[EX.ID].Assign(EX);
end;
for j:=0 to SeisElements.Count-1 do
if (frmEditSMExemple.lstExempleCurrent.Items.Objects[i] as TExempleSeismicMaterial).ID=SeisElements.Items[j].ExempleSeismicMaterial.ID then
begin
if SeisElements.Items[j].ID<=0 then AddEl:=True else AddEl:=False;
if AddEl then
begin
EL:=TMainFacade.GetInstance.ALLElementExemples.Add as TElementExemple;
end
else
begin
EL:=TElementExemple.Create(TMainFacade.GetInstance.ALLElementExemples) as TElementExemple;
end;
EL.Assign(SeisElements.Items[j]);
EL.ExempleSeismicMaterial.Assign(TMainFacade.GetInstance.ALLExempleSeismicMaterials.ItemsByID[EX.ID]);
if AddEl then EL.ID:=EL.Update() else
begin
EL.Update();
TMainFacade.GetInstance.ALLElementExemples.ItemsByID[EL.ID].Assign(EL);
end;
end;
end;
actSMSelectMaterialExempleExecute(frmEditSMExemple);
end;

procedure TfrmSMEdit.actSMAddProfileExecute(Sender: TObject);
begin
//переводим выбранный профиль в листбокс профилей отчета, и удаляем из списка нераспределенных профилей
frmEditSMSeisMaterial.lstProfileCurrent.Items.AddObject(TMainFacade.GetInstance.ALLSeismicProfiles.ItemsByID[(frmEditSMSeisMaterial.cbbProfile.Items.Objects[frmEditSMSeisMaterial.cbbProfile.ItemIndex] as TIDObject).ID].List,TMainFacade.GetInstance.ALLSeismicProfiles.ItemsByID[(frmEditSMSeisMaterial.cbbProfile.Items.Objects[frmEditSMSeisMaterial.cbbProfile.ItemIndex] as TIDObject).ID]);
frmEditSMSeisMaterial.cbbProfile.Items.Delete(frmEditSMSeisMaterial.cbbProfile.ItemIndex);
frmEditSMSeisMaterial.cbbProfile.ItemIndex:=-1;
frmEditSMSeisMaterial.cbbProfile.Text:='';
end;

procedure TfrmSMEdit.actSMAddSeisMatExecute(Sender: TObject);
var Add:Boolean;SM:TSeismicMaterial;i:Integer;SP:TSeismicProfile;
begin
if (CSM.ID=0) then Add:=True else Add:=False;//определяем создаем или редактируем отчет
if Add then SM:=TMainFacade.GetInstance.AllSeismicMaterials.Add as TSeismicMaterial
else
begin
SM:=TSeismicMaterial.Create(TMainFacade.GetInstance.AllSeismicMaterials) as TSeismicMaterial;
SM.Assign(TMainFacade.GetInstance.AllSeismicMaterials.ItemsByID[CSM.ID]);
end;
SM.BeginWorksDate:=frmEditSMSeisMaterial.dtpBeginWorks.Date;
SM.EndWorksDate:=frmEditSMSeisMaterial.dtpEndWorks.Date;
SM.ReferenceComposition:=frmEditSMSeisMaterial.edtRefComp.Text;
SM.StructMapReflectHorizon:=frmEditSMSeisMaterial.mmoStructMap.Text;
SM.CrossSection:=frmEditSMSeisMaterial.mmoCross.Text;
SM.SeisWorkScale:=StrToInt(frmEditSMSeisMaterial.edtScaleWorks.Text);
SM.SeisWorkType:=TMainFacade.GetInstance.AllSeisWorkTypes.ItemsByID[Integer(TSeisWorkType(frmEditSMSeisMaterial.cbbTypeWorks.Items.Objects[frmEditSMSeisMaterial.cbbTypeWorks.ItemIndex]).ID)] as TSeisWorkType;
SM.SeisWorkMethod:=TMainFacade.GetInstance.AllSeisWorkMethods.ItemsByID[Integer(TSeisWorkMethod(frmEditSMSeisMaterial.cbbMethodWorks.Items.Objects[frmEditSMSeisMaterial.cbbMethodWorks.ItemIndex]).ID)] as TSeisWorkMethod;
SM.SeisCrew:=TMainFacade.GetInstance.AllSeisCrews.ItemsByID[Integer(TSeisCrew(frmEditSMSeisMaterial.cbbSeisCrews.Items.Objects[frmEditSMSeisMaterial.cbbSeisCrews.ItemIndex]).ID)] as TSeisCrew;
SM.SimpleDocument:=TMainFacade.GetInstance.AllSimpleDocuments.ItemsByID[CSD.ID] as TSimpleDocument;
if Add then SM.ID:=SM.Update() else SM.Update();

actSMSelectMaterialSimpleDocExecute(frmEditSMSimpleDocument);//заготнит отчет в текущий отчет
if Add=False then
begin
(TMainFacade.GetInstance.AllSeismicMaterials.ItemsByID[SM.ID] as TSeismicMaterial).Assign(SM);
actSMSelectMaterialSimpleDocExecute(frmEditSMSimpleDocument);
end;

//если есть в списке привязаных профилей а связи не имеет,то привязываем
for i:=0 to frmEditSMSeisMaterial.lstProfileCurrent.Items.Count-1 do
if (not Assigned((TMainFacade.GetInstance.ALLSeismicProfiles.ItemsByID[(frmEditSMSeisMaterial.lstProfileCurrent.Items.Objects[i] as TSeismicProfile).ID] as TSeismicProfile).SeismicMaterial)) then
begin
(TMainFacade.GetInstance.ALLSeismicProfiles.ItemsByID[(frmEditSMSeisMaterial.lstProfileCurrent.Items.Objects[i] as TSeismicProfile).ID] as TSeismicProfile).SeismicMaterial:=(TMainFacade.GetInstance.AllSeismicMaterials.ItemsByID[SM.ID] as TSeismicMaterial);
(TMainFacade.GetInstance.ALLSeismicProfiles.ItemsByID[(frmEditSMSeisMaterial.lstProfileCurrent.Items.Objects[i] as TSeismicProfile).ID] as TSeismicProfile).Update();
end;

//среди профилей без связей, могут быть профиди без связи в коллекции, но со связью в БД, удаляем эту связь
for i:=0 to TMainFacade.GetInstance.ALLSeismicProfiles.Count-1 do
if (not Assigned(TMainFacade.GetInstance.ALLSeismicProfiles.Items[i].SeismicMaterial)) then
TMainFacade.GetInstance.ALLSeismicProfiles.Items[i].Update();

actSMSelectMaterialSeisMatExecute(frmEditSMSeisMaterial);
end;


procedure TfrmSMEdit.actSMBackExecute(Sender: TObject);
var butsel:Integer;
begin
 //переключение фреймов влево
{ butsel:=MessageDlg('Сохранить изменения?',mtConfirmation,[mbYes,mbNo,mbCancel],0 );
if butsel=mryes then
begin
Flag:=True;
actSMAddAllExecute(Sender);
Flag:=False;
end;
if butsel=mrcancel then Exit; }

if frmEditSMSeisMaterial.Visible=True then
begin
frmEditSMSimpleDocument.Visible:=True;
frmSMEdit.btnSMBack.Visible:=False;
frmEditSMSeisMaterial.Visible:=False;
end
else if frmEditSMMaterialBind.Visible=True then
begin
frmEditSMSeisMaterial.Visible:=True;
frmEditSMMaterialBind.Visible:=False;
frmSMEdit.btnSMGo.Visible:=True;
frmSMEdit.btnSMAddAll.Enabled:=False;
end;
{else if frmEditSMExemple.Visible=True then
begin
frmEditSMMaterialBind.Visible:=True;
frmSMEdit.btnSMGo.Visible:=True;
frmEditSMExemple.Visible:=False;
end;}
end;

procedure TfrmSMEdit.actSMBindKeyDownExecute(Sender: TObject;Key: Word);
var i:Integer;
begin
 //если нажат Enter и выбран тип привязки
if ((Key=13) and (frmEditSMMaterialBind.lstMaterialBind.ItemIndex<>-1)) then
begin
frmEditSMMaterialBind.lstObjectBindAll.Clear;
//добавить список объектов для привязки, Name которых начинается с указанной строки
for i := 0 to TMainFacade.GetInstance.BindingObjects[(frmEditSMMaterialBind.lstMaterialBind.Items.Objects[frmEditSMMaterialBind.lstMaterialBind.ItemIndex] as TObjectBindType).ID].Count - 1 do
if (Pos(AnsiLowerCase(frmEditSMMaterialBind.edtMaterialBind.Text),AnsiLowerCase(TMainFacade.GetInstance.BindingObjects[(frmEditSMMaterialBind.lstMaterialBind.Items.Objects[frmEditSMMaterialBind.lstMaterialBind.ItemIndex] as TObjectBindType).ID].Items[i].Name))>=1)  then
  frmEditSMMaterialBind.lstObjectBindAll.Items.AddObject(TMainFacade.GetInstance.BindingObjects[(frmEditSMMaterialBind.lstMaterialBind.Items.Objects[frmEditSMMaterialBind.lstMaterialBind.ItemIndex] as TObjectBindType).ID].Items[i].List, TMainFacade.GetInstance.BindingObjects[(frmEditSMMaterialBind.lstMaterialBind.Items.Objects[frmEditSMMaterialBind.lstMaterialBind.ItemIndex] as TObjectBindType).ID].Items[i]);
end;
end;

procedure TfrmSMEdit.actSMCloseExecute(Sender: TObject);
begin
frmSMEdit.Close;
end;

procedure TfrmSMEdit.actSMGoExecute(Sender: TObject);
var butsel:Integer;
begin
//переключение фреймов вправо
{if ((frmEditSMSimpleDocument.Visible=True) and (CSD.ID=0) and (frmEditSMSimpleDocument.chkAddSimpleDoc.Checked=True)) then
begin
butsel:=MessageDlg('Необходимо сохранить изменения.Сохранить?',mtConfirmation,[mbYes,mbNo,mbCancel],0 );
if butsel=mryes then
begin}
Flag:=True;
actSMAddAllExecute(Sender);
Flag:=False;
{end;
if butsel=mrcancel then Exit;
end;

if ((frmEditSMMaterialBind.Visible=True) and (CSM.ID=0)) then
begin
butsel:=MessageDlg('Необходимо сохранить изменения.Сохранить?',mtConfirmation,[mbYes,mbNo,mbCancel],0 );
if butsel=mryes then
begin }
Flag:=True;
actSMAddAllExecute(Sender);
Flag:=False;
{end;
if butsel=mrcancel then Exit;
end; }

if ((frmEditSMSimpleDocument.Visible=True) and (CSD.ID<>0)) then
begin
actSMSelectMaterialSeisMatExecute(frmEditSMSeisMaterial);
frmEditSMSeisMaterial.Visible:=True;
frmSMEdit.btnSMBack.Visible:=True;
frmEditSMSimpleDocument.Visible:=False;
end
else
if frmEditSMSeisMaterial.Visible=True then
begin
actSMSelectMaterialBindExecute(frmEditSMMaterialBind);
frmEditSMMaterialBind.Visible:=True;
frmEditSMSeisMaterial.Visible:=False;
frmSMEdit.btnSMGo.Visible:=False;
frmSMEdit.btnSMAddAll.Enabled:=True;
end;
{else if ((frmEditSMMaterialBind.Visible=True) and (CSM.ID<>0)) then
begin
actSMSelectMaterialExempleExecute(frmEditSMExemple);
frmEditSMExemple.Visible:=True;
frmSMEdit.btnSMGo.Visible:=False;
frmEditSMMaterialBind.Visible:=False;
end; }
end;

procedure TfrmSMEdit.actSMSelectMaterialExempleExecute(Sender: TObject);
var i,j:Integer;ob:TExempleSeismicMaterial;ob2:TElementExemple;
begin
SeisExemples.Clear;
SeisElements.Clear;
frmEditSMExemple.cbbSelectMaterial.ItemIndex:=frmEditSMSimpleDocument.cbbSelectMaterial.ItemIndex;
frmEditSMExemple.cbbSelectMaterial.Enabled:=False;
frmEditSMExemple.lstExempleCurrent.Clear;
frmEditSMExemple.lstElement.Clear;
frmEditSMExemple.cbbTypeExemple.ItemIndex:=-1;
frmEditSMExemple.cbbLocExemple.ItemIndex:=-1;
frmEditSMExemple.cbbTypeElement.ItemIndex:=-1;
frmEditSMExemple.edtCountExemple.Text:='';
frmEditSMExemple.edtCommentExemple.Text:='';
frmEditSMExemple.edtNumberElement.Text:='';
frmEditSMExemple.edtCommentElement.Text:='';
for i:=0 to TMainFacade.GetInstance.ALLExempleSeismicMaterials.Count-1 do
if (TMainFacade.GetInstance.ALLExempleSeismicMaterials.Items[i].SeismicMaterial.ID=CSM.ID) then
begin
frmEditSMExemple.lstExempleCurrent.Items.AddObject(TMainFacade.GetInstance.ALLExempleSeismicMaterials.Items[i].List,TMainFacade.GetInstance.ALLExempleSeismicMaterials.Items[i] as TExempleSeismicMaterial);
ob:=SeisExemples.Add  as TExempleSeismicMaterial;
ob.Assign(TMainFacade.GetInstance.ALLExempleSeismicMaterials.Items[i] as TExempleSeismicMaterial);
for j:=0 to TMainFacade.GetInstance.ALLElementExemples.Count-1 do
begin
if (TMainFacade.GetInstance.ALLExempleSeismicMaterials.Items[i].ID=TMainFacade.GetInstance.ALLElementExemples.Items[j].ExempleSeismicMaterial.ID) then
begin
ob2:=SeisElements.Add as TElementExemple;
ob2.Assign(TMainFacade.GetInstance.ALLElementExemples.Items[j] as TElementExemple);
end;
end;
end;
end;

procedure TfrmSMEdit.actSMSelectBindTypeExecute(Sender: TObject);
var cob1:TSimpleAreas;i,j:Integer;
begin
  //для того чтобы отрабатывало по клику мыши на типе привязки
  frmEditSMMaterialBind.lstObjectBindAll.Clear;
  actSMBindKeyDownExecute(Self.frmEditSMMaterialBind.edtMaterialBind,13);
end;

procedure TfrmSMEdit.actSMSelectBindTypesExecute(Sender: TObject);
begin
frmEditSMMaterialBind.lstObjectBindAll.Items.Clear;
end;

procedure TfrmSMEdit.actSMSelectMaterialBindExecute(Sender: TObject);
var i:Integer;
begin
//выводим привязки текущего материала
frmEditSMMaterialBind.cbbSelectMaterial.ItemIndex:=frmEditSMSimpleDocument.cbbSelectMaterial.ItemIndex;
frmEditSMMaterialBind.cbbSelectMaterial.Enabled:=False;
frmEditSMMaterialBind.lstObjectBindCurrent.Clear;
for  i:=0 to TMainFacade.GetInstance.AllMaterialBindings.Count-1 do
if Assigned(TMainFacade.GetInstance.AllMaterialBindings.Items[i].SimpleDocument) then
if (TMainFacade.GetInstance.AllMaterialBindings.Items[i].SimpleDocument.ID=CSD.ID) then
frmEditSMMaterialBind.lstObjectBindCurrent.Items.AddObject(TMainFacade.GetInstance.AllMaterialBindings.Items[i].ObjectBindType.Name+':   '+TMainFacade.GetInstance.BindingObjects[TMainFacade.GetInstance.AllMaterialBindings.Items[i].ObjectBindType.ID].ItemsByID[TMainFacade.GetInstance.AllMaterialBindings.Items[i].ID].Name,TMainFacade.GetInstance.BindingObjects[TMainFacade.GetInstance.AllMaterialBindings.Items[i].ObjectBindType.ID].ItemsByID[TMainFacade.GetInstance.AllMaterialBindings.Items[i].ID])
end;

procedure TfrmSMEdit.actSMSelectMaterialSeisMatExecute(Sender: TObject);
var i:Integer;
begin
frmEditSMSeisMaterial.cbbSelectMaterial.ItemIndex:=frmEditSMSimpleDocument.cbbSelectMaterial.ItemIndex;
frmEditSMSeisMaterial.cbbSelectMaterial.Enabled:=False;

frmEditSMSeisMaterial.dtpBeginWorks.Date:=CSM.BeginWorksDate;
frmEditSMSeisMaterial.dtpEndWorks.Date:=CSM.EndWorksDate;
if Assigned(CSM.SeisWorkType) then
begin
for i:=0 to frmEditSMSeisMaterial.cbbTypeWorks.Items.Count-1 do
if  (frmEditSMSeisMaterial.cbbTypeWorks.Items.Objects[i] as TSeisWorkType).ID=CSM.SeisWorkType.ID then
begin
frmEditSMSeisMaterial.cbbTypeWorks.ItemIndex:=i;
Break;
end;
end
else
frmEditSMSeisMaterial.cbbTypeWorks.ItemIndex:=-1;
if Assigned(CSM.SeisWorkMethod) then
begin
for i:=0 to frmEditSMSeisMaterial.cbbMethodWorks.Items.Count-1 do
if  (frmEditSMSeisMaterial.cbbMethodWorks.Items.Objects[i] as TSeisWorkMethod).ID=CSM.SeisWorkMethod.ID then
begin
frmEditSMSeisMaterial.cbbMethodWorks.ItemIndex:=i;
Break;
end;
end
else
frmEditSMSeisMaterial.cbbMethodWorks.ItemIndex:=-1;
if Assigned(CSM.SeisCrew) then
begin
for i:=0 to frmEditSMSeisMaterial.cbbSeisCrews.Items.Count-1 do
if  (frmEditSMSeisMaterial.cbbSeisCrews.Items.Objects[i] as TSeisCrew).ID=CSM.SeisCrew.ID then
begin
frmEditSMSeisMaterial.cbbSeisCrews.ItemIndex:=i;
Break;
end;
end
else
frmEditSMSeisMaterial.cbbSeisCrews.ItemIndex:=-1;

frmEditSMSeisMaterial.edtScaleWorks.Text:=IntToStr(CSM.SeisWorkScale);
frmEditSMSeisMaterial.edtRefComp.Text:=CSM.ReferenceComposition;
frmEditSMSeisMaterial.mmoStructMap.Text:=CSM.StructMapReflectHorizon;
frmEditSMSeisMaterial.mmoCross.Text:=CSM.CrossSection;

frmEditSMSeisMaterial.lstProfileCurrent.Clear;
frmEditSMSeisMaterial.cbbProfile.Clear;
for i:=0 to TMainFacade.GetInstance.ALLSeismicProfiles.Count-1 do
if (not Assigned(TMainFacade.GetInstance.ALLSeismicProfiles.Items[i].SeismicMaterial)) then
frmEditSMSeisMaterial.cbbProfile.Items.AddObject(TMainFacade.GetInstance.ALLSeismicProfiles.Items[i].List,TMainFacade.GetInstance.ALLSeismicProfiles.Items[i] as TSeismicProfile);


for i:=0 to TMainFacade.GetInstance.ALLSeismicProfiles.Count-1 do
if Assigned(TMainFacade.GetInstance.ALLSeismicProfiles.Items[i].SeismicMaterial) then
if (TMainFacade.GetInstance.ALLSeismicProfiles.Items[i].SeismicMaterial.ID=CSM.ID) then
begin
  frmEditSMSeisMaterial.lstProfileCurrent.Items.AddObject(IntToStr(TMainFacade.GetInstance.ALLSeismicProfiles.Items[i].SeisProfileNumber), TMainFacade.GetInstance.ALLSeismicProfiles.Items[i] as TSeismicProfile);
end;
end;

procedure TfrmSMEdit.actUpElementExecute(Sender: TObject);
var i:Integer;
begin
for i:=0 to SeisElements.Count-1 do
if SeisElements.Items[i].ID=(frmEditSMExemple.lstElement.Items.Objects[frmEditSMExemple.lstElement.ItemIndex] as TElementExemple).ID then
begin
SeisElements.Items[i].ExempleSeismicMaterial:=frmEditSMExemple.lstExempleCurrent.Items.Objects[frmEditSMExemple.lstExempleCurrent.ItemIndex] as TExempleSeismicMaterial;
SeisElements.Items[i].ElementType:=TMainFacade.GetInstance.AllElementTypes.ItemsById[(frmEditSMExemple.cbbTypeElement.Items.Objects[frmEditSMExemple.cbbTypeElement.ItemIndex] as TElementType).ID] as TElementType;
SeisElements.Items[i].ElementNumber:=StrToInt(frmEditSMExemple.edtNumberElement.Text);
SeisElements.Items[i].ElementComment:=frmEditSMExemple.edtCommentElement.Text;
SeisElements.Items[i].Name:=frmEditSMExemple.edtNameElement.Text;
SeisElements.Items[i].ElementLocation:=frmEditSMExemple.edtLocationElement.Text;
frmEditSMExemple.lstElement.Items.Objects[frmEditSMExemple.lstElement.ItemIndex]:=SeisElements.Items[i] as TElementExemple;
frmEditSMExemple.lstElement.Items.Strings[frmEditSMExemple.lstElement.ItemIndex]:=SeisElements.Items[i].List;
end;
end;

procedure TfrmSMEdit.actUpExempleExecute(Sender: TObject);
var i:Integer;
begin
for i:=0 to SeisExemples.Count-1 do
if SeisExemples.Items[i].ID=(frmEditSMExemple.lstExempleCurrent.Items.Objects[frmEditSMExemple.lstExempleCurrent.ItemIndex] as TExempleSeismicMaterial).ID then
begin
SeisExemples.Items[i].ExempleSum:=StrToInt(frmEditSMExemple.edtCountExemple.Text);
SeisExemples.Items[i].ExempleComment:=frmEditSMExemple.edtCommentExemple.Text;
SeisExemples.Items[i].ExempleLocation:=TMainFacade.GetInstance.AllExempleLocations.ItemsById[(frmEditSMExemple.cbbLocExemple.Items.Objects[frmEditSMExemple.cbbLocExemple.ItemIndex] as TExempleLocation).ID] as TExempleLocation;
SeisExemples.Items[i].ExempleType:=TMainFacade.GetInstance.AllExempleTypes.ItemsById[(frmEditSMExemple.cbbTypeExemple.Items.Objects[frmEditSMExemple.cbbTypeExemple.ItemIndex] as TExempleType).ID] as TExempleType;
SeisExemples.Items[i].SeismicMaterial:=TMainFacade.GetInstance.AllSeismicMaterials.ItemsById[CSM.ID] as TSeismicMaterial;
frmEditSMExemple.lstExempleCurrent.Items.Objects[frmEditSMExemple.lstExempleCurrent.ItemIndex]:=SeisExemples.Items[i] as TExempleSeismicMaterial;
frmEditSMExemple.lstExempleCurrent.Items.Strings[frmEditSMExemple.lstExempleCurrent.ItemIndex]:=SeisExemples.Items[i].List;
//frmEditSMExemple.lstExempleCurrent.Items.AddObject(SeisExemples.Items[i].List,SeisExemples.Items[i] as TExempleSeismicMaterial);
end;
end;

procedure TfrmSMEdit.frmEditSMMaterialBindedtMaterialBindKeyDown(
  Sender: TObject; var Key: Word; Shift: TShiftState);
begin
//отслеживаем Enter
actSMBindKeyDownExecute(Self.frmEditSMMaterialBind.edtMaterialBind,Key);
end;

procedure TfrmSMEdit.frmEditSMMaterialBindedtMaterialBindKeyUp(Sender: TObject; var
    Key: Word; Shift: TShiftState);
begin
actSMBindKeyDownExecute(Self.frmEditSMMaterialBind.edtMaterialBind,13);
end;

procedure TfrmSMEdit.frmEditSMMaterialBindlstObjectBindCurrentMouseDown(Sender:
    TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 //для контекстного меню, чтобы выбирало строку правой кнопкой
frmEditSMMaterialBind.lstObjectBindCurrent.ItemIndex:=frmEditSMMaterialBind.lstObjectBindCurrent.ItemAtPos(Point(x,y),True);
end;

procedure TfrmSMEdit.frmEditSMSeisMateriallstProfileCurrentMouseDown(Sender:
    TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  //для контекстного меню, чтобы выбирало строку правой кнопкой
frmEditSMSeisMaterial.lstProfileCurrent.ItemIndex:=frmEditSMSeisMaterial.lstProfileCurrent.ItemAtPos(Point(x,y),True);
end;

procedure TfrmSMEdit.frmEditSMSimpleDocumentcbbSelectMaterialKeyUp(Sender:
    TObject; var Key: Word; Shift: TShiftState);
begin
if Key=13 then
actSearchSDExecute(frmEditSMSimpleDocument.cbbSelectMaterial);
end;

procedure TfrmSMEdit.frmEditSMSimpleDocumentedtSearhAuthorKeyUp(Sender:
    TObject; var Key: Word; Shift: TShiftState);
begin
actSearchAuthorExecute(frmEditSMSimpleDocument.edtSearhAuthor);
end;



end.
