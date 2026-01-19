/* After completing the initial data exploration, I moved deeper into the analysis by answering the main business questions related to customer churn.*/

/*1. Overall Churn Rate

Since the dataset does not include a numeric churn column, I created one using a CASE statement based on the Customer_status field.
This allowed me to calculate the company’s overall churn rate.*/

WITH cte_churn AS (
SELECT
Customer_id,
CASE WHEN Customer_status = 'Churned' THEN 1 ELSE 0 END AS churn
FROM customer_churn
)

SELECT
COUNT(*) AS total_customers,
SUM(churn) AS churned_customers,
ROUND(100.0 * SUM(churn) / COUNT(*), 2) AS churn_rate
FROM cte_churn

/* 2. Churn by Customer Tenure

Next, I analyzed churn based on how long customers had been with the company.
Customers were grouped into tenure buckets measured in months. */

WITH cte_buckets_months AS (
SELECT 
CASE
	WHEN Tenure_in_months BETWEEN 0 AND 6 THEN '0-6 months'
	WHEN Tenure_in_months BETWEEN 7 AND 12 THEN '7-12 Months'
	WHEN Tenure_in_months BETWEEN 13 AND 24 THEN '13-24 Months'
	ELSE '25+ Months'
END AS buckets_months,
CASE WHEN Customer_status = 'Churned' THEN 1 ELSE 0 END AS churn
FROM customer_churn
)


SELECT
	buckets_months,
	SUM(churn) AS churned_customers,
	ROUND(100.0 * SUM(churn) / COUNT(*), 2) AS churn_rate
FROM cte_buckets_months
GROUP BY buckets_months
ORDER BY churn_rate DESC

/* 3. Churn by Contract Type

Finally, I analyzed churn across different contract types to understand how contract structure impacts customer retention.*/

SELECT 
Contract,
CASE WHEN Customer_status = 'Churned' THEN 1 ELSE 0 END AS churn
FROM customer_churn
)

WITH cte_contracts AS 
SELECT
	Contract,
	SUM(churn) AS churned_customers,
	ROUND(100.0 * SUM(churn) / COUNT(*), 2) AS churn_rate
FROM cte_contracts
GROUP BY Contract
ORDER BY churn_rate DESC
	
--------------------

SELECT
churn_category,
COUNT(*) Tot_customers
FROM customer_churn
WHERE Customer_status = 'Churned'
GROUP BY churn_category
ORDER BY Tot_customers DESC

-----------------------
WITH cte_age AS (
SELECT 
 CASE
        WHEN age BETWEEN 19 AND 29 THEN '19-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        WHEN age BETWEEN 50 AND 59 THEN '50-59'
        WHEN age BETWEEN 60 AND 69 THEN '60-69'
        WHEN age BETWEEN 70 AND 80 THEN '70-80'
        ELSE 'Unknown'
    END AS age_bucket,
CASE WHEN Customer_status = 'Churned' THEN 1 ELSE 0 END AS churn
FROM customer_churn
)


SELECT
	age_bucket,
	SUM(churn) AS churned_customers,
	ROUND(100.0 * SUM(churn) / COUNT(*), 2) AS churn_rate
FROM cte_age
GROUP BY age_bucket
ORDER BY churn_rate DESC
