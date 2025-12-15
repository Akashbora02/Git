resource "aws_iam_user" "iam_user" {
  name = var.user_list[count.index]
  count = length(var.user_list)
}

output "names" {
 value = [for username in aws_iam_user.iam_user : username.name] 
} 


resource "aws_instance" "my-instance" {
  instance_type = var.my-instance-inst-type
  key_name = var.my-instance-key_name
  ami = var.my-instance-ami_list[count.index]
  vpc_security_group_ids =  [var.my-instance-security_groups]
  count = length(var.my-instance-ami_list)
}

output "my-instance-ami-id" {
  value = [for ami-id in aws_instance.my-instance : ami-id.id]
}