resource "aws_vpc" "mi_vpc" {
  cidr_block           = "10.1.0.0/16 "
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "AUY1105-duocapp-vpc"
  }
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.mi_vpc.id
}

# checkov:skip=CKV_AWS_158:AWS Academy no permite el uso de KMS personalizado.
# checkov:skip=CKV_AWS_338:Retencion limitada a 7 dias para evitar costos en entorno estudiantil.
resource "aws_cloudwatch_log_group" "vpc_log_group" {
  name              = "/aws/vpc/flow-logs-duocapp"
  retention_in_days = 7 
}

resource "aws_flow_log" "mi_vpc_flow_log" {
  iam_role_arn    = aws_iam_role.role_flow_logs.arn
  log_destination = aws_cloudwatch_log_group.vpc_log_group.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.mi_vpc.id
}

resource "aws_iam_role" "role_flow_logs" {
  name = "role-vpc-flow-logs-duoc"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "vpc-flow-logs.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "policy_flow_logs" {
  name = "policy-vpc-flow-logs"
  role = aws_iam_role.role_flow_logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # checkov:skip=CKV_AWS_355:Se usa wildcard para simplificar en entorno de laboratorio Academy.
        # checkov:skip=CKV_AWS_290:Permisos requeridos por el entorno restringido de LabRole.
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.mi_vpc.id
  tags = { Name = "AUY1105-duocapp-igw" }
}

resource "aws_subnet" "subnet_publica_1" {
  vpc_id                  = aws_vpc.mi_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false 
  tags = { Name = "AUY1105-duocapp-subnet-publica-1" }
}

resource "aws_subnet" "subnet_publica_2" {
  vpc_id                  = aws_vpc.mi_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false 
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