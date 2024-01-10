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
resource "aws_iam_role_policy" "signupfunctionrolePolicy0" {
    name = "signupfunctionrolePolicy0"
    role = aws_iam_role.signupfunctionrole.name
    policy = jsonencode({
    "Statement": [
        {
            "Action": [
                "*"
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
resource "aws_iam_role_policy" "signupconfirmfunctionrolePolicy0" {
    name = "signupconfirmfunctionrolePolicy0"
    role = aws_iam_role.signupconfirmfunctionrole.name
    policy = jsonencode({
    "Statement": [
        {
            "Action": [
                "*"
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
resource "aws_iam_role_policy" "loginfunctionrolePolicy0" {
    name = "loginfunctionrolePolicy0"
    role = aws_iam_role.loginfunctionrole.name
    policy = jsonencode({
    "Statement": [
        {
            "Action": [
                "*"
            ],
            "Resource": [
                "*"
            ],
            "Effect": "Allow"
        }
    ]
})
}