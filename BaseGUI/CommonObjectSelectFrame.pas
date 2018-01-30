unit CommonObjectSelectFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, BaseObjects, CommonObjectSelector;

type
  TFrameClass = class of TFrame;

  TfrmIDObjectSelect = class(TFrame)
    edtObject: TEdit;
    btnObject: TButton;
    lblObjectName: TStaticText;
    procedure btnObjectClick(Sender: TObject);
  private
    { Private declarations }
    FObjectSelector: IObjectSelector;
    FSelectorForm: TForm;
    FSelectiveFrameClass: TFormClass;
    FSelectedObject: TIDObject;
    FLabelCaption: string;
    procedure SetLabelCaption(const Value: string);
    function  GetSelectorForm: TForm;
    procedure SetSelectedObject(const Value: TIDObject);
  public
    { Public declarations }
    procedure Clear;

    property SelectorForm: TForm read GetSelectorForm;
    property SelectiveFormClass: TFormClass read FSelectiveFrameClass write FSelectiveFrameClass;

    property ObjectSelector: IObjectSelector read FObjectSelector write FObjectSelector;
    property SelectedObject: TIDObject read FSelectedObject write SetSelectedObject;
    property LabelCaption: string read FLabelCaption write SetLabelCaption;
  end;

implementation

{$R *.dfm}

procedure TfrmIDObjectSelect.btnObjectClick(Sender: TObject);
begin
  if not Assigned(FSelectorForm) then
    FSelectorForm := SelectiveFormClass.Create(Self);

  FSelectorForm.Position := poScreenCenter;
  if Assigned(SelectedObject) then
    ObjectSelector.SelectedObject := SelectedObject;

  if FSelectorForm.ShowModal = mrOK then
    SelectedObject := ObjectSelector.SelectedObject;
end;

procedure TfrmIDObjectSelect.Clear;
begin
  edtObject.Clear;
end;

function TfrmIDObjectSelect.GetSelectorForm: TForm;
begin
  if not Assigned(FSelectorForm) then
    FSelectorForm := SelectiveFormClass.Create(Application.MainForm);

  Result := FSelectorForm;
end;

procedure TfrmIDObjectSelect.SetLabelCaption(const Value: string);
begin
  FLabelCaption := Value;
  lblObjectName.Caption := FLabelCaption;
end;

procedure TfrmIDObjectSelect.SetSelectedObject(const Value: TIDObject);
begin
  FSelectedObject := Value;
  if Assigned(FSelectedObject) then edtObject.Text := FSelectedObject.List(loBrief);
end;

end.
