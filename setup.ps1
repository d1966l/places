# PowerShell Script to Setup Australian Places Database
# Usage: .\setup.ps1
# Requirements: SQL Server installed on localhost

param(
    [string]$ServerInstance = "localhost",
    [string]$CsvPath = "",
    [switch]$Help
)

if ($Help) {
    Write-Host @"
Australian Places Database Setup Script

Usage: .\setup.ps1 [-ServerInstance <server>] [-CsvPath <path>]

Parameters:
  -ServerInstance  SQL Server instance (default: localhost)
  -CsvPath         Path to places.csv (default: current directory)
  -Help           Show this help message

Examples:
  .\setup.ps1
  .\setup.ps1 -ServerInstance localhost\SQLEXPRESS
  .\setup.ps1 -CsvPath "C:\Data\places.csv"
"@
    exit
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Australian Places Database Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Determine CSV path
if ([string]::IsNullOrEmpty($CsvPath)) {
    $CsvPath = Join-Path (Get-Location) "places.csv"
}

if (-not (Test-Path $CsvPath)) {
    Write-Host "ERROR: CSV file not found at: $CsvPath" -ForegroundColor Red
    Write-Host "Please specify the correct path using -CsvPath parameter" -ForegroundColor Yellow
    exit 1
}

Write-Host "Configuration:" -ForegroundColor Green
Write-Host "  Server Instance: $ServerInstance"
Write-Host "  CSV File: $CsvPath"
Write-Host ""

# Test SQL Server connection
Write-Host "Step 1: Testing SQL Server connection..." -ForegroundColor Yellow
try {
    $testQuery = "SELECT @@VERSION"
    $result = Invoke-Sqlcmd -ServerInstance $ServerInstance -Query $testQuery -ErrorAction Stop
    Write-Host "  ✓ Connected to SQL Server successfully" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Failed to connect to SQL Server" -ForegroundColor Red
    Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "Troubleshooting tips:" -ForegroundColor Yellow
    Write-Host "  - Ensure SQL Server is installed and running"
    Write-Host "  - Try: .\setup.ps1 -ServerInstance localhost\SQLEXPRESS"
    Write-Host "  - Check Windows Services for SQL Server status"
    exit 1
}

# Create schema
Write-Host ""
Write-Host "Step 2: Creating database and schema..." -ForegroundColor Yellow
try {
    $schemaPath = Join-Path (Get-Location) "schema.sql"
    Invoke-Sqlcmd -ServerInstance $ServerInstance -InputFile $schemaPath -ErrorAction Stop
    Write-Host "  ✓ Database and schema created successfully" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Failed to create schema" -ForegroundColor Red
    Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Import data
Write-Host ""
Write-Host "Step 3: Importing data from CSV..." -ForegroundColor Yellow
try {
    # Create temporary import script with correct path
    $importScript = @"
USE AustralianPlaces;
GO

BULK INSERT dbo.Places
FROM '$CsvPath'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK,
    KEEPNULLS
);
GO

SELECT COUNT(*) AS ImportedRecords FROM dbo.Places;
GO
"@
    
    $tempFile = [System.IO.Path]::GetTempFileName() + ".sql"
    $importScript | Out-File -FilePath $tempFile -Encoding UTF8
    
    $result = Invoke-Sqlcmd -ServerInstance $ServerInstance -InputFile $tempFile -ErrorAction Stop
    Remove-Item $tempFile
    
    $recordCount = $result.ImportedRecords
    Write-Host "  ✓ Data imported successfully: $recordCount records" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Failed to import data" -ForegroundColor Red
    Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Red
    if (Test-Path $tempFile) { Remove-Item $tempFile }
    exit 1
}

# Verify installation
Write-Host ""
Write-Host "Step 4: Verifying installation..." -ForegroundColor Yellow
try {
    $verifyQuery = @"
USE AustralianPlaces;
SELECT TOP 5 PlaceName, State, Population, PlaceType 
FROM dbo.Places 
ORDER BY Population DESC;
"@
    $result = Invoke-Sqlcmd -ServerInstance $ServerInstance -Query $verifyQuery -ErrorAction Stop
    Write-Host "  ✓ Verification successful" -ForegroundColor Green
    Write-Host ""
    Write-Host "Top 5 places by population:" -ForegroundColor Cyan
    $result | Format-Table -AutoSize
} catch {
    Write-Host "  ✗ Verification failed" -ForegroundColor Red
    Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Connection String:" -ForegroundColor Yellow
Write-Host "  Server=$ServerInstance;Database=AustralianPlaces;Trusted_Connection=True;" -ForegroundColor White
Write-Host ""
Write-Host "Try some queries:" -ForegroundColor Yellow
Write-Host "  sqlcmd -S $ServerInstance -E -d AustralianPlaces" -ForegroundColor White
Write-Host "  Or open queries.sql in SQL Server Management Studio" -ForegroundColor White
Write-Host ""
