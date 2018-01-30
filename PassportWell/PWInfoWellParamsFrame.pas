unit PWInfoWellParamsFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonFrame, ToolWin, ComCtrls, StdCtrls, ExtCtrls, Well, BaseObjects,
  Parameter, ActnList, ImgList, CommonValueDictFrame;

type
  TfrmInfoWellParams = class(TfrmCommonFrame)
    Splitter1: TSplitter;
    GroupBox1: TGroupBox;
    tvAllParametrs: TTreeView;
    gbx: TGroupBox;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    actnLst: TActionList;
    imgLst: TImageList;
    actnAddParameter: TAction;
    actnDelParameter: TAction;
    actnEditParameter: TAction;
    GroupBox3: TGroupBox;
    edtVchValue: TEdit;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    edtIntValue: TEdit;
    dtmValue: TDateTimePicker;
    ToolBar2: TToolBar;
    ToolButton4: TToolButton;
    actnSaveValue: TAction;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    actnAddGroupParams: TAction;
    frmFilterMUnits: TfrmFilter;
    frmFilterMUs: TfrmFilter;
    ToolButton7: TToolButton;
    actnDelValue: TAction;
    procedure actnAddParameterExecute(Sender: TObject);
    procedure actnDelParameterExecute(Sender: TObject);
    procedure actnEditParameterExecute(Sender: TObject);
    procedure actnSaveValueExecute(Sender: TObject);
    procedure actnAddGroupParamsExecute(Sender: TObject);
    procedure tvAllParametrsClick(Sender: TObject);
    procedure edtIntValueChange(Sender: TObject);
    procedure edtVchValueChange(Sender: TObject);
    procedure dtmValueChange(Sender: TObject);
    procedure edtIntValueKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtVchValueKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dtmValueKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure actnDelValueExecute(Sender: TObject);
  private
    FChanging: boolean;
    FPreActiveParametr: TParameterByWell;
    function  GetWell: TDinamicWell;
    function  GetActiveParametr: TParameterByWell;
    function  GetActiveParametrValue: TParameterValueByWell;
    function  GetActiveGroupParametr: TParametersGroupByWell;
  protected
    procedure FillControls(ABaseObject: TIDObject); override;
    procedure ClearControls; override;
    procedure FillParentControls; override;
    procedure RegisterInspector; override;
    function  GetParentCollection: TIDObjects; override;
  public
    property    Well: TDinamicWell read GetWell;

    property    Changing: boolean read FChanging write FChanging;

    property    ActiveGroupParametr: TParametersGroupByWell read GetActiveGroupParametr;
    property    ActiveParametr: TParameterByWell read GetActiveParametr;
    property    PreActiveParametr: TParameterByWell read FPreActiveParametr write FPreActiveParametr;

    property    ActiveParametrValue: TParameterValueByWell read GetActiveParametrValue;


    procedure   Clear; override;
    procedure   Save(AObject: TIDObject = nil);  override;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

var
  frmInfoWellParams: TfrmInfoWellParams;

implementation

uses Facade, AddUnits, AddObjectFrame, Math, MeasureUnits, SDFacade,
  Registrator;

{$R *.dfm}

{ TfrmInfoWellParams }

procedure TfrmInfoWellParams.ClearControls;
begin
  inherited;
  (TMainFacade.GetInstance as TMainFacade).AllParametersGroups.MakeList(tvAllParametrs, true, true);

  frmFilterMUnits.AllObjects := TMainFacade.GetInstance.AllMeasureUnits;
  frmFilterMUs.AllObjects := TMainFacade.GetInstance.AllMeasureUnits;

  frmFilterMUnits.cbxActiveObject.Text := '<не указана>';
  frmFilterMUs.cbxActiveObject.Text := '<не указана>';

  Clear;
end;

constructor TfrmInfoWellParams.Create(AOwner: TComponent);
begin
  inherited;
  EditingClass := TDinamicWell;
  FChanging := false;
end;

destructor TfrmInfoWellParams.Destroy;
begin

  inherited;
end;

procedure TfrmInfoWellParams.FillControls(ABaseObject: TIDObject);
begin
  inherited;

  with EditingObject as TDinamicWell do
  begin
    if Assigned (ActiveParametr) then
    if Assigned (ActiveParametr.MeasureUnit) then
    begin
      frmFilterMUnits.ActiveObject := ActiveParametr.MeasureUnit;
      frmFilterMUs.ActiveObject := ActiveParametr.MeasureUnit;
    end;

    if Assigned (ActiveParametrValue) then
    begin
      edtIntValue.Text := IntToStr(ActiveParametrValue.INTValue);
      edtVchValue.Text := ActiveParametrValue.VCHValue;
      dtmValue.Date := ActiveParametrValue.DTMValue;
    end;
  end;
end;

procedure TfrmInfoWellParams.FillParentControls;
begin
  inherited;

end;

