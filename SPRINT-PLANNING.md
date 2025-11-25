# Sprint Planning - Multi-Cloud Deployment Project

## Project Overview
**Project Name**: Multi-Cloud Deployment Project  
**Team Members**: 
- **Lerato Matamela** - Pipelines and Documentation
- **Thelezinhle Buthelezi** - AWS Deployment
- **Thato Rapholo** - Azure Deployment

**Duration**: 1 Week (November 19-25, 2025)  
**Timeline**: Wednesday, November 19, 2025 → Tuesday, November 25, 2025  
**Goal**: Deploy a Node.js AI Content Generator application across AWS and Azure with automated CI/CD pipelines

---

## Sprint Overview: Rapid Multi-Cloud Deployment (Week 1)

### Sprint Goal
Complete full multi-cloud deployment with CI/CD pipelines, documentation, and testing in a single intensive week

### User Stories & Team Assignments

#### Day 1-2 (Nov 19-20): Foundation & Setup - **All Team Members**
1. **As a team**, we want to set up the Node.js/Express backend with AI integration
   - **Owner**: All team members (pair programming)
   - **Story Points**: 8
   - **Tasks**:
     - Initialize Node.js project with Express
     - Integrate Google Gemini API
     - Create REST API endpoints (/health, /generate, /history)
     - Add error handling and fallback mechanisms
     - Configure environment variables
     - Create frontend interface (HTML/CSS/JavaScript)
     - Set up Jest and Supertest for testing
     - Write unit tests for API endpoints
     - Initialize GitHub repository

#### Day 3-4 (Nov 21-22): AWS Deployment - **Thelezinhle Buthelezi**
2. **As a DevOps engineer**, I want to create AWS infrastructure using CloudFormation
   - **Owner**: Thelezinhle Buthelezi
   - **Support**: Lerato Matamela (documentation)
   - **Story Points**: 13
   - **Tasks**:
     - Design CloudFormation template structure
     - Define Elastic Beanstalk application and environment
     - Create CodeBuild project with buildspec.yml
     - Configure CodePipeline (Source → Build → Deploy)
     - ⚠️ **ATTEMPTED**: GitHub Actions integration (FAILED)
     - **PIVOT**: Implement CodeStar Connections for GitHub
     - Set up IAM roles with least-privilege policies
     - Configure S3 artifact bucket
     - Set up AWS Secrets Manager for Gemini API key
     - Test end-to-end deployment

#### Day 3-4 (Nov 21-22): Azure Deployment - **Thato Rapholo**
3. **As a DevOps engineer**, I want to create Azure infrastructure using Bicep
   - **Owner**: Thato Rapholo
   - **Support**: Lerato Matamela (documentation)
   - **Story Points**: 13
   - **Tasks**:
     - Design Bicep template for App Service
     - Configure Azure Pipelines YAML
     - Set up Managed Identity for authentication
     - Configure Azure Key Vault for secrets
     - Create Azure DevOps project
     - Connect GitHub repository
     - Configure service connections
     - Test end-to-end deployment

#### Day 5-6 (Nov 23-24): Pipeline Refinement & Documentation - **Lerato Matamela**
4. **As a technical writer**, I want comprehensive documentation for both deployments
   - **Owner**: Lerato Matamela
   - **Support**: Thelezinhle Buthelezi, Thato Rapholo (technical review)
   - **Story Points**: 8
   - **Tasks**:
     - Create detailed README.md with multi-cloud sections
     - Write MANUAL-DEPLOYMENT.md for AWS (Console-based)
     - Create Azure deployment guide
     - Document GitHub Actions failure and pivot to CodePipeline
     - Add troubleshooting sections
     - Create export-iam-roles.ps1 script for AWS
     - Document Azure Managed Identities
     - Create IAM screenshot checklist
     - Write sprint planning document
     - Create reflection document

#### Day 7 (Nov 25): Testing & Finalization - **All Team Members**
5. **As a team**, we want to verify all deployments and complete documentation
   - **Owner**: All team members
   - **Story Points**: 8
   - **Tasks**:
     - Test AWS pipeline end-to-end
     - Test Azure pipeline end-to-end
     - Verify secrets injection on both platforms
     - Test API endpoints on deployed environments
     - Capture screenshots for submission
     - Final documentation review
     - Project submission preparation

### Sprint Deliverables
- ✅ Functional Node.js application with AI integration
- ✅ Working frontend interface
- ✅ Unit tests passing (100% coverage)
- ✅ AWS deployment with CloudFormation and CodePipeline
- ✅ Azure deployment with Bicep and Azure Pipelines
- ✅ Secure secrets management on both platforms
- ✅ Complete documentation (README, deployment guides, reflection)
- ✅ Sprint planning and retrospective
- ✅ IAM/RBAC documentation with screenshots
- ✅ GitHub repository with all code and IaC templates

