# Azure Pipelines Multi-Cloud Deployment Setup

This guide walks you through setting up Azure Pipelines to deploy your application to **both AWS and Azure** from a single pipeline.

---

## Prerequisites

- GitHub account with your repository (`Trapholo01/multi-cloud-deployment-project`)
- Azure DevOps account (free tier available)
- AWS account with appropriate permissions
- Azure subscription

---

## Part 1: Azure DevOps Project Setup

### Step 1: Create Azure DevOps Organization (if you don't have one)

1. Go to https://dev.azure.com
2. Sign in with your Microsoft account
3. Click **+ New organization**
4. Name it (e.g., `lerato-devops`)
5. Click **Continue**

### Step 2: Create a New Project

1. Click **+ New project**
2. **Project name**: `multi-cloud-deployment`
3. **Visibility**: Private (or Public for free CI/CD minutes)
4. Click **Create**

---

## Part 2: Connect GitHub Repository

### Step 1: Create Pipeline from GitHub

1. In your Azure DevOps project, go to **Pipelines** → **Pipelines**
2. Click **Create Pipeline** (or **New pipeline**)
3. Select **GitHub** as your code repository
4. **Authorize Azure Pipelines** to access your GitHub account
   - Click **Authorize AzurePipelines**
   - Enter your GitHub password if prompted
