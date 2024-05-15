terraform {
    required_providers {
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
  cloud {
    organization = "EOyebamiji-TF-Bootcamp"
    workspaces {
      name = "Terra-House-1"
    }
  }
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

provider "terratowns" {
  endpoint = var.terratowns_endpoint
  user_uuid = var.teacherseat_user_uuid
  token = var.terratowns_access_token
}

module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.teacherseat_user_uuid
  index_html_filepath = var.index_html_filepath
  error_html_filepath = var.error_html_filepath
  assets_path = var.assets_path
  content_version = var.content_version
}

resource "terratowns_home" "home" {
  name = "Amala Cuisine: A Taste of Tradition and Comfort"
  description =  <<DESCRIPTION
  Amala is a cherished dish rooted in the heart of Yoruba culture in Nigeria, celebrated for its unique flavor and hearty texture. Made from yam flour (elubo) or a combination of plantain flour and cassava flour, Amala is a staple that showcases the ingenuity and agricultural richness of the Yoruba people.
  The preparation of Amala involves boiling water and gradually adding the flour while stirring continuously until a smooth, stretchy dough-like consistency is achieved. The result is a dark, velvety dish that pairs perfectly with a variety of rich, savory soups such as ewedu (jute leaves soup), gbegiri (bean soup), or ogbono (wild mango seed soup).
  Each bite of Amala offers a comforting, slightly earthy flavor that complements the robust spices and ingredients found in traditional Nigerian soups. It is typically enjoyed by hand, rolled into small balls, and dipped into the accompanying soup, creating a harmonious blend of tastes and textures.
  Amala cuisine is more than just a meal; it's a culinary experience that connects generations, evokes memories of home, and brings people together to share in the warmth and richness of the Yoruba heritage. Whether served at family gatherings, celebrations, or local eateries, Amala remains a beloved symbol of Nigerian culture and culinary excellence.
DESCRIPTION
  domain_name = module.terrahouse_aws.cloudfront_url
  town = "missingo"
  content_version = 1
}