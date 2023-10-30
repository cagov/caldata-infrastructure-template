#!/bin/bash

set -euxo pipefail

TEAM_NAME="Test team"
FRIENDLY_PROJECT_NAME="Sample Project"
PROJECT_NAME="sample-project"

# Run copier.
for TARGET in Snowflake BigQuery; do
    DIRECTORY=${PROJECT_NAME}-${TARGET}

    # Enter the new project
    mkdir -p $DIRECTORY
    pushd $DIRECTORY

    copier copy \
        --data project_name=$DIRECTORY \
        --data friendly_project_name="$FRIENDLY_PROJECT_NAME" \
        --data team_name="$TEAM_NAME" \
        --data email_address="test@test.com" \
        --data license=MIT \
        --data dbt_target=$TARGET \
        --data dbt_profile_name="default" \
        ../caldata-infrastructure-template/ . 

    # Initialize git
    git init
    git add .
    git commit -m "Initial commit"

    # Install the dependencies
    poetry install --with dev

    # Run quality checks
    poetry run pre-commit run --all-files

    # Verify that the docs build
    pushd transform
    poetry run dbt deps
    poetry run dbt docs generate
    popd

    cp -r transform/target docs/dbt_docs
    poetry run mkdocs build

    popd
done
