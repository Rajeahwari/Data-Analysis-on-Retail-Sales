--- Create table
CREATE TABLE retail(
	transaction_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantity INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

--- To see if all the values are imported properly
SELECT COUNT (*) FROM retail;

--- Data Cleaning
SELECT * FROM retail
WHERE 
	transaction_id IS null
	OR 
	sale_date IS null 
	OR 
	sale_time IS null
	OR 
	customer_id IS null
	OR 
	gender IS null
	OR
	category IS null
	OR
	quantity IS null
	OR
	cogs IS NULL
	OR 
	total_sale IS null;
---
DELETE FROM retail
WHERE 
	transaction_id IS null
	OR 
	sale_date IS null 
	OR 
	sale_time IS null
	OR 
	customer_id IS null
	OR 
	gender IS null
	OR
	category IS null
	OR
	quantity IS null
	OR
	cogs IS NULL
	OR 
	total_sale IS null;

---Data Exploration 

-- How many sales we have 
SELECT COUNT(*) as total_sale FROM retail;

--- How many unique customers we have
SELECT COUNT(DISTINCT(customer_id)) AS total_customer FROM retail;

--- How many unique categories we have
SELECT COUNT(DISTINCT(category)) FROM retail;

---Data Analysis & Business Key Problems

--- 1.Write a SQL query to retrieve all columns for sales made on '2022-11-05'.
SELECT * 
FROM retail
WHERE sale_date='2022-11-05';

--- 2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022.
SELECT *
FROM retail
WHERE 
	category='Clothing'
	AND
	quantity>=4
	AND
	TO_CHAR(sale_date,'YYYY-MM')='2022-11';
	  
--- 3.Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category,S UM(total_sale) AS total_sales, COUNT(total_sale) AS total_orders
FROM retail
GROUP BY category;

--- 4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT ROUND(AVG(age),2)
FROM retail
WHERE category='Beauty';

--- 5.Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * 
FROM retail
WHERE total_sale>1000;

--- 6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT gender,category,COUNT(transaction_id) AS total_trans
FROM retail
GROUP BY gender,category
ORDER BY gender,category;

--- 7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
SELECT year,month,Average_sale
FROM
      (
	  SELECT 
	  EXTRACT(YEAR FROM sale_date) AS year,
	  EXTRACT(MONTH FROM sale_date) AS month,
	  AVG(total_sale) AS Average_sale,
	  RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
FROM retail
GROUP BY 1 ,2
ORDER BY 1 ,3 DESC
       ) as t
WHERE rank =1;

--- 8.Write a SQL query to find the top 5 customers based on the highest total sales.
SELECT customer_id,SUM(total_sale) AS highest_sales
FROM retail
GROUP BY customer_id
ORDER BY highest_sales DESC
LIMIT 5;

--- 9.Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category,COUNT(DISTINCT(customer_id)) AS un_customer
FROM retail 
GROUP BY category

--- 10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17).
WITH hour AS(
SELECT *,
CASE
	WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'Morning'
	WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	ELSE 'Evening'
END AS shift
FROM retail
			)
SELECT shift,COUNT(shift) AS no_orders
FROM hour
GROUP BY shift;

