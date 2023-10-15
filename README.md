# Walmart-Sales-Data

Purpose Of The Project  
This Walmart MySQL project is a study of how sales strategies can be improved and optimized.Through data exploration, it aims to understand top performing branches and products, sales trends, and customer behavior. 

About The Data
This dataset contains sales transactions from 3 different branches of Walmart and was obtained from the [Kaggle Walmart Sales Forecasting Competition](https://www.kaggle.com/c/walmart-recruiting-store-sales-forecasting).
The dataset contains 17 columns and 1000 rows:
| Column                  | Description                             | Data Type      |
| :---------------------- | :-------------------------------------- | :------------- |
| invoice_id              | Invoice of the sales made               | VARCHAR(30)    |
| branch                  | Branch at which sales were made         | VARCHAR(5)     |
| city                    | The location of the branch              | VARCHAR(30)    |
| customer_type           | The type of the customer                | VARCHAR(30)    |
| gender                  | Gender of the customer making purchase  | VARCHAR(10)    |
| product_line            | Product line of the product solf        | VARCHAR(100)   |
| unit_price              | The price of each product               | DECIMAL(10, 2) |
| quantity                | The amount of the product sold          | INT            |
| VAT                 | The amount of tax on the purchase       | FLOAT(6, 4)    |
| total                   | The total cost of the purchase          | DECIMAL(10, 2) |
| date                    | The date on which the purchase was made | DATE           |
| time                    | The time at which the purchase was made | TIMESTAMP      |
| payment_method                 | The total amount paid                   | DECIMAL(10, 2) |
| cogs                    | Cost Of Goods sold                      | DECIMAL(10, 2) |
| gross_margin_percentage | Gross margin percentage                 | FLOAT(11, 9)   |
| gross_income            | Gross Income                            | DECIMAL(10, 2) |
| rating                  | Rating                                  | FLOAT(2, 1)    |

Analysis Segments Conducted
1) Product Analysis
   This was conducted to understand which product lines are performing best and which need to improve.
2) Sales Analysis
   The was conducted to answer questions about sales trends which can help measure the effectiveness of each sales startegy and what modifications are     
    needed to increase sales. 
3) Customer Analysis
4) This analysis uncovers the different customer segments, purchase trends and profitability of each customer segment.

Approach Used
1) Data Wrangling:
   -Build a database
   -Create table and insert the data
   -Detect NULL values and use data replacement methods to replace missing values. Set NOT Null for each field to filter out null values.

2) Feature Engineering
   Generate 3 new columns from existing ones: time_of_day, day_name, and month_name.

4) Exploratory Data Analysis (EDA)
    Answers the listed questions and the purpose of the project:

   Business Questions To Answer
   Generic Questions:
   1) How many unique cities does the data have?
   2) What city is each branch located?  
   Product Question:
   1) How many unique product lines does the data have?
   2) What is the most common payment method?
   3) What product line has the highest quantity of sales?
   4) What month had the largest Cost of Goods Sold (COGS)?
   5) What product line had the greatest total revenue?
   6) Calculate the gross income by product line, which provides the greatest gross income?
   7) What city had the greatest revenue?
   8) What product line had the greatest alue added tax (VAT)?
   9) What product Fetch each product line & add a column to those product line showing "Good", "Bad."
   10) Which branch sold more products than the average product sold?
   11) What is the most common product line by gender?
   12) What is the average rating for each product line?

   Sales Questions:
   1) By weekday, what is the number of sales made at each time of the day?
   2) What is the total revenue by month?
   3) What customer type brings in the most revenue?
   4) Which city has the largest tax percent/ VAT (Value Added Tax)?
   5) Which customer type pays the most in VAT (Value Added Tax)?
      
   Customer Questions:
   1) What gender brings in the most gross income?
   2) How many unique customer types does the data have?
   3) How many unique payment methods does the data have?
   4) What is the most common customer type?
   5) What is the gender of most customers?
   6) What is the gender distribution per branch?
   7) At what time of the day do customers give the best ratings?
   8) According to the time of the day, which branch gets the best ratings?
   9) Which day of the week has the best average ratings?
   10) By each day of the week, how much product is sold?
   11) Which day of the week has the best average ratings per branch?
  
   Revenue & Profit Calculations:
   COGS = unitsPrice * quantity $

   VAT = 5\% * COGS $

   VAT is added to the COGS and this is what is billed to the customer.

    total(gross_sales) = VAT + COGS 

    grossProfit(grossIncome) = total(gross_sales) - COGS 

     **Gross Margin** is gross profit expressed in percentage of the total(gross profit/revenue)

