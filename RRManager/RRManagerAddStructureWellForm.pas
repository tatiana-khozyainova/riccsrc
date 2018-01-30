unit RRManagerAddStructureWellForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CommonComplexList, ExtCtrls, StdCtrls, ComCtrls,
  RRManagerBaseGUI, RRManagerBaseObjects, RRManagerObjects, RRManagerDataPosters,
  RRManagerPersistentObjects, RRManagerLoaderCommands;

type
  TfrmAddWell = class(TForm)
    gbxArea: TGroupBox;
    pnlButtons: TPanel;
    gbxWells: TGroupBox;
    btnOK: TButton;
    btnCancel: TButton;
    lwWells: TListView;
    cmbxAreas: TComboBox;
    Label1: TLabel;
    procedure cmbxAreasChange(Sender: TObject);
    procedure lwWellsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FWells: TOldDrilledStructureWells;
    actnLoadWell: TBaseAction;
    FSelectedWell: TOldDrilledStructureWell;
    FSelectedWells: TOldDrilledStructureWells;
    procedure SetSelectedWell(const Value: TOldDrilledStructureWell);
  public
    { Public declarations }
    property    SelectedWell: TOldDrilledStructureWell read FSelectedWell write SetSelectedWell;
    property    SelectedWells: TOldDrilledStructureWells read FSelectedWells;
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

var
  frmAddWell: TfrmAddWell;

implementation

uses Facade;

{$R *.DFM}

type

  TWellsLoadAction = class(TWellsBaseLoadAction)
  public
    function Execute(ASQL: string): boolean; override;
  end;


{ TfrmAddWell }

constructor TfrmAddWell.Create(AOwner: TComponent);
begin
  inherited;
  // загружаем площади
  (TMainFacade.GetInstance as TMainFacade).AllDicts.MakeList(cmbxAreas.Items, (TMainFacade.GetInstance as TMainFacade).AllDicts.DictContentByName('TBL_AREA_DICT'));
  cmbxAreas.Sorted := true;
  cmbxAreas.ItemIndex := 0;

  FWells  := TOldDrilledStructureWells.Create(nil);
  FSelectedWells := TOldDrilledStructureWells.Create(nil);

  actnLoadWell := TWellsLoadAction.Create(Self);
  cmbxAreasChange(cmbxAreas);
end;

procedure TfrmAddWell.SetSelectedWell(const Value: TOldDrilledStructureWell);
begin
  FSelectedWell := Value;
  btnOK.Enabled := Assigned(FSelectedWell);
end;

destructor TfrmAddWell.Destroy;
begin
  FWells.Free;
  FSelectedWells.Free;
  inherited;
end;

{ TWellsLoadAction }

function TWellsLoadAction.Execute(ASQL: String): boolean;
var i: integer;
    li: TListItem;
begin
  LastCollection := (Owner as TfrmAddWell).FWells;

  LastCollection.NeedsUpdate := false;

  Result := inherited Execute(ASQL);
  
  // сразу же грузим
  with Owner as TfrmAddWell do
  begin
    // загружаем в интерфейс копию
    lwWells.Items.BeginUpdate;
    // чистим
    lwWells.Items.Clear;
    // добавляем
    for i := 0 to LastCollection.Count - 1 do
    begin
      li := lwWells.Items.Add;
      li.Caption := LastCollection.Items[i].List(AllOpts.Current.ListOption, AllOpts.Current.ShowUINs, false);
      li.Data    := LastCollection.Items[i];
    end;
    lwWells.Items.EndUpdate;
  end;
end;

procedure TfrmAddWell.cmbxAreasChange(Sender: TObject);
var sSQL: string;
begin
  sSQL := 'Area_ID = ' + IntToStr(Integer(cmbxAreas.Items.Objects[cmbxAreas.ItemIndex]));
  SelectedWell := nil;
  FSelectedWells.Clear;
  actnLoadWell.Execute(sSQL);
end;

procedure TfrmAddWell.lwWellsSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
var w: TOldDrilledStructureWell;
begin
  if Selected then
  begin
    SelectedWell := TOldDrilledStructureWell(Item.Data);

    w := SelectedWells.Add;
    w.Assign(SelectedWell);
  end
  else
  begin
    // вырубаем прежде выделенные
    w := SelectedWells.ItemsByUIN[TOldDrilledStructureWell(Item.Data).ID] as TOldDrilledStructureWell;
    w.Free;
  end;
end;

procedure TfrmAddWell.FormShow(Sender: TObject);
begin
  SelectedWell := nil;
end;

end.
