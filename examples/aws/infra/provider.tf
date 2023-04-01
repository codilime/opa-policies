provider "aws" {
  region                      = var.region
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

  endpoints {
    dynamodb = "http://localstack:4566"
    lambda   = "http://localstack:4566"
    s3       = "http://localstack:4566"
    sqs      = "http://localstack:4566"
    sns      = "http://localstack:4566"
  }
}
