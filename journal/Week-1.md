# Terraform Beginner Bootcamp 2023 - Week 1

## Root Module Structure

Our root module structure is as follows:

```ASCII
PROJECT_ROOT
|
|__ variables.tf               (Stores the structure of input variables)
|__ main.tf                    (Every other item for the terraform project)
|__ outputs.tf                 (Stores our outputs)
|__ provider.tf                (Defines the required provider and relevant configuration)
|__ terraform.tfvars           (The data of variables to be loaded into the terraform project)
|__ README.md                  (Required for the root modules)
```

[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)
