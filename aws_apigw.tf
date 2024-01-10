resource "aws_api_gateway_deployment" "apigwdep" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    depends_on = [ 
        aws_api_gateway_integration.lambda_integration,
        aws_api_gateway_integration.lambda_integration_login,
        aws_api_gateway_integration.lambda_integration_confirm
     ]
}

resource "aws_api_gateway_stage" "ApidevStage" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    stage_name = "Stage"
    deployment_id = aws_api_gateway_deployment.apigwdep.id
}

resource "aws_api_gateway_rest_api" "api" {
    name = "apigw"
    endpoint_configuration {
      types = [ "EDGE" ]
    }
    api_key_source = "HEADER"
    # disable_execute_api_endpoint = "false"
}

resource "aws_api_gateway_authorizer" "CognitoAuthorizer" {
  name                   = "CognitoAuthorizer"
  rest_api_id            = aws_api_gateway_rest_api.api.id
  type                   = "COGNITO_USER_POOLS"
  provider_arns          = [ aws_cognito_user_pool.CognitoPool.arn]
}

resource "aws_api_gateway_resource" "signup" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    parent_id = aws_api_gateway_rest_api.api.root_resource_id
    path_part = "signup"
}

resource "aws_api_gateway_method" "signup_method" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    resource_id = aws_api_gateway_resource.signup.id
    http_method = "POST"
    authorization = "NONE"
    request_parameters = {
        "method.request.path.COGNITOCLIENT"     = true
    }
    api_key_required = false
}
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.signup.id
  http_method             = aws_api_gateway_method.signup_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  
  uri = aws_lambda_function.UserSignUp.invoke_arn 
  passthrough_behavior = "WHEN_NO_MATCH"
}

resource "aws_api_gateway_resource" "signup_confirm" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    parent_id = aws_api_gateway_resource.signup.id
    path_part = "confirm"
}

resource "aws_api_gateway_method" "signup_confirm_method" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    resource_id = aws_api_gateway_resource.signup_confirm.id
    http_method = "POST"
    authorization = "NONE"
    request_parameters = {
        "method.request.path.COGNITOCLIENT"     = true
    }
    api_key_required = false
}
resource "aws_api_gateway_integration" "lambda_integration_confirm" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.signup_confirm.id
  http_method             = aws_api_gateway_method.signup_confirm_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  
  uri = aws_lambda_function.UserSignUp_confirm.invoke_arn 
  passthrough_behavior = "WHEN_NO_MATCH"
}


resource "aws_api_gateway_resource" "login" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    parent_id = aws_api_gateway_rest_api.api.root_resource_id
    path_part = "login"
}

resource "aws_api_gateway_method" "login_method" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    resource_id = aws_api_gateway_resource.login.id
    http_method = "POST"
    authorization = "NONE"
    # authorization = "COGNITO_USER_POOLS"
    # authorizer_id = aws_api_gateway_authorizer.CognitoAuthorizer.id
    request_parameters = {
        "method.request.path.COGNITOCLIENT"     = true
    }
    api_key_required = false
}
resource "aws_api_gateway_integration" "lambda_integration_login" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.login.id
  http_method             = aws_api_gateway_method.login_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  
  uri = aws_lambda_function.UserLogin.invoke_arn 
  passthrough_behavior = "WHEN_NO_MATCH"
}