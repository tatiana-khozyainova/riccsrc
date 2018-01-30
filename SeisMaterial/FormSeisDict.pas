unit FormSeisDict;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ToolWin, ComCtrls, ActnList, DB, SeisMaterial, SeisProfile, SeisExemple,Material,
  Ex_Grid, ImgList;

type
  TfrmSeisDict = class(TForm)
    edtSeisDict: TEdit;
    tlbrSeisDict: TToolBar;
    btn1: TToolButton;
    btnSeisDictAdd: TToolButton;
    btnSeisDictUp: TToolButton;
    btnSeisDictDel: TToolButton;
    actnSeisDict: TActionList;
    actnSeisDictAdd: TAction;
    actnAddSeisMethod: TAction;
    actnAddSeisType: TAction;
    actnAddSeisCrew: TAction;
    actnAddProfileType: TAction;
    actnAddExempleType: TAction;
    actnAddElementType: TAction;
    actnSeisDictUp: TAction;
    actnOnClickList: TAction;
    actnUpSeisType: TAction;
    actnUpSeisCrew: TAction;
    actnUpProfileType: TAction;
    actnUpExempleType: TAction;
    actnUpElementType: TAction;
    actnUpSeisMethod: TAction;
    actnDelSeisMethod: TAction;
    actnSeisDictDel: TAction;
    ilSeisDict: TImageList;
    actnDelSeisType: TAction;
    actnDelSeisCrew: TAction;
    actnDelProfileType: TAction;
    actnDelExempleType: TAction;
    actnDelElementType: TAction;
    actnAddMatLocation: TAction;
    actnUpMatLocation: TAction;
    actnDelMatLocation: TAction;
    actSelectList: TAction;
    lvSeisDict: TListBox;
    procedure actnAddSeisMethodExecute(Sender: TObject);
    procedure actnAddSeisTypeExecute(Sender: TObject);
    procedure actnAddSeisCrewExecute(Sender: TObject);
    procedure actnAddProfileTypeExecute(Sender: TObject);
    procedure actnAddExempleTypeExecute(Sender: TObject);
    procedure actnAddElementTypeExecute(Sender: TObject);
    procedure actnSeisDictAddExecute(Sender: TObject);
    procedure actnSeisDictUpExecute(Sender: TObject);
    procedure actnUpSeisMethodExecute(Sender: TObject);
    procedure actnUpSeisTypeExecute(Sender: TObject);
    procedure actnUpSeisCrewExecute(Sender: TObject);
    procedure actnUpProfileTypeExecute(Sender: TObject);
    procedure actnUpExempleTypeExecute(Sender: TObject);
    procedure actnUpElementTypeExecute(Sender: TObject);
    procedure actnDelSeisMethodExecute(Sender: TObject);
    procedure actnSeisDictDelExecute(Sender: TObject);
    procedure actnDelSeisTypeExecute(Sender: TObject);
    procedure actnDelSeisCrewExecute(Sender: TObject);
    procedure actnDelProfileTypeExecute(Sender: TObject);
    procedure actnDelExempleTypeExecute(Sender: TObject);
    procedure actnDelElementTypeExecute(Sender: TObject);
    procedure actnAddMatLocationExecute(Sender: TObject);
    procedure actnUpMatLocationExecute(Sender: TObject);
    procedure actnDelMatLocationExecute(Sender: TObject);
    procedure actSelectListExecute(Sender: TObject);


  private
    { Private declarations }
    Fflags: Integer;

  public
    { Public declarations }
  property flags:Integer read Fflags write Fflags;
 
  end;

var
  frmSeisDict: TfrmSeisDict;

implementation

{$R *.dfm}
uses Facade,BaseObjects ;

procedure TfrmSeisDict.actnAddSeisMethodExecute(Sender: TObject);
var ob:TSeisWorkMethod;
begin
  ob:=TMainFacade.GetInstance.AllSeisWorkMethods.Add as TSeisWorkMethod;
  ob.Name:= edtSeisDict.Text;
  ob.Id:=ob.Update();
  lvSeisDict.Clear;
  TMainFacade.GetInstance.AllSeisWorkMethods.SortByName(true);
  TMainFacade.GetInstance.AllSeisWorkMethods.MakeList(lvSeisDict.Items);
end;

procedure TfrmSeisDict.actnAddSeisTypeExecute(Sender: TObject);
var ob:TSeisWorkType;
begin
ob:=TMainFacade.GetInstance.AllSeisWorkTypes.Add as TSeisWorkType;
  ob.Name:= edtSeisDict.Text;
  ob.Id:=ob.Update();
  lvSeisDict.Clear;
  TMainFacade.GetInstance.AllSeisWorkTypes.SortByName(true);
  TMainFacade.GetInstance.AllSeisWorkTypes.MakeList(lvSeisDict.Items);

