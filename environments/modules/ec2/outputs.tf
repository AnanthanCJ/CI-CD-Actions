output "instance_ips" {
  description = "Elastic (public) IP addresses of the EC2 instances"
  value       = aws_eip.test1-eip[*].public_ip
}