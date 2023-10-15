-- -------------------------------Data Wrangling-------------------------------------------------------------------------------------------------------------

-- Step 1: Create a database using the "IF NOT EXISTS" clause to prevent error.

CREATE DATABASE IF NOT EXISTS salesDataWalmart;

-- Step 2 (important): Right click on the "salesdatawalmart" database & then click on, "Set as 
-- Default Schema," to specify which database should be the default or current database for 
-- the session. When one sets a default schema, any SQL statements executed in that session will  
-- be implicitly performed within that database unless one explicitly specifys a different database.
-- This action simplifies querying because setting a default schema can simplify one's SQL queries. 
-- That is, instead of having to fully qualify table & object names with the database name each 
-- time one references them, one can omit the database name if it belongs to the default schema.
-- This also helps to prevent accidental changes to other databases. This is because without a 
-- "default schema," one might accidently make changes to the wrong database.

-- Step 3: Create a table & name it "sales." Use "if not exists" clause to prevent error. Specify 
-- the "NOT NULL" constraint when creating the table in a relational database to indicate that
-- a particular column must always contain a value. This constraint prevents the insertion of 
-- incomplete or undefined data, which could lead to errors or inconsistent information. 
-- Therefor, "NOT NULL" simplifies query conditions & calculations because one doesn't need to 
-- check for NULL values.
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

-- Step 4: Upload the data into the sales table. 
-- Highlight & run the above query to create the database. Refresh chemas & click the table view 
-- for the "sales" table. There is no data inside of it yet so import the data into the database 
-- by clicking "import records fromm external file." Select the destination with the "browse"
-- button to select the file to import. Under "Select Destination" use the existing sales table 
-- "salesdatawalmart" and select to "truncate table before import " which delets 
-- all the data from the table, effectively emptying it, prior to loading new data. This is often 
-- done as a part of a data import process to ensure that the target table is clean and ready 
-- to receive the incoming data. That is, his is important when you want to replace 
-- the existing data with a new dataset & ensures a clean slate to which new data is added.
-- By emptying the table, you prevent potential duplication issues. Before truncating a table, 
-- make sure you have a backup of the data if needed because truncation is an irreversible 
-- operation, and all data in the table will be lost. Additionally, be cautious when using 
-- this operation in a production database, as it can lead to data loss if not executed with care.
-- Match the columns to the database columns created. Vlick "Next" & then "Finish."

-- Take a look at the entire table. 
SELECT * FROM sales;

