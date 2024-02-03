variable "aws_config_file_path" {
  description = "path to aws config"
  type = string
}
variable "aws_credentials_file_path" {
  description = "path to aws credentials"
  type = string
}
variable "aws_profile" {
  description = "aws profile to use"
  type = string
}
variable "vpc_id" {
  description = "vpc id"
  type = string
}
variable "public_key" {
  description = "public key for minecraft server key pair"
  type = string
}
variable "home_ipv4_cidr" {
  description = "my ip address for security group whitelist"
  type = string
}