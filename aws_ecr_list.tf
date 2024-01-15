resource "aws_ecr_repository" "ecr_list" {
    name                            = "list_repo"
    force_delete = true
}

#The commands below are used to build and push a docker image of the application in the app folder
locals {
  docker_login_command_list             = "aws ecr get-login-password --region ${var.region} --profile personal| docker login --username AWS --password-stdin ${local.account_id}.dkr.ecr.${var.region}.amazonaws.com"
  docker_build_command_list             = "docker build -t ${aws_ecr_repository.ecr_list.name} ./src/list"
  docker_tag_command_list               = "docker tag ${aws_ecr_repository.ecr_list.name}:latest ${local.account_id}.dkr.ecr.${var.region}.amazonaws.com/${aws_ecr_repository.ecr_list.name}:latest"
  docker_push_command_list              = "docker push ${local.account_id}.dkr.ecr.${var.region}.amazonaws.com/${aws_ecr_repository.ecr_list.name}:latest"
}

#This resource authenticates you to the ECR service
resource "null_resource" "docker_login_list" {
    provisioner "local-exec" {
        command                     = local.docker_login_command_list
    }
    triggers = {
        "run_at"                    = timestamp()
    }
    depends_on                      = [ aws_ecr_repository.ecr_list ]
}

#This resource builds the docker image from the Dockerfile in the app folder
resource "null_resource" "docker_build_list" {
    provisioner "local-exec" {
        command                     = local.docker_build_command_list
    }
    triggers = {
        "run_at"                    = timestamp()
    }
    depends_on                      = [ null_resource.docker_login_list ]
}

#This resource tags the image 
resource "null_resource" "docker_tag_list" {
    provisioner "local-exec" {
        command                     = local.docker_tag_command_list
    }
    triggers = {
        "run_at"                    = timestamp()
    }
    depends_on                      = [ null_resource.docker_build_list ]
}

#This resource pushes the docker image to the ECR repo
resource "null_resource" "docker_push_ecr_list" {
    provisioner "local-exec" {
        command                     = local.docker_push_command_list
    }
    triggers = {
        "run_at"                    = timestamp()
    }
    depends_on                      = [ null_resource.docker_tag_list ]
}

