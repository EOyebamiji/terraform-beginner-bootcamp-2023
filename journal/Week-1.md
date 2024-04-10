# Terraform Beginner Bootcamp 2023 - Week 1

## Root Module Structure

Our root module structure is as follows:

```ASCII
PROJECT_ROOT
|
|__ main.tf                    (Stores the structure of input variables)
|__ variables.tf               (Every other item for the terraform project)
|__ outputs.tf                 (Stores our outputs)
|__ provider.tf                (Defines the required provider and relevant configuration)
|__ terraform.tfvars           (The data of variables to be loaded into the terraform project)
|__ README.md                  (Required for the root modules)
```

[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)


## Terraform and Input Variables
### Terraform Cloud Variables
In Terraform, we can set two types of variables:

- Environment variables: These are variables that you set in your bash terminal, such as AWS credentials.
- Terraform variables: These are variables that you set in your `tfvars` file.
- Terraform Cloud variables: These are variables that you set in Terraform Cloud. You can mark Terraform Cloud variables as sensitive to prevent them from being displayed in the UI.

### Loading Terraform Input Variables
[Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)

`-var` Flag
We can use the `-var` flag to set an input variable or override a variable in the tfvars file. For example:

```bsh
terraform -var user_ud="my-user_id"
```

### `-var-file` Flag

The `-var-file` flag allows you to load Terraform variables from a file. For example:

```bash
terraform -var-file=variables.tfvars
```

`terraform.tfvars` File
This is the default file that Terraform loads input variables from.

### `auto.tfvars` File

The `auto.tfvars` file is used to load Terraform variables from multiple files. For example, you could have a separate `auto.tfvars` file for each environment (production, staging, development).

### Order of Terraform Variables

Terraform variables are loaded in the following order:

1. Environment variables
2. `terraform.tfvars` file
3. `auto.tfvars` files
4. `-var-file` flag
5. `-var` flag

## Dealing With Configuration Drift

### What happens if we lose our state file?

If you lose your state file, you most likely have to tear down all your cloud infrastructure manually.

You can use Terraform import, but it won't work for all cloud resources. You need to check the Terraform provider's documentation for which resources support import.

More information on terraform import, refer to [Terraform Import Documentation](https://developer.hashicorp.com/terraform/cli/import)

To specifically import an AWS S3 Bucket, check the [AWS S3 Bucket Import Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)

### Fix Missing Resources with Terraform Import

To import a missing resource, use the following Terraform command:

```bash
terraform import aws_s3_bucket.bucket bucket-name
```
### Fix Manual Configuration

In the event where a team memeber deletes or modifies a cloud resource manually through ClickOps:
we run Terraform plan, which will attempt to put our infrastructure back into the expected state, fixing Configuration Drift.