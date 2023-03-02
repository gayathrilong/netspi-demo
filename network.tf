resource "aws_vpc" "spi_vpc" {
    cidr_block = var.vpc_cidr
}

resource "aws_vpc_dhcp_options" "dns_resolver" {
  domain_name_servers = ["169.254.169.253", "8.8.8.8"]
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = aws_vpc.spi_vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.dns_resolver.id
}

resource "aws_internet_gateway" "spi_gateway" {
  vpc_id = aws_vpc.spi_vpc.id
}
 
 resource "aws_route_table" "spi_public" {
  vpc_id = aws_vpc.spi_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.spi_gateway.id
  }
 }

resource "aws_route_table_association" "spi_public" {
  subnet_id      = aws_subnet.spi_subnet.id
  route_table_id = aws_route_table.spi_public.id
}

resource "aws_subnet" "spi_subnet" {
    vpc_id = aws_vpc.spi_vpc.id
    cidr_block = var.subnet_cidr
    availability_zone = var.availability_zone
  }

output "subnet_id" {
    value = aws_subnet.spi_subnet.id
}