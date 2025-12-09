output "subnet_id" {
  value = aws_subnet.my_subnetA.id
}

output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "webserver_sg" {
  value = aws_security_group.webserver_sg.id
}

output "webserver_sg_arn" {
  value = aws_security_group.webserver_sg.arn
}

#output "vpc_IGW" {
#  value = aws_internet_gateway.my_IGW.id
#}