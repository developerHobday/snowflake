terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.59"
    }
  }
}

provider "snowflake" {
  account = var.SNOWFLAKE_ACCOUNT
  private_key_path = var.SNOWFLAKE_PRIVATE_KEY_PATH
  region = var.SNOWFLAKE_REGION
  role  = "SYSADMIN"
  username = var.SNOWFLAKE_USER
}

resource "snowflake_database" "db" {
  name     = "INTEGRATION_DB"
}

resource "snowflake_warehouse" "warehouse" {
  name           = "FAST_QUERY_WH"
  warehouse_size = "large"

  auto_suspend = 60
}

variable "SNOWFLAKE_ACCOUNT" {
    type = string
}
variable "SNOWFLAKE_PRIVATE_KEY_PATH" {
    type = string
}
variable "SNOWFLAKE_REGION" {
    type = string
}
variable "SNOWFLAKE_USER" {
    type = string
}

# TODO terraform backend for state