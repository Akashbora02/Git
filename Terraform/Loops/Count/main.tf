resource "aws_iam_user" "iam_user" {
  count = length(var.user_list)
  name = var.user_list[count.index]
}

output "name" {
 value = [
    for user_name in var.user_list:
    aws_iam_user.iam_user[user_name].name
 ] 
}