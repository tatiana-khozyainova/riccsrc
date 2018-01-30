unit MRAllUsersFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UniButtonsFrame, StdCtrls, ExtCtrls, ActnList;

type
  TfrmAllUsers = class(TFrame)
    actnFilter: TActionList;
    actnAllEmployee: TAction;
    actnOurEmployee: TAction;
    actnOutsideEmployee: TAction;
    grp1: TGroupBox;
    grp2: TGroupBox;
    rbtnAllEmployee: TRadioButton;
    rbtnAllOurEmployee: TRadioButton;
    rbtnAllOutsideEmployee: TRadioButton;
    grp3: TGroupBox;
    lstAllEmployees: TListBox;
    pnl1: TPanel;
    lblFilter: TLabel;
    frmButtons: TfrmButtons;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
