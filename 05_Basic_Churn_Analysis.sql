/* Query 1 - Creating a Master Dataset using JOINS */

SELECT 
	c.CustomerID,
	c.Gender,
	c.SeniorCitizen,
	c.Partner,
	c.Dependents,

	s.PhoneService,
	s.MultipleLines,
	s.InternetService,
	s.OnlineSecurity,
	s.OnlineBackup,
	s.DeviceProtection,
	s.TechSupport,
	s.StreamingTV,
	s.StreamingMovies,

	b.Contract,
	b.PaperlessBilling,
	b.PaymentMethod,
	b.MonthlyCharges,
	b.TotalCharges,

	ch.Tenure,
	ch.Churn

FROM Customers c

INNER JOIN Services s
	ON c.CustomerID = s.CustomerID

INNER JOIN Billing b
	ON c.CustomerID = b.CustomerID

INNER JOIN Churn ch
	ON c.CustomerID = ch.CustomerID;


/* Query 2 - Calculating Total Churn */

SELECT 
	COUNT(*) AS TotalCustomers,
	
	SUM(
		CASE
			WHEN Churn='Yes' THEN 1
			ELSE 0
		END
	) AS ChurnedCustomers,

	CAST(
		100*
		SUM(
			CASE
				WHEN Churn='Yes' THEN 1
				ELSE 0
			END
		) / COUNT(*) 
		AS decimal(5,2)
	) AS ChurnRate

FROM Churn;

/* Query 3 - Churn by Contract type */

SELECT 
	b.Contract,

	COUNT(*) AS TotalCustomers,

	SUM(
		CASE
			WHEN ch.Churn='Yes' THEN 1
			ELSE 0
		END
	) AS ChurnedCustomers,

	CAST(
		100*
		SUM(
			CASE
				WHEN ch.Churn='Yes' THEN 1
				ELSE 0
			END
		) / COUNT(*)
		AS DECIMAL(5,2)
	) AS ChurnRate
FROM Billing b

LEFT JOIN Churn ch
	ON b.CustomerID = ch.CustomerID

GROUP BY B.Contract

ORDER BY ChurnRate DESC;


/* Query 4 - Churn by Internet Service */

SELECT 
	s.InternetService,

	COUNT(*) AS TotalCustomers,

	SUM(
		CASE
			WHEN ch.Churn='Yes' THEN 1
			ELSE 0
		END
	) AS ChurnedCustomers,

	CAST(
		100*
		SUM(
			CASE
				WHEN ch.Churn='Yes' THEN 1
				ELSE 0
			END
		) / COUNT(*)
		AS DECIMAL(5,2)
	) AS ChurnRate

FROM Services s

LEFT JOIN Churn ch
	ON s.CustomerID = ch.CustomerID

GROUP BY s.InternetService

ORDER BY ChurnRate DESC


/* Query 5 - Churn by Payment Method */

SELECT 
	b.PaymentMethod,

	COUNT(*) AS TotalCustomers,

	SUM(
		CASE
			WHEN ch.Churn='Yes' THEN 1
			ELSE 0
		END
	) AS ChurnedCustomers,
	
	CAST(
		100*
		SUM(
			CASE
				WHEN ch.Churn='Yes' THEN 1
				ELSE 0
			END
		) / COUNT(*)
		AS DECIMAL(5,2)
	) AS ChurnRate

FROM Billing b

LEFT JOIN Churn ch
	ON b.CustomerID = ch.CustomerID

GROUP BY b.PaymentMethod

ORDER BY ChurnRate DESC


/* Query 6 - Average Monthly Charges and Tenure for Churned vs Retained */

SELECT 
	ch.Churn,

	COUNT(*) AS TotalCustomers,

	CAST(
		AVG(b.MonthlyCharges)
		AS DECIMAL(10,2)
	) AS AvergaeMonthlyCharges,

	CAST(
		AVG(ch.Tenure)
		AS DECIMAL(10,2)
	) AS AverageTenure

FROM Billing b

LEFT JOIN Churn ch
	ON b.CustomerID = ch.CustomerID

GROUP BY ch.Churn