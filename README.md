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

```
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
    "Arn": "arn:aws:iam::0123456789011:user/terraform-beginner-bootcamp"
}
```

We'll need to generate AWS CLI credits from IAM User in order to the user AWS CLI.