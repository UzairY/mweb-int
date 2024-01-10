resource "aws_lambda_function" "UserSignUp" {
    architectures           = [ "arm64" ]
    tracing_config {
      mode = "Active"
    }
    environment {
      variables = {"LOG_LEVEL"="INFO"
                    "COGNITOCLIENT"         = "${aws_cognito_user_pool_client.CognitoPool_Client.id}"
      }
    }
    timeout                 = 180
    memory_size             = 2048
    
    function_name           = "UserSignUp-mweb-01"
    role                    = aws_iam_role.signupfunctionrole.arn
    package_type            = "Image"
    image_uri               = "${aws_ecr_repository.ecr_usersignup.repository_url}:latest"
    depends_on                      = [ null_resource.docker_login_add ]

}

resource "aws_lambda_permission" "UserSignUp_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.UserSignUp.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*/*" # Replace with your resource ARN
}

//arn:aws:execute-api:us-east-1:493638874957:tv7vhfyv8g/*/POST/{signup}

resource "aws_lambda_function" "UserSignUp_confirm" {
    architectures           = [ "arm64" ]
    tracing_config {
      mode = "Active"
    }
    environment {
      variables = {"LOG_LEVEL"="INFO"
                    "COGNITOCLIENT"         = "${aws_cognito_user_pool_client.CognitoPool_Client.id}"
      }
    }
    timeout                 = 180
    memory_size             = 2048
    
    function_name           = "UserSignUp-confirm-mweb-01"
    role                    = aws_iam_role.signupconfirmfunctionrole.arn
    package_type            = "Image"
    image_uri               = "${aws_ecr_repository.ecr_userconfirm.repository_url}:latest"
    depends_on                      = [ null_resource.docker_login_confirm ]

}
resource "aws_lambda_permission" "UserSignUp_confirm__lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.UserSignUp_confirm.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*/*" # Replace with your resource ARN
}


resource "aws_lambda_function" "UserLogin" {
    architectures           = [ "arm64" ]
    tracing_config {
      mode = "Active"
    }
    environment {
      variables = {"LOG_LEVEL"="INFO"
                    "COGNITOCLIENT"         = "${aws_cognito_user_pool_client.CognitoPool_Client.id}"
      }
    }
    timeout                 = 180
    memory_size             = 2048
    
    function_name           = "UserLogin-mweb-01"
    role                    = aws_iam_role.loginfunctionrole.arn
    package_type            = "Image"
    image_uri               = "${aws_ecr_repository.ecr_userlogin.repository_url}:latest"
    depends_on                      = [ null_resource.docker_login_login ]

}

resource "aws_lambda_permission" "Userlogin_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.UserLogin.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*/*" # Replace with your resource ARN
}