----------------------------------- MOST PROFITABLE -------------------------------------------------
/**
SEE: https://platform.stratascratch.com/coding/9680-most-profitable-companies?python=

Most Profitable Companies

Find the 3 most profitable companies in the entire world.
Output the result along with the corresponding company name.
Sort the result based on profits in descending order.


**/
--TEST USING BIKESDB


-- EXPLORING
use BikesDB

select * from BusinessPartners   --40 rows

select distinct COMPANYNAME      --40 rows
from BusinessPartners

-- columns needed: partnerID, companyname,

select * from SalesOrders         --334 rows

--checking the math
select 
	(GROSSAMOUNT - NETAMOUNT) as tax_amt
from SalesOrders

-- columns needed: partnerID, grossamount


-- APPROACH
--left join BusinessPartners to salesOrder
--create a subquery
--rank company using a window function


SELECT COMPANYNAME as Company,
	   sum(GROSSAMOUNT) as Total_Gross,
	   DENSE_RANK() over(order by sum(GROSSAMOUNT) DESC) as company_rank
FROM (
	SELECT s.PARTNER_ID,
		   s.GROSSAMOUNT,
		   p.COMPANYNAME
	FROM SalesOrders s
	LEFT JOIN BusinessPartners p ON s.PARTNER_ID = p.PARTNER_ID ) as sub
GROUP BY COMPANYNAME