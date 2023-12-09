output "eip" {
  value = aws_eip.cicdpo_ip.*.public_ip
}

output "instance_id" {
  value = module.ec2-instance.id[0]
}