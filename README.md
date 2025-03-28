# CalData Infrastructure Template

![test](https://github.com/cagov/caldata-infrastructure-template/actions/workflows/test.yml/badge.svg?branch=main)

This repository is a [copier](https://copier.readthedocs.io/en/stable/) template
which can be used to quickly seed a modern data stack project. Instructions may vary depending
on if the repo is hosted via GitHub or Azure DevOps, so we make some distinctions below.

This repo consists of:

1. A [dbt](https://docs.getdbt.com/) project.
1. [pre-commit](https://pre-commit.com/) checks for enforcing code-quality.
1. A [documentation skeleton](https://cagov.github.io/caldata-infrastructure-template) using [mkdocs-material](https://squidfunk.github.io/mkdocs-material/)
1. GitHub actions for running quality checks in continuous integration (CI)

## Usage

Start with a Python environment – we typically use [conda](https://docs.anaconda.com/anaconda/install/), but any environment manager will work. Install `copier` and `poetry`. Check that you have `python` installed or updated as well.:

```bash
pipx install copier poetry
```

Create a repo online and choose `None` for the license. Be sure to add all the necessary team members with the right level of permissions.
Next, create the repo locally into which the project will be rendered:

```bash
mkdir <your-project-name>
cd <your-project-name>
git init
```

Create a new project using the copier command-line tool, with the following prompts below depending on if this is in GitHub or Azure DevOps. This will ask you a series of questions, the answers to which will be used to populate the project.

### GitHub

HTTPS:

```bash
copier copy https://github.com/cagov/caldata-infrastructure-template .
```

OR with SSH:

```bash
copier copy git@github.com:cagov/caldata-infrastructure-template.git .
```

### Azure DevOps

Install git credential manager (with [Homebrew](https://brew.sh/) if on a Mac, if on a windows you should have it by default with [this git instalation](https://git-scm.com/downloads/win).) Then run the following three commands:

```bash
brew install git-credential-manager

git clone <Azure DevOps repo url e.g. https://caldata-sandbox@dev.azure.com/caldata-sandbox/mdsa-test/_git/mdsa-test>

copier copy https://github.com/cagov/caldata-infrastructure-template .
```

Once the project is rendered, you should add and commit the changes:

```bash
git add .
git commit -m "Initial commit"
```

Finally, install the Python dependencies and commit the `poetry.lock`:

```bash
poetry install
git add poetry.lock
git commit -m "Add poetry.lock"
git remote add <new-repo-name> https://github.com/cagov/<new-repo-name>
git push --set-upstream <new-repo-name> main
```

### dbt Cloud setup

For Azure DevOps repos you'll follow the instructions [here](https://docs.getdbt.com/docs/cloud/git/setup-azure#register-an-azure-ad-app).
To integrate dbtCloud with Azure DevOps, the service user (legacy) option must be used. Complete the steps found in the documentation.

For GitHub repos you'll follow the instructions [here](https://docs.getdbt.com/docs/cloud/git/connect-github).

### GitHub-based Snowflake setup

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
| `SNOWFLAKE_ACCOUNT` | <org_name>-<account_name> # format is organization-account |
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
