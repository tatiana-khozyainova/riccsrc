unit AllGisForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Menus, ExtCtrls, Buttons, Facade, AllGisReport,
  ActnList, SDReport, ComObj, ShellAPI, CheckLst, Area, Well, LasFile;

type
  TAllGis = class(TForm)
    pgc1: TPageControl;
    ts1: TTabSheet;
    ts2: TTabSheet;
    btnReport: TSpeedButton;
    btnClear: TSpeedButton;
    pnl1: TPanel;
    spl1: TSplitter;
    pnl2: TPanel;
    gbxWells: TGroupBox;
    chklstAreas: TCheckListBox;
    spl2: TSplitter;
    chklstWells: TCheckListBox;
    gbxCurves: TGroupBox;
    chklstCurves: TCheckListBox;
    chkAll: TCheckBox;
    chkAllWells: TCheckBox;
    rg1: TRadioGroup;
    mm1: TMainMenu;
    A1: TMenuItem;
    N1: TMenuItem;
    gbx1: TGroupBox;
    chkLas: TCheckBox;
    chkScan: TCheckBox;
    chkSIF: TCheckBox;
    gbx2: TGroupBox;
    lbl1: TLabel;
    edtZoom: TEdit;
    procedure actExportToExcelExecute(Sender: TObject);
    procedure actClearExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure chklstAreasClickCheck(Sender: TObject);
    procedure chkAllClick(Sender: TObject);
    procedure chkAllWellsClick(Sender: TObject);
    procedure rg1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AllGis: TAllGis;

implementation

{$R *.dfm}

procedure TAllGis.actExportToExcelExecute(Sender: TObject);
const
  xlExcel9795 = $0000002B;
  xlExcel8 = 56;
var
  Ex, Sheet: OLEVariant;
  i, k, r, c,p:integer;
  query, filter : String;
  AResult: OleVariant;
  Well:TSimpleWell;
  BigWell : TWell;
  Curve :TcurveCategory;
  s:Double;
