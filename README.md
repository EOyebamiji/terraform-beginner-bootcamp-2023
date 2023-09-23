# Terraform Beginner Bootcamp 2023

## Semantic Versioning

This project will utilize semantic versioning for its tagging.

Semantic Versioning, often abbreviated as [SemVer](https://semver.org/), is a versioning scheme for software that aims to communicate meaningful information about the underlying changes in a software package or library. It provides a standardized way to indicate the nature of changes between different versions of a software product, making it easier for developers and users to understand how updates may affect their systems and whether they need to take action. [ChatGPT](https://chat.openai.com/tGPT)

The General version format is **MAJOR.MINOR.PATCH** e.g., `1.0.1` increment the:
 
- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes


Additionally, Semantic Versioning allows for pre-release and build metadata to be added, using hyphens and plus signs, respectively, as follows:

- **Pre-release version:** A hyphen followed by an identifier (e.g., "1.0.0-alpha.1"). Pre-release versions indicate that the software is in development and not yet considered stable.

- **Build metadata:** A plus sign followed by additional information (e.g., "1.0.0+20130313144700"). Build metadata is typically used for build-related information and doesn't affect the version's precedence.

Semantic Versioning helps developers and users understand the impact of updates quickly. For example, if you see a change from version ``1.2.3`` to ``1.3.0``, you know that new features have been added but the existing functionality should remain compatible. If it changes to ``2.0.0``, you should be cautious, as there might be breaking changes.


## Refactor the Terraform CLI
### Considerations with the Terraform CLI changes
The Terraform CLI installation instructions have changed due to gpg keyring changes. So we needed refer to the latest install CLI instructions via Terraform Documentation and change introduce a script to fully automate the install process. You can find the official doducmentation on how to [Install the Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Development Environment
We currentlly utilize a cloud developer environment [CDE](https://www.gitpod.io/cde) called [Gitpod](https://gitpod.io/workspaces) which provides a development environment built on Ubuntu - our prefered linux distribution.

We can also utilize [Jumppad](https://jumppad.dev/) - it enables the creation and configuration of lightweight, reproducible, and portable environments as code.

### Considerations for Linux Distribution
This project is being developed in a Linux environment, with our prefered distribution being [Ubuntu](https://ubuntu.com/) - a [debian](https://www.debian.org/) based distribution built on the Linux Kernel.

Please consider checking your Linux Distrubtion and change accordingly to distrubtion needs. [How To Check OS Version in Linux](
https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/)

Sample output when checking for the OS Version:

```sh
$ cat /etc/os-release
PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```

### Refactoring into Bash Scripts

While fixing the Terraform CLI gpg depreciation issues we noticed that the steps provided were a considerable amount more code. So we decided to create a bash script to automate the installation of the Terraform CLI.

This bash script is located here: [./bin/install_terraform_cli](./bin/install_terraform_cli)

- This will keep the Gitpod Task File ([.gitpod.yml](.gitpod.yml)) tidy.
- This allow us an easier to execute and debug installation
- This will allow better portablity for other projects that need to install Terraform CLI.

#### Shebang Considerations

A Shebang (prounced Sha-bang) tells the bash script what program that will interpet the script. eg. `#!/bin/bash`

ChatGPT recommended this format for bash: `#!/usr/bin/env bash`

- This allows for portability and compatability for different OS distributions 
- The will search the user's PATH for the bash executable

More resources can be found here on [Shebang](https://en.wikipedia.org/wiki/Shebang_(Unix))

#### Execution Considerations

When executing the bash script we can use the `./` shorthand notiation to execute the bash script. However, required persmission for execution needs to be provided.

eg. `./bin/install_terraform_cli`

If we are using a script in .gitpod.yml  we need to point the script to a program to interpert it.

eg. `source ./bin/install_terraform_cli`

#### Linux Permissions Considerations

In order to make our bash scripts executable we need to change linux permission for the file to be executable by the user.

```sh
chmod u+x ./bin/install_terraform_cli
```

alternatively:

```sh
chmod 744 ./bin/install_terraform_cli
```

Access more resources on [chmod](https://en.wikipedia.org/wiki/Chmod) - the command responsible for this permission granting.

### Gitpod Lifecycle (Before, Init, Command)

We need to be careful when using the Init because it will not rerun if we restart an existing workspace.

- `before:` Use this for tasks that need to run before init and before command. For example, customize the terminal or install global project dependencies.
- `init:` Use this for heavy-lifting tasks such as downloading dependencies or compiling source code.
- `command:` Use this to start your database or development server.

Access more resource on how to effectvely utilize [Gitpod Task](https://www.gitpod.io/docs/configure/workspaces/tasks)

### Working Env Vars

#### Env command

We can list out all Enviroment Variables (Env Vars) using the `env` command

We can filter specific `env vars` using grep eg. `env | grep AWS`

#### Setting and Unsetting Env Vars

In the terminal we can set using `export HELLO='world`

In the terrminal we unset using `unset HELLO`

We can set an env var temporarily when just running a command

```sh
HELLO='world' ./bin/print_message
```
Within a bash script we can set env without writing export eg.

```sh
#!/usr/bin/env bash

HELLO='world'

echo $HELLO
```

#### Printing Vars

We can print an env var using echo eg. `echo $HELLO`

#### Scoping of Env Vars

When you open up new bash terminals in VSCode it will not be aware of env vars that you have set in another window.

If you want an env var to persist across all future bash terminals that are open, you'd need to set env vars in your bash profile. eg. `.bash_profile`

#### Persisting Env Vars in Gitpod

We can persist env vars into gitpod by storing them in Gitpod Secrets Storage.

```
gp env HELLO='world'
```

All future workspaces launched will set the env vars for all bash terminals opened in thoes workspaces.

You can also set en vars in the `.gitpod.yml` but this can only contain non-senstive env vars.


### AWS CLI Installation

AWS is our prefered cloud platform for this project and as such require the configuration of [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) into our [CDE](https://www.gitpod.io/cde). 

AWS CLI is installed for the project via the adoption of a bash script [`./bin/install_aws_cli`](./bin/install_aws_cli)

We also configured the credentials as env var in our environment to avoid committing our credentials to GitHub. Access more resources on configuring [AWS CLI Env Vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html).

We can check if our AWS credentials is configured correctly by running the following AWS CLI command:
```sh
aws sts get-caller-identity
```

If it is, there should be a output of a json payload that looks like this:

```json
{
    "UserId": "AIEAVUO15ZPVHJ5WIJ5KR",
    "Account": "0123456789011",
    "Arn": "arn:aws:iam::0123456789011:user/TF-Bootcamp"
}
```

We'll need to generate AWS CLI credits from IAM User in order to the user AWS CLI.


## Terraform Basics

[Terraform](https://www.terraform.io/) is an open-source infrastructure as code (IAC) tool developed by [HashiCorp](https://www.hashicorp.com/). It allows the definition and provision of infrastructure, such as virtual machines, networks, storage, and other cloud resources, using a declarative configuration language. Terraform enables the management and automatation of infrastructures in a way that's repeatable, version-controlled, and consistent.

## Terraform Workflow

The core Terraform workflow consists of three stages:

- **Write:** We define resources, which may be across multiple cloud providers and services. E.g., creating a configuration file to deploy an application on virtual machines in a Virtual Private Cloud (VPC) network with security groups and a load balancer.

- **Plan:** Terraform creates an execution plan describing the infrastructure it will create, update, or destroy based on the existing infrastructure and our written configuration.

- **Apply:** On approval, Terraform performs the proposed operations in the correct order, respecting any resource dependencies. As in the example given for a VPC, if we decide to update the properties of the VPC and change the number of virtual machines in that VPC, Terraform will recreate the VPC before scaling the virtual machines.

More resources can be found [here](https://developer.hashicorp.com/terraform/intro)

### Terraform Registry
[Terraform registry](https://registry.terraform.io/) is an interactive resource for discovering a wide selection of integrations (providers), configuration packages (modules), and security rules (policies) for use with Terraform. Access more resources on [Terraform registry](https://registry.terraform.io/) [here](https://developer.hashicorp.com/terraform/registry)

Terraform sources their providers and modules from the Terraform registry which located at [registry.terraform.io](https://registry.terraform.io/)

- **Providers** is an interface to APIs that will allow to create resources in terraform. They are also responsible for understanding API interactions and exposing resources.

- **Modules** are a way to make large amount of terraform code modular, portable and sharable. they are small, reusable Terraform configurations that allows the management of a group of related resources as if they were a single resource.

A sample terraform provider projet can be accessed here.  [Random Terraform Provider](https://registry.terraform.io/providers/hashicorp/random)

### Terraform Console

We can see a list of all the Terrform commands by simply typing `terraform`


- #### Terraform Init

At the start of a new terraform project we run the `terraform init` command to download the binaries for the terraform providers that we'll use in this project.

- #### Terraform Plan

`terraform plan`

This will generate out a changeset, about the state of our infrastructure and what will be changed.

We can output this changeset i.e. "plan" to be passed to an apply, but often we can just ignore outputting.

- #### Terraform Apply

`terraform apply`

This will run a plan and pass the changeset to be execute by terraform. Apply should prompt yes or no.

If we want to automatically approve an apply we can provide the auto approve flag eg. `terraform apply --auto-approve`

- #### Terraform Destroy

`teraform destroy`
This will destroy the resources and infrastructure deployed by the `terraform apply`.

We can also use the auto approve flag to skip the approve prompt `terraform apply --auto-approve`

- #### Terraform Lock Files

`.terraform.lock.hcl` contains the locked versioning for the providers or modulues that should be used with this project.

The Terraform Lock File **should be committed** to our project repository in our prefered Version Control System (VSC) E.g., Github

- #### Terraform State Files

`.terraform.tfstate` contain information about the current state of your infrastructure.

This file **should not be commited** to your VCS.

This file can contain sensentive data.

If this file is lost, we lose knowledge about the the state of our infrastructure.

`.terraform.tfstate.backup` is the previous state file state.

- #### Terraform Directory

`.terraform` directory contains binaries of terraform providers.


## Issues with Terraform Cloud Login and Gitpod Workspace

When attempting to run `terraform login` it launchs an interactive bash environment and a wysiwyg view to generate a token. However, this does not work expected in Gitpod VsCode in the browser.

- The workaround is to manually generate a token in Terraform Cloud by clicking on the link provided in the environment

```
https://app.terraform.io/app/settings/tokens?source=terraform-login
```

- Then create the file to store our credentials manually here:

```sh
touch /home/gitpod/.terraform.d/credentials.tfrc.json
open /home/gitpod/.terraform.d/credentials.tfrc.json
```

- Provide the following code (replace your token in the file) into the created file:

```json
{
  "credentials": {
    "app.terraform.io": {
      "token": "YOUR-TERRAFORM-CLOUD-TOKEN"
    }
  }
}
```
- #### TF CLoud issues
After creating the token fot gitpod, it's important to configure the AWS Env Var in Terraform Cloud as a sensitive file, to avoid running to issues.
