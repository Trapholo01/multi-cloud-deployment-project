# Deployment Coordination Guide

## For AWS Teammate (Member 1):
**Required from you:**
1. AWS Elastic Beanstalk environment setup
2. IAM user with deployment permissions
3. Provide these credentials:
   - AWS_ACCESS_KEY_ID
   - AWS_SECRET_ACCESS_KEY
   - AWS_REGION
   - EB_APPLICATION_NAME
   - EB_ENVIRONMENT_NAME

**Pipeline will:**
- Deploy `artifacts/backend-build/` to Elastic Beanstalk
- Deploy `artifacts/frontend-build/` to S3 + CloudFront

## For Azure Teammate (Member 2):
**Required from you:**
1. Azure App Service setup
2. Download publish profile
3. Provide this credential:
   - AZURE_PUBLISH_PROFILE

**Pipeline will:**
- Deploy `artifacts/backend-build/` to Azure App Service
- Deploy `artifacts/frontend-build/` to Azure Blob Storage

## Pipeline Status: ✅ READY
- All build stages working
- Artifacts prepared for both clouds
- Waiting for your cloud credentials to enable deployment