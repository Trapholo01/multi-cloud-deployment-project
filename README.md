# Multi-Cloud Deployment Project

A Node.js web application demonstrating deployment and CI/CD capabilities across **AWS** and **Azure** cloud platforms.

## 🚀 Project Overview

This project demonstrates a complete multi-cloud DevOps workflow:
- **Application**: Node.js/Express web server with static frontend (AI Content Generator)
- **CI/CD**: **Azure Pipelines** (single pipeline deploys to both AWS and Azure)
- **Cloud Platforms**: 
  - **AWS**: Elastic Beanstalk
  - **Azure**: App Service
- **Testing**: Automated unit tests with Jest + Supertest
- **Infrastructure**: CloudFormation (AWS) and manual/scripted setup (Azure)
- **Security**: 
  - AWS: IAM roles with least-privilege policies, Secrets Manager
  - Azure: Managed Identities, Key Vault integration

## 📁 Project Structure

```
multi-cloud-deployment-project/
├── server.js                    # Express server (backend API)
├── public/                      # Static frontend files
│   ├── index.html
│   ├── script.js
│   └── Style.css
├── tests/                       # Unit tests
│   └── health.test.js
├── azure-pipelines.yml          # Azure Pipelines configuration (deploys to both clouds)
├── buildspec.yml                # CodeBuild build instructions (legacy)
├── cloudformation/              # Infrastructure as Code (legacy)
│   └── codepipeline.yml        # Full CI/CD pipeline stack (legacy)
├── package.json                 # Node.js dependencies
├── export-iam-roles.ps1        # IAM documentation script
├── MANUAL-DEPLOYMENT.md        # Step-by-step AWS deployment guide
└── AZURE-PIPELINES-SETUP.md    # Azure Pipelines multi-cloud setup guide
```

## 🛠️ Technologies Used

### Application
- **Backend**: Node.js, Express
- **Frontend**: HTML, CSS, JavaScript
- **Testing**: Jest, Supertest
- **AI Integration**: Google Gemini API

### CI/CD Platform
- **Azure Pipelines**: Multi-cloud CI/CD orchestration (builds once, deploys to both AWS and Azure)
- **Azure DevOps**: Pipeline management and GitHub integration

### AWS Services
- **Elastic Beanstalk**: Application hosting (Node.js platform)
- **S3**: Artifact storage
- **Secrets Manager**: API key storage
- **IAM**: Role-based access control
- **CloudFormation**: Infrastructure provisioning (optional)

### Azure Services
- **Azure App Service**: Web app hosting (Node.js)
- **Azure Key Vault**: Secrets management
- **Managed Identities**: Secure service-to-service authentication

## 📋 Prerequisites

