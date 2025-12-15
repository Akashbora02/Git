resource "aws_instance" "my-instance" {
  instance_type          = var.my-instance-inst-type
  key_name               = var.my-instance-key_name
  ami                    = var.my-instance-ami
  vpc_security_group_ids = [var.my-instance-security_groups]


  provisioner "file" {
    source      = "user-data.sh"
    destination = "/home/ec2-user/user-data.sh"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> public_ip.txt"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("${path.module}/tf.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 700 user-data.sh",
      "sudo sh user-data.sh"
    ]
  }
}