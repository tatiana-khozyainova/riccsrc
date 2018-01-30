unit CRWellQuickInfoViewFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, BaseObjects, CoreCollection;

type
  TfrmWellSlottingInfoQuickView = class(TFrame, IVisitor)
    lwProperties: TListView;
    procedure lwPropertiesAdvancedCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
      var DefaultDraw: Boolean);
    procedure lwPropertiesDblClick(Sender: TObject);
  private
    { Private declarations }
    FFakeObject: TObject;
    FActiveObject: TIDObject;
    procedure AddItem(AName, AValue: string; AData: TObject);
  protected
    function  GetActiveObject: TIDObject;
    procedure SetActiveObject(const Value: TIDObject);
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  public
    { Public declarations }
    procedure VisitWell(AWell: TIDObject);
    procedure VisitGenSection(AGenSection: TIDObject);
    procedure VisitTestInterval(ATestInterval: TIDObject);
    procedure VisitLicenseZone(ALicenseZone: TIDObject);
    procedure VisitSlotting(ASlotting: TIDObject);
    procedure VisitGenSectionSlotting(ASlotting: TIDObject);

    procedure VisitCollectionWell(AWell: TIDObject);
    procedure VisitCollectionSample(ASample: TIDObject);
    procedure VisitDenudation(ADenudation: TIDObject);
    procedure VisitWellCandidate(AWellCandidate: TIDObject);
    procedure Clear;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;


implementation

uses Well, Slotting, BaseConsts, GeneralizedSection, StrViewForm;

{$R *.dfm}

type
  TFakeObject = class(TObject)

  end;

function TfrmWellSlottingInfoQuickView.GetActiveObject: TIDObject;
begin
  Result := FActiveObject;
end;

procedure TfrmWellSlottingInfoQuickView.lwPropertiesAdvancedCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  Stage: TCustomDrawStage; var DefaultDraw: Boolean);
var r: TRect;
begin
  try
    r := Item.DisplayRect(drBounds);
    if Item.Index = lwProperties.Items.Count - 1 then
    begin
      lwProperties.Canvas.Pen.Color := $00ACB9AF;
      lwProperties.Canvas.MoveTo(r.Left, r.Bottom);
      lwProperties.Canvas.LineTo(r.Right, r.Bottom);
      lwProperties.Canvas.Brush.Color := $00FFFFFF;//$00F7F4E1;//$00F2EDDF;//$00DCF5D6;//$00FBFAF0;//$00DAFCDB;//$00EFFAEB;
      lwProperties.Canvas.FillRect(r);
      lwProperties.Canvas.Font.Style := [];
      lwProperties.Canvas.TextOut(r.Left + 2, r.Top, Item.Caption);
    end;



    if not Assigned(Item.Data) then
    begin
      DefaultDraw := false;

      lwProperties.Canvas.Brush.Color := $00EFEFEF;//$00F7F4E1;//$00F2EDDF;//$00DCF5D6;//$00FBFAF0;//$00DAFCDB;//$00EFFAEB;
      lwProperties.Canvas.FillRect(r);

      lwProperties.Canvas.Font.Color := $00ACB9AF;//clGray;
      lwProperties.Canvas.Font.Style := [fsBold];

      if    (Item.Index < lwProperties.Items.Count - 1)
        and (TIDObject(lwProperties.Items[Item.Index + 1].Data) = IVisitor(Self).ActiveObject) then
        lwProperties.Canvas.Font.Color := lwProperties.Canvas.Font.Color + $00330000;

      lwProperties.Canvas.TextOut(r.Left + 2, r.Top, Item.Caption);
    end
    else
    begin
      if (TObject(Item.Data) is TFakeObject) then
      begin
        DefaultDraw := false;
        lwProperties.Canvas.Brush.Color := $00E4EAD7;//$00FBFAF0;//$00DAFCDB;//$00EFFAEB;
        lwProperties.Canvas.FillRect(r);
        lwProperties.Canvas.Font.Color := $00ACB9AF;//clGray;
        lwProperties.Canvas.Font.Style := [fsBold];

        if  (Item.Index < lwProperties.Items.Count - 2)
        and (TIDObject(lwProperties.Items[Item.Index + 2].Data) = IVisitor(Self).ActiveObject) then
          lwProperties.Canvas.Font.Color := lwProperties.Canvas.Font.Color + $0000AA00;

        lwProperties.Canvas.TextOut(r.Left + r.Right - lwProperties.Canvas.TextWidth(Item.Caption), r.Top, Item.Caption);
      end
    end;
  except
  
  end;
