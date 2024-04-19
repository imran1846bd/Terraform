provider "aws" {
  region     = var.region
  secret_key = var.secret_key
  access_key = var.access_key
}
################################  Default VPC and Subnets for AWS #################################
data "aws_vpc" "default" {
  default = true
}
data "aws_subnet" "subnet1" {
  vpc_id            = data.aws_vpc.default.id
  availability_zone = "us-east-1a"
}
data "aws_subnet" "subnet2" {
  vpc_id            = data.aws_vpc.default.id
  availability_zone = "us-east-1b"
}


################################ Creating a security group for AWS #################################




resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "AWS Security Group  for rds_sg"
  vpc_id      = data.aws_vpc.default.id
  ingress {
    description = "MYSQL"
    from_port   = 3306
    to_port     = 3006
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }



  egress {
    from_port   = 3306
    to_port     = 3006
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
