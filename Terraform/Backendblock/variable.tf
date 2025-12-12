variable "webserver_ami" {
  default = "ami-0f00d706c4a80fd93"
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
variable "webserver_disable_api_termination" {
  default = false
}