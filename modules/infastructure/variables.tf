variable "ssh-key_name" {
    type = string
    default = "ssh-key"
}

variable "ssh_key_path" {
    type = string
    default = "./final-project-resources-DevOps2022/ssh-key.pub"
}

variable "vpc_name" {
    type = string
    default = "my_vpc"
}

variable "vpc_cidr_block" {
    type = string
    default = "10.0.0.0/16" 
}

variable "subnet_availability_zone" {
    type = string
    default = "us-east-1a"
}

variable "public_subnet_cidr_block" {
    type = string
    default = "10.0.1.0/24"
}

variable "private_subnet_cidr_block" {
    type = string
    default = "10.0.2.0/24"
}

variable "security_group_name" {
    type = string
    default = "my_sg"
}

variable "ingres_ssh" {
    type = number
    default = 22
}

variable "ingres_jenkins_k8s" {
    type = number
    default = 8080
}

variable "aws_ami" {
    type = string
    default = "ami-06640050dc3f556bb"
}

variable "aws_instance_type" {
    type = string
    default = "t3a.medium"
}

variable "ansible_script_path" {
    type = string
    default = "./final-project-resources-DevOps2022/ansible-script.sh"
}

variable "ec2_ami" {
    type = string
    default = "ami-06640050dc3f556bb"
}