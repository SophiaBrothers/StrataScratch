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

--Also, there is no total invoice paid. Would have to add the 

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



-- use a window to find the best selling item for each month
SELECT ct.ProductID,
	   datepart('month' from OrderDate ) as Month
FROM
	(SELECT o.*,
			   oi.ProductID,
			   oi.ItemPrice,
			   oi.Quantity,
			   p.ProductName
		FROM Orders o
		INNER JOIN OrderItems oi ON o.OrderID = oi.OrderID
		LEFT JOIN Products p ON oi.ProductID = p.ProductID
		) as ct;


----------------------------------------------------------------------------------------------
use MyGuitarShop

SELECT DATEPART('month' from OrderDate) as Month
FROM Orders;


-- still getting an error.
