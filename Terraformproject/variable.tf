variable "webserver_ami" {
  default = "ami-0ecb62995f68bb549"
}
variable "webserver_instance_type" {
  default = "t2.micro"
}
variable "webserver_key_name" {
  default = "30july"
}
variable "webserver_vpc_security_group_ids" {
  default = "sg-0bbfe8e7d4bf3c179"
}
#variable "webserver_count" {
#  default = 5
#}
variable "webserver_disable_api_termination" {
  default = false
}