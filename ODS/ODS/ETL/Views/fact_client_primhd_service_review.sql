
CREATE      view [ETL].[fact_client_primhd_service_review]

as

/**********************************************************************************************************
 View		[ETL].[fact_client_primhd_service_review]
 Author		Pankaj Bhatt
 Created	2026-04-14
 Purpose	Used to build the edw.fact_client_primhd_service_review table 

 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 2026-04-14		Pankaj Bhatt	Initial version
**************************************************************************************************************/

SELECT 
	1 AS dim_company_key
    ,fp.PrimhdServiceReviewId as primhd_service_review_id
    ,fp.PersonId as client_id
    ,fp.ReferralId as client_referral_id
    ,du.UserEmployeeNumber as created_by_employee_id
    ,du.UserEmailAddress as created_by_user_email_address
    ,fp.PrimhdServiceReviewReviewDate as review_date
    ,fp.PrimhdServiceReviewCreatedDate as created_date

    
    ,dpras.PRIMHDReviewAccommodationStatusValue as accommodation_status_value
    ,dpras.PRIMHDReviewAccommodationStatusText as accommodation_status_text
    ,dprasp.PRIMHDReviewAccommodationStatusValue as parent_accommodation_status_value
    ,dprasp.PRIMHDReviewAccommodationStatusText as parent_accommodation_status_text  
    
    ,dpres.PRIMHDReviewEducationStatusValue as education_status_value
    ,dpres.PRIMHDReviewEducationStatusText as education_status_text      
    ,dpres1.PRIMHDReviewEducationStatusValue as parent_education_status_value
    ,dpres1.PRIMHDReviewEducationStatusText as parent_education_status_text    
    
    ,dpremps.PRIMHDReviewEmploymentStatusValue as employment_status_value
    ,dpremps.PRIMHDReviewEmploymentStatusText as employment_status_text
    ,dpremps1.PRIMHDReviewEmploymentStatusValue as parent_employment_status_value
    ,dpremps1.PRIMHDReviewEmploymentStatusText as parent_employment_status_text

    ,dprwps.PRIMHDReviewWellnessPlanStatusValue as wellness_plan_status_value
    ,dprwps.PRIMHDReviewWellnessPlanStatusText as wellness_plan_status_text    
    ,dprwps1.PRIMHDReviewWellnessPlanStatusValue as parent_wellness_plan_status_value
    ,dprwps1.PRIMHDReviewWellnessPlanStatusText as parent_wellness_plan_status_text
       
FROM RBEAL.dlfactprimhdservicereview fp
left outer join RBEAL.dlDimPRIMHDReviewAccommodationStatus dpras on fp.AccommodationStatusId = dpras.PRIMHDReviewAccommodationStatusID
left outer join RBEAL.dlDimPRIMHDReviewAccommodationStatus dprasp on dpras.PRIMHDReviewAccommodationStatusParentId = dprasp.PRIMHDReviewAccommodationStatusID

left outer join RBEAL.dlDimPRIMHDReviewEducationStatus dpres on fp.EducationStatusId = dpres.PRIMHDReviewEducationStatusID
left outer join RBEAL.dlDimPRIMHDReviewEducationStatus dpres1 on dpres.PRIMHDReviewEducationStatusParentId = dpres1.PRIMHDReviewEducationStatusID

left outer join RBEAL.dlDimPRIMHDReviewEmploymentStatus dpremps on fp.EmploymentStatusId = dpremps.PRIMHDReviewEmploymentStatusID
left outer join RBEAL.dlDimPRIMHDReviewEmploymentStatus dpremps1 on dpremps.PRIMHDReviewEmploymentStatusParentId = dpremps1.PRIMHDReviewEmploymentStatusID

left outer join RBEAL.dlDimPRIMHDReviewWellnessPlanStatus dprwps on fp.WellnessPlanStatusId = dprwps.PRIMHDReviewWellnessPlanStatusID
left outer join RBEAL.dlDimPRIMHDReviewWellnessPlanStatus dprwps1 on dprwps.PRIMHDReviewWellnessPlanStatusParentId = dprwps1.PRIMHDReviewWellnessPlanStatusID

