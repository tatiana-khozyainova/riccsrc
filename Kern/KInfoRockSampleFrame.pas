unit KInfoRockSampleFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ImgList, StdCtrls, Grids, ExtCtrls, ActnList, ToolWin,
  CoreDescription, Slotting;

type
  TfrmRockSample = class(TFrame)
    GroupBox1: TGroupBox;
    pnl: TPanel;
    grdRockSamples: TStringGrid;
    ckbx: TCheckBox;
    tbr: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    actnLst: TActionList;
    imgList: TImageList;
    actnAdd: TAction;
    actnDelete: TAction;

    procedure writetext(acanvas: tcanvas; const arect: trect; dx, dy: integer; const text: string; format: word);

    procedure AddCheckBoxes;
    procedure CleanPreviusBuffer;
    procedure SetCheckboxAlignment;

    procedure grdRockSamplesSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure actnAddExecute(Sender: TObject);
    procedure actnDeleteExecute(Sender: TObject);
    procedure grdRockSamplesTopLeftChanged(Sender: TObject);
    procedure grdRockSamplesSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: String);
    procedure ckbxClick(Sender: TObject);
  private
    FRowIndex: integer;
    FActiveRowIndex: integer;
    FChangeMade: boolean;
    FActiveLayer: TDescriptedLayer;

    procedure   ClearGrid; overload;
    procedure   ClearGrid (N: integer); overload;
  public
    //
    property    ChangeMade: boolean read FChangeMade write FChangeMade;
    // индекс новой строки
    property    RowIndex: integer read FRowIndex write FRowIndex;
    // индекс активной строки
    property    ActiveRowIndex: integer read FActiveRowIndex write FActiveRowIndex;

    property    ActiveLayer: TDescriptedLayer read FActiveLayer write FActiveLayer;

    procedure   MakeRecord(N: integer);
    procedure   Clear;
    procedure   Reload;
    function    Save: boolean;
    function    CheckInfoRockSamples: boolean;
    function    GetRockSampleText: string;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

implementation

uses facade, BaseObjects, TypeResearch, RockSample, LayerSlotting;

{$R *.dfm}

{ TfrmRockSample }

constructor TfrmRockSample.Create(AOwner: TComponent);
begin
  inherited;

  grdRockSamples.Cells[0, 0] := ' є долб.   ';
  grdRockSamples.Cells[1, 0] := ' от ... (м)   ';
  grdRockSamples.Cells[2, 0] := ' до ... (м)   ';
  grdRockSamples.Cells[3, 0] := ' ¬. к.   ';
  grdRockSamples.Cells[4, 0] := ' є обр.   ';
  grdRockSamples.Cells[5, 0] := ' от нач... (м)   ';

  FRowIndex := 1;
  FActiveRowIndex := -1;

  (TMainFacade.GetInstance as TMainFacade).TypeResearchs.MakeList(grdRockSamples);
  (TMainFacade.GetInstance as TMainFacade).AllLayers.Reload;
end;

destructor TfrmRockSample.Destroy;
begin

  inherited;
end;

procedure TfrmRockSample.Reload;
var j, iRow, k, iCol: integer;
begin
  if grdRockSamples.RowCount > 2 then ClearGrid;
  AddCheckBoxes;

  iRow := 1;
  for j := 0 to FActiveLayer.RockSamples.Count - 1 do
  begin
    // долбление
    with FActiveLayer.Collection.Owner as TSlotting do
    begin
      grdRockSamples.Cells[0, iRow] := '  ' + Name;
      grdRockSamples.Cells[1, iRow] := '  ' + FloatToStr(Top);
      grdRockSamples.Cells[2, iRow] := '  ' + FloatToStr(Bottom);
      grdRockSamples.Cells[3, iRow] := '  ' + FloatToStr(CoreYield);
    end;

    // образец
    grdRockSamples.Cells[4, iRow] := FActiveLayer.RockSamples.Items[j].Name;

    if FActiveLayer.RockSamples.Items[j].FromBegining > 0 then
      grdRockSamples.Cells[5, iRow] := FloatToStr(FActiveLayer.RockSamples.Items[j].FromBegining)
    else grdRockSamples.Cells[5, iRow] := 'н. к.';

    // ассоциируем с объектом образца
    grdRockSamples.Objects[0, iRow] := FActiveLayer.RockSamples.Items[j];

    // типы исследований
    for iCol := 6 to grdRockSamples.ColCount - 1 do
    for k := 0 to FActiveLayer.RockSamples.Items[j].Researchs.Count - 1 do
    if Assigned(FActiveLayer.RockSamples.Items[j].Researchs.GetItemByName(trim(grdRockSamples.Cols[iCol].Text))) then
    begin
      (grdRockSamples.Objects[iCol, iRow] as TCheckBox).Checked := true;
      break;
    end
    else (grdRockSamples.Objects[iCol, iRow] as TCheckBox).Checked := false;

    inc(iRow);
    if (iRow <= FActiveLayer.RockSamples.Count) and (FActiveLayer.RockSamples.Count > 1) then actnAdd.Execute;
  end;

  if FActiveLayer.RockSamples.Count = 0 then MakeRecord(2);

  grdRockSamples.FixedRows := 1;
