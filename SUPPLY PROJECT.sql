
			--- CAPSTONE PROJECT 

-- QUESTION 1
-- What is the total number of units sold per product SKU?

--Logic: total number of units sold per product
--Table : Sales
-- Columns: productid, inventoryquantity
		

		SELECT productid, SUM(inventoryquantity)AS Total_Units_Sold
		FROM sales
		GROUP BY productid
		ORDER BY Total_units_Sold DESC;
	


-- QUESTION 2
--Which product category had the highest sales volume last month?

-- Logic: Product category with highest sales volume last month
-- Table: Product, sales
-- Columns: , product category,inventoryquantity,


		SELECT p.productcategory, SUM (s.inventoryquantity) 
		AS Sales_Volume
		FROM PRODUCT p
		JOIN sales s ON s.productid = p.productid
		WHERE s.sales_year = '2021' AND sales_month = '11'
		GROUP BY p.productcategory
		ORDER BY Sales_Volume
		DESC LIMIT 1;



--QUESTION 3
--How does the inflation rate correlate
--with sales volume for a specific month?

-- Logic: Relationship between inflation rate,
-- and sales volume for specific months
-- Table: sales, factors
-- Column: sales month, sales year, inflationrate, inventoryquantity


		SELECT s.sales_month, s.sales_year,
		ROUND (AVG(f.inflationrate), 2) AS Avg_Inflation, 
		SUM (s.inventoryquantity) AS sales_Volume
		FROM sales s
		JOIN factors f ON f.salesdate = s.salesdate
		GROUP BY sales_year, sales_month
		ORDER BY Avg_inflation
		DESC;
		


--- QUESTION 4 
---What is the correlation between the inflation rate 
---and sales quantity for all products combined on a 
---monthly basis over the last year?


		SELECT s.sales_month, s.sales_year, 
		ROUND (AVG(f.inflationrate), 2)AS Avg_Inflation, 
			SUM (s.inventoryquantity) AS Total_Sales_quantity
		FROM sales s
			JOIN factors f ON f.salesdate = s.salesdate
			WHERE s.salesdate >= (CURRENT_DATE - INTERVAL '1 Year')
		GROUP BY sales_year, sales_month
		ORDER BY sales_year, sales_month;

-- No correlation 

--QUESTION 5
-- Did promotions significantly impact the sales quantity of products?

-- Logic: Significance of promotion on sales quantity of products
-- Tables: Sales, Products
-- Columns: Promotion, productid, inventory quantity

		SELECT p.productcategory, p.promotions, ROUND (AVG (s.inventoryquantity), 2)
		AS Avg_Sales_without_promotion
		FROM sales s
		JOIN product p ON p.productid = s.productid
		WHERE p.promotions = 'No'
		GROUP BY p.promotions, p.productcategory
		
		
		UNION ALL
		
		SELECT p.promotions, p.productcategory, ROUND (AVG (s.inventoryquantity), 2)
		AS Avg_Sales_with_promotion
		FROM sales s
		JOIN product p ON p.productid = s.productid
		WHERE p.promotions = 'Yes'
		GROUP BY p.promotions, p.productcategory;


--QUESTION 6
--  What is the average sales quantity per product category?

-- Logic: Average sales quantity per product category.
-- Tables: Sales, product
-- Column: inventory quantity, product category 

		SELECT  p.productcategory, ROUND (AVG (s.inventoryquantity), 2) 
		AS Avg_Sales_per_product_Category
		FROM sales s
		JOIN product p ON p.productid = s.productid
		GROUP BY p.productcategory
		ORDER BY Avg_Sales_per_product_Category
		DESC;


--QUESTION 7
-- How does the GDP affect the total sales volume?

--Logic How GDP affect total sales volume
--Tables: Factors, sales
-- Columns: GDP, inventory quantity


SELECT s.sales_year, SUM (f.gdp) AS Total_GDP, ROUND (SUM (s.inventoryquantity), 2)
AS sales_volume
FROM factors f
JOIN sales s ON s. salesdate = f.salesdate
GROUP BY s.sales_year
ORDER BY sales_volume 
DESC;


--QUESTION 8
-- What are the top 10 best-selling product SKUs?

-- Logic: top 10 best-selling products SKU
--Table: sales
-- Columns: productid, inventory quantity, salesid


SELECT productid, SUM (inventoryquantity)
AS unit_sold
FROM sales
GROUP BY productid
ORDER BY unit_sold
DESC LIMIT 10;



--QUESTION 9
-- How do seasonal factors influence sales quantities
--for different product categories?

-- Logic: seasonal factors influence on sales qauntities 
-- across different product categories.
-- Tables: Factors, product, sales
-- Columns: seasionalfactor, product category, inventory quantity


SELECT ROUND(AVG(f.seasonalfactor), 2) AS Avg_seasonal_factor, 
       p.productcategory, 
       SUM(s.inventoryquantity) AS Sale_volume
FROM factors f
JOIN sales s ON s.salesdate = f.salesdate
JOIN product p ON p.productid = s.productid
GROUP BY p.productcategory
ORDER BY Avg_seasonal_factor
DESC;

-- No Seasonal correlation between each categories 


--QUESTION 10
-- What is the average sales quantity per product category,
-- and how many products within each 
-- category were part of a promotion?

-- Logic: the average sales quantity per product category,
-- and how many products within each 
-- category were part of a promotion

--- Table: sales, product
-- Columns: inventory quantity, product category, promotions


SELECT  ROUND (AVG (s.inventoryquantity), 2) AS Avg_sales_qty,
		p.productcategory, 
		COUNT (CASE WHEN p.promotions ='Yes' 
				THEN 1 
				END) AS promotion_count
FROM sales s
JOIN product p ON s.productid = p.productid
GROUP BY p.productcategory
ORDER BY Avg_sales_qty;



