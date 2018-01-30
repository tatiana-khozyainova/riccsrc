unit CRGeneralizedSectionEditFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CommonFrame, ComCtrls, GeneralizedSection, StdCtrls,
  CommonObjectSelectFrame, BaseObjects;

type
  TfrmGenSectionEdit = class(TfrmCommonFrame)
    gbxGenSection: TGroupBox;
    lblGenSectionName: TLabel;
    edtGenSectionName: TEdit;
    frmBaseStratigraphyName: TfrmIDObjectSelect;
    frmTopStratigraphyName: TfrmIDObjectSelect;
  private
    { Private declarations }
    function GetGeneralizedSection: TGeneralizedSection;
  protected
    procedure FillControls(ABaseObject: TIDObject); override;
    procedure ClearControls; override;
    procedure FillParentControls; override;
    procedure RegisterInspector; override;
    function  InternalCheck: Boolean; override;
    procedure CopyEditingValues(Dest: TIDObject); override;

  public
    { Public declarations }

    property GeneralizedSection: TGeneralizedSection read GetGeneralizedSection;
    constructor Create(AOwner: TComponent); override;
    procedure   Save(AObject: TIDObject = nil);  override;
    destructor Destroy; override;
  end;

var
  frmGenSectionEdit: TfrmGenSectionEdit;

implementation

uses StratonSelectForm, Facade, BaseGUI, Straton;

{$R *.dfm}

{ TfrmGenSectionEdit }

procedure TfrmGenSectionEdit.ClearControls;
begin
  inherited;
  edtGenSectionName.Clear;
  frmBaseStratigraphyName.Clear;
  frmTopStratigraphyName.Clear;
end;

procedure TfrmGenSectionEdit.CopyEditingValues(Dest: TIDObject);
begin
  inherited;
  with Dest as TGeneralizedSection do
  begin
    Name := GeneralizedSection.Name;
    BaseStraton := GeneralizedSection.BaseStraton;
    TopStraton := GeneralizedSection.TopStraton;
  end;

end;

constructor TfrmGenSectionEdit.Create(AOwner: TComponent);
begin
  inherited;

  EditingClass := TGeneralizedSection;
  ParentClass := nil;

  frmBaseStratigraphyName.LabelCaption := 'Возраст от (подошва)';
  frmBaseStratigraphyName.SelectiveFormClass := TfrmStratonSelect;
  frmBaseStratigraphyName.ObjectSelector := (frmBaseStratigraphyName.SelectorForm as TfrmStratonSelect);
  frmBaseStratigraphyName.Update;

  frmTopStratigraphyName.LabelCaption := 'Возраст до (кровля)';
  frmTopStratigraphyName.SelectiveFormClass := TfrmStratonSelect;
  frmTopStratigraphyName.ObjectSelector := (frmTopStratigraphyName.SelectorForm as TfrmStratonSelect);
  frmTopStratigraphyName.Update;
end;

destructor TfrmGenSectionEdit.Destroy;
begin

  inherited;
end;

procedure TfrmGenSectionEdit.FillControls(ABaseObject: TIDObject);
var gs: TGeneralizedSection;
begin
  inherited;

  gs := ShadeEditingObject as TGeneralizedSection;
  with gs do
  begin
    edtGenSectionName.Text := gs.Name;
    frmTopStratigraphyName.SelectedObject := gs.TopStraton;
    frmBaseStratigraphyName.SelectedObject := gs.BaseStraton;
  end;

end;

procedure TfrmGenSectionEdit.FillParentControls;
begin
  inherited;

end;

function TfrmGenSectionEdit.GetGeneralizedSection: TGeneralizedSection;
begin
  Result := EditingObject as TGeneralizedSection;
end;

function TfrmGenSectionEdit.InternalCheck: Boolean;
begin
  Result := true;
end;

procedure TfrmGenSectionEdit.RegisterInspector;
begin
  inherited;
  Inspector.Add(edtGenSectionName, nil, ptString, 'наименование св. разреза', false);
end;

procedure TfrmGenSectionEdit.Save(AObject: TIDObject);
begin
  inherited;
  if not Assigned(EditingObject) then
    FEditingObject := TMainFacade.GetInstance.GeneralizedSections.Add;

  GeneralizedSection.Name := edtGenSectionName.Text;
  GeneralizedSection.BaseStraton := frmBaseStratigraphyName.SelectedObject as TSimpleStraton;
  GeneralizedSection.TopStraton := frmTopStratigraphyName.SelectedObject as TSimpleStraton;


end;

end.
