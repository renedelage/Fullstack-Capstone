DROP SCHEMA IF EXISTS retail_data;
CREATE SCHEMA retail_data;
USE retail_data;
-- import table data
SELECT * FROM marketing_campaign;
-- Calculate the total number of customer encounters in the marketing campaign dataset
SELECT COUNT(*) 'Customer Encounters' FROM marketing_campaign;
-- Identify the top 10 products purchased in the dataset
-- Can't pull top 10 products sold because there were only 6 products in the data set
-- Here are their totals though
SELECT SUM(MntWines) 'Wine', SUM(MntFruits) 'Fruit', SUM(MntMeatProducts) 'Meat Products', SUM(MntFishProducts) 'Fish Products', 
SUM(MntSweetProducts) 'Sweet Products', SUM(MntGoldProds) 'Gold Products' FROM marketing_campaign;
-- Here's a ranking of top 10 orders for Wine Products, which may be a more appropriate way to approach this task
SELECT ID, MntWines 'Wine Items Sold', RANK() OVER(ORDER BY MntWines DESC) 'Rank' FROM marketing_campaign LIMIT 10;
-- Find the count of response values
SELECT SUM(Response) 'Total Responses' FROM marketing_campaign;
-- Determine the distribution of customers based on their education level and marital status
SELECT Education, COUNT(ID) 'Total Customers' FROM marketing_campaign GROUP BY Education;
SELECT Marital_Status, COUNT(ID) 'Total Customers' FROM marketing_campaign GROUP BY Marital_Status;
SELECT Education, Marital_Status, COUNT(ID) AS 'Total Customers' FROM marketing_campaign GROUP BY Education, Marital_Status ORDER BY Education;
-- Identify the average income of customers who particated in the marketing campaign
SELECT ROUND(AVG(Income), 2) 'Average Income' FROM marketing_campaign;
SELECT Education, ROUND(AVG(Income), 2) 'Average Income' FROM marketing_campaign GROUP BY Education;
SELECT Marital_Status, ROUND(AVG(Income), 2) 'Average Income' FROM marketing_campaign GROUP BY Marital_Status;
SELECT Education, Marital_Status, ROUND(AVG(Income), 2) 'Average Income' FROM marketing_campaign Group BY Education, Marital_Status ORDER BY Education;
-- Calculate the total number of promotions accepted by customers in each campaign
SELECT SUM(AcceptedCmp1) 'Campaign 1', SUM(AcceptedCmp2) 'Campaign 2', SUM(AcceptedCmp3) 'Campaign 3', 
SUM(AcceptedCmp4) 'Campaign 4', SUM(AcceptedCmp5) 'Campaign 5' FROM marketing_campaign;
SELECT Education, SUM(AcceptedCmp1) 'Campaign 1', SUM(AcceptedCmp2) 'Campaign 2', SUM(AcceptedCmp3) 'Campaign 3', 
SUM(AcceptedCmp4) 'Campaign 4', SUM(AcceptedCmp5) 'Campaign 5' FROM marketing_campaign GROUP BY Education;
SELECT Marital_Status, SUM(AcceptedCmp1) 'Campaign 1', SUM(AcceptedCmp2) 'Campaign 2', SUM(AcceptedCmp3) 'Campaign 3', 
SUM(AcceptedCmp4) 'Campaign 4', SUM(AcceptedCmp5) 'Campaign 5' FROM marketing_campaign GROUP BY Marital_Status;
-- Identify the distribution of customers' responses to the last campaign
SELECT Education, SUM(Response) 'Responses from Campaign 5' FROM marketing_campaign WHERE AcceptedCmp5 = 1 GROUP BY Education;
SELECT Marital_Status, SUM(Response) 'Responses from Campaign 5' FROM marketing_campaign WHERE AcceptedCmp5 = 1 GROUP BY Marital_Status;
-- Calculate the average number of children and teenagers in customers' households
SELECT AVG(Kidhome) 'Average Kids in Household', AVG(Teenhome) 'Average Teens in Household' FROM marketing_campaign;
-- Create an Age Column by subtracting the year_birth from the current year
ALTER TABLE marketing_campaign ADD COLUMN Calc_Age INT;
UPDATE marketing_campaign SET Calc_Age = 2025 - Year_Birth;
SELECT Calc_Age FROM marketing_campaign LIMIT 20;
-- Create Age_Group columns base on the below condition (various age groups listed, 18-25, 26-35, 36-45, 46-55, 56+)
ALTER TABLE marketing_campaign ADD COLUMN Age_Group VARCHAR(10);
UPDATE marketing_campaign SET Age_Group = 
CASE
	WHEN Calc_Age BETWEEN 18 AND 25 THEN '18-25'
	WHEN Calc_Age BETWEEN 26 AND 35 THEN '26-35'
	WHEN Calc_Age BETWEEN 36 AND 45 THEN '36-45'
	WHEN Calc_Age BETWEEN 46 AND 55 THEN '46-55'
	ELSE '56+'
END;
SELECT Calc_Age, Age_Group FROM marketing_campaign LIMIT 20;
-- Determine the average number of visits per month for customers in each age group
SELECT Age_Group, AVG(NumWebVisitsMonth) 'Average Web Visits per Month' FROM marketing_campaign GROUP BY Age_Group;
SELECT MONTH(Dt_Customer) 'Month', Age_Group, AVG(NumWebVisitsMonth) 'Average Web Visits' FROM marketing_campaign GROUP BY MONTH(Dt_Customer), Age_Group ORDER BY MONTH(Dt_Customer);
-- No information noted for age group 18-25.