unit KReport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, StdCtrls, Buttons, ActnList, ExtCtrls, BaseObjects,
  ComCtrls, ComObj, OleServer, Word2000, CoreDescription, WordXP;

type
  TfrmReport = class(TForm)
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    actnLst: TActionList;
    actnSaveWord: TAction;
    BitBtn1: TBitBtn;
    actnPrint: TAction;
    imgLst: TImageList;
    edtTextReport: TRichEdit;
    dlgSave: TSaveDialog;
    wrdFrm: TWordParagraphFormat;
    wrdApp: TWordApplication;
    procedure actnSaveWordExecute(Sender: TObject);
  private
    FActiveObject: TIDObject;
    FActiveObjects: TIDObjects;
    FAreaName: string;
    FActiveSlotting: TIDObject;
  public
    // название площади
    property    AreaName: string read FAreaName write FAreaName;
    // скважина
    property    ActiveObject: TIDObject read FActiveObject write FActiveObject;
    // коллекция скважин
    property    ActiveObjects: TIDObjects read FActiveObjects write FActiveObjects;

    // долбление
    property    ActiveSlotting: TIDObject read FActiveSlotting write FActiveSlotting;

    procedure   Reload;

    procedure   AddWellToReport;
    procedure   AddSlottingToReport;

    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  end;

var
  frmReport: TfrmReport;

implementation

uses Well;

{$R *.dfm}

{ TfrmReport }

constructor TfrmReport.Create(AOwner: TComponent);
begin
  inherited;
  FActiveObjects := TIDObjects.Create;
end;

destructor TfrmReport.Destroy;
begin
  FActiveObjects.Free;
  inherited;
end;