function TfrmInfoWellParams.GetActiveParametr: TParameterByWell;
begin
  Result := nil;

  if tvAllParametrs.Items.Count > 0 then
  if Assigned (tvAllParametrs.Selected) then
  if tvAllParametrs.Selected.Level = 1 then
    Result := TParameterByWell(tvAllParametrs.Selected.Data);
end;

function TfrmInfoWellParams.GetParentCollection: TIDObjects;
begin
  Result := nil;
end;

function TfrmInfoWellParams.GetWell: TDinamicWell;
begin
  if EditingObject is TDinamicWell then
    Result := EditingObject as TDinamicWell
  else
    Result := nil;
end;

procedure TfrmInfoWellParams.RegisterInspector;
begin
  inherited;

end;

procedure TfrmInfoWellParams.Save;
begin
  inherited;

  //if (not Assigned(EditingObject)) or (EditingObject is ParentClass) then
  //  FEditingObject := TMainFacade.GetInstance.AllWells.Items[TMainFacade.GetInstance.AllWells.Count - 1];
    
  with Well.ParametrValues do
  begin

  end;
end;

procedure TfrmInfoWellParams.actnAddParameterExecute(Sender: TObject);
var o: TParameterByWell;
begin
  inherited;

  frmEditor := TfrmEditor.Create(Self);
  frmEditor.Caption := 'Группа параметров "' + ActiveGroupParametr.Name + '"';

  frmEditor.frmAddObject.frmFilterDicts.Visible := true;
  frmEditor.frmAddObject.edtName.Width := frmEditor.frmAddObject.gbx.Width - 15;
  frmEditor.frmAddObject.frmFilterDicts.gbx.Caption := 'Ед. изм.';
  frmEditor.frmAddObject.frmFilterDicts.AllObjects := TMainFacade.GetInstance.AllMeasureUnits;
  frmEditor.frmAddObject.frmFilterDicts.cbxActiveObject.Text := '<не указана>';

  if frmEditor.ShowModal = mrOk then
  if frmEditor.frmAddObject.Save then
  begin
    o := TParameterByWell.Create(ActiveGroupParametr.Parameters);
    o.Name := frmEditor.frmAddObject.Name;

    if Assigned (frmEditor.frmAddObject.frmFilterDicts.ActiveObject) then
      o.MeasureUnit := frmEditor.frmAddObject.frmFilterDicts.ActiveObject as TMeasureUnit;

    o.Update;
    ActiveGroupParametr.Parameters.Add(o);
    (TMainFacade.GetInstance as TMainFacade).AllParametersGroups.MakeList(tvAllParametrs, true, true);
  end;

  frmEditor.Free;
end;

procedure TfrmInfoWellParams.actnDelParameterExecute(Sender: TObject);
begin
  inherited;
  if MessageBox(0, 'Вы действительно хотите удалить объект ?', 'Вопрос', MB_YESNO + MB_ICONWARNING + MB_APPLMODAL) = ID_YES then
  begin
    ActiveGroupParametr.Parameters.Remove(ActiveParametr);
    (TMainFacade.GetInstance as TMainFacade).AllParametersGroups.MakeList(tvAllParametrs, true, true);
  end;
end;

procedure TfrmInfoWellParams.actnEditParameterExecute(Sender: TObject);
begin
  inherited;

  if Assigned (ActiveParametr) then
  begin
    frmEditor := TfrmEditor.Create(Self);
    frmEditor.Caption := 'Группа параметров "' + ActiveGroupParametr.Name + '"';

    frmEditor.frmAddObject.Name := trim(ActiveParametr.Name);

    frmEditor.frmAddObject.frmFilterDicts.Visible := true;
    frmEditor.frmAddObject.edtName.Width := frmEditor.frmAddObject.gbx.Width - 15;
    frmEditor.frmAddObject.frmFilterDicts.gbx.Caption := 'Ед. изм.';
    frmEditor.frmAddObject.frmFilterDicts.AllObjects := TMainFacade.GetInstance.AllMeasureUnits;

    if Assigned (ActiveParametr.MeasureUnit) then
      frmEditor.frmAddObject.frmFilterDicts.ActiveObject := ActiveParametr.MeasureUnit
    else frmEditor.frmAddObject.frmFilterDicts.cbxActiveObject.Text := '<не указана>';

    if frmEditor.ShowModal = mrOk then
    if frmEditor.frmAddObject.Save then
    begin
      ActiveParametr.Name := frmEditor.frmAddObject.Name;

      if Assigned (frmEditor.frmAddObject.frmFilterDicts.ActiveObject) then
        ActiveParametr.MeasureUnit := frmEditor.frmAddObject.frmFilterDicts.ActiveObject as TMeasureUnit;

      ActiveParametr.Update;
    end;
    frmEditor.Free;
  end
  else MessageBox(0, 'Параметр для редактирования не задан.', 'Ошибка', MB_OK + MB_ICONERROR + MB_APPLMODAL);
