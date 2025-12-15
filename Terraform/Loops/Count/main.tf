resource "aws_iam_user" "iam_user" {
  name = var.user_list[count.index]
  count = length(var.user_list)
}

output "name" {
 value = aws_iam_user.iam_user.name 
}