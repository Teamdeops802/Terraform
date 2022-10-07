output "k8s_private_ip" {
  value = aws_instance.k8s.private_ip
}

output "jenkins_private_ip" {
  value = aws_instance.jenkins.private_ip
}

output "ansible_private_ip" {
  value = aws_instance.ansible.private_ip
}
