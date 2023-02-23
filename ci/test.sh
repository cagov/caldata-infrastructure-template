#!/bin/bash

set -euxo pipefail

TEAM_NAME="Test team"
FRIENDLY_PROJECT_NAME="Sample Project"
PROJECT_NAME="sample-project"

# Run copier. TODO: parametrize over some different configurations
copier \
    --data project_name=$PROJECT_NAME \
    --data friendly_project_name="$FRIENDLY_PROJECT_NAME" \
    --data team_name="$TEAM_NAME" \
    --data license=MIT \
    --data use_dbt=true \
    --data dbt_target=BigQuery \
    --data use_orchestrator=false \
    caldata-infrastructure-template/ . 

# Enter the new project
pushd $PROJECT_NAME

# Initialize git
git init
git add .
git commit -m "Initial commit"

# Run quality checks
pre-commit run --all-files
