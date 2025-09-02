# Google Cloud Data Platform with Terraform

This project sets up Google Cloud services using Terraform:
- Google Cloud Storage (GCS)
- BigQuery
- Dataflow (Python code)

## How to run

Use the Makefile commands:

```bash
# Setup dependencies
make setup

# Initialize Terraform
make tf-init

# Plan infrastructure changes
make tf-plan

# Apply infrastructure changes
make tf-apply

# Run the Python ETL pipeline
make py-run

# Destroy infrastructure
make tf-destroy

# Clean up local files
make clean
```

## How it works

1. Uses [modules](/terraform/modules) to create resources
2. [main.tf](terraform/main.tf) is the main setup file