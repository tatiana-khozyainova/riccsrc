unit CommonIDObjectEditFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonFrame, ComCtrls, StdCtrls, ExtCtrls, BaseObjects, BaseGUI;

type
  TfrmIDObjectEditFrame = class(TfrmCommonFrame)
    gbxObjectInfo: TGroupBox;
    edtName: TLabeledEdit;
    edtShortName: TLabeledEdit;
  private
    { Private declarations }
    FShowShortName: boolean;
    FIDObjects: TIDObjects;
    function  GetIDObject: TIDObject;
  protected
    procedure FillControls(ABaseObject: TIDObject); override;
    procedure ClearControls; override;

    procedure RegisterInspector; override;
    function  InternalCheck: boolean; override;
    function  GetParentCollection: TIDObjects; override;
    procedure SetShowShortName(const Value: boolean); virtual;
  public
    { Public declarations }
    property ShowShortName: boolean read FShowShortName write SetShowShortName;
    property IDObject: TIDObject read GetIDObject;
    property ParentIDObjects: TIDObjects read FIDObjects write FIDObjects;

    constructor Create(AOwner: TComponent); override;
    procedure   Save(AObject: TIDObject = nil); override;
  end;

var
  frmIDObjectEditFrame: TfrmIDObjectEditFrame;

implementation

type
  EParentCollectionNotAssigned = class(Exception)
    constructor Create;
  end;

{$R *.dfm}

{ TfrmIDObjectEditFrame }

procedure TfrmIDObjectEditFrame.ClearControls;
begin
  inherited;
  edtName.Clear;
  edtShortName.Clear;
end;

constructor TfrmIDObjectEditFrame.Create(AOwner: TComponent);
begin
  inherited;
  EditingClass := TIDObject;
  ParentClass := nil;
end;

procedure TfrmIDObjectEditFrame.FillControls(ABaseObject: TIDObject);
begin
  inherited;
  edtName.Text := IDObject.Name;
  edtShortName.Text := IDObject.ShortName;
  if (Owner.Owner is TForm) then
     (Owner.Owner as TForm).Caption := IDObject.ClassIDString;
  FillParentControls;
end;

function TfrmIDObjectEditFrame.GetIDObject: TIDObject;
begin
  Result := EditingObject;
end;

function TfrmIDObjectEditFrame.GetParentCollection: TIDObjects;
begin
  Result := ParentIDObjects;
end;

function TfrmIDObjectEditFrame.InternalCheck: boolean;
begin
  Result := inherited InternalCheck;
end;

procedure TfrmIDObjectEditFrame.RegisterInspector;
begin
  inherited;
  Inspector.Add(edtName, nil, ptString, 'название объекта', false)
end;

procedure TfrmIDObjectEditFrame.Save;
begin
  inherited;


  if not Assigned(IDObject) then
    if Assigned(FIDObjects) then
      FEditingObject := FIDObjects.Add
    else
      raise EParentCollectionNotAssigned.Create;

  IDObject.Name := edtName.Text;
  IDObject.ShortName := edtShortName.Text;
end;

procedure TfrmIDObjectEditFrame.SetShowShortName(const Value: boolean);
begin
  FShowShortName := Value;
  edtShortName.Visible := FShowShortName;
  edtShortName.EditLabel.Visible := FShowShortName;
  edtShortName.Refresh;
end;

{ EParentCollectionNotAssigned }

constructor EParentCollectionNotAssigned.Create;
begin
  inherited Create('Базовая коллекция не задана');
end;

end.
