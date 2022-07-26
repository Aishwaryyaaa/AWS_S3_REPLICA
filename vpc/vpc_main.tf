#creating vpc
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
}

#public subnet
resource "aws_subnet" "mainpub" {
    count = length(var.public_vpc_cidr)  #sare subnets call krne k liye
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_vpc_cidr[count.index]
  availability_zone = element(var.avail_zone, count.index)  #element se multiple ekdusre k satth connect hoge multiple subnets to avail zone
}

#private subnet
resource "aws_subnet" "mainpri" {
    count = length(var.private_vpc_cidr)  #sare subnets call krne k liye
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_vpc_cidr[count.index]
  availability_zone = element(var.avail_zone, count.index)  #element se multiple ekdusre k satth connect hoge multiple subnets to avail zone
}

#internet gateway
resource "aws_internet_gateway" "gateway_my" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "my"
  }
}

#route table for internet gateway
resource "aws_route_table" "igw" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway_my.id
  }
}

#elastic ip for nat
resource "aws_eip" "my" {
  vpc = true
}

#nat gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.my.id
  subnet_id     = aws_subnet.mainpub[2].id
  
  tags = {
    Name = "gw my NAT"
  }
  depends_on = [aws_internet_gateway.gateway_my]
}

#route table for nat gateway
resource "aws_route_table" "ngw" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
}

#subnet association
resource "aws_route_table_association" "a" {
    count = length(var.private_vpc_cidr)
  subnet_id      = aws_subnet.mainpri[count.index].id
  route_table_id = aws_route_table.ngw.id
}