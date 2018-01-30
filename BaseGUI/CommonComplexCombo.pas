unit CommonComplexCombo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CommonComplexList, ComCtrls, BaseDicts
  {$IFDEF VER150}
  , Variants
  {$ENDIF}
  ;


type
  TfrmComplexCombo = class(TFrame)
    cmbxName: TComboBox;
    btnShowAdditional: TButton;
    lblName: TLabel;
    procedure btnShowAdditionalClick(Sender: TObject);
    procedure cmbxNameChange(Sender: TObject);
    procedure btnRemoveSelectionClick(Sender: TObject);
    procedure cmbxNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    FSelectedElementID: integer;
    FCaption: string;
    FColumns: TColumnNumbers;
    FFullLoad: boolean;
    frm: TForm;
    FSelectedElementName: string;
    FShowButton: boolean;
    FShowID: boolean;
    FDictName: string;
    FDictObject: TDict;
    FFiltered: boolean;
    FStyle: TComboBoxStyle;
    FDelimiter: String;
    FIsEditable: boolean;
    procedure CreateForm;
    procedure SetCaption(const Value: string);
    procedure SetShowButton(const Value: boolean);
    procedure SetDictName(const Value: string);
    procedure SetStyle(const Value: TComboBoxStyle);
    function  GetText: string;
    procedure SetText(const Value: string);
  protected
    CmplxList: TfrmComplexList;
    procedure InternalShowAdditional; virtual;
  public
    { Public declarations }
    property DictName: string read FDictName write SetDictName;
    // �������, ������� �������� � ������
    property Columns: TColumnNumbers read FColumns write FColumns;
    // ������������ �����������
    property Caption: string read FCaption write SetCaption;
    // ������������� ���������� ��������
    property SelectedElementID: integer read FSelectedElementID;
    property SelectedElementName: string read FSelectedElementName;
    // ������� � ���������� ����� ���
    property FullLoad: boolean read FFullLoad write FFullLoad;
    // ���������� ������ ������ ���������
    property ShowButton: boolean read FShowButton write SetShowButton;
    // ���������� ID
    property ShowID: boolean read FShowID write FShowID;
    // ��������� �������, � ���� ����� ���� - �� ��������
    function AddItem(const AID: integer; const AName: string): integer; virtual;
    // ���������� �� �������� �����-���� �������
    // � ������ �������� ������ ��������������� ������
    function  Filter(const AFilterColumnIndex: integer; AFilterValues: variant): integer;
    property  Filtered: boolean read FFiltered;
    // �������� ������ - �������� ��� ������ ���������
    procedure CancelFilter;
    procedure Clear; virtual;
    // ����������� ������
    procedure Reload;
    // ������� ������� �� � ������
    function  FindSimilarName(const AName: string): integer;
    // ��������� ����� ���� (������� ������ ��� �� ������������� �������)
    { TODO :
��� ������������� ������ ���� ��� �������� ������ �����,
�������������� ��������� ��������� - �����-������ �����.
��� ��-�� ����, ��� ����� ��������� � ���� � ����������, � � ��������� � ���������� -
��������������� ���. ������, �������, �� ��-���� ���-�� ������ ����������.
�� � ������� ��������. ����� ��� ���� ������� �����-�� ��������� �������, �� ����� ��� � ��
������ �������, � ��� ����� ���-�� ���������� ��� ��� ������ ��������� �������.
� ����� ���� ��������. }
    property  Style: TComboBoxStyle read FStyle write SetStyle;
    // ����������� (��������� ������ ���� Style = csSimple � ����� ������� ��������� ���������)
    property  Delimiter: string read FDelimiter write FDelimiter;
    // ���� ���������� ����� - ��� ������� ������ ����� SelecteElement
    property  Text: string read GetText write SetText;

    property  DictObject: TDict read FDictObject;
    property  IsEditable: boolean read FIsEditable write FIsEditable;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

implementation

uses Facade;

{$R *.DFM}

{ TfrmComplexCombo }

constructor TfrmComplexCombo.Create(AOwner: TComponent);
begin
  inherited;
  frm := nil;
  FShowButton := true;
  FShowID := false;
  cmbxName.Sorted := true;
  Style := csDropDownList;
  FDelimiter := ';';
  IsEditable := true;
//  FSelectedElementID := -1;
//  FSelectedElementName := '';
end;

procedure TfrmComplexCombo.CreateForm;
begin
  frm := TForm.Create(Self);
  frm.Parent := nil;
  frm.Position := poOwnerFormCenter;
  frm.Height := 350;
  frm.Width  := 520;


  CmplxList := TfrmComplexList.Create(frm);
  CmplxList.Parent := frm;
  CmplxList.Align := alClient;

  CmplxList.Columns := Columns;
  CmplxList.DictName := DictName;

  CmplxList.AllowEditing := IsEditable;

  CmplxList.btnOK.ModalResult := mrOK;
  CmplxList.SelectedElementID := -1;
end;