end;

function TfrmWellSlottingInfoQuickView._AddRef: Integer;
begin
  Result := -1;
end;

function TfrmWellSlottingInfoQuickView._Release: Integer;
begin
  Result := -1;
end;

procedure TfrmWellSlottingInfoQuickView.SetActiveObject(
  const Value: TIDObject);
begin
  FActiveObject := Value;
end;

procedure TfrmWellSlottingInfoQuickView.VisitWell(AWell: TIDObject);
var w: TWell;
begin
  lwProperties.Items.BeginUpdate;
  lwProperties.Items.Clear;

  try                
    w := AWell as TWell;

    AddItem('�������� ', '', FFakeObject);

    AddItem('UIN', IntToStr(AWell.ID), AWell);
    AddItem('������������ ��������', w.NumberWell + ' - ' + (AWell as TWell).Area.Name, AWell);

    AddItem('������� ������������', w.Name, AWell);
    if w.TrueDepth > 0 then
      AddItem('�����', Format('%.2f', [w.TrueDepth]), AWell)
    else
      AddItem('�����', '<�� ������>', AWell);

    if w.Altitude > 0 then
      AddItem('���������', Format('%.2f', [w.Altitude]), AWell)
    else
      AddItem('���������', '<�� ������>', AWell);


    AddItem('���������', w.Category.List, AWell);

    if Assigned(w.State) then
      AddItem('�������+��', w.State.List, AWell);
      
    if Assigned(w.WellPosition) and Assigned(w.WellPosition.NewNGR) then
      AddItem('���', w.WellPosition.NewNGR.List, AWell);

    if w.DtDrillingStart <> 0 then
      AddItem('���� ������ �������',  DateToStr(w.DtDrillingStart), AWell)
    else
      AddItem('���� ������ �������',  '<�� �������>', AWell);

    if w.DtDrillingFinish <> 0 then
      AddItem('���� ��������� �������',  DateToStr(w.DtDrillingFinish), AWell)
    else
      AddItem('���� ��������� �������',  '<�� �������>', AWell);


    AddItem('��������� �����', Format('%.2f', [w.SlottingPlacement.CoreYieldWithGenSection]), AWell);
    AddItem('����� �����', Format('%.2f', [w.SlottingPlacement.CoreFinalYieldWithGenSection]), AWell);
    AddItem('������� ���������', w.SlottingPlacement.TransferHistory, AWell);

    IVisitor(Self).ActiveObject := AWell;
  except

  end;

  lwProperties.Items.EndUpdate;
end;

procedure TfrmWellSlottingInfoQuickView.VisitLicenseZone(
  ALicenseZone: TIDObject);
begin

end;

procedure TfrmWellSlottingInfoQuickView.VisitTestInterval(
  ATestInterval: TIDObject);
begin

end;

procedure TfrmWellSlottingInfoQuickView.Clear;
begin
  lwProperties.Items.Clear;
end;

constructor TfrmWellSlottingInfoQuickView.Create(AOwner: TComponent);
begin
  inherited;
  FFakeObject := TFakeObject.Create;
end;

destructor TfrmWellSlottingInfoQuickView.Destroy;
begin
  FFakeObject.Free;
  inherited;
end;

procedure TfrmWellSlottingInfoQuickView.AddItem(AName, AValue: string;
  AData: TObject);
var li: TListItem;
begin
  li := lwProperties.Items.Add;
  li.Caption := AName;
  if not (AData is TFakeObject) then
  begin
    li := lwProperties.Items.Add;
    li.Caption := Trim(AValue);
    li.Data := AData;
  end
  else li.Data := AData;
end;

procedure TfrmWellSlottingInfoQuickView.VisitSlotting(
  ASlotting: TIDObject);
