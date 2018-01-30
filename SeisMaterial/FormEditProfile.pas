unit FormEditProfile;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrameEditProfile, ActnList,SeisProfile,SeisMaterial,FormEvent,
  StdCtrls;

type
  TfrmEditProfile = class(TForm)
    frmEditAllProfile: TFrame8;
    actlstEditProfile: TActionList;
    actCheckProfile: TAction;
    actSelectProfile: TAction;
    actAddProfile: TAction;
    actUpProfile: TAction;
    actDelProfile: TAction;
    btnSPAdd: TButton;
    actAddCoord: TAction;
    actUpCoord: TAction;
    actSelectCoord: TAction;
    actDelCoord: TAction;
    actSPAdd: TAction;
    btn1: TButton;
    procedure actAddCoordExecute(Sender: TObject);
    procedure actAddProfileExecute(Sender: TObject);
    procedure actCheckProfileExecute(Sender: TObject);
    procedure actDelCoordExecute(Sender: TObject);
    procedure actDelProfileExecute(Sender: TObject);
    procedure actSelectCoordExecute(Sender: TObject);
    procedure actSelectProfileExecute(Sender: TObject);
    procedure actSPAddExecute(Sender: TObject);
    procedure actUpCoordExecute(Sender: TObject);
    procedure actUpProfileExecute(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure ClearForm;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    FOnMyEvent:TMyEvent;
    FSeisProfiles:TSeismicProfiles;
    FSeisProfileCoords:TSeismicProfileCoordinates;
  public
    { Public declarations }
    property OnMyEvent:TMyEvent read FOnMyEvent write FOnMyEvent;
    property SeisProfiles:TSeismicProfiles read FSeisProfiles write FSeisProfiles;
    property SeisProfileCoords:TSeismicProfileCoordinates read FSeisProfileCoords write FSeisProfileCoords;
  end;

var
  frmEditProfile: TfrmEditProfile;

implementation

{$R *.dfm}
uses Facade;

procedure TfrmEditProfile.actAddCoordExecute(Sender: TObject);
var spc:TSeismicProfileCoordinate;i,m:Integer;
begin
spc:=SeisProfileCoords.Add as TSeismicProfileCoordinate;
m:=SeisProfileCoords.Items[0].ID;
for i:=1 to SeisProfileCoords.Count-1 do
if SeisProfileCoords.Items[i].ID<m then m:=SeisProfileCoords.Items[i].ID;
if m>0 then spc.ID:=-1 else spc.ID:=m-1;
spc.SeismicProfile:=frmEditAllProfile.cbbSelectProfile.Items.Objects[frmEditAllProfile.cbbSelectProfile.ItemIndex] as TSeismicProfile;

spc.CoordNumber:=StrToInt(frmEditAllProfile.edtNumberCoord.Text);
spc.CoordX:=StrToFloat(frmEditAllProfile.edtCoordX.Text);
spc.CoordY:=StrToFloat(frmEditAllProfile.edtCoordY.Text);
frmEditAllProfile.lstCoordProfile.Items.AddObject(spc.List,spc as TSeismicProfileCoordinate);
end;

procedure TfrmEditProfile.actAddProfileExecute(Sender: TObject);
var sp:TSeismicProfile;i,m:Integer;
begin
  sp:=SeisProfiles.Add as TSeismicProfile;
  m:=SeisProfiles.Items[0].ID;
  for i:=1 to SeisProfiles.Count-1 do
  if SeisProfiles.Items[i].ID<m then m:=SeisProfiles.Items[i].ID;
  if m>0 then sp.ID:=-1 else sp.ID:=m-1;
  sp.SeisProfileNumber:=StrToInt(frmEditAllProfile.edtNumberProfile.Text);
  sp.PiketBegin:=StrToInt(frmEditAllProfile.edtBeginPiket.Text);
  sp.PiketEnd:=StrToInt(frmEditAllProfile.edtEndPiket.Text);
  sp.SeisProfileLenght:=StrToFloat(frmEditAllProfile.edtLengthProfile.Text);
  sp.DateEntry:=Now;
  sp.SeisProfileComment:=frmEditAllProfile.edtCommentProfile.Text;
  if frmEditAllProfile.cbbSeisMaterial.ItemIndex<>-1 then
  sp.SeismicMaterial:=TMainFacade.GetInstance.AllSeismicMaterials.ItemsByID[Integer(TSeismicMaterial(frmEditAllProfile.cbbSeisMaterial.Items.Objects[frmEditAllProfile.cbbSeisMaterial.ItemIndex]).ID)] as TSeismicMaterial;
  sp.SeismicProfileType:=TMainFacade.GetInstance.AllSeismicProfileTypes.ItemsByID[Integer(TSeismicProfileType(frmEditAllProfile.cbbTypeProfile.Items.Objects[frmEditAllProfile.cbbTypeProfile.ItemIndex]).ID)] as TSeismicProfileType;
  //TMainFacade.GetInstance.ALLSeismicProfiles.Add(sp);
  //sp.ID:=sp.Update();
  //TMainFacade.GetInstance.ALLSeismicProfiles.ItemsById[Integer(sp.ID)].Assign(sp);
  //if Assigned(FOnMyEvent) then FOnMyEvent(Sender);
  //actCheckProfileExecute(frmEditAllProfile);
  //actCheckProfileExecute(frmEditAllProfile);
  ClearForm;
  frmEditAllProfile.cbbSelectProfile.Items.AddObject(sp.List,sp as TSeismicProfile);
  frmEditAllProfile.cbbSelectProfile.ItemIndex:=frmEditAllProfile.cbbSelectProfile.Items.Count-1;
  actSelectProfileExecute(frmEditAllProfile);
end;

procedure TfrmEditProfile.actCheckProfileExecute(Sender: TObject);
var i:Integer;
begin
if frmEditAllProfile.rgProfile.ItemIndex=0 then
begin
frmEditAllProfile.cbbSelectProfile.Clear;
TMainFacade.GetInstance.ALLSeismicProfiles.MakeList(frmEditAllProfile.cbbSelectProfile.Items);
end
else
begin
frmEditAllProfile.cbbSelectProfile.Clear;
for i:=0 to TMainFacade.GetInstance.ALLSeismicProfiles.Count-1 do
if (not Assigned(TMainFacade.GetInstance.ALLSeismicProfiles.Items[i].SeismicMaterial)) then
frmEditAllProfile.cbbSelectProfile.Items.AddObject(TMainFacade.GetInstance.ALLSeismicProfiles.Items[i].List,TMainFacade.GetInstance.ALLSeismicProfiles.Items[i] as TSeismicProfile);
end;
ClearForm;
end;

procedure TfrmEditProfile.actDelCoordExecute(Sender: TObject);
begin
if ((frmEditAllProfile.lstCoordProfile.Items.Objects[frmEditAllProfile.lstCoordProfile.ItemIndex] as TSeismicProfileCoordinate).ID)<=0 then
SeisProfileCoords.MarkDeleted(SeisProfileCoords.ItemsByID[(frmEditAllProfile.lstCoordProfile.Items.Objects[frmEditAllProfile.lstCoordProfile.ItemIndex] as TSeismicProfileCoordinate).ID] as TSeismicProfileCoordinate)
else
begin
SeisProfileCoords.MarkDeleted(SeisProfileCoords.ItemsByID[(frmEditAllProfile.lstCoordProfile.Items.Objects[frmEditAllProfile.lstCoordProfile.ItemIndex] as TSeismicProfileCoordinate).ID] as TSeismicProfileCoordinate)
//TMainFacade.GetInstance.AllSeismicProfileCoordinates.MarkDeleted(TMainFacade.GetInstance.AllSeismicProfileCoordinates.ItemsByID[(frmEditAllProfile.lstCoordProfile.Items.Objects[frmEditSMExemple.lstElement.ItemIndex] as TElementExemple).ID] as TElementExemple)
end;
frmEditAllProfile.lstCoordProfile.DeleteSelected;
end;

procedure TfrmEditProfile.actDelProfileExecute(Sender: TObject);
var i:Integer;
begin
if (frmEditAllProfile.cbbSelectProfile.Items.Objects[frmEditAllProfile.cbbSelectProfile.ItemIndex] as TSeismicProfile).ID>0 then
for i:=0 to TMainFacade.GetInstance.ALLSeismicProfiles.Count-1 do
if TMainFacade.GetInstance.ALLSeismicProfiles.Items[i].ID=(frmEditAllProfile.cbbSelectProfile.Items.Objects[frmEditAllProfile.cbbSelectProfile.ItemIndex] as TSeismicProfile).ID then
begin
TMainFacade.GetInstance.ALLSeismicProfiles.MarkDeleted(i);
Break;
end;
frmEditAllProfile.cbbSelectProfile.DeleteSelected;
frmEditAllProfile.lstCoordProfile.Clear;
ClearForm;
end;

procedure TfrmEditProfile.actSelectCoordExecute(Sender: TObject);
begin
frmEditAllProfile.edtNumberCoord.Text:=IntToStr((frmEditAllProfile.lstCoordProfile.Items.Objects[frmEditAllProfile.lstCoordProfile.ItemIndex] as TSeismicProfileCoordinate).CoordNumber);
frmEditAllProfile.edtCoordX.Text:=FloatToStr((frmEditAllProfile.lstCoordProfile.Items.Objects[frmEditAllProfile.lstCoordProfile.ItemIndex] as TSeismicProfileCoordinate).CoordX);
frmEditAllProfile.edtCoordY.Text:=FloatToStr((frmEditAllProfile.lstCoordProfile.Items.Objects[frmEditAllProfile.lstCoordProfile.ItemIndex] as TSeismicProfileCoordinate).CoordY);
end;

procedure TfrmEditProfile.actSelectProfileExecute(Sender: TObject);
var i,j:Integer;
begin
for i:=0 to SeisProfiles.Count-1 do
if SeisProfiles.Items[i].ID=(frmEditAllProfile.cbbSelectProfile.Items.Objects[frmEditAllProfile.cbbSelectProfile.ItemIndex] as TSeismicProfile).ID then Break;

frmEditAllProfile.edtNumberProfile.Text:=IntToStr(SeisProfiles.Items[i].SeisProfileNumber);
frmEditAllProfile.edtBeginPiket.Text:=IntToStr(SeisProfiles.Items[i].PiketBegin);
frmEditAllProfile.edtEndPiket.Text:=IntToStr(SeisProfiles.Items[i].PiketEnd);
frmEditAllProfile.edtLengthProfile.Text:=FloatToStr(SeisProfiles.Items[i].SeisProfileLenght);
frmEditAllProfile.edtCommentProfile.Text:=SeisProfiles.Items[i].SeisProfileComment;
if Assigned(SeisProfiles.Items[i].SeismicProfileType) then
begin
for j:=0 to frmEditAllProfile.cbbTypeProfile.Items.Count-1 do
if  (frmEditAllProfile.cbbTypeProfile.Items.Objects[j] as TSeismicProfileType).ID=SeisProfiles.Items[i].SeismicProfileType.ID then
begin
frmEditAllProfile.cbbTypeProfile.ItemIndex:=j;
Break;
end;
end
else
frmEditAllProfile.cbbTypeProfile.ItemIndex:=-1;

if Assigned(SeisProfiles.Items[i].SeismicMaterial) then
begin
for j:=0 to frmEditAllProfile.cbbSeisMaterial.Items.Count do
if  (frmEditAllProfile.cbbSeisMaterial.Items.Objects[j] as TSeismicMaterial).ID=SeisProfiles.Items[i].SeismicMaterial.ID then
begin
frmEditAllProfile.cbbSeisMaterial.ItemIndex:=j;
Break;
end;
end
else
frmEditAllProfile.cbbSeisMaterial.ItemIndex:=-1;

frmEditAllProfile.lstCoordProfile.Clear;
for j:=0 to SeisProfileCoords.Count-1 do
if (SeisProfileCoords.Items[j].SeismicProfile.ID=SeisProfiles.Items[i].ID) then
frmEditAllProfile.lstCoordProfile.Items.AddObject(SeisProfileCoords.Items[j].List,SeisProfileCoords.Items[j] as TSeismicProfileCoordinate);



end;

procedure TfrmEditProfile.actSPAddExecute(Sender: TObject);
var i,j,id:integer;sp:TSeismicProfile;spc:TSeismicProfileCoordinate;Addsp,Addspc,Del:Boolean;
begin
for i:=0 to TMainFacade.GetInstance.ALLSeismicProfiles.DeletedObjects.Count-1 do
TMainFacade.GetInstance.ALLSeismicProfiles.DeletedObjects.Remove(TMainFacade.GetInstance.ALLSeismicProfiles.DeletedObjects.Items[0] as TSeismicProfile);
TMainFacade.GetInstance.ALLSeismicProfiles.DeletedObjects.Clear;




for i:=0 to frmEditAllProfile.cbbSelectProfile.Items.Count-1 do
begin
if (frmEditAllProfile.cbbSelectProfile.Items.Objects[i] as TSeismicProfile).ID<=0 then Addsp:=True else Addsp:=False;
if Addsp then
begin
sp:=TMainFacade.GetInstance.ALLSeismicProfiles.Add as TSeismicProfile;
end
else
begin
sp:=TSeismicProfile.Create(TMainFacade.GetInstance.ALLSeismicProfiles) as TSeismicProfile;
end;
sp.Assign(frmEditAllProfile.cbbSelectProfile.Items.Objects[i] as TSeismicProfile);
if Addsp then sp.ID:=sp.Update() else
begin
sp.Update();
TMainFacade.GetInstance.ALLSeismicProfiles.ItemsByID[sp.ID].Assign(sp);
end;
for j:=0 to SeisProfileCoords.Count-1 do
if (frmEditAllProfile.cbbSelectProfile.Items.Objects[i] as TSeismicProfile).ID=SeisProfileCoords.Items[j].SeismicProfile.ID then
begin
if SeisProfileCoords.Items[j].ID<=0 then Addspc:=True else Addspc:=False;
if Addspc then
begin
spc:=TMainFacade.GetInstance.AllSeismicProfileCoordinates.Add as TSeismicProfileCoordinate;
end
else
begin
spc:=TSeismicProfileCoordinate.Create(TMainFacade.GetInstance.AllSeismicProfileCoordinates) as TSeismicProfileCoordinate;
end;
spc.Assign(SeisProfileCoords.Items[j]);
spc.SeismicProfile.Assign(TMainFacade.GetInstance.ALLSeismicProfiles.ItemsByID[sp.ID] as TSeismicProfile);
if Addspc then spc.ID:=spc.Update() else
begin
spc.Update();
TMainFacade.GetInstance.AllSeismicProfileCoordinates.ItemsByID[spc.ID].Assign(spc);
end;
end;
end;
if Assigned(FOnMyEvent) then FOnMyEvent(Sender);
Close;
end;

procedure TfrmEditProfile.actUpCoordExecute(Sender: TObject);
var i:Integer;
begin
for i:=0 to SeisProfileCoords.Count-1 do
if SeisProfileCoords.Items[i].CoordNumber=(frmEditAllProfile.lstCoordProfile.Items.Objects[frmEditAllProfile.lstCoordProfile.ItemIndex] as TSeismicProfileCoordinate).CoordNumber then
begin
SeisProfileCoords.Items[i].CoordNumber:=StrToInt(frmEditAllProfile.edtNumberCoord.Text);
SeisProfileCoords.Items[i].CoordX:=StrToFloat(frmEditAllProfile.edtCoordX.Text);
SeisProfileCoords.Items[i].CoordY:=StrToFloat(frmEditAllProfile.edtCoordY.Text);
frmEditAllProfile.lstCoordProfile.Items.Objects[frmEditAllProfile.lstCoordProfile.ItemIndex]:=SeisProfileCoords.Items[i] as TSeismicProfileCoordinate;
frmEditAllProfile.lstCoordProfile.Items.Strings[frmEditAllProfile.lstCoordProfile.ItemIndex]:=SeisProfileCoords.Items[i].List;
end;
end;

procedure TfrmEditProfile.actUpProfileExecute(Sender: TObject);
var sp:TSeismicProfile;
begin

  sp:=TSeismicProfile.Create(SeisProfiles) as TSeismicProfile;
  sp.Assign(SeisProfiles.ItemsById[Integer(TSeismicProfile(frmEditAllProfile.cbbSelectProfile.Items.Objects[frmEditAllProfile.cbbSelectProfile.ItemIndex]).ID)] as TSeismicProfile);
  sp.SeisProfileNumber:=StrToInt(frmEditAllProfile.edtNumberProfile.Text);
  sp.PiketBegin:=StrToInt(frmEditAllProfile.edtBeginPiket.Text);
  sp.PiketEnd:=StrToInt(frmEditAllProfile.edtEndPiket.Text);
  sp.SeisProfileLenght:=StrToFloat(frmEditAllProfile.edtLengthProfile.Text);
  sp.SeisProfileComment:=frmEditAllProfile.edtCommentProfile.Text;
  if frmEditAllProfile.cbbSeisMaterial.ItemIndex<>-1 then
  sp.SeismicMaterial:=TMainFacade.GetInstance.AllSeismicMaterials.ItemsByID[Integer(TSeismicMaterial(frmEditAllProfile.cbbSeisMaterial.Items.Objects[frmEditAllProfile.cbbSeisMaterial.ItemIndex]).ID)] as TSeismicMaterial
  else sp.SeismicMaterial:=nil;
  sp.SeismicProfileType:=TMainFacade.GetInstance.AllSeismicProfileTypes.ItemsByID[Integer(TSeismicProfileType(frmEditAllProfile.cbbTypeProfile.Items.Objects[frmEditAllProfile.cbbTypeProfile.ItemIndex]).ID)] as TSeismicProfileType;
  //sp.Update();
  SeisProfiles.ItemsById[Integer(sp.ID)].Assign(sp);
  frmEditAllProfile.cbbSelectProfile.Clear;
  //TMainFacade.GetInstance.ALLSeismicProfiles.MakeList(frmEditAllProfile.cbbSelectProfile.Items);
  //if Assigned(FOnMyEvent) then FOnMyEvent(Sender);
  //actCheckProfileExecute(frmEditAllProfile);
  //actCheckProfileExecute(frmEditAllProfile);
  ClearForm;
  SeisProfiles.MakeList(frmEditAllProfile.cbbSelectProfile.Items);

end;

procedure TfrmEditProfile.btn1Click(Sender: TObject);
begin
Close;
end;

procedure TfrmEditProfile.ClearForm;
begin
  with frmEditAllProfile do
  begin
  edtNumberProfile.Text:='';
  edtBeginPiket.Text:='';
  edtEndPiket.Text:='';
  edtLengthProfile.Text:='';
  edtCommentProfile.Text:='';
  cbbSeisMaterial.ItemIndex:=-1;
  cbbTypeProfile.ItemIndex:=-1;
  edtCoordX.Text:='';
  edtCoordY.Text:='';
  edtNumberCoord.Text:='';
  lstCoordProfile.Clear;
  end
end;

procedure TfrmEditProfile.FormActivate(Sender: TObject);
var i,j:Integer;ob:TSeismicProfile;ob2:TSeismicProfileCoordinate;
begin
SeisProfiles:=TSeismicProfiles.Create;
SeisProfileCoords:=TSeismicProfileCoordinates.Create;

for i:=0 to TMainFacade.GetInstance.ALLSeismicProfiles.Count-1 do
begin
ob:=SeisProfiles.Add  as TSeismicProfile;
ob.Assign(TMainFacade.GetInstance.ALLSeismicProfiles.Items[i] as TSeismicProfile);
end;
for j:=0 to TMainFacade.GetInstance.AllSeismicProfileCoordinates.Count-1 do
begin
ob2:=SeisProfileCoords.Add as TSeismicProfileCoordinate;
ob2.Assign(TMainFacade.GetInstance.AllSeismicProfileCoordinates.Items[j] as TSeismicProfileCoordinate);
end;
end;


end.
