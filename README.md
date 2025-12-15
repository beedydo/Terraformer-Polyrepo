# govtech-dre-aip-terraform

This repository contains separate Terraform roots per component (vpc, ec2, s3)
and per environment (dev, staging, prod). Each leaf directory is an independent
Terraform root module with its own state/backend, variables, and provider
configuration.
