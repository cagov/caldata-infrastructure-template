# CalData Infrastructure Template

![test](https://github.com/cagov/caldata-infrastructure-template/actions/workflows/test.yml/badge.svg?branch=main)

This repository is a [copier](https://copier.readthedocs.io/en/stable/) template
which can be used to quickly seed a modern data stack project.
It consists of:

1. A [dbt](https://docs.getdbt.com/) project.
1. [pre-commit](https://pre-commit.com/) checks for enforcing code-quality.
1. A [documentation skeleton](https://cagov.github.io/caldata-infrastructure-template) using [mkdocs-material](https://squidfunk.github.io/mkdocs-material/)
1. GitHub actions for running quality checks in continuous integration (CI)

## Usage

Start with a Python environment. Install `copier`:

```bash
python -m pip install copier
```

Create a directory into which the project will be rendered:

```bash
mkdir <your-project-name>
cd <your-project-name>
```

Create a new project using the copier command-line tool, with HTTPS:
```bash
copier copy https://github.com/cagov/caldata-infrastructure-template .
```
OR with SSH:
```bash
copier copy git@github.com:cagov/caldata-infrastructure-template.git .
```

This will ask you a series of questions, the answers to which will be used to populate the project.

Once the project is rendered, you should initialize it as a git repository:

```bash
git init
git add .
git commit -m "Initial commit"
```

### BigQuery setup

Using the dbt project with BigQuery requires the following setup steps:
* Users must set up their dbt profile locally to develop as themselves.
  Instructions for this can be found in the "Local Development" section of the dbt project README.
* Repository owners must set up a service account in GCP for continuous integration to
  be able to run against a test GCP project:
    * Go to the "Service Accounts" section in the Google Cloud Console.
    * Click "Create Service Account"
    * Make a new service account with a name like `<my-project-name>-dbt-ci-bot`.
      Give that account the IAM role of "BigQuery Metadata Viewer".
    * Go to the "Keys" tab and create a new JSON private key.
    * In the GitHub page for your new repository, go to `Settings -> Secrets and Variables -> Actions`
    * Create a new repository secret called `GOOGLE_CREDENTIALS` and paste the JSON key
      into the value for the secret. This should allow CI to authenticate with your
      test BigQuery project and view metadata for datasets and tables.

### Snowflake setup

The projects generated from our infrastructure template need read access to the
Snowflake account in order to do two things from GitHub actions:

1. Verify that dbt models in branches compile and pass linter checks
1. Generate dbt docs upon merge to `main`.

The terraform configurations deployed above create two service accounts
for GitHub actions, a production one for docs and a dev one for CI checks.

#### Add key pairs to the GitHub service accounts

This repository assumes two service accounts in Snowflake for usage with GitHub Actions.
Set up key pairs for the two GitHub actions service accounts
(`GITHUB_ACTIONS_SVC_USER_DEV` and `GITHUB_ACTIONS_SVC_USER_PRD`) following the instructions given
[here](https://docs.snowflake.com/en/user-guide/key-pair-auth#configuring-key-pair-authentication).

#### Set up GitHub actions secrets

In order for the service accounts to be able to connect to your Snowflake account
you need to configure secrets in GitHub actions
From the repository page, go to "Settings", then to "Secrets and variables", then to "Actions".

Add the following repository secrets:

| Variable | Value |
|----------|-------|
| `SNOWFLAKE_ACCOUNT` | new account locator |
| `SNOWFLAKE_USER_DEV` | `GITHUB_ACTIONS_SVC_USER_DEV` |
| `SNOWFLAKE_USER_PRD` | `GITHUB_ACTIONS_SVC_USER_PRD` |
| `SNOWFLAKE_PRIVATE_KEY_DEV` | dev service account private key |
| `SNOWFLAKE_PRIVATE_KEY_PRD` | prd service account private key |

### Enable GitHub pages for the repository

The repository must have GitHub pages enabled in order for it to deploy and be viewable.

1. From the repository page, go to "Settings", then to "Pages".
1. Under "GitHub Pages visibility" select "Private" (unless the project is public!).
1. Under "Build and deployment" select "Deploy from a branch" and choose "gh-pages" as your branch.

## Testing

Continuous integration for this template creates a new project from the template,
then verifies that the `pre-commit` checks pass.
Future versions might do additional checks
(e.g., running sample dbt models or orchestration DAGs).

To run the tests locally, change directories to the *parent* of the template,
then run

```bash
./caldata-infrastructure-template/ci/test.sh
```
