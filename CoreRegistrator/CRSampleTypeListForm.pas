unit CRSampleTypeListForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonIDObjectListForm, CommonIDObjectListFrame, StdCtrls,
  ExtCtrls;

type
  TfrmSampleTypeList = class(TfrmIDObjectList)
    procedure frmIDObjectListFramelwObjectsDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmSampleTypeList: TfrmSampleTypeList;

implementation

uses Facade;

{$R *.dfm}

{ TfrmSampleTypeList }

constructor TfrmSampleTypeList.Create(AOwner: TComponent);
begin
  inherited;
  IDObjects := (TMainFacade.GetInstance as TMainFacade).AllRockSampleTypes;
  Caption := 'Тип образца';
end;

procedure TfrmSampleTypeList.frmIDObjectListFramelwObjectsDblClick(
  Sender: TObject);
begin
  ModalResult := mrOK;
end;

end.
