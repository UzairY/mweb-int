# #Creation of the ECR repo
resource "aws_ecr_repository" "ecr_userconfirm" {
    name                            = "userconfirm_repo"
    force_delete = true
}

#The commands below are used to build and push a docker image of the application in the app folder
locals {
  docker_login_command_confirm             = "aws ecr get-login-password --region ${var.region} --profile personal| docker login --username AWS --password-stdin ${local.account_id}.dkr.ecr.${var.region}.amazonaws.com"
  docker_build_command_confirm             = "docker build -t ${aws_ecr_repository.ecr_userconfirm.name} ./src/confirm"
  docker_tag_command_confirm               = "docker tag ${aws_ecr_repository.ecr_userconfirm.name}:latest ${local.account_id}.dkr.ecr.${var.region}.amazonaws.com/${aws_ecr_repository.ecr_userconfirm.name}:latest"
  docker_push_command_confirm              = "docker push ${local.account_id}.dkr.ecr.${var.region}.amazonaws.com/${aws_ecr_repository.ecr_userconfirm.name}:latest"
}

#This resource authenticates you to the ECR service
resource "null_resource" "docker_login_confirm" {
    provisioner "local-exec" {
        command                     = local.docker_login_command_confirm
    }
    triggers = {
        "run_at"                    = timestamp()
    }
    depends_on                      = [ aws_ecr_repository.ecr_userconfirm ]
}

#This resource builds the docker image from the Dockerfile in the app folder
resource "null_resource" "docker_build_confirm" {
    provisioner "local-exec" {
        command                     = local.docker_build_command_confirm
    }
    triggers = {
        "run_at"                    = timestamp()
    }
    depends_on                      = [ null_resource.docker_login_confirm ]
}

#This resource tags the image 
resource "null_resource" "docker_tag_confirm" {
    provisioner "local-exec" {
        command                     = local.docker_tag_command_confirm
    }
    triggers = {
        "run_at"                    = timestamp()
    }
    depends_on                      = [ null_resource.docker_build_confirm ]
}

#This resource pushes the docker image to the ECR repo
resource "null_resource" "docker_push_ecr_userconfirm" {
    provisioner "local-exec" {
        command                     = local.docker_push_command_confirm
    }
    triggers = {
        "run_at"                    = timestamp()
    }
    depends_on                      = [ null_resource.docker_tag_confirm ]
}


