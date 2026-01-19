/*Data Exploration & Data Quality Checks (SQL)

Before starting the churn analysis, I performed several data quality checks and exploratory queries to better understand the dataset.

1. Duplicate Check

Checked for duplicate records based on Customer_id.
No duplicate customers were found in the dataset.*/

WITH CTE_duplicate AS 
(
SELECT
	Customer_id,
	RANK() OVER (PARTITION BY Customer_id ORDER BY Customer_id) AS Duplicate
FROM customer_churn
)

SELECT
Customer_id,
Duplicate
FROM CTE_duplicate
WHERE Duplicate > 1


/*2. Age Validation

Verified whether there were incorrect or unrealistic values in the Age column.*/
  
SELECT
Customer_id,
Age
FROM customer_churn
WHERE age < 18 OR age > 100;

/* 3. Contract Type Analysis

Explored the different types of contracts available in the dataset.*/

SELECT
DISTINCT(Contract)
FROM customer_churn

/* 4. Customer Distribution by City

Analyzed which cities have the highest number of customers. */

SELECT city,
       COUNT(*) AS num_client
FROM customer_churn
GROUP BY city
ORDER BY num_client DESC;

/*5. Churn Category Analysis

Identified the churn category with the highest number of customers.*/

SELECT
COUNT(*) tot_clients,
churn_category
FROM customer_churn
WHERE churn_category IS NOT NULL
GROUP BY churn_category
ORDER BY tot_clients DESC
