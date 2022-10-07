terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

module "infrastructure" {
  source                    = "./modules/infastructure"
  vpc_name                  = "my_vpc"
  vpc_cidr_block            = "10.0.0.0/16"
  subnet_availability_zone  = "us-east-1a"
  public_subnet_cidr_block  = "10.0.1.0/24"
  private_subnet_cidr_block = "10.0.2.0/24"
  security_group_name       = "my_sg"
  ingres_ssh                = 22
  ingres_jenkins_k8s        = 8080
  aws_ami                   = "ami-06640050dc3f556bb"
  aws_instance_type         = "t3a.medium"
  ansible_script_path       = "./final-project-resources-DevOps2022/ansible-script.sh"
}

module "repository" {
  source                     = "./modules/repository"
  GH_TOKEN                   = var.GH_TOKEN
  repo_name                  = "java-app"
  repo_description           = "java maven jenkins"
  repo_visibility            = "public"
  repo_github_branch_default = "main"
}