-- -------------------------------------Feature Engineering--------------------------------------------------------------------------------------------------
-- Add the time_of_day column to give insight into sales in the Morning, Afternoon and Evening. 
SELECT time,
	(CASE WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening" END) AS time_of_day FROM sales;
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR (20);

-- Update the new column cells. 
UPDATE sales SET time_of_day = 
		(CASE WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening" END);
-- For this to work turn off safe mode for update
-- Edit > Preferences > SQL Editor > scroll down and toggle safe mode
-- Reconnect to MySQL: Query > Reconnect to server

-- Add day name column.
SELECT date, DAYNAME(date) FROM sales;
ALTER TABLE sales ADD COLUMN day_name VARCHAR (10);
-- Update the new column cells 
UPDATE sales SET day_name = DAYNAME (date);

-- Add month name column.
SELECT date, MONTHNAME(date) FROM sales;
ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);
-- Update the new column cells. 
UPDATE sales SET month_name = MONTHNAME(date);




-- --------------------------------------------------Exploratory Data Analysis (EDA)---------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------Answering Generic Questions-------------------------------------------------------------------------------------------------
-- How many unique cities does the data have?
SELECT DISTINCT city FROM sales;
-- Answer: We have 3 (Yangon Naypyitaw, and Mandalay).

-- What city is each branch located?  
SELECT DISTINCT city, branch FROM sales;
-- Answer: Branch A is in Yangon, B is in Mandalay, and C is in Naypyitaw.

-- ----------------------------------Answering Product Questions------------------------------------------------------------------------------------------------
-- How many unique product lines does the data have? 
SELECT COUNT(DISTINCT product_line) FROM sales;
-- Answer: There are 6 distinct product lines. 

-- What is the most common payment method? 
SELECT payment_method, COUNT(payment_method) AS cnt FROM sales 
GROUP BY payment_method 
ORDER BY cnt DESC;  
-- Answer: Cash is the most common Payment method. Cash (344), Ewallet (342), Credit Card (309). 

-- What product line has the highest quantity of sales?
SELECT SUM(quantity) as qty, product_line FROM sales
GROUP BY product_line
ORDER BY qty DESC;
-- Answer: The product line with the highest sales quatity is Electronics accessories.

-- What is the total revenue by month?
SELECT month_name AS month, SUM(total) AS total_revenue FROM sales
GROUP BY month_name 
ORDER BY total_revenue DESC; 
-- Answer: January (116291.8680), March (108867.1500), February (95727.3765).

-- What month had the largest Cost of Goods Sold (COGS)?
SELECT month_name AS month, SUM(cogs) as cogs from sales
GROUP BY month_name
ORDER BY cogs DESC;
-- Answer: January had the largest COGS ($110,754). COGS in March was $103,683 & 
-- February was $91,169.

-- What product line had the greatest total revenue?
SELECT product_line, SUM(total) AS total_revenue FROM sales 
GROUP BY product_line 
ORDER BY total_revenue DESC; 
-- Answer: Food and beverages is the product line with the greatest revenue. 
-- Food and beverage ($56,144.8440), Fashion and accessories ($54,305.8950), 
-- Sports and travel ($53,936.1270), Home and lifestyle ($53,861.9130), 
-- Electronics and accessories ($53,783.2365), & Health and Beauty ($48,854.3790).

-- Calculate the gross income by product line, which provides the greatest gross income?
SELECT product_line, ROUND(SUM(gross_income), 0) AS gross_income FROM sales
GROUP BY product_line
ORDER BY gross_income DESC;
-- Answer: Food and beverage produce the greatest gross income  of $2674. 
-- Results: Product Line, Gross Income
-- Food and beverages, $2674
-- Fashion accessories, $2586
-- Sports and travel, $2568
-- Home and lifestyle, $2565
-- Electronic accessories, $2561
-- Health and beauty, $2326

-- What city had the greatest revenue?
SELECT city, branch, SUM(total) AS total_revenue FROM sales 
GROUP BY city, branch 
ORDER BY total_revenue DESC; 
-- Answer: Naypyitaw (branch c) has the greatest total revenue. 
-- Naypyitaw($110,490.7755), Yangon($105,861.0105),Mandalay ($104,534.6085).

-- What product line had the greatest alue added tax (VAT)?
SELECT product_line, AVG(tax_pct) AS avg_tax FROM sales
GROUP BY product_line 
ORDER BY avg_tax DESC;
-- Answer: Home and lifestyle have the greatest VAT. Home and lifestyle (16.03033124), Sports 
-- and travel(15.75697549),Health and beauty(15.40661591),Food and beverages(15.36531029), 
-- Electronic accessories(15.15447632), Fashion accessories (14.52806181). 
    
-- Fetch each product line & add a column to those product line showing "Good", "Bad". 
-- Good if its greater than average sales.
SELECT AVG(quantity) AS avg_qnty FROM sales;
    -- Average sales quantity is 5.4995. Round up to 6. 
SELECT product_line,
	CASE WHEN AVG(quantity) > 6 THEN "Good" ELSE "Bad"END AS remark FROM sales
GROUP BY product_line;
-- Answer: All are bad.

-- Which branch sold more products than the average product sold?
SELECT branch, SUM(quantity) AS total_quantity FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG (quantity) FROM sales);
-- Answer: Branch A sold more products that the average products sold. A (1849), B (1828), C (1795).

 -- What is the most common product line by gender?
SELECT product_line, gender, COUNT(gender) AS total_count FROM sales
GROUP BY product_line, gender
Order BY total_count DESC;
-- Answer: Fashion accessories is the most common product_line for women. 
-- Health and beauty is the most common product_line for men.

-- What is the average rating for each product line?
SELECT ROUND(AVG(rating),2) AS avg_rating, product_line FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;
-- Answer: Food and Beverages has the best rating. Food and beverages (7.11), 
-- Fashion accessories (7.03), Health and beauty (6.98), Electronic accessories (6.91), 
-- Sports and travel (6.86), Home and lifestyle (6.84)
    

-- ---------------------------------------Answering Questions about Sales-----------------------------------------------------------------------------------------
-- By weekday, what is the number of sales made at each time of the day? 
SELECT time_of_day, COUNT(*) AS total_sales FROM sales
WHERE day_name = "Monday"
GROUP BY time_of_day
ORDER BY total_sales DESC;
-- Answer:  (insert day in "Where" Clause)       
-- Results: Total sales in the Evening, Afternoon, Morning respectively (see below)
--         Monday- 56, 48, 20
--         Tuesday- 69, 53, 36
--         Wednesday- 61, 58, 22
--         Thursday- 56, 49, 33
--         Friday- 58, 51, 29
--         Saturday- 81, 55, 28
--         Sunday- 58,52, 22
--         Evenings experience the most sales and should therefore have more staff during that time.

-- What customer type brings in the most revenue?
SELECT customer_type, SUM(total) AS total_revenue FROM sales 
GROUP BY customer_type 
ORDER BY total_revenue DESC; 
-- Answer: Members customers provide the greatest total revenue which equals $163,625.1015. 
-- Normal customers $157,261.2930 in total revenue. 

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT city, ROUND(AVG(tax_pct), 2) AS avg_tax_pct FROM sales
GROUP BY city 
ORDER BY avg_tax_pct DESC;
-- Answer: Naypyitaw has the highest average tax percent of 16.09%. 
-- Mandalay has 15.13% and Yangon has 14.87% VAT. 

-- Which customer type pays the most in VAT (Value Added Tax)?
SELECT customer_type, ROUND(AVG(tax_pct), 2) AS avg_tax_pct FROM sales
GROUP BY customer_type 
ORDER BY avg_tax_pct DESC;
-- Answer: For VAT, Member customers pay more than Normal customers. 
-- Results: Member (15.61%) V.S. Customers (15.10%)


