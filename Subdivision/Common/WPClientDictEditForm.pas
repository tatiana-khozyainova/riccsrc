unit WPClientDictEditForm;

interface

uses
  Windows, Classes, Forms, Controls, StdCtrls, SysUtils, ComCtrls, Grids,
  Buttons, Messages, Menus;

type
  TDictAttributeRecord = record
    iAttributeID: integer;
    sAttributeName: shortstring;
    sRusAttributeName: shortstring;
    pvDict: PVariant;
  end;
  TDictTableRecord = record
    iTableID: integer;
    sTableName: shortstring;
    darKey: TDictAttributeRecord;
    arrAttribute: array of TDictAttributeRecord;
    pvDict: PVariant;
  end;

  TfrmDictEdit = class(TForm)
    lblDictList: TLabel;
    cmbxDictList: TComboBox;
    prgbrDictLoad: TProgressBar;
    strgrCurrentDict: TStringGrid;
    btnRefresh: TSpeedButton;
    edtSearch: TEdit;
    btnFirst: TSpeedButton;
    btnLast: TSpeedButton;
    btnInsert: TSpeedButton;
    btnEdit: TSpeedButton;
    btnDelete: TSpeedButton;
    ppmnDictRow: TPopupMenu;
    mniInsert: TMenuItem;
    mniEdit: TMenuItem;
    mniDelete: TMenuItem;
    mniBreak1: TMenuItem;
    mniBreak2: TMenuItem;
    chbxShowIDs: TCheckBox;
    lblSearch: TLabel;
    procedure cmbxDictListChange(Sender: TObject);
    procedure strgrCurrentDictMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure btnFirstClick(Sender: TObject);
    procedure btnLastClick(Sender: TObject);
    procedure edtSearchChange(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnInsertClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure chbxShowIDsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure strgrCurrentDictDblClick(Sender: TObject);
  private
    { Private declarations }
    dtrArray: array[0..3] of TDictTableRecord;
    dtrCurrentDict: TDictTableRecord;
    vCurrentDictStructure: variant;
    sAttrs: string;
    procedure PrepareFormForCurrentDict(AForm: TForm);
    procedure InsertCurrentDictRow(var strarrValues: array of string);
    procedure UpdateCurrentDictRow(var strarrValues: array of string);
  public
    { Public declarations }
  end;

var
  frmDictEdit: TfrmDictEdit;


implementation

uses StraDictCommon, ClientCommon, WPClientAddDictItemForm;

{$R *.DFM}

procedure TfrmDictEdit.cmbxDictListChange(Sender: TObject);
var vDict: variant;
    iAttrCount: byte;
    i, j, iRes: smallint;
    vQR: variant;
begin
  if cmbxDictList.ItemIndex >= 0 then
  begin
    strgrCurrentDict.Visible:= false;
    for i:=0 to strgrCurrentDict.ColCount - 1 do
    for j:=0 to strgrCurrentDict.RowCount - 1 do
      strgrCurrentDict.Cells[i, j]:= '';
    strgrCurrentDict.RowCount:= 2;
    strgrCurrentDict.ColCount:= 2;

    dtrCurrentDict.iTableID:= GetObjectID(vTableDict, cmbxDictList.Items[cmbxDictList.ItemIndex], 2);
    dtrCurrentDict.sTableName:= GetObjectName(vTableDict, dtrCurrentDict.iTableID);
    for i:=0 to high(dtrArray) do
      if UpperCase(dtrArray[i].sTableName) = UpperCase(dtrCurrentDict.sTableName) then
      begin
        if varIsEmpty(dtrArray[i].pvDict^) then
        begin
          vDict:=GetDictEx(dtrArray[i].sTableName);
          dtrArray[i].pvDict^:= vDict;
        end;
        dtrCurrentDict:= dtrArray[i];
        break;
      end;

    sAttrs:='';

    iAttrCount:=Length(dtrCurrentDict.arrAttribute);
    if iAttrCount > 0 then
    begin
      strgrCurrentDict.ColCount:=iAttrCount + 1; //все неключевые атрибуты + ключевой
      sAttrs:=', ';
      for i:=0 to iAttrCount - 1 do
      begin
        sAttrs:=sAttrs + dtrCurrentDict.arrAttribute[i].sAttributeName + ', ';
        strgrCurrentDict.Cells[i + 1, 0]:= dtrCurrentDict.arrAttribute[i].sRusAttributeName;
        if strgrCurrentDict.Cells[i + 1, 0] <> '' then
          strgrCurrentDict.ColWidths[i + 1]:= Length(dtrCurrentDict.arrAttribute[i].sRusAttributeName)*7;
      end;
      System.Delete(sAttrs, Length(sAttrs) - 1, 2);
    end;//if iAttrCount > 0

    strgrCurrentDict.Cells[0, 0]:= dtrCurrentDict.darKey.sRusAttributeName;
    if not chbxShowIDs.Checked
      then strgrCurrentDict.ColWidths[0]:= 1
      else strgrCurrentDict.ColWidths[0]:= 30;

    iRes:=IServer.SelectRows(dtrCurrentDict.sTableName, dtrCurrentDict.darKey.sAttributeName + sAttrs);//, '', null);
    if iRes > 0 then
    begin
      strgrCurrentDict.RowCount:= iRes + 1;
      vQR:= IServer.QueryResult;
      vCurrentDictStructure:= IServer.QueryResultStructure;
      for i:=0 to varArrayHighBound(vQR, 2) do
      begin
        strgrCurrentDict.Cells[0, i + 1]:= GetSingleValue(vQR, 0, i);
        for j:=0 to iAttrCount - 1 do
        if not Assigned(dtrCurrentDict.arrAttribute[j].pvDict)
           or varIsEmpty(dtrCurrentDict.arrAttribute[j].pvDict^) then
            strgrCurrentDict.Cells[j + 1, i + 1]:= GetSingleValue(vQR, j + 1, i)
        else
          strgrCurrentDict.Cells[j + 1, i + 1]:= GetObjectName(dtrCurrentDict.arrAttribute[j].pvDict^, vQR[j + 1, i]);
      end;
    end
    else begin
      strgrCurrentDict.RowCount:= 2;
      strgrCurrentDict.ColCount:= 2;
      for i:=0 to 2 do
      for j:=0 to 2 do
        strgrCurrentDict.Cells[i, j]:='';
    end;

    strgrCurrentDict.Visible:=true;
  end;//if cmbxDictList.ItemIndex >= 0
end;

procedure TfrmDictEdit.strgrCurrentDictMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var i, iCol, iRow: integer;
    strlst: TStringList;
//    iKey: word;
begin
  strgrCurrentDict.MouseToCell(X, Y, iCol, iRow);
  //Сортировка таблицы по столбцу, если по нему щёлкнули правой кнопкой с шифтом
  if (Button = mbLeft) and (ssShift in Shift) then
  begin
    if (iRow = 0) then
    begin
      strlst:= TStringList.Create();
      strlst.Capacity:= strgrCurrentDict.RowCount - 1;
      for i:= 1 to strgrCurrentDict.RowCount - 1 do
        strlst.Add(strgrCurrentDict.Cells[iCol, i] + ';' + strgrCurrentDict.Cells[0, i] + '=' + strgrCurrentDict.Rows[i].Text);
      strlst.Sort();
      strgrCurrentDict.Hide();

      prgbrDictLoad.Position:=0;
      prgbrDictLoad.Max:= strgrCurrentDict.RowCount - 1;
      prgbrDictLoad.Step:= 1;

      try
        for i:= 1 to strgrCurrentDict.RowCount - 1 do
        begin
          strgrCurrentDict.Rows[i].Text:= strlst.Values[strlst.Names[i - 1]];
          prgbrDictLoad.StepIt();
          prgbrDictLoad.Update();
        end;
      finally
        strgrCurrentDict.Show();
      end;//try
      strlst.Free();
      prgbrDictLoad.Position:=0;
    end;//if (iRow = 0)
  end;
{  if (iLastEditedRow > 0) and (iRow <> iLastEditedRow) then
  begin
    iKey:= VK_UP;
    strgrCurrentDictKeyUp(strgrCurrentDict, iKey, []);
  end;}
end;

procedure TfrmDictEdit.btnFirstClick(Sender: TObject);
var grFirstCell: TGridRect;
begin
  grFirstCell.Left:= 1;
  grFirstCell.Right:= 1;
  grFirstCell.Top:= 1;
  grFirstCell.Bottom:= 1;
  strgrCurrentDict.Selection:=grFirstCell;

  strgrCurrentDict.Perform(WM_KEYDOWN, VK_DOWN, 0);
  strgrCurrentDict.Perform(WM_KEYDOWN, VK_UP, 0);
end;

procedure TfrmDictEdit.btnLastClick(Sender: TObject);
var grLastCell: TGridRect;
begin
  grLastCell.Left:= 1;
  grLastCell.Right:= 1;
  grLastCell.Top:= strgrCurrentDict.RowCount - 1;
  grLastCell.Bottom:= grLastCell.Top;
  strgrCurrentDict.Selection:= grLastCell;

  strgrCurrentDict.Perform(WM_KEYDOWN, VK_UP, 0);
  strgrCurrentDict.Perform(WM_KEYDOWN, VK_DOWN, 0);
end;

procedure TfrmDictEdit.edtSearchChange(Sender: TObject);
var sSimilar: shortstring;
    iID: integer;
    i, j: word;
    grLastCell: TGridRect;
    bNoValue: boolean; //наличие такого текста в строке
begin
if Trim(edtSearch.Text) <> '' then
begin
  //если в строке есть такой текст (вообще)
  if Pos(ANSIUpperCase(Trim(edtSearch.Text)), strgrCurrentDict.Rows[strgrCurrentDict.Row].Text) > 0 then
  begin
    bNoValue:= true;
    //просматриваем строку по ячейкам - ищем начинающиеся с такого текста
    for i:= 1 to strgrCurrentDict.ColCount - 1 do
    if Pos(ANSIUpperCase(Trim(edtSearch.Text)), strgrCurrentDict.Cells[i, strgrCurrentDict.Row]) = 1 then
    begin
      bNoValue:= false;
      break;
    end;
  end
  else bNoValue:= true;
  if bNoValue then
  for i:= 1 to strgrCurrentDict.ColCount - 1 do
  begin
    sSimilar:= varAsType(GetFirstSimilarName(dtrCurrentDict.pvDict^,
                                             Trim(edtSearch.Text),
                                             iID,
                                             i),
                         varOleStr);
    if iID > 0 then
    begin
      for j:= 1 to strgrCurrentDict.RowCount - 1 do
      if strgrCurrentDict.Cells[0, j] = IntToStr(iID) then
      begin
        grLastCell.Left:= i;
        grLastCell.Right:= i;
        grLastCell.Top:= j;
        grLastCell.Bottom:= j;
        strgrCurrentDict.Selection:= grLastCell;

        //если строка не первая, то можно сначала перейти вверх, а потом вниз
        if j > 1 then
        begin
          strgrCurrentDict.Perform(WM_KEYDOWN, VK_UP, 0);
          strgrCurrentDict.Perform(WM_KEYDOWN, VK_DOWN, 0);
        end
        //иначе - вверх перейти нельзя, поэтому вниз-вверх
        else begin
          strgrCurrentDict.Perform(WM_KEYDOWN, VK_DOWN, 0);
          strgrCurrentDict.Perform(WM_KEYDOWN, VK_UP, 0);
        end;
        break;
      end;
      break;
    end;
  end;
end; //if Trim(edtSearch.Text) <> ''
end;

procedure TfrmDictEdit.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then Close();
end;

procedure TfrmDictEdit.btnInsertClick(Sender: TObject);
var strarr: array of string;
    i: byte;
begin
  if (cmbxDictList.ItemIndex >= 0)
  and(strgrCurrentDict.Row > 0) then
  begin
    frmWPClientAddDictItem:= TfrmWPClientAddDictItem.Create(Self);
    PrepareFormForCurrentDict(frmWPClientAddDictItem as TForm);
    if frmWPClientAddDictItem.ShowModal() = mrOK then
    begin
      SetLength(strarr, strgrCurrentDict.ColCount - 1);
      if Length(strarr) > 0 then
      begin
        for i:= 0 to Length(strarr) - 1 do
        if (frmWPClientAddDictItem.arrEdit[i] is TEdit) then
           strarr[i]:=(frmWPClientAddDictItem.arrEdit[i] as TEdit).Text
        else
        if (frmWPClientAddDictItem.arrEdit[i] is TComboBox) then
           strarr[i]:= dtrCurrentDict.arrAttribute[i].pvDict^[0,TComboBox(frmWPClientAddDictItem.arrEdit[i]).ItemIndex];

        InsertCurrentDictRow(strarr);
      end;
    end;
    frmWPClientAddDictItem.Free();
    frmWPClientAddDictItem:= nil;
  end;
end;

procedure TfrmDictEdit.btnEditClick(Sender: TObject);
var strarr: array of string;
    i: byte;
begin
  if (cmbxDictList.ItemIndex >= 0)
  and(strgrCurrentDict.Row > 0) then
  begin
    frmWPClientAddDictItem:= TfrmWPClientAddDictItem.Create(Self);
    PrepareFormForCurrentDict(frmWPClientAddDictItem as TForm);
    for i:= 1 to strgrCurrentDict.ColCount - 1 do
    if (frmWPClientAddDictItem.arrEdit[i - 1] is TEdit) then
        TEdit(frmWPClientAddDictItem.arrEdit[i - 1]).Text:= strgrCurrentDict.Cells[i, strgrCurrentDict.Row]
    else
    if (frmWPClientAddDictItem.arrEdit[i - 1] is TComboBox) then
        TComboBox(frmWPClientAddDictItem.arrEdit[i - 1]).ItemIndex:= TComboBox(frmWPClientAddDictItem.arrEdit[i - 1]).Items.IndexOf(strgrCurrentDict.Cells[i, strgrCurrentDict.Row]);
    if frmWPClientAddDictItem.ShowModal() = mrOK then
    begin
      SetLength(strarr, strgrCurrentDict.ColCount - 1);
      if Length(strarr) > 0 then
      begin
        for i := 0 to Length(strarr) - 1 do
        if frmWPClientAddDictItem.arrEdit[i] is TEdit then
          strarr[i]:=TEdit(frmWPClientAddDictItem.arrEdit[i]).Text
        else
        if frmWPClientAddDictItem.arrEdit[i] is TComboBox then
          strarr[i]:= dtrCurrentDict.arrAttribute[i].pvDict^[0,TComboBox(frmWPClientAddDictItem.arrEdit[i]).ItemIndex];

        UpdateCurrentDictRow(strarr);
      end;
    end;
    frmWPClientAddDictItem.Free();
    frmWPClientAddDictItem:= nil;
  end;
end;

procedure TfrmDictEdit.PrepareFormForCurrentDict(AForm: TForm);
var iAttrCount: byte;
    i: byte;
    j: integer;
begin
  if AForm is TfrmWPClientAddDictItem then
  with AForm as TfrmWPClientAddDictItem do
  begin
    iAttrCount:= Length(dtrCurrentDict.arrAttribute);
    if iAttrCount > 0 then
    begin
      AForm.ClientHeight:= 40 + iAttrCount * 40;
      btnOK:= TButton.Create(AForm);
      with btnOK do
      begin
        Parent:= AForm;
        Height:= 25;
        Width:= 75;
        Caption:= 'OK';
        Left:= 50;
        Top:= AForm.ClientHeight - 30;
        ModalResult:= mrOK;
        Default:= true;
        TabOrder:= iAttrCount;
      end;

      btnCancel:= TButton.Create(AForm);
      with btnCancel do
      begin
        Parent:= AForm;
        Height:= 25;
        Width:= 75;
        Caption:= 'Отмена';
        Left:= 130;
        Top:= AForm.ClientHeight - 30;
        ModalResult:= mrCancel;
        TabOrder:= iAttrCount + 1;
      end;
      for i:=0 to iAttrCount - 1 do
      begin
        SetLength(arrLabel, i + 1);
        arrLabel[i]:= TLabel.Create(AForm);
        //with arrLabel[i]
        begin
          arrLabel[i].Parent:= AForm;
          arrLabel[i].Left:= 5;
          arrLabel[i].Height:= 15;
          arrLabel[i].Top:= i * 40 + 5;
          arrLabel[i].Caption:= dtrCurrentDict.arrAttribute[i].sRusAttributeName;
        end;

        SetLength(arrEdit, i + 1);
        if not Assigned(dtrCurrentDict.arrAttribute[i].pvDict) then
        begin
          arrEdit[i]:= TEdit.Create(AForm);
          arrEdit[i].Parent := AForm;
        end
        else
        begin
          arrEdit[i]:= TComboBox.Create(AForm);
          arrEdit[i].Parent := AForm;
          TComboBox(arrEdit[i]).Style := csDropDownList;
          if not varIsEmpty(dtrCurrentDict.arrAttribute[i].pvDict^) then
          for j := 0 to varArrayHighBound(dtrCurrentDict.arrAttribute[i].pvDict^, 2) do
              TComboBox(arrEdit[i]).Items.Add(dtrCurrentDict.arrAttribute[i].pvDict^[1, j]);
        end;
        with arrEdit[i] do
        begin
          Left:= 5;
          Width:= 200;
          Height:= 20;
          Top:= i * 40 + 20;
          TabOrder:= i;
        end;
        ActiveControl:= arrEdit[0];        
      end;
    end;//if iAttrCount > 0
  end;
end;

procedure TfrmDictEdit.InsertCurrentDictRow(var strarrValues: array of string);
var iRes: smallint;
    vQR: variant;
    i, iRow: word;
    vValues, vColumns: variant;
begin
  iRes:= IServer.SelectRows(dtrCurrentDict.sTableName,
                            'MAX(' + dtrCurrentDict.darKey.sAttributeName + ') + 1',
                            '', null);
  if iRes > 0 then
  begin
    vQR:= IServer.QueryResult;
    iRow:= strgrCurrentDict.RowCount;
    strgrCurrentDict.RowCount:= iRow + 1;
    strgrCurrentDict.Row:= iRow;
    strgrCurrentDict.Cells[0, iRow]:= IntToStr(GetSingleValue(vQR));
    strgrCurrentDict.Col:= 1;

    vValues:= varArrayCreate([0, strgrCurrentDict.ColCount - 1], varVariant);
    vValues[0]:= StrToInt(strgrCurrentDict.Cells[0, strgrCurrentDict.Row]);
    for i:= 1 to strgrCurrentDict.ColCount - 1 do
    begin
      if (vCurrentDictStructure[i, 1] = 'I') then
        vValues[i]:= StrToIntEx(strarrValues[i - 1])
      else if (vCurrentDictStructure[i, 1] = 'F')
      or (vCurrentDictStructure[i, 1] = 'B')
      or (vCurrentDictStructure[i, 1] = 'N')
      or (vCurrentDictStructure[i, 1] = 'Y') then
        vValues[i]:= StrToFloatEx(strarrValues[i - 1])
      else vValues[i]:= strarrValues[i - 1];
    end;

    vColumns:= varArrayCreate([0, Length(dtrCurrentDict.arrAttribute)], varOleStr);
    vColumns[0]:=dtrCurrentDict.darKey.sAttributeName;
    for i:=0 to Length(dtrCurrentDict.arrAttribute) - 1 do
      vColumns[i + 1]:=dtrCurrentDict.arrAttribute[i].sAttributeName;
    iRes:= IServer.InsertRow(dtrCurrentDict.sTableName,
                             vColumns,
                             vValues);
    if iRes >= 0 then
    begin
      MessageBox(Self.Handle, 'Строка успешно добавлена.', 'Сообщение', mb_OK + mb_IconInformation);
      for i:= 1 to strgrCurrentDict.ColCount - 1 do
      if not Assigned(dtrCurrentDict.arrAttribute[i-1].pvDict) then
         strgrCurrentDict.Cells[i, iRow]:= strarrValues[i - 1]
      else
      if not varIsEmpty(dtrCurrentDict.arrAttribute[i-1].pvDict^) then
         strgrCurrentDict.Cells[i, iRow]:= GetObjectName(dtrCurrentDict.arrAttribute[i-1].pvDict^,
                                                         StrToFloat(strarrValues[i - 1]));
      // обновляем справочник
      dtrCurrentDict.pvDict^ := GetDictEx(dtrCurrentDict.sTableName);
    end
    else begin
      MessageBox(Self.Handle,
                 'Не удалось добавить строку!',
                 'Сообщение', mb_OK + mb_IconError);
      exit;
    end;
  end;
end;

procedure TfrmDictEdit.UpdateCurrentDictRow(var strarrValues: array of string);
var iRes: smallint;
    i: word;
    vValues, vColumns: variant;
begin
  vValues:= varArrayCreate([0, strgrCurrentDict.ColCount - 1], varVariant);
  vValues[0]:= StrToInt(strgrCurrentDict.Cells[0, strgrCurrentDict.Row]);
  for i:= 1 to strgrCurrentDict.ColCount - 1 do
  begin
    if (vCurrentDictStructure[i, 1] = 'I') then
      vValues[i]:= StrToIntEx(strarrValues[i - 1])
    else if (vCurrentDictStructure[i, 1] = 'F')
    or (vCurrentDictStructure[i, 1] = 'B')
    or (vCurrentDictStructure[i, 1] = 'N')
    or (vCurrentDictStructure[i, 1] = 'Y') then
      vValues[i]:= StrToFloatEx(strarrValues[i - 1])
    else vValues[i]:= strarrValues[i - 1];
  end;

  vColumns:= varArrayCreate([0, Length(dtrCurrentDict.arrAttribute)], varOleStr);
  vColumns[0]:=dtrCurrentDict.darKey.sAttributeName;
  for i:=0 to Length(dtrCurrentDict.arrAttribute) - 1 do
    vColumns[i + 1]:=dtrCurrentDict.arrAttribute[i].sAttributeName;
  iRes:= IServer.UpdateRow(dtrCurrentDict.sTableName,
                           vColumns,
                           vValues,
                           'WHERE ' + dtrCurrentDict.darKey.sAttributeName +
                             ' = ' + IntToStr(vValues[0]));
  if iRes >= 0 then
  begin
    MessageBox(Self.Handle, 'Строка успешно изменена.', 'Сообщение', mb_OK + mb_IconInformation);
    for i := 1 to strgrCurrentDict.ColCount - 1 do
    if not Assigned(dtrCurrentDict.arrAttribute[i-1].pvDict) then
       strgrCurrentDict.Cells[i, strgrCurrentDict.Row]:= strarrValues[i - 1]
    else
    if not varIsEmpty(dtrCurrentDict.arrAttribute[i-1].pvDict^) then
       strgrCurrentDict.Cells[i, strgrCurrentDict.Row]:= GetObjectName(dtrCurrentDict.arrAttribute[i-1].pvDict^,
                                                                       StrToFloat(strarrValues[i - 1]));
    // обновляем справочник
    dtrCurrentDict.pvDict^ := GetDictEx(dtrCurrentDict.sTableName);
  end
  else MessageBox(Self.Handle, 'Не удалось изменить строку', 'Сообщение', mb_OK + mb_IconError);
end;

procedure TfrmDictEdit.btnDeleteClick(Sender: TObject);
var iRes: smallint;
begin
  if (cmbxDictList.ItemIndex >= 0)
  and(strgrCurrentDict.Row > 0) then
  if MessageBox(Self.Handle,
                'Вы действительно хотите удалить' + #10 + #13 +
                  'строку справочника?',
                'Подтверждение',
                mb_YesNo + mb_IconWarning) = IDYes then
  begin
    iRes:= IServer.DeleteRow(dtrCurrentDict.sTableName,
                             'WHERE ' + dtrCurrentDict.darKey.sAttributeName + ' = ' +
                               strgrCurrentDict.Cells[0, strgrCurrentDict.Row]);
    if iRes >= 0 then
    begin
      strgrCurrentDict.Rows[strgrCurrentDict.Row].Clear();//(strgrCurrentDict.Row);
      strgrCurrentDict.RowCount := strgrCurrentDict.RowCount - 1;
      MessageBox(Self.Handle, 'Строка успешно удалена', 'Сообщение', mb_OK + mb_IconInformation);
    end
    else MessageBox(Self.Handle, 'Не удалось удалить строку.'+#13#10 +
                    'Возможно, на неё ссылаются другие таблицы. ',
                    'Сообщение', mb_OK + mb_IconError);
  end;
end;

procedure TfrmDictEdit.btnRefreshClick(Sender: TObject);
begin
  cmbxDictListChange(cmbxDictList);
end;

procedure TfrmDictEdit.chbxShowIDsClick(Sender: TObject);
begin
  if not chbxShowIDs.Checked
    then strgrCurrentDict.ColWidths[0]:= -1
    else strgrCurrentDict.ColWidths[0]:= 30;
end;

procedure TfrmDictEdit.FormCreate(Sender: TObject);
var j, m: byte;
    i, k, l: word;
    iRes: smallint;
    vQR: variant;
    iResult: integer;
    vDict: variant;
begin

  dtrArray[0].sTableName:='tbl_Taxonomy_Type_dict';
  dtrArray[0].pvDict:= @Dicts.vTaxonomyType;

  dtrArray[1].sTableName:='tbl_Taxonomy_dict';
  dtrArray[1].pvDict:= @Dicts.vTaxonomy;

  dtrArray[2].sTableName:='tbl_Stratigraphy_Name_dict';
  dtrArray[2].pvDict:= @Dicts.vStratNames;

  dtrArray[3].sTableName:='tbl_Stratotype_Region_dict';
  dtrArray[3].pvDict:= @Dicts.vStratRegions;




  Self.Update();
  iResult := IServer.SelectRows('SPD_GET_TABLES',
                                 varArrayOf(['distinct Table_ID', 'vch_Table_Name', 'vch_Rus_Table_Name']),
                                 '',varArrayOf([iClientAppType, iGroupID, 2]));
  if iResult>0 then
     vTableDict:=IServer.QueryResult;

  prgbrDictLoad.Position:=0;
  if not varIsEmpty(vTableDict) then
    for j:=0 to High(dtrArray) do
    begin
      for i:=0 to varArrayHighBound(vTableDict, 2) do
        if UpperCase(vTableDict[1, i]) = UpperCase(dtrArray[j].sTableName) then
        begin
          cmbxDictList.Items.Add(vTableDict[2, i]);
          dtrArray[j].iTableID:= vTableDict[0, i];
          prgbrDictLoad.StepIt();
          prgbrDictLoad.Update();

          iRes:= IServer.ExecuteQuery('select att.ATTRIBUTE_ID, att.VCH_ATTRIBUTE_NAME, att.VCH_RUS_ATTRIBUTE_NAME, tbat.num_Is_Key ' +
                                      ' from tbl_Attribute att, tbl_Table_Attribute tbat ' +
                                      ' where tbat.Table_ID = ' + IntToStr(vTableDict[0, i]) +
                                      ' and tbat.Attribute_ID = att.Attribute_ID');
          if iRes > 0 then
          begin
            vQR:= IServer.QueryResult;
            m:=0;
            for k:=0 to iRes - 1 do
              if varAsType(GetSingleValue(vQR, 3, k), varSmallint) <> 1 then
              begin
                SetLength(dtrArray[j].arrAttribute, m + 1);
                dtrArray[j].arrAttribute[m].iAttributeID:= GetSingleValue(vQR, 0, k);
                dtrArray[j].arrAttribute[m].sAttributeName:= GetSingleValue(vQR, 1, k);
                dtrArray[j].arrAttribute[m].sRusAttributeName:= GetSingleValue(vQR, 2, k);
                if pos('_ID', UpperCase(dtrArray[j].arrAttribute[m].sAttributeName)) > 0 then
                for l := 0 to j - 1 do
                if UpperCase(dtrArray[j].arrAttribute[m].sAttributeName) =
                   UpperCase(dtrArray[l].darKey.sAttributeName) then
                begin
                  vDict:=GetDictEx(dtrArray[l].sTableName);
                  dtrArray[l].pvDict^ := vDict;
                  dtrArray[j].arrAttribute[m].pvDict := dtrArray[l].pvDict;
                  break;
                end;
                inc(m);
              end
              else begin
                dtrArray[j].darKey.iAttributeID:= GetSingleValue(vQR, 0, k);
                dtrArray[j].darKey.sAttributeName:= GetSingleValue(vQR, 1, k);
                dtrArray[j].darKey.sRusAttributeName:= GetSingleValue(vQR, 2, k);
              end;

            prgbrDictLoad.StepIt();
            prgbrDictLoad.Update();

          end;

          break;
        end;
      prgbrDictLoad.Position:=i;
      prgbrDictLoad.Update();
    end;
  cmbxDictList.Sorted:=true;
  prgbrDictLoad.Position:=0;
end;

procedure TfrmDictEdit.strgrCurrentDictDblClick(Sender: TObject);
begin
  btnEditClick(Sender);
end;

end.
