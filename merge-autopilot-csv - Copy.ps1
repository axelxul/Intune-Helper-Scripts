$groupTag = "TestTag123"
$csvDirectory = "$env:OneDrive\Intune\CSV-Merge-Tests"

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
    $mergedData | Export-Csv -Path $outputPath -NoTypeInformation
    Write-Host "Merged CSV file created at: $outputPath"
} else {
    Write-Host "No CSV files found in the specified directory."
}

