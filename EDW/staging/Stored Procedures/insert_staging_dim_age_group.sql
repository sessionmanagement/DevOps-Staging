


                    
CREATE procedure [staging].[insert_staging_dim_age_group]
as begin 
 set nocount on;
 set xact_abort on;
 TRUNCATE TABLE [staging].[dim_age_group]
   insert into [staging].[dim_age_group]
   (
      [age_in_years]
      ,[age_group_tangatawhaiora]
      ,[age_5_Year_Groups]
      ,[age_decade_Group]
      ,[age_Group_Broad]
      ,[age_Group_MoH_Covid]
      ,[age_group_groupings]
   )
 SELECT [age_in_years]
      ,[age_group_tangatawhaiora]
      ,[age_5_Year_Groups]
      ,[age_decade_Group]
      ,[age_Group_Broad]
      ,[age_Group_MoH_Covid]
      ,[age_group_groupings]
  FROM [landing].[dim_age_group]
   ;
  end