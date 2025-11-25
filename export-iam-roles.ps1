#!/usr/bin/env pwsh
<#
.SYNOPSIS
Export IAM roles and policies from a CloudFormation stack for documentation/screenshots.

.DESCRIPTION
This script:
1. Queries CloudFormation to find IAM roles created by the stack
2. Exports role details, attached policies, and inline policies to JSON files
3. Fetches managed policy documents for attached policies
4. Opens IAM console pages in the browser for screenshot capture

.PARAMETER StackName
Name of the CloudFormation stack (default: multi-cloud-pipeline)

.PARAMETER Region
AWS region (default: us-east-1)

.PARAMETER OutputDir
Directory to save exported JSON files (default: iam-export)

.EXAMPLE
.\export-iam-roles.ps1 -StackName multi-cloud-pipeline -Region us-east-1
#>

param(
    [string]$StackName = "multi-cloud-pipeline",
    [string]$Region = "us-east-1",
    [string]$OutputDir = "iam-export"
)

# Create output directory
if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir | Out-Null
    Write-Host "✓ Created output directory: $OutputDir" -ForegroundColor Green
}

Write-Host "`n=== Step 1: Finding IAM roles in CloudFormation stack ===" -ForegroundColor Cyan
Write-Host "Stack: $StackName, Region: $Region`n" -ForegroundColor Gray

# Get stack resources
try {
    $stackResourcesJson = aws cloudformation describe-stack-resources --stack-name $StackName --region $Region 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "✗ Error querying CloudFormation stack: $stackResourcesJson" -ForegroundColor Red
        Write-Host "`nMake sure:" -ForegroundColor Yellow
        Write-Host "  1. AWS CLI is installed and configured" -ForegroundColor Yellow
        Write-Host "  2. You have deployed the CloudFormation stack '$StackName'" -ForegroundColor Yellow
        Write-Host "  3. Your AWS credentials have access to the stack" -ForegroundColor Yellow
        exit 1
    }
    
    $stackResources = $stackResourcesJson | ConvertFrom-Json
    $iamRoles = $stackResources.StackResources | Where-Object { $_.ResourceType -eq 'AWS::IAM::Role' }
    
    if ($iamRoles.Count -eq 0) {
        Write-Host "✗ No IAM roles found in stack '$StackName'" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "Found $($iamRoles.Count) IAM role(s):" -ForegroundColor Green
    $iamRoles | ForEach-Object {
        Write-Host "  • $($_.LogicalResourceId) → $($_.PhysicalResourceId)" -ForegroundColor White
    }
    
    # Save stack resources summary
    $iamRoles | Select-Object LogicalResourceId, PhysicalResourceId, ResourceType | 
        ConvertTo-Json -Depth 10 | 
        Out-File -FilePath "$OutputDir\stack-iam-roles.json" -Encoding utf8
    Write-Host "`n✓ Saved roles summary to: $OutputDir\stack-iam-roles.json" -ForegroundColor Green
    
} catch {
    Write-Host "✗ Error: $_" -ForegroundColor Red
    exit 1
}

Write-Host "`n=== Step 2: Exporting role details and policies ===" -ForegroundColor Cyan

$roleNames = $iamRoles | Select-Object -ExpandProperty PhysicalResourceId

