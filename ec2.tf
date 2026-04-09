# 1. Security Group: Está perfecto. 
# Solo asegúrate de que tu IP pública no haya cambiado (puedes verificar en checkip.amazonaws.com)
resource "aws_security_group" "ssh_access" {
  name        = "ssh-access"
  description = "Permitir acceso SSH desde mi IPv4"
  vpc_id      = aws_vpc.mi_vpc.id

  ingress {
    description = "SSH desde mi IPv4"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["201.189.206.99/32"] 
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

# 2. Instancia EC2: Cumple con tus políticas de OPA y Checkov
resource "aws_instance" "mi_ec2" {
  ami                     = "ami-0fa8aad99729521be"
  instance_type           = "t2.micro" 
  subnet_id               = aws_subnet.subnet_publica_1.id
  vpc_security_group_ids  = [aws_security_group.ssh_access.id]
  disable_api_termination = true
  monitoring              = true
  ebs_optimized           = true
  
  # CAMBIO AQUÍ: En laboratorios, usamos el perfil que ya existe.
  # "LabInstanceProfile" es el nombre estándar en AWS Academy.
  iam_instance_profile    = "LabInstanceProfile" 

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
