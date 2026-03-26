variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  description = "SSH key pair name"
  default     = "awskey"
}