end;

procedure TfrmInfoWellParams.actnSaveValueExecute(Sender: TObject);
var o : TParameterValueByWell;
begin
  inherited;

  if not Assigned (ActiveParametrValue) then
  begin
    o := TParameterValueByWell.Create(Well.ParametrValues);
    o.ParametrWell := PreActiveParametr;
    Well.ParametrValues.Add(o);
  end;

  with ActiveParametrValue do
  begin
    ParametrWell := PreActiveParametr;

    INTValue := StrToInt(trim(edtIntValue.Text));
    VCHValue := trim(edtVchValue.Text);
    DTMValue := Date;
  end;
end;

function TfrmInfoWellParams.GetActiveParametrValue: TParameterValueByWell;
var i: integer;
begin
  Result := nil;

  if Assigned (PreActiveParametr) then
  if Well.ParametrValues.Count > 0 then
  begin
    for i := 0 to Well.ParametrValues.Count - 1 do
    if well.ParametrValues.Items[i].ParametrWell.ID = PreActiveParametr.ID then
      Result := Well.ParametrValues.Items[i];
  end;
end;

procedure TfrmInfoWellParams.actnAddGroupParamsExecute(Sender: TObject);
var o: TParametersGroupByWell;
begin
  inherited;

  frmEditor := TfrmEditor.Create(Self);
  frmEditor.Caption := 'Укажате название новой группы параметров';

  if frmEditor.ShowModal = mrOk then
  if frmEditor.frmAddObject.Save then
  begin
    o := TParametersGroupByWell.Create((TMainFacade.GetInstance as TMainFacade).AllParametersGroups);
    o.Name := frmEditor.frmAddObject.Name;
    o.Update;
    (TMainFacade.GetInstance as TMainFacade).AllParametersGroups.Add(o);
    (TMainFacade.GetInstance as TMainFacade).AllParametersGroups.MakeList(tvAllParametrs);
  end;

  frmEditor.Free;
end;

function TfrmInfoWellParams.GetActiveGroupParametr: TParametersGroupByWell;
begin
  Result := nil;

  if tvAllParametrs.Items.Count > 0 then
  if tvAllParametrs.Selected.Level = 0 then
    Result := TParametersGroupByWell(tvAllParametrs.Selected.Data)
  else if tvAllParametrs.Selected.Level = 1 then
    Result := TParametersGroupByWell(tvAllParametrs.Selected.Parent.Data)
end;

procedure TfrmInfoWellParams.tvAllParametrsClick(Sender: TObject);
begin
  inherited;

  if Assigned (PreActiveParametr) then
  if FChanging then
  if MessageBox(0, PChar('Значение параметра "' + trim(PreActiveParametr.Name) + '" было изменено. Сохранить изменения ?'), 'Вопрос', MB_ICONWARNING + MB_YESNO + MB_APPLMODAL) = ID_YES then
    actnSaveValue.Execute;

  FChanging := false;
  Clear;

  if tvAllParametrs.Items.Count > 0 then
  if Assigned (tvAllParametrs.Selected) then
  case tvAllParametrs.Selected.Level of
    0 : begin
          Clear;
        end;
    1 : begin
          gbx.Caption := 'Значение параметра "' + trim(ActiveParametr.Name) + '"';
          PreActiveParametr := ActiveParametr;
          FillControls(Well);
        end;
  end;
end;

procedure TfrmInfoWellParams.Clear;
begin
  gbx.Caption := 'Значение параметра';
  edtIntValue.Text := '';
  edtVchValue.Text := '';
  dtmValue.Date := Date;

  frmFilterMUnits.ActiveObject := nil;
  frmFilterMUs.ActiveObject := nil;

  frmFilterMUnits.cbxActiveObject.Text := '<не указана>';
  frmFilterMUs.cbxActiveObject.Text := '<не указана>';
end;

procedure TfrmInfoWellParams.edtIntValueChange(Sender: TObject);
begin
  inherited;
  //FChanging := true;
end;

procedure TfrmInfoWellParams.edtVchValueChange(Sender: TObject);
begin
  inherited;
  //FChanging := true;
end;

procedure TfrmInfoWellParams.dtmValueChange(Sender: TObject);
begin
  inherited;
  //FChanging := true;
end;

procedure TfrmInfoWellParams.edtIntValueKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  FChanging := true;
end;

procedure TfrmInfoWellParams.edtVchValueKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  FChanging := true;
end;

procedure TfrmInfoWellParams.dtmValueKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  FChanging := true;
end;

procedure TfrmInfoWellParams.actnDelValueExecute(Sender: TObject);
begin
  inherited;

  if Assigned (ActiveParametrValue) then
  begin
    Well.ParametrValues.Remove(ActiveParametrValue);
    FillControls(Well);
  end
  else MessageBox(0, '', '', MB_ICONERROR + MB_OK + MB_APPLMODAL);
end;

end.