**Total Story Points**: 50 (Intensive 1-week sprint)

---

## Daily Breakdown

### Wednesday, Nov 19 - Application Foundation
- **All Team**: Set up Node.js project, create basic Express server
- **All Team**: Integrate Gemini API, create frontend interface
- **All Team**: Initialize GitHub repository
- **Deliverable**: Working application locally

### Thursday, Nov 20 - Testing & Preparation
- **All Team**: Write unit tests with Jest/Supertest
- **All Team**: Plan infrastructure architecture
- **Thelezinhle**: Research AWS services and CloudFormation
- **Thato**: Research Azure services and Bicep
- **Lerato**: Set up documentation structure
- **Deliverable**: Test suite passing, deployment plans ready

### Friday, Nov 21 - Cloud Deployments Begin
- **Thelezinhle**: Start AWS CloudFormation template, attempt GitHub Actions
- **Thato**: Start Azure Bicep template and pipeline configuration
- **Lerato**: Document setup steps, support both deployments
- **Deliverable**: Initial infrastructure templates created

### Saturday, Nov 22 - Pipeline Implementation & Pivot
- **Thelezinhle**: 🔄 **PIVOT from GitHub Actions to CodePipeline**, complete AWS setup
- **Thato**: Complete Azure pipeline and App Service deployment
- **Lerato**: Document the GitHub Actions failure and pivot decision
- **Deliverable**: Both pipelines functional

### Sunday, Nov 23 - Testing & Documentation
- **Thelezinhle**: Test AWS deployment, export IAM roles
- **Thato**: Test Azure deployment, document Managed Identities
- **Lerato**: Write comprehensive README and deployment guides
- **Deliverable**: Documentation 80% complete

### Monday, Nov 24 - Refinement & Screenshots
- **All Team**: End-to-end testing on both platforms
- **Lerato**: Complete sprint planning and reflection documents
- **Thelezinhle**: Capture AWS screenshots for submission
- **Thato**: Capture Azure screenshots for submission
- **Deliverable**: All deployments verified, documentation complete

### Tuesday, Nov 25 - Final Review & Submission
- **All Team**: Final testing and bug fixes
- **All Team**: Review all documentation
- **All Team**: Prepare presentation materials
- **Deliverable**: Project ready for submission

---

## Team Retrospective - Key Learning

### User Stories
1. **As a DevOps engineer**, I want to create AWS infrastructure using CloudFormation, so that resources are reproducible
   - **Story Points**: 13
   - **Tasks**:
     - Design CloudFormation template structure
     - Define Elastic Beanstalk application and environment
     - Create CodeBuild project with buildspec.yml
     - Configure CodePipeline (Source → Build → Deploy)
     - Set up IAM roles with least-privilege policies
     - Configure S3 artifact bucket

2. **As a DevOps engineer**, I want to integrate GitHub with AWS securely, so that code changes trigger deployments
   - **Story Points**: 8
   - **Tasks**:
     - ⚠️ **ATTEMPTED**: GitHub Actions integration (FAILED - see Sprint 2 Retrospective)
     - **PIVOT**: Implement CodeStar Connections for GitHub
     - Configure webhook triggers
     - Test pipeline triggering
     - Document authentication setup

3. **As a DevOps engineer**, I want to secure API keys using AWS Secrets Manager, so that sensitive data is protected
   - **Story Points**: 5
   - **Tasks**:
     - Create Secrets Manager secret for Gemini API key
     - Configure CodeBuild to inject secrets
     - Update application to read from environment
     - Test secret retrieval in deployed environment

- ❌ **What Didn't Work**: GitHub Actions initially planned for AWS CI/CD
  - **Issue**: Complex AWS credential management
  - **Issue**: Long-lived access keys security concerns
  - **Issue**: Manual secret rotation challenges
  - **Owner**: Thelezinhle Buthelezi identified the issues
- ✅ **What We Changed**: Pivoted to AWS CodePipeline with CodeStar Connections
  - **Benefit**: Native AWS integration
  - **Benefit**: Secure GitHub App authentication
  - **Benefit**: No long-lived tokens required
  - **Decision**: Made by team on Saturday, Nov 22
- 📝 **Documentation**: Lerato Matamela documented the pivot and lessons learned

---

## Summary

### Total Project Story Points: 50
**Completed in 1 intensive week** (November 19-25, 2025)

### Team Contributions
- **Thelezinhle Buthelezi (AWS Deployment)**:
  - CloudFormation template design and implementation
  - CodeBuild and CodePipeline configuration
  - GitHub Actions pivot to CodeStar Connections
  - IAM roles and Secrets Manager setup
  - AWS testing and verification
  
