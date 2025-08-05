# SQl sales_Retail_Analysis

create database SQL_project_1;

 -- created  table
create table retail_sales
          (
			transactions_id int primary key,
            sale_date date,
            sale_time time,
            customer_id int,
            gender	varchar(15),
            age int,	
            category varchar(20),	
            quantity int,
            price_per_unit float,	
            cogs float,
            total_sale float

           );
		
 select count(*) from retail_sales;

 -- Data cleaning
 
select * from retail_sales
where
 transactions_id is null
 or
 sale_date is null
 or
 sale_time is null
 or
 customer_id is null
 or
 gender is null
 or
 age is null
 or
 category is null
 or 
 quantity is null
 or
 price_per_unit is null
 or 
 cogs is null
 or
 total_sale is null;
 
  -- Data Exploration

-- HOW MANY SALES WE HAVE ? 
 select count(*) as total_sale from retail_sales;
 
--  HOW MANY UNIQUE CUSTOMERS WE HAVE ?
select count(distinct customer_id) as total_sale from retail_sales;     # use distinct for unique cust_id

 --  HOW MANY UNIQUE CATEGORY WE HAVE ?       
select distinct category from retail_sales;       

-- Data Analysis & Buisness Key Problems & Answers     

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)        


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

select * from retail_sales where
sale_date = "2022-11-05" ;

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022

select * 
from retail_sales
where category = 'Clothing'
and date(sale_date) between '2022-11-01' and '2022-11-30'
and quantity > 3;

 -- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
 
 select category, sum(total_sale) as net_sale
 from retail_sales
 group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select category,
round(avg(age),2) as avg_age       # use round for converting  decimal points
from retail_sales where category ='Beauty'
group by category;

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from retail_sales
where total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select category,gender,
count(*) as total_transaction
from retail_sales 
group by category,gender
order by category;           # use for better understanding

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT 
  year,
  month,
  avg_sale
FROM (
  SELECT
    YEAR(sale_date)   AS year,
    MONTH(sale_date)  AS month,
    AVG(total_sale)   AS avg_sale,
    RANK() OVER (
      PARTITION BY YEAR(sale_date)
      ORDER BY AVG(total_sale) DESC
    ) AS rk                                              # rk means column alias
  FROM retail_sales
  GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS ranked
WHERE rk = 1
ORDER BY year;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales

select customer_id,
sum(total_sale) from retail_sales
group by 1
order by 2 desc
limit 5 ;        # for top 5 customers

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select category,
count(distinct customer_id)   # distinct used for unique customers
 from retail_sales
group by category ;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)    

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift

-- End of project