# terraform {
#   backend "s3" {
#     bucket         = "tfstate-sanjay-eks"
#     key            = "eks/terraform.tfstate"
#     region         = "us-east-2"
#     encrypt        = true
#     dynamodb_table = "terraform-locks"
#   }
# }
