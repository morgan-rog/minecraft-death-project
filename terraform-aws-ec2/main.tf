terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region                   = "us-east-2"
  shared_config_files      = [var.aws_config_file_path]
  shared_credentials_files = [var.aws_credentials_file_path]
  profile                  = var.aws_profile
}

resource "aws_key_pair" "minecraft_server_key" {
  key_name   = "minecraft-server-key"
  public_key = var.public_key
}

resource "aws_security_group" "minecraft_ssh" {
  name        = "minecraft_ssh"
  description = "Security groups with ports open for minecraft-death-server and SSH"
  vpc_id      = var.vpc_id

  tags = {
    Name = "minecraft_ssh"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.minecraft_ssh.id
  # EC2 Instance Connect from the aws console
  cidr_ipv4   = "3.16.146.0/29"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_tcp_ipv4" {
  security_group_id = aws_security_group.minecraft_ssh.id
  # minecraft port, pass my ip
  #cidr_ipv4         = "0.0.0.0/0"
  cidr_ipv4   = var.home_ipv4_cidr
  from_port   = 25565
  ip_protocol = "tcp"
  to_port     = 25565
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.minecraft_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
##############
## INSTANCE ##
##############
resource "aws_instance" "minecraft_death_server" {
  ami                    = "ami-0beec7f2863e681cf" # Amazon Linux 2023 AMI
  instance_type          = "t4g.small"
  key_name               = aws_key_pair.minecraft_server_key.key_name
  vpc_security_group_ids = [aws_security_group.minecraft_ssh.id]
  #user_data = file("../setup.sh")

  ebs_block_device {
    device_name = "/dev/xvda"
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name = "minecraft-death-server"
  }

  user_data = file("../minecraft-spigot-setup.sh")
}
