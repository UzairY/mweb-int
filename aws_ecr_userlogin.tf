# #Creation of the ECR repo
resource "aws_ecr_repository" "ecr_userlogin" {
    name                            = "userlogin_repo"
    force_delete = true
}


#The commands below are used to build and push a docker image of the application in the app folder
locals {
  docker_login_command_login             = "aws ecr get-login-password --region ${var.region} --profile personal| docker login --username AWS --password-stdin ${local.account_id}.dkr.ecr.${var.region}.amazonaws.com"
  docker_build_command_login             = "docker build -t ${aws_ecr_repository.ecr_userlogin.name} ./src/login"
  docker_tag_command_login               = "docker tag ${aws_ecr_repository.ecr_userlogin.name}:latest ${local.account_id}.dkr.ecr.${var.region}.amazonaws.com/${aws_ecr_repository.ecr_userlogin.name}:latest"
  docker_push_command_login              = "docker push ${local.account_id}.dkr.ecr.${var.region}.amazonaws.com/${aws_ecr_repository.ecr_userlogin.name}:latest"
}

#This resource authenticates you to the ECR service
resource "null_resource" "docker_login_login" {
    provisioner "local-exec" {
        command                     = local.docker_login_command_login
    }
    triggers = {
        "run_at"                    = timestamp()
    }
    depends_on                      = [ aws_ecr_repository.ecr_userlogin ]
}

#This resource builds the docker image from the Dockerfile in the app folder
resource "null_resource" "docker_build_login" {
    provisioner "local-exec" {
        command                     = local.docker_build_command_login
    }
    triggers = {
        "run_at"                    = timestamp()
    }
    depends_on                      = [ null_resource.docker_login_login ]
}

#This resource tags the image 
resource "null_resource" "docker_tag_login" {
    provisioner "local-exec" {
        command                     = local.docker_tag_command_login
    }
    triggers = {
        "run_at"                    = timestamp()
    }
    depends_on                      = [ null_resource.docker_build_login ]
}

#This resource pushes the docker image to the ECR repo
resource "null_resource" "docker_push_ecr_userlogin" {
    provisioner "local-exec" {
        command                     = local.docker_push_command_login
    }
    triggers = {
        "run_at"                    = timestamp()
    }
    depends_on                      = [ null_resource.docker_tag_login ]
}
