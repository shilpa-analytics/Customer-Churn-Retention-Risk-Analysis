
/* Query 1 - Churn by Tenure group */

SELECT 
	CASE
		WHEN ch.Tenure <= 12 THEN '0-12 months'
		WHEN ch.Tenure <= 24 THEN '13-24 months'
		WHEN ch.Tenure <= 48 THEN '25-48 months'
		ELSE '49+ months'
	END AS TenureGroup,

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

FROM Churn ch

GROUP BY 
	CASE
		WHEN ch.Tenure <= 12 THEN '0-12 months'
		WHEN ch.Tenure <= 24 THEN '13-24 months'
		WHEN ch.Tenure <= 48 THEN '25-48 months'
		ELSE '49+ months'
	END

ORDER BY ChurnRate DESC;


/* Query 2 - Churn by Monthly Charges */

SELECT
	CASE
		WHEN b.MonthlyCharges < 50 THEN 'Under $50'
		WHEN b.MonthlyCharges < 80 THEN '$50-$80'
		ELSE 'Over $80'
	END AS MpnthlyChargesGroup,

	COUNT(*) AS TotalCustomers,

	SUM(
		CASE
			WHEN ch.Churn = 'Yes' THEN 1
			ELSE 0
		END
	) AS ChurnedCustomers,

	CAST(
		100*
		SUM(
			CASE
				WHEN ch.Churn = 'Yes' THEN 1
				ELSE 0
			END
		) / count(*) 
		AS DECIMAL(5,2)
	) AS ChurnRate

FROM Billing b

INNER JOIN Churn ch
	ON b.CustomerID = ch.CustomerID

GROUP BY
	CASE
		WHEN b.MonthlyCharges < 50 THEN 'Under $50'
		WHEN b.MonthlyCharges < 80 THEN '$50-$80'
		ELSE 'Over $80'
	END

	ORDER BY ChurnRate DESC;


/* Query 3 - Churned Customers: Customer Risk Segmentation based on the churned customers */

SELECT
	c.CustomerID,
	b.Contract,
	b.MonthlyCharges,
	ch.Tenure,
	ch.Churn,

	CASE
		WHEN ch.Churn = 'Yes' 
			AND ch.Tenure <= 12 
			AND b.Contract = 'Month-to-month'
			THEN 'High Risk'

		WHEN ch.Churn = 'Yes' 
			OR (
				ch.Tenure <= 12 
				AND b.Contract = 'Month-to-month'
			)
			THEN 'Medium Risk'

		ELSE 'Low Risk'
	END AS RiskLevel

FROM Customers c

INNER JOIN Billing b
	ON c.CustomerID = b.CustomerID

INNER JOIN Churn CH
	ON c.CustomerID = ch.CustomerID;


/* Query 4 - Churned Customers: Risk Level Summary based on the churned customers */

WITH CustomerRisk AS(
	SELECT
		c.CustomerID,
		b.Contract,
		b.MonthlyCharges,
		ch.Tenure,
		ch.Churn,

		CASE
			WHEN ch.Churn = 'Yes'
				AND ch.Tenure <= 12
				AND b.Contract = 'Month-to-month'
				THEN 'High Risk'
			WHEN ch.Churn = 'Yes'
				OR (
					ch.Tenure <= 12
					AND b.Contract = 'Month-to-month'
				)
				THEN 'Medium Risk'
			ELSE 'Low Risk'
		END AS RiskLevel

FROM Customers c
	
INNER JOIN Billing b
	ON c.CustomerID = b.CustomerID
	
INNER JOIN Churn ch
	ON c.CustomerID = ch.CustomerID

)

SELECT 
	RiskLevel,
	COUNT(*) AS CustomerCount

FROM CustomerRisk

GROUP BY RiskLevel

ORDER BY CustomerCount DESC;



/* Query 5 - Retained Customers: Customer Risk Segmentation based on the Retained customers. 
				(Churn Status and Retention Risk) */

SELECT 
	c.CustomerID,
	b.Contract,
	ch.Tenure,
	b.MonthlyCharges,
	ch.Churn,

	 CASE						 
	 	WHEN ch.Churn = 'Yes' 
			THEN 'Churned'
		
		ELSE 'Retained'
	END AS ChurnStatus,

	CASE
		WHEN ch.Churn = 'Yes' 
			THEN 'N/A'

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
	ON c.CustomerID = ch.CustomerID;



/* Query 6 - Retained Customers: Risk Level Summary based on the Retained customers 
				(Churn Status and Retention Risk)*/

WITH CustomerRisk AS(
	SELECT
		c.CustomerID,
		b.Contract,
		ch.Tenure,
		b.MonthlyCharges,
		ch.Churn,

		CASE
			WHEN ch.Churn = 'Yes' 
				THEN 'Churned'
			ELSE 'Retained'
		END AS ChurnStatus,

		CASE
			WHEN ch.Churn = 'Yes'
				THEN 'N/A'
			
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
	ON c.CustomerID =b.CustomerID

INNER JOIN Churn ch
	ON c.CustomerID = ch.CustomerID
)

SELECT
	RetentionRisk,
	COUNT(*) As CustomerCount

FROM CustomerRisk

WHERE RetentionRisk <> 'N/A'

GROUP BY RetentionRisk

ORDER BY CustomerCount DESC;