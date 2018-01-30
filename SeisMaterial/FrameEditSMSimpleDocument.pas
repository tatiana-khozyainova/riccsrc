unit FrameEditSMSimpleDocument;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ActnList, ComCtrls, CheckLst, Material, Employee,Organization;

type
  TFrame3 = class(TFrame)
    cbbSelectMaterial: TComboBox;
    txtSelectMaterial: TStaticText;
    chkAddSimpleDoc: TCheckBox;
    edtInventNumber: TEdit;
    edtTGFNumber: TEdit;
    dtpCreationDate: TDateTimePicker;
    edtCommentSimpleDoc: TEdit;
    txtInventNumber: TStaticText;
    txtTGFNumber: TStaticText;
    txtNameSimpleDoc: TStaticText;
    txtCreationDate: TStaticText;
    txtCommentSimpleDoc: TStaticText;
    edtLocationPath: TEdit;
    txtLocationPath: TStaticText;
    chklstAuthorOurs: TCheckListBox;
    cbbOrganization: TComboBox;
    cbbLocation: TComboBox;
    txtOrganization: TStaticText;
    txtLocation: TStaticText;
    chklstAuthorOutsides: TCheckListBox;
    btnAddSimpleDoc: TButton;
    edtSearhAuthor: TEdit;
    grp1: TGroupBox;
    grp2: TGroupBox;
    edtNameSimpleDoc: TMemo;
    grp3: TGroupBox;
    procedure actAddSimpleDocExecute(Sender: TObject);
    procedure actSelectMaterialOnSelectExecute(Sender: TObject);
    procedure actMaterialBindKeyUpExecute(Sender: TObject);
    procedure actTestExecute(Sender: TObject);
    procedure chklstAuthorOursMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  

  private
    { Private declarations }
  //FCSD:TSimpleDocument;
  public
    { Public declarations }
  //property CSD:TSimpleDocument read FCSD write FCSD;
  end;

implementation

uses Facade, MaterialPoster, EmployeePoster, OrganizationPoster;

{$R *.dfm}





procedure TFrame3.actAddSimpleDocExecute(Sender: TObject);
var ob1:TSimpleDocument;ob2:TMaterialAuthor;i:Integer;str_autors:string;
begin
  {
//CSD:=TSimpleDocument.Create(TMainFacade.GetInstance.AllSimpleDocuments) as TSimpleDocument;

if chkAddSimpleDoc.Checked then CSD.ID:=0
//else CSD.ID:=Integer(TSimpleDocument(cbbSelectMaterial.Items.Objects[cbbSelectMaterial.ItemIndex]).ID);
else CSD.Assign(TMainFacade.GetInstance.AllSimpleDocuments.ItemsByID[Integer(TSimpleDocument(cbbSelectMaterial.Items.Objects[cbbSelectMaterial.ItemIndex]).ID)]);
CSD.Name:=edtNameSimpleDoc.Text;
CSD.InventNumber:=StrToInt(edtInventNumber.Text);
CSD.TGFNumber:=StrToInt(edtTGFNumber.Text);
CSD.MaterialComment:=edtCommentSimpleDoc.Text;
CSD.CreationDate:=dtpCreationDate.Date;
CSD.EnteringDate:=Now;
CSD.VCHLocation:='fdhgsdfgjdsgf';
CSD.MaterialLocation:=TMainFacade.GetInstance.AllMaterialLocations.ItemsByID[Integer(TMaterialLocation(cbbLocation.Items.Objects[cbbLocation.ItemIndex]).ID)] as TMaterialLocation;
CSD.DocType:=TMainFacade.GetInstance.AllDocumentTypes.ItemsByID[70] as TDocumentType;
CSD.Organization:=TMainFacade.GetInstance.AllOrganizations.ItemsByID[Integer(TOrganization(cbbOrganization.Items.Objects[cbbOrganization.ItemIndex]).ID)] as TOrganization;
CSD.Employee:=TMainFacade.GetInstance.AllEmployees.ItemsByID[148] as TEmployee;
CSD.Update();
TMainFacade.GetInstance.AllSimpleDocuments.ItemsByID[CSD.ID].Assign(CSD);
ob2:=TMaterialAuthor.Create(TMainFacade.GetInstance.AllMaterialAuthors) as TMaterialAuthor;
for i:=0 to chklstAuthorOurs.Count-1 do
begin
  if chklstAuthorOurs.Checked[i] then
  begin
  ob2.SimpleDocument:=CSD;
  ob2.EmployeeID:=Integer(TEmployeeOur(chklstAuthorOurs.Items.Objects[i]).ID);
  ob2.RoleID:=0;
  ob2.Update();
  str_autors:=str_autors+ ','+TEmployeeOur(chklstAuthorOurs.Items.Objects[i]).Name;
  end;
end;
for i:=0 to chklstAuthorOutsides.Count-1 do
begin
  if chklstAuthorOutsides.Checked[i] then
  begin
  ob2.SimpleDocument:=CSD;
  ob2.EmployeeID:=Integer(TEmployeeOutside(chklstAuthorOutsides.Items.Objects[i]).ID);
  ob2.RoleID:=1;
  ob2.Update();
  str_autors:=str_autors+ ','+TEmployeeOutside(chklstAuthorOutsides.Items.Objects[i]).Name;
  end;
end;
ob1.Authors:=Copy(str_autors,2,Length(str_autors));
ob1.Update();
TMainFacade.GetInstance.AllSimpleDocuments.ItemsByID[CSD.ID].Assign(CSD);
ob1.Free;
ob2.Free; }
end;

