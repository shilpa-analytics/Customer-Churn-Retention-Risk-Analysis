IF NOT EXISTS(
SELECT *
FROM sys.databases
WHERE name = 'CustomerChurnDB')
BEGIN
	CREATE DATABASE CustomerChurnDB;
END
GO

USE CustomerChurnDB;
GO