
use sysadmin role?


# Code in Snowflake to create user
CREATE USER "tf-snow" RSA_PUBLIC_KEY='MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnRHZ4xbrmGUMCuoke5c9KIogYggO5FSTYwQdaBcj7vlmEOicBikQJGwZaj35blEuriCgidNsKHVdIS57G2rFbcXJUimlU+UroORqpYBS6LPmxXXGEYwDAM8tyV62oduX42yTlLO3BN4JGi68zmvAoW3gpVUUG5wPu2unXPKU0YrR/swl/h62LOdY03HDfOzQOetDUwtdELvamI6feXXGz5qtkMR3fyKseQqUDH1bDcnriXY5rpCosysjSozqZ+CzkLQvVguXTAmo/Fft+s3F46Xk/dBLEKHy0WkB+qUjLp/bSiwqlYwIdnZW0iNUlzqyKd27Ppz7xyGymv+BMNK5XQIDAQAB' DEFAULT_ROLE=PUBLIC MUST_CHANGE_PASSWORD=FALSE;

GRANT ROLE SYSADMIN TO USER "tf-snow";
GRANT ROLE SECURITYADMIN TO USER "tf-snow";


## x509 error
could not retrieve session id err = Post "https://BIB76405.AWS_US_EAST_1.snowflakecomputing.com:443/session/v1/login-request?requestId=8e44c953-ee7f-4b15-6764-d81a567682b4&request_guid=892806f9-f17c-458b-5472-a53056c65b57&roleName=SYSADMIN": x509: certificate is valid for *.prod3.us-west-2.snowflakecomputing.com, *.us-west-2.snowflakecomputing.com, *.global.snowflakecomputing.com, *.snowflakecomputing.com, *.prod3.us-west-2.aws.snowflakecomputing.com, not BIB76405.AWS_US_EAST_1.snowflakecomputing.com
https://github.com/Snowflake-Labs/terraform-provider-snowflake/issues/529
Understand snowfalke account identifiers at https://docs.snowflake.com/en/user-guide/admin-account-identifier#snowflake-region-ids

E.g. for AWS us-east-1 region, the region = "us-east-1", and not "AWS_US_EAST_1"


# JWT token 
Planning failed. Terraform encountered an error while generating this plan.

╷
│ Error: could not retrieve session id err = 390144 (08004): JWT token is invalid.
│
│   with provider["registry.terraform.io/snowflake-labs/snowflake"],
│   on main.tf line 10, in provider "snowflake":
│   10: provider "snowflake" {
│

https://community.snowflake.com/s/article/Key-Based-Authentication-Failed-with-JWT-token-is-invalid-Error

For WSL, it could be because the clock is out of sync.  