end;

procedure TfrmRockSample.writetext(acanvas: tcanvas; const arect: trect;
  dx, dy: integer; const text: string; format: word);
var s: array[0..255] of char;
begin
  with acanvas, arect do
  begin
    case format of
      dt_left: exttextout(handle, left + dx, top + dy, eto_opaque or eto_clipped,
                 @arect, strpcopy(s, text), length(text), nil);
      dt_right: exttextout(handle, right - textwidth(text) - 3, top + dy,
                  eto_opaque or eto_clipped, @arect, strpcopy(s, text), length(text), nil);
      dt_center: exttextout(handle, left + (right - left - textwidth(text)) div 2,
                   top + dy, eto_opaque or eto_clipped, @arect,
                   strpcopy(s, text), length(text), nil);
    end;
  end;
end;

procedure TfrmRockSample.AddCheckBoxes;
var i: Integer;
    NewCheckBox: TCheckBox;
begin
  CleanPreviusBuffer; // очищаем неиспользуемые чекбоксы...

  for i := 6 to grdRockSamples.ColCount - 1 do
  begin
    NewCheckBox := TCheckBox.Create(Application);
    NewCheckBox.Width := 0;
    NewCheckBox.Visible := false;
    NewCheckBox.Color := clWindow;
    NewCheckBox.Tag := RowIndex;
    NewCheckBox.OnClick := ckbx.OnClick; // —в€зываем предыдущее событие OnClick
                                              // с существующим TCheckBox
    NewCheckBox.Parent := pnl;

    grdRockSamples.Objects[i, RowIndex] := NewCheckBox;
  end;

  SetCheckboxAlignment; // расположение чекбоксов в €чейках таблицы...
end;

procedure TfrmRockSample.CleanPreviusBuffer;
var NewCheckBox: TCheckBox;
    i: Integer;
begin
  for i := 6 to grdRockSamples.ColCount - 1 do
  begin
    NewCheckBox := grdRockSamples.Objects[i, FRowIndex] as TCheckBox;
    if NewCheckBox <> nil then
    begin
      NewCheckBox.Visible := false;
      grdRockSamples.Objects[i, FRowIndex] := nil;
    end;
  end;
end;

procedure TfrmRockSample.SetCheckboxAlignment;
var NewCheckBox: TCheckBox;
    Rect: TRect;
    i: Integer;
begin
  for i := 6 to grdRockSamples.ColCount - 1 do
  begin
    NewCheckBox := grdRockSamples.Objects[i, RowIndex] as TCheckBox;
    if NewCheckBox <> nil then
    begin
      Rect := grdRockSamples.CellRect(i, RowIndex); // получаем размер €чейки дл€ чекбокса

      NewCheckBox.Left := grdRockSamples.Left + Rect.Left + (grdRockSamples.ColWidths[i] div  2) - 5;
      NewCheckBox.Top := grdRockSamples.Top + Rect.Top + 2;
      NewCheckBox.Width := 12;
      NewCheckBox.Height := Rect.Bottom - Rect.Top;
      NewCheckBox.Visible := True;
    end;
  end;
end;

procedure TfrmRockSample.grdRockSamplesSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  if ((grdRockSamples.ColCount - (TMainFacade.GetInstance as TMainFacade).TypeResearchs.Count) <= ACol) or (ACol <= 3) then
    grdRockSamples.Options := grdRockSamples.Options - [goEditing, goAlwaysShowEditor]
  else grdRockSamples.Options := grdRockSamples.Options + [goEditing, goAlwaysShowEditor];

  FActiveRowIndex := ARow;
end;

procedure TfrmRockSample.actnAddExecute(Sender: TObject);
begin
  FRowIndex := grdRockSamples.RowCount;
  FActiveRowIndex := grdRockSamples.RowCount;
  grdRockSamples.RowCount := grdRockSamples.RowCount + 1;
  AddCheckBoxes;

  MakeRecord(grdRockSamples.RowCount);
end;