end;

procedure TfrmSeisDict.actnAddSeisCrewExecute(Sender: TObject);
var ob:TSeisCrew;
begin
ob:=TMainFacade.GetInstance.AllSeisCrews.Add as TSeisCrew;
  ob.SeisCrewNumber:= StrToInt(edtSeisDict.Text);
  ob.Id:=ob.Update();
  lvSeisDict.Clear;
  TMainFacade.GetInstance.AllSeisCrews.SortByID(true);
  TMainFacade.GetInstance.AllSeisCrews.MakeList(lvSeisDict.Items);

  //TMainFacade.GetInstance.AllSeisCrews.Add(ob);
  //lvSeisDict.Items[lvSeisDict.Items.Count-1].SubItems.Text:=edtSeisDict.Text;
  //ob.Free;

end;

procedure TfrmSeisDict.actnAddProfileTypeExecute(Sender: TObject);
var ob:TSeismicProfileType;
begin
ob:=TMainFacade.GetInstance.AllSeismicProfileTypes.Add as TSeismicProfileType;
  ob.Name:= edtSeisDict.Text;
  ob.Id:=ob.Update();
  lvSeisDict.Clear;
  TMainFacade.GetInstance.AllSeismicProfileTypes.SortByName(true);
  TMainFacade.GetInstance.AllSeismicProfileTypes.MakeList(lvSeisDict.Items);
end;

procedure TfrmSeisDict.actnAddExempleTypeExecute(Sender: TObject);
var ob:TExempleType;
begin
ob:=TMainFacade.GetInstance.AllExempleTypes.Add as TExempleType;
  ob.Name:= edtSeisDict.Text;
  ob.Id:=ob.Update();
  lvSeisDict.Clear;
  TMainFacade.GetInstance.AllExempleTypes.SortByName(true);
  TMainFacade.GetInstance.AllExempleTypes.MakeList(lvSeisDict.Items);
end;

procedure TfrmSeisDict.actnAddElementTypeExecute(Sender: TObject);
var ob:TElementType;
begin
ob:=TMainFacade.GetInstance.AllElementTypes.Add as TElementType;
  ob.Name:= edtSeisDict.Text;
  ob.Id:=ob.Update();
  lvSeisDict.Clear;
  TMainFacade.GetInstance.AllElementTypes.SortByName(true);
  TMainFacade.GetInstance.AllElementTypes.MakeList(lvSeisDict.Items);
end;

procedure TfrmSeisDict.actnAddMatLocationExecute(Sender: TObject);
var ob:TMaterialLocation;
begin
ob:=TMainFacade.GetInstance.AllMaterialLocations.Add as TMaterialLocation;
  ob.Name:= edtSeisDict.Text;
  ob.Id:=ob.Update();
  lvSeisDict.Clear;
  TMainFacade.GetInstance.AllMaterialLocations.SortByName(true);
  TMainFacade.GetInstance.AllMaterialLocations.MakeList(lvSeisDict.Items);
end;

procedure TfrmSeisDict.actnSeisDictAddExecute(Sender: TObject);
begin
if  edtSeisDict.Text='' then
begin
ShowMessage('Введите значение');
Exit;
end;
case flags of
1:actnAddSeisMethod.Execute;
2:actnAddSeisType.Execute;
3:actnAddSeisCrew.Execute;
4:actnAddProfileType.Execute;
5:actnAddExempleType.Execute;
6:actnAddElementType.Execute;
7:actnAddMatLocation.Execute;
end;
edtSeisDict.Text:='';
lvSeisDict.ItemIndex:=lvSeisDict.Items.Count-1;
actSelectListExecute(frmSeisDict);
end;

procedure TfrmSeisDict.actnSeisDictUpExecute(Sender: TObject);
var i:Integer;
begin

if  lvSeisDict.ItemIndex=-1 then
begin
ShowMessage('Выбирите изменяемый атрибут');
Exit;
end;
if  edtSeisDict.Text='' then
begin
ShowMessage('Введите значение');
Exit;
end;
i:=lvSeisDict.ItemIndex;
case flags of
1:actnUpSeisMethod.Execute;
2:actnUpSeisType.Execute;
3:actnUpSeisCrew.Execute;
4:actnUpProfileType.Execute;
5:actnUpExempleType.Execute;
6:actnUpElementType.Execute;
7:actnUpMatLocation.Execute;
end;
lvSeisDict.ItemIndex:=i;
actSelectListExecute(frmSeisDict);
end;