procedure TFrame3.actSelectMaterialOnSelectExecute(Sender: TObject);
var ob1:TSimpleDocument;i:Integer;
begin
  {
//CSD:=TSimpleDocument.Create(TMainFacade.GetInstance.AllSimpleDocuments) as TSimpleDocument;
CSD.Assign(TMainFacade.GetInstance.AllSimpleDocuments.ItemsByID[Integer(TSimpleDocument(cbbSelectMaterial.Items.Objects[cbbSelectMaterial.ItemIndex]).ID)]);
edtNameSimpleDoc.Text:=CSD.Name;
edtInventNumber.Text:=IntToStr(CSD.InventNumber);
edtTGFNumber.Text:=IntToStr(CSD.TGFNumber);
edtCommentSimpleDoc.Text:=CSD.MaterialComment;
dtpCreationDate.Date:=CSD.CreationDate;
edtLocationPath.Text:=CSD.VCHLocation;
if Assigned(CSD.Organization) then
begin
for i:=0 to cbbOrganization.Items.Count do
if  (cbbOrganization.Items.Objects[i] as TOrganization).ID=CSD.Organization.ID then
begin
cbbOrganization.ItemIndex:=i;
Break;
end;
end
else
cbbOrganization.ItemIndex:=-1;
if Assigned(CSD.MaterialLocation) then
begin
for i:=0 to cbbOrganization.Items.Count do
if  (cbbLocation.Items.Objects[i] as TMaterialLocation).ID=CSD.MaterialLocation.ID then
begin
cbbLocation.ItemIndex:=i;
Break;
end;
end
else
cbbLocation.ItemIndex:=-1;
//ob1.MaterialLocation:=TMainFacade.GetInstance.AllMaterialLocations.ItemsByID[Integer(TMaterialLocation(cbbLocation.Items.Objects[cbbLocation.ItemIndex]).ID)] as TMaterialLocation;
//ob1.DocType:=TMainFacade.GetInstance.AllDocumentTypes.ItemsByID[70] as TDocumentType;
//ob1.Organization:=TMainFacade.GetInstance.AllOrganizations.ItemsByID[Integer(TOrganization(cbbOrganization.Items.Objects[cbbOrganization.ItemIndex]).ID)] as TOrganization;
//ob1.Employee:=TMainFacade.GetInstance.AllEmployees.ItemsByID[148] as TEmployee;     }
end;

procedure TFrame3.actMaterialBindKeyUpExecute(Sender: TObject);
var i:Integer;
begin
 i:=2;

end;

procedure TFrame3.actTestExecute(Sender: TObject);
begin
 if chklstAuthorOurs.Checked[chklstAuthorOurs.ItemIndex]=False then ShowMessage('123');
end;

procedure TFrame3.chklstAuthorOursMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 if chklstAuthorOurs.Checked[chklstAuthorOurs.ItemIndex]=False then ShowMessage('123');
end;

end.
