IF OBJECT_ID('Customers','U') IS NULL
BEGIN
	CREATE TABLE Customers
	(
		CustomerID VARCHAR(20) NOT NULL,
		Gender VARCHAR(10) NOT NULL,
		SeniorCitizen BIT NOT NULL,
		Partner VARCHAR(3) NOT NULL,
		Dependents VARCHAR(3) NOT NULL,

		CONSTRAINT PK_Customers
			PRIMARY KEY (CustomerID)
	);
END
GO

IF OBJECT_ID('Services','U') IS NULL
BEGIN
	CREATE TABLE Services
	(
		CustomerID VARCHAR(20) NOT NULL,
		PhoneService VARCHAR(3) NOT NULL,
		MultipleLines VARCHAR(20) NOT NULL,
		InternetService VARCHAR(20) NOT NULL,
		OnlineSecurity VARCHAR(20) NOT NULL,
		OnlineBackup VARCHAR(20) NOT NULL,
		DeviceProtection VARCHAR(20) NOT NULL,
		TechSupport VARCHAR(20) NOT NULL,
		StreamingTV VARCHAR(20) NOT NULL,
		StreamingMovies VARCHAR(20) NOT NULL,

		CONSTRAINT PK_Services
			PRIMARY KEY (CustomerID),

		CONSTRAINT FK_Services_Customers
			FOREIGN KEY (CustomerID)
			REFERENCES Customers(CustomerID)
	);
END
GO

IF OBJECT_ID('Billing','U') IS NULL
BEGIN
	CREATE TABLE Billing
	(
		CustomerID VARCHAR(20) NOT NULL,
		Contract VARCHAR(20) NOT NULL,
		PaperlessBilling VARCHAR(3) NOT NULL,
		PaymentMethod VARCHAR(50) NOT NULL,
		MonthlyCharges DECIMAL(10,2) NOT NULL,
		TotalCharges DECIMAL(10,2) NOT NULL,

		CONSTRAINT PK_Billing
			PRIMARY KEY (CustomerID),

		CONSTRAINT FK_Billing_Customers
			FOREIGN KEY (CustomerID)
			REFERENCES Customers(CustomerID)
	);
END
GO

IF OBJECT_ID('Churn','U') IS NULL
BEGIN
	CREATE TABLE Churn
	(
		CustomerID VARCHAR(20) NOT NULL,
		Tenure INT NOT NULL,
		Churn VARCHAR(3) NOT NULL,

		CONSTRAINT PK_Churn
			PRIMARY KEY (CustomerID),

		CONSTRAINT FK_Churn_Customers
			FOREIGN KEY (CustomerID)
			REFERENCES Customers(CustomerID)
	);
END
GO