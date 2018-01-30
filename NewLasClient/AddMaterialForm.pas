unit AddMaterialForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, StdCtrls, ComCtrls, Menus, Buttons, Facade, LasFile, Material,
  Well, Area , Employee, Organization;

type
  TAddMaterial = class(TForm)
    mm1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    actlst1: TActionList;
    pgc1: TPageControl;
    ts1: TTabSheet;
    lbl1: TLabel;
    edtPath: TEdit;
    btnBrose: TButton;
    actBrose: TAction;
    lbl2: TLabel;
    cmbxType: TComboBox;
    lbl3: TLabel;
    edtName: TEdit;
    lbl4: TLabel;
    edtComment: TEdit;
    btnOpen: TSpeedButton;
    btnClear: TSpeedButton;
    actClear: TAction;
    actSave: TAction;
    dlgOpen: TOpenDialog;
    lstAllCurves: TListBox;
    gbxCurves: TGroupBox;
    lblAllCurves: TLabel;
    lstCurvesInDoc: TListBox;
    lbl5: TLabel;
    btnRight: TButton;
    btnRightAll: TButton;
    btnLeftAll: TButton;
    btnLeft: TButton;
    btnSave: TSpeedButton;
    cmbxArea: TComboBox;
    lbl6: TLabel;
    cmbxWell: TComboBox;
    lbl7: TLabel;
    gbxWell: TGroupBox;
    lbl8: TLabel;
    dtp1: TDateTimePicker;
    procedure actBroseExecute(Sender: TObject);
    procedure actClearExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure btnRightClick(Sender: TObject);
    procedure cmbxAreaChange(Sender: TObject);
    procedure btnRightAllClick(Sender: TObject);
    procedure btnLeftAllClick(Sender: TObject);
    procedure btnLeftClick(Sender: TObject);
  private
    { Private declarations }
    FBindingWells : TWells;
    function GetSelectedArea : TArea;
    function GetSelectedWell : TWell;
  public
    { Public declarations }
    property SelectedArea : TArea read GetSelectedArea;
    property SelectedWell : TWell read GetSelectedWell;
    property BindingWells : TWells read FBindingWells;
  end;

var
  AddMaterial: TAddMaterial;

implementation

{$R *.dfm}

procedure TAddMaterial.actBroseExecute(Sender: TObject);
begin
  dlgOpen := TOpenDialog.Create(self);
  dlgOpen.InitialDir := GetCurrentDir;
  dlgOpen.Filter :='Все файлы|*.*|';
  dlgOpen.FilterIndex := 1;
  if dlgOpen.Execute then
  begin
    edtPath.Text:=ExtractFileName(dlgOpen.FileName);
  end;
end;

procedure TAddMaterial.actClearExecute(Sender: TObject);
var
  i:Integer;
begin
edtPath.Text:='';
edtName.Text:='';
edtComment.Text:='';
lstAllCurves.Items.Clear;
lstCurvesInDoc.Items.Clear;
for i:=0 to TMainFacade.GetInstance.AllCurveCategories.Count-1 do
  lstAllCurves.Items.AddObject(TMainFacade.GetInstance.AllCurveCategories.Items[i].ShortName,TMainFacade.GetInstance.AllCurveCategories.Items[i]);
end;

procedure TAddMaterial.FormCreate(Sender: TObject);
var
  i:Integer;
begin
cmbxType.Text:='Укажите тип материала';
for i:=0 to TMainFacade.GetInstance.AllCurveCategories.Count-1 do
  lstAllCurves.Items.AddObject(TMainFacade.GetInstance.AllCurveCategories.Items[i].ShortName,TMainFacade.GetInstance.AllCurveCategories.Items[i]);
TMainFacade.GetInstance.AllAreas.Reload('',true);
//TMainFacade.GetInstance.AllAreas.MakeList(cmbxArea);
 for i:=0 to TMainFacade.GetInstance.AllAreas.Count-1 do
 cmbxArea.items.AddObject(TMainFacade.GetInstance.AllAreas.Items[i].Name,TMainFacade.GetInstance.AllAreas.Items[i]);
 // TMainFacade.GetInstance.AllAreas.MakeList(cmbxArea);
  FBindingWells := TWells.Create;
  cmbxArea.Text:='Площадь';
  cmbxWell.Text:='Скважина';

end;


procedure TAddMaterial.actSaveExecute(Sender: TObject);
var
  m:TSimpleDocument;
  mc:TMaterialCurve;
  mb:TMaterialBinding;
  i:Integer;
  path:string;
