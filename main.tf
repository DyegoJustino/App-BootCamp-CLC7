data "aws_vpc" "infra-bootcamp-prod-vpc" {
    filter {
      name = "tag:Name"
      values = ["infra-bootcamp-prod-vpc"]
    }
}

data "aws_subnet" "infra_public_sub_1a" {
    filter {
      name = "tag:Name"
      values = ["infra-bootcamp-prod-vpc-public-us-east-1a"]
    }
}

module "app_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "App-SG"
  description = "Security group para nossa instancia da Aplicação"
  vpc_id      = data.aws_vpc.infra-bootcamp-prod-vpc.id
  ingress_with_cidr_blocks = [
    {
      from_port   = 5000
      to_port     = 5000
      protocol    = "tcp"
      description = "Porta para minha aplicacao contador de acesso"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "Porta SSH"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_rules        = ["all-all"]
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "App"

  ami                    = "ami-07d02ee1eeb0c996c"
  instance_type          = "t2.micro"
  key_name               = "vockey"
  monitoring             = true
  vpc_security_group_ids = [module.app_sg.security_group_id]
  subnet_id              = data.aws_subnet.infra_public_sub_1a.id
  user_data              = file("./dependencias.sh")

  tags = {
    Terraform = "true"
    Environment = "Production"
    App = "Servidor de Aplicação"
    OwnerSquad = "Infraestrutura"
  }
}

resource "aws_eip" "app-ip" {
  instance = module.ec2_instance.id
  vpc      = true

  tags = {
    Name = "App-Server"
  }
}

