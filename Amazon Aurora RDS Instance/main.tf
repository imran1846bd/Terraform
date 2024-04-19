provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}
############################### Default VPC CREATION #############################
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
############################## Creating Security Groups #############################

resource "aws_security_group" "allow_aurora" {
  name        = "Aurora_lab_sg"
  description = "Security group for RDS Aurora"
  ingress {
    description = "MYSQL/Aurora"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

################################ Creating Creating DB Subnet Group #############################
resource "aws_db_subnet_group" "mydb_subnet_group" {
  name = "mydb_subnet_group"
  subnet_ids = [
    data.aws_subnet.subnet1.id,
    data.aws_subnet.subnet2.id
  ]
  tags = {
    name = "MyDBSubnetGroup"
  }

}

resource "aws_rds_cluster" "aurorards" {
  cluster_identifier     = "myauroracluster"
  engine                 = "aurora-mysql"
  engine_version         = "5.7.mysql_aurora.2.12.0"
  database_name          = "MyDB"
  master_username        = "WhizlabsAdmin"
  master_password        = "Whizlabs123"
  vpc_security_group_ids = [aws_security_group.allow_aurora.id]
  db_subnet_group_name   = aws_db_subnet_group.mydb_subnet_group.name
  storage_encrypted      = false
  skip_final_snapshot    = true
}
resource "aws_rds_cluster_instance" "cluster_instances" {
  identifier         = "muaurorainstance"
  cluster_identifier = aws_rds_cluster.aurorards.id
  instance_class     = "db.t3.small"
  engine             = aws_rds_cluster.aurorards.engine
  engine_version     = aws_rds_cluster.aurorards.engine_version
}