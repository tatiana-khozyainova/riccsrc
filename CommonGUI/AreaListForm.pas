unit AreaListForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonIDObjectListForm, CommonIDObjectListFrame, StdCtrls,
  ExtCtrls;

type
  TfrmAreaList = class(TfrmIDObjectList)
    procedure frmIDObjectListFramelwObjectsDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

var
  frmAreaList: TfrmAreaList;

implementation

uses Facade, SDFacade;

{$R *.dfm}

{ TfrmAreaList }

constructor TfrmAreaList.Create(AOwner: TComponent);
begin
  inherited;
  IDObjects := TMainFacade.GetInstance.AllAreas;
end;

procedure TfrmAreaList.frmIDObjectListFramelwObjectsDblClick(
  Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
