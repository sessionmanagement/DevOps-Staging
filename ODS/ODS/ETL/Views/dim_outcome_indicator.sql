
CREATE    view [ETL].[dim_outcome_indicator]

as

/**********************************************************************************************************
 View		[ETL].[dim_outcome_indicator]
 Author		Greg Nuthall
 Created	10-08-2026	
 Purpose	Used to build the edw.dim_outcome_indicator table 

 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 10-08-2026		Greg Nuthall	Initial version
**************************************************************************************************************/


SELECT i.[indicator_id] 
      ,i.[indicator] 
      ,i.[specific_outcome_id]
      ,i.[priority_outcome_id]
      ,i.[wellbeing_domain_id]
      ,po.[priority_outcome]
      ,so.[specific_outcome]
      ,CONCAT_WS(', ', so.relates_to, so.relates_to_2, so.relates_to_3, so.relates_to_4) AS relates_to_outcome
      ,wd.wellbeing_domain
      ,i.[data_type]
      ,replace(replace(i.[measure_type],char(10),''),char(13),'') as measure_type
      ,replace(replace(i.[indicator_description],char(10),''),char(13),'') as indicator_description
      ,replace(replace(i.[indicator_definition_status],char(10),''),char(13),'') as indicator_definition_status
      ,replace(replace(i.[relates_to],char(10),''),char(13),'') as [relates_to]
      ,replace(replace(i.[measure_logic],char(10),''),char(13),'') as [measure_logic]
      ,i.[enrolled_teams_or_services]
      ,i.[enrolled_sub_programme_id]
      ,replace(replace(i.[enrolled_sub_programme_value],char(10),''),char(13),'') as [enrolled_sub_programme_value]
      ,replace(replace(i.[considerations],char(10),''),char(13),'') as [considerations]
      ,replace(replace(i.[delivery_phasing],char(10),''),char(13),'') as [delivery_phasing]
      ,replace(replace(i.[datasource_1],char(10),''),char(13),'') as [datasource_1]
      ,replace(replace(i.[datasource_2],char(10),''),char(13),'') as [datasource_2]
      ,replace(replace(i.[datasource_3],char(10),''),char(13),'') as [datasource_3]
      ,i.[leading_sign]
      ,i.[trailing_sign]
      ,i.[rounding_dp]
      ,replace(replace(i.[description_positive],char(10),''),char(13),'') as [description_positive] 
      ,replace(replace(i.[qualifier_text],char(10),''),char(13),'') as [qualifier_text]
      ,replace(replace(i.[qualifier_text_part2],char(10),''),char(13),'') as [qualifier_text_part2]
      ,replace(replace(i.[qualifier_number_logic],char(10),''),char(13),'') as [qualifier_number_logic]
      ,replace(replace(i.[example_of_this_reported],char(10),''),char(13),'') as [example_of_this_reported] 
      ,replace(replace(i.[include_in_macroview],char(10),''),char(13),'') as [include_in_macroview]
      
  FROM [Outcome].[indicator] i
  left outer join outcome.priority_outcome po on i.priority_outcome_id = po.priority_outcome_id
  left outer join outcome.specific_outcome so on i.specific_outcome_id = so.specific_outcome_id
  left outer join outcome.wellbeing_domain wd on i.wellbeing_domain_id = wd.wellbeing_domain_id