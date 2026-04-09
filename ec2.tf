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
    description = "Permitir trafico de salida a cualquier lugar"
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Todos los protocolos
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh-access"
  }
}

resource "aws_instance" "mi_ec2" {
  ami                    = "ami-0fa8aad99729521be"
  instance_type          = "t2.micro" # Requerimiento 4 de tu pauta
  subnet_id              = aws_subnet.subnet_publica_1.id
  vpc_security_group_ids = [aws_security_group.ssh_access.id]
  
  # Evita que se borre accidentalmente (Buena practica)
  disable_api_termination = true

  root_block_device {
    encrypted = true # Cumple con CKV_AWS_3
  }

  metadata_options {
    http_tokens = "required" # Cumple con CKV_AWS_79 (IMDSv2)
  }

  tags = {
    Name = "Name = "AUY1105-duocapp-ec2""
  }
}
