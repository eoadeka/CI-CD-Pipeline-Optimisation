output "eip" {
  value = aws_eip.cicdpo_ip.*.public_ip
}

output "instance_id" {
  # value = module.ec2_instance.id[0]
  value = module.ec2_instance.id
}

output "private_key" {
  value = tls_private_key.tls-key.private_key_openssh
  sensitive = true
}

output "public_ip" {
  value = module.ec2_instance.public_ip
}