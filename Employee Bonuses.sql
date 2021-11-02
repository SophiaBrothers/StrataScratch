----------------------------------  Employee Bonuses  -----------------------------------------------------
/**

**** WORK IN PROGRESS ****


see: https://platform.stratascratch.com/coding/10081-find-the-number-of-employees-who-received-the-bonus-and-who-didnt?python=

Find the number of employees who received the bonus and who didn't

Find the number of employees who received the bonus and who didn't.

Output an indication of whether the bonus was received or not along with the corresponding number of employees.
    ex: if the bonus was received: 1, if not: 0.

Tables: employee, bonus

**/


--using EmployeeDW to find out if those who are no longer employee were managers. and the corresponding count of how many
--were and how many were not.

--DESIRED OUTPUT
--  MANAGER       COUNT_OF_SEPERATION
--     0                  123546
--     1                  136844


use EmployeeDW

--STEP1 EXPLORE / UNDERSTAND
 
select * from FactEmployeeSeparation   -- 119,818 rows
select * from FactDepartmentEmployee   --(0 not manager/ 1 is manager)   663,254 rows
select * from DimTitle
select * from DimManager

--columns needed: 
-- FactEmployeeSeparation :  ManagerKey, EmployeeKey, SeperationCode
-- FactDepartmentEmployee :  EmployeeKey, ManagerFlag



-- STEP2 APPROACH
--join the two tables on employeekey
--      will use inner join as I only want matching records from both tables
--create a subquery out of the joined tables to pull the selected data
--create a cte out of the ouput 
-- use a window function

-- STEP3 CODE

SELECT *
FROM FactDepartmentEmployee e
INNER JOIN FactEmployeeSeparation s ON e.EmployeeKey = s.EmployeeKey

-- output shows that no one seperated was a manager

-- lets confirm with a left join
SELECT *
FROM FactDepartmentEmployee e
LEFT JOIN FactEmployeeSeparation s ON e.EmployeeKey = s.EmployeeKey


-- JOINING THE DimManger to FactEmployeeSeperation for further confirmation
SELECT *
FROM FactEmployeeSeparation s
LEFT JOIN DimManager m ON s.EmployeeKey = m.ManagerEmployeeNumber;

--apparently no manager has ever seperated 


--MOVING AHEAD 
SELECT *
FROM(
	 SELECT e.EmployeeKey,
			e.ManagerFlag,
			s.ManagerKey,
			s.SeparationCode
	 FROM FactDepartmentEmployee e
	 INNER JOIN FactEmployeeSeparation s ON e.EmployeeKey = s.EmployeeKey) ms;


--CREATING A CTE

with sep_manager as(
					SELECT *
					FROM(
						 SELECT e.EmployeeKey,
								e.ManagerFlag,
								s.ManagerKey,
								s.SeparationCode
						 FROM FactDepartmentEmployee e
						 INNER JOIN FactEmployeeSeparation s ON e.EmployeeKey = s.EmployeeKey) ms)
SELECT distinct ManagerFlag,
	            COUNT(EmployeeKey) OVER (PARTITON BY ManagerFlag) AS count_of_managers
FROM sep_manager;


--Above code returns an error. May need to rename the two items in the select statement

with sep_manager as(
					SELECT *
					FROM(
						 SELECT e.EmployeeKey as emp,
								e.ManagerFlag as man_flag,
								s.ManagerKey as man_key,
								s.SeparationCode as sep_code
						 FROM FactDepartmentEmployee e
						 INNER JOIN FactEmployeeSeparation s ON e.EmployeeKey = s.EmployeeKey) ms)
SELECT distinct man_flag,
	            COUNT(emp) OVER (PARTITON BY Man_flag) AS count_of_managers
FROM sep_manager;

-- above code still doesn't work 


--trying as subquery. currently results in error: multi-part identifier could not be bound
--when trying to add the second select item.

SELECT f.ManagerFlag
FROM (SELECT ms.*
	  FROM(
			SELECT e.EmployeeKey AS emp,
		    	   e.ManagerFlag as man_flag,
				   s.ManagerKey as mkey,
				   s.SeparationCode as scode
			FROM FactDepartmentEmployee e
			INNER JOIN FactEmployeeSeparation s ON e.EmployeeKey = s.EmployeeKey) ms) as f




--- WORKS BUT NEED A WAY TO REPRESENT 1 (IS MANAGERS)
SELECT distinct f.man_flag,
	   count(f.emp) OVER (PARTITION BY f.man_flag) as count_of_sep
FROM (SELECT ms.*
	  FROM(
			SELECT e.EmployeeKey AS emp,
		    	   e.ManagerFlag as man_flag,
				   s.ManagerKey as mkey,
				   s.SeparationCode as scode
			FROM FactDepartmentEmployee e
			INNER JOIN FactEmployeeSeparation s ON e.EmployeeKey = s.EmployeeKey) ms) as f


--perhaps changing that join to a left join
SELECT distinct f.man_flag,
	   count(f.emp) OVER (PARTITION BY f.man_flag) as count_of_sep
FROM (SELECT ms.*
	  FROM(
			SELECT e.EmployeeKey AS emp,
		    	   e.ManagerFlag as man_flag,
				   s.ManagerKey as mkey,
				   s.SeparationCode as scode
			FROM FactDepartmentEmployee e
			LEFT JOIN FactEmployeeSeparation s ON e.EmployeeKey = s.EmployeeKey) ms) as f
--looks like what i want but is inaccurate because it counts all the employee keys without regard to seperaton status



--filtering by sep status
SELECT distinct f.man_flag,
	   count(f.emp) OVER (PARTITION BY f.man_flag) as count_of_sep
FROM (SELECT ms.*
	  FROM(
			SELECT e.EmployeeKey AS emp,
		    	   e.ManagerFlag as man_flag,
				   s.ManagerKey as mkey,
				   s.SeparationCode as scode
			FROM FactDepartmentEmployee e
			LEFT JOIN FactEmployeeSeparation s ON e.EmployeeKey = s.EmployeeKey
			where SeparationCode = 'RES') ms) as f

--this does not work becuase it outpus the same result as the inner join


--Perhaps retry later using case when