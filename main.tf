# a postgresql database on postgresql cluster

#variable "host" {
#  type = string
#}

#variable "password" {
#  type = string
#}

terraform {
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.17.1"
    }
    
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }


  backend "s3" {
    bucket   = "test-by-dadior"
    key      = "test_by_dadior.tfstate"
    endpoint = "https://sfo2.digitaloceanspaces.com"
    # DO uses the S3 format
    # eu-west-1 is used to pass TF validation
    # Region is ACTUALLY sfo2 on DO
    region = "eu-west-1"
    # Deactivate a few checks as TF will attempt these against AWS
    skip_credentials_validation = true
    # skip_get_ec2_platforms = true
    # skip_requesting_account_id = true
    skip_metadata_api_check = true
  }

}

provider "postgresql" {
  #alias    = "postgres"
  database = "postgres"

  host            = "127.0.0.1"
  port            = 15432
  username        = "user1"
  password        = "mysecretpassword"
  sslmode         = "disable"
  connect_timeout = 15
  #superuser       = false
}

resource "postgresql_schema" "schema_foo" {
  name     = "my_schema"
  #owner    = "postgres"
  database = "postgres"
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}


resource "postgresql_role" "my_role" {
  name     = "my_role"
  login    = true
  password = random_password.password.result
}

output passsword {
  value     = random_password.password.result
  sensitive = true
}
