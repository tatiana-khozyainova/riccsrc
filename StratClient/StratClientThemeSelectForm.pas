unit StratClientThemeSelectForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ToolEdit, ExtCtrls, Theme, Employee;

type
  TfrmThemeSelect = class(TForm)
    pnlButtons: TPanel;
    gbxTheme: TGroupBox;
    lblTheme: TLabel;
    cmbxTheme: TComboBox;
    dtedtSignedDate: TDateEdit;
    lblSignedDate: TLabel;
    lblEmployee: TLabel;
    cmbxEmployee: TComboBox;
    btnOK: TButton;
    btnCancel: TButton;
    lblAttention: TLabel;
  private
    function GetEmployee: TEmployee;
    function GetTheme: TTheme;
    function GetDate: TDateTime;
    { Private declarations }
  public
    { Public declarations }
    property Theme: TTheme read GetTheme;
    property Employee: TEmployee read GetEmployee;
    property SiginingDate: TDateTime read GetDate;
    constructor Create(AOwner: TComponent);override;
  end;

var
  frmThemeSelect: TfrmThemeSelect;

implementation

uses Facade, BaseConsts;

{$R *.dfm}

{ TfrmThemeSelect }

constructor TfrmThemeSelect.Create(AOwner: TComponent);
begin
  inherited;

  (TMainFacade.GetInstance as TMainFacade).AllThemes.MakeList(cmbxTheme.Items);
  (TMainFacade.GetInstance).AllEmployees.MakeList(cmbxEmployee.Items);

  cmbxEmployee.ItemIndex := cmbxEmployee.Items.IndexOfObject((TMainFacade.GetInstance).AllEmployees.ItemsByID[EMPLOYEE_NIKONOV]);
end;

function TfrmThemeSelect.GetDate: TDateTime;
begin
  Result := dtedtSignedDate.Date;
end;

function TfrmThemeSelect.GetEmployee: TEmployee;
begin
  Result := cmbxEmployee.Items.Objects[cmbxEmployee.ItemIndex] as TEmployee;
end;

function TfrmThemeSelect.GetTheme: TTheme;
begin
  Result := cmbxTheme.Items.Objects[cmbxTheme.ItemIndex] as TTheme;
end;

end.
