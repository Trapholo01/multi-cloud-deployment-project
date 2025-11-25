# Manual Deployment Guide (No AWS CLI Required)

This guide walks you through deploying the pipeline using only the AWS Console web interface.

---

## Prerequisites

- AWS account with access to the Console
- GitHub account
- Gemini API key

---

## Step 1: Create CodeStar Connection (via Console)

1. **Open AWS Console** and sign in: https://console.aws.amazon.com/
2. Go to **Developer Tools** → **Settings** → **Connections**: https://console.aws.amazon.com/codesuite/settings/connections
3. Click **"Create connection"**
4. Select **"GitHub"** as provider
5. Connection name: `github-connection`
6. Click **"Connect to GitHub"**
7. Click **"Authorize AWS"** and complete GitHub authorization
8. Select your repository: `Trapholo01/multi-cloud-deployment-project`
9. Click **"Connect"**
10. **Copy the Connection ARN** shown on the success page (format: `arn:aws:codestar-connections:us-east-1:ACCOUNT:connection/xxxxx`)
    - Save this ARN in a text file for Step 3

---

## Step 2: Create Secrets Manager Secret (via Console)

1. Go to **Secrets Manager**: https://console.aws.amazon.com/secretsmanager/
2. Click **"Store a new secret"**
3. Select **"Other type of secret"**
4. Click **"Plaintext"** tab
5. Paste this JSON (replace YOUR_GEMINI_KEY with your actual key):
   ```json
   {
     "GEMINI_API_KEY": "YOUR_GEMINI_KEY_HERE"
   }
   ```
6. Click **"Next"**
7. Secret name: `my/gemini-key`
8. Click **"Next"** → **"Next"** → **"Store"**
9. **Copy the secret name**: `my/gemini-key` (save for Step 3)

**To get Gemini API key**: https://aistudio.google.com/app/apikey

---

## Step 3: Create S3 Bucket for Artifacts (via Console)

1. Go to **S3**: https://s3.console.aws.amazon.com/s3/
2. Click **"Create bucket"**
3. Bucket name: `mcd-pipeline-artifacts-20251125-YOURACCOUNTID` (must be globally unique)
   - Replace YOURACCOUNTID with any random number
   - Example: `mcd-pipeline-artifacts-20251125-98765`
4. Region: **US East (N. Virginia) us-east-1**
5. Keep all other defaults
6. Click **"Create bucket"**
7. **Copy the bucket name** (save for Step 4)

---

## Step 4: Deploy CloudFormation Stack (via Console)

