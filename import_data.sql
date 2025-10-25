-- =============================================
-- Import Data from CSV
-- Description: Imports place data from places.csv into the Places table
-- =============================================

USE AustralianPlaces;
GO

-- Clear existing data (optional - comment out if you want to preserve existing data)
-- TRUNCATE TABLE dbo.Places;
-- GO

-- Import data from CSV file
-- Note: Update the path to match where your places.csv file is located
-- This script assumes the CSV file is in the same directory as the SQL scripts

BULK INSERT dbo.Places
FROM 'C:\path\to\places.csv'  -- UPDATE THIS PATH
WITH (
    FIRSTROW = 2,              -- Skip the header row
    FIELDTERMINATOR = ',',     -- CSV field delimiter
    ROWTERMINATOR = '\n',      -- Row delimiter
    TABLOCK,                   -- Table lock for better performance
    KEEPNULLS,                 -- Keep NULL values
    ERRORFILE = 'C:\path\to\import_errors.txt'  -- UPDATE THIS PATH for error logging
);
GO

-- Verify the import
SELECT COUNT(*) AS TotalRecords FROM dbo.Places;
GO

-- Display sample data
SELECT TOP 10 * FROM dbo.Places ORDER BY PlaceID;
GO

PRINT 'Data import completed!';
PRINT 'Please verify the record count and sample data above.';
