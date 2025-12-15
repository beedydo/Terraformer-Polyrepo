variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

#################################################
###################### VPC ######################
#################################################

variable "my_public_ip" {
  description = "Your public IP address (leave blank to auto-detect)"
  type        = string
  default     = ""
}

# VPC Configuration
variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/24"
}

variable "vpc_name" {
  description = "VPC name tag"
  type        = string
  default     = "cicd-vpc"
}

####################################################
###################### Subnet ######################
####################################################

# Subnet Configuration
variable "public_subnet_cidr" {
  description = "Public subnet CIDR block"
  type        = string
  default     = "10.0.0.0/28"
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR block"
  type        = string
  default     = "10.0.0.16/28"
}

variable "availability_zone" {
  description = "Availability zone for subnets"
  type        = string
  default     = "ap-southeast-1a"
}

############################################################
###################### Resource Names ######################
############################################################

variable "internet_gateway_name" {
  description = "Internet Gateway name tag"
  type        = string
  default     = "cicd-igw"
}

variable "public_subnet_name" {
  description = "Public subnet name tag"
  type        = string
  default     = "public-subnet"
}

variable "private_subnet_name" {
  description = "Private subnet name tag"
  type        = string
  default     = "private-subnet"
}

variable "public_route_table_name" {
  description = "Public route table name tag"
  type        = string
  default     = "public-rt"
}

variable "private_route_table_name" {
  description = "Private route table name tag"
  type        = string
  default     = "private-rt"
}

variable "public_nacl_name" {
  description = "Public NACL name tag"
  type        = string
  default     = "public-nacl"
}

variable "private_nacl_name" {
  description = "Private NACL name tag"
  type        = string
  default     = "private-nacl"
}
