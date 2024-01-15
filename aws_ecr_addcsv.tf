# #Creation of the ECR repo
resource "aws_ecr_repository" "ecr_addcsv" {
    name                            = "ecr_addcsv_repo"
    force_delete = true
}

#The commands below are used to build and push a docker image of the application in the app folder
locals {
  docker_login_command_addcsv            = "aws ecr get-login-password --region ${var.region} --profile personal| docker login --username AWS --password-stdin ${local.account_id}.dkr.ecr.${var.region}.amazonaws.com"
  docker_build_command_addcsv            = "docker build -t ${aws_ecr_repository.ecr_addcsv.name} ./src/addcsv"
  docker_tag_command_addcsv              = "docker tag ${aws_ecr_repository.ecr_addcsv.name}:latest ${local.account_id}.dkr.ecr.${var.region}.amazonaws.com/${aws_ecr_repository.ecr_addcsv.name}:latest"
  docker_push_command_addcsv             = "docker push ${local.account_id}.dkr.ecr.${var.region}.amazonaws.com/${aws_ecr_repository.ecr_addcsv.name}:latest"
}

#This resource authenticates you to the ECR service
resource "null_resource" "docker_login_addcsv" {
    provisioner "local-exec" {
        command                     = local.docker_login_command_addcsv
    }
    triggers = {
        "run_at"                    = timestamp()
    }
    depends_on                      = [ aws_ecr_repository.ecr_addcsv ]
}
#This resource builds the docker image from the Dockerfile in the app folder
resource "null_resource" "docker_build_addcsv" {
    provisioner "local-exec" {
        command                     = local.docker_build_command_addcsv
    }
    triggers = {
        "run_at"                    = timestamp()
    }
    depends_on                      = [ null_resource.docker_login_addcsv ]
}

#This resource tags the image 
resource "null_resource" "docker_tag_addcsv" {
    provisioner "local-exec" {
        command                     = local.docker_tag_command_addcsv
    }
    triggers = {
        "run_at"                    = timestamp()
    }
    depends_on                      = [ null_resource.docker_build_addcsv ]
}

#This resource pushes the docker image to the ECR repo
resource "null_resource" "docker_push_ecr_addcsv" {
    provisioner "local-exec" {
        command                     = local.docker_push_command_addcsv
    }
    triggers = {
        "run_at"                    = timestamp()
    }
    depends_on                      = [ null_resource.docker_tag_addcsv ]
}