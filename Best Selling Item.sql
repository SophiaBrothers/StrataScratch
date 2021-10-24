----------------------------------------  Best Selling Item  ---------------------------------------------
/**

https://platform.stratascratch.com/coding/10172-best-selling-item?python=

Best Selling Item

Find the best selling item for each month (no need to separate months by year) where the biggest total invoice was paid.
The best selling item is calculated using the formula (unitprice * quantity). Output the description of the item along
with the amount paid.

**/

use MyGuitarShop;

GO
 

select * from Orders;  --41 rows
select * from OrderItems;  --47 rows
select top 2 * from Products

--approach
-- need to join orders table and orderItems table on orderID, then join the product table on productId

--columns needed: orderID, ProductID, itemprice, Qty, orderDate, productname

--*NOTE:The item id is not the same as the product id. The item id is just the primary key for the orderitem table

--Also, there is no total invoice paid. 

--first join the tables, using order as the master table

SELECT o.*,
	   oi.*,
	   p.ProductName
FROM Orders o
INNER JOIN OrderItems oi ON o.OrderID = oi.OrderID
LEFT JOIN Products p ON oi.ProductID = p.ProductID;



--the output of the left join and inner join are the same in this case


--CREATE A CTE
with complete_order as(                            --creating CTE 
	SELECT o.*,
		   oi.ProductID,
		   oi.ItemPrice,
		   oi.Quantity,
		   p.ProductName
	FROM Orders o
	INNER JOIN OrderItems oi ON o.OrderID = oi.OrderID
	LEFT JOIN Products p ON oi.ProductID = p.ProductID);



-- using CTE to find total item price for each order item
with complete_order as(                            
		SELECT o.*,
				oi.ProductID,
				oi.ItemPrice,
				oi.Quantity,
				p.ProductName
		FROM Orders o
		INNER JOIN OrderItems oi ON o.OrderID = oi.OrderID
		LEFT JOIN Products p ON oi.ProductID = p.ProductID)
SELECT OrderID,
	   ProductID,
	   ProductName,
	   ItemPrice,
	   Quantity,
	   abs(ItemPrice * Quantity) as total_price,
	   datename(month,OrderDate ) as Month
FROM complete_order;

	

----------------------------------------------------------------------------------------------

-- use a window to rank the items in each month by their total_price for 

with complete_order as(                            
			SELECT o.*,
					oi.ProductID,
					oi.ItemPrice,
					oi.Quantity,
					p.ProductName,
					abs(ItemPrice * Quantity) as total_price,
		            datename(month,OrderDate ) as Month
			FROM Orders o
			INNER JOIN OrderItems oi ON o.OrderID = oi.OrderID
			LEFT JOIN Products p ON oi.ProductID = p.ProductID)
SELECT ProductName,
	   Month,
	   total_price,
	   Rank() OVER (PARTITION BY Month ORDER BY total_price DESC) as rank
FROM complete_order;
 

-- some products have the same ranking within a month

-- add group by to get more accurate results

with complete_order as(                            
			SELECT o.*,
					oi.ProductID,
					oi.ItemPrice,
					oi.Quantity,
					p.ProductName,
					abs(ItemPrice * Quantity) as total_price,
		            datename(month,OrderDate ) as Month
			FROM Orders o
			INNER JOIN OrderItems oi ON o.OrderID = oi.OrderID
			LEFT JOIN Products p ON oi.ProductID = p.ProductID)
SELECT ProductName,
	   Month,
	   total_price,
	   Rank() OVER (PARTITION BY Month ORDER BY total_price DESC) as rank
FROM complete_order
GROUP BY ProductName, Month, total_price;

-- rankings now make more sense


-- NOW LET'S OUTPUT THE BEST SELLING ITEM FOR EACH MONTH

with complete_order as(                            
			SELECT o.*,
					oi.ProductID,
					oi.ItemPrice,
					oi.Quantity,
					p.ProductName,
					abs(ItemPrice * Quantity) as total_price,
		            datename(month,OrderDate ) as Month
			FROM Orders o
			INNER JOIN OrderItems oi ON o.OrderID = oi.OrderID
			LEFT JOIN Products p ON oi.ProductID = p.ProductID)
SELECT ProductName,
	   Month,
	   total_price,
	   Rank() OVER (PARTITION BY Month ORDER BY total_price DESC) as Ranking
FROM complete_order
WHERE Ranking = 1                 -- will get an error (Invalid column name)
GROUP BY ProductName, Month, total_price;



-- trying somthing else
with complete_order as(                            
			SELECT o.*,
					oi.ProductID,
					oi.ItemPrice,
					oi.Quantity,
					p.ProductName,
					abs(ItemPrice * Quantity) as total_price,
		            datename(month,OrderDate ) as Month
			FROM Orders o
			INNER JOIN OrderItems oi ON o.OrderID = oi.OrderID
			LEFT JOIN Products p ON oi.ProductID = p.ProductID)
SELECT ProductName,
	   Month,
	   total_price,
	   Rank() OVER (PARTITION BY Month ORDER BY total_price DESC) as Ranking
FROM complete_order
WHERE Rank() OVER (PARTITION BY Month ORDER BY total_price DESC) = 1      -- will also get an error (Windowed functions can only appear in the SELECT or ORDER BY clauses.)
GROUP BY ProductName, Month, total_price;


--see: https://sqltheater.com/blog/cant-use-row-number-where/



with complete_order as(                            
			SELECT o.*,
					oi.ProductID,
					oi.ItemPrice,
					oi.Quantity,
					p.ProductName,
					abs(ItemPrice * Quantity) as total_price,
		            datename(month,OrderDate ) as Month
			FROM Orders o
			INNER JOIN OrderItems oi ON o.OrderID = oi.OrderID
			LEFT JOIN Products p ON oi.ProductID = p.ProductID)
SELECT ProductName,
	   Month,
	   total_price,
	   CASE
	   WHEN Rank() OVER (PARTITION BY Month ORDER BY total_price DESC) = 1 then 1 ELSE NULL END as ranking
FROM complete_order
GROUP BY ProductName, Month, total_price 


--would prefer to omit records that do not have ranking of 1



-see https://learnsql.com/blog/using-case-data-modifying-statements/