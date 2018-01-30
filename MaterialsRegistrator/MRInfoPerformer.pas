unit MRInfoPerformer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MRAllUsersFrame, StdCtrls, Buttons, ExtCtrls, Employee;

type
  TfrmSetPerformer = class(TForm)
    Panel8: TPanel;
    btnOk: TBitBtn;
    BitBtn17: TBitBtn;
    frmAllUsers: TfrmAllUsers;
    procedure frmAllEmployees1lstAllEmployeesDblClick(Sender: TObject);
  private
    FPerformer: TEmployee;
    { Private declarations }
  public
    { Public declarations }
    property Performer: TEmployee read FPerformer write FPerformer;

    constructor Create(AOnwer: TComponent); override;
    destructor  Destroy; override;
  end;

var
  frmSetPerformer: TfrmSetPerformer;

implementation

{$R *.dfm}

constructor TfrmSetPerformer.Create(AOnwer: TComponent);
begin
  inherited;
  FPerformer := TEmployee.Create(nil);

end;

destructor TfrmSetPerformer.Destroy;
begin
  FPerformer.Free;
  inherited;
end;

procedure TfrmSetPerformer.frmAllEmployees1lstAllEmployeesDblClick(Sender: TObject);
begin
  //Performer := frmAllEmployees.ActiveAuthor;
  ModalResult := mrOK;
end;

end.
