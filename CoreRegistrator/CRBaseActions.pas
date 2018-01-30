unit CRBaseActions;

interface

uses BaseActions, BaseObjects,
     TestInterval, Controls,
     Classes, Windows, CoreInterfaces, LoggerImpl;

type

  TSlottingBaseLoadAction = class(TBaseAction)

  end;

  TSlottingBaseEditAction = class(TBaseAction, ILogger)
  private
    function GetLogger: TMemoLogger;
  public
    property  Logger: TMemoLogger read GetLogger implements ILogger;
    function  Execute(ABaseObject: TIDObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TSlottingBaseAddAction = class(TSlottingBaseEditAction)
  public
    function Execute: boolean; override;
    function Execute(ABaseObject: TIDObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TSlottingPlacementBaseAddAction = class(TBaseAction)
  public
    function Execute: boolean; override;
    function Execute(ABaseObject: TIDObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TSlottingDeleteAction = class(TBaseAction)
  public
    function Execute(ABaseObject: TIDObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TRockSampleSizeTypeEditAction = class(TBaseAction)
  public
    function Execute(ABaseObject: TIDObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;


  TRockSampleSizeTypeAddAction = class(TRockSampleSizeTypeEditAction)
  public
    function Execute: boolean; override;
    function Execute(ABaseObject: TIDObject): boolean; override;
    function Execute(ABaseCollection: TIDObjects): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TCollectionEditAction = class(TBaseAction)
  public
    function Execute(ABaseObject: TIDObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TCollectionAddAction = class(TCollectionEditAction)
  public
    function Execute(ABaseObject: TIDObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;


  TCollectionSampleEditAction = class(TBaseAction)
  public
    function Execute(ABaseObject: TIDObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

  TCollectionSampleAddAction = class(TCollectionSampleEditAction)
  public
    function Execute(ABaseObject: TIDObject): boolean; override;
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses CRSlottingEditForm, CommonFrame, SysUtils, CRSlottingPlacementEdit,
     Slotting, CRRockSampleSizeTypeEditFrame,
     CRSampleSizeTypeEditForm, CRCollectionEditForm, CRSampleEditForm, Well;

{ TSlottingBaseEditAction }

constructor TSlottingBaseEditAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  Caption := 'Редактировать интервал отбора керна';
end;

function TSlottingBaseEditAction.Execute(ABaseObject: TIDObject): boolean;
begin
  Result := true;
  if not Assigned(frmSlottingEdit) then frmSlottingEdit := TfrmSlottingEdit.Create(Self);

  frmSlottingEdit.ToolBarVisible := false;
  frmSlottingEdit.Clear;
  frmSlottingEdit.EditingObject := ABaseObject;
  frmSlottingEdit.dlg.ActiveFrameIndex := 0;

  if frmSlottingEdit.ShowModal = mrOK then
  begin
    frmSlottingEdit.Save;
    // это у нас такая транзакционность - самый простой случай
    try
      ABaseObject := (frmSlottingEdit.dlg.Frames[0] as TfrmCommonFrame).EditingObject;
      if ((ABaseObject as TSlotting).Owner is TWell) then ((ABaseObject as TSlotting).Owner as TWell).SlottingPlacement.Update();
      ABaseObject.Update;
      (ABaseObject as TSlotting).Boxes.Update(nil);
      (ABaseObject as TSlotting).RockSampleSizeTypePresences.Update(nil);
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

function TSlottingBaseEditAction.GetLogger: TMemoLogger;
begin
  Result := TMemoLogger.GetInstance;
end;


{ TSlottingBaseAddAction }

constructor TSlottingBaseAddAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  Caption := 'Добавить интервал отбора керна';
end;

function TSlottingBaseAddAction.Execute: boolean;
begin
  Result := Execute(nil);
end;

function TSlottingBaseAddAction.Execute(ABaseObject: TIDObject): boolean;
begin
  Result := inherited Execute(ABaseObject);
end;

{ TCoreMechanicalStateBaseEditAction }


{ TSlottingDeleteAction }

constructor TSlottingDeleteAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  Caption := 'Удалить интервал отбора керна';
end;

function TSlottingDeleteAction.Execute(ABaseObject: TIDObject): boolean;
begin
  Result := true;
  if MessageBox(0, PChar('Вы действительно хотите удалить интервал отбора керна ' +  #13#10 +
                         ABaseObject.List + '?'), 'Вопрос',
                         MB_YESNO+MB_TASKMODAL+MB_DEFBUTTON2+MB_ICONQUESTION) = ID_YES then
  begin
    try
      ABaseObject.Collection.Remove(ABaseObject);
    except
      on E: Exception do
      begin
        if Assigned(LastObjectCopy) then ABaseObject.Assign(LastObjectCopy)
        else FreeAndNil(ABaseObject);

        raise EObjectDeletingException.Create(ABaseObject);
      end;
    end;
  end;
end;

{ TSlottingPlacementBaseAddAction }

constructor TSlottingPlacementBaseAddAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  CanUndo := false;
  Caption := 'Редактировать местоположение керна';
end;

function TSlottingPlacementBaseAddAction.Execute: boolean;
begin
  Result := Execute(nil);
end;

function TSlottingPlacementBaseAddAction.Execute(
  ABaseObject: TIDObject): boolean;
begin
  Result := true;
  if not Assigned(frmSlottingPlacementEditForm) then frmSlottingPlacementEditForm := TfrmSlottingPlacementEditForm.Create(Self);

  frmSlottingPlacementEditForm.Clear;
  frmSlottingPlacementEditForm.EditingObject := ABaseObject;
  frmSlottingPlacementEditForm.dlg.ActiveFrameIndex := 0;

  if frmSlottingPlacementEditForm.ShowModal = mrOK then
  begin
    frmSlottingPlacementEditForm.Save;
    // это у нас такая транзакционность - самый простой случай
    try
      ABaseObject := (frmSlottingPlacementEditForm.dlg.Frames[0] as TfrmCommonFrame).EditingObject;
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

{ TRockSampleSizeTypeEditAction }

constructor TRockSampleSizeTypeEditAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  Caption := 'Редактировать типоразмер образца';
end;

function TRockSampleSizeTypeEditAction.Execute(
  ABaseObject: TIDObject): boolean;
begin
  if not Assigned(frmSampleSizeTypeEditor) then frmSampleSizeTypeEditor := TfrmSampleSizeTypeEditor.Create(Self);

  Result := true;
  frmSampleSizeTypeEditor.Clear;
  frmSampleSizeTypeEditor.EditingObject := ABaseObject;
  frmSampleSizeTypeEditor.dlg.ActiveFrameIndex := 0;

  (frmSampleSizeTypeEditor.dlg.Frames[0] as TfrmRockSampleSizeTypeEditFrame).ShowShortName := true;

  if frmSampleSizeTypeEditor.ShowModal = mrOK then
  begin
    frmSampleSizeTypeEditor.Save;
    // это у нас такая транзакционность - самый простой случай
    try
      ABaseObject := (frmSampleSizeTypeEditor.dlg.Frames[0] as TfrmCommonFrame).EditingObject;
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

                               
{ TRockSampleSizeTypeAddAction }

{constructor TRockSampleSizeTypeAddAction.Create(AOwner: TComponent);
begin
  inherited;

end;

function TRockSampleSizeTypeAddAction.Execute: boolean;
begin
  Result := Execute(TIDObject(nil));
end;

function TRockSampleSizeTypeAddAction.Execute(
  ABaseObject: TIDObject): boolean;
begin
  Result := inherited Execute(ABaseObject);
end;

function TRockSampleSizeTypeAddAction.Execute(
  ABaseCollection: TIDObjects): boolean;
begin

end;}

{ TRockSampleSizeTypeAddAction }

constructor TRockSampleSizeTypeAddAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  Caption := 'Добавить типоразмер образца';
end;

function TRockSampleSizeTypeAddAction.Execute: boolean;
begin
  Result := Execute(TIDObject(nil));
end;

function TRockSampleSizeTypeAddAction.Execute(
  ABaseObject: TIDObject): boolean;
begin
  Result := inherited Execute(ABaseObject);
end;

function TRockSampleSizeTypeAddAction.Execute(
  ABaseCollection: TIDObjects): boolean;
begin
  if not Assigned(frmSampleSizeTypeEditor) then frmSampleSizeTypeEditor := TfrmSampleSizeTypeEditor.Create(Self);

  frmSampleSizeTypeEditor.Clear;
  frmSampleSizeTypeEditor.IDObjects := ABaseCollection;

  Result := Execute;
end;

{ TCollectionEditAction }

constructor TCollectionEditAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  Caption := 'Редактировать коллекцию';
end;

function TCollectionEditAction.Execute(ABaseObject: TIDObject): boolean;
begin
  if not Assigned(frmCollectionEditForm) then frmCollectionEditForm := TfrmCollectionEditForm.Create(Self);

  Result := true;
  frmCollectionEditForm.Clear;
  frmCollectionEditForm.EditingObject := ABaseObject;

  if frmCollectionEditForm.ShowModal = mrOK then
  begin
    frmCollectionEditForm.Save;
    // это у нас такая транзакционность - самый простой случай
    try
      ABaseObject := (frmCollectionEditForm.dlg.Frames[0] as TfrmCommonFrame).EditingObject;
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

{ TCollectionAddAction }

constructor TCollectionAddAction.Create(AOwner: TComponent);
begin
  inherited;
  Caption := 'Добавить коллекцию';
end;

function TCollectionAddAction.Execute(ABaseObject: TIDObject): boolean;
begin
  Result := inherited Execute(nil);
end;

{ TCollectionSampleAddAction }

constructor TCollectionSampleAddAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  Caption := 'Добавить образец коллекции';
end;

function TCollectionSampleAddAction.Execute(
  ABaseObject: TIDObject): boolean;
begin
  Result := inherited Execute(nil);
end;

{ TCollectionSampleEditAction }

constructor TCollectionSampleEditAction.Create(AOwner: TComponent);
begin
  inherited;
  CanUndo := false;
  Caption := 'Редактировать образец коллекции';
end;

function TCollectionSampleEditAction.Execute(
  ABaseObject: TIDObject): boolean;
begin
  if not Assigned(frmSampleEditForm) then frmSampleEditForm := TfrmSampleEditForm.Create(Self);

  Result := true;
  frmSampleEditForm.Clear;
  frmSampleEditForm.EditingObject := ABaseObject;

  if frmSampleEditForm.ShowModal = mrOK then
  begin
    frmSampleEditForm.Save;
    // это у нас такая транзакционность - самый простой случай
    try
      ABaseObject := (frmCollectionEditForm.dlg.Frames[0] as TfrmCommonFrame).EditingObject;
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

end.

