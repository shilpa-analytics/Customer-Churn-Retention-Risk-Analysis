/* Data Validation Checks */

/*Row Count Validation */
SELECT 'Customers' AS Table_Name, COUNT(*) AS ROW_COUNT
FROM Customers

UNION ALL

SELECT 'Services', COUNT(*)
FROM Services

UNION ALL

SELECT 'Billing', COUNT(*)
FROM Billing

UNION ALL

SELECT 'Churn', COUNT(*)
FROM Churn;

/* Check Duplicate Customer IDs */

--Customers Table
SELECT CustomerID, COUNT(*) AS Duplicate_Count
FROM Customers
GROUP BY CustomerID
HAVING COUNT(*) > 1;

--Services Table
SELECT CustomerID, COUNT(*) AS Duplicate_Count
FROM Services
GROUP BY CustomerID
HAVING COUNT(*) > 1;

--Billing Table
SELECT CustomerID, COUNT(*) AS Duplicate_Count
FROM Billing
GROUP BY CustomerID
HAVING COUNT(*) > 1;

--Churn Table
SELECT CustomerID, COUNT(*) AS Duplicate_Count
FROM Churn
GROUP BY CustomerID
HAVING COUNT(*) > 1;

/* Check Missing Values */

--Check CutomerID in Customers Table
SELECT *
FROM Customers
WHERE CustomerID IS NULL;

--Check Gender in Customers Table
SELECT *
FROM Customers
WHERE Gender IS NULL;

--Check CutomerID in Services Table
SELECT *
FROM Services
WHERE CustomerID IS NULL;

--Check CutomerID in Billing Table
SELECT *
FROM Billing
WHERE CustomerID IS NULL;

--Check MonthlyCharges in Billing Table
SELECT *
FROM Billing
WHERE MonthlyCharges IS NULL;

--Check TotalCharges in Billing Table
SELECT COUNT(*) AS Misiing_TotalCharges
FROM Billing
WHERE TotalCharges IS NULL;

--Check CutomerID in Churn Table
SELECT *
FROM Churn
WHERE CustomerID IS NULL;


/* Referential Integrity Check -
Every CustomerID in Services, Billing, and Churn exists in Customers */

--Check Services - Shows the Service records that do not have any matching cutomers.
SELECT s.CustomerID
FROM Services s
LEFT JOIN Customers c
	ON s.CustomerID = c.CustomerID
WHERE C.CustomerID IS NULL;

--Check Billing - Shows the Billing records that do not have any matching cutomers.
SELECT b.CustomerID
FROM Billing b
LEFT JOIN Customers c
	ON b.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL;

--Checking Churn - Shows the Churn records that do not have any matching cutomers
SELECT ch.CustomerID
FROM Churn ch
LEFT JOIN Customers c
	ON ch.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL;

/* Check Relationships using JOIN */

SELECT TOP 10
	c.CustomerID,
	c.Gender,
	s.InternetService,
	b.MonthlyCharges,
	ch.Churn
FROM Customers c
JOIN Services s
	ON c.CustomerID = s.CustomerID
JOIN Billing b
	ON c.CustomerID = b.CustomerID
JOIN Churn ch
	ON c.CustomerID = ch.CustomerID;