terraform {
  required_version = "~> 1"  
}


# Configure the GitHub Provider
provider "github" {
  # token = ""
  token = var.GH_TOKEN 
  owner = "Teamdeops802"
}

resource "github_repository" "repo" {
  name               = var.repo_name
  description        = var.repo_description
  visibility         = var.repo_visibility
  has_issues         = true
  has_wiki           = true
  auto_init          = true
  # license_template   = "mit"
  # gitignore_template = "VisualStudio"
}

#Set default branch 'main'
resource "github_branch_default" "main" {
  repository = github_repository.repo.name
  branch     = var.repo_github_branch_default
}