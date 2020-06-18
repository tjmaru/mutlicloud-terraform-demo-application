terraform {
  required_version = "~> 0.12.6"
  experiments      = [variable_validation]
  required_providers {
    aws     = ">= 2.60.0"
    azurerm = ">= 2.0"
    google  = ">= 3.21"
  }
}
