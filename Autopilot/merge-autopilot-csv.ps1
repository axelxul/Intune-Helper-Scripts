# Variables
$groupTag = "<insert Group Tag here>"  # Replace with the actual group tag
$csvDirectory = "<insert path to CSV files here>"  # Replace with the actual path to the directory containing CSV files

# Get all CSV files in the directory
$csvFiles = Get-ChildItem -Path $csvDirectory -Filter "*.csv"

# Create empty array to store merged data
$mergedData = @()

foreach ($file in $csvFiles) {
    # Import CSV content
    $csvContent = Import-Csv -Path $file.FullName
    
    # Add GroupTag property to each row
    $csvContent | ForEach-Object {
        $_ | Add-Member -NotePropertyName "Group Tag" -NotePropertyValue $groupTag
    }
    
    # Add to merged data
    $mergedData += $csvContent
}

if ($mergedData.Count -gt 0) {
    # Export merged data to new CSV file
    $outputPath = Join-Path $csvDirectory "merged_autopilot_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
    
    # Convert to CSV and remove quotes
    $csvData = $mergedData | ConvertTo-Csv -NoTypeInformation
    $csvData = $csvData | ForEach-Object { $_ -replace '"' }
    
    # Write to file
    $csvData | Set-Content -Path $outputPath -Encoding UTF8
    Write-Host "Merged CSV file created at: $outputPath"
} else {
    Write-Host "No CSV files found in the specified directory."
}
