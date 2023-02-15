# CalData Infrastructure Template

This repository is a [copier](https://copier.readthedocs.io/en/stable/) template
which can be used to quickly seed a modern data stack project.
It consists of:

1. A [dbt](https://docs.getdbt.com/) project.
1. [pre-commit](https://pre-commit.com/) checks for enforcing code-quality.
1. GitHub actions for running quality checks in continuous integration (CI)

## Usage

Start with a Python environment. Install `copier`:

```bash
python -m pip install copier
```

Create a new project using the copier command-line tool:

```bash
copier copy https://github.com/cagov/caldata-infrastructure-template .
```

This will ask you a series of questions, the answers to which will be used to populate th project.

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
