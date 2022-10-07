variable "GH_TOKEN" {
    type = string
}

variable "repo_name" {
    type = string
    default = "java-app"
}

variable "repo_description" {
    type = string
    default = "java maven jenkins"
}

variable "repo_visibility" {
    type = string
    default = "public"
}

variable "repo_github_branch_default" {
    type = string
    default = "main"
}