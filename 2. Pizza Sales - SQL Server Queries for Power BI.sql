

------------------------ Pizza Sales PROJECT DATA ANALYSIS - Using SQL Server for POWER BI Dashboard ---------------------------------
/* 
		Skills used are STANDARD SQL QUERIES, SUB-QUERY, JOINs, DATE FORMATTING, DATEPART
*/

USE pizza_sales;

-------------------------- KPIs - For Dashboard --------------------------------------------------------------------


---- 1) Total Revenue

SELECT 
		ROUND(SUM(price * quantity), 2) AS [Total Revenue]
FROM 
	order_details As o
	JOIN pizzas AS p
	ON o.pizza_id = p.pizza_id;


---- 2) Average Order Value
----	Which is -- total order value/order count

SELECT 
		ROUND(SUM(price * quantity)/ COUNT(DISTINCT order_id), 2) AS [Average Order Value]
FROM 
	order_details As o
	JOIN pizzas AS p
	ON o.pizza_id = p.pizza_id;


 ---- 3) Total Pizzas Sold

 SELECT SUM( quantity) AS [Total Pizza Sold]
 FROM order_details;


 ---- 4) Total Orders

 SELECT COUNT(DISTINCT order_id) AS [Total Orders]
 FROM order_details;


 ---- 5) Average Pizza sold per Order
 --- which is toatl of pizzas sold/number of pizzas

SELECT SUM(quantity)/COUNT(DISTINCT order_id) AS [Average Pizza Per Order]
FROM order_details;



------------------------ DATA FOR GRAPHS ------------------------------------------------------------------------------


---- 1) Daily Trends for Total Orders

SELECT 
		FORMAT( date, 'dddd') AS [Day of Week],
		COUNT(DISTINCT order_id) AS [Number of Orders]
FROM orders
GROUP BY FORMAT( date, 'dddd')
ORDER BY [Number of Orders] DESC;


---- 2) Hourly Trend for Total Orders

SELECT 
		DATEPART( HOUR, time) AS [Hour],
		COUNT(DISTINCT order_id) AS [Number of Orders]
FROM orders
GROUP BY DATEPART( HOUR, time)
ORDER BY [Hour] DESC;


---- 3) Percentage of Sales by Pizza Category
--		 a: total revenue per category
--		 b: % sales (a:/total revenue) * 100

SELECT 
		 category,
		 ROUND(SUM(price * quantity), 2) AS Revenue,
		 ROUND(SUM(price * quantity) * 100/(
										SELECT SUM(price * quantity)
										FROM pizzas AS p2
											JOIN order_details As o2
											ON   o2.pizza_id = p2.pizza_id
										), 2) AS [Percentage Sales]
FROM pizzas AS p
	JOIN pizza_types AS pt
	ON p.pizza_type_id = pt.pizza_type_id
	JOIN order_details As o
	ON   o.pizza_id = p.pizza_id
GROUP BY category
ORDER BY [Percentage Sales] DESC;



---- 4) Percentage of Sales by Pizza Size

SELECT 
		 size,
		 ROUND(SUM(price * quantity), 2) AS Revenue,
		 ROUND(SUM(price * quantity) * 100/(
										SELECT SUM(price * quantity)
										FROM pizzas AS p2
											JOIN order_details As o2
											ON   o2.pizza_id = p2.pizza_id
										), 2) AS [Percentage Sales]
FROM pizzas AS p
	JOIN pizza_types AS pt
	ON p.pizza_type_id = pt.pizza_type_id
	JOIN order_details As o
	ON   o.pizza_id = p.pizza_id
GROUP BY size
ORDER BY [Percentage Sales] DESC;


---- 5) Total Pizzas Sold by Pizza Category


SELECT category,
		SUM(quantity) AS [Qunatity Solds]
FROM pizzas AS p
	JOIN pizza_types AS pt
	ON p.pizza_type_id = pt.pizza_type_id
	JOIN order_details As o
	ON   o.pizza_id = p.pizza_id
GROUP BY category
ORDER BY [Qunatity Solds]DESC;


---- 6) Top 5 Best Sellers by Total Pizzas Sold

SELECT 
		TOP 5 name,
		SUM(quantity) AS [Qunatity Solds]
FROM pizzas AS p
	JOIN pizza_types AS pt
	ON p.pizza_type_id = pt.pizza_type_id
	JOIN order_details As o
	ON   o.pizza_id = p.pizza_id
GROUP BY name
ORDER BY [Qunatity Solds] DESC;



---- 7) Bottom 5 Worst Sellers by Total Pizzas Sold

SELECT 
		TOP 5 name,
		SUM(quantity) AS [Qunatity Solds]
FROM pizzas AS p
	JOIN pizza_types AS pt
	ON p.pizza_type_id = pt.pizza_type_id
	JOIN order_details As o
	ON   o.pizza_id = p.pizza_id
GROUP BY name
ORDER BY [Qunatity Solds] ASC;



---- 8) Orders by categories and dates

SELECT TOP 10
		category,
		p.size,
		pt.name,
		COUNT(DISTINCT o.order_id) as [TotalOrders],
		SUM(price * quantity) AS [Total Sales]
FROM pizzas AS p
	JOIN pizza_types AS pt 
	ON p.pizza_type_id = pt.pizza_type_id
	JOIN order_details AS od 
	ON od.pizza_id = p.pizza_id
	JOIN orders AS o 
	ON o.order_id = od.order_id
GROUP BY category,
			p.size, 
			pt.name
ORDER BY category ASC,[Total Sales] DESC;



---------------------------------------------- END -------------------------------------------------------------------
