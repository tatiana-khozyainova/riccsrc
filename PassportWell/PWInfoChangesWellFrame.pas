unit PWInfoChangesWellFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Well, BaseObjects, CommonFrame, StdCtrls, ComCtrls, ExtCtrls,
  CommonValueDictFrame;

type
  TInfoChangesWell = class(TfrmCommonFrame)
    Panel5: TPanel;
    GroupBox8: TGroupBox;
    dtmEnteringData: TDateTimePicker;
    GroupBox9: TGroupBox;
    dtmLastModifyData: TDateTimePicker;
    GroupBox1: TGroupBox;
    mmBasicChange: TMemo;
    frmFilterEmployee: TfrmFilter;
    frmFilterReasonChange: TfrmFilter;
  private
    function GetWell: TWell;
  protected
    procedure FillControls(ABaseObject: TIDObject); override;
    procedure ClearControls; override;
    procedure FillParentControls; override;
    procedure RegisterInspector; override;
    function  GetParentCollection: TIDObjects; override;
  public
    property  Well: TWell read GetWell;

    procedure Save(AObject: TIDObject = nil); override;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  InfoChangesWell: TInfoChangesWell;

implementation

uses Facade, SDFacade, Employee, ReasonChange, DateUtils;

{$R *.dfm}

{ TfrmCommonFrame1 }

procedure TInfoChangesWell.ClearControls;
var EmpID: integer;
begin
  inherited;

  EmpID := TMainFacade.GetInstance.DBGates.EmployeeID;

  frmFilterEmployee.AllObjects := TMainFacade.GetInstance.AllEmployees;
  frmFilterEmployee.ActiveObject := TMainFacade.GetInstance.AllEmployees.ItemsByID[EmpID];
  frmFilterEmployee.Reload;

  frmFilterReasonChange.AllObjects := (TMainFacade.GetInstance as TMainFacade).ReasonChangesByWell;
  frmFilterReasonChange.ActiveObject := (TMainFacade.GetInstance as TMainFacade).ReasonChangesByWell.ItemsByID[EmpID];
  frmFilterReasonChange.Reload;
end;

constructor TInfoChangesWell.Create(AOwner: TComponent);
begin
  inherited;

  EditingClass := TWell;
end;

destructor TInfoChangesWell.Destroy;
begin

  inherited;
end;

procedure TInfoChangesWell.FillControls(ABaseObject: TIDObject);
begin
  inherited;

  with Well do
  begin
    //if Assigned (ReasonChange) then
    //if Assigned (ReasonChange.Employee) then
    //begin
    //  frmFilterEmployee.ActiveObject := ReasonChange.Employee;
    //  frmFilterEmployee.cbxActiveObject.Text := ReasonChange.Employee.Name;
    //end;
    if ID > 0 then
    begin
      if EnteringDate > 0 then
        dtmEnteringData.Date := EnteringDate
      else
        dtmEnteringData.Date := Date;

      if LastModifyDate > 0 then
        dtmLastModifyData.Date := LastModifyDate
      else
        dtmLastModifyData.Date := Date;
    end
    else
    begin
      dtmEnteringData.Date := Date;
      dtmLastModifyData.Date := Date;
    end;
  end;
end;

procedure TInfoChangesWell.FillParentControls;
begin
  inherited;

end;

function TInfoChangesWell.GetParentCollection: TIDObjects;
begin

end;

function TInfoChangesWell.GetWell: TWell;
begin
  Result := EditingObject as TWell;
end;

procedure TInfoChangesWell.RegisterInspector;
begin
  inherited;

end;

procedure TInfoChangesWell.Save;
var o: TReasonChange;
begin
  inherited;
  if Assigned (Well) then
  with Well do
  begin

    EnteringDate := DateOf(dtmEnteringData.Date);
    LastModifyDate := Date;

    // данные по сотруднику назначается автоматически при сохранении информации в БД

  end;
end;

end.
