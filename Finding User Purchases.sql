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
-- if you add up the orders in this table that equals 11



--testing above query
Select CustomerID,
	   count(orderID) as order_count
from Orders
where CustomerID = '8'
group by CustomerID


----------------------------------------------------------------------------



SELECT *
FROM Orders
where CustomerID in 
		(select CustomerID,
				 count(OrderID) as order_count
		from Orders
		group by CustomerID
		having count(OrderID) > 1) 


-- this returns 11 records of customers with more than 1 order
SELECT o.*
FROM Orders o
inner join 
		(select CustomerID,
				 count(OrderID) as order_count
		from Orders
		group by CustomerID
		having count(OrderID) > 1) m
on o.CustomerID = m.CustomerID


-- adding first purchase date column
SELECT o.*,
        min(OrderDate) over (partition by o.CustomerID) as first_purchase
FROM Orders o
inner join 
		(select CustomerID,
				 count(OrderID) as order_count
		from Orders
		group by CustomerID
		having count(OrderID) > 1) m
on o.CustomerID = m.CustomerID



-- create a new column called 'Days_between_purchase'
SELECT fp.CustomerID,
	   fp.OrderDate,
	   fp.first_purchase,
	   ABS(DATEDIFF(DAY, OrderDate, first_purchase)) AS Days_between_purchase      --use ABS to remove neg signs and get the absolute value
FROM 
	(SELECT o.*,
			min(OrderDate) over (partition by o.CustomerID) as first_purchase
	 FROM Orders o
	 inner join 
			(select CustomerID,
					 count(OrderID) as order_count
			from Orders
			group by CustomerID
			having count(OrderID) > 1) m
	 on o.CustomerID = m.CustomerID) fp

--at a glance, there are 3 customers who have made purchases within 7 days of first purcahse



-- FINAL SOLUTION:

-- lets filter out day 0 ( because 0 would be the first purchase) and days greater than 7 
SELECT fp.CustomerID,
	   fp.first_purchase,
	   fp.OrderDate AS second_purchase,           --reordered columns and renamed this column
	   ABS(DATEDIFF(DAY, OrderDate, first_purchase)) AS Days_between_purchase      
FROM 
	(SELECT o.*,
			min(OrderDate) over (partition by o.CustomerID) as first_purchase
	 FROM Orders o
	 inner join 
			(select CustomerID,
					 count(OrderID) as order_count
			from Orders
			group by CustomerID
			having count(OrderID) > 1) m
	 on o.CustomerID = m.CustomerID) fp
WHERE ABS(DATEDIFF(DAY, OrderDate, first_purchase)) BETWEEN 1 AND 7;  -- have to use between 1 & 7 to exclude the first purchase

