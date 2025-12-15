resource "aws_iam_user" "iam_user" {
  name = var.user_list[count.index]
  count = length(var.user_list)
}

output "names" {
 value = [for username in aws_iam_user.iam_user : username.name] 
}