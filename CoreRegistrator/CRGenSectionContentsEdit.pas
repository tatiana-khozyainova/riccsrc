unit CRGenSectionContentsEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonFrame, ComCtrls, GeneralizedSection, StdCtrls, SlottingWell, Slotting, BaseObjects;

type
  TfrmGenSectionContentsEdit = class(TfrmCommonFrame)
    gbxGenSectionContents: TGroupBox;
    cmbxWell: TComboBox;
    lwSlottings: TListView;
    lblWell: TLabel;
    lblIntervals: TLabel;
    procedure cmbxWellChange(Sender: TObject);
    procedure lwSlottingsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    FSelectedSlottings: TSlottings;
    function GetGeneralizedSection: TGeneralizedSection;
    function GetSelectedWell: TSlottingWell;
    function GetSelectedSlottings: TSlottings;
  protected
    procedure FillControls(ABaseObject: TIDObject); override;
    procedure ClearControls; override;
    procedure RegisterInspector; override;
    procedure FillParentControls; override;
  public
    { Public declarations }

    property    SelectedWell: TSlottingWell read GetSelectedWell;
    property    SelectedSlottings: TSlottings read GetSelectedSlottings;
    property    GeneralizedSection: TGeneralizedSection read GetGeneralizedSection;

    constructor Create(AOwner: TComponent); override;
    procedure   Save(AObject: TIDObject = nil);  override;
    destructor  Destroy; override;
  end;

var
  frmGenSectionContentsEdit: TfrmGenSectionContentsEdit;

implementation

uses Facade, Math;

{$R *.dfm}

{ TfrmGenSectionContentsEdit }

procedure TfrmGenSectionContentsEdit.ClearControls;
begin
  inherited;
  cmbxWell.Items.Clear;
  lwSlottings.Items.Clear;

  SelectedSlottings.Clear;
  TMainFacade.GetInstance.AllWells.MakeList(cmbxWell.Items, True, true);
  cmbxWell.ItemIndex := 0;
  cmbxWellChange(cmbxWell);  
end;


constructor TfrmGenSectionContentsEdit.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TfrmGenSectionContentsEdit.Destroy;
begin
  FreeAndNil(FSelectedSlottings);
  inherited;
end;

procedure TfrmGenSectionContentsEdit.FillControls(ABaseObject: TIDObject);
var i: Integer;
    wls: TIDObjects;
begin
  inherited;
  TMainFacade.GetInstance.AllWells.MakeList(cmbxWell.Items, True, true);
  wls := TIDObjects.Create;
  wls.OwnsObjects := false;
  if Assigned(GeneralizedSection) then
  begin
    for i := 0 to GeneralizedSection.Slottings.Count - 1 do
    if not Assigned(TMainFacade.GetInstance.AllWells.ItemsByID[GeneralizedSection.Slottings.Items[i].Well.ID]) then
    begin
      if not Assigned(wls.ItemsByID[GeneralizedSection.Slottings.Items[i].Well.ID]) then
      begin
        wls.Add(GeneralizedSection.Slottings.Items[i].Well, false, false);
        cmbxWell.AddItem(GeneralizedSection.Slottings.Items[i].Well.List, GeneralizedSection.Slottings.Items[i].Well);
      end;
    end;
    SelectedSlottings.AddObjects(GeneralizedSection.Slottings, False, False);
  end;
  cmbxWell.ItemIndex := 0;
  cmbxWellChange(cmbxWell);
end;

function TfrmGenSectionContentsEdit.GetGeneralizedSection: TGeneralizedSection;
begin
  Result := EditingObject as TGeneralizedSection;
end;

procedure TfrmGenSectionContentsEdit.RegisterInspector;
begin
  inherited;

end;

procedure TfrmGenSectionContentsEdit.Save(AObject: TIDObject);
var i: Integer;

    s: TGeneralizedSectionSlotting;
    w: TSlottingWell;
begin
  inherited;

  // подменяем на настоящий интервал отбора керна
  with TMainFacade.GetInstance do
  if ((not Assigned(EditingObject)) or (EditingObject is ParentClass)) and (GeneralizedSections.Count > 0) then
      FEditingObject := GeneralizedSections.Items[GeneralizedSections.Count - 1];

  if EditingObject is TGeneralizedSection then
  begin
    GeneralizedSection.Slottings.MarkAllDeleted;
    for i := 0 to SelectedSlottings.Count - 1 do
    begin
      s := GeneralizedSection.Slottings.Add(SelectedSlottings.Items[i], True, True) as TGeneralizedSectionSlotting;
      s.Well := TSlottingWell.Create(nil);
      if SelectedSlottings.Items[i].Owner is TSlottingWell then
        w := SelectedSlottings.Items[i].Collection.Owner as TSlottingWell
      else
        w := (SelectedSlottings.Items[i] as TGeneralizedSectionSlotting).Well;

      s.Well.ID := w.ID;
      s.Well.Area := w.Area;
      S.Well.NumberWell := w.NumberWell;

    end;
    GeneralizedSection.Slottings.RefreshIntervals;
  end;
end;

procedure TfrmGenSectionContentsEdit.cmbxWellChange(Sender: TObject);
var i: integer;
begin
  inherited;
  if Assigned(SelectedWell) then
  begin
    SelectedWell.Slottings.MakeList(lwSlottings.Items, true, true);
    // загружаем выбранные
    for i := 0 to SelectedWell.Slottings.Count - 1 do
    begin
      if Assigned(SelectedSlottings.ItemsByID[SelectedWell.Slottings.Items[i].ID]) then
        lwSlottings.Items[i].Checked := True
      else
        lwSlottings.Items[i].Checked := False;
    end;
  end;
end;

function TfrmGenSectionContentsEdit.GetSelectedWell: TSlottingWell;
begin
  if cmbxWell.ItemIndex > -1 then
    Result := cmbxWell.Items.Objects[cmbxWell.ItemIndex] as TSlottingWell
  else
    Result := nil;
end;

function TfrmGenSectionContentsEdit.GetSelectedSlottings: TSlottings;
begin
  if not Assigned(FSelectedSlottings) then
  begin
    FSelectedSlottings := TSlottings.Create;
    FSelectedSlottings.OwnsObjects := false;
  end;

  Result := FSelectedSlottings;
end;

procedure TfrmGenSectionContentsEdit.lwSlottingsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var Item: TListItem;
    slt: TIDObject;
begin
  inherited;

  Item := lwSlottings.GetItemAt(X, Y);
  if Assigned(Item) then
  begin
    if Item.Checked then
      SelectedSlottings.Add(TIDObject(Item.Data), false, true)
    else
    begin
      slt := SelectedSlottings.ItemsByID[TIDObject(Item.Data).ID];
      if Assigned(slt) then
        SelectedSlottings.Remove(slt);
    end;
  end;
end;

procedure TfrmGenSectionContentsEdit.FillParentControls;
begin
  inherited;
  TMainFacade.GetInstance.AllWells.MakeList(cmbxWell.Items, True, true);
  cmbxWell.ItemIndex := 0;
  cmbxWellChange(cmbxWell);
end;

end.
