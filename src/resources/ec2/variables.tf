
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "my_public_ip" {
  description = "Your public IP address (leave blank to auto-detect)"
  type        = string
  default     = ""
}

##########################################################
###################### EC2 Terratest ######################
##########################################################

variable "terratest_instance_ami" {
  description = "AMI ID for terratest EC2 instance"
  type        = string
  default     = "ami-05f071c65e32875a8" 
}

variable "terratest_instance_type" {
  description = "Instance type for terratest EC2"
  type        = string
  default     = "t3.micro"
}

variable "terratest_key_name" {
  description = "EC2 key pair name for SSH access"
  type        = string
  default     = "terraformer-key"
}

variable "terratest_instance_name" {
  description = "Name tag for terratest EC2 instance"
  type        = string
  default     = "terratest-instance"
}

variable "terratest_security_group_name" {
  description = "Security group name for terratest EC2"
  type        = string
  default     = "terratest-sg"
}

variable "terratest_eip_allocation_id" {
  description = "Elastic IP allocation ID for terratest instance"
  type        = string
  default     = ""
}