- **Thato Rapholo (Azure Deployment)**:
  - Bicep template design and implementation
  - Azure Pipelines YAML configuration
  - Managed Identity setup
  - Azure Key Vault integration
  - Azure testing and verification

- **Lerato Matamela (Pipelines & Documentation)**:
  - README.md and deployment guides
  - Sprint planning and reflection documents
  - GitHub Actions failure documentation
  - IAM/RBAC export scripts
  - Screenshot checklists
  - Technical writing and editing
  - Cross-platform pipeline coordination

### Key Milestones (1 Week Timeline)
1. ✅ **Nov 19-20**: Working application with tests
2. ✅ **Nov 21-22**: AWS & Azure deployments (pivot from GitHub Actions)
3. ✅ **Nov 23-24**: Documentation and testing
4. ✅ **Nov 25**: Final review and submission preparation

### Risk Management

| Risk | Mitigation | Status |
|------|------------|--------|
| GitHub Actions complexity for AWS | Pivoted to CodeStar Connections | ✅ Resolved |
| Cross-cloud environment differences | Abstracted configuration via env vars | ✅ Mitigated |
| API key exposure | Cloud-native secret managers | ✅ Mitigated |
| Limited Azure experience | Followed Microsoft documentation closely | ✅ Managed |
| Time constraints | Prioritized MVP, documented alternatives | ✅ Managed |

### Definition of Done
- [ ] Code compiles and tests pass
- [ ] Infrastructure deployed via IaC
- [ ] Security best practices implemented
- [ ] Documentation complete and clear
- [ ] Screenshots captured for submission
- [ ] Both cloud deployments working
- [ ] Sprint retrospective completed

---

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                        GitHub Repository                     │
│              (Single Source of Truth - Main Branch)          │
└────────────┬──────────────────────────────┬─────────────────┘
             │                               │
             │ CodeStar Connection           │ Azure DevOps
             │ (Webhook)                     │ Integration
             ▼                               ▼
    ┌────────────────────┐         ┌────────────────────┐
    │   AWS CodePipeline │         │  Azure Pipelines   │
    │                    │         │                    │
    │ 1. Source Stage    │         │ 1. Build Stage     │
    │ 2. Build (CodeBuild)│        │ 2. Test Stage      │
    │ 3. Deploy (EB)     │         │ 3. Deploy Stage    │
    └─────────┬──────────┘         └─────────┬──────────┘
              │                               │
              │ Secrets Manager               │ Key Vault
              │ (Gemini API Key)              │ (Gemini API Key)
              ▼                               ▼
    ┌────────────────────┐         ┌────────────────────┐
    │ Elastic Beanstalk  │         │  Azure App Service │
    │ (Node.js Platform) │         │  (Node.js Runtime) │
    │                    │         │                    │
    │ Express + Gemini   │         │  Express + Gemini  │
    └────────────────────┘         └────────────────────┘
```

---

## Presentation Slide Suggestions

### Slide 1: Title
- **Multi-Cloud Deployment Project**
- Node.js AI Content Generator
- AWS + Azure CI/CD Pipelines

### Slide 2: Project Overview
- Application: AI-powered content generator (Gemini API)
- Multi-cloud: AWS & Azure deployments
- Automated CI/CD pipelines
- Infrastructure as Code

### Slide 3: Project Timeline (1 Week)
- **Nov 19-20**: Foundation (App + Tests)
- **Nov 21-22**: AWS & Azure Pipelines (GitHub Actions Pivot)
- **Nov 23-24**: Documentation & Testing
- **Nov 25**: Final Review & Submission

### Slide 4: Technical Architecture
- [Use architecture diagram above]
- Source → Build → Test → Deploy (both clouds)

### Slide 5: Key Challenges & Solutions
- ❌ Challenge: GitHub Actions complexity
- ✅ Solution: AWS CodeStar Connections
- ✅ Learning: Native cloud integrations > generic CI/CD

### Slide 6: Security Implementation
- AWS: IAM roles, Secrets Manager
- Azure: Managed Identities, Key Vault
- No hardcoded secrets
- Least-privilege access

### Slide 7: Results & Deliverables
- 2 working cloud deployments
- 100% test coverage
- Complete IaC templates
- Comprehensive documentation

### Slide 8: Key Learnings
- Multi-cloud strategies
- DevOps best practices
- Security-first approach
- Agile adaptation (sprint pivot)

---

**Document Version**: 1.0  
**Last Updated**: November 25, 2025  
**Team Members**:
- Lerato Matamela (Pipelines & Documentation)
- Thelezinhle Buthelezi (AWS Deployment)
- Thato Rapholo (Azure Deployment)
