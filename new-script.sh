# ├── src/
# │   ├── environments/
# │   │   ├── dev.tfvars
# │   │   ├── stage.tfvars
# │   │   └── prod.tfvars
# │   └── resources/
# │       ├── vpc/
# │       │   ├── main.tf
# │       │   ├── outputs.tf
# │       │   ├── provider.tf
# │       │   ├── terraform.tfvars
# │       │   └── variables.tf
# │       ├── ec2/     # Same structure
# │       └── s3/      # Same structure
# └── README.md

#!/usr/bin/env bash
set -euo pipefail

# Centralized version and default region
TERRAFORM_REQUIRED_VERSION=">= 1.8.0"
DEFAULT_AWS_REGION="ap-southeast-1"

# Create environments directory and tfvars files
echo "Creating environments tfvars..."
mkdir -p src/environments

cat > src/environments/dev.tfvars << 'EOF'
# Dev Environment
aws_region  = "ap-southeast-1"
vpc_cidr    = "10.0.0.0/24"
vpc_name    = "dev-vpc"
EOF

cat > src/environments/stage.tfvars << 'EOF'
# Stage Environment
aws_region  = "ap-southeast-1"
vpc_cidr    = "10.1.0.0/24"
vpc_name    = "stage-vpc"
EOF

cat > src/environments/prod.tfvars << 'EOF'
# Prod Environment
aws_region  = "ap-southeast-1"
vpc_cidr    = "10.2.0.0/16"
vpc_name    = "prod-vpc"
EOF

# Components (modules under resources/)
COMPONENTS=("vpc" "ec2" "s3")

for component in "${COMPONENTS[@]}"; do
  dir="src/resources/${component}"
  echo "Creating directory: ${dir}"
  mkdir -p "${dir}"

  # Create ALL Terraform files if they don't exist
  for file in main.tf outputs.tf provider.tf variables.tf; do
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

# Top-level README
cat > README.md <<'EOF'
# Terraform Monorepo Structure

## Directory Structure
# ├── src/
# │   ├── environments/
# │   │   ├── dev.tfvars
# │   │   ├── stage.tfvars
# │   │   └── prod.tfvars
# │   └── resources/
# │       ├── vpc/
# │       │   ├── main.tf
# │       │   ├── outputs.tf
# │       │   ├── provider.tf
# │       │   ├── terraform.tfvars
# │       │   └── variables.tf
# │       ├── ec2/     # Same structure
# │       └── s3/      # Same structure
# └── README.md

