#access_key              = " "
#secret_key              = " "
#region                  = "ap-southeast-2"

name                    = "TEST-APP"  
azs                     = ["ap-southeast-2a","ap-southeast-2b"]
vpc_cidr                = "172.20.0.0/16"
public_subnet_cidr01    = "172.20.1.0/24"
public_subnet_cidr02    = "172.20.2.0/24"
private_subnet_cidr01   = "172.20.3.0/24"
private_subnet_cidr02   = "172.20.4.0/24"
host_count              = "1"
instancetype            = "t2.micro"
ami_id                  = "ami-0e040c48614ad1327"
