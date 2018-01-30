unit FrameSeisMateralList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ComCtrls, SeisMaterial,
  SeisExemple,SeisProfile,Material, Structure, Table, ActnList;

type
  TFrame2 = class(TFrame)
    tvSeisMaterial: TTreeView;
    actlstSeisMaterialList: TActionList;
    actOpen: TAction;
    lvSeisMaterialProperty: TListView;
    actSelectProperty: TAction;
    actDrawItemList: TAction;
    pbLoadDict: TProgressBar;
    //procedure actOpenExecute(Sender: TObject);
    //procedure actSelectPropertyExecute(Sender: TObject);
    //procedure actDrawItemListExecute(Sender: TObject);
    procedure lvSeisMaterialPropertyCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);


  private
    { Private declarations }

  public
    { Public declarations }

  end;

implementation

uses Facade,SeisMaterialPoster,SeisExemplePoster,SeisProfilePoster,MaterialPoster, StructurePoster, TablePoster, DateUtils;
{$R *.dfm}

{procedure TFrame2.actOpenExecute(Sender: TObject);
var i0,i1,i2,i3,step1,step2,step3:Integer;
begin
step1:=-1;
step2:=-1;
tvSeisMaterial.Items.Clear;
tvSeisMaterial.Items.BeginUpdate;
tvSeisMaterial.Items.Add(nil,'Отчеты сейсморазведочных работ');
  for i0:=0 to TMainFacade.GetInstance.AllSimpleDocuments.Count-1 do
  begin
    //if (TMainFacade.GetInstance.AllSimpleDocuments.Items[i0].DocType.ID=70) then
    //begin
    tvSeisMaterial.Items.AddChildObject(tvSeisMaterial.Items.Item[0],IntToStr(TMainFacade.GetInstance.AllSimpleDocuments.Items[i0].InventNumber)+' '+TMainFacade.GetInstance.AllSimpleDocuments.Items[i0].Name+' '+IntToStr(TMainFacade.GetInstance.AllSimpleDocuments.Items[i0].ID),TMainFacade.GetInstance.AllSimpleDocuments.Items[i0]);
    Inc(step1);
      for i1:=0 to TMainFacade.GetInstance.AllSeismicMaterials.Count-1 do
      begin
      if (TMainFacade.GetInstance.AllSeismicMaterials.Items[i1].SimpleDocument.ID=TMainFacade.GetInstance.AllSimpleDocuments.Items[i0].ID) then
        begin
        tvSeisMaterial.Items.AddChildObject(tvSeisMaterial.Items.Item[0].Item[step1],'Подробно',TMainFacade.GetInstance.AllSeismicMaterials.Items[i1]);

          tvSeisMaterial.Items.AddChild(tvSeisMaterial.Items.Item[0].Item[step1].Item[0],'Сейсмопрофиля');
          tvSeisMaterial.Items.AddChild(tvSeisMaterial.Items.Item[0].Item[step1].Item[0],'Экземпляры отчета');

          for i2:=0 to TMainFacade.GetInstance.ALLSeismicProfiles.Count-1 do
          if (TMainFacade.GetInstance.ALLSeismicProfiles.Items[i2].SeismicMaterial.ID=TMainFacade.GetInstance.AllSeismicMaterials.Items[i1].ID) then
            begin
            inc(step2);
            tvSeisMaterial.Items.AddChildObject(tvSeisMaterial.Items.Item[0].Item[step1].Item[0].Item[0],'№'+IntToStr(TMainFacade.GetInstance.ALLSeismicProfiles.Items[i2].SeisProfileNumber),TMainFacade.GetInstance.ALLSeismicProfiles.Items[i2]);
           // tvSeisMaterial.Items.AddChild(tvSeisMaterial.Items.Item[0].Item[step1].Item[0].Item[0].Item[step2],'Координаты');

           // for i3:=0 to TMainFacade.GetInstance.AllSeismicProfileCoordinates.Count-1 do
           // if (TMainFacade.GetInstance.AllSeismicProfileCoordinates.Items[i3].SeismicProfile.ID=TMainFacade.GetInstance.ALLSeismicProfiles.Items[i2].ID) then
           // tvSeisMaterial.Items.AddChildObject(tvSeisMaterial.Items.Item[0].Item[step1].Item[0].Item[0].Item[step2].Item[0],'№'+IntToStr(TMainFacade.GetInstance.AllSeismicProfileCoordinates.Items[i3].CoordNumber)+' X:'+FloatToStr(TMainFacade.GetInstance.AllSeismicProfileCoordinates.Items[i3].CoordX)+' Y:'+FloatToStr(TMainFacade.GetInstance.AllSeismicProfileCoordinates.Items[i3].CoordY),TMainFacade.GetInstance.AllSeismicProfileCoordinates.Items[i3]);
            end;
          step2:=-1;

          for i2:=0 to TMainFacade.GetInstance.ALLExempleSeismicMaterials.Count-1 do
          if (TMainFacade.GetInstance.ALLExempleSeismicMaterials.Items[i2].SeismicMaterial.ID=TMainFacade.GetInstance.AllSeismicMaterials.Items[i1].ID) then
            begin
            inc(step2);
            tvSeisMaterial.Items.AddChildObject(tvSeisMaterial.Items.Item[0].Item[step1].Item[0].Item[1],'№'+IntToStr(TMainFacade.GetInstance.ALLExempleSeismicMaterials.Items[i2].ID)+' '+TMainFacade.GetInstance.ALLExempleSeismicMaterials.Items[i2].ExempleType.Name,TMainFacade.GetInstance.ALLExempleSeismicMaterials.Items[i2]);
            tvSeisMaterial.Items.AddChild(tvSeisMaterial.Items.Item[0].Item[step1].Item[0].Item[1].Item[step2],'Элементы экземпляра');

            for i3:=0 to TMainFacade.GetInstance.ALLElementExemples.Count-1 do
            if (TMainFacade.GetInstance.ALLElementExemples.Items[i3].ExempleSeismicMaterial.ID=TMainFacade.GetInstance.ALLExempleSeismicMaterials.Items[i2].ID) then
            tvSeisMaterial.Items.AddChildObject(tvSeisMaterial.Items.Item[0].Item[step1].Item[0].Item[1].Item[step2].Item[0],'№'+IntToStr(TMainFacade.GetInstance.ALLElementExemples.Items[i3].ElementNumber)+' '+TMainFacade.GetInstance.ALLElementExemples.Items[i3].ElementType.Name,TMainFacade.GetInstance.ALLElementExemples.Items[i3]);
            end;
          step2:=-1;
        end;
      //end;
    end;
  end;
  tvSeisMaterial.Items.EndUpdate;
end;

procedure TFrame2.actSelectPropertyExecute(Sender: TObject);
var ListItem:TListItem;Column:TListColumn;
i3:Integer;
begin
//lvSeisMaterialProperty.Items.BeginUpdate;
lvSeisMaterialProperty.Clear;
ListItem:=TListItem.Create(lvSeisMaterialProperty.Items);
if TObject(tvSeisMaterial.Selected.Data) is TSimpleDocument then
begin
lvSeisMaterialProperty.Items.BeginUpdate;
 lvSeisMaterialProperty.Column[0].Caption:='Сейсмический отчет';
 ListItem:=lvSeisMaterialProperty.Items.Add;
 ListItem.Caption:='Инвентарный номер';
ListShortLine(lvSeisMaterialProperty,ListItem,IntToStr((TObject(tvSeisMaterial.Selected.Data) as TSimpleDocument).InventNumber));
ListItem:=lvSeisMaterialProperty.Items.Add;
 ListItem.Caption:='Номер ТГФ';
ListShortLine(lvSeisMaterialProperty,ListItem,IntToStr((TObject(tvSeisMaterial.Selected.Data) as TSimpleDocument).TGFNumber));
ListItem:=lvSeisMaterialProperty.Items.Add;
 ListItem.Caption:='Название отчета';
ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TSimpleDocument).Name);
ListItem:=lvSeisMaterialProperty.Items.Add;
 ListItem.Caption:='Дата создания отчета';
