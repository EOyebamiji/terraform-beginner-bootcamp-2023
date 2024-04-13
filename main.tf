terraform {
# #   cloud {
# #     organization = "EOyebamiji-TF-Bootcamp"
# #     workspaces {
# #       name = "Terra-House-1"
# #     }
# #   }
#   required_providers {
#     aws = {
#       source = "hashicorp/aws"
#       version = "5.17.0"
#     }
#   }
# }

# provider "aws" {
#   region = "us-east-1"
#   # Configuration options
}

module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
  index_html_filepath = var.index_html_filepath
  error_html_filepath = var.error_html_filepath
  assets_path = var.assets_path
  content_version = var.content_version
}