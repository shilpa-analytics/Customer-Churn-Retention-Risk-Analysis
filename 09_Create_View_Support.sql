--====================
-- Check the threshold value

/*
SELECT
	MAX(EstimatedCustomerValue) AS MaximumCustomerValue,
	AVG(EstimatedCustomerValue) AS AverageCustomerValue,
	MIN(EstimatedCustomerValue) AS MinimumCustomerValue
FROM vw_CustomerRisk
WHERE ChurnStatus = 'Retained'; 

SELECT TOP 20
	CustomerID,
	Contract,
	Tenure,
	MonthlyCharges,
	RetentionRisk,
	EstimatedCustomerValue
FROM vw_CustomerRisk
WHERE ChurnStatus = 'Retained'
ORDER BY EstimatedCustomerValue DESC; 

SELECT
	MAX(EstimatedCustomerValue) AS MaximumCustomerValue,
	AVG(EstimatedCustomerValue) AS AverageCustomerValue,
	MIN(EstimatedCustomerValue) AS MinimumCustomerValue
FROM vw_CustomerRisk
WHERE RetentionRisk = 'High Risk';

SELECT TOP 20
	CustomerID,
	Contract,
	Tenure,
	MonthlyCharges,
	RetentionRisk,
	EstimatedCustomerValue
FROM vw_CustomerRisk
WHERE RetentionRisk = 'High Risk'
ORDER BY EstimatedCustomerValue DESC; 


SELECT
    COUNT(*) AS HighRiskCustomers,
    MIN(EstimatedCustomerValue) AS MinHighRiskValue,
    MAX(EstimatedCustomerValue) AS MaxHighRiskValue,
    AVG(EstimatedCustomerValue) AS AvgHighRiskValue
FROM vw_CustomerRisk
WHERE RetentionRisk = 'High Risk';

SELECT
    COUNT(*) AS RetainedCustomers,
    MIN(EstimatedCustomerValue) AS MinRetainedValue,
    MAX(EstimatedCustomerValue) AS MaxRetainedValue,
    AVG(EstimatedCustomerValue) AS AvgRetainedValue
FROM vw_CustomerRisk
WHERE ChurnStatus = 'Retained';
*/

--===============================================
--Calculate the Risk Score
--=================================================
/*	month to month contract		+2
	tenure <=12					+2
	monthly charges >= $70		+1
	no online security			+1
	No tech support				+1
	
	it's a 7 point scale for calculating Risk:
	5-7 High
	3-4 Medium
	0-2 Low
*/

SELECT 
	c.CustomerID,
	b.Contract,
	ch.Tenure,
	b.MonthlyCharges,
	s.OnlineSecurity,
	s.TechSupport,
	ch.Churn,
	
	(
		CASE
			WHEN b.Contract = 'Month-to-month' THEN 2
			ELSE 0
		END

		+

		CASE
			WHEN ch.Tenure <= 12 THEN 2 
			ELSE 0 
		END

		+

		CASE
			WHEN b.MonthlyCharges >= 70 THEN 1  
			ELSE 0 
		END 

		+

		CASE
			WHEN s.OnlineSecurity = 'No' THEN 1 
			ELSE 0 
		END 

		+

		CASE
			WHEN s.TechSupport = 'No' THEN 1 
			ELSE 0 
		END 
	) AS RiskScore

FROM Customers c

INNER JOIN Services s
	ON c.CustomerID = s.CustomerID 

INNER JOIN Billing b
	ON c.CustomerID = b.CustomerID

INNER JOIN Churn ch
	ON c.CustomerID = ch.CustomerID

WHERE ch.Churn = 'No';

--==========================================================
-- Calculating the Risk Score Distribution
--==========================================================

SELECT 
	RiskScore,
	COUNT(*) AS CustomerCount

FROM(
	SELECT 
		c.CustomerID,
		b.Contract,
		ch.Tenure,
		b.MonthlyCharges,
		s.OnlineSecurity,
		s.TechSupport,
		ch.Churn,
	
		(
			CASE
				WHEN b.Contract = 'Month-to-month' THEN 2
				ELSE 0
			END

			+

			CASE
				WHEN ch.Tenure <= 12 THEN 2 
				ELSE 0 
			END

			+

			CASE
				WHEN b.MonthlyCharges >= 70 THEN 1  
				ELSE 0 
			END 

			+

			CASE
				WHEN s.OnlineSecurity = 'No' THEN 1 
				ELSE 0 
			END 

			+

			CASE
				WHEN s.TechSupport = 'No' THEN 1 
				ELSE 0 
			END 
		) AS RiskScore

	FROM Customers c

	INNER JOIN Services s
		ON c.CustomerID = s.CustomerID 

	INNER JOIN Billing b
		ON c.CustomerID = b.CustomerID

	INNER JOIN Churn ch
		ON c.CustomerID = ch.CustomerID

	WHERE ch.Churn = 'No'
) AS RiskData

