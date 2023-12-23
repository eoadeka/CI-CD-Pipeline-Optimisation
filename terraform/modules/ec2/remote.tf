# test connectivity to web server
# curl http://13.235.0.7/web/

# resource "null_resource" "remote" {
  
#   connection {
#     type = "ssh"
#     user = "ec2-user"
#     private_key = tls_private_key.tls-key.private_key_openssh
#     host = module.ec2_instance.public_ip
#   }
  
#   provisioner "file" {
#     source = "${path.module}/userdata.sh"
#     destination = "/tmp/userdata.sh"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "chmod +x /tmp/userdata.sh",
#       # "/tmp/userdata.sh args",
#     ]
#   }
# }