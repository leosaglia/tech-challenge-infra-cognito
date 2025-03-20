resource "aws_cognito_user_pool" "user_pool" {
    name = "fast-food-user-pool"
    username_attributes = ["email"]
    auto_verified_attributes = ["email"]

    password_policy {
        minimum_length = 6
    }

    account_recovery_setting {
        recovery_mechanism {
            name = "verified_email"
            priority = 1
        }
    }

    email_configuration {
        email_sending_account = "COGNITO_DEFAULT"
    }

    admin_create_user_config {
        allow_admin_create_user_only = true
    }
}

resource "aws_cognito_user_pool_domain" "cognito_domain" {
  domain       = "tech-challenge-fast-food-domain-2025"
  user_pool_id = aws_cognito_user_pool.user_pool.id
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
    name = "fast-food-employee"
    user_pool_id = aws_cognito_user_pool.user_pool.id
    generate_secret = true

    allowed_oauth_flows_user_pool_client = true
    allowed_oauth_flows = ["implicit"]
    allowed_oauth_scopes = ["email", "openid"]

    callback_urls = ["https://example.com"]

    prevent_user_existence_errors = "ENABLED"
    supported_identity_providers = ["COGNITO"]
    explicit_auth_flows = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
}