ListShortLine(lvSeisMaterialProperty,ListItem,DateToStr((TObject(tvSeisMaterial.Selected.Data) as TSimpleDocument).CreationDate));
ListItem:=lvSeisMaterialProperty.Items.Add;
 ListItem.Caption:='Авторы отчета';
ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TSimpleDocument).Authors);
ListItem:=lvSeisMaterialProperty.Items.Add;
 ListItem.Caption:='Организация-заказчик';
if not Assigned((TObject(tvSeisMaterial.Selected.Data) as TSimpleDocument).Organization) then
ListShortLine(lvSeisMaterialProperty,ListItem,'<нет данных>')
else ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TSimpleDocument).Organization.Name);
ListItem:=lvSeisMaterialProperty.Items.Add;
ListItem.Caption:='Местонахождение отчета';
if not Assigned((TObject(tvSeisMaterial.Selected.Data) as TSimpleDocument).MaterialLocation) then
ListShortLine(lvSeisMaterialProperty,ListItem,'<нет данных>')
else ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TSimpleDocument).MaterialLocation.Name);
ListItem:=lvSeisMaterialProperty.Items.Add;
 ListItem.Caption:='Комментарий';
ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TSimpleDocument).MaterialComment);
ListItem:=lvSeisMaterialProperty.Items.Add;
 ListItem.Caption:='Сотрудник внесший отчет';
