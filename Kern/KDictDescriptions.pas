unit KDictDescriptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, KInfoDictionaryFrame, ExtCtrls, KAllDicts, StdCtrls, Buttons;

type
  TfrmDicts = class(TForm)
    frmAllDicts: TfrmAllDicts;
    Splitter1: TSplitter;
    Panel1: TPanel;
    btnOK: TBitBtn;
    frmInfoDictionary: TfrmInfoDictionary;
    procedure btnOKClick(Sender: TObject);
    procedure frmAllDictslstAllDictsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure DoOnObjectAdd(Sender: TObject);
    procedure DoOnObjectDelete(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmDicts: TfrmDicts;

implementation

uses Facade;

{$R *.dfm}

{ TfrmDicts }

constructor TfrmDicts.Create(AOwner: TComponent);
begin
  inherited;

  frmAllDicts.GUIAdapter.OnAfterDelete := DoOnObjectDelete;
  frmAllDicts.GUIAdapter.OnAfterAdd := DoOnObjectAdd;
end;

procedure TfrmDicts.DoOnObjectAdd(Sender: TObject);
begin
  frmInfoDictionary.ActiveDict := frmAllDicts.ActiveDict;
end;

procedure TfrmDicts.DoOnObjectDelete(Sender: TObject);
begin
  frmInfoDictionary.ActiveDict := nil;
end;

procedure TfrmDicts.btnOKClick(Sender: TObject);
begin
  frmInfoDictionary.GUIAdapter.ChangeMade := true;
end;

procedure TfrmDicts.frmAllDictslstAllDictsClick(Sender: TObject);
begin
  frmInfoDictionary.ActiveDict := frmAllDicts.ActiveDict;

  if frmInfoDictionary.ActiveDict.Name = 'Литология (нередактируемый справочник)' then
    frmInfoDictionary.SetActiveElements(false)
  else frmInfoDictionary.SetActiveElements(true);
end;

procedure TfrmDicts.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  (TMainFacade.GetInstance as TMainFacade).ClearWords;
end;

end.
