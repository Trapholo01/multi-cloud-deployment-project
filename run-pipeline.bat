@echo off
echo MULTI-CLOUD CI/CD PIPELINE
echo.
echo [STAGE 1] Environment
dir /B
echo.
echo [STAGE 2] Backend
if exist backend (
  cd backend
  npm install
  cd ..
  xcopy backend artifacts\backend-build /E /I /Y >nul
  echo Backend done
)
echo.
echo [STAGE 3] Frontend
if exist frontend (
  xcopy frontend artifacts\frontend-build /E /I /Y >nul
  echo Frontend done
)
echo.
echo [STAGE 4] Deployment
mkdir artifacts 2>nul
echo Ready for AWS + Azure > artifacts\status.txt
echo.
echo [DONE] Pipeline complete
dir artifacts /B
