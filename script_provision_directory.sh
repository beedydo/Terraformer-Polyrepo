# govtech-dre-aip-terraform/
# ├── vpc/    # For infrastructure as code (AWS resources)
# │   ├── dev/
# │   │   ├── main.tf/
# │   │   ├── output.tf/
# │   │   ├── provider.tf/
# │   │   ├── terraform.tfvars/
# │   │   ├── variables.tf/
# │   │   └── ...
# │   ├── staging/
# │   │   ├── main.tf/
# │   │   ├── output.tf/
# │   │   ├── provider.tf/
# │   │   ├── terraform.tfvars/
# │   │   ├── variables.tf/
# │   │   └── ...
# │   └── prod/
# │       ├── main.tf/
# │       ├── output.tf/
# │       ├── provider.tf/
# │       ├── terraform.tfvars/
# │       ├── variables.tf/
# │       └── ...
# ├── ec2/
# │   ├── dev/
# │   │   ├── main.tf/
# │   │   ├── output.tf/
# │   │   ├── provider.tf/
# │   │   ├── terraform.tfvars/
# │   │   ├── variables.tf/
# │   │   └── ...
# │   ├── staging/
# │   │   ├── main.tf/
# │   │   ├── output.tf/
# │   │   ├── provider.tf/
# │   │   ├── terraform.tfvars/
# │   │   ├── variables.tf/
# │   │   └── ...
# │   └── prod/
# │       ├── main.tf/
# │       ├── output.tf/
# │       ├── provider.tf/
# │       ├── terraform.tfvars/
# │       ├── variables.tf/
# │       └── ...
# ├── s3/
# │   ├── dev/
# │   │   ├── main.tf/
# │   │   ├── output.tf/
# │   │   ├── provider.tf/
# │   │   ├── terraform.tfvars/
# │   │   ├── variables.tf/
# │   │   └── ...
# │   ├── staging/
# │   │   ├── main.tf/
# │   │   ├── output.tf/
# │   │   ├── provider.tf/
# │   │   ├── terraform.tfvars/
# │   │   ├── variables.tf/
# │   │   └── ...
# │   └── prod/
# │       ├── main.tf/
# │       ├── output.tf/
# │       ├── provider.tf/
# │       ├── terraform.tfvars/
# │       ├── variables.tf/
# │       └── ...
# └── README.md

#!/usr/bin/env bash
set -euo pipefail

# Environments and components
ENVS=("dev" "staging" "prod")
COMPONENTS=("vpc" "ec2" "s3")

# Centralized version and default region used when generating files
TERRAFORM_REQUIRED_VERSION=">= 1.8.0"
DEFAULT_AWS_REGION="ap-southeast-1"

for env in "${ENVS[@]}"; do
  for component in "${COMPONENTS[@]}"; do
    dir="${env}/${component}"
    echo "Creating directory: ${dir}"
    mkdir -p "${dir}"

    # Create empty Terraform files if they don't already exist
    for file in main.tf outputs.tf provider.tf terraform.tfvars variables.tf; do
      filepath="${dir}/${file}"
      if [[ ! -f "${filepath}" ]]; then
        touch "${filepath}"
      fi
    done

    # Write provider.tf content only if file is empty
    provider_file="${dir}/provider.tf"
    if [[ ! -s "${provider_file}" ]]; then
      cat > "${provider_file}" <<EOF
terraform {
  required_version = "${TERRAFORM_REQUIRED_VERSION}"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
EOF
    fi

    # Ensure aws_region variable exists in variables.tf
    variables_file="${dir}/variables.tf"
    if ! grep -q 'variable "aws_region"' "${variables_file}"; then
      cat >> "${variables_file}" <<EOF

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "${DEFAULT_AWS_REGION}"
}
EOF
    fi

  done
done

# Top-level README (optional)
if [[ ! -f "README.md" ]]; then
  cat > README.md <<'EOF'
# govtech-dre-aip-terraform

This repository contains separate Terraform roots per component (vpc, ec2, s3)
and per environment (dev, staging, prod). Each leaf directory is an independent
Terraform root module with its own state/backend, variables, and provider
configuration.
EOF
fi

echo "Terraform polyrepo-style structure created."