1. Go to **CloudFormation**: https://console.aws.amazon.com/cloudformation/
2. Click **"Create stack"** → **"With new resources (standard)"**
3. In **"Specify template"**:
   - Select **"Upload a template file"**
   - Click **"Choose file"**
   - Navigate to your project folder: `C:\Users\lerat\Documents\New folder\multi-cloud-deployment-project\cloudformation\`
   - Select **`codepipeline.yml`**
   - Click **"Next"**

4. **Stack details** (enter these parameters):
   - **Stack name**: `multi-cloud-pipeline`
   - **Parameters**:
     - `GitHubOwner`: `Trapholo01`
     - `GitHubRepo`: `multi-cloud-deployment-project`
     - `GitHubBranch`: `main`
     - `CodeStarConnectionArn`: *Paste the ARN from Step 1*
     - `GitHubOAuthSecretName`: `placeholder` (not used with CodeStar)
     - `GeminiSecretName`: `my/gemini-key`
     - `ArtifactBucket`: *Paste bucket name from Step 3*
     - `EBPlatform`: `64bit Amazon Linux 2 v3.4.12 running Node.js` (keep default)
   - Click **"Next"**

5. **Configure stack options**:
   - Leave defaults
   - Click **"Next"**

6. **Review**:
   - Scroll to bottom
   - Check ✅ **"I acknowledge that AWS CloudFormation might create IAM resources with custom names"**
   - Click **"Submit"**

7. **Wait for deployment** (5-10 minutes):
   - Status will show `CREATE_IN_PROGRESS`
   - Refresh the page periodically
   - When complete, status will show `CREATE_COMPLETE`

---

## Step 5: Trigger the Pipeline

### Option A: Push a commit via GitHub website

1. Go to your GitHub repo: https://github.com/Trapholo01/multi-cloud-deployment-project
2. Click any file (e.g., `README.md`)
3. Click the ✏️ pencil icon (Edit)
4. Make a small change (add a blank line)
5. Click **"Commit changes"**
6. This will trigger the pipeline automatically

### Option B: Push a commit via Git locally (if you have Git installed)

```powershell
cd "C:\Users\lerat\Documents\New folder\multi-cloud-deployment-project"
git add .
git commit -m "Trigger pipeline"
git push origin main
```

---

## Step 6: Monitor Pipeline Execution

1. Go to **CodePipeline**: https://console.aws.amazon.com/codesuite/codepipeline/pipelines
2. Click your pipeline (will be named something like `Pipeline-xxxxx`)
3. Watch the stages:
   - **Source** (fetches code from GitHub) → should turn green
   - **Build** (runs tests, creates artifact) → should turn green  
   - **Deploy** (deploys to Elastic Beanstalk) → should turn green
4. If any stage fails, click it to see error details

---

## Step 7: Export IAM Roles for Screenshots

### Option A: Manual export via Console

1. Go to **IAM Roles**: https://console.aws.amazon.com/iam/home#/roles
2. Search for: `multi-cloud-pipeline`
3. You should see 2 roles:
   - `multi-cloud-pipeline-CodeBuildRole-xxxxx`
   - `multi-cloud-pipeline-PipelineRole-xxxxx`
4. Click each role and capture screenshots of:
   - **Permissions** tab (all policies expanded)
   - **Trust relationships** tab

### Option B: Use the export script (requires AWS CLI)

If you later install AWS CLI:
```powershell
.\export-iam-roles.ps1 -StackName multi-cloud-pipeline -Region us-east-1
```

---

## Step 8: Take Screenshots for Assignment

Follow the checklist in `IAM-SCREENSHOT-CHECKLIST.md`:

1. **IAM Roles** (2 roles × permissions + trust policy)
2. **CloudFormation Stack** (resources, parameters, outputs)
3. **CodePipeline** (stages and execution history)
4. **Elastic Beanstalk** (application and environment)
5. **Secrets Manager** (secret name only, NOT the value)

Use **Windows Snipping Tool**: Press `Win + Shift + S`

---

## Verification Checklist

After deployment, verify:

- ✅ CloudFormation stack status = `CREATE_COMPLETE`
- ✅ CodePipeline exists and shows 3 stages (Source, Build, Deploy)
- ✅ 2 IAM roles created with names containing your stack name
- ✅ Elastic Beanstalk application and environment created
- ✅ S3 artifact bucket contains pipeline artifacts after first run
- ✅ Pipeline execution completes successfully (all stages green)

---

## Troubleshooting

### CodeStar Connection Fails
- Go to Connections page and verify status is **"Available"**
- If "Pending", click the connection and complete authorization

### CloudFormation Stack Creation Fails
- Check the **Events** tab in CloudFormation for error details
- Common issues:
  - Invalid CodeStar Connection ARN
  - Secret name doesn't exist
  - Bucket name already taken (try a different name)
  - Insufficient IAM permissions

### Pipeline Fails at Build Stage
- Go to **CodeBuild** → **Build projects** → Click project → **Build history**
- Click failed build → View **Phase details** and **Logs**
- Common issues:
  - Tests failing (check `npm test` locally first)
  - Missing dependencies

### Pipeline Fails at Deploy Stage
- Go to **Elastic Beanstalk** → Click environment → **Logs**
- Common issues:
  - Application crashes on startup
  - Invalid Node.js platform version

---

## Need Help?

If you encounter errors:
1. Check the AWS Console error messages
2. Look at CloudFormation **Events** tab for stack creation errors
3. Check CodePipeline execution details for stage-specific errors
4. Review CloudWatch Logs for CodeBuild and Elastic Beanstalk

---

## Success! What You've Deployed

✅ **Full CI/CD Pipeline**:
- Source: GitHub via CodeStar Connections
- Build: CodeBuild running tests and creating deployment artifact
- Deploy: Elastic Beanstalk hosting your Node.js app

✅ **Security**: 
- Least-privilege IAM roles
- Secrets in Secrets Manager
- No long-lived tokens

✅ **Infrastructure as Code**:
- All resources defined in CloudFormation template
- Reproducible and version-controlled

---

**Next**: Take your screenshots and document the deployment! 📸
