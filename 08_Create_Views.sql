--==============================================
--Creating Views
--==============================================

================================================
--View 1: Customer Churn Analysis
--==============================================

CREATE VIEW vw_CustomerChurnAnalysis
AS

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


/* Test the View */

SELECT TOP 10 *
FROM vw_CustomerChurnAnalysis;

/* Check the total number of rows */

SELECT COUNT(*) AS TotalRows
FROM vw_CustomerChurnAnalysis;

/* Check for Duplicate Customers */

SELECT 
    CustomerID,
    COUNT(*) AS TotalCount
FROM vw_CustomerChurnAnalysis
GROUP BY CustomerID
HAVING COUNT(*) > 1;


--====================================================
--View 2: Churn Analysis by Contract
--====================================================

CREATE VIEW vw_ChurnByContract
AS

SELECT
    b.Contract,

    Count(*) AS TotalCustomers,

    SUM(
        CASE
            WHEN ch.Churn = 'Yes' THEN 1
            ELSE 0
        END
     ) AS ChurnedCustomers,

     CAST(
        100 * 
        SUM(
            CASE
                WHEN ch.Churn = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*)
        AS DECIMAL(5,2)
    ) AS ChurnRate

FROM Billing b

INNER JOIN Churn ch
ON b.CustomerID = ch.CustomerID

GROUP BY b.Contract;


/* Test the view */

SELECT *
FROM vw_ChurnByContract
ORDER BY ChurnRate DESC;

/* Validate the View */

SELECT
    SUM(TotalCustomers) AS TotalCustomers,
    SUM(ChurnedCustomers) AS TotalChurnedCustomers
FROM vw_ChurnByContract;

SELECT COUNT(*) AS TotalChurnedCustomers
FROM Churn
WHERE Churn = 'Yes';


--============================================
--View 3: Churn Analysis by Tenure
--============================================

CREATE VIEW vw_ChurnByTenure
AS

SELECT 
    CASE
        WHEN ch.Tenure <= 12 THEN '0-12 Months'
        WHEN ch.Tenure <= 24 THEN '13-24 Months'
        WHEN ch.Tenure <= 48 THEN '25-48 Months'
        ELSE '49+ Months'
    END,

    COUNT(*) AS TotalCustomers,

    SUM(
        CASE
            WHEN ch.Churn = 'Yes' THEN 1
            ELSE 0
        END
    ) AS ChurnedCustomer,

    CAST(
        100 *
        SUM(
            CASE
                WHEN ch.Churn = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*) 
        AS DECIMAL(5,2)
    ) AS ChurnRate

FROM Churn ch

GROUP BY
    CASE
        WHEN ch.Tenure <= 12 THEN '0-12 Months'
        WHEN ch.Tenure <= 24 THEN '13-24 Months'
        WHEN ch.Tenure <= 48 THEN '25-48 Months'
        ELSE '49+ Months'
    END;


/* Validate the view */

SELECT
    SUM(TotalCustomers) AS TotalCustomers,
    SUM(ChurnedCustomers) AS TotalChurnedCustomers
FROM vw_ChurnByTenure;

SELECT COUNT(*) AS TotalChurnedCustomers
FROM Churn
WHERE Churn = 'Yes';


--============================================
--View 4: Customer Risk Analysis
--============================================
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

CREATE VIEW vw_CustomerRisk
AS

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

)

SELECT
    CustomerID,
    Contract,
    Tenure,
    MonthlyCharges,
    Churn,

    CASE
        WHEN Churn = 'Yes' THEN 'Churned'
        ELSE 'Retained'
    END AS ChurnStatus,

    RiskScore,

    CASE
        WHEN churn= 'Yes' 
            THEN 'N/A'

        WHEN RiskScore >= 5 
            THEN 'High Risk'

        WHEN RiskScore >= 3 
            THEN 'Medium Risk'

        ELSE 'Low Risk'
    END AS RetentionRisk,

    CAST(
        MonthlyCharges * Tenure
        AS DECIMAL(12,2)
    ) AS EstimatedCustomerValue

FROM RiskData;


/* Test the view */

SELECT TOP 20
    CustomerID,
    Contract,
    Tenure,
    MonthlyCharges,
    ChurnStatus,
    RiskScore,
    RetentionRisk,
    EstimatedCustomerValue
FROM vw_CustomerRisk
ORDER BY RiskScore DESC;

/* Check the Risk Count */

SELECT 
    RetentionRisk,
    COUNT(*) AS TotalCustomers

FROM vw_CustomerRisk

WHERE ChurnStatus = 'Retained'

GROUP BY RetentionRisk

ORDER BY
    CASE
        WHEN RetentionRisk = 'High Risk' THEN 1
        WHEN RetentionRisk = 'Medium Risk' THEN 2
        WHEN RetentionRisk = 'Low Risk' THEN 3
    END;


/* Checking High Risk Customer Value */

SELECT
    COUNT(*) AS HighRiskCustomers,
    MIN(EstimatedCustomerValue) AS MinValue,
    MAX(EstimatedCustomerValue) AS MaxValue,
    AVG(EstimatedCustomerValue) AS AvgValue

FROM vw_CustomerRisk

WHERE RetentionRisk = 'High Risk';


/* Calculating the threshold */

SELECT DISTINCT 
    PERCENTILE_CONT(0.75)
    WITHIN GROUP (ORDER BY EstimatedCustomerValue)
    OVER() AS Value75thPercentile
FROM vw_CustomerRisk
WHERE ChurnStatus = 'Retained';


--============================================
--View 5: 
--============================================

/* With threshold value = 4244.8125 that is calculated above */


CREATE VIEW vw_HighValueRiskCustomers
AS

SELECT
    CustomerID,
    Contract,
    Tenure,
    MonthlyCharges,
    ChurnStatus,
    RiskScore,
    RetentionRisk,
    EstimatedCustomerValue

FROM vw_CustomerRisk

WHERE ChurnStatus = 'Retained'
    AND RetentionRisk = 'High Risk'
    AND EstimatedCustomerValue >= 4244.8125;


/* Test the view */

SELECT *
FROM vw_HighValueRiskCustomers
ORDER BY EstimatedCustomerValue DESC;

/* Total Priority Customer Count (High Risk+High Value) */

SELECT 
    COUNT(*) AS PriorityCustomerCount,

    CAST(
        SUM(EstimatedCustomerValue)
        AS DECIMAL(14,2)
    ) AS TotalEstimatedValue,

    CAST(
        AVG(EstimatedCustomerValue)
        AS DECIMAL(14,2)
    ) AS AverageEstimatedValue

FROM vw_HighValueRiskCustomers;


--=====================================================================
-- Final Validation of all the Views
--=====================================================================

-- View 1

SELECT COUNT(*) AS TotalCustomers
FROM vw_CustomerChurnAnalysis;

-- View 2

SELECT *
FROM vw_ChurnByContract
ORDER BY ChurnRate DESC;
    
-- View 3

SELECT *
FROM vw_ChurnByTenure
ORDER BY ChurnRate DESC;

-- View 4

SELECT 
    RetentionRisk,
    COUNT(*) AS CustomerCount
FROM vw_CustomerRisk
GROUP BY RetentionRisk
ORDER BY(
    CASE
        WHEN RetentionRisk = 'High Risk' THEN 1
        WHEN RetentionRisk = 'Medium Risk' THEN 2
        WHEN RetentionRisk = 'Low Risk' THEN 3
        ELSE 4
    END
);

select *
from vw_CustomerRisk;