procedure TfrmRockSample.actnDeleteExecute(Sender: TObject);
var deleting: boolean;
begin
  deleting := false;

  if Assigned(grdRockSamples.Objects[0, ActiveRowIndex]) then
    MessageBox(0, '”даление образцов запрещено.', 'ѕредупреждение', MB_APPLMODAL + MB_OK + MB_ICONWARNING)
  else deleting := true;

  if deleting then
  begin
    ClearGrid(ActiveRowIndex);
    dec(FActiveRowIndex);
  end;
end;

function TfrmRockSample.Save: boolean;
var i, j: integer;
    t: Double;
    r: TRockSample;
    o: TRockSampleResearch;
begin
  Result := false;

  for j := 1 to grdRockSamples.RowCount - 1 do  // все строки
  begin
    // если окажетс€, что нет такого образца, то создаем новый экземпл€р
    if not Assigned(grdRockSamples.Objects[0, j]) then
      r := TRockSample.Create(FActiveLayer.RockSamples)
    else r := FActiveLayer.RockSamples.ItemsByID[(grdRockSamples.Objects[0, j] as TRockSample).ID] as TRockSample;

    // номер образца
    r.Name := trim(grdRockSamples.Cells[4, j]);

    // ... от начала
    if TryStrToFloat(trim(grdRockSamples.Cells[5, j]), t) then
      r.FromBegining := StrToFloat(trim(grdRockSamples.Cells[5, j]))
    else r.FromBegining := -2;

    // типы исследований
    r.Researchs.Clear;
    for i := 6 to grdRockSamples.ColCount - 1 do  // столбцы пока только с исследовани€ми
    if (grdRockSamples.Objects[i, j] as TCheckBox).Checked then
    begin
      o := TRockSampleResearch.Create(r.Researchs);
      o.Assign((TMainFacade.GetInstance as TMainFacade).TypeResearchs.GetItemByName(trim(grdRockSamples.Cells[i, 0])) as TTypeResearch);
      o.Research := true;
      r.Researchs.Add(o);
    end;

    if r.ID = 0 then FActiveLayer.RockSamples.Add(r);

    Result := true;
  end;
end;

procedure TfrmRockSample.ClearGrid;
var i : integer;
    NewCheckBox: TCheckBox;
begin
  for i := grdRockSamples.RowCount downto 2 do
    ClearGrid(i);

  // почистить первую строку
  for i := 6 to grdRockSamples.ColCount - 1 do
  begin
    NewCheckBox := grdRockSamples.Objects[i, 1] as TCheckBox;
    if Assigned(NewCheckBox) then
      (grdRockSamples.Objects[i, 1] as TCheckBox).Checked := false;
  end;
end;

procedure TfrmRockSample.ClearGrid(N: integer);
var i: Integer;
    NewCheckBox: TCheckBox;
begin
  with grdRockSamples do
  if (N > 0) and (N < RowCount) then
  begin
    for i := N to RowCount - 2 do
      Rows[i].Assign(Rows[i + 1]);
    RowCount := RowCount - 1;

    // удалить чекбоксы
    for i := 6 to grdRockSamples.ColCount - 1 do
    begin
      NewCheckBox := grdRockSamples.Objects[i, RowCount] as TCheckBox;
      if NewCheckBox <> nil then
      begin
        NewCheckBox.Visible := false;
        grdRockSamples.Objects[i, RowCount] := nil;
      end;
    end;
  end;
end;

function TfrmRockSample.GetRockSampleText: string;
var i, j: integer;
begin
  Result := #10 + #9;
  for i := 0 to ActiveLayer.RockSamples.Count - 1 do
  if ActiveLayer.RockSamples.Items[i].Researchs.Count > 0 then
  if ActiveLayer.RockSamples.Items[i].Changing then
  begin
    if ActiveLayer.RockSamples.Items[i].FromBegining > 0 then
      Result := Result + 'ќбр. ' + ActiveLayer.Collection.Owner.Name + '/' + ActiveLayer.RockSamples.Items[i].Name + ' (' +
                FloatToStr(ActiveLayer.RockSamples.Items[i].FromBegining) + ' м н.к.) ' + #8211 + ' '
    else Result := Result + 'ќбр. ' + ActiveLayer.Collection.Owner.Name + '/' + ActiveLayer.RockSamples.Items[i].Name + ' (н.к.) ' + #8211 + ' ';

    for j := 0 to ActiveLayer.RockSamples.Items[i].Researchs.Count - 1 do
    if j < ActiveLayer.RockSamples.Items[i].Researchs.Count - 1 then
      Result := Result + AnsiLowerCase(ActiveLayer.RockSamples.Items[i].Researchs.Items[j].Name) + ', '
    else Result := Result + AnsiLowerCase(ActiveLayer.RockSamples.Items[i].Researchs.Items[j].Name);

    ActiveLayer.RockSamples.Items[i].Changing := false;

    Result := Result + #10 + #9;
  end;