procedure TfrmComplexCombo.SetCaption(const Value: string);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    lblName.Caption := FCaption;
  end;
end;


procedure TfrmComplexCombo.btnShowAdditionalClick(Sender: TObject);
begin
  if not Assigned(frm) then CreateForm;
  CmplxList.SelectedElementID := SelectedElementID;
  InternalShowAdditional;
  // ��� ������� �� ����� - ��������� � ������
  if frm.ShowModal = mrOk then
  begin
    AddItem(cmplxList.SelectedElementID, cmplxList.SelectedElementName);
    cmbxName.OnChange(Sender);
  end
end;

function TfrmComplexCombo.AddItem(const AID: integer;
  const AName: string): integer;
begin
  if Style <> csSimple then
  begin
    Result := cmbxName.Items.IndexOfObject(TObject(AID));
    if  Result = -1 then
      Result := cmbxName.Items.AddObject(AName, TObject(AID))
    else cmbxName.Items[Result] := AName;

    cmbxName.ItemIndex := Result;
    //if Assigned(cmbxName.OnChange) then cmbxName.OnChange(cmbxName);
    FSelectedElementID := Integer(cmbxName.Items.Objects[cmbxName.ItemIndex]);
    FSelectedElementName := cmbxName.Items[cmbxName.ItemIndex];
  end
  else
  begin
    Result := 0;
    cmbxName.Text := cmbxName.Text + AName + Delimiter + ' ';
    FSelectedElementID := AID;
    FSelectedElementName := AName;
  end;
end;

procedure TfrmComplexCombo.cmbxNameChange(Sender: TObject);
begin
  if cmbxName.ItemIndex > -1 then
  begin
    FSelectedElementID := Integer(cmbxName.Items.Objects[cmbxName.ItemIndex]);
    FSelectedElementName := cmbxName.Items[cmbxName.ItemIndex];
  end;
end;

procedure TfrmComplexCombo.Clear;
begin
  cmbxName.ItemIndex := -1;
end;


procedure TfrmComplexCombo.SetShowButton(const Value: boolean);
begin
  if FShowButton <> Value then
  begin
    FShowButton := Value;
    btnShowAdditional.Visible := FShowButton;
  end;
end;

procedure TfrmComplexCombo.SetDictName(const Value: string);
begin
  FDictName := Value;
  FDictObject := TMainFacade.GetInstance.AllDicts.DictByName[FDictName];
  cmbxName.Items.Clear;
  if FFullLoad then
  begin
    if not varIsEmpty(FDictObject.Dict) then
      TMainFacade.GetInstance.AllDicts.MakeList(cmbxName.Items, FDictObject.Dict);
  end;
end;

function TfrmComplexCombo.Filter(const AFilterColumnIndex: integer;
  AFilterValues: variant): integer;
begin
  cmbxName.Clear;
  TMainFacade.GetInstance.AllDicts.MakeList(cmbxName.Items, FDictObject.Dict, AFilterValues, AFilterColumnIndex);
  Result := cmbxName.Items.Count;
  FFiltered := true;
end;

procedure TfrmComplexCombo.CancelFilter;
begin
  DictName := DictName;
  FFiltered := false;
end;

procedure TfrmComplexCombo.Reload;
var sDictName: string;
begin
  sDictName := FDictName;
  FDictName := '';
  DictName  := sDictName;
end;

procedure TfrmComplexCombo.btnRemoveSelectionClick(Sender: TObject);
begin
  cmbxName.ItemIndex := -1;
end;

procedure TfrmComplexCombo.cmbxNameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 27  then
  begin
    cmbxName.ItemIndex := -1;
    cmbxName.Text := '';
    cmbxName.OnChange(cmbxName);
  end
end;

function TfrmComplexCombo.FindSimilarName(const AName: string): integer;
var i: integer;
begin
  cmbxName.ItemIndex := -1;
  FSelectedElementID := 0;
  FSelectedElementName := '';

  Result := -1;
  for i := 0 to cmbxName.Items.Count - 1 do
  if pos(AName, cmbxName.Items[i]) = 1 then
  begin
    FSelectedElementID := Integer(cmbxName.Items.Objects[i]);
    FSelectedElementName := cmbxName.Items[i];
    cmbxName.ItemIndex := i;
    Result := i;
    break;
  end;
end;

procedure TfrmComplexCombo.SetStyle(const Value: TComboBoxStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    cmbxName.Style := FStyle;
    // ������ ����� �� ����������� ������.
    // ����� ����� ��������
    FullLoad := false;
    cmbxName.Clear;
  end;
end;

destructor TfrmComplexCombo.Destroy;
begin
  inherited;
end;

function TfrmComplexCombo.GetText: string;
begin
  Result := cmbxName.Text;
end;

procedure TfrmComplexCombo.SetText(const Value: string);
begin
  cmbxName.Text := Value;
end;

procedure TfrmComplexCombo.InternalShowAdditional;
begin
  CmplxList.IDObjects  := nil;
end;

end.
