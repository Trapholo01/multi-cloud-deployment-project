# Multi-Cloud Deployment Project

A Node.js web application demonstrating deployment and CI/CD capabilities across **AWS** and **Azure** cloud platforms.

## 🚀 Project Overview

This project demonstrates a complete multi-cloud DevOps workflow:
- **Application**: Node.js/Express web server with static frontend (AI Content Generator)
- **Cloud Platforms**: 
  - **AWS**: CodePipeline → CodeBuild → Elastic Beanstalk
  - **Azure**: Azure Pipelines → App Service (or Container Instances)
- **Testing**: Automated unit tests with Jest + Supertest
- **Infrastructure**: CloudFormation (AWS) and Bicep/ARM templates (Azure)
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
├── buildspec.yml                # CodeBuild build instructions
├── cloudformation/              # Infrastructure as Code
│   └── codepipeline.yml        # Full CI/CD pipeline stack
├── package.json                 # Node.js dependencies
├── export-iam-roles.ps1        # IAM documentation script
└── MANUAL-DEPLOYMENT.md        # Step-by-step deployment guide
```

## 🛠️ Technologies Used

### Application
- **Backend**: Node.js, Express
- **Frontend**: HTML, CSS, JavaScript
- **Testing**: Jest, Supertest
- **AI Integration**: Google Gemini API

### AWS Services
- **CodePipeline**: CI/CD orchestration
- **CodeBuild**: Build and test automation
- **Elastic Beanstalk**: Application hosting (Node.js platform)
- **CodeStar Connections**: Secure GitHub integration
- **S3**: Artifact storage
- **Secrets Manager**: API key storage
- **IAM**: Role-based access control
- **CloudFormation**: Infrastructure provisioning

### Azure Services
- **Azure Pipelines**: CI/CD automation
- **Azure App Service**: Web app hosting (Node.js)
- **Azure Container Instances** (alternative): Containerized deployment
- **Azure Key Vault**: Secrets management
- **Azure DevOps**: Source control and pipeline management
- **Managed Identities**: Secure service-to-service authentication
- **Bicep/ARM Templates**: Infrastructure as Code

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

### Option 1: AWS Deployment
Follow the complete step-by-step guide in **[MANUAL-DEPLOYMENT.md](MANUAL-DEPLOYMENT.md)**

**Quick Steps (AWS):**
1. Create CodeStar Connection for GitHub (AWS Console)
2. Store Gemini API key in Secrets Manager
3. Create S3 bucket for artifacts
4. Deploy CloudFormation stack (`cloudformation/codepipeline.yml`)
5. Push commit to trigger pipeline
6. Monitor execution in CodePipeline console

**Deployment time**: ~10-15 minutes

### Option 2: Azure Deployment
Documentation for Azure deployment available in **azure/** directory (includes Bicep templates and pipeline YAML)

**Quick Steps (Azure):**
1. Create Azure DevOps project and connect to GitHub
2. Store Gemini API key in Azure Key Vault
3. Create Azure App Service or Container Instance
4. Deploy pipeline configuration (azure-pipelines.yml)
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

## 📊 Pipeline Stages

1. **Source**: Fetch code from GitHub (triggered by commits)
2. **Build**: 
   - Install dependencies (`npm ci`)
   - Run tests (`npm test`)
   - Package application (`app.zip`)
3. **Deploy**: Deploy to Elastic Beanstalk environment

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
| **CI/CD** | CodePipeline + CodeBuild | Azure Pipelines |
| **Hosting** | Elastic Beanstalk | App Service / Container Instances |
| **Secrets** | Secrets Manager | Key Vault |
| **Identity** | IAM Roles | Managed Identities |
| **IaC** | CloudFormation | Bicep / ARM Templates |
| **Source Integration** | CodeStar Connections | Azure DevOps Git / GitHub Integration |
| **Artifacts** | S3 | Azure Storage / Container Registry |

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

**Author**: Trapholo01  
**Repository**: [github.com/Trapholo01/multi-cloud-deployment-project](https://github.com/Trapholo01/multi-cloud-deployment-project)