begin
  m:= TMainFacade.GetInstance.AllSimpleDocuments.Add as TSimpleDocument;
  m.Name:=edtName.Text;
  m.MaterialComment:=edtComment.Text;
  if (cmbxType.ItemIndex=0) then m.DocType:=TMainFacade.GetInstance.AllDocTypes.ItemsById[41] as TDocumentType;
  if (cmbxType.ItemIndex=1) then m.DocType:=TMainFacade.GetInstance.AllDocTypes.ItemsById[42] as TDocumentType;
  m.MaterialLocation:=TMainFacade.GetInstance.AllMaterialLocations.ItemsById[1] as TMaterialLocation;
  m.Organization:=TMainFacade.GetInstance.AllLasOrg.ItemsById[0] as TOrganization;
  m.CreationDate:=dtp1.Date;

  m.EnteringDate:=Now;
  m.LocationPath:=edtPath.Text;
  m.Employee:=TMainFacade.GetInstance.AllEmployees.ItemsById[636] as TEmployee;
  m.Bindings:=SelectedWell.NumberWell+'-'+SelectedWell.Area.Name;
  m.ID:=m.Update;
  //тестовая база  \\srvsrvc\ricctest\materialbank\
  path:='\\srvdb\docs$\scans\'+IntToStr(SelectedArea.ID)+'\'+IntToStr(SelectedWell.ID)+'\';
  if not DirectoryExists(path) then
          ForceDirectories(path);
  CopyFile(PChar(dlgOpen.FileName), PChar(path+IntToStr(m.ID)+ExtractFileExt(dlgOpen.FileName)), True);
  //CopyFile(Pchar(dlgOpen.FileName), Pchar('\\srvdb\docs$\scans\'+IntToStr(m.ID)+'____'+m.LocationPath), false);
  //m.LocationPath:='\\srvdb\docs$\scans\'+IntToStr(m.ID)+'____'+m.LocationPath;
  m.LocationPath:=path+IntToStr(m.ID)+ExtractFileExt(dlgOpen.FileName);
  m.Update;

  mb:=TMainFacade.GetInstance.AllMaterialBindings.Add as TMaterialBinding;
  mb.SimpleDocument:=m;
  mb.ObjectBindType:=TMainFacade.GetInstance.AllObjectBindTypes.ItemsById[1] as TObjectBindType;
  mb.ID:=SelectedWell.ID;
  mb.Update;

  for i:=0 to lstCurvesInDoc.Count-1 do
    begin
      mc:=TMaterialCurve(TMainFacade.GetInstance.AllMaterialCurves.Add);
      mc.SimpleDocument:=(m);
      mc.CurveCategory:=(lstCurvesInDoc.Items.Objects[i] as TCurveCategory);
      mc.Update;
      FreeAndNil(mc);
    end;

 MessageDlg('Документ успешно добавлен.', mtInformation, [mbOK],0);
end;

procedure TAddMaterial.btnRightClick(Sender: TObject);
begin
if Assigned(lstAllCurves.Items.Objects[lstAllCurves.ItemIndex]) then
  begin
    lstCurvesInDoc.Items.AddObject(TMainFacade.GetInstance.AllCurveCategories.ItemsByID[TCurveCategory(lstAllCurves.Items.Objects[lstAllCurves.ItemIndex]).ID].ShortName,TMainFacade.GetInstance.AllCurveCategories.ItemsByID[TCurveCategory(lstAllCurves.Items.Objects[lstAllCurves.ItemIndex]).ID]);
    lstAllCurves.Items.Delete(lstAllCurves.ItemIndex);
  end;
end;

function TAddMaterial.GetSelectedArea: TArea;
begin
  if cmbxArea.ItemIndex > -1 then
    Result := TArea(cmbxArea.Items.Objects[cmbxArea.ItemIndex])
  else
    Result := nil;
end;

function TAddMaterial.GetSelectedWell: TWell;
begin
   if cmbxWell.ItemIndex > -1 then
    Result := TWell(cmbxWell.Items.Objects[cmbxWell.ItemIndex])
  else
    Result := nil;
end;

procedure TAddMaterial.cmbxAreaChange(Sender: TObject);
var
  i:integer;
begin
  BindingWells.Clear;
  if Assigned(SelectedArea)then
    BindingWells.Reload('Area_ID = ' + IntToStr(SelectedArea.ID));
  for i:=0 to BindingWells.Count-1 do
    cmbxWell.items.AddObject(BindingWells.Items[i].NumberWell+'-'+SelectedArea.Name,BindingWells.Items[i]);
  //BindingWells.MakeList(cmbxWell.Items, false, true);
end;

procedure TAddMaterial.btnRightAllClick(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to lstAllCurves.Count-1 do
  begin
    lstCurvesInDoc.Items.AddObject(TCurveCategory(lstAllCurves.Items.Objects[i]).ShortName, TCurveCategory(lstAllCurves.Items.Objects[i]));
  end;
  lstAllCurves.Clear();
end;

procedure TAddMaterial.btnLeftAllClick(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to lstCurvesInDoc.Count-1 do
  begin
    lstAllCurves.Items.AddObject(TCurveCategory(lstCurvesInDoc.Items.Objects[i]).ShortName, TCurveCategory(lstCurvesInDoc.Items.Objects[i]));
  end;
  lstCurvesInDoc.Clear();
end;

procedure TAddMaterial.btnLeftClick(Sender: TObject);
begin
 if Assigned(lstCurvesInDoc.Items.Objects[lstCurvesInDoc.ItemIndex]) then
  begin
    lstAllCurves.Items.AddObject(TCurveCategory(lstCurvesInDoc.Items.Objects[lstCurvesInDoc.ItemIndex]).ShortName, lstCurvesInDoc.Items.Objects[lstCurvesInDoc.ItemIndex]);
    lstCurvesInDoc.Items.Delete(lstAllCurves.ItemIndex);
    lstCurvesInDoc.Items.Delete(lstCurvesInDoc.ItemIndex);
  end;
end;

end.
