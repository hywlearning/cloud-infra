# Using a single workspace:
terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "terraform-hyw"

    workspaces {
      name = "cloud-infra"
    }
  }
}
