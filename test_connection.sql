-- =============================================
-- Test Database Connection
-- Description: Simple script to verify database setup and connectivity
-- =============================================

-- Test 1: Check if database exists
PRINT '=== Test 1: Database Existence ===';
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'AustralianPlaces')
    PRINT '✓ Database "AustralianPlaces" exists';
ELSE
    PRINT '✗ Database "AustralianPlaces" does NOT exist';
PRINT '';

-- Test 2: Check if table exists
PRINT '=== Test 2: Table Existence ===';
USE AustralianPlaces;
IF OBJECT_ID('dbo.Places', 'U') IS NOT NULL
    PRINT '✓ Table "Places" exists';
ELSE
    PRINT '✗ Table "Places" does NOT exist';
PRINT '';

-- Test 3: Check record count
PRINT '=== Test 3: Record Count ===';
DECLARE @RecordCount INT;
SELECT @RecordCount = COUNT(*) FROM dbo.Places;
PRINT 'Total records in Places table: ' + CAST(@RecordCount AS VARCHAR(10));
IF @RecordCount = 50
    PRINT '✓ Expected 50 records found';
ELSE IF @RecordCount > 0
    PRINT '⚠ Found ' + CAST(@RecordCount AS VARCHAR(10)) + ' records (expected 50)';
ELSE
    PRINT '✗ No records found - data may not be imported';
PRINT '';

-- Test 4: Check indexes
PRINT '=== Test 4: Indexes ===';
SELECT 
    i.name AS IndexName,
    CASE WHEN i.is_primary_key = 1 THEN 'Primary Key' ELSE 'Index' END AS IndexType
FROM sys.indexes i
WHERE i.object_id = OBJECT_ID('dbo.Places')
  AND i.name IS NOT NULL
ORDER BY i.is_primary_key DESC, i.name;
PRINT '';

-- Test 5: Sample data retrieval
PRINT '=== Test 5: Sample Data ===';
SELECT TOP 5
    PlaceID,
    PlaceName,
    State,
    PlaceType,
    FORMAT(Population, 'N0') AS Population
FROM dbo.Places
ORDER BY Population DESC;
PRINT '';

-- Test 6: Check data types
PRINT '=== Test 6: Table Schema ===';
SELECT 
    c.name AS ColumnName,
    t.name AS DataType,
    c.max_length AS MaxLength,
    c.is_nullable AS IsNullable
FROM sys.columns c
INNER JOIN sys.types t ON c.user_type_id = t.user_type_id
WHERE c.object_id = OBJECT_ID('dbo.Places')
ORDER BY c.column_id;
PRINT '';

-- Test 7: State distribution
PRINT '=== Test 7: State Distribution ===';
SELECT 
    State,
    COUNT(*) AS PlaceCount
FROM dbo.Places
GROUP BY State
ORDER BY PlaceCount DESC;
PRINT '';

-- Test 8: View existence
PRINT '=== Test 8: Views ===';
IF OBJECT_ID('dbo.vw_PlacesSummary', 'V') IS NOT NULL
    PRINT '✓ View "vw_PlacesSummary" exists';
ELSE
    PRINT '✗ View "vw_PlacesSummary" does NOT exist';
PRINT '';

-- Summary
PRINT '=== Summary ===';
PRINT 'All tests completed. Review results above.';
PRINT 'If all tests passed with ✓, your database is ready to use!';
PRINT '';
PRINT 'Connection String:';
PRINT 'Server=localhost;Database=AustralianPlaces;Trusted_Connection=True;';