### General
- GitHub Account
- Gemini API Key (for AI features) - [Get key](https://aistudio.google.com/app/apikey)

### For AWS Deployment
- AWS Account with Console/CLI access
- AWS CLI (optional, for automation)

### For Azure Deployment
- Azure Account with Azure DevOps access
- Azure CLI (optional, for automation)

## 🚀 Deployment Options

### **Recommended: Azure Pipelines (Multi-Cloud)**
Follow the complete step-by-step guide in **[AZURE-PIPELINES-SETUP.md](AZURE-PIPELINES-SETUP.md)**

**One pipeline deploys to both AWS and Azure:**
1. Create Azure DevOps project and connect to GitHub
2. Set up AWS infrastructure (Elastic Beanstalk, S3, Secrets Manager)
3. Set up Azure infrastructure (App Service, Key Vault)
4. Configure service connections (AWS and Azure)
5. Set pipeline variables
6. Push commit to trigger pipeline
7. Watch pipeline deploy to both clouds automatically!

**Deployment time**: ~15-20 minutes (both clouds)

### **Alternative: AWS-Only Deployment (Legacy)**
For AWS-only deployment using CodePipeline, follow **[MANUAL-DEPLOYMENT.md](MANUAL-DEPLOYMENT.md)**

**Quick Steps (AWS CodePipeline):**
1. Create CodeStar Connection for GitHub
2. Store Gemini API key in Secrets Manager
3. Create S3 bucket for artifacts
4. Deploy CloudFormation stack (`cloudformation/codepipeline.yml`)
5. Push commit to trigger pipeline

**Deployment time**: ~10-15 minutes

## 🔐 Security Features

### AWS Security
- **Least-Privilege IAM Roles**: 
  - CodeBuildRole: Scoped to specific S3 bucket, secrets, and EB resources
  - PipelineRole: Scoped to artifact bucket and stack environment
- **No Long-Lived Tokens**: Uses CodeStar Connections (GitHub App)
- **Secrets Management**: API keys stored in AWS Secrets Manager
- **Infrastructure as Code**: All resources version-controlled and reproducible

### Azure Security
- **Managed Identities**: System-assigned identities for service-to-service authentication
- **Key Vault Integration**: Secure secrets storage and retrieval
- **Azure AD Authentication**: Role-based access control (RBAC)
- **Network Security**: Virtual Network integration and private endpoints (optional)
- **Infrastructure as Code**: Bicep templates with security best practices

### Both Platforms
- **No API Keys in Code**: All secrets injected via cloud-native secret managers
- **HTTPS Only**: Secure transport for all communications
- **Automated Security Scanning**: Available through cloud provider tools

## 🧪 Testing

Run tests locally:
```bash
npm install
npm test
```

Tests run automatically in the CI/CD pipeline during the Build stage.

## 📊 Pipeline Stages (Azure Pipelines)

### Stage 1: Build and Test
- Install Node.js 18
- Install dependencies (`npm ci`)
- Run tests (`npm test`)
- Package application (`app.zip`)
- Publish artifact

### Stage 2: Deploy to AWS
- Download artifact
- Upload to S3
- Create Elastic Beanstalk version
- Deploy to Elastic Beanstalk environment
- Wait for deployment completion

### Stage 3: Deploy to Azure
- Download artifact
- Deploy to Azure App Service
- Configure Key Vault integration
- Set environment variables

**Single push → Both clouds deployed automatically!** 🚀

## 📸 IAM Role Documentation

After deployment, export IAM roles for documentation:

```powershell
.\export-iam-roles.ps1 -StackName multi-cloud-pipeline -Region us-east-1
```

This creates `iam-export/` folder with:
- Role details (JSON)
- Attached policies (JSON)
- Inline policies (JSON)
- Opens IAM console pages for screenshots

## 🔄 Making Updates

Push any commit to trigger the pipeline:
```bash
git add .
git commit -m "Update application"
git push origin main
```

The pipeline will automatically:
- ✅ Fetch latest code
- ✅ Run tests
- ✅ Deploy to Elastic Beanstalk (if tests pass)

## 📝 CloudFormation Template Details

### Resources Created:
- **S3 Bucket**: Pipeline artifacts
- **Elastic Beanstalk Application**: Multi-cloud deployment app
- **Elastic Beanstalk Environment**: Node.js runtime
- **CodeBuild Project**: Build and test automation
- **CodePipeline**: 3-stage pipeline
- **2 IAM Roles**: CodeBuildRole, PipelineRole
- **Inline Policies**: Scoped S3, Secrets Manager, EB, iam:PassRole

### Parameters:
- `GitHubOwner`, `GitHubRepo`, `GitHubBranch`: Repository details
- `CodeStarConnectionArn`: GitHub connection ARN
- `GeminiSecretName`: Secrets Manager secret name
- `ArtifactBucket`: S3 bucket for artifacts
- `EBPlatform`: Elastic Beanstalk platform version

## 🎯 Project Goals Achieved

✅ **Multi-Cloud Architecture**: Application deployable on both AWS and Azure  
✅ **Automated CI/CD Pipelines**: Complete source → build → test → deploy workflow on both platforms  
✅ **Automated Testing**: Unit tests run on every commit (both clouds)  
✅ **Infrastructure as Code**: CloudFormation (AWS) and Bicep/ARM (Azure)  
✅ **Security Best Practices**: 
   - AWS: Least-privilege IAM roles, Secrets Manager
   - Azure: Managed Identities, Key Vault integration
✅ **Documentation**: Complete deployment guides for both cloud platforms  
✅ **Cloud Deployment**: 
   - AWS: Elastic Beanstalk
   - Azure: App Service / Container Instances
✅ **Cloud Agnostic Application**: Same codebase runs on both platforms  

## 🌐 Access the Application

After successful deployment:
1. Go to **Elastic Beanstalk** in AWS Console
2. Click your environment
3. Copy the **Environment URL** (e.g., `http://env-name.us-east-1.elasticbeanstalk.com`)
4. Open in browser to view the deployed application

## ☁️ Multi-Cloud Comparison

| Feature | AWS | Azure |
|---------|-----|-------|
| **CI/CD** | Azure Pipelines (unified) | Azure Pipelines (unified) |
| **Hosting** | Elastic Beanstalk | App Service |
| **Secrets** | Secrets Manager | Key Vault |
| **Identity** | IAM Roles | Managed Identities |
| **IaC** | CloudFormation (optional) | Manual/Scripted Setup |
| **Source Integration** | GitHub → Azure Pipelines | GitHub → Azure Pipelines |
| **Artifacts** | S3 | Azure Pipelines Artifacts |

**Why Multi-Cloud?**
- **Vendor Independence**: Avoid lock-in to a single provider
- **Cost Optimization**: Choose the most cost-effective platform per workload
- **Disaster Recovery**: Cross-cloud redundancy options
- **Skills Development**: Learn multiple cloud platforms
- **Compliance**: Meet regulatory requirements that may prefer specific clouds

## 📚 Additional Resources

### AWS Resources
- [AWS CodePipeline Documentation](https://docs.aws.amazon.com/codepipeline/)
- [AWS Elastic Beanstalk Documentation](https://docs.aws.amazon.com/elasticbeanstalk/)
- [CloudFormation Best Practices](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/best-practices.html)

### Azure Resources
- [Azure Pipelines Documentation](https://docs.microsoft.com/azure/devops/pipelines/)
- [Azure App Service Documentation](https://docs.microsoft.com/azure/app-service/)
- [Bicep Documentation](https://docs.microsoft.com/azure/azure-resource-manager/bicep/)

## 🤝 Contributing

This is a portfolio/educational project. Feel free to fork and adapt for your own use.

## 📄 License

MIT License - Feel free to use this project as a reference or starting point for your own work.

---

## 👥 Team Members

- **Lerato Matamela** - Pipelines & Documentation
- **Thelezinhle Buthelezi** - AWS Deployment
- **Thato Rapholo** - Azure Deployment

**Sprint**: November 19-25, 2025 (1 week intensive)  
**Repository**: [github.com/Trapholo01/multi-cloud-deployment-project](https://github.com/Trapholo01/multi-cloud-deployment-project)
