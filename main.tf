resource "aws_iam_user" "lb" {
  name = "valdrin-user"
  path = "/system/"
}

resource "aws_iam_user_login_profile" "example" {
  user                    = aws_iam_user.lb.name
  password_reset_required = true
}

resource "aws_iam_user_policy" "lb_ro" {
  name = "valdrin-policy"
  user = aws_iam_user.lb.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*", "iam:GetAccountPasswordPolicy"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "iam:ChangePassword"
        ]
        Effect   = "Allow"
        Resource = aws_iam_user.lb.arn
      }
    ]
  })
}
