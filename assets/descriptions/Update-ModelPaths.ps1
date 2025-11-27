$directory = Get-Location
$jsonFiles = Get-ChildItem -Path $directory -Filter "*.json" -ErrorAction Stop

foreach ($file in $jsonFiles) {
    # Read the file content and convert it to a PowerShell object
    $content = Get-Content -Path $file.FullName | Out-String | ConvertFrom-Json

    # Check if the 'modelPath' property exists in the object
    # This works for PSCustomObjects without needing ContainsKey()
    if ($null -ne $content.modelPath) {
        $fileName = $file.BaseName
        $newPath = "assets/models/$fileName.glb"
        
        # Assign the new path
        $content.modelPath = $newPath
        
        # Convert the modified object back to JSON and overwrite the file
        $content | ConvertTo-Json -Depth 100 | Set-Content -Path $file.FullName -Force
    }
}

Write-Host "Model paths updated in all JSON files in $directory"