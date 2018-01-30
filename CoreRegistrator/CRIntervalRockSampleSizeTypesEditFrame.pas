unit CRIntervalRockSampleSizeTypesEditFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonFrame, ComCtrls, Ex_Grid, BaseObjects, Well;

type
  TfrmRockSampleSizeTypesEdit = class(TfrmCommonFrame)
    grdSampleSizeTypes: TGridView;
    procedure grdSampleSizeTypesGetCellText(Sender: TObject;
      Cell: TGridCell; var Value: String);
    procedure grdSampleSizeTypesSetEditText(Sender: TObject;
      Cell: TGridCell; var Value: String);
    procedure grdSampleSizeTypesDblClick(Sender: TObject);
  private
    { Private declarations }
    procedure ClearTable;
    function  GetWell: TWell;
  protected
    procedure FillControls(ABaseObject: TIDObject); override;
    procedure FillParentControls; override;
    procedure ClearControls; override;
  public
    { Public declarations }
    property Well: TWell read GetWell;
    procedure   Save(AObject: TIDObject = nil);  override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;    
  end;

var
  frmRockSampleSizeTypesEdit: TfrmRockSampleSizeTypesEdit;

implementation

uses Facade, RockSample, Registrator, Slotting, CommonIDObjectListForm,
     CRBaseActions;

{$R *.dfm}

{ TfrmRockSampleSizeTypesEdit }

procedure TfrmRockSampleSizeTypesEdit.ClearControls;
begin
  inherited;
  ClearTable;
end;

procedure TfrmRockSampleSizeTypesEdit.ClearTable;
begin
  grdSampleSizeTypes.Rows.Count := 1;
  grdSampleSizeTypes.Cells[0, 0] := '';
  grdSampleSizeTypes.Cells[1, 0] := '';
end;

constructor TfrmRockSampleSizeTypesEdit.Create(AOwner: TComponent);
begin
  inherited;
  grdSampleSizeTypes.AllowEdit := false;
  grdSampleSizeTypes.Rows.Count := 1;

  NeedsShadeEditing := true;
  EditingClass := TSlotting;
  ParentClass := TWell;
end;

procedure TfrmRockSampleSizeTypesEdit.FillControls(ABaseObject: TIDObject);
begin
  inherited;
  grdSampleSizeTypes.AllowEdit := true;
  grdSampleSizeTypes.Rows.Count := (TMainFacade.GetInstance as TMainFacade).AllRockSampleSizeTypes.Count;

  (ShadeEditingObject as TSlotting).RockSampleSizeTypePresences.Assign((EditingObject as TSlotting).RockSampleSizeTypePresences);
  grdSampleSizeTypes.Refresh;


end;

function TfrmRockSampleSizeTypesEdit.GetWell: TWell;
begin
  Result := nil;

  if EditingObject is TWell then
    Result := EditingObject as TWell
  else if EditingObject is TSlotting then
    Result := (EditingObject as TSlotting).Collection.Owner as TWell
end;

procedure TfrmRockSampleSizeTypesEdit.grdSampleSizeTypesGetCellText(
  Sender: TObject; Cell: TGridCell; var Value: String);
var p: TRockSampleSizeTypePresence;
begin
  inherited;
  if grdSampleSizeTypes.AllowEdit then
  begin
    if Cell.Col = 0 then
    begin
      with grdSampleSizeTypes do
        Value := (TMainFacade.GetInstance as TMainFacade).AllRockSampleSizeTypes.Items[Cell.Row].List();
    end
    else if Cell.Col = 1 then
    begin
      with grdSampleSizeTypes do
      begin
        p := (ShadeEditingObject as TSlotting).RockSampleSizeTypePresences.GetPresenseBySizeType((TMainFacade.GetInstance as TMainFacade).AllRockSampleSizeTypes.Items[Cell.Row]);
        if Assigned(p) then Value := IntToStr(p.Count)
        else Value := '0'
      end;
    end;
  end;
end;

procedure TfrmRockSampleSizeTypesEdit.grdSampleSizeTypesSetEditText(
  Sender: TObject; Cell: TGridCell; var Value: String);
var p: TRockSampleSizeTypePresence;
begin
  inherited;
  if (Cell.Col = 1) and grdSampleSizeTypes.AllowEdit then
  begin
    p := (ShadeEditingObject as TSlotting).RockSampleSizeTypePresences.GetPresenseBySizeType((TMainFacade.GetInstance as TMainFacade).AllRockSampleSizeTypes.Items[Cell.Row]);
    if not Assigned(p) then
    begin
      p := (ShadeEditingObject as TSlotting).RockSampleSizeTypePresences.Add as TRockSampleSizeTypePresence;
      p.RockSampleSizeType := (TMainFacade.GetInstance as TMainFacade).AllRockSampleSizeTypes.Items[Cell.Row];
    end;

    try
      p.Count := StrToInt(Value);
    except
      p.Count := 0;
    end;
  end;
end;

procedure TfrmRockSampleSizeTypesEdit.Save;
begin
  inherited;
  if DataLoaded then
  begin
     // подменяем на настоящий интервал отбора керна
     if (not Assigned(EditingObject)) or (EditingObject is ParentClass) then
       FEditingObject := Well.Slottings.Items[Well.Slottings.Count - 1];

    (EditingObject as TSlotting).RockSampleSizeTypePresences.Assign((ShadeEditingObject as TSlotting).RockSampleSizeTypePresences);
    grdSampleSizeTypes.AllowEdit := false;
  end;
end;

procedure TfrmRockSampleSizeTypesEdit.grdSampleSizeTypesDblClick(
  Sender: TObject);
begin
  inherited;
  if (grdSampleSizeTypes.Col = 0) then
  begin
    if not Assigned(frmIDObjectList) then frmIDObjectList := TfrmIDObjectList.Create(Self);
    frmIDObjectList.IDObjects := (TMainFacade.GetInstance as TMainFacade).AllRockSampleSizeTypes;
    frmIDObjectList.Caption := 'Типоразмеры образцов';

    frmIDObjectList.AddActionClass := TRockSampleSizeTypeAddAction;
    frmIDObjectList.EditActionClass := TRockSampleSizeTypeEditAction ;
    frmIDObjectList.ShowShortName := true;

    frmIDObjectList.ShowModal;
    grdSampleSizeTypes.Rows.Count := (TMainFacade.GetInstance as TMainFacade).AllRockSampleSizeTypes.Count;
  end
end;

destructor TfrmRockSampleSizeTypesEdit.Destroy;
begin

  inherited;
end;

procedure TfrmRockSampleSizeTypesEdit.FillParentControls;
begin
  inherited;
  grdSampleSizeTypes.AllowEdit := true;
  grdSampleSizeTypes.Rows.Count := (TMainFacade.GetInstance as TMainFacade).AllRockSampleSizeTypes.Count;
  grdSampleSizeTypes.Refresh;
end;

end.
