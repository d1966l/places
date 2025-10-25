# Australian Places Database Setup Guide

This repository contains data and SQL scripts for setting up an MSSQL database of Australian cities and towns.

## Contents

- `places.csv` - CSV file containing Australian places data
- `schema.sql` - SQL script to create the database and table structure
- `import_data.sql` - SQL script to import CSV data into MSSQL
- `queries.sql` - Sample queries to work with the data

## Database Schema

The database `AustralianPlaces` contains one main table:

### Places Table

| Column | Type | Description |
|--------|------|-------------|
| PlaceID | INT | Primary key, unique identifier for each place |
| PlaceName | NVARCHAR(100) | Name of the city or town |
| State | NVARCHAR(3) | Australian state/territory code (NSW, VIC, QLD, etc.) |
| PostCode | NVARCHAR(4) | Australian postal code |
| Latitude | DECIMAL(9,6) | Geographic latitude |
| Longitude | DECIMAL(9,6) | Geographic longitude |
| Population | INT | Approximate population |
| PlaceType | NVARCHAR(20) | Type of place (City or Town) |
| CreatedDate | DATETIME | Record creation timestamp |
| ModifiedDate | DATETIME | Record modification timestamp |

## Prerequisites

- Microsoft SQL Server installed and running on localhost
- SQL Server Management Studio (SSMS) or Azure Data Studio
- Windows Authentication or SQL Server Authentication configured
- Appropriate permissions to create databases and tables

## Setup Instructions

### Option 1: Using SQL Server Management Studio (SSMS)

1. **Connect to SQL Server**
   - Open SQL Server Management Studio
   - Connect to your localhost instance (usually `localhost` or `.\SQLEXPRESS`)

2. **Create Database and Schema**
   - Open `schema.sql` in SSMS
   - Execute the script (F5 or click Execute)
   - This creates the `AustralianPlaces` database and `Places` table

3. **Import CSV Data**
   - Open `import_data.sql` in SSMS
   - **IMPORTANT**: Update the file path on line 15 to point to your `places.csv` location
     ```sql
     FROM 'C:\path\to\places.csv'  -- Change this to actual path
     ```
   - Also update the error file path on line 21
   - Execute the script to import the data

4. **Verify Import**
   - The script will display the total record count and sample data
   - You should see 50 records imported

### Option 2: Using sqlcmd (Command Line)

```bash
# Create schema
sqlcmd -S localhost -E -i schema.sql

# Update paths in import_data.sql first, then import data
sqlcmd -S localhost -E -i import_data.sql
```

### Option 3: Using Azure Data Studio

1. Connect to localhost SQL Server instance
2. Open and execute `schema.sql`
3. Update paths in `import_data.sql`
4. Execute `import_data.sql`

## Connection Strings

### C# / .NET
```csharp
// Windows Authentication
string connectionString = "Server=localhost;Database=AustralianPlaces;Trusted_Connection=True;";

// SQL Server Authentication
string connectionString = "Server=localhost;Database=AustralianPlaces;User Id=youruser;Password=yourpassword;";
```

### Python (pyodbc)
```python
import pyodbc

# Windows Authentication
conn = pyodbc.connect(
    'DRIVER={ODBC Driver 17 for SQL Server};'
    'SERVER=localhost;'
    'DATABASE=AustralianPlaces;'
    'Trusted_Connection=yes;'
)
```

### Node.js (mssql)
```javascript
const sql = require('mssql');

const config = {
    server: 'localhost',
    database: 'AustralianPlaces',
    options: {
        trustedConnection: true,
        trustServerCertificate: true
    }
};
```

### JDBC
```java
String url = "jdbc:sqlserver://localhost;databaseName=AustralianPlaces;integratedSecurity=true;";
```

## Sample Queries

See `queries.sql` for example queries including:
- Searching by state
- Finding cities vs towns
- Population analysis
- Geographic queries

## Troubleshooting

### Cannot bulk load. The file does not exist
- Ensure the path in `import_data.sql` points to the actual location of `places.csv`
- Use absolute paths (e.g., `C:\Users\YourName\Downloads\places.csv`)
- Ensure SQL Server service account has read access to the file location

### Access denied
- The SQL Server service account needs read permissions on the CSV file and its directory
- Try copying the CSV file to a location like `C:\Temp\` and granting Everyone read access

### Cannot open database "AustralianPlaces"
- Ensure `schema.sql` was executed successfully first
- Check that the database was created: `SELECT name FROM sys.databases WHERE name = 'AustralianPlaces'`

### Wrong number of records imported
- Check the error file specified in `import_data.sql`
- Verify the CSV file format matches the expected structure
- Ensure FIRSTROW = 2 to skip the header row

## Data Source

The places data includes major Australian cities and towns with:
- Approximate population figures
- Geographic coordinates (latitude/longitude)
- State/territory classifications
- Postal codes

## License

This is a sample dataset for educational and development purposes.