GROUP BY RiskScore 

ORDER BY RiskScore;

--=======================================================
-- CTE: Another Approach for Calculating the Risk Score Distribution
--=======================================================

WITH RiskData AS(
SELECT 
	c.CustomerID,
	b.Contract,
	ch.Tenure,
	b.MonthlyCharges,
	s.OnlineSecurity,
	s.TechSupport,
	ch.Churn,
	
	(
		CASE
			WHEN b.Contract = 'Month-to-month' THEN 2
			ELSE 0
		END

		+

		CASE
			WHEN ch.Tenure <= 12 THEN 2 
			ELSE 0 
		END

		+

		CASE
			WHEN b.MonthlyCharges >= 70 THEN 1  
			ELSE 0 
		END 

		+

		CASE
			WHEN s.OnlineSecurity = 'No' THEN 1 
			ELSE 0 
		END 

		+

		CASE
			WHEN s.TechSupport = 'No' THEN 1 
			ELSE 0 
		END 
	) AS RiskScore

FROM Customers c

INNER JOIN Services s
	ON c.CustomerID = s.CustomerID 

INNER JOIN Billing b
	ON c.CustomerID = b.CustomerID

INNER JOIN Churn ch
	ON c.CustomerID = ch.CustomerID

WHERE ch.Churn = 'No'
)

SELECT 
	RiskScore,
	COUNT(*) AS CustomerCount
FROM RiskData

GROUP BY RiskScore

ORDER BY RiskScore;


--=========================================
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

    (
        CASE
            WHEN b.Contract = 'Month-to-month' THEN 2
            ELSE 0
        END

        +

        CASE
            WHEN ch.Tenure <= 12 THEN 2
            ELSE 0
        END

        +

        CASE
            WHEN b.MonthlyCharges >= 70 THEN 1
            ELSE 0
        END

        +

        CASE
            WHEN s.OnlineSecurity = 'No' THEN 1
            ELSE 0
        END

        +

        CASE
            WHEN s.TechSupport = 'No' THEN 1
            ELSE 0
        END
    ) AS RiskScore,

    CASE
        WHEN ch.Churn = 'Yes'
            THEN 'N/A'

        WHEN
            (
                CASE
                    WHEN b.Contract = 'Month-to-month' THEN 2
                    ELSE 0
                END

                +

                CASE
                    WHEN ch.Tenure <= 12 THEN 2
                    ELSE 0
                END

                +

                CASE
                    WHEN b.MonthlyCharges >= 70 THEN 1
                    ELSE 0
                END

                +

                CASE
                    WHEN s.OnlineSecurity = 'No' THEN 1
                    ELSE 0
                END

                +

                CASE
                    WHEN s.TechSupport = 'No' THEN 1
                    ELSE 0
                END
            ) >= 5
            THEN 'High Risk'

        WHEN
            (
                CASE
                    WHEN b.Contract = 'Month-to-month' THEN 2
                    ELSE 0
                END

                +

                CASE
                    WHEN ch.Tenure <= 12 THEN 2
                    ELSE 0
                END

                +

                CASE
                    WHEN b.MonthlyCharges >= 70 THEN 1
                    ELSE 0
                END

                +

                CASE
                    WHEN s.OnlineSecurity = 'No' THEN 1
                    ELSE 0
                END

                +

                CASE
                    WHEN s.TechSupport = 'No' THEN 1
                    ELSE 0
                END
            ) >= 3
            THEN 'Medium Risk'

        ELSE 'Low Risk'
    END AS RetentionRisk,

    CAST(
        b.MonthlyCharges * ch.Tenure
        AS DECIMAL(12,2)
    ) AS EstimatedCustomerValue

FROM Customers c

INNER JOIN Services s
    ON c.CustomerID = s.CustomerID

INNER JOIN Billing b
    ON c.CustomerID = b.CustomerID

INNER JOIN Churn ch
    ON c.CustomerID = ch.CustomerID;