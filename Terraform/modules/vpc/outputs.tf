output "vpc_id" {
  description = "The ID of the VPC"
  value       = concat(aws_vpc.this.*.id, [""])[0]
}

output "public_subnet_01_id" {
  description = "Public subnet ID"
  value       = aws_subnet.public-subnet01.id
}

output "public_subnet_02_id" {
  description = "Public subnet ID"
  value       = aws_subnet.public-subnet02.id
}

output "private_subnet_01_id" {
  description = "Private subnet ID"
  value       = aws_subnet.private-subnet01.id
}

output "private_subnet_02_id" {
  description = "Private subnet ID"
  value       = aws_subnet.private-subnet02.id
}