-- --------------------------------Answering Questions about the Customer-------------------------------------------------------------------------------------
--  Understand the gender distribution of customers to tailor marketing strategies and product offerings.
-- Analyze customer types (e.g., retail, wholesale) to differentiate marketing approaches & 
-- product packaging.

-- What gender brings in the most gross income?
SELECT gender, ROUND(SUM(gross_income),0) AS gross_income FROM sales
GROUP BY gender
ORDER BY gross_income;
-- Answer: Females generate the greatest gorss income of $7923 compared to males who generate $7356

-- How many unique customer types does the data have?
SELECT DISTINCT customer_type FROM sales;
-- Answer: There are two customer types, Normal & Member.

-- How many unique payment methods does the data have?
SELECT DISTINCT payment_method FROM sales;
-- Answer: There are 3 distinct payment methods; Credit Card, Ewallet, & Cash.

-- What is the most common customer type?
SELECT customer_type, count(*) as count FROM sales
GROUP BY customer_type
ORDER BY count DESC;
-- Answer: Members are the most common customer type (499) compared to Normal customers (496).
    
-- What is the gender of most customers?
Select gender, COUNT(*) as count from sales 
GROUP BY gender
ORDER BY count DESC;
-- Answer: There are 498 males and 497 females. So, most customers are males but not by much more.

-- What is the gender distribution per branch?
SELECT gender, COUNT(*) as gender_cnt FROM sales
WHERE branch = "A"
GROUP BY gender
ORDER BY gender_cnt DESC;
-- Insert the desired branch in the WHERE clause in the above script.
-- Answer: Branch, Female Count, Male Count, (respectively,see below)
--              A, 160, 179
--              B, 160, 169
--              C, 177, 150
 
-- At what time of the day do customers give the best ratings?
SELECT time_of_day, ROUND(AVG(rating),2) AS avg_rating FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;
-- Answer: The time of day does not have a significant affect on rating as it is about the same rating 
-- at each time of the day. The results are as follows:
-- Time of day, Average Rating (respectively, see below) 
-- Afternoon, 7.02
-- Morning, 6.94
-- Evening, 6.91

-- According to the time of the day, which branch gets the best ratings?
SELECT time_of_day, ROUND(AVG(rating),2) AS avg_rating FROM sales
WHERE branch = "C"
GROUP BY time_of_day;
ORDER BY avg_rating DESC;
-- Above, insert the desired branch (A,B,C) in the WHERE clause.
-- Answer: Branch A and C are doing well in ratings but branch B needs to do more to get better ratings.
-- Results: Branch,Time of Day/Average Rating
-- 			A, Morning (7.01), Afternoon (7.19), Evening (6.87) 
-- 			B, Morning (6.84), Afternoon (6.81), Evening (6.75) 
--          C, Morning (6.97), Afternoon (7.07), Evening (7.10) 

-- Which day of the week has the best average ratings?
SELECT day_name, ROUND(AVG(rating),2) AS rating FROM sales
GROUP BY day_name
ORDER BY rating DESC;
-- Answer: Mondays, Tuesdays and Fridays get the best ratings. 
-- Results: Day, Average Rating (respectively, see below) 
-- Monday, 7.13
-- Friday, 7.06
-- Tuesday, 7
-- Sunday, 6.99
-- Saturday, 6.90
-- Thursday, 6.89
-- Wednesday, 6.76

-- By each day of the week, how much product is sold?
SELECT day_name, SUM(quantity) AS total_quantity FROM sales
GROUP BY day_name
ORDER BY total_quantity DESC;
-- Answer:  The highest quatity of product are sold on Saturdays.
-- Results: Day, Total Quantity
--      Saturday, 919
-- 		Tuesday, 862
-- 		Wednesday, 784
-- 		Sunday, 769
-- 		Thursday, 755
-- 		Friday, 755
-- 		Monday, 628

-- Which day of the week has the best average ratings per branch?
SELECT day_name, ROUND(AVG(rating),2) AS average_rating FROM sales
WHERE branch = "C" 
GROUP BY day_name
ORDER BY average_rating Desc;
-- Answer: Branch A gets the best ratings on Fridays, Branch B gets the best ratings on Mondays, and Branch C gets the best ratings on Saturday.
-- Result: Branch, Day, Average Rating (respectivelly, see below)
-- A, Friday, 7.31
-- A, Monday, 7.1
-- A, Sunday, 7.08
-- A, Tuesday, 7.06
-- A, Thursday, 6.96
-- A, Wednesday, 6.84
-- A, Saturday, 6.75
-- B, Monday, 7.27
-- B, Tuesday, 7
-- B, Sunday, 6.8
-- B, Thursday, 6.75
-- B, Saturday,6.74
-- B, Friday, 6.69
-- B, Wednesday, 6.38
-- C, Saturday, 7.23 
-- C, Friday, 7.21
-- C, Wednesday, 7.06
-- C, Monday, 7.04
-- C, Sunday, 7.03
-- C, Thursday, 6.95
-- C, Tuesday, 6.95
-- C, Sunday, 7.03


    

