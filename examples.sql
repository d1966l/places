-- Example C# code to connect to Australian Places database
-- This is a comment file showing example code (not executable)

/*
==============================================================================
C# Console Application Example
==============================================================================
*/

using System;
using System.Data.SqlClient;

namespace AustralianPlacesExample
{
    class Program
    {
        static void Main(string[] args)
        {
            // Connection string - update as needed
            string connectionString = "Server=localhost;Database=AustralianPlaces;Trusted_Connection=True;";
            
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionString))
                {
                    connection.Open();
                    Console.WriteLine("Connected to database successfully!\n");
                    
                    // Query 1: Get all cities
                    string query1 = @"
                        SELECT PlaceName, State, Population 
                        FROM Places 
                        WHERE PlaceType = 'City' 
                        ORDER BY Population DESC";
                    
                    using (SqlCommand command = new SqlCommand(query1, connection))
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        Console.WriteLine("Top Cities by Population:");
                        Console.WriteLine("{0,-20} {1,-5} {2,15}", "City", "State", "Population");
                        Console.WriteLine(new string('-', 45));
                        
                        while (reader.Read())
                        {
                            string placeName = reader["PlaceName"].ToString();
                            string state = reader["State"].ToString();
                            int population = Convert.ToInt32(reader["Population"]);
                            Console.WriteLine("{0,-20} {1,-5} {2,15:N0}", placeName, state, population);
                        }
                    }
                    
                    Console.WriteLine("\n\nQuery 2: Places in New South Wales");
                    
                    string query2 = @"
                        SELECT PlaceName, PlaceType, Population 
                        FROM Places 
                        WHERE State = @State 
                        ORDER BY Population DESC";
                    
                    using (SqlCommand command = new SqlCommand(query2, connection))
                    {
                        command.Parameters.AddWithValue("@State", "NSW");
                        
                        using (SqlDataReader reader = command.ExecuteReader())
                        {
                            Console.WriteLine("{0,-20} {1,-10} {2,15}", "Place", "Type", "Population");
                            Console.WriteLine(new string('-', 50));
                            
                            while (reader.Read())
                            {
                                Console.WriteLine("{0,-20} {1,-10} {2,15:N0}", 
                                    reader["PlaceName"], 
                                    reader["PlaceType"], 
                                    reader["Population"]);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error: " + ex.Message);
            }
            
            Console.WriteLine("\nPress any key to exit...");
            Console.ReadKey();
        }
    }
}

/*
==============================================================================
Python Example (using pyodbc)
==============================================================================

import pyodbc

# Connection string
conn_str = (
    'DRIVER={ODBC Driver 17 for SQL Server};'
    'SERVER=localhost;'
    'DATABASE=AustralianPlaces;'
    'Trusted_Connection=yes;'
)

try:
    # Connect to database
    conn = pyodbc.connect(conn_str)
    cursor = conn.cursor()
    
    print("Connected to database successfully!\n")
    
    # Query 1: Get top 10 places by population
    cursor.execute("""
        SELECT TOP 10 PlaceName, State, Population, PlaceType
        FROM Places
        ORDER BY Population DESC
    """)
    
    print("Top 10 Places by Population:")
    print(f"{'Place':<20} {'State':<5} {'Population':>12} {'Type':<10}")
    print("-" * 50)
    
    for row in cursor.fetchall():
        print(f"{row.PlaceName:<20} {row.State:<5} {row.Population:>12,} {row.PlaceType:<10}")
    
    # Query 2: Get places by state
    state = 'VIC'
    cursor.execute("""
        SELECT PlaceName, Population, PlaceType
        FROM Places
        WHERE State = ?
        ORDER BY Population DESC
    """, state)
    
    print(f"\n\nPlaces in {state}:")
    for row in cursor.fetchall():
        print(f"{row.PlaceName}: {row.Population:,} ({row.PlaceType})")
    
    # Close connection
    cursor.close()
    conn.close()
    print("\nConnection closed.")
    
except Exception as e:
    print(f"Error: {e}")

==============================================================================
Node.js Example (using mssql package)
==============================================================================

const sql = require('mssql');

const config = {
    server: 'localhost',
    database: 'AustralianPlaces',
    options: {
        trustedConnection: true,
        trustServerCertificate: true
    }
};

async function getPlaces() {
    try {
        // Connect to database
        await sql.connect(config);
        console.log('Connected to database successfully!\n');
        
        // Query 1: Get all cities
        const result1 = await sql.query`
            SELECT PlaceName, State, Population
            FROM Places
            WHERE PlaceType = 'City'
            ORDER BY Population DESC
        `;
        
        console.log('Cities by Population:');
        result1.recordset.forEach(row => {
            console.log(`${row.PlaceName} (${row.State}): ${row.Population.toLocaleString()}`);
        });
        
        // Query 2: Parameterized query
        const state = 'QLD';
        const result2 = await sql.query`
            SELECT PlaceName, PlaceType, Population
            FROM Places
            WHERE State = ${state}
            ORDER BY Population DESC
        `;
        
        console.log(`\nPlaces in ${state}:`);
        result2.recordset.forEach(row => {
            console.log(`${row.PlaceName}: ${row.Population.toLocaleString()} (${row.PlaceType})`);
        });
        
    } catch (err) {
        console.error('Database error:', err);
    } finally {
        await sql.close();
    }
}

getPlaces();

==============================================================================
PowerShell Example
==============================================================================

# Connection string
$connectionString = "Server=localhost;Database=AustralianPlaces;Trusted_Connection=True;"

try {
    # Create connection
    $connection = New-Object System.Data.SqlClient.SqlConnection
    $connection.ConnectionString = $connectionString
    $connection.Open()
    
    Write-Host "Connected to database successfully!`n" -ForegroundColor Green
    
    # Query
    $query = @"
        SELECT TOP 10 PlaceName, State, Population, PlaceType
        FROM Places
        ORDER BY Population DESC
"@
    
    $command = New-Object System.Data.SqlClient.SqlCommand
    $command.Connection = $connection
    $command.CommandText = $query
    
    $reader = $command.ExecuteReader()
    
    Write-Host "Top 10 Places by Population:" -ForegroundColor Cyan
    Write-Host ("{0,-20} {1,-5} {2,12} {3,-10}" -f "Place", "State", "Population", "Type")
    Write-Host ("-" * 50)
    
    while ($reader.Read()) {
        Write-Host ("{0,-20} {1,-5} {2,12:N0} {3,-10}" -f 
            $reader["PlaceName"], 
            $reader["State"], 
            $reader["Population"], 
            $reader["PlaceType"])
    }
    
    $reader.Close()
    $connection.Close()
    
    Write-Host "`nConnection closed." -ForegroundColor Green
    
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}

*/
