-- =============================================
-- Create Database: AustralianPlaces
-- Description: Database for Australian cities and towns
-- =============================================

-- Create the database
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'AustralianPlaces')
BEGIN
    CREATE DATABASE AustralianPlaces;
END
GO

-- Use the database
USE AustralianPlaces;
GO

-- =============================================
-- Create Table: Places
-- Description: Stores information about Australian cities and towns
-- =============================================

-- Drop table if exists (for re-creation)
IF OBJECT_ID('dbo.Places', 'U') IS NOT NULL
    DROP TABLE dbo.Places;
GO

-- Create the Places table
CREATE TABLE dbo.Places (
    PlaceID INT PRIMARY KEY,
    PlaceName NVARCHAR(100) NOT NULL,
    State NVARCHAR(3) NOT NULL,
    PostCode NVARCHAR(4) NOT NULL,
    Latitude DECIMAL(9,6) NOT NULL,
    Longitude DECIMAL(9,6) NOT NULL,
    Population INT NULL,
    PlaceType NVARCHAR(20) NOT NULL,
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE()
);
GO

-- Create indexes for better query performance
CREATE INDEX IX_Places_State ON dbo.Places(State);
CREATE INDEX IX_Places_PlaceType ON dbo.Places(PlaceType);
CREATE INDEX IX_Places_PlaceName ON dbo.Places(PlaceName);
GO

-- Create a view for easy querying
CREATE VIEW dbo.vw_PlacesSummary
AS
SELECT 
    PlaceID,
    PlaceName,
    State,
    PostCode,
    Latitude,
    Longitude,
    Population,
    PlaceType
FROM dbo.Places;
GO

PRINT 'Database schema created successfully!';
