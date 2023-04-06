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
cd <your-project-name>
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

**TODO**

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
