# This script can be used to install terraform in Ubuntu
# For detailed instructions, refer to Terraform docs - https://developer.hashicorp.com/terraform/downloads 

# run script with sudo


# add HashiCorp's Debian package repository.
apt-get update && apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
gpg --no-default-keyring \
    --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    --fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/hashicorp.list
apt update

# install terraform package
apt-get install terraform
terraform -help
