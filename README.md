# scalr-install
Install and configure Scalr IaCP with Terraform on AWS with and RDS database and ALB load balancer

This template will install Scalr on a singles server

This template is configured as follows.

1. Built for AWS - Expects credentials to be provided via Environment Variables
2. Auto selects latest Canonical Ubuntu 16.04 LTS AMI for the chosen region
3. Requires user to define VPC and Subnet mappings either in terraform.tfvars(.json) or via policy bindings in scalr-module.hcl (Scalr Next-gen, see https://scalr-athena.readthedocs-hosted.com/en/latest/details/variables.html#binding-to-policy)
4. Scalr requires 16GB minimum of Ram. Instance type must be set in terraform.tfvars(.json) or via policy binding.

Below are descriptions on how to use this template in 3 possible modes.

* Locally
* Scalr Next-gen as the remote backend
* Scalr Next-Gen Service Catalog Offering

## Using Locally

1. Pull the repo.
1. Upload your public key to AWS.
1. Copy your Scalr license to ./license/license.json in the repo
1. Copy your private ssh key to ./ssh/id_rsa in the repo
1. Copy your SSL Certificate to ./cert/my.crt
1. Copy your SSL key to ./cert/my.key
1. Set values for the following variables in terraform.tfvars(.json) or provide values on the command line at runtime
1. `region` - AWS Region to use.
1. `key_name` - Key in AWS.
1. `token` - Your packagecloud.io download token supplied with the license.
1. `vpc` - VPC to be used.
1. `subnet` - Subnet to be used.
1. `instance_type` - Must be 4GB ram. t3.medium recommended.
1. `name_prefix` - 1-3 character prefix to be added to all instance names.
1. `domain_name` - the domain name to be used to access Scalr IaCP
1. Comment out the remote backend config block in `scalr-prod.tf` (`terraform {......`).
1. Set your access keys for AWS using environment variables `export AWS_ACCESS_KEY_ID=<access_key> AWS_SECRET_ACCESS_KEY=<secret_key>`
1. Run `terraform init;terraform apply` and watch the magic happen.

## Using with Scalr IaCP as Remote Backend

NOTE: SSH Key and Scalr license can either be provided via Files in the repo or through Variables in Scalr Next-Gen

1. Pull the repo.
1. Upload the public key to AWS.
1. To provide the Scalr license via a file copy it to ./license/license.json in the repo
1. To provide the SSH private key via a file copy it to ./shh/id_rsa in the repo
1. To provide your SSL Certificate via a file copy it to ./cert/my.crt
1. To provide your SSL key via a file copy it to ./cert/my.key
1. Create an TF API token in Scalr IaCP and add it to `~/.terraformrc`.
1. In Scalr Workspace add Terraform variables and values as follows (note that terraform.tfvars(.json) in the template is not used with a remote backend).
1. `region` - AWS Region to use.
1. `key_name` - Key in AWS.
1. `token` - Your packagecloud.io download token supplied with the license. Mark as "SENSITIVE".
1. To provide the license via variable: `license` - The full text of your Scalr license file. Mark as "SENSITIVE".
1. To provide the SSH private key via variable: `ssh_private_key` - The full text of you private key file in either PEM or PPK format. Mark as "SENSITIVE".
1. `vpc` - VPC to be used.
1. `subnet` - Subnet to be used.
1. `instance_type` - Must be 4GB ram. t3.medium recommended.
1. `name_prefix` - 1-3 character prefix to be added to all instance names.
1. `domain_name` - the domain name to be used to access Scalr IaCP
1. Run `terraform init;terraform apply` and watch the magic happen.

## Using with Scalr IaCP template registry.

In general follow the example here https://iacp.docs.scalr.com/en/latest/guides/new_service_catalog.html

For this specific template you need to do the following in Scalr

1. Create Policies (scalr-module.hcl shows the policy bindings that are required)
  1. cloud.locations - Policy to limit the cloud locations (note this can be all locations but the policy must exist)
  1. cloud.networks - Create a policy for every location allowed in the cloud.locations policy.
  1. cloud.subnets - Create a policy for every location/network (vpc) combination that is allowed.
  1. cloud.instance_types - Restrict the instance types that are allowed. Minimum 4GB of ram.
1. Create a Global Variable called `name_prefix_fmt` of type text with the REGEX `^[A-Z0-9]{1,3}$`.
1. Fork or clone the Source repo (https://github.com/scalr-eap/scalr-install)
1. Create the Service Catalog offering pointing to your copy repo
1. Request the offering.
