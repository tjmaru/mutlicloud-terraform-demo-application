locals {
  cloud = lower(var.cloud)
  azure = local.cloud == "azure"
  aws   = local.cloud == "aws"
  gcp   = local.cloud == "gcp"
  user_data = templatefile(
    format("%s/files/cloudinit.yaml", path.module),
    { cloud = upper(var.cloud) }
  )
  user_data64 = base64encode(local.user_data)
}

locals {
  instance_type = {
    small = {
      aws   = "t3.micro"
      azure = "Standard_DS1_V2"
      gcp   = "n1-standard-1"
    }
    medium = {
      aws   = "t3.micro"
      azure = "Standard_DS2_V2"
      gcp   = "n1-standard-4"
    }
  }
}