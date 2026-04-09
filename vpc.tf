resource "aws_vpc" "mi_vpc" {
  # CAMBIO: Ajustado a 10.0.0.0/16 para que coincida con tus subnets
  cidr_block           = "10.0.0.0/16" 
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "AUY1105-duocapp-vpc"
  }
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.mi_vpc.id
}

# --- NOTA SOBRE FLOW LOGS ---
# En AWS Academy, a menudo NO tienes permiso para crear Roles para Flow Logs.
# Si el pipeline falla en 'aws_iam_role.role_flow_logs', te recomiendo 
# comentar toda esta sección de Flow Logs y el Rol asociado.
# ----------------------------

resource "aws_cloudwatch_log_group" "vpc_log_group" {
  name              = "/aws/vpc/flow-logs-duocapp-v2" # Agregamos -v2
  retention_in_days = 7 
}

# Si decides usarlo, debes usar el ARN del "LabRole" que ya existe
resource "aws_flow_log" "mi_vpc_flow_log" {
  # CAMBIO: Usamos el rol pre-existente del laboratorio
  iam_role_arn    = "arn:aws:iam::767397756296:role/LabRole" 
  log_destination = aws_cloudwatch_log_group.vpc_log_group.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.mi_vpc.id
}

# IMPORTANTE: Comenta o elimina los recursos 'aws_iam_role' y 'aws_iam_role_policy' 
# porque causan el error 403 AccessDenied en tu cuenta.

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.mi_vpc.id
  tags = { Name = "AUY1105-duocapp-igw" }
}

# Ahora estas subnets SÍ son válidas dentro de 10.0.0.0/16
resource "aws_subnet" "subnet_publica_1" {
  vpc_id                  = aws_vpc.mi_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true # Cambiado a true para que las EC2 públicas tengan IP
  tags = { Name = "AUY1105-duocapp-subnet-publica-1" }
}

resource "aws_subnet" "subnet_publica_2" {
  vpc_id                  = aws_vpc.mi_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = { Name = "AUY1105-duocapp-subnet-publica-2" }
}

resource "aws_subnet" "subnet_privada_1" {
  vpc_id            = aws_vpc.mi_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  tags              = { Name = "AUY1105-duocapp-subnet-privada-1" }
}

resource "aws_subnet" "subnet_privada_2" {
  vpc_id            = aws_vpc.mi_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  tags              = { Name = "AUY1105-duocapp-subnet-privada-2" }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags   = { Name = "AUY1105-duocapp-nat-eip" }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnet_publica_1.id
  tags          = { Name = "AUY1105-duocapp-nat-gw" }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.mi_vpc.id
  tags   = { Name = "AUY1105-duocapp-public-rt" }
}

resource "aws_route_table_association" "public_assoc_1" {
  subnet_id      = aws_subnet.subnet_publica_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_assoc_2" {
  subnet_id      = aws_subnet.subnet_publica_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.mi_vpc.id
  tags   = { Name = "AUY1105-duocapp-private-rt" }
}

resource "aws_route_table_association" "private_assoc_1" {
  subnet_id      = aws_subnet.subnet_privada_1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_assoc_2" {
  subnet_id      = aws_subnet.subnet_privada_2.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}