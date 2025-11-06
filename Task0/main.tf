provider "aws" {
  region     = "us-west-2"
}

resource "aws_vpc" "Task0-VPC-Zaeem" {
  cidr_block = "10.0.0.0/16"
  

    tags = {
        Name = "Task0-VPC-Zaeem"
    }  
}

resource "aws_subnet" "Task0-VPC-Zaeem-Public-SubnetA" {
  vpc_id            = aws_vpc.Task0-VPC-Zaeem.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "Task0-VPC-Zaeem-Public-SubnetA"
  }
  
}

resource "aws_subnet" "Task0-VPC-Zaeem-Private-SubnetA" {
  vpc_id            = aws_vpc.Task0-VPC-Zaeem.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2a"

    tags = {
        Name = "Task0-VPC-Zaeem-Private-SubnetA"
    }
  
}

resource "aws_subnet" "Task0-VPC-Zaeem-Public-SubnetB" {
  vpc_id            = aws_vpc.Task0-VPC-Zaeem.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-west-2b"

    tags = {
        Name = "Task0-VPC-Zaeem-Public-SubnetB"
    }
  
}

resource "aws_subnet" "Task0-VPC-Zaeem-Private-SubnetB" {
  vpc_id            = aws_vpc.Task0-VPC-Zaeem.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-west-2b"

    tags = {
        Name = "Task0-VPC-Zaeem-Private-SubnetB"
    }
  
}

resource "aws_internet_gateway" "Task0-VPC-Zaeem-IGW" {
  vpc_id = aws_vpc.Task0-VPC-Zaeem.id

  tags = {
    Name = "Task0-VPC-Zaeem-IGW"
  }
}

resource "aws_route_table" "Task0-VPC-Zaeem-Public-RT" {
  vpc_id = aws_vpc.Task0-VPC-Zaeem.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Task0-VPC-Zaeem-IGW.id
  }


  tags = {
    Name = "Task0-VPC-Zaeem-Public-RT"
  }
}

resource "aws_route_table_association" "Task0-VPC-Zaeem-Public-SubnetA-Association" {
  subnet_id      = aws_subnet.Task0-VPC-Zaeem-Public-SubnetA.id
  route_table_id = aws_route_table.Task0-VPC-Zaeem-Public-RT.id
  
}
resource "aws_route_table_association" "Task0-VPC-Zaeem-Public-SubnetB-Association" {
  subnet_id      = aws_subnet.Task0-VPC-Zaeem-Public-SubnetB.id
  route_table_id = aws_route_table.Task0-VPC-Zaeem-Public-RT.id
  
}

resource "aws_route_table" "Task0-VPC-Zaeem-Private-RT" {
  vpc_id = aws_vpc.Task0-VPC-Zaeem.id
  
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.Task0-VPC-Zaeem-NAT.id
    }

  tags = {
    Name = "Task0-VPC-Zaeem-Private-RT"
  }
  
}

resource "aws_route_table_association" "Task0-VPC-Zaeem-Private-SubnetA-Association" {
  subnet_id      = aws_subnet.Task0-VPC-Zaeem-Private-SubnetA.id
  route_table_id = aws_route_table.Task0-VPC-Zaeem-Private-RT.id
  
}
resource "aws_route_table_association" "Task0-VPC-Zaeem-Private-SubnetB-Association" {
  subnet_id      = aws_subnet.Task0-VPC-Zaeem-Private-SubnetB.id
  route_table_id = aws_route_table.Task0-VPC-Zaeem-Private-RT.id  

}
resource "aws_nat_gateway" "Task0-VPC-Zaeem-NAT" {
  allocation_id = aws_eip.Task0-VPC-Zaeem-NAT-EIP.id
  subnet_id     = aws_subnet.Task0-VPC-Zaeem-Public-SubnetA.id

  tags = {
    Name = "Task0-VPC-Zaeem-NAT"
  }
}
resource "aws_eip" "Task0-VPC-Zaeem-NAT-EIP" {
  domain = "vpc"

  tags = {
    Name = "Task0-VPC-Zaeem-NAT-EIP"
  }
}

resource "aws_instance" "Task0-VPC-Zaeem-EC2-Instance-Public-SubnetA" {
  ami           = "ami-00e15f0027b9bf02b" 
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.Task0-VPC-Zaeem-Public-SubnetA.id
  associate_public_ip_address = true
  vpc_security_group_ids = [ aws_security_group.Task0-VPC-Zaeem-Public-InstanceA-SG.id ]

  tags = {
    Name = "Task0-VPC-Zaeem-EC2-Instance-Public-SubnetA"
  }
}