var s: TSimpleSlotting;
begin
  lwProperties.Items.BeginUpdate;
  lwProperties.Items.Clear;

  try
    s := ASlotting as TSimpleSlotting;
    if s.Owner is TSimpleWell then
      VisitWell(s.Owner)
    else if s.Owner is TGeneralizedSection then
    begin
      VisitGenSection(s.Owner);
      VisitWell((s as TGeneralizedSectionSlotting).Well);
    end;

    AddItem('�������� ������ ����� ', '', FFakeObject);

    AddItem('UIN', IntToStr(ASlotting.ID), ASlotting);
    AddItem('�������',
            Format('%.2f', [s.Top]) + ' - ' + Format('%.2f', [s.Bottom]),
            ASlotting);
    AddItem('��������', Format('%.2f', [s.Digging]), ASlotting);
    AddItem('����� �����', Format('%.2f', [s.CoreYield]), ASlotting);
    AddItem('����������� ����� �����', Format('%.2f', [s.CoreFinalYield]), ASlotting);
    AddItem('�������', Format('%.2f', [s.Diameter]), ASlotting);
    AddItem('���� ������', DateToStr(s.CoreTakeDate), ASlotting);
    AddItem('������������ ���������', s.CoreMechanicalStates.List(loBrief), ASlotting);
    (* if (s is TSlotting) then
    begin
      ss := s as TSlotting;
      w := s.Owner as TWell;
      if Assigned(w.SlottingPlacement) and Assigned(w.SlottingPlacement.StatePartPlacement) then
      if (w.SlottingPlacement.StatePartPlacement.ID = CORE_MAIN_GARAGE_ID) then
         AddItem('��������������', ' ' + ss.Boxes.Racks.List, ASlotting);
    end; *)

    IVisitor(Self).ActiveObject := ASlotting;
  except

  end;

  lwProperties.Items.EndUpdate;
end;

procedure TfrmWellSlottingInfoQuickView.VisitCollectionWell(
  AWell: TIDObject);
var w: TCollectionWell;
begin
  lwProperties.Items.BeginUpdate;
  lwProperties.Items.Clear;

  try
    w := AWell as TCollectionWell;
    AddItem('�������� ', '', FFakeObject);

    AddItem('UIN', IntToStr(AWell.ID), AWell);
    AddItem('������������ ��������', w.NumberWell + ' - ' + w.Area.List(loBrief), AWell);

    AddItem('�����', Format('%.2f', [w.TrueDepth]), AWell);
    AddItem('���������', Format('%.2f', [w.Altitude]), AWell);

    AddItem('���������', w.Category.List, AWell);

    if Assigned(w.State) then
      AddItem('���������', w.State.List, AWell);

    AddItem('���� ������ �������',  DateToStr(w.DtDrillingStart), AWell);
    AddItem('���� ��������� �������',  DateToStr(w.DtDrillingFinish), AWell);
    AddItem('���������� ��������', IntToStr(w.CollectionSamples.Count), AWell);

    IVisitor(Self).ActiveObject := AWell;
  except

  end;
  lwProperties.Items.EndUpdate;
end;

procedure TfrmWellSlottingInfoQuickView.VisitCollectionSample(
  ASample: TIDObject);
var s: TCollectionSample;
begin
  lwProperties.Items.BeginUpdate;
  lwProperties.Items.Clear;

  try
    s := ASample as TCollectionSample;
    AddItem('������� ', '', FFakeObject);

    AddItem('UIN', IntToStr(s.ID), s);


    if Trim(s.AdditionalNumber) = '' then
      AddItem('�����', s.SlottingNumber + ' / ' + s.SampleNumber, s)
    else
      AddItem('�����', s.SlottingNumber + ' / ' + s.SampleNumber + '(' + Trim(s.AdditionalNumber) + ')', s);

    AddItem('���������� ������� ������, �', Format('%.2f', [s.RealDepth]), s);
    AddItem('�������� ������, �', Format('%.2f', [s.Top]) + ' - '  + Format('%.2f', [s.Bottom]), s);
    if s.DepthFromTop > 0 then
      AddItem('������� ������ �� ����� �����, �', Format('%.2f', [s.DepthFromTop]), s)
    else if s.DepthFromBottom > 0 then
      AddItem('������� ������ �� ���� �����, �', Format('%.2f', [s.DepthFromBottom]), s);

    if s.ListStrat <> '' then
      AddItem('����������������� ��������', s.ListStrat, s)
    else
      AddItem('����������������� ��������', '��� ������', s);

    AddItem('���. �', s.LabNumber, s);

    AddItem('�������� ', '', FFakeObject);
    if s.IsDescripted then
      AddItem('������� �����������', '����', s)
    else
      AddItem('������� �����������', '���', s);

    if s.IsElectroDescription then
      AddItem('������� ����������� � ��. ����', '����', s)
    else
      AddItem('������� ����������� � ��. ����', '���', s);


    AddItem('����� �������� ', '', FFakeObject);      
    AddItem('�������', IntToStr(s.RoomNum), s);
    AddItem('�������', s.BoxNumber, s);


    IVisitor(Self).ActiveObject := s;
  except

  end;
  lwProperties.Items.EndUpdate;
