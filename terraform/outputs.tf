output "public_ip" {
  value       = aws_instance.portfolio_server.public_ip
  description = "Public IP address"
}

output "instance_url" {
  value       = "http://${aws_instance.portfolio_server.public_ip}"
  description = "App URL"
}