
--E-Commerce Project Solution


update prod_dimen
set Prod_id=replace(Prod_id,'Prod_','') 
where Prod_id is not null
​
update cust_dimen
set  cust_id=replace(cust_id,'Cust_','') 
where cust_id is not null
​

update market_fact
set  cust_id=replace(cust_id,'Cust_',''), 
	Prod_id=replace(Prod_id,'Prod_','') ,
	Ord_id=replace(Ord_id,'Ord_','') ,
	Ship_id=replace(Ship_id,'SHP_','') 
where cust_id is not null Prod_id is not null Ord_id is not null Ship_id  is not null
​
​
update orders_dimen
set  Ord_id=replace(Ord_id,'Ord_','') 
where Ord_id is not null
​
update shipping_dimen
set  Ship_id=replace(Ship_id,'SHP_','') 
where Ship_id is not null
​
​
--1. Join all the tables and create a new table called combined_table. (market_fact, cust_dimen, orders_dimen, prod_dimen, shipping_dimen)


select A.*, B.Customer_Name,B.Customer_Segment,B.Province,B.Region,
			C.Order_Date,C.Order_Priority,
			D.Product_Category,D.Product_Sub_Category,
			E.Order_ID,E.Ship_Date,E.Ship_Mode
into combined_table
from dbo.market_fact A, dbo.cust_dimen B,dbo.orders_dimen C , dbo.prod_dimen D,dbo.shipping_dimen E  
where A.Cust_id=B.Cust_id and
      A.Ord_id=C.Ord_id   and 
      A.Prod_id=D.Prod_id and
      A.Ship_id=E.Ship_id
		
select * 
from combined_table
order by Ord_id


--///////////////////////


--2. Find the top 3 customers who have the maximum count of orders.


select top 3 cust_id, Customer_Name, count(distinct Ord_id) as max_or_quantityfrom combined_tablegroup by Cust_id, Customer_Nameorder by 3 desc;



--/////////////////////////////////


--3.Create a new column at combined_table as DaysTakenForDelivery that contains the date difference of Order_Date and Ship_Date.
--Use "ALTER TABLE", "UPDATE" etc.

alter table combined_table add DaysTakenForDelivery varchar(50);

update combined_table set DaysTakenForDelivery = datediff(day, Order_Date, Ship_Date);

select	distinct Cust_id, Order_Date, Ship_Date, DaysTakenForDeliveryfrom combined_table

select *
from combined_table

--////////////////////////////////////


--4. Find the customer whose order took the maximum time to get delivered.
--Use "MAX" or "TOP"


select top 1 Cust_id,Customer_Name, DaysTakenForDelivery
from combined_table
order by DaysTakenForDelivery desc


--////////////////////////////////


--5. Count the total number of unique customers in January and how many of 
--them came back every month over the entire year in 2011
--You can use date functions and subqueries


select	count(distinct Cust_id) as unique_customer_January_2011 from	combined_tablewhere	month(Order_Date ) = 1 and year(order_date ) = 2011    select	datename(month,order_date) as months_name,		month(order_date) as months_number, 		count(distinct Cust_id) as come_back_customers from	combined_tablewhere	Cust_id in (					select distinct Cust_id 					from combined_table					where month(Order_Date) = 1 and year(order_date ) = 2011					)		and year(order_date ) = 2011group by datename(month,order_date), month(order_date)

--////////////////////////////////////////////


--6. write a query to return for each user acording to the time elapsed between the first purchasing and the third purchasing, 
--in ascending order by Customer ID
--Use "MIN" with Window Functions


create view purchase_one asselect *  from  (		select	Cust_id, Customer_Name, Order_Date, 				row_number() over(partition by Customer_Name order by Order_Date) row_num1		from combined_table		) awhere a.row_num1 = 1;create view purchase_three asselect *  from   (		 select Cust_id, Customer_Name, Order_Date, 				row_number() over(partition by Customer_Name order by Order_Date) row_num3		 from combined_table		 ) awhere a.row_num3 = 3;select b.Cust_id, b.Customer_Name, 		datediff(d, a.Order_Date, b.Order_Date) as Time_Elapsedfrom	purchase_one a, purchase_three bwhere	a.Cust_id = b.Cust_idorder by b.Cust_id

--//////////////////////////////////////

