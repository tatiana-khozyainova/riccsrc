CREATE TABLE tbl_Placement_Quality (
       Placement_Quality_ID  dmn_Smallint_Key,
       vch_Placement_Quality_Name dmn_Varchar_30
);


ALTER TABLE tbl_Placement_Quality
       ADD PRIMARY KEY (Placement_Quality_ID);


alter table tbl_Part_Placement_dict add Placement_Quality_ID  dmn_Smallint_Key;
ALTER TABLE tbl_Part_Placement_Dict
       ADD FOREIGN KEY (Placement_Quality_ID)
                             REFERENCES tbl_Placement_Quality;

insert into tbl_table_data_group (data_group_id, table_id) values (9, (select min(table_id) from tbl_table t where t.vch_table_name = 'TBL_PLACEMENT_QUALITY'));


INSERT INTO TBL_PLACEMENT_QUALITY (PLACEMENT_QUALITY_ID, VCH_PLACEMENT_QUALITY_NAME) VALUES (2, 'Плохое');

INSERT INTO TBL_PLACEMENT_QUALITY (PLACEMENT_QUALITY_ID, VCH_PLACEMENT_QUALITY_NAME) VALUES (3, 'Удовлетворительное');

INSERT INTO TBL_PLACEMENT_QUALITY (PLACEMENT_QUALITY_ID, VCH_PLACEMENT_QUALITY_NAME) VALUES (4, 'Хорошее');

INSERT INTO TBL_PLACEMENT_QUALITY (PLACEMENT_QUALITY_ID, VCH_PLACEMENT_QUALITY_NAME) VALUES (5, 'Отличное');
