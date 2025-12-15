# Fetching and storing My_IP
data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}

locals {
  my_ip = coalesce(var.my_public_ip, "${chomp(data.http.myip.response_body)}/32")
}

##########################################################
###################### EC2 Instance ######################
##########################################################

resource "aws_instance" "terratest" {
  ami           = var.terratest_instance_ami
  instance_type = var.terratest_instance_type
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = var.terratest_key_name
  associate_public_ip_address = false
  vpc_security_group_ids = [aws_security_group.terratest_sg.id]

  tags = {
    Name = var.terratest_instance_name
  }
}

# Create Elastic IP automatically
resource "aws_eip" "terratest_eip" {
  domain = "vpc"
  
  tags = {
    Name = "${var.terratest_instance_name}-eip"
  }

  depends_on = [aws_internet_gateway.cicd_igw]
}

resource "aws_eip_association" "terratest_eip" {
  instance_id   = aws_instance.terratest.id
  allocation_id = aws_eip.terratest_eip.id 
}

####################################################
###################### EC2 SG ######################
####################################################

resource "aws_security_group" "terratest_sg" {
  name        = var.terratest_security_group_name
  description = "Security group for terratest ec2 server"
  vpc_id      = aws_vpc.cicd_vpc.id

  # SSH from your IP only
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.my_ip]  # Your IP from data source
  }

  # ICMP (ping) from your IP only
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = [local.my_ip]  # Your IP from data source
  }

  # All outbound traffic allowed
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.terratest_security_group_name
  }
}