resource "aws_instance" "Task0-VPC-Zaeem-EC2-Instance-Private-SubnetA" {
  ami           = "ami-00e15f0027b9bf02b" 
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.Task0-VPC-Zaeem-Private-SubnetA.id
  vpc_security_group_ids = [ aws_security_group.Task0-VPC-Zaeem-Private-InstanceA-SG.id ]
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name

  tags = {
    Name = "Task0-VPC-Zaeem-EC2-Instance-Private-SubnetA"
  }
}

resource "aws_instance" "Task0-VPC-Zaeem-EC2-Instance-Public-SubnetB" {
  ami           = "ami-00e15f0027b9bf02b" 
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.Task0-VPC-Zaeem-Public-SubnetB.id
  vpc_security_group_ids = [ aws_security_group.Task0-VPC-Zaeem-Public-InstanceB-SG.id ]
  associate_public_ip_address = true

  tags = {
    Name = "Task0-VPC-Zaeem-EC2-Instance-Public-SubnetB"
  }
  
}

resource "aws_instance" "Task0-VPC-Zaeem-EC2-Instance-Private-SubnetB" {
  ami           = "ami-00e15f0027b9bf02b" 
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.Task0-VPC-Zaeem-Private-SubnetB.id
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
  vpc_security_group_ids = [ aws_security_group.Task0-VPC-Zaeem-Private-InstanceB-SG.id ]

  tags = {
    Name = "Task0-VPC-Zaeem-EC2-Instance-Private-SubnetB"
  }
  
}

resource "aws_security_group" "Task0-VPC-Zaeem-Public-InstanceA-SG" {
  name        = "Task0-VPC-Zaeem-Public-InstanceA-SG"
  description = "Security group for Public EC2 instances"
  vpc_id      = aws_vpc.Task0-VPC-Zaeem.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow ICMP ping requests"
    from_port   = -1              # -1 means all ICMP types
    to_port     = -1
    protocol    = "icmp"          # ICMP protocol for ping
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "Task0-VPC-Zaeem-Public-InstanceB-SG" {
  name        = "Task0-VPC-Zaeem-Public-InstanceB-SG"
  description = "Security group for Public EC2 instances"
  vpc_id      = aws_vpc.Task0-VPC-Zaeem.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow ICMP ping requests"
    from_port   = -1              # -1 means all ICMP types
    to_port     = -1
    protocol    = "icmp"          # ICMP protocol for ping
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "Task0-VPC-Zaeem-Private-InstanceA-SG" {
  name        = "Task0-VPC-Zaeem-Private-InstanceA-SG"
  description = "Security group for Private EC2 instances"
  vpc_id      = aws_vpc.Task0-VPC-Zaeem.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow ICMP ping requests"
    from_port   = -1              # -1 means all ICMP types
    to_port     = -1
    protocol    = "icmp"          # ICMP protocol for ping
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "Task0-VPC-Zaeem-Private-InstanceB-SG" {
  name        = "Task0-VPC-Zaeem-Private-InstanceB-SG"
  description = "Security group for Private EC2 instances"
  vpc_id      = aws_vpc.Task0-VPC-Zaeem.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow ICMP ping requests"
    from_port   = -1              # -1 means all ICMP types
    to_port     = -1
    protocol    = "icmp"          # ICMP protocol for ping
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "ssm_role" {
  name = "EC2_SSM_Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_managed" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "EC2_SSM_Profile"
  role = aws_iam_role.ssm_role.name
}

resource "aws_s3_bucket" "Task0-VPC-Zaeem-S3-Bucket" {
  bucket = "task0-vpc-zaeem-bucket-1234567890"
  region = "us-west-2"

  tags = {
    Name = "Task0-VPC-Zaeem-S3-Bucket"
  }
  
}

resource "aws_vpc_endpoint" "Task0-VPC-Zaeem-S3-Endpoint" {
  vpc_id       = aws_vpc.Task0-VPC-Zaeem.id
  service_name = "com.amazonaws.us-west-2.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    aws_route_table.Task0-VPC-Zaeem-Private-RT.id,
    aws_route_table.Task0-VPC-Zaeem-Public-RT.id
  ]

  tags = {
    Name = "Task0-VPC-Zaeem-S3-Endpoint"
  }
}