begin
 if (rg1.ItemIndex=0) then
  begin
      filter:='';
      for i:=0 to chklstWells.Count-1 do
        begin
          Well:=TSimpleWell(chklstWells.Items.Objects[i]);
          filter:=filter+IntToStr(Well.ID)+',';
        end;
      filter[Length(filter)]:=')';
      filter:='('+filter;
      Ex := CreateOleObject('Excel.Application');
      Ex.Visible := false;
      Ex.Workbooks.Add;
      Sheet := Ex.Workbooks[1].WorkSheets[1];
      Sheet.name:='Отчет';
      //шапка
      Sheet.Rows[1].Font.Bold:=True;
      Ex.Rows[1].HorizontalAlignment:=3;
      Ex.Rows[1].VerticalAlignment:=2;
      Ex.Rows[2].HorizontalAlignment:=3;
      Ex.Rows[2].VerticalAlignment:=2;
      Ex.Range['A1:BG2'].Select;
      Ex.Selection.WrapText:=True;
      Ex.Range['B3:B999'].Select;
      Ex.Selection.NumberFormat := '@';
      Ex.Range['C3:C999'].Select;
      Ex.Selection.NumberFormat := '0.00';
      Ex.Range['D3:BG999'].Select;
      Ex.Selection.HorizontalAlignment:=3;
        //1
      Ex.Range['A1:A2'].Select;
      Ex.Selection.MergeCells:=True;
      Sheet.columns[1].ColumnWidth:=40;
      Sheet.cells[1,1]:='Площадь';
        //2
      Ex.Range['B1:B2'].Select;
      Ex.Selection.MergeCells:=True;
      Sheet.columns[1].ColumnWidth:=5;
      Sheet.cells[1,2]:='Номер';
        //3
      Ex.Range['C1:C2'].Select;
      Ex.Selection.MergeCells:=True;
      Sheet.columns[1].ColumnWidth:=20;
      Sheet.cells[1,3]:='Забой';
        //4
      Ex.Range['D1:F1'].Select;
      Ex.Selection.MergeCells:=True;
      Sheet.columns[1].ColumnWidth:=23;
      Sheet.cells[1,4]:='Барометрия';
      Sheet.cells[2,4]:='От';
      Sheet.cells[2,5]:='До';
      Sheet.cells[2,6]:='Кол-во LAS-файлов';
        //5
      Ex.Range['G1:I1'].Select;
      Ex.Selection.MergeCells:=True;
      Sheet.columns[1].ColumnWidth:=23;
      Sheet.cells[1,7]:='Аккустический каротаж';
      Sheet.cells[2,7]:='От';
      Sheet.cells[2,8]:='До';
      Sheet.cells[2,9]:='Кол-во LAS-файлов';
        //6
      Ex.Range['J1:L1'].Select;
      Ex.Selection.MergeCells:=True;
      Sheet.columns[1].ColumnWidth:=23;
      Sheet.cells[1,10]:='Боковой каротаж';
      Sheet.cells[2,10]:='От';
      Sheet.cells[2,11]:='До';
      Sheet.cells[2,12]:='Кол-во LAS-файлов';
        //7
      Ex.Range['M1:O1'].Select;
      Ex.Selection.MergeCells:=True;
      Sheet.columns[1].ColumnWidth:=23;
      Sheet.cells[1,13]:='Градиент-зонд';
      Sheet.cells[2,13]:='От';
      Sheet.cells[2,14]:='До';
      Sheet.cells[2,15]:='Кол-во LAS-файлов';
        //8
      Ex.Range['P1:R1'].Select;
      Ex.Selection.MergeCells:=True;
      Sheet.columns[1].ColumnWidth:=23;
      Sheet.cells[1,16]:='Гамма каротаж';
      Sheet.cells[2,16]:='От';
      Sheet.cells[2,17]:='До';
      Sheet.cells[2,18]:='Кол-во LAS-файлов';
        //9
      Ex.Range['S1:U1'].Select;
      Ex.Selection.MergeCells:=True;
      Sheet.columns[1].ColumnWidth:=23;
      Sheet.cells[1,19]:='Номинальный диаметр скважины';
      Sheet.cells[2,19]:='От';
      Sheet.cells[2,20]:='До';
      Sheet.cells[2,21]:='Кол-во LAS-файлов';
        //10
      Ex.Range['V1:X1'].Select;
      Ex.Selection.MergeCells:=True;
      Sheet.columns[1].ColumnWidth:=23;
      Sheet.cells[1,22]:='Диаметр скважины';
      Sheet.cells[2,22]:='От';
      Sheet.cells[2,23]:='До';
      Sheet.cells[2,24]:='Кол-во LAS-файлов';
        //11
      Ex.Range['Y1:AA1'].Select;
      Ex.Selection.MergeCells:=True;
      Sheet.columns[1].ColumnWidth:=23;
      Sheet.cells[1,25]:='Индукционный каротаж';
      Sheet.cells[2,25]:='От';
      Sheet.cells[2,26]:='До';
      Sheet.cells[2,27]:='Кол-во LAS-файлов';
        //12
      Ex.Range['AB1:AD1'].Select;
      Ex.Selection.MergeCells:=True;
      Sheet.columns[1].ColumnWidth:=23;
      Sheet.cells[1,28]:='Инклонометрия';
      Sheet.cells[2,28]:='От';
      Sheet.cells[2,29]:='До';
      Sheet.cells[2,30]:='Кол-во LAS-файлов';
      //13
      Ex.Range['AE1:AG1'].Select;
      Ex.Selection.MergeCells:=True;
      Sheet.columns[1].ColumnWidth:=23;
      Sheet.cells[1,31]:='Мкрокавернометрия';
      Sheet.cells[2,31]:='От';
      Sheet.cells[2,32]:='До';
      Sheet.cells[2,33]:='Кол-во LAS-файлов';
      //14
      Ex.Range['AH1:AJ1'].Select;
      Ex.Selection.MergeCells:=True;
      Sheet.columns[1].ColumnWidth:=23;
      Sheet.cells[1,34]:='Нейтронный гамма-каротаж';
      Sheet.cells[2,34]:='От';
      Sheet.cells[2,35]:='До';
      Sheet.cells[2,36]:='Кол-во LAS-файлов';
      //15
      Ex.Range['AK1:AM1'].Select;
      Ex.Selection.MergeCells:=True;
      Sheet.columns[1].ColumnWidth:=23;
      Sheet.cells[1,37]:='Потенциал-зонд';
      Sheet.cells[2,37]:='От';
      Sheet.cells[2,38]:='До';
      Sheet.cells[2,39]:='Кол-во LAS-файлов';
      //16
      Ex.Range['AN1:AP1'].Select;
      Ex.Selection.MergeCells:=True;
      Sheet.columns[1].ColumnWidth:=23;
      Sheet.cells[1,40]:='Профилеметрия';
      Sheet.cells[2,40]:='От';
      Sheet.cells[2,41]:='До';
      Sheet.cells[2,42]:='Кол-во LAS-файлов';
      //17
      Ex.Range['AQ1:AS1'].Select;
      Ex.Selection.MergeCells:=True;
      Sheet.columns[1].ColumnWidth:=23;
      Sheet.cells[1,43]:='Потенциалы самопроизвольной поляризации';
      Sheet.cells[2,43]:='От';
      Sheet.cells[2,44]:='До';
      Sheet.cells[2,45]:='Кол-во LAS-файлов';
      //18
      Ex.Range['AT1:AV1'].Select;
      Ex.Selection.MergeCells:=True;
      Sheet.columns[1].ColumnWidth:=23;
      Sheet.cells[1,46]:='Термометрия';
      Sheet.cells[2,46]:='От';
      Sheet.cells[2,47]:='До';
      Sheet.cells[2,48]:='Кол-во LAS-файлов';
      //19
      Ex.Range['AW1:AY1'].Select;
      Ex.Selection.MergeCells:=True;
      Sheet.columns[1].ColumnWidth:=23;
      Sheet.cells[1,49]:='Микрокаротаж';
      Sheet.cells[2,49]:='От';
      Sheet.cells[2,50]:='До';
      Sheet.cells[2,51]:='Кол-во LAS-файлов';
      //20
      Ex.Range['AZ1:BB1'].Select;
      Ex.Selection.MergeCells:=True;
      Sheet.columns[1].ColumnWidth:=23;
      Sheet.cells[1,52]:='Газовый каротаж';
      Sheet.cells[2,52]:='От';
      Sheet.cells[2,53]:='До';
      Sheet.cells[2,54]:='Кол-во LAS-файлов';
      //21-SIF
      Ex.Range['BC1:BC2'].Select;
      Ex.Selection.MergeCells:=True;
      Sheet.columns[1].ColumnWidth:=23;
      Sheet.cells[1,55]:='Документы СИФ';
      //22-
      Ex.Range['BD1:BD2'].Select;
      Ex.Selection.MergeCells:=True;
      Sheet.columns[1].ColumnWidth:=23;
      Sheet.cells[1,56]:='Каротаж';
      //23
      Ex.Range['BE1:BE2'].Select;
      Ex.Selection.MergeCells:=True;
      Sheet.columns[1].ColumnWidth:=23;
      Sheet.cells[1,57]:='Заключение ГИС';
      //24
      Ex.Range['BF1:BF2'].Select;
      Ex.Selection.MergeCells:=True;
      Sheet.columns[1].ColumnWidth:=23;
      Sheet.cells[1,58]:='Инклинограмма';
      //25
      Ex.Range['BG1:BG2'].Select;
      Ex.Selection.MergeCells:=True;
      Sheet.columns[1].ColumnWidth:=23;
      Sheet.cells[1,59]:='Таблицы вертикальных и горизонтальных поправок';
      p:=3;  //Отступ от шапки
      Query := 'select * from vw_well_curve_category where well_uin in '+filter;
      if (TMainFacade.GetInstance.DBGates.ExecuteQuery(query, AResult)>0) then
      begin
        for k:= VarArrayLowBound(AResult,2) to VarArrayHighBound(AResult,2)-1 do
         begin
          sheet.cells[k+p, 1]:=AResult[1,k];
          sheet.cells[k+p, 2]:=AResult[2,k];
          sheet.cells[k+p, 3]:=AResult[3,k];
          sheet.cells[k+p, 4]:=AResult[4,k];
          sheet.cells[k+p, 5]:=AResult[5,k];
          sheet.cells[k+p, 6]:=AResult[6,k];
          sheet.cells[k+p, 7]:=AResult[7,k];
          sheet.cells[k+p, 8]:=AResult[8,k];
          sheet.cells[k+p, 9]:=AResult[9,k];
          sheet.cells[k+p, 10]:=AResult[10,k];
          sheet.cells[k+p, 11]:=AResult[11,k];
          sheet.cells[k+p, 12]:=AResult[12,k];
          sheet.cells[k+p, 13]:=AResult[13,k];
          sheet.cells[k+p, 14]:=AResult[14,k];
          sheet.cells[k+p, 15]:=AResult[15,k];
          sheet.cells[k+p, 16]:=AResult[16,k];
          sheet.cells[k+p, 17]:=AResult[17,k];
          sheet.cells[k+p, 18]:=AResult[18,k];
          sheet.cells[k+p, 19]:=AResult[19,k];
          sheet.cells[k+p, 20]:=AResult[20,k];
          sheet.cells[k+p, 21]:=AResult[21,k];
          sheet.cells[k+p, 22]:=AResult[22,k];
          sheet.cells[k+p, 23]:=AResult[23,k];
          sheet.cells[k+p, 24]:=AResult[24,k];
          sheet.cells[k+p, 25]:=AResult[25,k];
          sheet.cells[k+p, 26]:=AResult[26,k];
          sheet.cells[k+p, 27]:=AResult[27,k];
          sheet.cells[k+p, 28]:=AResult[28,k];
          sheet.cells[k+p, 29]:=AResult[29,k];
          sheet.cells[k+p, 30]:=AResult[30,k];
          sheet.cells[k+p, 31]:=AResult[31,k];
          sheet.cells[k+p, 32]:=AResult[32,k];
          sheet.cells[k+p, 33]:=AResult[33,k];
          sheet.cells[k+p, 34]:=AResult[34,k];
          sheet.cells[k+p, 35]:=AResult[35,k];
          sheet.cells[k+p, 36]:=AResult[36,k];
          sheet.cells[k+p, 37]:=AResult[37,k];
          sheet.cells[k+p, 38]:=AResult[38,k];
          sheet.cells[k+p, 39]:=AResult[39,k];
          sheet.cells[k+p, 40]:=AResult[40,k];
          sheet.cells[k+p, 41]:=AResult[41,k];
          sheet.cells[k+p, 42]:=AResult[42,k];
          sheet.cells[k+p, 43]:=AResult[43,k];
          sheet.cells[k+p, 44]:=AResult[44,k];
          sheet.cells[k+p, 45]:=AResult[45,k];
          sheet.cells[k+p, 46]:=AResult[46,k];
          sheet.cells[k+p, 47]:=AResult[47,k];
          sheet.cells[k+p, 48]:=AResult[48,k];
          sheet.cells[k+p, 49]:=AResult[49,k];
          sheet.cells[k+p, 50]:=AResult[50,k];
          sheet.cells[k+p, 51]:=AResult[51,k];
          sheet.cells[k+p, 52]:=AResult[52,k];
          sheet.cells[k+p, 53]:=AResult[53,k];
          sheet.cells[k+p, 54]:=AResult[54,k];
          sheet.cells[k+p, 55]:=AResult[55,k];
          sheet.cells[k+p, 56]:=AResult[56,k];
          sheet.cells[k+p, 57]:=AResult[57,k];
          sheet.cells[k+p, 58]:=AResult[58,k];
          sheet.cells[k+p, 59]:=AResult[59,k];
         end;
       Ex.Range['A1:BG'+inttostr(VarArrayHighBound(AResult,2)+2)].Select;
       Ex.Selection.Borders.LineStyle:=1;

      end;
      Ex.DisplayAlerts := False;
        try
           Ex.Workbooks[1].saveas('C:\ReportGis.xls', xlExcel9795);
           //showmessage('???? ???????? 2003-?? ????');
        except
          Ex.Workbooks[1].saveas('C:\ReportGis.xls', xlExcel8);
          //showmessage('???? ???????? 2007 ??? 2010-?? ????');
        end;
      Ex.Quit;
      Ex := Unassigned;
      Sheet := Unassigned;
      ShellExecute(Handle, 'open','C:\ReportGis.xls', nil, nil, SW_MAXIMIZE );
 end
 else
  begin
      Ex := CreateOleObject('Excel.Application');
      Ex.Visible := false;
      Ex.Workbooks.Add;
      Sheet := Ex.Workbooks[1].WorkSheets[1];
      Sheet.name:='Отчет';
      //шапка
      Sheet.Rows[1].Font.Bold:=True;
      Ex.Rows[1].HorizontalAlignment:=3;
      Ex.Rows[1].VerticalAlignment:=2;
      Ex.Rows[2].HorizontalAlignment:=3;
      Ex.Rows[2].VerticalAlignment:=2;
      Ex.Range['A1:H1'].Select;
      Ex.Selection.MergeCells:=True;
      Ex.Range['A2:H2'].Select;
      Ex.Selection.MergeCells:=True;

        //1
      Sheet.columns[1].ColumnWidth:=40;
      Sheet.cells[4,1]:='Площадь';
        //2
      Sheet.columns[2].ColumnWidth:=10;
      Sheet.cells[4,2]:='№ скв.';
        //3
      Sheet.columns[3].ColumnWidth:=15;
      Sheet.cells[4,3]:='Метод';
        //4
      Sheet.columns[4].ColumnWidth:=15;
      Sheet.cells[4,4]:='Масштаб';
       //5
      Sheet.columns[5].ColumnWidth:=15;
      Ex.Range['E4:F4'].Select;
      Ex.Selection.MergeCells:=True;
      Sheet.cells[4,5]:='Интервал';
        //6
      Sheet.columns[7].ColumnWidth:=10;
      Sheet.cells[4,7]:='Метры';
       //7
      Sheet.columns[8].ColumnWidth:=10;
      Sheet.cells[4,8]:='Погон. м';

      for i:=0 to chklstWells.Count-1 do
      if (chklstCurves.Checked[i]) then
         Well:=TSimpleWell(chklstWells.Items.Objects[i]);

      TMainFacade.GetInstance.ExportFilter:='WELL_UIN IN ('+IntToStr(Well.ID)+')';
      query := IntToStr(TMainFacade.Getinstance.AllExportWells.Count);
      
      BigWell:= TWell(TMainFacade.GetInstance.AllExportWells.ItemsByID[Well.ID]);

      Sheet.cells[1,1]:='Скважина '+BigWell.NumberWell+'-'+BigWell.Area.Name;
      Sheet.cells[2,1]:='Расчет объемов и стоимости оцифровки';
      Sheet.cells[5,1]:=BigWell.Area.Name;
      Sheet.cells[5,2]:=BigWell.NumberWell;

      filter:=edtZoom.Text;
      s:=0;
      r:=0;
      for i:=0 to chklstCurves.Count-1 do
        if (chklstCurves.Checked[i]) then
          begin
           Curve:=TCurveCategory(chklstCurves.Items.Objects[i]);
           Sheet.cells[5+r,3]:=Curve.ShortName;
           Sheet.cells[5+r,4]:='1/'+filter;
           Sheet.cells[5+r,5]:='0';
           Sheet.cells[5+r,6]:=FloatToStr(BigWell.TrueDepth);
           Sheet.cells[5+r,7]:=FloatToStr(BigWell.TrueDepth);
           Sheet.cells[5+r,8]:=FloatToStr(BigWell.TrueDepth/StrToInt(filter));
           s:=s+BigWell.TrueDepth/StrToInt(filter);
           inc(r);
          end;

      Ex.Range['A5:A'+inttostr(r+4)].Select;
      Ex.Selection.MergeCells:=True;
      Ex.Selection.VerticalAlignment:=1;

      Ex.Range['B5:B'+inttostr(r+4)].Select;
      Ex.Selection.MergeCells:=True;
      Ex.Selection.VerticalAlignment:=1;

      Ex.Range['A4:H'+inttostr(r+4)].Select;
      Ex.Selection.Borders.LineStyle:=1;
      Ex.Selection.HorizontalAlignment:=3;

      Sheet.cells[5+r,7]:='итого:';
      Sheet.cells[5+r,8]:=FloatToStr(s);


      Ex.DisplayAlerts := False;
        try
           Ex.Workbooks[1].saveas('C:\'+IntToStr(Well.ID)+'-Расчет объемов и стоимости оцифровки.xls', xlExcel9795);
        except
          Ex.Workbooks[1].saveas('C:\'+IntToStr(Well.ID)+'-Расчет объемов и стоимости оцифровки.xls', xlExcel8);
        end;
      Ex.Quit;
      Ex := Unassigned;
      Sheet := Unassigned;
      ShellExecute(Handle, 'open',PChar('C:\'+IntToStr(Well.ID)+'-Расчет объемов и стоимости оцифровки.xls'), nil, nil, SW_MAXIMIZE );
  end;
end;

procedure TAllGis.actClearExecute(Sender: TObject);
begin
//clear
end;

procedure TAllGis.FormCreate(Sender: TObject);
var
i:Integer;
begin
//TMainFacade.GetInstance.AllExportWells;
TMainFacade.GetInstance.AllAreas.Reload('',true);
TMainFacade.GetInstance.AllCurveCategories.Reload('',true);
for i:=0 to TMainFacade.Getinstance.AllAreas.Count-1 do
  chklstAreas.Items.AddObject(TMainFacade.Getinstance.AllAreas.Items[i].Name, TMainFacade.Getinstance.AllAreas.Items[i]);
for i:=0 to TMainFacade.Getinstance.AllCurveCategories.Count-1 do
  chklstCurves.Items.AddObject(TMainFacade.Getinstance.AllCurveCategories.Items[i].Name, TMainFacade.Getinstance.AllCurveCategories.Items[i]);
end;

procedure TAllGis.chklstAreasClickCheck(Sender: TObject);
var
  i,k:Integer;
  Area:TArea;
begin
chklstWells.Clear;
for i:=0 to chklstAreas.Count-1 do
  if (chklstAreas.Checked[i]) then
      begin
        Area:=TArea (chklstAreas.Items.Objects[i]);
        for k:=0 to Area.Wells.Count-1 do
            chklstWells.Items.AddObject(Area.Wells.Items[k].NumberWell+'-'+Area.Name, TSimpleWell(Area.Wells.Items[k]));
          //chklstWells.Items.AddObject(TWell(TMainFacade.GetInstance.AllExportWells.ItemsByID[Area.Wells.Items[k].ID]).NumberWell+' - '+Area.Name, TWell(TMainFacade.GetInstance.AllExportWells.ItemsByID[Area.Wells.Items[k].ID]));
      end;
end;

procedure TAllGis.chkAllClick(Sender: TObject);
var
  i:Integer;
begin
  if (chkAll.Checked) then
    for i:=0 to chklstCurves.Count-1 do
      chklstCurves.Checked[i]:=True
  else
    for i:=0 to chklstCurves.Count-1 do
      chklstCurves.Checked[i]:=False;
end;

procedure TAllGis.chkAllWellsClick(Sender: TObject);
var
  i:Integer;
begin
   if (chkAllWells.Checked) then
    for i:=0 to chklstWells.Count-1 do
      chklstWells.Checked[i]:=True
  else
    for i:=0 to chklstWells.Count-1 do
      chklstWells.Checked[i]:=False;
end;

procedure TAllGis.rg1Click(Sender: TObject);
begin
if (rg1.ItemIndex=0) then
  begin
    chkLas.Enabled:=True;
    chkScan.Enabled:=True;
    chkSIF.Enabled:=True;
    edtZoom.Enabled:=False;
    lbl1.Enabled:=False;
  end
else
  begin
    chkLas.Enabled:=False;
    chkScan.Enabled:=False;
    chkSIF.Enabled:=False;
    edtZoom.Enabled:=True;
    lbl1.Enabled:=True;
  end;
end;

end.
