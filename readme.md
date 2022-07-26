# GCP Redis Terraform

Example configuration showing how to setup Redis Stack on Google Cloud Platform using Terraform.

This is not intended to be a comprehensive setup, just an example of how to get started. Expect to customize the network setup, instance size and Redis configuration to suite your needs.

As-is it will create an `e2-micro` instance with a 10Gb volume for data and Append Only File persistence (so your data will be there if you restart or resize the instance).

## How to use

Follow the guide to [Get Started on Google Cloud using Terraform](https://learn.hashicorp.com/collections/terraform/gcp-get-started).

The minimal pieces you need to do are [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/gcp-get-started#install-terraform) and [Setup GCP](https://learn.hashicorp.com/tutorials/terraform/google-cloud-platform-build?in=terraform/gcp-get-started#set-up-gcp).

Once you have a service-account JSON file and Terraform installed, you can install Redis.

Rename the `terraform.tfvars.template` file to `terraform.tfvars` and edit it's contents as required.

Initialize Terraform:

    terraform init

Update the config to change the instance type or size, the Redis configuration and the GCP resource locations. See what it will change by running:

    terraform plan

Install the instance by running

    terraform apply

Once you're finished, you can clean-up using:

    terraform destroy

## Security

Don't use the default password! Be sure to [Generate a unique password](https://1password.com/password-generator/) to use.
