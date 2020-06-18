#######################
# Multi-Cloud Variables
#######################
variable "cloud" {
  description = "Multi-Cloud: Cloud to deploy in (Azure, AWS or GCP)"
  type        = string
  validation {
    condition     = contains(["azure", "aws", "gcp"], lower(var.cloud))
    error_message = "MultiCloud: Cloud should be on of: AWS, Azure or GCP."
  }
}

variable "cloud_location" {
  description = "Multi-Cloud: Mapping of cloud regions for multi-cloud."
  type        = map
}

variable "location" {
  description = "Multi-Cloud: Abstract location name"
  type        = string
}
##################
# Common variables
##################
variable "name" {
  description = "Common: Resources name"
  type        = string
}

variable "environment" {
  description = "Common: Environment name"
  type        = string
}

variable "tags" {
  description = "Common: Mapping of tags being associated with the resources"
  type        = map(string)
}

variable "subnet_id" {
  description = "Common: Subnet ID HAProxy deployment"
  type        = string
}

variable "vpc_id" {
  description = "Common: VPC ID HAProxy deployment"
  type        = string
}

variable "instance_size" {
  description = "Common: HAProxy instance size"
  type        = string
}

#################
# Azure variables
#################
variable "resource_group_name" {
  description = "Azure: The name of an existing resource group to be imported."
  type        = string
}
###############
# GCP variables
###############
variable "gcp_project" {
  description = "GCP: Google Cloud Platform project name"
  type        = string
}
