----ASSIGNMENT_3 (CONVERSION RATE)

--a.Create above table (Actions) and insert values,

CREATE TABLE Actions
(
Visitor_ID BIGINT,
Adv_Type VARCHAR(20),
Actions VARCHAR(20),
);

INSERT Actions VALUES
 (1,'A', 'Left')
,(2,'A', 'Order')
,(3,'B', 'Left')
,(4,'A', 'Order')
,(5,'A', 'Review')
,(6,'A', 'Left')
,(7,'B', 'Left')
,(8,'B', 'Order')
,(9,'B', 'Review')
,(10,'A', 'Review')

SELECT *
FROM Actions

--b. Retrieve count of total Actions and Orders for each Advertisement Type,

CREATE VIEW TT 
AS
SELECT Adv_Type, COUNT(Actions) Total, Actions
FROM Actions
WHERE Actions = 'Order'
GROUP BY Adv_Type, Actions 

CREATE VIEW T_O 
AS
SELECT Adv_Type, COUNT(Actions) Total_Order
FROM Actions
GROUP BY Adv_Type

SELECT TT.Adv_Type, Total_Order, Total
FROM TT, T_O
WHERE TT.Adv_Type = T_O.Adv_Type

--c. Calculate Orders (Conversion) rates for each Advertisement Type by dividing by total count of actions casting as float by multiplying by 1.0.

SELECT TT.Adv_Type, ROUND(CAST(Total AS float)/CAST(Total_Order AS float), 2) AS Conversion_Rate
FROM TT, T_O
WHERE TT.Adv_Type = T_O.Adv_Type

SELECT TT.Adv_Type, ROUND(CONVERT(float,Total)/CONVERT(float,Total_Order), 2) AS Conversion_Rat
FROM TT, T_O
WHERE TT.Adv_Type = T_O.Adv_Type


--2nd Type of Solution
select Adv_Type,  conv_rate
from (
		select distinct Adv_Type,Actions,
				COUNT (Actions) over (partition by Adv_Type ) total_actions_of_Adv_Type,
				COUNT (Actions) over (partition by Adv_Type,Actions ) actions_portions_of_Adv_Type,
				cast ((1.0 * COUNT (Actions) over (partition by Adv_Type,Actions ) / COUNT (Actions) over (partition by Adv_Type )) as decimal (5,2)) conv_rate
				from	Actions
	 ) as T1
where Actions = 'Order'