
--DAwSQL Session -8 

--E-Commerce Project Solution
--E-Ticaret Projesi Çözümü


--1. Join all the tables and create a new table called combined_table. (market_fact, cust_dimen, orders_dimen, prod_dimen, shipping_dimen)


select A.*,
			B.Customer_Name,B.Customer_Segment,B.Province,B.Region,
			C.Order_Date,C.Order_Priority,
			D.Product_Category,D.Product_Sub_Category,
			E.Order_ID,E.Ship_Date,E.Ship_Mode
	into  [combined_table]
    from     dbo.market_fact A, dbo.cust_dimen B,dbo.orders_dimen C , dbo.prod_dimen D,dbo.shipping_dimen E  
    where A.Cust_id=B.Cust_id 
          and A.Ord_id=C.Ord_id
          AND A.Prod_id=D.Prod_id
          AND A.Ship_id=E.Ship_id
		
select * from combined_table
order by Ord_id

select *
from market_fact
--///////////////////////


--2. Find the top 3 customers who have the maximum count of orders.


SELECT TOP 3 cust_id, Customer_Name, COUNT (DISTINCT Ord_id) AS max_or_quantityFROM combined_tableGROUP BY Cust_id, Customer_NameORDER BY 3 DESC;



--/////////////////////////////////


--3.Create a new column at combined_table as DaysTakenForDelivery that contains the date difference of Order_Date and Ship_Date.
--Use "ALTER TABLE", "UPDATE" etc.

ALTER TABLE combined_table ADD DaysTakenForDelivery VARCHAR(50);

UPDATE combined_table SET DaysTakenForDelivery = DATEDIFF(Day, Order_Date, Ship_Date);

SELECT	distinct Cust_id, Order_Date, Ship_Date, DaysTakenForDeliveryFROM	combined_table

SELECT *
FROM combined_table

--////////////////////////////////////


--4. Find the customer whose order took the maximum time to get delivered.
--Use "MAX" or "TOP"


SELECT top 1 Cust_id,Customer_Name, DaysTakenForDelivery
FROM combined_table
ORDER BY DaysTakenForDelivery DESC


--////////////////////////////////


--5. Count the total number of unique customers in January and how many of 
--them came back every month over the entire year in 2011
--You can use date functions and subqueries


-- Count the total number of unique customers in January SELECT	COUNT(distinct Cust_id) as unique_customer_January_2011 FROM	combined_tableWHERE	MONTH(Order_Date ) = 1 and YEAR(order_date ) = 2011    --returns 99-- how many of them came back every month over the entire year in 2011SELECT	DATENAME(Month,order_date) as months_name,		MONTH(order_date) as months_number, 		COUNT(distinct Cust_id) as come_back_customers FROM	combined_tableWHERE	Cust_id in (					SELECT distinct Cust_id 					FROM combined_table					WHERE MONTH(Order_Date) = 1 and YEAR(order_date ) = 2011					)		AND YEAR(order_date ) = 2011GROUP BY DATENAME(Month,order_date), MONTH(order_date)

--////////////////////////////////////////////


--6. write a query to return for each user acording to the time elapsed between the first purchasing and the third purchasing, 
--in ascending order by Customer ID
--Use "MIN" with Window Functions


CREATE VIEW first_purchasing AS(SELECT * FROM (				SELECT	Cust_id, Customer_Name, Order_Date, 						ROW_NUMBER() OVER(partition by Customer_Name order by Order_Date)  [Row_Num1]				FROM combined_table) FWHERE F.Row_Num1 = 1);CREATE VIEW third_purchasing AS(SELECT * FROM (				SELECT Cust_id, Customer_Name, Order_Date, 						ROW_NUMBER() OVER(partition by Customer_Name order by Order_Date) [Row_Num3]				FROM combined_table) FWHERE F.Row_Num3 = 3);SELECT	B.Cust_id, B.Customer_Name, 		DATEDIFF(D, A.Order_Date, B.Order_Date) as Time_ElapsedFROM	first_purchasing A, third_purchasing BWHERE	A.Cust_id = B.Cust_idORDER BY B.Cust_id



--//////////////////////////////////////

--7. Write a query that returns customers who purchased both product 11 and product 14, 
--as well as the ratio of these products to the total number of products purchased by all customers.
--Use CASE Expression, CTE, CAST and/or Aggregate Functions

--customers who purchased both product 11 and product 14 SELECT	Cust_id, Customer_NameFROM	combined_tableWHERE	Prod_id = 11  --returns 361 rowsintersectSELECT	cust_id,Customer_NameFROM	combined_tableWHERE	Prod_id = 14     --returns 87 rows-- returns 19 rows

