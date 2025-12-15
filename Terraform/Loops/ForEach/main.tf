resource "aws_instance" "my-instance" {
  instance_type          = var.my-instance-inst-type
  key_name               = var.my-instance-key_name
  vpc_security_group_ids = [var.my-instance-security_groups]
  for_each               = toset(var.my-instance-ami_list)
  ami                    = each.value
}

output "my-instance-ami-id" {
  value = [for ami-id in var.my-instance-ami_list :
    aws_instance.my-instance[ami-id].public_ip
  ]
}