5. Select your repository: `Trapholo01/multi-cloud-deployment-project`
6. Azure Pipelines will detect your `azure-pipelines.yml` file
7. Click **Run** (don't worry, it will fail until we set up connections)

---

## Part 3: AWS Configuration

### Step 1: Create AWS IAM User for Azure Pipelines

1. **Open AWS Console** → **IAM** → **Users** → **Create user**
2. **User name**: `azure-pipelines-deploy`
3. Select **Attach policies directly**
4. Attach these policies:
   - `AWSElasticBeanstalkFullAccess`
   - `AmazonS3FullAccess` (or create custom policy for specific bucket)
5. Click **Next** → **Create user**
6. Click on the user → **Security credentials** → **Create access key**
7. Select **Third-party service**
8. Click **Next** → **Create access key**
9. **Save the Access Key ID and Secret Access Key** (you won't see the secret again!)

### Step 2: Create AWS Service Connection in Azure DevOps

1. In Azure DevOps, go to **Project Settings** (bottom left)
2. Under **Pipelines**, click **Service connections**
3. Click **New service connection**
4. Select **AWS** → **Next**
5. Fill in:
   - **Access Key ID**: (from Step 1)
   - **Secret Access Key**: (from Step 1)
   - **Service connection name**: `AWS-ServiceConnection`
   - **Grant access permission to all pipelines**: ✅ Check this
6. Click **Save**

### Step 3: Create AWS Infrastructure

You need to create the Elastic Beanstalk application and environment first:

**Option A: Using AWS Console**

1. Go to **Elastic Beanstalk** → **Create application**
2. **Application name**: `multi-cloud-ai-app`
3. **Platform**: Node.js
4. **Platform branch**: Node.js 18 running on 64bit Amazon Linux 2023
5. **Application code**: Sample application (we'll deploy via pipeline)
6. Click **Create application**
7. Note the environment name (e.g., `multi-cloud-ai-env`)

**Option B: Using AWS CLI** (if you prefer)

```bash
# Install AWS CLI first: https://aws.amazon.com/cli/

# Create application
aws elasticbeanstalk create-application \
  --application-name multi-cloud-ai-app \
  --description "Multi-cloud AI content generator"

# Create environment
aws elasticbeanstalk create-environment \
  --application-name multi-cloud-ai-app \
  --environment-name multi-cloud-ai-env \
  --solution-stack-name "64bit Amazon Linux 2023 v6.1.0 running Node.js 18" \
  --option-settings \
    Namespace=aws:autoscaling:launchconfiguration,OptionName=IamInstanceProfile,Value=aws-elasticbeanstalk-ec2-role
```

### Step 4: Create S3 Bucket for Deployments

1. Go to **S3** → **Create bucket**
2. **Bucket name**: `multi-cloud-ai-deployments-<your-unique-id>` (must be globally unique)
3. **Region**: `us-east-1` (or match your Elastic Beanstalk region)
4. Keep default settings
5. Click **Create bucket**

### Step 5: Store Gemini API Key in AWS Secrets Manager

1. Go to **Secrets Manager** → **Store a new secret**
2. Select **Other type of secret**
3. **Key/value**:
   - Key: `GEMINI_API_KEY`
   - Value: Your actual Gemini API key
4. **Secret name**: `multi-cloud/gemini-api-key`
5. Click **Next** → **Next** → **Store**

### Step 6: Configure Elastic Beanstalk Environment Variables

1. Go to **Elastic Beanstalk** → Your environment
2. **Configuration** → **Software** → **Edit**
3. Add environment properties:
   - `GEMINI_API_KEY`: (Your Gemini API key, or reference Secrets Manager)
   - `PORT`: `8080`
   - `NODE_ENV`: `production`
4. Click **Apply**

---

## Part 4: Azure Configuration

### Step 1: Create Azure App Service

**Option A: Using Azure Portal**

1. Go to **Azure Portal** → **Create a resource**
2. Search for **Web App** → **Create**
3. Fill in:
   - **Subscription**: Your subscription
   - **Resource Group**: Create new → `multi-cloud-rg`
   - **Name**: `multi-cloud-ai-app-<your-initials>` (must be globally unique)
   - **Publish**: Code
   - **Runtime stack**: Node 18 LTS
   - **Operating System**: Linux
   - **Region**: Choose your region
   - **Pricing plan**: Free F1 (or B1 for production)
4. Click **Review + create** → **Create**
5. Note your app name for later

**Option B: Using Azure CLI**

```bash
# Install Azure CLI first: https://aka.ms/installazurecli

# Login
az login

# Create resource group
az group create --name multi-cloud-rg --location eastus

# Create App Service plan
az appservice plan create \
  --name multi-cloud-plan \
  --resource-group multi-cloud-rg \
  --is-linux \
  --sku B1

# Create Web App
az webapp create \
  --resource-group multi-cloud-rg \
  --plan multi-cloud-plan \
  --name multi-cloud-ai-app-<your-initials> \
  --runtime "NODE:18-lts"
```

### Step 2: Create Azure Key Vault for Secrets

1. Go to **Azure Portal** → **Create a resource**
2. Search for **Key Vault** → **Create**
3. Fill in:
   - **Subscription**: Your subscription
   - **Resource Group**: `multi-cloud-rg`
   - **Key vault name**: `multi-cloud-kv-<your-initials>`
   - **Region**: Same as your App Service
   - **Pricing tier**: Standard
4. Click **Review + create** → **Create**

### Step 3: Store Gemini API Key in Key Vault

1. Go to your Key Vault → **Secrets** → **Generate/Import**
2. Fill in:
   - **Name**: `gemini-api-key`
   - **Value**: Your actual Gemini API key
3. Click **Create**
4. Click on the secret → Click on the current version
5. Copy the **Secret Identifier** (URI) - you'll need this

### Step 4: Enable Managed Identity for App Service

1. Go to your App Service → **Identity**
2. Under **System assigned**, toggle **Status** to **On**
3. Click **Save** → **Yes**
4. Copy the **Object (principal) ID**

### Step 5: Grant App Service Access to Key Vault

1. Go to your Key Vault → **Access policies** → **Create**
2. **Secret permissions**: Select **Get** and **List**
3. Click **Next**
4. **Principal**: Search for your App Service name
5. Select it → **Next** → **Next** → **Create**

### Step 6: Create Azure Service Connection in Azure DevOps

1. In Azure DevOps, go to **Project Settings** → **Service connections**
2. Click **New service connection**
3. Select **Azure Resource Manager** → **Next**
4. Select **Service principal (automatic)** → **Next**
5. Fill in:
   - **Scope level**: Subscription
   - **Subscription**: Select your Azure subscription
   - **Resource group**: `multi-cloud-rg`
   - **Service connection name**: `Azure-ServiceConnection`
   - **Grant access permission to all pipelines**: ✅ Check this
6. Click **Save**

---

## Part 5: Configure Pipeline Variables

1. In Azure DevOps, go to **Pipelines** → **Pipelines**
2. Select your pipeline → **Edit**
3. Click **Variables** (top right)
4. Add these variables:

### AWS Variables:
- **Name**: `AWS_S3_BUCKET`, **Value**: `multi-cloud-ai-deployments-<your-id>` (your S3 bucket)

### Azure Variables:
- **Name**: `AZURE_APP_NAME`, **Value**: `multi-cloud-ai-app-<your-initials>` (your App Service name)
- **Name**: `AZURE_RESOURCE_GROUP`, **Value**: `multi-cloud-rg`
- **Name**: `KEYVAULT_SECRET_URI`, **Value**: (Secret Identifier URI from Key Vault)

5. Click **Save**

---

## Part 6: Run the Pipeline

1. Go to **Pipelines** → **Pipelines**
2. Select your pipeline
3. Click **Run pipeline**
4. Click **Run**

### Pipeline Stages:

1. **Build and Test**: Installs dependencies, runs tests, creates deployment package
2. **Deploy to AWS**: Uploads to S3, deploys to Elastic Beanstalk
3. **Deploy to Azure**: Deploys to Azure App Service

---

## Part 7: Verify Deployments

### AWS:
1. Go to **Elastic Beanstalk** → Your environment
2. Click on the URL (e.g., `http://multi-cloud-ai-env.xxxxxxxx.us-east-1.elasticbeanstalk.com`)
3. Test the `/health` endpoint

### Azure:
1. Go to your **App Service** → **Overview**
2. Click on the URL (e.g., `https://multi-cloud-ai-app-<your-initials>.azurewebsites.net`)
3. Test the `/health` endpoint

---

## Troubleshooting

### Pipeline Fails at AWS Stage

**Issue**: "Unable to locate credentials"
- **Fix**: Check AWS Service Connection in Azure DevOps
- Verify Access Key ID and Secret Access Key are correct

**Issue**: "Application does not exist"
- **Fix**: Create Elastic Beanstalk application first (Part 3, Step 3)

**Issue**: "Access Denied to S3"
- **Fix**: Verify IAM user has `AmazonS3FullAccess` policy

### Pipeline Fails at Azure Stage

**Issue**: "Service connection not found"
- **Fix**: Check Azure Service Connection name is exactly `Azure-ServiceConnection`

**Issue**: "App Service not found"
- **Fix**: Verify `AZURE_APP_NAME` variable matches your actual App Service name

**Issue**: "Cannot access Key Vault secret"
- **Fix**: Verify Managed Identity is enabled and has Key Vault access policy

### Application Errors

**Issue**: "GEMINI_API_KEY not found"
- **AWS**: Check Elastic Beanstalk environment variables
- **Azure**: Check App Service configuration references Key Vault correctly

---

## Pipeline Architecture

```
GitHub Repository
        │
        │ (Webhook triggers on push to main)
        ▼
Azure Pipelines
        │
        ├─ Stage 1: Build & Test
        │    ├─ npm ci
        │    ├─ npm test
        │    └─ Create app.zip
        │
        ├─ Stage 2: Deploy to AWS
        │    ├─ Upload to S3
        │    ├─ Create EB version
        │    └─ Update EB environment
        │
        └─ Stage 3: Deploy to Azure
             ├─ Deploy to App Service
             └─ Configure Key Vault integration
```

---

## Next Steps

1. ✅ Pipeline runs successfully
2. ✅ Both AWS and Azure deployments work
3. ✅ Test API endpoints on both platforms
4. ✅ Capture screenshots for documentation
5. ✅ Update README with deployment URLs

---

## Cost Considerations

### Azure DevOps
- **Free tier**: 1,800 minutes/month for private projects
- **Public projects**: Unlimited free minutes

### AWS
- **Elastic Beanstalk**: Free (you pay for underlying EC2)
- **EC2 t2.micro**: Free tier eligible (750 hours/month)
- **S3**: Free tier 5GB storage, 20,000 GET requests

### Azure
- **App Service F1**: Free tier (1GB RAM, 60 min/day CPU)
- **Key Vault**: $0.03 per 10,000 operations
- **B1 tier**: ~$13/month (recommended for production)

---

## Support

If you encounter issues:
1. Check Azure DevOps pipeline logs (click on failed stage)
2. Check AWS CloudWatch logs (Elastic Beanstalk → Logs)
3. Check Azure App Service logs (Log stream)
4. Verify all service connections are authorized
5. Verify all pipeline variables are set correctly

---

**Created**: November 25, 2025  
**Team**: Lerato Matamela, Thelezinhle Buthelezi, Thato Rapholo