procedure TfrmSeisDict.actnUpSeisMethodExecute(Sender: TObject);
var ob:TSeisWorkMethod;
begin
ob:=TSeisWorkMethod.Create(TMainFacade.GetInstance.AllSeisWorkMethods) as TSeisWorkMethod;
  ob.Assign(TMainFacade.GetInstance.AllSeisWorkMethods.ItemsByID[TIDObject(lvSeisDict.Items.Objects[lvSeisDict.ItemIndex]).ID]);
  ob.Name:= edtSeisDict.Text;
  ob.Update();
  TMainFacade.GetInstance.AllSeisWorkMethods.ItemsByID[ob.Id].Assign(ob);
  lvSeisDict.Clear;
  TMainFacade.GetInstance.AllSeisWorkMethods.SortByName(true);
  TMainFacade.GetInstance.AllSeisWorkMethods.MakeList(lvSeisDict.Items);
  ob.Free;
end;

procedure TfrmSeisDict.actnUpSeisTypeExecute(Sender: TObject);
var ob:TSeisWorkType;
begin
ob:=TSeisWorkType.Create(TMainFacade.GetInstance.AllSeisWorkTypes) as TSeisWorkType;
  ob.Assign(TMainFacade.GetInstance.AllSeisWorkTypes.ItemsByID[TIDObject(lvSeisDict.Items.Objects[lvSeisDict.ItemIndex]).ID]);
  ob.Name:= edtSeisDict.Text;
  ob.Update();
  TMainFacade.GetInstance.AllSeisWorkTypes.ItemsByID[ob.Id].Assign(ob);
  lvSeisDict.Clear;
  TMainFacade.GetInstance.AllSeisWorkTypes.SortByName(true);
  TMainFacade.GetInstance.AllSeisWorkTypes.MakeList(lvSeisDict.Items);
  ob.Free;
end;

procedure TfrmSeisDict.actnUpSeisCrewExecute(Sender: TObject);
var ob:TSeisCrew;
begin
  ob:=TSeisCrew.Create(TMainFacade.GetInstance.AllSeisCrews) as TSeisCrew;
  ob.Assign(TMainFacade.GetInstance.AllSeisCrews.ItemsByID[TIDObject(lvSeisDict.Items.Objects[lvSeisDict.ItemIndex]).ID]);
  ob.SeisCrewNumber:= StrToInt(edtSeisDict.Text);
  ob.Update();
  TMainFacade.GetInstance.AllSeisCrews.ItemsByID[ob.Id].Assign(ob);
  lvSeisDict.Clear;
  TMainFacade.GetInstance.AllSeisCrews.SortByName(true);
  TMainFacade.GetInstance.AllSeisCrews.MakeList(lvSeisDict.Items);
  ob.Free;
end;

procedure TfrmSeisDict.actnUpProfileTypeExecute(Sender: TObject);
var ob:TSeismicProfileType;
begin
  ob:=TSeismicProfileType.Create(TMainFacade.GetInstance.AllSeismicProfileTypes) as TSeismicProfileType;
  ob.Assign(TMainFacade.GetInstance.AllSeismicProfileTypes.ItemsByID[TIDObject(lvSeisDict.Items.Objects[lvSeisDict.ItemIndex]).ID]);
  ob.Name:= edtSeisDict.Text;
  ob.Update();
  TMainFacade.GetInstance.AllSeismicProfileTypes.ItemsByID[ob.Id].Assign(ob);
  lvSeisDict.Clear;
  TMainFacade.GetInstance.AllSeismicProfileTypes.SortByName(true);
  TMainFacade.GetInstance.AllSeismicProfileTypes.MakeList(lvSeisDict.Items);
  ob.Free;
end;

procedure TfrmSeisDict.actnUpExempleTypeExecute(Sender: TObject);
var ob:TExempleType;
begin
  ob:=TExempleType.Create(TMainFacade.GetInstance.AllExempleTypes) as TExempleType;
  ob.Assign(TMainFacade.GetInstance.AllExempleTypes.ItemsByID[TIDObject(lvSeisDict.Items.Objects[lvSeisDict.ItemIndex]).ID]);
  ob.Name:= edtSeisDict.Text;
  ob.Update();
  TMainFacade.GetInstance.AllExempleTypes.ItemsByID[ob.Id].Assign(ob);
  lvSeisDict.Clear;
  TMainFacade.GetInstance.AllExempleTypes.SortByName(true);
  TMainFacade.GetInstance.AllExempleTypes.MakeList(lvSeisDict.Items);
  ob.Free;
end;

