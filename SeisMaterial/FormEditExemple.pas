unit FormEditExemple;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrameEditSMExemple, StdCtrls, FormEvent, Material, SeisExemple, SeisMaterial,
  ActnList;

type
  TfrmEditExemple = class(TForm)
    btnSMAddExemple: TButton;
    btnClose: TButton;
    frmEditSMExemple: TFrame6;
    actlst1: TActionList;
    actClose: TAction;
    actSMSelectMaterialSimpleDoc: TAction;
    actSMSelectMaterialExemple: TAction;
    actSelectExemple: TAction;
    actSelectElement: TAction;
    actAddExemple: TAction;
    actUpExemple: TAction;
    actDelExemple: TAction;
    actAddElement: TAction;
    actUpElement: TAction;
    actDelElement: TAction;
    actSMAddExemple: TAction;
    procedure actAddElementExecute(Sender: TObject);
    procedure actAddExempleExecute(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure actDelElementExecute(Sender: TObject);
    procedure actDelExempleExecute(Sender: TObject);
    procedure actSelectElementExecute(Sender: TObject);
    procedure actSelectExempleExecute(Sender: TObject);
    procedure actSMAddExempleExecute(Sender: TObject);
    procedure actSMSelectMaterialExempleExecute(Sender: TObject);
    procedure actSMSelectMaterialSimpleDocExecute(Sender: TObject);
    procedure actUpElementExecute(Sender: TObject);
    procedure actUpExempleExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    FOnMyEvent:TMyEvent;
    FCSD:TSimpleDocument;
  FCSM:TSeismicMaterial;
  FSeisExemples:TExempleSeismicMaterials;
  FSeisElements:TElementExemples;
  public
    { Public declarations }
  property OnMyEvent:TMyEvent read FOnMyEvent write FOnMyEvent;
  property CSD:TSimpleDocument read FCSD write FCSD;//текущий материал
  property CSM:TSeismicMaterial read FCSM write FCSM;//текущий отчет(сейсм.материал)
  property SeisExemples:TExempleSeismicMaterials read FSeisExemples write FSeisExemples;
  property SeisElements:TElementExemples read FSeisElements write FSeisElements;
  end;

var
  frmEditExemple: TfrmEditExemple;

implementation

uses Facade;
{$R *.dfm}

procedure TfrmEditExemple.actAddElementExecute(Sender: TObject);
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

procedure TfrmEditExemple.actAddExempleExecute(Sender: TObject);
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

procedure TfrmEditExemple.actCloseExecute(Sender: TObject);
begin
frmEditExemple.Close;
end;

procedure TfrmEditExemple.actDelElementExecute(Sender: TObject);
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

procedure TfrmEditExemple.actDelExempleExecute(Sender: TObject);
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

procedure TfrmEditExemple.actSelectElementExecute(Sender: TObject);
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

procedure TfrmEditExemple.actSelectExempleExecute(Sender: TObject);
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

procedure TfrmEditExemple.actSMAddExempleExecute(Sender: TObject);
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
if Assigned(FOnMyEvent) then FOnMyEvent(Sender);
Close;
end;

procedure TfrmEditExemple.actSMSelectMaterialExempleExecute(Sender: TObject);
var i,j:Integer;ob:TExempleSeismicMaterial;ob2:TElementExemple;
begin
SeisExemples.Clear;
SeisElements.Clear;

//frmEditSMExemple.cbbSelectMaterial.Enabled:=False;
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

procedure TfrmEditExemple.actSMSelectMaterialSimpleDocExecute(Sender: TObject);
var i:Integer;
begin
CSD.Assign(TMainFacade.GetInstance.AllSimpleDocuments.ItemsByID[Integer(TSimpleDocument(frmEditSMExemple.cbbSelectMaterial.Items.Objects[frmEditSMExemple.cbbSelectMaterial.ItemIndex]).ID)]);
//провер€ем есть ли у материала св€занный с ним отчет(сейс.материал)
for i:=0 to TMainFacade.GetInstance.AllSeismicMaterials.Count-1 do
if CSD.ID=TMainFacade.GetInstance.AllSeismicMaterials.Items[i].SimpleDocument.ID then
begin
CSM.Assign(TMainFacade.GetInstance.AllSeismicMaterials.Items[i] as TSeismicMaterial);//если есть заполн€ем текущий отчет
Break;
end;
actSMSelectMaterialExempleExecute(frmEditExemple);
end;

procedure TfrmEditExemple.actUpElementExecute(Sender: TObject);
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

procedure TfrmEditExemple.actUpExempleExecute(Sender: TObject);
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

procedure TfrmEditExemple.FormActivate(Sender: TObject);
begin
CSD:=TSimpleDocument.Create(TMainFacade.GetInstance.AllSimpleDocuments) as TSimpleDocument;
CSM:=TSeismicMaterial.Create(TMainFacade.GetInstance.AllSeismicMaterials) as TSeismicMaterial;

SeisExemples:=TExempleSeismicMaterials.Create;
SeisElements:=TElementExemples.Create;

end;

end.
