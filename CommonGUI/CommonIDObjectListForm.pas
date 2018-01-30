unit CommonIDObjectListForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CommonIDObjectListFrame, ExtCtrls, BaseObjects,
  CommonObjectSelector, BaseActions, ComCtrls;

type
  TModalButton = (mbOK, mbCancel, mbClose);
  TModalButtons = set of TModalButton;

  TfrmIDObjectList = class(TForm, IObjectSelector)
    pnlButtons: TPanel;
    frmIDObjectListFrame: TfrmIDObjectListFrame;
    btnClose: TButton;
    btnCancel: TButton;
    btnOk: TButton;
    procedure frmIDObjectListFramelwObjectsDblClick(Sender: TObject);
    procedure frmIDObjectListFramelwObjectsMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    FIDObjects: TIDObjects;
    FShowShortName: boolean;
    FButtons: TModalButtons;
    FShowID: boolean;
    FMultiSelect: boolean;
    FShowNavigationButtons: boolean;
    procedure SetIDObjects(const Value: TIDObjects);
    procedure SetAddActionClass(const Value: TBaseActionClass);
    procedure SetDeleteActionClass(const Value: TBaseActionClass);
    procedure SetEditActionClass(const Value: TBaseActionClass);
    procedure SetShowShortName(const Value: boolean);
    function GetAddActionClass: TBaseActionClass;
    function GetDeleteActionClass: TBaseActionClass;
    function GetEditActionClass: TBaseActionClass;
    procedure SetButtons(const Value: TModalButtons);
    procedure SetShowID(const Value: boolean);
    procedure SetShowNavigationButtons(const Value: boolean);
    function GetIsEditable: boolean;
    procedure SetIsEditable(const Value: boolean);
  protected
    procedure SetMultiSelect(const Value: boolean);
    function  GetMultiSelect: boolean;
    procedure SetSelectedObject(AValue: TIDObject);
    function  GetSelectedObject: TIDObject;
    function  GetSelectedObjects: TIDObjects;
    procedure SetSelectedObjects(AValue: TIDObjects);
  public
    { Public declarations }
    property  AddActionClass: TBaseActionClass read GetAddActionClass write SetAddActionClass;
    property  EditActionClass: TBaseActionClass read GetEditActionClass write SetEditActionClass;
    property  DeleteActionClass: TBaseActionClass read GetDeleteActionClass write SetDeleteActionClass;
    property  ShowShortName: boolean read FShowShortName write SetShowShortName;
    property  ShowNavigationButtons: boolean read FShowNavigationButtons write SetShowNavigationButtons;

    property  ShowID: boolean read FShowID write SetShowID;
    property  MultiSelect: boolean read FMultiSelect write SetMultiSelect;
    property  SelectedObjects: TIDObjects read GetSelectedObjects write SetSelectedObjects;
    property  IsEditable: boolean read GetIsEditable write SetIsEditable;

    procedure ReadSelectedObjects;



    property    IDObjects: TIDObjects read FIDObjects write SetIDObjects;
    property    Buttons: TModalButtons read FButtons write SetButtons;
    constructor Create(AOwner: TCOmponent); override;
  end;

  TfrmIDObjectListFormClass = class of TfrmIDObjectList;

var
  frmIDObjectList: TfrmIDObjectList;

implementation

{$R *.dfm}

{ TfrmIDObjectList }

procedure TfrmIDObjectList.SetIDObjects(const Value: TIDObjects);
begin
  if FIDObjects <> Value then
  begin
    FIDObjects := Value;
    frmIDObjectListFrame.ObjectList := FIdObjects;
  end;
end;


function TfrmIDObjectList.GetSelectedObject: TIDObject;
begin
  Result := frmIDObjectListFrame.SelectedObject;
end;

procedure TfrmIDObjectList.SetSelectedObject(AValue: TIDObject);
begin
  frmIDObjectListFrame.SelectedObject := AValue;
end;

procedure TfrmIDObjectList.SetAddActionClass(
  const Value: TBaseActionClass);
begin
  frmIDObjectListFrame.AddActionClass := Value;
end;

procedure TfrmIDObjectList.SetDeleteActionClass(
  const Value: TBaseActionClass);
begin
  frmIDObjectListFrame.DeleteActionClass := Value;
end;

procedure TfrmIDObjectList.SetEditActionClass(
  const Value: TBaseActionClass);
begin
  frmIDObjectListFrame.EditActionClass := Value;
end;

procedure TfrmIDObjectList.SetShowShortName(const Value: boolean);
begin
  FShowShortName := Value;
  frmIDObjectListFrame.ShowShortName := FShowShortName;
end;

function TfrmIDObjectList.GetAddActionClass: TBaseActionClass;
begin
  Result := frmIDObjectListFrame.AddActionClass;
end;

function TfrmIDObjectList.GetDeleteActionClass: TBaseActionClass;
begin
  Result := frmIDObjectListFrame.DeleteActionClass;
end;

function TfrmIDObjectList.GetEditActionClass: TBaseActionClass;
begin
  Result := frmIDObjectListFrame.EditActionClass;
end;

procedure TfrmIDObjectList.SetMultiSelect(const Value: boolean);
begin
  frmIDObjectListFrame.MultiSelect := Value;
end;

function TfrmIDObjectList.GetMultiSelect: boolean;
begin
  Result := frmIDObjectListFrame.MultiSelect;
end;

function TfrmIDObjectList.GetSelectedObjects: TIDObjects;
begin
  Result := frmIDObjectListFrame.SelectedObjects;
end;

procedure TfrmIDObjectList.SetSelectedObjects(AValue: TIDObjects);
begin
  frmIDObjectListFrame.SelectedObjects := AValue;
end;

constructor TfrmIDObjectList.Create(AOwner: TCOmponent);
begin
  inherited;
  FButtons := [mbCancel];
end;

procedure TfrmIDObjectList.SetButtons(const Value: TModalButtons);
begin
  if FButtons <> Value then
  begin
    FButtons := Value;

    btnClose.Visible := mbClose in FButtons;
    btnCancel.Visible := mbCancel in FButtons;
    btnOk.Visible := mbOK in FButtons;
  end;
end;

procedure TfrmIDObjectList.SetShowID(const Value: boolean);
begin
  FShowID := Value;
  frmIDObjectListFrame.ShowID := FShowID;
end;

procedure TfrmIDObjectList.ReadSelectedObjects;
begin
  frmIDObjectListFrame.ReadSelectedObjects;
end;

procedure TfrmIDObjectList.SetShowNavigationButtons(const Value: boolean);
begin
  FShowNavigationButtons := Value;
  frmIDObjectListFrame.ShowNavigationButtons := FShowNavigationButtons;
end;

function TfrmIDObjectList.GetIsEditable: boolean;
begin
  Result := frmIDObjectListFrame.IsEditable;
end;

procedure TfrmIDObjectList.SetIsEditable(const Value: boolean);
begin
  frmIDObjectListFrame.IsEditable := Value;
end;

procedure TfrmIDObjectList.frmIDObjectListFramelwObjectsDblClick(
  Sender: TObject);
begin
  //
end;

procedure TfrmIDObjectList.frmIDObjectListFramelwObjectsMouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var li: TListItem;
begin
  if ssDouble in Shift then
  begin
    li := frmIDObjectListFrame.lwObjects.GetItemAt(X, Y);
    if Assigned(li) then
    begin
      li.Selected := True;
      ModalResult := mrOk;
    end;
  end;
end;


end.
