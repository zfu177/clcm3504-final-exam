provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP inbound traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name          = "techco-web-server"
    Administrator = "z.fu177@mybvc.ca"
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0230bd60aa48260c6"
  instance_type = "t2.micro"
  user_data     = file("${path.module}/userdata.sh")

  vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]

  tags = {
    Name          = "techco-web-server"
    Administrator = "z.fu177@mybvc.ca"
  }
}

output "aws_instance_id" {
  value = aws_instance.web.id
}

output "aws_instance_public_dns" {
  value = aws_instance.web.public_dns
}
