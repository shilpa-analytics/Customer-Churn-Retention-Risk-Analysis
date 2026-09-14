/* Loading Data from Staging Table */

-- Inspect the data in the Staging Data Table
SELECT TOP 10 * 
FROM StagingCustomerData;

/* Data Quality Check
Missing Customer IDs */
SELECT *
FROM StagingCustomerData
WHERE CustomerID IS NULL;

--Duplicate Custome IDs
SELECT CustomerID, COUNT(*)
FROM StagingCustomerData
GROUP BY CustomerID
HAVING COUNT(*) > 1;

--Blank Total Charges
SELECT * 
FROM StagingCustomerData
WHERE TotalCharges IS NULL;


/* Insert Data from Staging Table into Final 4 Tables

Load Customers Table */

INSERT INTO Customers
(
	CustomerID,
	Gender,
	SeniorCitizen,
	Partner,
	Dependents
)
SELECT
	CustomerID,
	Gender,
	CAST (SeniorCitizen AS BIT),
	Partner,
	Dependents
FROM StagingCustomerData;

--Verfiy Customers Table
SELECT COUNT(*) AS Customer_Count
FROM Customers;

--Load Services Table
INSERT INTO Services
(
	CustomerID,
	PhoneService,
	MultipleLines,
	InternetService,
	OnlineSecurity,
	OnlineBackup,
	DeviceProtection,
	TechSupport,
	StreamingTV,
	StreamingMovies
)
SELECT
	CustomerID,
	PhoneService,
	MultipleLines,
	InternetService,
	OnlineSecurity,
	OnlineBackup,
	DeviceProtection,
	TechSupport,
	StreamingTV,
	StreamingMovies
FROM StagingCustomerData;

--Verify Services Table
SELECT COUNT(*) AS Services_Count
FROM Services;

--Load Billing Table
INSERT INTO Billing
(
	CustomerID,
	Contract,
	PaperlessBilling,
	PaymentMethod,
	MonthlyCharges,
	TotalCharges
)
SELECT
	CustomerID,
	Contract,
	PaperlessBilling,
	PaymentMethod,
	TRY_CAST(MonthlyCharges AS DECIMAL(10,2)),
	TRY_CAST(NULLIF(TotalCharges,'') AS DECIMAL(10,2))
FROM StagingCustomerData;

--Verify Billing Table
SELECT COUNT(*) AS Billing_Count
FROM Billing;

--Load Churn Data
INSERT INTO Churn
(
	CustomerID,
	Tenure,
	Churn
)
SELECT
	CustomerID,
	CAST(Tenure AS INT),
	Churn
FROM StagingCustomerData;

--Verify Churn Table
SELECT COUNT(*) AS Churn_Count
FROM Churn;

