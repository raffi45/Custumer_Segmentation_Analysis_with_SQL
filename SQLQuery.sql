use Transac

BEGIN TRANSACTION;
	
SAVE TRANSACTION SP1;

	CREATE TABLE Transaction_Data (
		TransactionID varchar(12),
		TransactionDate DATE,
		ProductID varchar(12),
		ProductName varchar(50),
		Price DECIMAL(10, 2),
		Quantity INT,
		CustomerID INT,
		Country varchar(20)
	);

	BULK INSERT Transaction_Data
	FROM 'C:\Users\lenovo\Documents\SQL Server Management Studio\normalisasi database\data_file\Transaction_data.csv'
	WITH (
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n',
		FIRSTROW = 2
	);

SAVE TRANSACTION SP2;

-- Create the table structure for German customers
	CREATE TABLE Germancustomer (
		TransactionID varchar(12),
		TransactionDate DATE,
		ProductID varchar(12),
		ProductName varchar(50),
		Price DECIMAL(10, 2),
		Quantity INT,
		CustomerID INT,
		Country varchar(20)
	);

-- Insert data into GermanCustomers table
	INSERT INTO germancustomer (Transactionid,TransactionDate, ProductID, ProductName, Price, Quantity, CustomerID, Country)
	SELECT TransactionID, TransactionDate, ProductID, ProductName, Price, Quantity, CustomerID, Country
	FROM Transaction_Data
	WHERE Country = 'Germany';

SAVE TRANSACTION SP3;


-- Create a table to store RFM values
	CREATE TABLE RFM_german (
		CustomerID FLOAT PRIMARY KEY,
		Recency INT,
		Frequency INT,
		Monetary FLOAT
	);

SAVE TRANSACTION SV4;

-- Set a reference date for recency calculations, e.g., the latest date in the dataset
	DECLARE @ReferenceDate DATE = (SELECT MAX(TransactionDate) FROM Germancustomer);
-- Calculate Recency, Frequency, and Monetary values
	INSERT INTO RFM_german(CustomerID, Recency, Frequency, Monetary)
	SELECT
		CustomerID,
		DATEDIFF(DAY, MAX(TransactionDate), @ReferenceDate) AS Recency,
		COUNT(TransactionID) AS Frequency,
		SUM(Price * Quantity) AS Monetary
	FROM
		Germancustomer
	GROUP BY
		CustomerID;



SAVE TRANSACTION SP5;


-- Add RFM rank columns
	ALTER TABLE RFM_german
	ADD RecencyRank INT,
		FrequencyRank INT,
		MonetaryRank INT;

-- Rank the customers based on RFM values
	WITH RankedData AS (
		SELECT 
			CustomerID,
			Recency,
			Frequency,
			Monetary,
			NTILE(5) OVER (ORDER BY Recency) AS RecencyRank,
			NTILE(5) OVER (ORDER BY Frequency DESC) AS FrequencyRank,
			NTILE(5) OVER (ORDER BY Monetary DESC) AS MonetaryRank
		FROM RFM_german
	)
	UPDATE RFM_german
	SET RecencyRank = r.RecencyRank,
		FrequencyRank = r.FrequencyRank,
		MonetaryRank = r.MonetaryRank
	FROM RankedData r
	WHERE RFM_german.CustomerID = r.CustomerID;


SAVE TRANSACTION SP6;


-- Add RFM Score column
	ALTER TABLE RFM_german
	ADD RFMScore INT;

-- Calculate RFM Score
	UPDATE RFM_german
	SET RFMScore = RecencyRank + FrequencyRank + MonetaryRank;


SAVE TRANSACTION SP7;

-- Add a segment column
ALTER TABLE RFM_german
ADD Segment NVARCHAR(50);

-- Update segment based on RFM Score
UPDATE RFM_german
SET Segment = CASE
    WHEN RFMScore >= 12 THEN 'Best Customers'
    WHEN RFMScore BETWEEN 9 AND 11 THEN 'Loyal Customers'
    WHEN RFMScore BETWEEN 6 AND 8 THEN 'Potential Loyalists'
    ELSE 'Regular Customers'
END;

SAVE TRANSACTION SP7;



SELECT * FROM RFM_german;

-- Create a view to display the count of customers based on segmentation
CREATE VIEW german_customers_segmentation AS
SELECT 
    Segment,
    COUNT(CustomerID) AS CustomerCount
FROM 
    RFM_german
GROUP BY 
    Segment;


SELECT * FROM german_customers_segmentation;

COMMIT;


