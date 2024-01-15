resource "aws_api_gateway_deployment" "apigwdep" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    depends_on = [ 
        aws_api_gateway_integration.lambda_integration,
        aws_api_gateway_integration.lambda_integration_login,
        aws_api_gateway_integration.lambda_integration_confirm,
        aws_api_gateway_integration.login_OPTIONS_integration,
        aws_api_gateway_integration.list_lambda_integration,
        aws_api_gateway_integration.addcsv_lambda_integration,
        aws_api_gateway_integration.dowloadcsv_lambda_integration,
        aws_api_gateway_integration.select_lambda_integration
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

resource "aws_api_gateway_method" "login_OPTIONS" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    resource_id = aws_api_gateway_resource.login.id
    http_method = "ANY"
    authorization = "NONE"
    request_parameters = {
        "method.request.path.COGNITOCLIENT"     = true
    }
    api_key_required = false

}

resource "aws_api_gateway_method_response" "login_OPTIONS_method_response" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    resource_id = aws_api_gateway_resource.login.id
    http_method = aws_api_gateway_method.login_OPTIONS.http_method
    status_code = "200"
    
    response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = false,
        "method.response.header.Access-Control-Allow-Methods" = false,
        "method.response.header.Access-Control-Allow-Origin"  = false
    }
}

resource "aws_api_gateway_integration" "login_OPTIONS_integration" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    resource_id = aws_api_gateway_resource.login.id
    http_method = aws_api_gateway_method.login_OPTIONS.http_method
    type = "MOCK"
    request_templates = {
        "application/json" = jsonencode({"statusCode":200})
    }
    passthrough_behavior = "WHEN_NO_MATCH"
}

resource "aws_api_gateway_integration_response" "login_OPTIONS_integration_response" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    resource_id = aws_api_gateway_resource.login.id
    http_method = aws_api_gateway_method.login_OPTIONS.http_method
    status_code = "200"
    response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = "'*'",
        "method.response.header.Access-Control-Allow-Methods" = "'*'",
        "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    }
    response_templates = {
        "application/json" = jsonencode({})
    }
    depends_on = [ 
        aws_api_gateway_method.login_method,
        aws_api_gateway_integration.login_OPTIONS_integration
     ]
}


resource "aws_api_gateway_resource" "list" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    parent_id = aws_api_gateway_rest_api.api.root_resource_id
    path_part = "list"
}

resource "aws_api_gateway_method" "list_method" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    resource_id = aws_api_gateway_resource.list.id
    http_method = "GET"
    authorization = "COGNITO_USER_POOLS"
    authorizer_id = aws_api_gateway_authorizer.CognitoAuthorizer.id
    api_key_required = false
}
resource "aws_api_gateway_integration" "list_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.list.id
  http_method             = aws_api_gateway_method.list_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  
  uri = aws_lambda_function.list.invoke_arn 
  passthrough_behavior = "WHEN_NO_MATCH"
}


resource "aws_api_gateway_resource" "addcsv" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    parent_id = aws_api_gateway_rest_api.api.root_resource_id
    path_part = "addcsv"
}

resource "aws_api_gateway_method" "addcsv_method" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    resource_id = aws_api_gateway_resource.addcsv.id
    http_method = "POST"
    authorization = "COGNITO_USER_POOLS"
    authorizer_id = aws_api_gateway_authorizer.CognitoAuthorizer.id
    api_key_required = false
}
resource "aws_api_gateway_integration" "addcsv_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.addcsv.id
  http_method             = aws_api_gateway_method.addcsv_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  
  uri = aws_lambda_function.addcsv.invoke_arn 
  passthrough_behavior = "WHEN_NO_MATCH"
}

resource "aws_api_gateway_resource" "downloadcsv" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    parent_id = aws_api_gateway_rest_api.api.root_resource_id
    path_part = "download"
}

resource "aws_api_gateway_method" "dowloadcsv_method" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    resource_id = aws_api_gateway_resource.downloadcsv.id
    http_method = "POST"
    authorization = "COGNITO_USER_POOLS"
    authorizer_id = aws_api_gateway_authorizer.CognitoAuthorizer.id
    api_key_required = false
}
resource "aws_api_gateway_integration" "dowloadcsv_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.downloadcsv.id
  http_method             = aws_api_gateway_method.dowloadcsv_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  
  uri = aws_lambda_function.downloadcsv.invoke_arn 
  passthrough_behavior = "WHEN_NO_MATCH"
}



resource "aws_api_gateway_resource" "select" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    parent_id = aws_api_gateway_rest_api.api.root_resource_id
    path_part = "select"
}

resource "aws_api_gateway_method" "select_method" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    resource_id = aws_api_gateway_resource.select.id
    http_method = "POST"
    authorization = "COGNITO_USER_POOLS"
    authorizer_id = aws_api_gateway_authorizer.CognitoAuthorizer.id
    api_key_required = false
}
resource "aws_api_gateway_integration" "select_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.select.id
  http_method             = aws_api_gateway_method.select_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  
  uri = aws_lambda_function.select.invoke_arn 
  passthrough_behavior = "WHEN_NO_MATCH"
}
