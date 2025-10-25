# Quick Reference Guide

## Quick Setup (3 Steps)

### Step 1: Create the Database
```sql
-- Run this in SQL Server Management Studio or Azure Data Studio
-- Execute: schema.sql
```

### Step 2: Import the Data
```sql
-- Before running import_data.sql:
-- 1. Open import_data.sql
-- 2. Change line 15 from:
FROM 'C:\path\to\places.csv'
-- To your actual path, for example:
FROM 'C:\Users\YourName\Downloads\places\places.csv'

-- 3. Execute: import_data.sql
```

### Step 3: Query the Data
```sql
-- Run sample queries from queries.sql
-- Or try this simple query:
SELECT * FROM AustralianPlaces.dbo.Places;
```

## Connection String Templates

### Windows Authentication (Recommended)
```
Server=localhost;Database=AustralianPlaces;Trusted_Connection=True;
```

### SQL Authentication
```
Server=localhost;Database=AustralianPlaces;User Id=sa;Password=YourPassword;
```

## Common Commands

### Connect via sqlcmd
```bash
sqlcmd -S localhost -E -d AustralianPlaces
```

### Quick Queries
```sql
-- Count all places
SELECT COUNT(*) FROM Places;

-- Top 5 cities by population
SELECT TOP 5 PlaceName, Population FROM Places ORDER BY Population DESC;

-- All places in NSW
SELECT PlaceName, Population FROM Places WHERE State = 'NSW';
```

## Troubleshooting

### Can't find the CSV file?
- Use the full absolute path (e.g., `C:\Users\YourName\Documents\places.csv`)
- Make sure there are no typos in the path
- Check that SQL Server has read access to the file location

### SQL Server not found?
- Try `localhost\SQLEXPRESS` instead of `localhost`
- Check if SQL Server service is running: Services → SQL Server
- Verify SQL Server is installed and configured

### Permission denied?
- Run SSMS as Administrator
- Ensure your Windows user has SQL Server permissions
- Try using SQL Server Authentication instead

## File Descriptions

| File | Purpose |
|------|---------|
| `places.csv` | The source data (50 Australian places) |
| `schema.sql` | Creates database and table structure |
| `import_data.sql` | Loads CSV data into database |
| `queries.sql` | Sample queries to explore the data |
| `SETUP.md` | Detailed documentation |

## Data Structure

```
AustralianPlaces (Database)
  └── Places (Table)
      ├── PlaceID (Primary Key)
      ├── PlaceName
      ├── State (NSW, VIC, QLD, WA, SA, TAS, ACT, NT)
      ├── PostCode
      ├── Latitude
      ├── Longitude
      ├── Population
      └── PlaceType (City or Town)
```

## Next Steps

1. ✅ Database is set up
2. ✅ Data is imported
3. 📊 Try the sample queries in `queries.sql`
4. 🔌 Connect your application using the connection strings above
5. 🚀 Build your application!

For detailed help, see [SETUP.md](SETUP.md)
