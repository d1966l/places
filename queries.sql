-- =============================================
-- Sample Queries for Australian Places Database
-- =============================================

USE AustralianPlaces;
GO

-- =============================================
-- Basic Queries
-- =============================================

-- Get all places
SELECT * FROM dbo.Places;

-- Get total count of places
SELECT COUNT(*) AS TotalPlaces FROM dbo.Places;

-- =============================================
-- Search by State
-- =============================================

-- All places in New South Wales
SELECT PlaceName, PlaceType, Population, PostCode
FROM dbo.Places
WHERE State = 'NSW'
ORDER BY Population DESC;

-- All places in Queensland
SELECT PlaceName, PlaceType, Population, PostCode
FROM dbo.Places
WHERE State = 'QLD'
ORDER BY Population DESC;

-- =============================================
-- Search by Place Type
-- =============================================

-- All cities
SELECT PlaceName, State, Population
FROM dbo.Places
WHERE PlaceType = 'City'
ORDER BY Population DESC;

-- All towns
SELECT PlaceName, State, Population
FROM dbo.Places
WHERE PlaceType = 'Town'
ORDER BY Population DESC;

-- =============================================
-- Population Analysis
-- =============================================

-- Top 10 most populous places
SELECT TOP 10 PlaceName, State, Population, PlaceType
FROM dbo.Places
ORDER BY Population DESC;

-- Places with population over 100,000
SELECT PlaceName, State, Population, PlaceType
FROM dbo.Places
WHERE Population > 100000
ORDER BY Population DESC;

-- Average population by state
SELECT 
    State,
    COUNT(*) AS NumberOfPlaces,
    AVG(Population) AS AvgPopulation,
    SUM(Population) AS TotalPopulation
FROM dbo.Places
GROUP BY State
ORDER BY TotalPopulation DESC;

-- Average population by place type
SELECT 
    PlaceType,
    COUNT(*) AS Count,
    AVG(Population) AS AvgPopulation,
    MIN(Population) AS MinPopulation,
    MAX(Population) AS MaxPopulation
FROM dbo.Places
GROUP BY PlaceType;

-- =============================================
-- Geographic Queries
-- =============================================

-- Most northern place
SELECT TOP 1 PlaceName, State, Latitude, Longitude
FROM dbo.Places
ORDER BY Latitude ASC;

-- Most southern place
SELECT TOP 1 PlaceName, State, Latitude, Longitude
FROM dbo.Places
ORDER BY Latitude DESC;

-- Most eastern place
SELECT TOP 1 PlaceName, State, Latitude, Longitude
FROM dbo.Places
ORDER BY Longitude DESC;

-- Most western place
SELECT TOP 1 PlaceName, State, Latitude, Longitude
FROM dbo.Places
ORDER BY Longitude ASC;

-- =============================================
-- Search by Name
-- =============================================

-- Find places with specific name pattern
SELECT PlaceName, State, PlaceType, Population
FROM dbo.Places
WHERE PlaceName LIKE '%Bay%'
ORDER BY PlaceName;

-- Find a specific place
SELECT * FROM dbo.Places
WHERE PlaceName = 'Sydney';

-- =============================================
-- Postal Code Queries
-- =============================================

-- Find place by postal code
SELECT PlaceName, State, PlaceType, Population
FROM dbo.Places
WHERE PostCode = '2000';

-- Group by postal code prefix (first 2 digits)
SELECT 
    LEFT(PostCode, 2) AS PostCodePrefix,
    COUNT(*) AS NumberOfPlaces
FROM dbo.Places
GROUP BY LEFT(PostCode, 2)
ORDER BY PostCodePrefix;

-- =============================================
-- Complex Queries
-- =============================================

-- Rank places by population within each state
SELECT 
    PlaceName,
    State,
    Population,
    PlaceType,
    RANK() OVER (PARTITION BY State ORDER BY Population DESC) AS StateRank
FROM dbo.Places
ORDER BY State, StateRank;

-- Find places within a specific geographic bounding box
-- (Example: South-eastern Australia)
SELECT PlaceName, State, Latitude, Longitude, Population
FROM dbo.Places
WHERE Latitude BETWEEN -45 AND -25
  AND Longitude BETWEEN 140 AND 155
ORDER BY Population DESC;

-- Calculate distance between two places (approximate)
-- Example: Distance from Sydney to Melbourne
DECLARE @SydneyLat DECIMAL(9,6) = -33.8688;
DECLARE @SydneyLon DECIMAL(9,6) = 151.2093;

SELECT 
    PlaceName,
    State,
    SQRT(
        POWER((Latitude - @SydneyLat), 2) + 
        POWER((Longitude - @SydneyLon), 2)
    ) * 111 AS ApproxDistanceKm  -- Rough conversion to kilometers
FROM dbo.Places
WHERE PlaceName != 'Sydney'
ORDER BY ApproxDistanceKm ASC;

-- =============================================
-- Statistics
-- =============================================

-- Overall statistics
SELECT 
    COUNT(*) AS TotalPlaces,
    COUNT(DISTINCT State) AS NumberOfStates,
    SUM(Population) AS TotalPopulation,
    AVG(Population) AS AveragePopulation,
    MIN(Population) AS SmallestPopulation,
    MAX(Population) AS LargestPopulation
FROM dbo.Places;

-- State distribution
SELECT 
    State,
    COUNT(*) AS PlaceCount,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM dbo.Places) AS DECIMAL(5,2)) AS Percentage
FROM dbo.Places
GROUP BY State
ORDER BY PlaceCount DESC;
