output "vpc_id" {
    description = "The ID of the VPC"
    value       = aws_vpc.test-vpc.id
}
output "subnet_id" {
    description = "The ID of the subnet"
    value       = aws_subnet.test-subnet.id
}