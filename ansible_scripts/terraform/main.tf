provider "aws" {
  region = "ap-south-1"
}


resource "aws_security_group" "tomcat_sg" {
  name        = "tomcat-sg"
  description = "Allow SSH and HTTP"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "tomcat" {
  count = var.ec2_instance_count
  ami           = "ami-0144277607031eca2" # Amazon Linux 2 AMI (update as needed)
  instance_type = "t2.micro"
  key_name      = "syampawan"         # Replace with your key name
  security_groups = [aws_security_group.tomcat_sg.name]
  tags = {
    Name = "TomcatServer"
    Role = "tomcat"
    Env  = "dev"
  }
}

output "tomcatservers_privateIPs" {
  description = "Private IP addresses of all Tomcat EC2 instances"
  value       = aws_instance.tomcat[*].private_ip
}
