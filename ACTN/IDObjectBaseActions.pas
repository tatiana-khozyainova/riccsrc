unit IDObjectBaseActions;

interface

uses BaseActions, BaseObjects, Classes, Controls,
     SysUtils, CommonIDObjectEditForm, Windows;

type
  TIDObjectBaseLoadAction = class(TBaseAction)

  end;

  TIDObjectEditAction = class(TBaseAction)
  private
    FfrmIDObjectEditClass: TfrmIDObjectEditClass;
  protected
    FfrmIDObjectEdit: TfrmIDObjectEdit;
    procedure SetShortName; virtual;
  public
    property frmIDObjectEdit: TfrmIDObjectEdit read FfrmIDObjectEdit;
    property frmIDObjectEditClass: TfrmIDObjectEditClass read FfrmIDObjectEditClass write FfrmIDObjectEditClass;
    function Execute(ABaseObject: TIDObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TIDObjectWithShortNameEditAction = class(TIDObjectEditAction)
  protected
    procedure SetShortName; override;
  end;

  TIDObjectAddAction = class(TIDObjectEditAction)
  public
    function Execute: boolean; override;
    function Execute(ABaseObject: TIDObject): boolean; override;
    function Execute(ABaseCollection: TIDObjects): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TIDObjectWithShortNameAddAction = class(TIDObjectWithShortNameEditAction)
  public
    function Execute: boolean; override;
    function Execute(ABaseObject: TIDObject): boolean; override;
    function Execute(ABaseCollection: TIDObjects): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TIDObjectDeleteAction = class(TBaseAction)
  public
    function Execute(ABaseObject: TIDObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses CommonFrame, CommonIDObjectEditFrame;

{ TIDObjectEditAction }

constructor TIDObjectEditAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  Caption := 'Редактировать объект справочника';
  frmIDObjectEditClass := TfrmIDObjectEdit;
end;

function TIDObjectEditAction.Execute(ABaseObject: TIDObject): boolean;
var IDObjects: TIDObjects;
begin
  IDObjects := nil;
  if Assigned(frmIDObjectEdit) then
    IDObjects := frmIDObjectEdit.IDObjects;

  FreeAndNil(FfrmIDObjectEdit);
  FfrmIDObjectEdit := frmIDObjectEditClass.Create(Self);
  frmIDObjectEdit.IDObjects := IDObjects;


  Result := true;
  frmIDObjectEdit.Clear;
  frmIDObjectEdit.EditingObject := ABaseObject;
  frmIDObjectEdit.dlg.ActiveFrameIndex := 0;
  frmIDObjectEdit.ShowNavigationButtons := false;

  SetShortName;

  if frmIDObjectEdit.ShowModal = mrOK then
  begin
    frmIDObjectEdit.Save;
    // это у нас такая транзакционность - самый простой случай
    try
      ABaseObject := (frmIDObjectEdit.dlg.Frames[0] as TfrmCommonFrame).EditingObject;
      ABaseObject.Update;
    except
      on E: Exception do
      begin
        if Assigned(LastObjectCopy) then ABaseObject.Assign(LastObjectCopy)
        else FreeAndNil(ABaseObject);

        raise EObjectAddingException.Create(ABaseObject, E);
      end;
    end;
  end;
end;

procedure TIDObjectEditAction.SetShortName;
begin
  if (frmIDObjectEdit.dlg.Frames[0] is TfrmIDObjectEditFrame) then
    (frmIDObjectEdit.dlg.Frames[0] as TfrmIDObjectEditFrame).ShowShortName := false;
end;

{ TIDObjectAddAction }

constructor TIDObjectAddAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  Caption := 'Добавить объект справочника';
end;

function TIDObjectAddAction.Execute: boolean;
begin
  Result := Execute(TIDObject(nil));
end;

function TIDObjectAddAction.Execute(ABaseObject: TIDObject): boolean;
begin
  Result := inherited Execute(ABaseObject);
end;

function TIDObjectAddAction.Execute(ABaseCollection: TIDObjects): boolean;
begin
  if not Assigned(frmIDObjectEdit) then FfrmIDObjectEdit := frmIDObjectEditClass.Create(Self);

  frmIDObjectEdit.Clear;
  frmIDObjectEdit.IDObjects := ABaseCollection;

  Result := Execute;
end;


{ TIDObjectDeleteAction }

constructor TIDObjectDeleteAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  Caption := 'Удалить объект справочника';
end;

function TIDObjectDeleteAction.Execute(ABaseObject: TIDObject): boolean;
begin
  Result := true;
  if MessageBox(0, PChar('Вы действительно хотите удалить объект справочника ' +  #13#10 +
                         ABaseObject.List + '?'), 'Вопрос',
                         MB_YESNO+MB_TASKMODAL+MB_DEFBUTTON2+MB_ICONQUESTION) = ID_YES then
  begin
    try
      ABaseObject.Collection.Remove(ABaseObject);
    except
      on E: Exception do
      begin
        if Assigned(LastObjectCopy) then ABaseObject.Assign(LastObjectCopy);
        raise EObjectDeletingException.Create(ABaseObject);
      end;
    end;
  end;
end;

{ TIDObjectWithShortNameEditAction }

procedure TIDObjectWithShortNameEditAction.SetShortName;
begin
  (frmIDObjectEdit.dlg.Frames[0] as TfrmIDObjectEditFrame).ShowShortName := true;
end;

{ TIDObjectWithShortNameAddAction }

constructor TIDObjectWithShortNameAddAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  Caption := 'Добавить объект справочника';
end;

function TIDObjectWithShortNameAddAction.Execute: boolean;
begin
  Result := Execute(TIDObject(nil));
end;

function TIDObjectWithShortNameAddAction.Execute(
  ABaseObject: TIDObject): boolean;
begin
  Result := inherited Execute(ABaseObject);
end;

function TIDObjectWithShortNameAddAction.Execute(
  ABaseCollection: TIDObjects): boolean;
begin
  if not Assigned(frmIDObjectEdit) then FfrmIDObjectEdit := TfrmIDObjectEdit.Create(Self);

  frmIDObjectEdit.Clear;
  frmIDObjectEdit.IDObjects := ABaseCollection;

  Result := Execute;
end;

end.
