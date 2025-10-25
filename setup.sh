#!/bin/bash
# Bash Script to Setup Australian Places Database on SQL Server for Linux
# Usage: ./setup.sh [server_instance] [csv_path]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Default values
SERVER_INSTANCE="${1:-localhost}"
CSV_PATH="${2:-$(pwd)/places.csv}"

echo -e "${CYAN}========================================"
echo "Australian Places Database Setup"
echo -e "========================================${NC}"
echo ""

# Check if sqlcmd is installed
if ! command -v sqlcmd &> /dev/null; then
    echo -e "${RED}ERROR: sqlcmd is not installed${NC}"
    echo -e "${YELLOW}Please install SQL Server command-line tools${NC}"
    echo "Visit: https://docs.microsoft.com/en-us/sql/linux/sql-server-linux-setup-tools"
    exit 1
fi

# Check if CSV file exists
if [ ! -f "$CSV_PATH" ]; then
    echo -e "${RED}ERROR: CSV file not found at: $CSV_PATH${NC}"
    echo -e "${YELLOW}Please provide the correct path as second argument${NC}"
    echo "Usage: ./setup.sh [server_instance] [csv_path]"
    exit 1
fi

echo -e "${GREEN}Configuration:${NC}"
echo "  Server Instance: $SERVER_INSTANCE"
echo "  CSV File: $CSV_PATH"
echo ""

# Test SQL Server connection
echo -e "${YELLOW}Step 1: Testing SQL Server connection...${NC}"
if sqlcmd -S "$SERVER_INSTANCE" -Q "SELECT @@VERSION" > /dev/null 2>&1; then
    echo -e "${GREEN}  ✓ Connected to SQL Server successfully${NC}"
else
    echo -e "${RED}  ✗ Failed to connect to SQL Server${NC}"
    echo ""
    echo -e "${YELLOW}Troubleshooting tips:${NC}"
    echo "  - Ensure SQL Server is installed and running"
    echo "  - Check if SQL Server service is running: systemctl status mssql-server"
    echo "  - Verify connection settings"
    exit 1
fi

# Create schema
echo ""
echo -e "${YELLOW}Step 2: Creating database and schema...${NC}"
if sqlcmd -S "$SERVER_INSTANCE" -i schema.sql > /dev/null; then
    echo -e "${GREEN}  ✓ Database and schema created successfully${NC}"
else
    echo -e "${RED}  ✗ Failed to create schema${NC}"
    exit 1
fi

# Import data - create temporary import script with correct path
echo ""
echo -e "${YELLOW}Step 3: Importing data from CSV...${NC}"

# Create temporary SQL file with correct CSV path
TEMP_SQL=$(mktemp)
cat > "$TEMP_SQL" << EOF
USE AustralianPlaces;
GO

BULK INSERT dbo.Places
FROM '$CSV_PATH'
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
EOF

if sqlcmd -S "$SERVER_INSTANCE" -i "$TEMP_SQL"; then
    echo -e "${GREEN}  ✓ Data imported successfully${NC}"
    rm "$TEMP_SQL"
else
    echo -e "${RED}  ✗ Failed to import data${NC}"
    rm "$TEMP_SQL"
    echo ""
    echo -e "${YELLOW}Note: The SQL Server service account must have read access to the CSV file${NC}"
    echo "Try copying the CSV to /tmp/ and granting appropriate permissions"
    exit 1
fi

# Verify installation
echo ""
echo -e "${YELLOW}Step 4: Verifying installation...${NC}"
VERIFY_SQL=$(mktemp)
cat > "$VERIFY_SQL" << EOF
USE AustralianPlaces;
SELECT TOP 5 PlaceName, State, Population, PlaceType 
FROM dbo.Places 
ORDER BY Population DESC;
GO
EOF

if sqlcmd -S "$SERVER_INSTANCE" -i "$VERIFY_SQL"; then
    echo -e "${GREEN}  ✓ Verification successful${NC}"
    rm "$VERIFY_SQL"
else
    echo -e "${RED}  ✗ Verification failed${NC}"
    rm "$VERIFY_SQL"
fi

echo ""
echo -e "${CYAN}========================================"
echo -e "${GREEN}Setup Complete!${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""
echo -e "${YELLOW}Connection String:${NC}"
echo "  Server=$SERVER_INSTANCE;Database=AustralianPlaces;Trusted_Connection=True;"
echo ""
echo -e "${YELLOW}Try some queries:${NC}"
echo "  sqlcmd -S $SERVER_INSTANCE -E -d AustralianPlaces"
echo "  Or run queries from queries.sql"
echo ""