procedure TfrmSeisDict.actnUpElementTypeExecute(Sender: TObject);
var ob:TElementType;
begin
  ob:=TElementType.Create(TMainFacade.GetInstance.AllElementTypes) as TElementType;
  ob.Assign(TMainFacade.GetInstance.AllElementTypes.ItemsByID[TIDObject(lvSeisDict.Items.Objects[lvSeisDict.ItemIndex]).ID]);
  ob.Name:= edtSeisDict.Text;
  ob.Update();
  TMainFacade.GetInstance.AllElementTypes.ItemsByID[ob.Id].Assign(ob);
  lvSeisDict.Clear;
  TMainFacade.GetInstance.AllElementTypes.SortByName(true);
  TMainFacade.GetInstance.AllElementTypes.MakeList(lvSeisDict.Items);
  ob.Free;
end;

procedure TfrmSeisDict.actnUpMatLocationExecute(Sender: TObject);
var ob:TMaterialLocation;
begin
  ob:=TMaterialLocation.Create(TMainFacade.GetInstance.AllMaterialLocations) as TMaterialLocation;
  ob.Assign(TMainFacade.GetInstance.AllMaterialLocations.ItemsByID[TIDObject(lvSeisDict.Items.Objects[lvSeisDict.ItemIndex]).ID]);
  ob.Name:= edtSeisDict.Text;
  ob.Update();
  TMainFacade.GetInstance.AllMaterialLocations.ItemsByID[ob.Id].Name:=ob.Name;
  lvSeisDict.Clear;
  TMainFacade.GetInstance.AllMaterialLocations.SortByName(true);
  TMainFacade.GetInstance.AllMaterialLocations.MakeList(lvSeisDict.Items);
  ob.Free;
end;

procedure TfrmSeisDict.actnSeisDictDelExecute(Sender: TObject);
begin
if  lvSeisDict.ItemIndex=-1 then
begin
ShowMessage('Выбирите удаляемый атрибут');
Exit;
end;
case flags of
1:actnDelSeisMethod.Execute;
2:actnDelSeisType.Execute;
3:actnDelSeisCrew.Execute;
4:actnDelProfileType.Execute;
5:actnDelExempleType.Execute;
6:actnDelElementType.Execute;
7:actnDelMatLocation.Execute;
end;
edtSeisDict.Text:='';
end;

procedure TfrmSeisDict.actnDelSeisMethodExecute(Sender: TObject);
var ob:TSeisWorkMethod;
begin
TMainFacade.GetInstance.AllSeisWorkMethods.Remove(TMainFacade.GetInstance.AllSeisWorkMethods.ItemsByID[TIDObject(lvSeisDict.Items.Objects[lvSeisDict.ItemIndex]).ID])
end;

procedure TfrmSeisDict.actnDelSeisTypeExecute(Sender: TObject);
begin
TMainFacade.GetInstance.AllSeisWorkTypes.Remove(TMainFacade.GetInstance.AllSeisWorkTypes.ItemsByID[TIDObject(lvSeisDict.Items.Objects[lvSeisDict.ItemIndex]).ID])
end;

procedure TfrmSeisDict.actnDelSeisCrewExecute(Sender: TObject);
begin
TMainFacade.GetInstance.AllSeisCrews.Remove(TMainFacade.GetInstance.AllSeisCrews.ItemsByID[TIDObject(lvSeisDict.Items.Objects[lvSeisDict.ItemIndex]).ID])
end;

procedure TfrmSeisDict.actnDelProfileTypeExecute(Sender: TObject);
begin
TMainFacade.GetInstance.AllSeismicProfileTypes.Remove(TMainFacade.GetInstance.AllSeismicProfileTypes.ItemsByID[TIDObject(lvSeisDict.Items.Objects[lvSeisDict.ItemIndex]).ID])
end;

procedure TfrmSeisDict.actnDelExempleTypeExecute(Sender: TObject);
begin
TMainFacade.GetInstance.AllExempleTypes.Remove(TMainFacade.GetInstance.AllExempleTypes.ItemsByID[TIDObject(lvSeisDict.Items.Objects[lvSeisDict.ItemIndex]).ID])
end;

procedure TfrmSeisDict.actnDelElementTypeExecute(Sender: TObject);
begin
TMainFacade.GetInstance.AllElementTypes.Remove(TMainFacade.GetInstance.AllElementTypes.ItemsByID[TIDObject(lvSeisDict.Items.Objects[lvSeisDict.ItemIndex]).ID])
end;

procedure TfrmSeisDict.actnDelMatLocationExecute(Sender: TObject);
begin
TMainFacade.GetInstance.AllMaterialLocations.Remove(TMainFacade.GetInstance.AllMaterialLocations.ItemsByID[TIDObject(lvSeisDict.Items.Objects[lvSeisDict.ItemIndex]).ID])
end;

procedure TfrmSeisDict.actSelectListExecute(Sender: TObject);
begin
if lvSeisDict.ItemIndex<>-1 then
edtSeisDict.Text:=Trim(lvSeisDict.Items.Strings[lvSeisDict.ItemIndex]);
end;

end.

