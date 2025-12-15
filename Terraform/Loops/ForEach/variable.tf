variable "my-instance-ami_list" {
  default = ["ami-068c0051b15cdb816" , "ami-0ecb62995f68bb549"]
}

variable "my-instance-inst-type" {
  default = "t3.micro"
}

variable "my-instance-key_name" {
  default = "16dec"
}

variable "my-instance-security_groups" {
  default = "sg-013ac9044ebaee90e"
}