-------------------------------------  Finding User Purchases  -------------------------------------------------------
/**

From StrataScratch

https://platform.stratascratch.com/coding/10322-finding-user-purchases?python=


Finding User Purchases

Write a query that'll identify returning active users. A returning active user is a user that has made a second purchase
within 7 days of any other of their purchases. Output a list of user_ids of these returning active users.


3-STEP APPROACH
	1. UNDERSTAND / EXPLORE THE DATA
	2. FORULATE YOU APPROACH 
		-write out step by step how you are going to solve the problem
	3. WRITE OUT THE CODE STEP BY STEP

**/


-- Columns needed:  user_id, created_at

-- required output: user_id

-------------------------------------------------------------------------------------------------------------------------

-- trying on my Guitarshop
use MyGuitarShop;
go


-- VERY BASIC
SELECT CustomerID,
	   OrderDate
FROM Orders


-- using a Window to identify the date of first purchase for each user
SELECT *,
       min(OrderDate) over (partition by CustomerID) as first_purchase
FROM Orders



-- Counting the number of orders for each customer with more than 1 purchase
select  CustomerID,
		count(OrderID) as order_count
from    Orders
group by
        CustomerID
having  count(OrderID) > 1


--testing above query
Select CustomerID,
	   count(orderID) as order_count
from Orders
where CustomerID = '8'
group by CustomerID


----------------------------------------------------------------------------






