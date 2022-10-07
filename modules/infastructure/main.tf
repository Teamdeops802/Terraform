terraform {
  required_version = "~> 1"  
}

# Key-pair
resource "aws_key_pair" "ssh-key" {
  key_name   = var.ssh-key_name
  public_key = file(var.ssh_key_path)
}

# VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = var.vpc_name
  }
}

# public subnet for Ansible, K8s, Jenkins
resource "aws_subnet" "PublicSubnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  availability_zone       = var.subnet_availability_zone
  cidr_block              = var.public_subnet_cidr_block
  map_public_ip_on_launch = true
}

# # future development private subnet for the k8s worker nodes
# resource "aws_subnet" "PrivSubnet" {
#   vpc_id                  = aws_vpc.my_vpc.id
  # cidr_block              = var.private_subnet_cidr_block
#   map_public_ip_on_launch = true
# }

# Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

# route Tables for public subnet
resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
}

# route table association public subnet 
resource "aws_route_table_association" "PublicRTAssociation" {
  subnet_id      = aws_subnet.PublicSubnet.id
  route_table_id = aws_route_table.PublicRT.id
}

# Creating Security Group for ASG
resource "aws_security_group" "my_sg" {
  name        = var.security_group_name
  description = "security gropup"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "ssh"
    from_port   = var.ingres_ssh
    to_port     = var.ingres_ssh
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "jenkins,k8s"
    from_port   = var.ingres_jenkins_k8s
    to_port     = var.ingres_jenkins_k8s
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #outbound = egress
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "k8s" {
  ami           = var.aws_ami
  instance_type = var.aws_instance_type
  key_name      = aws_key_pair.ssh-key.key_name
  subnet_id     = aws_subnet.PublicSubnet.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  tags = {
    Name = "k8s"
  }
  
  # attach private ip to inventory file
  provisioner "local-exec" {
  command = "echo ${self.tags.Name} ansible_host=${self.private_ip} >> ./ansible_DevOps2022/inventory"
  }
}

# elastic ip
resource "aws_eip" "k8s" {
  instance = aws_instance.k8s.id
  vpc      = true
}

resource "aws_instance" "jenkins" {
  ami           = var.aws_ami
  instance_type = var.aws_instance_type
  key_name      = aws_key_pair.ssh-key.key_name
  subnet_id     = aws_subnet.PublicSubnet.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  tags = {
    Name = "jenkins"
  }
  
  # attach private ip to inventory file  
  provisioner "local-exec" {
  command = "echo ${self.tags.Name} ansible_host=${self.private_ip} >> ./ansible_DevOps2022/inventory"
  }
}

# elastic ip
resource "aws_eip" "jenkins" {
  instance = aws_instance.jenkins.id
  vpc      = true
}

resource "aws_instance" "ansible" {
  ami           = var.aws_ami
  instance_type = var.aws_instance_type
  key_name      = aws_key_pair.ssh-key.key_name
  subnet_id     = aws_subnet.PublicSubnet.id


  vpc_security_group_ids = [aws_security_group.my_sg.id]
  user_data              = file(var.ansible_script_path)

  tags = {
    Name = "ansible"
  }

  #send ansible_DevOps2022 folder to ansible server
  provisioner "file" {
    connection {
      host        = self.public_ip
      user        = "ec2-user"
      type        = "ssh"
      private_key = file("./final-project-resources-DevOps2022/ssh-key.pem")
      timeout     = "2m"
    }
    source      = "ansible_DevOps2022"
    destination = "ansible_DevOps2022"
  }
}

# elastic ip
resource "aws_eip" "ansible" {
  instance = aws_instance.ansible.id
  vpc      = true
}

