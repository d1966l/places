# Australian Places Database

A geodatabase of Australian cities and towns with MSSQL database support.

## Overview

This repository contains a comprehensive dataset of Australian cities and towns that can be imported into Microsoft SQL Server (MSSQL) running on localhost.

## Quick Start

### Automated Setup (Recommended)

**Windows (PowerShell):**
```powershell
.\setup.ps1
```

**Linux/Mac (Bash):**
```bash
./setup.sh
```

### Manual Setup

1. Ensure you have SQL Server installed and running on localhost
2. Execute `schema.sql` to create the database and tables
3. Update the file path in `import_data.sql` to point to your `places.csv` location
4. Execute `import_data.sql` to import the data
5. Use the sample queries in `queries.sql` to explore the data

📖 **See [QUICKSTART.md](QUICKSTART.md) for a step-by-step guide**

## Files

- **places.csv** - CSV file with 50 Australian cities and towns
- **schema.sql** - Database schema creation script
- **import_data.sql** - Data import script
- **queries.sql** - Sample SQL queries
- **setup.ps1** - Automated setup script for Windows
- **setup.sh** - Automated setup script for Linux/Mac
- **QUICKSTART.md** - Quick reference guide
- **SETUP.md** - Detailed setup instructions and documentation

## Database Features

- 50 Australian places (cities and towns)
- Geographic coordinates (latitude/longitude)
- Population data
- State/territory information
- Postal codes
- Indexed for optimal query performance

## Data Fields

Each place record includes:
- PlaceID (unique identifier)
- PlaceName
- State (NSW, VIC, QLD, WA, SA, TAS, ACT, NT)
- PostCode
- Latitude & Longitude
- Population
- PlaceType (City or Town)

## Documentation

For detailed setup instructions, connection strings, and troubleshooting, see [SETUP.md](SETUP.md).

## Requirements

- Microsoft SQL Server (Express, Standard, or Enterprise)
- SQL Server Management Studio or Azure Data Studio (recommended)
- Windows or Linux with SQL Server support
