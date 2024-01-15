resource "aws_iam_role" "signupfunctionrole" {
    name = "signupfunctionrole"
    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com" #need to change
        }
      },
    ]
  })
}
resource "aws_iam_role_policy_attachment" "lambdabasic_signup" {
  role       = aws_iam_role.signupfunctionrole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
resource "aws_iam_role_policy" "signupfunctionrolePolicy0" {
    name = "signupfunctionrolePolicy0"
    role = aws_iam_role.signupfunctionrole.name
    policy = jsonencode({
    "Statement": [
        {
            "Action": [
                "cognito-idp:SignUp",
                "cognito-idp:ListUsers"
            ],
            "Resource": [
                "*"
            ],
            "Effect": "Allow"
        }
    ]
})
}

resource "aws_iam_role" "signupconfirmfunctionrole" {
    name = "signupconfirmfunctionrole"
    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com" #need to change
        }
      },
    ]
  })
}
resource "aws_iam_role_policy_attachment" "lambdabasic_confirm" {
  role       = aws_iam_role.signupconfirmfunctionrole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
resource "aws_iam_role_policy" "signupconfirmfunctionrolePolicy0" {
    name = "signupconfirmfunctionrolePolicy0"
    role = aws_iam_role.signupconfirmfunctionrole.name
    policy = jsonencode({
    "Statement": [
        {
            "Action": [
                "cognito-idp:ConfirmSignUp",
                "cognito-idp:ListUsers"
            ],
            "Resource": [
                "*"
            ],
            "Effect": "Allow"
        }
    ]
})
}


resource "aws_iam_role" "loginfunctionrole" {
    name = "loginfunctionrole"
    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com" #need to change
        }
      },
    ]
  })
}
resource "aws_iam_role_policy_attachment" "lambdabasic_login" {
  role       = aws_iam_role.loginfunctionrole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
resource "aws_iam_role_policy" "loginfunctionrolePolicy0" {
    name = "loginfunctionrolePolicy0"
    role = aws_iam_role.loginfunctionrole.name
    policy = jsonencode({
    "Statement": [
        {
            "Action": [
                "cognito-idp:InitiateAuth"
            ],
            "Resource": [
                "*"
            ],
            "Effect": "Allow"
        }
    ]
})
}


resource "aws_iam_role" "listfunctionrole" {
    name = "listfunctionrole"
    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com" #need to change
        }
      },
    ]
  })
}
resource "aws_iam_role_policy_attachment" "lambdabasic_list" {
  role       = aws_iam_role.listfunctionrole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
resource "aws_iam_role_policy" "listfunctionrolePolicy0" {
    name = "listfunctionrolePolicy0"
    role = aws_iam_role.listfunctionrole.name
    policy = jsonencode({
    "Statement": [
        {
            "Action": [
                "cognito-idp:InitiateAuth",
                "s3:List*",
                "s3:Get*"
            ],
            "Resource": [
                "*"
            ],
            "Effect": "Allow"
        }
    ]
})
}

resource "aws_iam_role" "addcsvfunctionrole" {
    name = "addcsvfunctionrole"
    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com" #need to change
        }
      },
    ]
  })
}
resource "aws_iam_role_policy_attachment" "lambdabasic_add" {
  role       = aws_iam_role.addcsvfunctionrole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
resource "aws_iam_role_policy" "addcsvfunctionrolePolicy0" {
    name = "addcsvfunctionrolePolicy0"
    role = aws_iam_role.addcsvfunctionrole.name
    policy = jsonencode({
    "Statement": [
        {
            "Action": [
                "cognito-idp:InitiateAuth",
                "s3:Put*"
            ],
            "Resource": [
                "*"
            ],
            "Effect": "Allow"
        }
    ]
})
}



resource "aws_iam_role" "downloadcsvfunctionrole" {
    name = "downloadcsvfunctionrole"
    assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com" #need to change
        }
      },
    ]
  })
}
resource "aws_iam_role_policy_attachment" "lambdabasic_download" {
  role       = aws_iam_role.downloadcsvfunctionrole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
resource "aws_iam_role_policy" "downloadcsvfunctionrolePolicy0" {
    name = "downloadcsvfunctionrolePolicy0"
    role = aws_iam_role.addcsvfunctionrole.name
    policy = jsonencode({
    "Statement": [
        {
            "Action": [
                "cognito-idp:InitiateAuth",
                "s3:Get*"
            ],
            "Resource": [
                "*"
            ],
            "Effect": "Allow"
        }
    ]
})
}