if not Assigned((TObject(tvSeisMaterial.Selected.Data) as TSimpleDocument).Employee) then
ListShortLine(lvSeisMaterialProperty,ListItem,'<нет данных>')
else ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TSimpleDocument).Employee.Name);
ListItem:=lvSeisMaterialProperty.Items.Add;
 ListItem.Caption:='Дата внесения отчета';
ListShortLine(lvSeisMaterialProperty,ListItem,DateToStr((TObject(tvSeisMaterial.Selected.Data) as TSimpleDocument).EnteringDate));

lvSeisMaterialProperty.Items.EndUpdate;
end
else
if TObject(tvSeisMaterial.Selected.Data) is TSeismicMaterial then
begin
 lvSeisMaterialProperty.Items.BeginUpdate;
 lvSeisMaterialProperty.Column[0].Caption:='Сейсмический материал(подробно)';
 ListItem:=lvSeisMaterialProperty.Items.Add;
 ListItem.Caption:='№Сейсмопартии';
ListShortLine(lvSeisMaterialProperty,ListItem,IntToStr((TObject(tvSeisMaterial.Selected.Data) as TSeismicMaterial).SeisCrew.SeisCrewNumber));
 ListItem:=lvSeisMaterialProperty.Items.Add;
 ListItem.Caption:='Метод сейсморазведочных работ:';
ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TSeismicMaterial).SeisWorkMethod.Name);
 ListItem:=lvSeisMaterialProperty.Items.Add;
 ListItem.Caption:='Тип сейсморазведочных работ:';
ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TSeismicMaterial).SeisWorkType.Name);
 ListItem:=lvSeisMaterialProperty.Items.Add;
 ListItem.Caption:='Дата начала работ:';
ListShortLine(lvSeisMaterialProperty,ListItem,DateToStr((TObject(tvSeisMaterial.Selected.Data) as TSeismicMaterial).BeginWorksDate));
 ListItem:=lvSeisMaterialProperty.Items.Add;
 ListItem.Caption:='Дата окончания работ:';
ListShortLine(lvSeisMaterialProperty,ListItem,DateToStr((TObject(tvSeisMaterial.Selected.Data) as TSeismicMaterial).EndWorksDate));
 ListItem:=lvSeisMaterialProperty.Items.Add;
 ListItem.Caption:='Состав отчета:';
ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TSeismicMaterial).ReferenceComposition);
 ListItem:=lvSeisMaterialProperty.Items.Add;
 ListItem.Caption:='Масштаб работ:';
 ListShortLine(lvSeisMaterialProperty,ListItem,'1 : '+IntToStr((TObject(tvSeisMaterial.Selected.Data) as TSeismicMaterial).SeisWorkScale));
 ListItem:=lvSeisMaterialProperty.Items.Add;
 ListItem.Caption:='Структурная карта ОГ:';
ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TSeismicMaterial).StructMapReflectHorizon);
 ListItem:=lvSeisMaterialProperty.Items.Add;
 ListItem.Caption:='Разломы:';
 ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TSeismicMaterial).CrossSection);
 lvSeisMaterialProperty.Items.EndUpdate;
