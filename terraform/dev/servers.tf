provider "aws" {
  region = "ap-northeast-1"
}

variable "web_ami-id" {
  default = "ami-0c4c4a62"
}
variable "stage" {
  default = "dev"
}
variable "app_name" {
  default = "Yoshinani"
}

#####################################
# VPC Settings
#####################################
resource "aws_vpc" "yoshinani-vpc" {
  cidr_block = "10.1.0.0/16"
  instance_tenancy = "default"
  tags {
    Name = "${var.app_name}-vpc"
  }
}

#####################################
# Internet Gateway Settings
#####################################
resource "aws_internet_gateway" "yoshinani-vpc-igw" {
  vpc_id = "${aws_vpc.yoshinani-vpc.id}"
  tags {
    Name = "${var.app_name}-igw"
  }
}

#####################################
# Public Subnet Settings
#####################################
resource "aws_subnet" "public-subnet-a" {
  vpc_id = "${aws_vpc.yoshinani-vpc.id}"
  cidr_block = "10.1.1.0/24"
  availability_zone = "ap-northeast-1a"
  tags {
    Name = "${var.app_name}-public-subnet-a"
  }
}

#####################################
# Private Subnet Settings
#####################################
resource "aws_subnet" "private-subnet-a" {
  vpc_id = "${aws_vpc.yoshinani-vpc.id}"
  cidr_block = "10.1.200.0/24"
  availability_zone = "ap-northeast-1a"
  tags {
    Name = "${var.app_name}-private-subnet-a"
  }
}

#####################################
# Route Table Settings
#####################################
resource "aws_route_table" "public-route" {
  vpc_id = "${aws_vpc.yoshinani-vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.yoshinani-vpc-igw.id}"
  }
  tags {
    Name = "${var.app_name} public-rt"
  }
}

resource "aws_route_table_association" "puclic-a" {
  subnet_id = "${aws_subnet.public-subnet-a.id}"
  route_table_id = "${aws_route_table.public-route.id}"
}

resource "aws_instance" "web_server" {
  ami = "${var.web_ami-id}"
  instance_type = "t2.micro"
  tags {
    Name = "${var.app_name}-dev"
  }
}