--7. Write a query that returns customers who purchased both product 11 and product 14, 
--as well as the ratio of these products to the total number of products purchased by all customers.
--Use CASE Expression, CTE, CAST and/or Aggregate Functions

  select Cust_id, Customer_Name  from combined_table  where	Prod_id = 11 intersect  select cust_id,Customer_Name  from combined_table  where	Prod_id = 14   

with aa as (select	Cust_id, Customer_Name, count(Order_ID) as number_of_ordersfrom	combined_tablewhere	Cust_id in (					  select	distinct cust_id					  from	combined_table					  where	Prod_id = 11					intersect					  select	distinct Cust_id					  from	combined_table					  where	Prod_id = 14					)group by Cust_id, Customer_Name			)select SUM(number_of_orders)
from aa

with bb as (select	cust_id,		sum(case when Prod_id=11 then order_quantity else 0 end ) as p11,		sum(case when Prod_id=14 then order_quantity else 0 end ) as p14,		sum(order_quantity) total_productfrom	combined_tablegroup by cust_idhaving	sum(case when Prod_id=11 then order_quantity else 0 end ) >=1  and		sum(case when Prod_id=14 then order_quantity else 0 end ) >=1			)

select cust_id, p11, p14, total_product,	   cast (1.0*p11/Total_Product as numeric(3,2)) AS ratio_11,	   cast (1.0*p14/Total_Product as numeric(3,2)) AS ratio_14FROM bb


--/////////////////

--CUSTOMER SEGMENTATION

--1. Create a view that keeps visit logs of customers on a monthly basis. (For each log, three field is kept: Cust_id, Year, Month)
--Use such date functions. Don't forget to call up columns you might need later.

create view visit_log as select	Cust_id, 			year(Order_Date) as [Year], 			month(Order_Date) as [Month]from combined_table

select *
from visit_log

--//////////////////////////////////


  --2.Create a “view” that keeps the number of monthly visits by users. (Show separately all months from the beginning  business)
--Don't forget to call up columns you might need later.

create view monthly_visits asselect Cust_id, [Year], [Month], count(*) as Cumulativefrom visit_loggroup by Cust_id, [Year], [Month]

select *
from monthly_visits

--//////////////////////////////////


--3. For each visit of customers, create the next month of the visit as a separate column.
--You can order the months using "DENSE_RANK" function.
--then create a new column for each month showing the next month using the order you have made above. (use "LEAD" function.)
--Don't forget to call up columns you might need later.

create view next_visit asselect *,		lead (month_order) over (partition by cust_id order by month_order) next_visitfrom	(		select	*,		dense_rank() over (order by [Year],[Month]) as month_order		FROM monthly_visits		) a
SELECT *FROM next_visit;


--/////////////////////////////////


--4. Calculate monthly time gap between two consecutive visits by each customer.
--Don't forget to call up columns you might need later.

create view gap asselect	*,		next_visit - month_order as gapfrom	next_visit

select * from gap

--///////////////////////////////////


--5.Categorise customers using average time gaps. Choose the most fitted labeling model for you.
--For example: 
--Labeled as “churn” if the customer hasn't made another purchase for the months since they made their first purchase.
--Labeled as “regular” if the customer has made a purchase every month.
--Etc.
	
select	cust_id, avg_gap,		case when avg_gap = 1 then 'regular'		when avg_gap > 1 then 'irregular'		when avg_gap IS NULL then 'churn'		else 'unknown' end custfrom	(		select Cust_id, avg(gap) avg_gap		from gap		group by Cust_id			) aorder by 1;

--/////////////////////////////////////

--MONTH-WISE RETENTÝON RATE


--Find month-by-month customer retention rate  since the start of the business.


--1. Find the number of customers retained month-wise. (You can use time gaps)
--Use Time Gaps

select distinct [Year],[Month],		next_visit as retention_month,		count (Cust_id) over (partition by next_visit) as monthly_retention_sumfrom gapwhere gap = 1
 
 --//////////////////////
 
--2. Calculate the month-wise retention rate.

--Basic formula: o	Month-Wise Retention Rate = 1.0 * Number of Customers Retained in The Current Month / Total Number of Customers in the Current Month

--It is easier to divide the operations into parts rather than in a single ad-hoc query. It is recommended to use View. 
--You can also use CTE or Subquery if you want.

--You should pay attention to the join type and join columns between your views or tables.

select distinct cust_id, [Year], [Month], month_order, next_visit,		count(cust_id)	over (partition by next_visit) Month_Wise_Retentionfrom	gapwhere	gap = 1 and		month_order > 1

---///////////////////////////////////
