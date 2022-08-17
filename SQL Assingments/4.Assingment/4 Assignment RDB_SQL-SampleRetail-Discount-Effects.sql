--Var olan minimum indirim degeri kontrol parametresi olarak kabul edilmistir 
--[0.05]  total_quantity
--Var olan minimum indirim sonrasindaki indirimlerin quantity ortalamasi alinmistir 
--[0.07],[0.10],[0.20]  Avg_Last_3_Discount
--Quantity farki ile kiyaslama yapilmiitir
--Avg_Last_3_Discount-Avg_Last_3_Discount 0>Positive, 0<Negative, Neutral

USE SampleRetail;
GO

SELECT   *
FROM    sale.order_item
--examine result:
--1 Order, 5 item, 8 quantity, 4 discount category
GO

-- Unpivot the table.  
SELECT Count_of_Order_Item, Datas 
FROM	(
    --Count Orders Item Table 
	select	COUNT(*) Order_Item_Rows
			,COUNT(distinct order_id) Different_Orders
			,COUNT(distinct product_id) Different_Products
			,SUM(quantity) Total_Quantities
			,COUNT(distinct discount) Discount_Category
	from sale.order_item
) like_pvt  
UNPIVOT	(
	Datas 
	FOR Count_of_Order_Item IN (
		Order_Item_Rows
        ,Different_Orders
        ,Different_Products
        ,Total_Quantities 
        ,Discount_Category 
		
	)  
)AS unpvt;  
--examine result: Products, Orders, Discount, Quantities
GO  

drop table if exists #temp_tbl_1;

--Create temp table 1
--WINDOW FUN ile count_order ve total_quantity
select	distinct product_id, discount
        ,count(order_id) OVER(partition by product_id, discount) count_order
        ,sum(quantity) OVER(partition by product_id, discount) total_quantity
INTO	#temp_tbl_1
from sale.order_item

select	*
from    #temp_tbl_1
--examine result: count_order, total_quantity, choosed-total_quantity
GO


drop table if exists #temp_tbl_2;

--Create temp table 2
SELECT  product_id, discount, total_quantity
        ,AVG(total_quantity) OVER(PARTITION BY product_id ORDER BY discount ROWS BETWEEN 1 FOLLOWING AND UNBOUNDED FOLLOWING) Avg_Last_3_Discount
        ,DENSE_RANK() OVER(PARTITION BY product_id ORDER BY discount ) [DENSE_RANK]
INTO    #temp_tbl_2
FROM    #temp_tbl_1

SELECT  *
FROM    #temp_tbl_2
--examine result: 
--product_id: 2,	discount: 0.05, 	quantity: 26	Avg_Last_3: 30  	[DENSE_RANK]:1 
GO


drop table if exists #temp_tbl_3;

--Create temp table 3
SELECT  product_id, discount, total_quantity
        ,CASE 
                WHEN (Avg_Last_3_Discount - total_quantity) > 0 THEN  'Positive'
                WHEN (Avg_Last_3_Discount - total_quantity) < 0 THEN  'Negative'
                ELSE 'Neutral'
        END [Discount_Effect]
INTO    #temp_tbl_3
FROM    #temp_tbl_2
WHERE   [DENSE_RANK]=1

SELECT  *
FROM    #temp_tbl_3
--examine result: Change Values ('Positive', 'Negative', 'Neutral')
GO


drop table if exists #temp_tbl_4;

--Create temp table 4
SELECT  Discount_Effect
        ,COUNT(product_id) Total_Discount_Effect
INTO    #temp_tbl_4
FROM    #temp_tbl_3
GROUP BY Discount_Effect

SELECT  *
FROM    #temp_tbl_4
ORDER BY 1 DESC
--examine result: 
--number of positively affected products		number of negatively affected products
--197											110
GO


select  (
        SELECT  SUM(Total_Discount_Effect)
        FROM    #temp_tbl_4
        WHERE   Discount_Effect NOT IN ('Negative')
        ) 'number of positively affected products'
        ,(
        SELECT  SUM(Total_Discount_Effect)
        FROM    #temp_tbl_4
        WHERE   Discount_Effect IN ('Negative')
        ) 'number of negatively affected products'
--examine result: Total Effect
GO

--result:
--Mostly discount effect look like positively. 
--Discounts have been increasing orders and sales.