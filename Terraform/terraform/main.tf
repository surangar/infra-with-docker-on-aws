module "vpc" {
  source = "../modules/vpc"
  
  name                      = var.name
  azs                       = var.azs
  vpc_cidr                  = var.vpc_cidr
  public_subnet_cidr01      = var.public_subnet_cidr01
  public_subnet_cidr02      = var.public_subnet_cidr02
  private_subnet_cidr01     = var.private_subnet_cidr01
  private_subnet_cidr02     = var.private_subnet_cidr02
}

data "http" "ip" {
  url = "https://ifconfig.me"
}

module "sg-app-servers" {
  source = "../modules/security-group"

  name        = var.name
  vpc_id      = module.vpc.vpc_id

ingress_with_cidr_blocks  = [
    {
        from_port   = 22
        to_port     = 22
        protocol    = "TCP"
        cidr_blocks = "${data.http.ip.body}/32"
    
    },
    {
        from_port   = 80
        to_port     = 80
        protocol    = "TCP"
        cidr_blocks = "0.0.0.0/0"
    
    },
    {
        from_port   = 8090
        to_port     = 8090
        protocol    = "TCP"
        cidr_blocks = "0.0.0.0/0"
    
    },
  ]
  ingress_with_self = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "all"
        self = true
    
    },
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "all"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  egress_with_self = [
      {
        from_port   = 0
        to_port     = 0
        protocol    = "all"
        self = true
    
    },
  ]
}

resource "tls_private_key" "oskey" {
  algorithm = "RSA"
}

resource "local_file" "test-app-key" {
  content  = tls_private_key.oskey.private_key_pem
  filename = "test-app-key.pem"
}

resource "aws_key_pair" "test-app-key" {
  key_name   = "test-app-key"
  public_key = tls_private_key.oskey.public_key_openssh
}

module "ec2-instance" {
  source = "../modules/ec2-instance"

  instance_count              = var.host_count
  name                        = var.name
  ami                         = var.ami_id
  instance_type               = var.instancetype
  key_name                    = aws_key_pair.test-app-key.key_name
  subnet_id                   = module.vpc.public_subnet_01_id
  vpc_security_group_ids      = ["${module.sg-app-servers.this_security_group_id}"]
  associate_public_ip_address = true
}