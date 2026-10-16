resource "aws_vpc" "test-vpc" {
  cidr_block = var.vpc_cidr

}

resource "aws_subnet" "test-subnet" {
  
  cidr_block = var.subnet_cidr
  vpc_id = aws_vpc.test-vpc.id
  availability_zone = var.availability_zone
}

resource "aws_internet_gateway" "test-gateway" {
  vpc_id = aws_vpc.test-vpc.id
}

resource "aws_route_table" "test-route-table" {
  vpc_id = aws_vpc.test-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test-gateway.id
  }
}
 
resource "aws_route_table_association" "test-route-table-association" {
  subnet_id      = aws_subnet.test-subnet.id
  route_table_id = aws_route_table.test-route-table.id
}