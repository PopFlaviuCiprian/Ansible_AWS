provider "aws" {
  region = "eu-central-1" # Choose the AWS region
}

resource "aws_instance" "simple" {
  count                  = 4
  ami                    = "ami-0292a7daeeda6b851"
  instance_type          = "t2.micro"
  key_name               = "ansible_key_frankfurt"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "node-${count.index + 1}"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow-ssh"
  description = "Allow inbound SSH traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow ssh from any ip
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic on this port from any ip
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # Allow all the traffic
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic from any ip
  }
}

output "controller_node_ip" {
  value = aws_instance.simple[0].public_ip
}

output "nodes_ips" {
  value = aws_instance.simple[*].public_ip
}
