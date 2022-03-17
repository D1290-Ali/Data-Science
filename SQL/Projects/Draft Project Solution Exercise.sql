SELECT UPPER (SUBSTRING('clarusway.com', 0 , CHARINDEX('.','clarusway.com')));
SELECT TRIM('@' FROM '@@@clarusway@@@@') AS new_string;
SELECT REPLACE('REIMVEMT','M','N');

--- checking dublicate values in one column
SELECT Order_ID,Ship_id
FROM shipping_dimen
GROUP BY Order_ID,Ship_id
ORDER BY Order_ID 


--Duplicate Values in Multiple Columns
SELECT OrderID, ProductID, COUNT(*)
FROM OrderDetails
GROUP BY OrderID, ProductID
HAVING COUNT(*)>1

--if you want the IDs of the dups
SELECT
    y.id,y.name,y.email
    FROM @YourTable y
        INNER JOIN (SELECT
                        name,email, COUNT(*) AS CountOf
                        FROM @YourTable
                        GROUP BY name,email
                        HAVING COUNT(*)>1
                    ) dt ON y.name=dt.name AND y.email=dt.email


--to delete the duplicates try:

DELETE d
    FROM @YourTable d
        INNER JOIN (SELECT
                        y.id,y.name,y.email,ROW_NUMBER() OVER(PARTITION BY y.name,y.email ORDER BY y.name,y.email,y.id) AS RowRank
                        FROM @YourTable y
                            INNER JOIN (SELECT
                                            name,email, COUNT(*) AS CountOf
                                            FROM @YourTable
                                            GROUP BY name,email
                                            HAVING COUNT(*)>1
                                        ) dt ON y.name=dt.name AND y.email=dt.email
                   ) dt2 ON d.id=dt2.id
        WHERE dt2.RowRank!=1
SELECT * FROM @YourTable



--finding null values
SELECT column_names
FROM table_name
WHERE column_name IS NULL;

SELECT CustomerName, ContactName, Address
FROM Customers
WHERE Address IS NULL;

SELECT id,
  first_name,
  last_name
FROM children
WHERE middle_name IS NULL

SELECT column_names
FROM table_name
WHERE column_name IS NOT NULL;


ALTER TABLE Persons
ADD CONSTRAINT PK_Person PRIMARY KEY (ID,LastName);

ALTER TABLE Persons
DROP CONSTRAINT PK_Person;

---All columns defined within a PRIMARY KEY constraint must be defined as NOT NULL. 
---If nullability is not specified, all columns participating in a PRIMARY KEY constraint have their nullability set to NOT NULL.


ALTER TABLE suppliers
  ADD CONSTRAINT suppliers_pk 
    PRIMARY KEY (supplier_id);

	---OR with multiple columns

ALTER TABLE suppliers
  ADD CONSTRAINT suppliers_pk
    PRIMARY KEY (supplier_id, supplier_name);

ALTER TABLE shipping_dimen
ALTER COLUMN Order_ID BIGINT NOT NULL

--- checking dublicate values in one column
SELECT Order_ID,Ship_id
FROM shipping_dimen
GROUP BY Order_ID,Ship_id
ORDER BY Order_ID 


--ALTER TABLE shipping_dimen
UPDATE shipping_dimen.Ship_id
SET shipping_dimen.Ship_id = (SELECT SUBSTRING(Ship_id, (CHARINDEX('_',Ship_id)+1), LEN(Ship_id))
				FROM shipping_dimen)
WHERE shipping_dimen.Ship_id


ALTER TABLE shipping_dimen
ADD (SELECT SUBSTRING(Ship_id, (CHARINDEX('_',Ship_id)+1), LEN(Ship_id)) 
FROM shipping_dimen) Ship_id_new) BIGINT NOT NULL

UPDATE shipping_dimen
SET Ship_id = (SELECT SUBSTRING(Ship_id, (CHARINDEX('_',Ship_id)+1), LEN(Ship_id))
			   FROM shipping_dimen A) Ship_id
FROM shipping_dimen

SELECT SUBSTRING(Ship_id, (CHARINDEX('_',Ship_id)+1), LEN(Ship_id)) Ship_id
FROM shipping_dimen