end;

procedure TfrmRockSample.Clear;
begin
  ClearGrid;
  FChangeMade := false;
end;

procedure TfrmRockSample.MakeRecord(N: integer);
begin
  grdRockSamples.Cells[0, N - 1] := '  ' + FActiveLayer.Collection.Owner.Name;
  grdRockSamples.Cells[1, N - 1] := '  ' + FloatToStr((FActiveLayer.Collection.Owner as TSlotting).Top);
  grdRockSamples.Cells[2, N - 1] := '  ' + FloatToStr((FActiveLayer.Collection.Owner as TSlotting).Bottom);
  grdRockSamples.Cells[3, N - 1] := '  ' + FloatToStr((FActiveLayer.Collection.Owner as TSlotting).CoreYield);
  grdRockSamples.Cells[4, N - 1] := '';
  grdRockSamples.Cells[5, N - 1] := '';
end;

procedure TfrmRockSample.grdRockSamplesTopLeftChanged(Sender: TObject);
var R: TRect;
    i, j: integer;
begin
  with grdRockSamples do
  for j := 6 to ColCount - 1 do
  for i := 0 to RowCount - 1 do
  begin
    R := grdRockSamples.CellRect(j, i);

    if grdRockSamples.Objects[j, i] is TControl then
    with TControl(grdRockSamples.Objects[j, i]) do
    begin
      if R.Right = R.Left then {пр€моугольник €чейки невидим}
        Visible := False
      else
      begin
        InflateRect(R, 0, 0);
        OffsetRect (R, grdRockSamples.Left + (grdRockSamples.ColWidths[j] div  2) - 5, grdRockSamples.Top + 2);
        BoundsRect := R;
        Visible := True;
      end;
    end;
  end;
end;

function TfrmRockSample.CheckInfoRockSamples: boolean;
begin
  Result := false;
end;

procedure TfrmRockSample.grdRockSamplesSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
var i: integer;
    ErrorTrue: boolean;
begin
  // проверка ошибок
  FChangeMade := true;

  if Assigned (grdRockSamples.Objects[0, ARow]) then
  begin
    (grdRockSamples.Objects[0, ARow] as TRockSample).Changing := true;

    if grdRockSamples.RowCount <> 1 then
    begin
      ErrorTrue := false;

      case ACol of
      5: begin // выход керна >= значению от начала керна
           if (trim(grdRockSamples.Cells[ACol, ARow]) <> '') and
              (trim(grdRockSamples.Cells[ACol, ARow]) <> 'н. к.') then
           try
             if StrToFloat(grdRockSamples.Cells[ACol, ARow]) > StrToFloat(trim(grdRockSamples.Cells[3, ARow]))then
             begin
               MessageBox(0, '«начение "от начала керна" не может превышать "выход керна".', 'ќшибка', MB_APPLMODAL + MB_ICONERROR + MB_OK);
               ErrorTrue := true;
             end;
            except
              MessageBox(0, '¬ведено значение некорректного формата.', 'ќшибка', MB_APPLMODAL + MB_ICONERROR + MB_OK);
              ErrorTrue := true;
            end;

           if ErrorTrue then
           if Assigned (grdRockSamples.Objects[0, ARow]) then
           if (grdRockSamples.Objects[0, ARow] as TRockSample).FromBegining > 0 then
             grdRockSamples.Cells[ACol, ARow] := FloatToStr((grdRockSamples.Objects[0, ARow] as TRockSample).FromBegining)
           else grdRockSamples.Cells[ACol, ARow] := 'н. к.';
         end;
      4: begin // проверить чтобы є образцов не повтор€лись
           for i := 1 to grdRockSamples.RowCount - 1 do
           if (grdRockSamples.Cells[ACol, ARow] = grdRockSamples.Cells[ACol, i]) and (i <> ARow) then
           begin
             MessageBox(0, 'ќбразец с таким номером уже существует.', 'ќшибка', MB_APPLMODAL + MB_ICONERROR + MB_OK);
             if Assigned (grdRockSamples.Objects[0, ARow]) then
               grdRockSamples.Cells[ACol, ARow] := (grdRockSamples.Objects[0, ARow] as TRockSample).Name
             else grdRockSamples.Cells[ACol, ARow] := '';
           end;
         end;
       end;
    end;
  end;
end;

procedure TfrmRockSample.ckbxClick(Sender: TObject);
begin
  ChangeMade := true;

  if (Sender as TCheckBox).Tag > -1 then
  if Assigned (grdRockSamples.Objects[0, (Sender as TCheckBox).Tag]) then
    (grdRockSamples.Objects[0, (Sender as TCheckBox).Tag] as TRockSample).Changing := true;
end;

end.
