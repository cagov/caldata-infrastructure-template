#!/bin/bash

set -euxo pipefail

TEAM_NAME="Test team"
FRIENDLY_PROJECT_NAME="Sample Project"
BQ_PROJECT_NAME="bigquery-sample-project"
SNOWFLAKE_PROJECT_NAME="snowflake-sample-project"
PROJECT_NAME=$SNOWFLAKE_PROJECT_NAME

# Run copier. TODO: parametrize over some different configurations
copier \
    --data project_name=$PROJECT_NAME \
    --data friendly_project_name="$FRIENDLY_PROJECT_NAME" \
    --data team_name="$TEAM_NAME" \
    --data license=MIT \
    --data dbt_target=Snowflake \
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

# Verify that the docs build
dbt deps --project-dir=transform
dbt docs generate --project-dir=transform
cp -r transform/target docs/dbt_docs
mkdocs build
