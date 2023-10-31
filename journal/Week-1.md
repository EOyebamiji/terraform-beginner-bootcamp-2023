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