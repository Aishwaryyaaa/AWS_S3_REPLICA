#basic instance
resource "aws_instance" "myinstance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.terra-sg.id] #calling sg grp
  user_data              = local.user_data
  key_name = "TF_key"
  #count = 2     #no. of instances
}

#for public key
resource "aws_key_pair" "TF_key" {
  key_name   = "TF_key"
  public_key = tls_private_key.rsa-my.public_key_openssh
}

resource "tls_private_key" "rsa-my" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#creating a file to store private key 
resource "local_file" "tf-pri-key" {
  content  = tls_private_key.rsa-my.private_key_pem
  filename = "tfprikey.pem"
}

#security group (we need vpc id for sg)
#first create sg then we'll call it .. see line 5
resource "aws_security_group" "terra-sg" {
  name        = "sg using terra"
  description = "sg using terra"
  vpc_id      = "vpc-0dae89238b24076a7"
  #ingress for inbound & egress for outbound
  ingress {
    description      = "HTTPS"
    from_port        = 22
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] #anywhere
    ipv6_cidr_blocks = ["::/0"]
  }
  #   ingress {
  #     description      = "HTTP"
  #     from_port        = 80
  #     to_port          = 80
  #     protocol         = "tcp"
  #     cidr_blocks      = ["0.0.0.0/0"] #anywhere
  #     ipv6_cidr_blocks = ["::/0"]
  #   }
  #   ingress {
  #     description      = "SSH"
  #     from_port        = 22
  #     to_port          = 22
  #     protocol         = "tcp"
  #     cidr_blocks      = ["0.0.0.0/0"] #anywhere
  #     ipv6_cidr_blocks = ["::/0"]
  #   }
  #     ingress {
  #     description      = "Custom TCP"
  #     from_port        = 8080
  #     to_port          = 8080
  #     protocol         = "tcp"
  #     cidr_blocks      = ["0.0.0.0/0"] #anywhere
  #     ipv6_cidr_blocks = ["::/0"]
  #   }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"] #anywhere
    ipv6_cidr_blocks = ["::/0"]
  }
}