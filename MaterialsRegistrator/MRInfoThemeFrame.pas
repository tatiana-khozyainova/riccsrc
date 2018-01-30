unit MRInfoThemeFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonFrame, Buttons, StdCtrls, ExtCtrls, ComCtrls, Theme, BaseObjects;

type
  TfrmInfoTheme = class(TfrmCommonFrame)
    grp1: TGroupBox;
    grp2: TGroupBox;
    mmName: TMemo;
    grp3: TGroupBox;
    grp4: TGroupBox;
    dtmPeriodBegin: TDateTimePicker;
    grp5: TGroupBox;
    dtmPeriodFinish: TDateTimePicker;
    pnl1: TPanel;
    edtNumber: TLabeledEdit;
    edtFolder: TLabeledEdit;
    grp6: TGroupBox;
    btnSetAuthors: TButton;
    edtAuthors: TEdit;
    btnClear: TBitBtn;
    procedure btnSetAuthorsClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
  private
    function  GetTheme: TTheme;
    { Private declarations }
  protected
    procedure FillControls(ABaseObject: TIDObject); override;
    procedure ClearControls; override;
    procedure FillParentControls; override;
    procedure RegisterInspector; override;
    function  GetParentCollection: TIDObjects; override;
  public
    property  Theme: TTheme read GetTheme;

    procedure Save(AObject: TIDObject = nil); override;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;


var
  frmInfoTheme: TfrmInfoTheme;

implementation

uses MRInfoPerformer;

{$R *.dfm}

{ TfrmCommonFrame1 }

procedure TfrmInfoTheme.ClearControls;
begin
  inherited;

  edtNumber.Clear;
  mmName.Clear;
  edtFolder.Clear;

  dtmPeriodBegin.Date := Date;
  dtmPeriodFinish.Date := Date;
end;

constructor TfrmInfoTheme.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TfrmInfoTheme.Destroy;
begin

  inherited;
end;

procedure TfrmInfoTheme.FillControls(ABaseObject: TIDObject);
begin
  inherited;

  if Assigned (Theme) then
  with Theme do
  begin
    edtNumber.Text := trim(Number);
    edtFolder.Text := trim(Folder);
    mmName.Clear;
    mmName.Lines.Add(trim(Name));

    if Assigned (Performer) then edtAuthors.Text := Performer.Name
    else edtAuthors.Text := '<не указан>';

    if (trim(Number) <> '') then  // пересмотреть условие
    begin
      dtmPeriodBegin.DateTime := ActualPeriodStart;
      dtmPeriodFinish.DateTime := ActualPeriodFinish;
    end
    else
    begin
      dtmPeriodBegin.DateTime := Date;
      dtmPeriodFinish.DateTime := Date;
    end;
  end;
end;

procedure TfrmInfoTheme.FillParentControls;
begin
  inherited;

end;

function TfrmInfoTheme.GetParentCollection: TIDObjects;
begin

end;

function TfrmInfoTheme.GetTheme: TTheme;
begin

end;

procedure TfrmInfoTheme.RegisterInspector;
begin
  inherited;

end;

procedure TfrmInfoTheme.Save(AObject: TIDObject = nil); 
begin
  inherited;

  with Theme do
  if dtmPeriodBegin.Date <= dtmPeriodFinish.Date then
  begin
    Name := trim(mmName.Lines.Text);
    Number := trim(edtNumber.Text);
    Folder := trim (edtFolder.Text);
    ActualPeriodStart := dtmPeriodBegin.Date;
    ActualPeriodFinish := dtmPeriodFinish.Date;
    Text := '';
  end
  else MessageBox(0, 'Ошибка', 'Некорректно задан период актуальности темы.', MB_OK + MB_ICONERROR + MB_APPLMODAL);
end;

procedure TfrmInfoTheme.btnSetAuthorsClick(Sender: TObject);
begin
  inherited;

  frmSetPerformer := TfrmSetPerformer.Create(Self);

  if frmSetPerformer.ShowModal = mrOK then
  begin
    //Theme.Performer := frmSetPerformer.frmAllEmployees.ActiveAuthor;
    edtAuthors.Text := Theme.Performer.Name;
    //GUIAdapter.ChangeMade := true;
  end;

  frmSetPerformer.Free;
end;

procedure TfrmInfoTheme.btnClearClick(Sender: TObject);
begin
  inherited;
  //Performer := nil;
  edtAuthors.Text := '<не указан>';
end;

end.
