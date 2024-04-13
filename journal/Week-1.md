# Terraform Beginner Bootcamp 2023 - Week 1

## Fixing Tags

[How to Delete Local and Remote Tags on Git](https://devconnected.com/how-to-delete-local-and-remote-tags-on-git/)

Locall delete a tag
```sh
git tag -d <tag_name>
```

Remotely delete tag

```sh
git push --delete origin tagname
```

Checkout the commit that you want to retag. Grab the sha from your Github history.

```sh
git checkout <SHA>
git tag M.M.P
git push --tags
git checkout main
```

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

## Fix using Terraform Refresh

```sh
terraform apply -refresh-only -auto-approve
```

## Terraform Modules

### Terraform Module Structure

It is recommend to place modules in a `modules` directory when locally developing modules but you can name it whatever you like.

### Passing Input Variables

We can pass input variables to our module.
The module has to declare the terraform variables in its own variables.tf

```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```

### Modules Sources

Using the source we can import the module from various places eg:
- locally
- Github
- Terraform Registry

```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
}
```
[Modules Sources](https://developer.hashicorp.com/terraform/language/modules/sources)

## Considerations when using ChatGPT to write Terraform

LLMs such as ChatGPT may not be trained on the latest documentation or information about Terraform.

It may likely produce older examples that could be deprecated. Often affecting providers.

## Working with Files in Terraform

### Fileexists function

This is a built-in terraform function to check the existance of a file.

```tf
condition = fileexists(var.error_html_filepath)
```
Reference more information on [File Exist Function](https://developer.hashicorp.com/terraform/language/functions/fileexists)

### Filemd5 Function

Reference more information on [Filemd5 Function](https://developer.hashicorp.com/terraform/language/functions/filemd5)

### Path Variable

In terraform there is a special variable called `path` that allows us to reference local paths:
- path.module = get the path for the current module
- path.root = get the path for the root module

[Special Path Variable](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info)

```terraform
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = "${path.root}/public/index.html"
}
```

## Terraform Locals
Terraform locals are used to declare local variables within our Terraform configuration files. These variables are defined within a `locals` block and are useful for simplifying complex expressions, avoiding redundancy, and improving readability. Local variables are scoped to the module where they are defined and cannot be accessed outside of that module.

Locals allows us to define local variables. It can be very useful when we need transform data into another format and have referenced a varaible.

```tf
locals {
  s3_origin_id = "MyS3Origin"
}
```

Reference more information on [Local Values](https://developer.hashicorp.com/terraform/language/values/locals)

## Terraform Data Sources

Terraform data sources allow you to fetch information from external systems or providers and use that data within our Terraform configuration. Data sources are defined using the `data` block in our Terraform configuration files.

This allows us to source data from cloud resources. This is useful when we want to reference cloud resources without importing them.

```tf
data "aws_caller_identity" "current" {}
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```

Reference more information on [Data Sources](https://developer.hashicorp.com/terraform/language/data-sources)

## Working with JSON

In Terraform, `jsonencode` is a function used to convert Terraform data structures into JSON strings. This is particularly useful when you need to pass JSON-formatted data to external systems or when working with APIs that expect JSON input. We use the jsonencode to create the json policy inline in the hcl.

```tf
> jsonencode({"hello"="world"})
{"hello":"world"}
```

Reference more information on [jsonencode](https://developer.hashicorp.com/terraform/language/functions/jsonencode)

## Changing the Lifecycle of Resources

[Meta Arguments Lifcycle](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)

## Terraform Data

Plain data values such as Local Values and Input Variables don't have any side-effects to plan against and so they aren't valid in replace_triggered_by. You can use terraform_data's behavior of planning an action each time input changes to indirectly use a plain value to trigger replacement.

Reference more information on [Terraform Data ](https://developer.hashicorp.com/terraform/language/resources/terraform-data)


## Provisioners

Terraform provisioners are used to execute scripts or commands on local or remote resources after they have been created or updated by Terraform. Provisioners are typically used for tasks such as installing software, configuring applications, initializing databases, or performing any other actions required to prepare a resource for use. Provisioners allow you to execute commands on compute instances eg. a AWS CLI command. They are not recommended for use by Hashicorp because Configuration Management tools such as Ansible are a better fit, but the functionality exists. Configuration as code (CaC) such as Anisble, Puppet, and Chef are perfectly for incorporating configuration into our infrastructure.

Reference more information on [Provisioners](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax)

### Local-Exec Provisioner

This provisioner runs commands or scripts on the machine where Terraform is executed. It is suitable for tasks that need to be performed locally, such as initializing configurations or running setup scripts. This will execute command on the machine running the terraform commands eg. plan apply

```tf
resource "aws_instance" "web" {
  # ...
  provisioner "local-exec" {
    command = "echo The server's IP address is ${self.private_ip}"
  }
}
```

Reference more information on [Local-Exec Provisioner](https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec)

### Remote-Exec Provisioner: 

This provisioner runs commands or scripts on a remote resource over SSH or WinRM. It is useful for tasks like executing commands on newly created instances or configuring remote servers. This will execute commands on a machine which you target. You will need to provide credentials such as ssh to get into the machine.

```tf
resource "aws_instance" "web" {
  # ...
  # Establishes connection to be used by all
  # generic remote provisioners (i.e. file/remote-exec)
  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [
      "puppet apply",
      "consul join ${aws_instance.web.private_ip}",
    ]
  }
}
```
Reference more information on [Remote-Exec Provisioner](https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec)

### File Provisioner: 

This provisioner is used to copy files or directories from the local machine to a remote resource over SSH or WinRM.

Reference more information on [File Provisioner](https://developer.hashicorp.com/terraform/language/resources/provisioners/file)

## For Each Expressions

The `for_each` expression in Terraform is used to iterate over a map or set of objects and create multiple instances of a resource or module based on the elements in the map or set. It allows you to dynamically create and manage multiple resources with similar configurations but different attributes. For each allows us to enumerate over complex data types

```sh
[for s in var.list : upper(s)]
```

This is mostly useful when you are creating multiples of a cloud resource and you want to reduce the amount of repetitive terraform code.

Reference more information on [For Each Expressions](https://developer.hashicorp.com/terraform/language/expressions/for)