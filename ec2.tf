resource "aws_security_group" "ssh_access" {
  name        = "ssh-access"
  description = "Permitir acceso SSH desde mi IPv4"
  vpc_id      = aws_vpc.mi_vpc.id

  ingress {
    description = "SSH desde mi IPv4"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["201.189.206.99/32"] # Permitir desde mi dirección IPv4
  }

  egress {
  description = "Permitir HTTPS de salida para actualizaciones"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh-access"
  }
}

resource "aws_instance" "mi_ec2" {
  ami                     = "ami-0fa8aad99729521be"
  instance_type           = "t2.micro" # Cumple con OPA
  subnet_id               = aws_subnet.subnet_publica_1.id
  vpc_security_group_ids  = [aws_security_group.ssh_access.id]
  disable_api_termination = true
  monitoring              = true
  ebs_optimized           = true
  iam_instance_profile    = aws_iam_instance_profile.ec2_profile.name

  root_block_device {
    encrypted = true 
  }

  metadata_options {
    http_tokens = "required" 
  }

  tags = {
   
    Name = "AUY1105-duocapp-ec2" 
  }
}


resource "aws_iam_instance_profile" "ec2_profile" {
  name = "mi_ec2_profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role" "ec2_role" {
  name = "mi_ec2_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}


