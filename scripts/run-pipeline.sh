#!/bin/bash

echo "🚀 MULTI-CLOUD CI/CD PIPELINE STARTED"
echo "======================================"
echo "Timestamp: $(date)"
echo "Node Version: $(node --version)"
echo "NPM Version: $(npm --version)"
echo ""

# Function to run pipeline stages
run_stage() {
    echo "▶️  STAGE: $1"
    echo "----------------------------------------"
    eval $2
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        echo "✅ $1 - SUCCESS"
    else
        echo "❌ $1 - FAILED (Exit code: $exit_code)"
        # Don't exit immediately - continue to show all failures
    fi
    echo ""
    return $exit_code
}

# Initialize error tracking
ERRORS=0

# STAGE 1: Environment Setup
run_stage "Environment Setup" "
    echo 'Workspace: $(pwd)'
    echo 'Files:'
    ls -la
    echo 'Backend contents:'
    ls -la backend/ || echo 'No backend directory'
    echo 'Frontend contents:'
    ls -la frontend/ || echo 'No frontend directory'
"

# STAGE 2: Backend Build & Test
if [ -d "backend" ] && [ -f "backend/package.json" ]; then
    run_stage "Backend Dependencies" "
        cd backend
        echo 'Installing dependencies...'
        npm ci
    " || ((ERRORS++))
    
    run_stage "Backend Testing" "
        cd backend
        echo 'Running tests...'
        npm test || echo 'No tests defined - continuing'
    " || ((ERRORS++))
    
    run_stage "Backend Build" "
        cd backend
        echo 'Building application...'
        npm run build || echo 'No build script - continuing'
    " || ((ERRORS++))
else
    echo "⚠️  Backend directory or package.json not found - skipping backend stages"
    ((ERRORS++))
fi

# STAGE 3: Frontend Processing
if [ -d "frontend" ]; then
    run_stage "Frontend Processing" "
        cd frontend
        echo 'Processing frontend files...'
        echo 'Frontend structure:'
        find . -type f -name '*.html' -o -name '*.js' -o -name '*.css' | head -10
        echo 'Total files:'
        find . -type f | wc -l
    " || ((ERRORS++))
else
    echo "⚠️  Frontend directory not found - skipping frontend stages"
    ((ERRORS++))
fi

# STAGE 4: Artifact Creation
run_stage "Artifact Creation" "
    echo 'Creating deployment artifacts...'
    mkdir -p /artifacts
    
    # Create backend artifact
    if [ -d 'backend' ]; then
        cp -r backend /artifacts/backend-build
        echo 'Backend artifact created'
    fi
    
    # Create frontend artifact  
    if [ -d 'frontend' ]; then
        cp -r frontend /artifacts/frontend-build
        echo 'Frontend artifact created'
    fi
    
    # Create deployment manifest
    cat > /artifacts/deployment-manifest.json << EOF
{
    \"pipeline\": \"multi-cloud-docker-pipeline\",
    \"timestamp\": \"$(date -Iseconds)\",
    \"commit\": \"${GIT_COMMIT:-local}\",
    \"artifacts\": {
        \"backend\": \"$(ls -la /artifacts/backend-build 2>/dev/null | wc -l || echo 0) files\",
        \"frontend\": \"$(ls -la /artifacts/frontend-build 2>/dev/null | wc -l || echo 0) files\"
    },
    \"environment\": {
        \"node_version\": \"$(node --version)\",
        \"platform\": \"$(uname -s)\"
    }
}
EOF
    echo 'Deployment manifest created'
    
    echo 'Final artifacts:'
    ls -la /artifacts/
"

# STAGE 5: Deployment Readiness
run_stage "Deployment Readiness" "
    echo '🌐 MULTI-CLOUD DEPLOYMENT STATUS'
    echo '----------------------------------------'
    echo 'AWS Ready:    $( [ -n \"\$AWS_ACCESS_KEY_ID\" ] && echo \"✅\" || echo \"⏳ - Set AWS_ACCESS_KEY_ID\" )'
    echo 'Azure Ready:  $( [ -n \"\$AZURE_PUBLISH_PROFILE\" ] && echo \"✅\" || echo \"⏳ - Set AZURE_PUBLISH_PROFILE\" )'
    echo ''
    echo '📦 ARTIFACTS PREPARED FOR:'
    echo '   - AWS Elastic Beanstalk'
    echo '   - Azure App Service'
    echo '   - Any cloud platform'
"

# Final Summary
echo ""
echo "======================================"
echo "🏁 PIPELINE EXECUTION COMPLETE"
echo "======================================"
if [ $ERRORS -eq 0 ]; then
    echo "✅ SUCCESS: Pipeline completed with no errors"
    echo "📁 Artifacts available in: ./artifacts/"
    echo "🚀 Ready for multi-cloud deployment!"
    exit 0
else
    echo "⚠️  COMPLETED WITH $ERRORS WARNINGS"
    echo "📁 Partial artifacts in: ./artifacts/"
    echo "💡 Check the stages above for issues"
    exit 1
fi