USE [Project 5]
SELECT * FROM Health
--Changing 'M' and 'F' to 'Male' and 'Female'--
UPDATE Health
SET Gender=CASE WHEN Gender='M' THEN 'Male'
WHEN Gender ='F' THEN 'Female'
ELSE Gender END
--Country wise--
SELECT COUNT(*) AS Total,Country FROM Health
GROUP BY Country ORDER BY 1 DESC
--Year wise--
SELECT COUNT(*) AS Total,Year(Timestamp) AS Year FROM Health
GROUP BY Year(Timestamp)
--Gender wise--
SELECT COUNT(*) AS Total,Gender FROM Health
WHERE Gender IN('Female','Male')
GROUP BY Gender
--Family history of mental illness--
SELECT COUNT(*) AS Total,family_history,Gender FROM Health WHERE Gender IN ('Male','Female')
GROUP BY family_history,Gender
--Percentage of employees with and without family history of mental illness--
WITH FamilyCTE AS
(
SELECT SUM(CASE WHEN family_history='Yes' THEN 1 ELSE 0 END) AS Total_familyhistory,SUM(CASE WHEN family_history='No' THEN 1 ELSE 0 END) AS Total_No_family_history,COUNT(family_history) AS Total FROM Health 
)
SELECT (Total_familyhistory*100)/Total AS Percentage_with_family_history,(Total_No_family_history*100)/Total AS Percentage_with_No_family_history FROM FamilyCTE
--No: of employees Sought treatment for a mental health condition--
SELECT COUNT(*) AS Total,treatment FROM Health
GROUP BY treatment
--Employer primarily a tech company/organization--
SELECT COUNT(*) AS Total_emp_tech,tech_company FROM Health
GROUP BY tech_company
--Self-employed--
SELECT COUNT(*) AS Total_self_emp,self_employed FROM Health
GROUP BY self_employed
--Adding an Age group column--
ALTER TABLE Health
ADD Age_group VARCHAR(255)
UPDATE Health
SET Age_group= CASE WHEN Age BETWEEN 0 AND 20 THEN '0-20'
WHEN Age BETWEEN 21 AND 30 THEN '21-30'
WHEN Age BETWEEN 31 AND 40 THEN '31-40'
WHEN Age BETWEEN 41 AND 65 THEN '41-65'
WHEN Age BETWEEN 66 AND 100 THEN '66-100'
ELSE 'NULL' END
SELECT COUNT(*) AS Total,Age_group FROM Health 
GROUP BY Age_group ORDER BY 1 DESC
--Work remotely (outside of an office) at least 50% of the time--
SELECT COUNT(*) AS Total_remote_work_emp,remote_work FROM Health
GROUP BY remote_work

--Social stigma--

--No: of employees haveing a mental health condition leads to a feeling that it interferes with their work--
SELECT COUNT(*) AS Total,work_interfere FROM Health
GROUP BY work_interfere

--Percentage of employees having a mental health condition leads to a feeling that it interferes with their work--
WITH InterCTE AS
(
SELECT SUM(CASE WHEN work_interfere='Often' THEN 1 
WHEN work_interfere ='Sometimes' THEN 1
WHEN work_interfere='Rarely' THEN 1
ELSE 0 END) AS Total_Interference ,COUNT(work_interfere) AS Total FROM Health
)
SELECT (Total_Interference*100)/Total AS Percentage_with_interferance FROM InterCTE


--Employer provide mental health benefits--
SELECT COUNT(*) AS Total,benefits FROM Health
GROUP BY benefits
--Number of employees aware of the options for mental health care provide by the employer--
SELECT COUNT(*) AS Total,care_options FROM Health
GROUP BY care_options
--Discussing mental health as part of an employee wellness program by the employer--
SELECT COUNT(*) AS Total,wellness_program FROM Health
GROUP BY wellness_program
--Employer provide resources to learn more about mental health issues and how to seek help--
SELECT COUNT(*) AS Total,seek_help FROM Health
GROUP BY seek_help
--Medical leave for a mental health condition--
SELECT COUNT(*) AS Total,leave FROM Health
GROUP BY leave
--No: of employees thinking that discussing a mental health issue with their employer would have negative consequences--
SELECT COUNT(*) AS Total,mental_health_consequence FROM Health
GROUP BY mental_health_consequence
--Willingness to discuss a mental health issue with coworkers--
SELECT COUNT(*) AS Total,coworkers FROM Health
GROUP BY coworkers
-- Willingness to discuss a mental health issue with your direct supervisor--
SELECT COUNT(*) AS Total,supervisor FROM Health
GROUP BY supervisor
--Bring up a mental health issue with a potential employer in an interview--
SELECT COUNT(*) AS Total_mental_health_inter,mental_health_interview FROM Health
GROUP BY mental_health_interview
-- Bring up a physical health issue with a potential employer in an interview--
SELECT COUNT(*) AS Total_phys_health_inter,phys_health_interview FROM Health
GROUP BY phys_health_interview
--Feeling that employer takes mental health as seriously as physical health--
SELECT COUNT(*) AS Total,mental_vs_physical FROM Health
GROUP BY mental_vs_physical

--Removing Duplicates--
WITH RowCTE AS
(
SELECT *, ROW_NUMBER() OVER (PARTITION BY Timestamp,Age,Gender,family_history,work_interfere,tech_company ORDER BY Age,Gender,family_history,work_interfere,tech_company) AS Row_no FROM Health
)
SELECT * FROM RowCTE WHERE Row_no>1 
--Delete unused column--
ALTER TABLE Health
DROP COLUMN comments


