#!/bin/bash
touch /home/ec2-user/start_time
sudo yum update -y
sudo yum -y install python3-pip ansible git
cd /home/ec2-user

# using resources which pushed by terraform
sudo chown -R ec2-user:ec2-user ansible_DevOps2022/ # use when all the files provided by terraform
sudo chmod 400 ansible_DevOps2022/ssh-key.pem  # use when all the files provided by terraform
cd ansible_DevOps2022
# export ANSIBLE_HOST_KEY_CHECKING=False
# ansible-playbook install-jenkins.yml -i inventory & # use when all the files provided by terraform
# ansible-playbook install-k8s.yml -i inventory # use when all the files provided by terraform
# sudo mv ansible_DevOps2022 .ansible_DevOps2022 # use when all the files provided by terraform



git clone https://github.com/turancyberhub/ansible_DevOps2022.git
sudo chown -R ec2-user:ec2-user ansible_DevOps2022/
touch /home/ec2-user/end_time
