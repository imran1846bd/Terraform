# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "MyVPC"
  }
}
#Creating public and private subnets
resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "MyPublicSubnet"

  }
}
resource "aws_subnet" "subnet2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name : "MyPrivateSubnet"
  }
}
# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags = {
    Name = "MyInternetGateway"
  }
}			
resource "aws_route_table" "routetable" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id

  }
}
resource "aws_route_table_association" "subnetassociation" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.routetable.id
}
resource "aws_security_group" "ec2sg" {
  name        = "MyEC2Server_SG"
  description = "Security Group to allow traffic to the EC2"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "whiz_sg"
  }
}
#######################Launching first EC2 instance #####################
resource "aws_instance" "instance" {
  ami                         = "ami-02e136e904f3da870"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.ec2sg.id]
  subnet_id                   = aws_subnet.subnet1.id
  associate_public_ip_address = true
  key_name                    = "WhizKey"
  tags = {
    Name : "MyPublicEC2Server"
  }
  depends_on = [aws_security_group.ec2sg]
}
resource "aws_instance" "instance2" {
  ami                         = "ami-02e136e904f3da870"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.ec2sg.id]
  subnet_id                   = aws_subnet.subnet2.id
  associate_public_ip_address = false
  key_name                    = "WhizKey"
  tags = {
    Name : "MyPrivateEC2Server"
  }
  depends_on = [aws_security_group.ec2sg]
}
resource "aws_nat_gateway" "NATGateway" {
  allocation_id = aws_eip.elasticIP.id
  subnet_id     = aws_subnet.subnet1.id
  tags = {
    Name = "MyNATGateway"
  }
}
resource "aws_eip" "elasticIP" {
  domain   = "vpc"
}
#Update Route Table
resource "aws_route" "update" {
  route_table_id            = aws_vpc.vpc.main_route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = "${aws_nat_gateway.NATGateway.id}"
}			