#Create VPC in us-east-1
resource "aws_vpc" "vpc_k8s" {
  provider             = aws.region
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-k8s"
  }
}

#Create IGW in us-east-1
resource "aws_internet_gateway" "igw" {
  provider = aws.region
  vpc_id   = aws_vpc.vpc_k8s.id
}


#Get all available AZ's in VPC for master region
data "aws_availability_zones" "azs" {
  provider = aws.region
  state    = "available"
}


#Create subnet # 1 in us-east-1
resource "aws_subnet" "subnet_1" {
  provider          = aws.region
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id            = aws_vpc.vpc_k8s.id
  cidr_block        = "10.0.1.0/24"
}


#Create subnet #2  in us-east-1
resource "aws_subnet" "subnet_2" {
  provider          = aws.region
  vpc_id            = aws_vpc.vpc_k8s.id
  availability_zone = element(data.aws_availability_zones.azs.names, 1)
  cidr_block        = "10.0.2.0/24"
}

#Create subnet #2  in us-east-1
resource "aws_subnet" "subnet_3" {
  provider          = aws.region
  vpc_id            = aws_vpc.vpc_k8s.id
  availability_zone = element(data.aws_availability_zones.azs.names, 2)
  cidr_block        = "10.0.3.0/24"
}

#Create route table in us-east-1
resource "aws_route_table" "internet_route" {
  provider = aws.region
  vpc_id   = aws_vpc.vpc_k8s.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = "k8s-region-rt"
  }
}

#Overwrite default route table of VPC(Master) with our route table entries
resource "aws_main_route_table_association" "k8s-default-rt-assoc" {
  provider       = aws.region
  vpc_id         = aws_vpc.vpc_k8s.id
  route_table_id = aws_route_table.internet_route.id
}