foreach ($roleName in $roleNames) {
    Write-Host "`nProcessing role: $roleName" -ForegroundColor Yellow
    
    # Get role details
    try {
        $roleJson = aws iam get-role --role-name $roleName --region $Region 2>&1
        if ($LASTEXITCODE -eq 0) {
            $roleJson | Out-File -FilePath "$OutputDir\iam-${roleName}-role.json" -Encoding utf8
            Write-Host "  ✓ Exported role details" -ForegroundColor Green
        } else {
            Write-Host "  ✗ Failed to get role: $roleJson" -ForegroundColor Red
            continue
        }
    } catch {
        Write-Host "  ✗ Error getting role: $_" -ForegroundColor Red
        continue
    }
    
    # Get attached managed policies
    try {
        $attachedJson = aws iam list-attached-role-policies --role-name $roleName --region $Region 2>&1
        if ($LASTEXITCODE -eq 0) {
            $attachedJson | Out-File -FilePath "$OutputDir\iam-${roleName}-attached-policies.json" -Encoding utf8
            Write-Host "  ✓ Exported attached policies list" -ForegroundColor Green
            
            # Parse and get policy documents
            $attached = $attachedJson | ConvertFrom-Json
            if ($attached.AttachedPolicies.Count -gt 0) {
                Write-Host "    Found $($attached.AttachedPolicies.Count) attached managed policy(ies)" -ForegroundColor Gray
                foreach ($policy in $attached.AttachedPolicies) {
                    $policyArn = $policy.PolicyArn
                    $policyName = $policy.PolicyName
                    Write-Host "      • $policyName" -ForegroundColor Gray
                    
                    # Get policy version
                    $policyMetaJson = aws iam get-policy --policy-arn $policyArn --region $Region 2>&1
                    if ($LASTEXITCODE -eq 0) {
                        $policyMeta = $policyMetaJson | ConvertFrom-Json
                        $versionId = $policyMeta.Policy.DefaultVersionId
                        
                        # Get policy document
                        $policyDocJson = aws iam get-policy-version --policy-arn $policyArn --version-id $versionId --region $Region 2>&1
                        if ($LASTEXITCODE -eq 0) {
                            $safeName = $policyName -replace '[/:\\]', '_'
                            $policyDocJson | Out-File -FilePath "$OutputDir\managed-${safeName}.json" -Encoding utf8
                            Write-Host "        ✓ Exported policy document" -ForegroundColor Green
                        }
                    }
                }
            }
        } else {
            Write-Host "  ✗ Failed to list attached policies: $attachedJson" -ForegroundColor Red
        }
    } catch {
        Write-Host "  ✗ Error getting attached policies: $_" -ForegroundColor Red
    }
    
    # Get inline policies
    try {
        $inlineListJson = aws iam list-role-policies --role-name $roleName --region $Region 2>&1
        if ($LASTEXITCODE -eq 0) {
            $inlineList = $inlineListJson | ConvertFrom-Json
            if ($inlineList.PolicyNames.Count -gt 0) {
                Write-Host "  ✓ Found $($inlineList.PolicyNames.Count) inline policy(ies)" -ForegroundColor Green
                foreach ($policyName in $inlineList.PolicyNames) {
                    Write-Host "    • $policyName" -ForegroundColor Gray
                    $inlinePolicyJson = aws iam get-role-policy --role-name $roleName --policy-name $policyName --region $Region 2>&1
                    if ($LASTEXITCODE -eq 0) {
                        $safeName = $policyName -replace '[/:\\]', '_'
                        $inlinePolicyJson | Out-File -FilePath "$OutputDir\iam-${roleName}-inline-${safeName}.json" -Encoding utf8
                        Write-Host "      ✓ Exported inline policy" -ForegroundColor Green
                    } else {
                        Write-Host "      ✗ Failed to get inline policy: $inlinePolicyJson" -ForegroundColor Red
                    }
                }
            } else {
                Write-Host "  • No inline policies" -ForegroundColor Gray
            }
        } else {
            Write-Host "  ✗ Failed to list inline policies: $inlineListJson" -ForegroundColor Red
        }
    } catch {
        Write-Host "  ✗ Error getting inline policies: $_" -ForegroundColor Red
    }
}

Write-Host "`n=== Step 3: Opening IAM Console pages for screenshots ===" -ForegroundColor Cyan
Write-Host "Opening browser tabs for each role...`n" -ForegroundColor Gray

foreach ($roleName in $roleNames) {
    $consoleUrl = "https://console.aws.amazon.com/iam/home?region=$Region#/roles/$roleName"
    Write-Host "Opening: $roleName" -ForegroundColor Yellow
    Write-Host "  $consoleUrl" -ForegroundColor Gray
    Start-Process $consoleUrl
    Start-Sleep -Milliseconds 500  # Brief delay between tabs
}

Write-Host "`n=== Export Complete ===" -ForegroundColor Green
Write-Host "`nExported files are in: $OutputDir\" -ForegroundColor White
Write-Host "`nNext steps for screenshots:" -ForegroundColor Cyan
Write-Host "  1. Check opened browser tabs (IAM console pages)" -ForegroundColor White
Write-Host "  2. Sign in to AWS Console if not already authenticated" -ForegroundColor White
Write-Host "  3. For each role, capture screenshots of:" -ForegroundColor White
Write-Host "     • Permissions tab (attached policies)" -ForegroundColor Gray
Write-Host "     • Permissions tab (inline policies expanded)" -ForegroundColor Gray
Write-Host "     • Trust relationships tab" -ForegroundColor Gray
Write-Host "  4. Review exported JSON files in $OutputDir\ for documentation" -ForegroundColor White
Write-Host "`nTip: Use Windows Snipping Tool (Win+Shift+S) for screenshots`n" -ForegroundColor Yellow
