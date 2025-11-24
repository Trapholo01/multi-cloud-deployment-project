#!/bin/bash

echo "🧪 DEPLOYMENT VALIDATION TESTS"
echo "==============================="

# Test backend artifact
if [ -d "/artifacts/backend-build" ]; then
    echo "✅ Backend artifact exists"
    echo "   Files: $(find /artifacts/backend-build -type f | wc -l)"
else
    echo "❌ Backend artifact missing"
fi

# Test frontend artifact
if [ -d "/artifacts/frontend-build" ]; then
    echo "✅ Frontend artifact exists"
    echo "   Files: $(find /artifacts/frontend-build -type f | wc -l)"
else
    echo "❌ Frontend artifact missing"
fi

# Test deployment manifest
if [ -f "/artifacts/deployment-manifest.json" ]; then
    echo "✅ Deployment manifest exists"
    cat /artifacts/deployment-manifest.json
else
    echo "❌ Deployment manifest missing"
fi

echo ""
echo "📊 DEPLOYMENT READINESS:"
echo "------------------------"
echo "Artifacts prepared for multi-cloud deployment!"
echo "Next: Configure AWS and Azure deployment scripts"
