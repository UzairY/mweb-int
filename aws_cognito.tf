#Cognito user pool
resource "aws_cognito_user_pool" "CognitoPool" {
    name = "CognitoUserPool-mweb"
    auto_verified_attributes = [ "email" ]
}

resource "aws_cognito_user_pool_client" "CognitoPool_Client" {
    name                                = "userpool-client-mweb" 
    user_pool_id                        = aws_cognito_user_pool.CognitoPool.id 
    allowed_oauth_flows_user_pool_client = true
    generate_secret = false
    allowed_oauth_scopes = ["aws.cognito.signin.user.admin","email","openid", "profile"]
    allowed_oauth_flows = ["implicit", "code"]
    explicit_auth_flows = ["ADMIN_NO_SRP_AUTH", "USER_PASSWORD_AUTH"]
    supported_identity_providers = ["COGNITO"]
    callback_urls = ["https://example.com"]
}

# resource "aws_cognito_user" "example" {
#   user_pool_id = aws_cognito_user_pool.CognitoPool.id
#   username = "uzair"
#   password = "Test@123"
# }
