//Create Cognito User Pool
resource "aws_cognito_user_pool" "vault_user_pool" {
  name = "${var.project_name}_user_pool"

  // Add any additional configuration for the user pool as needed
  mfa_configuration = "ON"
  software_token_mfa_configuration {
    enabled = true
  }

  alias_attributes = [ "email" ]

}


//Create Cognito User Pool Client
resource "aws_cognito_user_pool_client" "vault_user_pool_client" {
  name         = "${var.project_name}_user_pool_client"
  user_pool_id = aws_cognito_user_pool.vault_user_pool.id

  // Add any additional configuration for the user pool client as needed
  generate_secret = false
  
  explicit_auth_flows = [
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH"
    ]

    access_token_validity = 60
    id_token_validity     = 60
    refresh_token_validity = 30

    token_validity_units {
      access_token  = "minutes"
      id_token      = "minutes"
      refresh_token = "days"
    }


}



//Create Cognito Hosted UI Domain
resource "aws_cognito_user_pool_domain" "vault_user_pool_domain" {
  domain       = "${var.project_name}-vault-domain"
  user_pool_id = aws_cognito_user_pool.vault_user_pool.id
}