-- product count of the customers who purchased both product 11 and product 14 WITH yaz AS (	SELECT	Cust_id, Customer_Name, COUNT(Order_ID) as number_of_orders	FROM	combined_table	WHERE	Cust_id in (					SELECT	distinct cust_id					FROM	combined_table					WHERE	Prod_id = 11					intersect					SELECT	distinct Cust_id					FROM	combined_table					WHERE	Prod_id = 14)	GROUP BY Cust_id, Customer_Name)SELECT SUM(number_of_orders) FROM yaz

WITH T1 AS (SELECT	cust_id,		SUM(CASE WHEN Prod_id=11 THEN order_quantity else 0 end ) as p11,		SUM(CASE WHEN Prod_id=14 THEN order_quantity else 0 end ) as p14,		SUM(order_quantity) Total_ProductFROM	combined_tableGROUP BY cust_idHAVING	SUM(CASE WHEN Prod_id=11 THEN order_quantity else 0 end ) >=1  AND		SUM(CASE WHEN Prod_id=14 THEN order_quantity else 0 end ) >=1)

SELECT		cust_id,		p11,		p14,		Total_Product,		cast (1.0*p11/Total_Product as numeric(3,2)) AS Ratio_P11,		cast (1.0*p14/Total_Product as numeric(3,2)) AS Ratio_P14FROM T1




--/////////////////

--CUSTOMER SEGMENTATION



--1. Create a view that keeps visit logs of customers on a monthly basis. (For each log, three field is kept: Cust_id, Year, Month)
--Use such date functions. Don't forget to call up columns you might need later.

CREATE VIEW logs_customer AS (	SELECT	Cust_id, 			YEAR(Order_Date) as [Year], 			MONTH(Order_Date) as [Month]	FROM	combined_table);

--//////////////////////////////////



  --2.Create a “view” that keeps the number of monthly visits by users. (Show separately all months from the beginning  business)
--Don't forget to call up columns you might need later.

CREATE VIEW numberOf_monthlyVisits AS(	SELECT	Cust_id, [Year], [Month], COUNT(*) as Total	FROM	logs_customer	GROUP BY Cust_id, [Year], [Month])



--//////////////////////////////////


--3. For each visit of customers, create the next month of the visit as a separate column.
--You can order the months using "DENSE_RANK" function.
--then create a new column for each month showing the next month using the order you have made above. (use "LEAD" function.)
--Don't forget to call up columns you might need later.

CREATE VIEW Next_Visit ASSELECT *,		LEAD (Month_Order) OVER (PARTITION BY cust_id ORDER BY Month_Order) Next_VisitFROM (		SELECT	*,		DENSE_RANK() over (ORDER BY [YEAR],[MONTH]) AS Month_Order		FROM numberOf_monthlyVisits	 ) A

SELECT *FROM Next_Visit;


--/////////////////////////////////



--4. Calculate monthly time gap between two consecutive visits by each customer.
--Don't forget to call up columns you might need later.

CREATE VIEW time_gaps AS(select	*,		Next_Visit - Month_Order as Time_Gapfrom	Next_Visit);

SELECT * FROM time_gaps;





--///////////////////////////////////


--5.Categorise customers using average time gaps. Choose the most fitted labeling model for you.
--For example: 
--Labeled as “churn” if the customer hasn't made another purchase for the months since they made their first purchase.
--Labeled as “regular” if the customer has made a purchase every month.
--Etc.
	
select	cust_id, avg_time_gap,		CASE WHEN avg_time_gap = 1 THEN 'regular'		WHEN avg_time_gap > 1 THEN 'irregular'		WHEN avg_time_gap IS NULL THEN 'churn'		ELSE 'unknown' END Cust_Labelingfrom	(		SELECT Cust_id, AVG(Time_Gap) avg_time_gap		FROM	time_gaps		GROUP BY Cust_id			) Aorder by 1;







--/////////////////////////////////////




--MONTH-WISE RETENTÝON RATE


--Find month-by-month customer retention rate  since the start of the business.


--1. Find the number of customers retained month-wise. (You can use time gaps)
--Use Time Gaps

SELECT DISTINCT [Year],[Month],		Next_Visit AS Retention_Month,		COUNT (Cust_id) OVER (PARTITION BY Next_Visit) AS Retention_Sum_Monthly FROM time_gaps WHERE Time_Gap = 1






--//////////////////////


--2. Calculate the month-wise retention rate.

--Basic formula: o	Month-Wise Retention Rate = 1.0 * Number of Customers Retained in The Current Month / Total Number of Customers in the Current Month

--It is easier to divide the operations into parts rather than in a single ad-hoc query. It is recommended to use View. 
--You can also use CTE or Subquery if you want.

--You should pay attention to the join type and join columns between your views or tables.

SELECT	DISTINCT cust_id, [YEAR],		[MONTH],		Month_Order,		Next_Visit,		COUNT (cust_id)	OVER (PARTITION BY Next_Visit) Month_Wise_RetentionFROM	time_gapsWHERE	time_gap = 1AND		Month_Order > 1







---///////////////////////////////////
--Good luck!