procedure TfrmReport.Reload;
var i: integer;
begin
  if Assigned(ActiveObject) then
    AddWellToReport
  else
  begin
    // уточнить атрибут с названием пощади
    edtTextReport.Lines.Add('Описание керна по площади ' + AreaName + #10#13);

    for i := 0 to ActiveObjects.Count - 1 do
    begin
      ActiveObject := ActiveObjects.Items[i];
      AddWellToReport;
      edtTextReport.Lines.Add(#10#13);
    end;
  end;
end;

procedure TfrmReport.AddWellToReport;
var i, j : integer;
    flDate: boolean;

    FAuthors: string;
    Authors: TAuthors;

    FLastDate: TDateTime;

    Well: TDescriptedWell;
begin
  Well := (TDescriptedWell(ActiveObject));

  Caption := 'Отчет по скважине №' + Well.NumberWell + '-' + Well.Area.Name;

  edtTextReport.Lines.Add('Описание керна по скв. ' + Well.NumberWell + '-' + Well.Area.Name + #10#13);

  Authors := TAuthors.Create;

  for i := 0 to Well.Slottings.Count - 1 do
  if Well.Slottings.Items[i].LayerSlottings.Count > 0 then
  begin
    // заголовок
    edtTextReport.Lines.Add(Well.Slottings.Items[i].MakeHeader);

    // формируем текст
    for j := 0 to Well.Slottings.Items[i].LayerSlottings.Count - 1 do
    if Assigned((Well.Slottings.Items[i].LayerSlottings.Items[j] as TDescriptedLayer).Description) then
    begin
      if (Well.Slottings.Items[i].LayerSlottings.Items[j] as TDescriptedLayer).Description.ID = 0 then
      begin
        (Well.Slottings.Items[i].LayerSlottings.Items[j] as TDescriptedLayer).ClearDescription;
        (Well.Slottings.Items[i].LayerSlottings.Items[j] as TDescriptedLayer).Description.Reload;
      end;

      if (Well.Slottings.Items[i].LayerSlottings.Items[j] as TDescriptedLayer).DummyLayer then
        edtTextReport.Lines.Add((Well.Slottings.Items[i].LayerSlottings.Items[j] as TDescriptedLayer).Description.AllText)
      else
      begin
        if (Well.Slottings.Items[i].LayerSlottings.Items[j] as TDescriptedLayer).Capacity > 0 then
          edtTextReport.Lines.Add('Слой ' + (Well.Slottings.Items[i].LayerSlottings.Items[j] as TDescriptedLayer).Name +
                                  ' (' + FloatToStr((Well.Slottings.Items[i].LayerSlottings.Items[j] as TDescriptedLayer).Capacity) + ' м). ' +
                                  (Well.Slottings.Items[i].LayerSlottings.Items[j] as TDescriptedLayer).Description.AllText)
        else edtTextReport.Lines.Add('Слой ' + (Well.Slottings.Items[i].LayerSlottings.Items[j] as TDescriptedLayer).Name + ' ' +
                                     (Well.Slottings.Items[i].LayerSlottings.Items[j] as TDescriptedLayer).Description.AllText);
      end;
    end;

    // дата и авторы
    //Authors.Clear;
    //Authors.Poster.GetFromDB('DESCRIPTION_ID = ' + IntToStr((Well.Slottings.Items[i].LayerSlottings.Items[0] as TDescriptedLayer).Description.ID), Authors);

    edtTextReport.Lines.Add(' ');
    edtTextReport.Lines.Add(#9 + DateToStr((Well.Slottings.Items[i].LayerSlottings.Items[0] as TDescriptedLayer).Description.DateCreate) + #9#9#9 + (Authors as TAuthors).ObjectsToStr);
    edtTextReport.Lines.Add(' ');
  end;

  Authors.Free;
end;

procedure TfrmReport.actnSaveWordExecute(Sender: TObject);
var MSWord : Variant;
    i, index : integer;
    temp: string;
begin
  // сохранить в MS Word
  //try
    //MsWord := GetActiveOleObject('Word.Application');
  //except
    try
      MsWord := CreateOleObject('Word.Application');
      MsWord.Visible := True;
    except
      Exception.Create('Error');
    end;
  //end;

  MSWord.Documents.Add;
  MSWord.Selection.Font.Size := 12;
  MSWord.Selection.Font.Name := 'Times New Roman';

  // заголовок
  wrdFrm.ConnectTo(wrdApp.Selection.ParagraphFormat);
  wrdFrm.Alignment := wdAlignParagraphCenter;

  MSWord.Selection.Font.Bold := true;
  MSWord.Selection.TypeText(edtTextReport.Lines[0]);

  wrdFrm.ConnectTo(wrdApp.Selection.ParagraphFormat);
  wrdFrm.Alignment := wdAlignParagraphJustifyMed;
  wrdFrm.Hyphenation := 0;

  // остальной текст
  MSWord.Selection.Font.Bold := false;
  for i := 1 to edtTextReport.Lines.Count - 1 do
  begin
    if trim(edtTextReport.Lines[i]) <> '' then
    begin
      if (pos ('Долбление ', edtTextReport.Lines[i]) > 0) or
         (pos ('Интервал ', edtTextReport.Lines[i]) > 0) or
         (pos ('Проходка ', edtTextReport.Lines[i]) > 0) or
         (pos ('Выход керна ', edtTextReport.Lines[i]) > 0) then
      begin
        MSWord.Selection.Font.Bold := true;

        if (pos ('Долбление ', edtTextReport.Lines[i]) > 0) and (i > 5) then
          MSWord.Selection.TypeText(#10);

        MSWord.Selection.TypeText(#9 + edtTextReport.Lines[i] + #10);
      end
      else
      begin
        if (pos ('Слой ', edtTextReport.Lines[i]) > 0) then
        begin
          index := Pos(' )', edtTextReport.Lines[i]) + 1;

          temp := edtTextReport.Lines[i];
          MSWord.Selection.Font.Bold := true;
          Delete(temp, index + 1, Length(temp));
          MSWord.Selection.TypeText(#9 + temp + ' ');

          temp := edtTextReport.Lines[i];
          MSWord.Selection.Font.Bold := false;
          Delete(temp, 1, index + 2);
          MSWord.Selection.TypeText(temp + #10);
        end
        else
        begin
          MSWord.Selection.Font.Bold := false;

          if i <> edtTextReport.Lines.Count then
          if (pos (#9, edtTextReport.Lines[i + 1]) > 0) then
            MSWord.Selection.TypeText(edtTextReport.Lines[i] + #10)
          else MSWord.Selection.TypeText(edtTextReport.Lines[i]);
        end
      end;
    end
    else
    begin
      if edtTextReport.Lines[i] <> '' then MSWord.Selection.TypeText(#10)
      else MSWord.Selection.TypeText(#10#13);
    end;
  end;
end;

procedure TfrmReport.AddSlottingToReport;
begin
  Caption := 'Отчет по скважине №' + (ActiveObject as TWell).NumberWell + '-' + ActiveObject.Name;

  edtTextReport.Lines.Add('Описание керна по скв. ' + (ActiveObject as TWell).NumberWell + '-' + ActiveObject.Name + #10);
  edtTextReport.Lines.Add(' ');
  {
  if Assigned((ActiveSlotting as TDescriptedSlotting).Description) then
  begin
    edtTextReport.Lines.Add((ActiveSlotting as TDescriptedSlotting).Description.GetModelDescription + (ActiveSlotting as TDescriptedSlotting).Description.AllText);

    (ActiveSlotting as TDescriptedSlotting).Description.Authors.Poster.GetFromDB('DESCRIPTION_ID = ' + IntToStr((ActiveSlotting as TDescriptedSlotting).Description.ID), (ActiveSlotting as TDescriptedSlotting).Description.Authors);
    edtTextReport.Lines.Add(#9 + DateToStr((ActiveSlotting as TDescriptedSlotting).Description.DateCreate) + #9#9#9 +
                             (ActiveSlotting as TDescriptedSlotting).Description.Authors.ObjectsToStr);
  end;
  }
end;

end.
