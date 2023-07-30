# Login to Azure Powershell CLI
Connect-AzAccount -TenantId <YOUR_TENANT_ID>

# Parse CSV for String Content and strip header valuers
$csvTagData = Import-Csv -Path .\TagData.csv

# Iterate over rows
foreach ($row in $csvTagData){

    # Set Subscription Context
    $subscriptionContext = Set-AzContext -Subscription $row.SubscriptionName

    # Query for ResourceGroup ResourceId
    $rg = Get-AzResourceGroup -Name $row.ResourceGroup
    
    $tags = @{"Owner"=$row.Owner; "Department"=$row.Department; "Environment"=$row.Environment; "CostCenter"=$row.CostCenter}

    # Apply Tags
    Write-Host "Processing "$rg.ResourceGroupName"" -ForegroundColor Black -BackgroundColor white
    Update-AzTag -ResourceId $rg.ResourceId -Tag $tags -operation Merge
} 
