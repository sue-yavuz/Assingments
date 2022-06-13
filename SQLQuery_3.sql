USE new_db

DROP TABLE IF EXISTS Actions;

-- a.Create above table (Actions) and insert values,
CREATE TABLE Actions(
     Visitor_ID INT IDENTITY(1,1) PRIMARY KEY,
     Adv_Type CHAR,
     Action VARCHAR(10),
);

SET IDENTITY_INSERT Actions ON;
INSERT Actions (Visitor_ID,Adv_Type,Action)
VALUES
(1, 'A', 'Left'),
(2, 'A', 'Order'),
(3, 'B', 'Left'),
(4, 'A', 'Order'),
(5, 'A', 'Review'),
(6, 'A', 'Left'),
(7, 'B', 'Left'),
(8, 'B', 'Order'),
(9, 'B', 'Review'),
(10, 'A', 'Review')
SET IDENTITY_INSERT Actions OFF;

select * from Actions

-- b.Retrieve count of total Actions and Orders for each Advertisement Type,
GO
CREATE OR ALTER VIEW count_table AS
SELECT Adv_Type, 
     COUNT(ACTION) AS Total_Actions,
     COUNT(CASE WHEN Action = 'Order' then 1 ELSE NULL END) AS Orders
FROM Actions
GROUP BY Adv_Type
GO

-- c.Calculate Orders (Conversion) rates for each Advertisement Type by 
-- dividing by total count of actions casting as float by multiplying by 1.0.
SELECT Adv_Type, CAST((Orders*1.0/Total_Actions) AS NUMERIC(10,2)) AS Conversion_Rate
FROM count_table

