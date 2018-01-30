ALTER TABLE TBL_WELL_DINAMICS ADD NUM_IS_PROJECT DMN_SMALLINT_FIELD DEFAULT 0 NOT NULL;
ALTER TABLE TBL_WELL ADD NUM_IS_PROJECT DMN_SMALLINT_FIELD DEFAULT 0 NOT NULL;

CREATE OR ALTER trigger trg_aft_ins_well_dinamics for tbl_well_dinamics
active after insert position 0
AS
begin
  if (not exists(select * from tbl_well w where new.Well_UIN = w.well_uin)) then
  begin
    INSERT INTO tbl_Well (Well_UIN, Well_Category_Id, Area_Id, Well_State_Id, num_Target_Depth,
                          dtm_Construction_Started, dtm_Construction_Finished, vch_Well_Num,
                          vch_Passport_Num, Profile_Id, dtm_Drilling_Start, dtm_Drilling_Finish,
                          num_True_Depth, num_Rotor_Altitude, vch_Well_Productivity,
                          num_Target_Cost, num_True_Cost, Target_Straton_ID, True_Straton_ID,
                          dtm_Entering_Date, Target_Fluid_Type_ID, True_Fluid_Type_ID, vch_Well_Name, num_Is_Project)
    VALUES (New.well_uin,New.Well_Category_ID, New.Area_Id, New.Well_State_Id, New.num_Target_Depth,
            New.dtm_Construction_Started, New.dtm_Construction_Finished, New.vch_Well_Num,
            New.vch_Passport_Num, New.Profile_Id, New.dtm_Drilling_Start, New.dtm_Drilling_Finish,
            New.num_True_Depth, New.num_Rotor_Altitude, New.vch_Well_Productivity,
            New.num_Target_Cost, New.num_True_Cost, null, null,
            New.dtm_Entering_Date, New.Target_Fluid_Type_ID, New.True_Fluid_Type_ID, New.vch_Well_Name, new.num_is_project);
  end
  else
  begin
    update tbl_well v
    set Well_Category_ID = New.Well_Category_ID,
        Area_Id = New.Area_Id,
        Well_State_Id = New.Well_State_Id,
        num_Target_Depth = New.num_Target_Depth,
        dtm_Construction_Started = New.dtm_Construction_Started,
        dtm_Construction_Finished = New.dtm_Construction_Finished,
        vch_Well_Num = New.vch_Well_Num,
        vch_Passport_Num = New.vch_Passport_Num,
        Profile_Id = New.Profile_Id,
        dtm_Drilling_Start = New.dtm_Drilling_Start,
        dtm_Drilling_Finish = New.dtm_Drilling_Finish,
        num_True_Depth = New.num_True_Depth,
        num_Rotor_Altitude = New.num_Rotor_Altitude,
        vch_Well_Productivity = New.vch_Well_Productivity,
        num_Target_Cost = New.num_Target_Cost,
        num_True_Cost = New.num_True_Cost,
        Target_Straton_ID = new.target_straton_id,
        True_Straton_ID = new.true_straton_id,
        dtm_Entering_Date = New.dtm_Entering_Date,
        Target_Fluid_Type_ID = New.Target_Fluid_Type_ID,
        True_Fluid_Type_ID = New.True_Fluid_Type_ID,
        vch_Well_Name = New.vch_Well_Name,
        num_is_project = new.num_is_project
    where v.well_uin = new.well_uin;
  end
end;

CREATE OR ALTER trigger trg_aft_upd_well_dinamics for tbl_well_dinamics
active after update position 0
AS
begin
  update tbl_well v
  set Well_Category_ID = New.Well_Category_ID,
      Area_Id = New.Area_Id,
      Well_State_Id = New.Well_State_Id,
      num_Target_Depth = New.num_Target_Depth,
      dtm_Construction_Started = New.dtm_Construction_Started,
      dtm_Construction_Finished = New.dtm_Construction_Finished,
      vch_Well_Num = New.vch_Well_Num,
      vch_Passport_Num = New.vch_Passport_Num,
      Profile_Id = New.Profile_Id,
      dtm_Drilling_Start = New.dtm_Drilling_Start,
      dtm_Drilling_Finish = New.dtm_Drilling_Finish,
      num_True_Depth = New.num_True_Depth,
      num_Rotor_Altitude = New.num_Rotor_Altitude,
      vch_Well_Productivity = New.vch_Well_Productivity,
      num_Target_Cost = New.num_Target_Cost,
      num_True_Cost = New.num_True_Cost,
      Target_Straton_ID = new.target_straton_id,
      True_Straton_ID = new.true_straton_id,
      dtm_Entering_Date = New.dtm_Entering_Date,
      Target_Fluid_Type_ID = New.Target_Fluid_Type_ID,
      True_Fluid_Type_ID = New.True_Fluid_Type_ID,
      vch_Well_Name = New.vch_Well_Name,
      num_Is_Project = new.num_is_project
  where v.well_uin = new.well_uin;
end;