end
else
if TObject(tvSeisMaterial.Selected.Data) is TSeismicProfile then
begin
lvSeisMaterialProperty.Items.BeginUpdate;
lvSeisMaterialProperty.Column[0].Caption:='Сейсмический профиль';
ListItem:=lvSeisMaterialProperty.Items.Add;
ListItem.Caption:='№Сейсмопрофиля';
ListShortLine(lvSeisMaterialProperty,ListItem,IntToStr((TObject(tvSeisMaterial.Selected.Data) as TSeismicProfile).SeisProfileNumber));
ListItem:=lvSeisMaterialProperty.Items.Add;
ListItem.Caption:='Тип сейсмопрофиля';
ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TSeismicProfile).SeismicProfileType.Name);
ListItem:=lvSeisMaterialProperty.Items.Add;
ListItem.Caption:='Начальный пикет';
ListShortLine(lvSeisMaterialProperty,ListItem,IntToStr((TObject(tvSeisMaterial.Selected.Data) as TSeismicProfile).PiketBegin));
ListItem:=lvSeisMaterialProperty.Items.Add;
ListItem.Caption:='Конечный пикет';
ListShortLine(lvSeisMaterialProperty,ListItem,IntToStr((TObject(tvSeisMaterial.Selected.Data) as TSeismicProfile).PiketEnd));
ListItem:=lvSeisMaterialProperty.Items.Add;
ListItem.Caption:='Длина сейсмопрофиля';
ListShortLine(lvSeisMaterialProperty,ListItem,FloatToStr((TObject(tvSeisMaterial.Selected.Data) as TSeismicProfile).SeisProfileLenght));
ListItem:=lvSeisMaterialProperty.Items.Add;
ListItem.Caption:='Дата внесения сейсмопрофиля';
ListShortLine(lvSeisMaterialProperty,ListItem,DateToStr((TObject(tvSeisMaterial.Selected.Data) as TSeismicProfile).DateEntry));
ListItem:=lvSeisMaterialProperty.Items.Add;
ListItem.Caption:='Комментарий';
ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TSeismicProfile).SeisProfileComment);
ListItem:=lvSeisMaterialProperty.Items.Add;
ListItem.Caption:='Координаты сейсмопрофиля';
for i3:=0 to TMainFacade.GetInstance.AllSeismicProfileCoordinates.Count-1 do
if (TMainFacade.GetInstance.AllSeismicProfileCoordinates.Items[i3].SeismicProfile.ID=(TObject(tvSeisMaterial.Selected.Data) as TSeismicProfile).ID) then
ListShortLine(lvSeisMaterialProperty,ListItem,'№'+IntToStr(TMainFacade.GetInstance.AllSeismicProfileCoordinates.Items[i3].CoordNumber)+'  X: '+FloatToStr(TMainFacade.GetInstance.AllSeismicProfileCoordinates.Items[i3].CoordX)+'  Y: '+FloatToStr(TMainFacade.GetInstance.AllSeismicProfileCoordinates.Items[i3].CoordY));

lvSeisMaterialProperty.Items.EndUpdate;
end
else
if TObject(tvSeisMaterial.Selected.Data) is TExempleSeismicMaterial then
begin
lvSeisMaterialProperty.Items.BeginUpdate;
lvSeisMaterialProperty.Column[0].Caption:='Экземпляр отчета';
ListItem:=lvSeisMaterialProperty.Items.Add;
ListItem.Caption:='№Экземпляра';
ListShortLine(lvSeisMaterialProperty,ListItem,IntToStr((TObject(tvSeisMaterial.Selected.Data) as TExempleSeismicMaterial).ID));
ListItem:=lvSeisMaterialProperty.Items.Add;
ListItem.Caption:='Количество экземпляров';
ListShortLine(lvSeisMaterialProperty,ListItem,IntToStr((TObject(tvSeisMaterial.Selected.Data) as TExempleSeismicMaterial).ExempleSum));
ListItem:=lvSeisMaterialProperty.Items.Add;
ListItem.Caption:='Тип экземпляра';
ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TExempleSeismicMaterial).ExempleType.Name);
ListItem:=lvSeisMaterialProperty.Items.Add;
ListItem.Caption:='Местонахождение экземпляра';
ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TExempleSeismicMaterial).ExempleLocation.Name+' '+(TObject(tvSeisMaterial.Selected.Data) as TExempleSeismicMaterial).ExempleLocation.MaterialLocation.Name);
ListItem:=lvSeisMaterialProperty.Items.Add;
ListItem.Caption:='Комментарий';
ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TExempleSeismicMaterial).ExempleComment);
lvSeisMaterialProperty.Items.EndUpdate;
end
else
if TObject(tvSeisMaterial.Selected.Data) is TElementExemple then
begin
lvSeisMaterialProperty.Items.BeginUpdate;
lvSeisMaterialProperty.Column[0].Caption:='Элемент экземпляра';
ListItem:=lvSeisMaterialProperty.Items.Add;
ListItem.Caption:='Порядковый № элемента';
ListShortLine(lvSeisMaterialProperty,ListItem,IntToStr((TObject(tvSeisMaterial.Selected.Data) as TElementExemple).ElementNumber));
ListItem:=lvSeisMaterialProperty.Items.Add;
ListItem.Caption:='Тип элемента';
ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TElementExemple).ElementType.Name);
ListItem:=lvSeisMaterialProperty.Items.Add;
ListItem.Caption:='Комментарий';
ListShortLine(lvSeisMaterialProperty,ListItem,(TObject(tvSeisMaterial.Selected.Data) as TElementExemple).Comment);
lvSeisMaterialProperty.Items.EndUpdate;
end;
//lvSeisMaterialProperty.Items.EndUpdate;
end;



procedure TFrame2.actDrawItemListExecute(Sender: TObject);
begin
lvSeisMaterialProperty.Canvas.Brush.Color := clRed;
end;  }

procedure TFrame2.lvSeisMaterialPropertyCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
if Item.Data=nil then
TListView(Sender).Canvas.Brush.Color := clMoneyGreen
else
TListView(Sender).Canvas.Brush.Color := clCream;
end;





end.
