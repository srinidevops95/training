
####################
#     VPC
####################

resource "aws_vpc" "main_vpc" {
  cidr_block       = var.VPC_CIDR
  instance_tenancy = "default"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  tags = {
    Name = "demo-vpc"
  }
}

#################
### public subnet
#################
resource "aws_subnet" "public_subnet1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.SUBNET_CIDR1
  availability_zone = var.SUBNET_AZ1

  tags = {
    Name = "demo-pub1"
  }
}

#####################
# Public subnet2
####################
### public subnet
resource "aws_subnet" "public_subnet2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.SUBNET_CIDR2
  availability_zone = var.SUBNET_AZ2

  tags = {
    Name = "demo-pub2"
  }
}


##################
### private subnet
##################
resource "aws_subnet" "private_subnet1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.SUBNET_CIDR3
  availability_zone = var.SUBNET_AZ1

  tags = {
    Name = "demo-pri1"
  }
}


##################
#  private subnet2
##################
### public subnet
resource "aws_subnet" "private_subnet2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.SUBNET_CIDR4
  availability_zone = var.SUBNET_AZ2

  tags = {
    Name = "demo-pri2"
  }
}


#########
## IGW
########
resource "aws_internet_gateway" "igw_demo" {

 vpc_id   = aws_vpc.main_vpc.id

tags = {
    Name = "demo-igw"
  }
}



####################
# Public Route Table
###################
resource "aws_route_table" "rt_public" {


 vpc_id   = aws_vpc.main_vpc.id


tags = {
    Name = "demo-pub-rt"
  }
}

#####################
# private route table
#####################
resource "aws_route_table" "rt_private" {


 vpc_id   = aws_vpc.main_vpc.id


tags = {
    Name = "demo-pri-rt"
  }
}


######################
# route table association public
######################
resource "aws_route_table_association" "asso_public1" {


  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.rt_public.id
}

###### Association public subnet2
resource "aws_route_table_association" "asso_public2" {


  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.rt_public.id
}

###igw routing
resource "aws_route" "route1" {
      
  
  route_table_id         = aws_route_table.rt_public.id
  destination_cidr_block = var.CIDR_ALL
  gateway_id             = aws_internet_gateway.igw_demo.id
}





################################
# route table association private1
################################
resource "aws_route_table_association" "asso_private1" {


  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.rt_private .id
}


############ Association private subnet2
resource "aws_route_table_association" "asso_private2" {


  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.rt_private .id
}





################
## NAT
################

resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw_demo]
}


# Private NAT
resource "aws_nat_gateway" "nat_demo" {
  allocation_id     = aws_eip.nat_eip.id
  subnet_id         = aws_subnet.public_subnet2.id
  depends_on        = [aws_internet_gateway.igw_demo]
tags = {
    Name = "demo_nat"
  }
}




####### nat routing
resource "aws_route" "nat_route" {
      
  
  route_table_id         = aws_route_table.rt_private.id
  destination_cidr_block = var.CIDR_ALL
  nat_gateway_id          = aws_nat_gateway.nat_demo.id
}


