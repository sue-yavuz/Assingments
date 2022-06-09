USE SampleRetail;

SELECT	sc.customer_id, 
		sc.first_name, sc.last_name,
		pp.product_name
INTO	#main_table
FROM	sale.customer sc
JOIN	sale.orders so
		ON sc.customer_id=so.customer_id
JOIN	sale.order_item soi
		ON so.order_id=soi.order_id
JOIN	product.product pp
		ON soi.product_id=pp.product_id

SELECT * FROM #main_table;
--DROP TABLE IF EXISTS #main_table;

--#table_hdd '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'
SELECT	DISTINCT *
INTO	#table_hdd
FROM	#main_table
WHERE	product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'; --109

--#hdd_Woofer 1. 'Polk Audio - 50 W Woofer - Black' -- (first_product)
SELECT	DISTINCT *
INTO	#table_Woofer
FROM	#main_table
WHERE	product_name = 'Polk Audio - 50 W Woofer - Black';  --102

--#hdd_Subwoofer 2. 'SB-2000 12 500W Subwoofer (Piano Gloss Black)' -- (second_product)
SELECT	DISTINCT *
INTO	#table_Subwoofer
FROM	#main_table
WHERE	product_name = 'SB-2000 12 500W Subwoofer (Piano Gloss Black)'; --90

--#hdd_Speakers 3. 'Virtually Invisible 891 In-Wall Speakers (Pair)' -- (third_product)
SELECT	DISTINCT *
INTO	#table_Speakers
FROM	#main_table
WHERE	product_name = 'Virtually Invisible 891 In-Wall Speakers (Pair)'; --95

--RESULT -> LEFT JOIN #table_hdd, #table_Woofer, #table_Subwoofer, #table_Speakers
SELECT		hdd.*, 
			woofer.product_name as First_product,
			subwoofer.product_name as Second_product,
			speakers.product_name as Third_product
INTO		#result
FROM		#table_hdd as hdd
LEFT JOIN	#table_Woofer as woofer ON hdd.customer_id=woofer.customer_id
LEFT JOIN	#table_Subwoofer as subwoofer ON hdd.customer_id=subwoofer.customer_id
LEFT JOIN	#table_Speakers as speakers ON hdd.customer_id=speakers.customer_id;

--UPDATE -> NOT NULL to YES
UPDATE #result 
SET First_product = 'Yes'  WHERE First_product IS NOT NULL;
UPDATE #result 
SET Second_product = 'Yes' WHERE Second_product IS NOT NULL;
UPDATE #result 
SET Third_product = 'Yes'  WHERE Third_product IS NOT NULL;

--UPDATE -> NULL to NO
UPDATE #result 
SET First_product = COALESCE(First_product, 'No');
UPDATE #result 
SET Second_product = COALESCE(Second_product, 'No');
UPDATE #result 
SET Third_product = COALESCE(Third_product, 'No');

--RESULT
SELECT * FROM #result;