##ApplyResourceGroupTags.ps1

try {
    # Login to Azure Powershell CLI
    Connect-AzAccount -TenantId "{{TENANT_ID}}"
} catch {
    # Log auth exceptions
    Write-Host $_ -ForegroundColor Black -BackgroundColor white
}

# Parse CSV for String Content and strip header valuers
$csvTagData = Import-Csv -Path .\TagData.csv

# Iterate over rows
foreach ($row in $csvTagData){
    # Set Subscription Context
    $subscriptionContext = Set-AzContext -Subscription $row.SubscriptionName
    
    # Create Tags dictionary
    $tags = @{"Owner"=$row.Owner; "Department"=$row.Department; "Environment"=$row.Environment; "CostCenter"=$row.CostCenter}
    try {
        # Query for ResourceGroup ResourceId
        $rg = Get-AzResourceGroup -Name $row.ResourceGroup

        # Apply Tags
        Write-Host "Processing "$rg.ResourceGroupName"" -ForegroundColor Black -BackgroundColor white

        # Update Tags for specific ResourceGroup
        $updatedTag = Update-AzTag -ResourceId $rg.ResourceId -Tag $tags -operation Merge
    } catch {
        # Log exceptions
        Write-Host $_ -ForegroundColor Black -BackgroundColor white
    }
} 
