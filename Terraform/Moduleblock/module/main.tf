module "vpc" {
  source      = "/mnt/c/Users/AB/Desktop/Git/Terraform/Moduleblock/main/VPC"
  vpc_cidr    = "10.0.0.0/16"
  vpc_subnetA = "10.0.1.0/24"
  public_ip   = true
}
module "ec2" {
  source                            = "/mnt/c/Users/AB/Desktop/Git/Terraform/Moduleblock/main/EC2"
  webserver_ami                     = "ami-0ecb62995f68bb549"
  webserver_instance_type           = "t2.micro"
  webserver_key_name                = "30july"
  webserver_subnetA = module.vpc.subnet_id
  webserver_sg =  module.vpc.webserver_sg_id
  webserver_disable_api_termination = false
}