left outer join RBEAL.dlDimUser du on fp.PrimhdServiceReviewCreatedUserID = du.userid
union all
SELECT
DISTINCT -- Dev has duplicate records
	5 AS dim_company_key
    ,fp.PrimhdServiceReviewId as primhd_service_review_id
    ,fp.PersonId as client_id
    ,fp.ReferralId as client_referral_id
    ,du.UserEmployeeNumber as created_by_employee_id
    ,du.UserEmailAddress as created_by_user_email_address
    ,fp.PrimhdServiceReviewReviewDate as review_date
    ,fp.PrimhdServiceReviewCreatedDate as created_date

    
    ,dpras.PRIMHDReviewAccommodationStatusValue as accommodation_status_value
    ,dpras.PRIMHDReviewAccommodationStatusText as accommodation_status_text
    ,dprasp.PRIMHDReviewAccommodationStatusValue as parent_accommodation_status_value
    ,dprasp.PRIMHDReviewAccommodationStatusText as parent_accommodation_status_text  
    
    ,dpres.PRIMHDReviewEducationStatusValue as education_status_value
    ,dpres.PRIMHDReviewEducationStatusText as education_status_text      
    ,dpres1.PRIMHDReviewEducationStatusValue as parent_education_status_value
    ,dpres1.PRIMHDReviewEducationStatusText as parent_education_status_text    
    
    ,dpremps.PRIMHDReviewEmploymentStatusValue as employment_status_value
    ,dpremps.PRIMHDReviewEmploymentStatusText as employment_status_text
    ,dpremps1.PRIMHDReviewEmploymentStatusValue as parent_employment_status_value
    ,dpremps1.PRIMHDReviewEmploymentStatusText as parent_employment_status_text

    ,dprwps.PRIMHDReviewWellnessPlanStatusValue as wellness_plan_status_value
    ,dprwps.PRIMHDReviewWellnessPlanStatusText as wellness_plan_status_text    
    ,dprwps1.PRIMHDReviewWellnessPlanStatusValue as parent_wellness_plan_status_value
    ,dprwps1.PRIMHDReviewWellnessPlanStatusText as parent_wellness_plan_status_text
       
FROM RBMNB.dlfactprimhdservicereview fp
left outer join RBMNB.dlDimPRIMHDReviewAccommodationStatus dpras on fp.AccommodationStatusId = dpras.PRIMHDReviewAccommodationStatusID and dpras.PRIMHDReviewAccommodationStatusValue not like 'Run#%'
left outer join RBMNB.dlDimPRIMHDReviewAccommodationStatus dprasp on dpras.PRIMHDReviewAccommodationStatusParentId = dprasp.PRIMHDReviewAccommodationStatusID and dprasp.PRIMHDReviewAccommodationStatusValue not like 'Run#%'

left outer join RBMNB.dlDimPRIMHDReviewEducationStatus dpres on fp.EducationStatusId = dpres.PRIMHDReviewEducationStatusID
left outer join RBMNB.dlDimPRIMHDReviewEducationStatus dpres1 on dpres.PRIMHDReviewEducationStatusParentId = dpres1.PRIMHDReviewEducationStatusID

left outer join RBMNB.dlDimPRIMHDReviewEmploymentStatus dpremps on fp.EmploymentStatusId = dpremps.PRIMHDReviewEmploymentStatusID
left outer join RBMNB.dlDimPRIMHDReviewEmploymentStatus dpremps1 on dpremps.PRIMHDReviewEmploymentStatusParentId = dpremps1.PRIMHDReviewEmploymentStatusID

left outer join RBMNB.dlDimPRIMHDReviewWellnessPlanStatus dprwps on fp.WellnessPlanStatusId = dprwps.PRIMHDReviewWellnessPlanStatusID
left outer join RBMNB.dlDimPRIMHDReviewWellnessPlanStatus dprwps1 on dprwps.PRIMHDReviewWellnessPlanStatusParentId = dprwps1.PRIMHDReviewWellnessPlanStatusID

left outer join RBMNB.dlDimUser du on fp.PrimhdServiceReviewCreatedUserID = du.userid