end;

procedure TfrmWellSlottingInfoQuickView.VisitDenudation(
  ADenudation: TIDObject);
var d: TDenudation;
begin
  lwProperties.Items.BeginUpdate;
  lwProperties.Items.Clear;

  try
    d := ADenudation as TDenudation;
    AddItem('��������� ', '', FFakeObject);

    AddItem('UIN', IntToStr(d.ID), d);
    AddItem('������������ ���������', d.Name, d);
    AddItem('����� ���������', d.Number, d);


    AddItem('���������� ��������', IntToStr(d.DenudationSamples.Count), d);

    IVisitor(Self).ActiveObject := d;
  except

  end;
  lwProperties.Items.EndUpdate;
end;

procedure TfrmWellSlottingInfoQuickView.VisitWellCandidate(
  AWellCandidate: TIDObject);
var w: TWellCandidate;
begin
  lwProperties.Items.BeginUpdate;
  lwProperties.Items.Clear;

  try
    w := AWellCandidate as TWellCandidate;
    AddItem('��������-��������', '', FFakeObject);

    AddItem('UIN', IntToStr(w.ID), w);
    AddItem('������������ �������', w.AreaName, w);
    AddItem('����� ��������', w.WellNum, w);
    AddItem('�������', w.Reason, w);
    AddItem('���� ���������', DateToStr(w.PlacingDate), w);
    AddItem('���������� ��������', IntToStr(w.WellCandidateSamples.Count), w);

    IVisitor(Self).ActiveObject := w;
  except

  end;
  lwProperties.Items.EndUpdate;
end;

procedure TfrmWellSlottingInfoQuickView.VisitGenSection(
  AGenSection: TIDObject);
var s: TGeneralizedSection;
begin
  lwProperties.Items.BeginUpdate;
  lwProperties.Items.Clear;

  try
    s := AGenSection as TGeneralizedSection;

    AddItem('������� ������ ', '', FFakeObject);

    AddItem('ID', IntToStr(s.ID), AGenSection);
    AddItem('������������', s.Name, AGenSection);
    AddItem('������������', s.Stratigraphy, AGenSection);
    AddItem('������� ���������', s.SlottingPlacement.TransferHistory, AGenSection);


    IVisitor(Self).ActiveObject := s;
  except

  end;

  lwProperties.Items.EndUpdate;
end;

procedure TfrmWellSlottingInfoQuickView.VisitGenSectionSlotting(
  ASlotting: TIDObject);
var s: TGeneralizedSectionSlotting;
begin
  lwProperties.Items.BeginUpdate;
  lwProperties.Items.Clear;

  try
    s := ASlotting as TGeneralizedSectionSlotting;
    if s.Owner is TGeneralizedSection then
    begin
      VisitGenSection(s.Owner);
    end;

    AddItem('�������� ������ ����� ', '', FFakeObject);

    AddItem('UIN', IntToStr(ASlotting.ID), ASlotting);
    AddItem('��������', s.Well.List(loBrief), ASlotting);
    AddItem('�������',
            Format('%.2f', [s.Top]) + ' - ' + Format('%.2f', [s.Bottom]),
            ASlotting);
    AddItem('��������', Format('%.2f', [s.Digging]), ASlotting);
    AddItem('����� �����', Format('%.2f', [s.CoreYield]), ASlotting);
    AddItem('����������� ����� �����', Format('%.2f', [s.CoreFinalYield]), ASlotting);
    AddItem('�������', Format('%.2f', [s.Diameter]), ASlotting);
    AddItem('���� ������', DateToStr(s.CoreTakeDate), ASlotting);
    IVisitor(Self).ActiveObject := ASlotting;
  except

  end;

  lwProperties.Items.EndUpdate;
end;

procedure TfrmWellSlottingInfoQuickView.lwPropertiesDblClick(
  Sender: TObject);
begin
  if Assigned(lwProperties.Selected) and (Assigned(lwProperties.Selected.Data)) and (Trim(lwProperties.Selected.Caption) <> '') then
  begin
    if not Assigned(frmStringView) then frmStringView := TfrmStringView.Create(Self);

    frmStringView.Text := lwProperties.Selected.Caption;
    frmStringView.Show;
  end;
end;

end.
