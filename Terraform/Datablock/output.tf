output "webserver_publicip" {
  value = aws_instance.webserver.public_ip
}
output "webserver_publicdns" {
  value = aws_instance.webserver.public_dns
}
output "webserver_privateip" {
  value = aws_instance.webserver.private_ip
}
output "webserver_sg_id" {
  value = data.aws_ami.myami.id
}