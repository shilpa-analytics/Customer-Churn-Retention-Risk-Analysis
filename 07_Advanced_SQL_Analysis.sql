/* Query 1 - Contract Churn using CTE */

WITH ContractChurn AS(
	SELECT
		b.Contract,

		COUNT(*) AS TotalCustomers,

		SUM(
			CASE
				WHEN ch.Churn = 'Yes' THEN 1
				ELSE 0
			END
		) AS ChurnedCustomers

	FROM Billing b

	INNER JOIN Churn ch
		ON b.CustomerID = ch.CustomerID

	GROUP BY b.Contract
)

SELECT 
	Contract,
	TotalCustomers,
	ChurnedCustomers,

	CAST(
		100 * ChurnedCustomers / TotalCustomers
		AS DECIMAL(5,2)
	) AS ChurnRate

FROM ContractChurn

ORDER BY ChurnRate DESC;



/* Churn by Payment Method using CTE */

WITH PaymentMethodChurn AS(
	
	SELECT
		b.PaymentMethod,

		COUNT(*) AS TotalCustomers,

		SUM(
			CASE
				WHEN ch.Churn = 'Yes' THEN 1
				ELSE 0
			END
		) AS ChurnedCustomers


	FROM Billing b
	
	INNER JOIN Churn ch
		ON b.CustomerID = ch.CustomerID
	
	GROUP BY b.PaymentMethod
)

SELECT 
	PaymentMethod,
	TotalCustomers,
	ChurnedCustomers,

	CAST(
		100 * ChurnedCustomers / TotalCustomers
		AS DECIMAL(5,2)
	) AS ChurnRate

FROM PaymentMethodChurn

ORDER BY ChurnRate DESC;



/* Churn by Tech Support */

WITH TechSupportChurn AS(
	SELECT 
		s.TechSupport,

		COUNT(*) AS TotalCustomers,

		SUM(
			CASE
				WHEN ch.Churn = 'Yes' THEN 1
				ELSE 0
			END
		) AS ChurnedCustomers

	FROM Services s

	INNER JOIN Churn ch
		ON s.CustomerID = ch.CustomerID

	GROUP BY s.TechSupport
)

SELECT
	TechSupport,
	TotalCustomers,
	ChurnedCustomers,

	CAST(
		100 * ChurnedCustomers / TotalCustomers
		AS DECIMAL(5,2)
	) AS ChurnRate

FROM TechSupportChurn

ORDER BY ChurnRate DESC;

/* Query 2 - Contract Churn Ranking */




/* Query 3 - Estimated Customer Value of Churned and Retained customers */

SELECT
	c.CustomerID,
	b.MonthlyCharges,
	ch.Tenure,

	CAST(
		b.MonthlyCharges * ch.Tenure
		AS DECIMAL(10,2)
	) AS EstimatedCustomerValue

FROM Customers c

INNER JOIN Billing b
	ON c.CustomerID = b.CustomerID

INNER JOIN Churn ch
	ON c.CustomerID = ch.CustomerID;


/* Query 4 - Estimated Customer Value of Only Retained customers 
				(Retained + High Risk Customers) */

SELECT
	c.CustomerID,
	b.Contract,
	ch.Tenure,
	b.MonthlyCharges,

	CAST(
		b.MonthlyCharges * ch.Tenure
		AS DECIMAL(10,2)
	) AS EstimatedCustomerValue,

	CASE
		WHEN ch.Tenure <= 12
			AND b.Contract = 'Month-to-month'
			THEN 'High Risk'

		WHEN ch.Tenure <= 24
			OR b.Contract = 'Month-to-month'
			THEN 'Medium Risk'
		
		ELSE 'Low Risk'
	END AS RetentionRisk

FROM Customers c

INNER JOIN Billing b
	ON c.CustomerID = b.CustomerID

INNER JOIN Churn ch
	ON c.CustomerID = ch.CustomerID

WHERE ch.Churn = 'No'

AND ch.Tenure <= 12

AND b.Contract = 'Month-to-month'

ORDER BY EstimatedCustomerValue DESC;



/* Query 4 - Estimated Customer Lifetime Value Proxy of Only Retained customers 
				(Retained + High Risk + High Value Customers) 
				High Value threshold is set for $1000 for this project */

SELECT
	c.CustomerID,
	b.Contract,
	ch.Tenure,
	b.MonthlyCharges,

	CAST(
		b.MonthlyCharges * ch.Tenure
		AS DECIMAL(10,2)
	) AS EstimatedCustomerValue

FROM Customers c

INNER JOIN Billing b
	ON c.CustomerID = b.CustomerID

INNER JOIN Churn ch
	ON c.CustomerID = ch.CustomerID

WHERE ch.Churn = 'No'

AND ch.Tenure <= 12

AND b.Contract = 'Month-to-month'

AND (b.MonthlyCharges * ch.Tenure) >= 1000;

