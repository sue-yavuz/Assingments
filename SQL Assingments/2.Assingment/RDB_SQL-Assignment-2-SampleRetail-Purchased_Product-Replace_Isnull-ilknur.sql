USE SampleRetail;

SELECT	sc.customer_id, 
		sc.first_name, sc.last_name,
		pp.product_name
INTO	#jointable
FROM	sale.customer sc
JOIN	sale.orders so
		ON sc.customer_id=so.customer_id
JOIN	sale.order_item soi
		ON so.order_id=soi.order_id
JOIN	product.product pp
		ON	soi.product_id=pp.product_id;

SELECT * FROM #jointable;
--DROP TABLE IF EXISTS #jointable;

--#table_hdd -> '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'
SELECT DISTINCT *
INTO	#table_hdd
FROM	#jointable
WHERE	product_name='2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD'; --109

--1. 'Polk Audio - 50 W Woofer - Black' -- (first_product)
SELECT DISTINCT *
INTO	#table_Woofer
FROM	#jointable
WHERE	product_name='Polk Audio - 50 W Woofer - Black'; --102

--2. 'SB-2000 12 500W Subwoofer (Piano Gloss Black)' -- (second_product)
SELECT DISTINCT *
INTO	#table_Subwoofer
FROM	#jointable
WHERE	product_name='SB-2000 12 500W Subwoofer (Piano Gloss Black)'; --90

--3. 'Virtually Invisible 891 In-Wall Speakers (Pair)' -- (third_product)
SELECT DISTINCT *
INTO	#table_Speakers
FROM	#jointable
WHERE	product_name='Virtually Invisible 891 In-Wall Speakers (Pair)'; --95

--RESULT -> LEFT JOIN #table_hdd, #table_Woofer, #table_Subwoofer, #table_Speakers
SELECT	hdd.*, 
		REPLACE(ISNULL(woofer.product_name,'No'),'Polk Audio - 50 W Woofer - Black','Yes') as First_product,
		REPLACE(ISNULL(subwoofer.product_name,'No'),'SB-2000 12 500W Subwoofer (Piano Gloss Black)','Yes') as Second_product,
		REPLACE(ISNULL(speakers.product_name,'No'),'Virtually Invisible 891 In-Wall Speakers (Pair)','Yes') as Third_product
FROM	#table_hdd as hdd
LEFT JOIN	#table_Woofer as woofer ON hdd.customer_id=woofer.customer_id
LEFT JOIN	#table_Subwoofer as subwoofer ON hdd.customer_id=subwoofer.customer_id
LEFT JOIN	#table_Speakers as speakers ON hdd.customer_id=speakers.customer_id;