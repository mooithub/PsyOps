variable "project_id" {
  description = "The GCP project id"
  type        = string
}

variable "region" {
  default     = "us-central1"
  description = "GCP region"
  type        = string
}

variable "location" {
  default     = "us-central1-a"
  description = "GCP location"
  type        = string
}

variable "namespace" {
  description = "The project namespace to use for unique resource naming"
  type        = string
}

variable "svc_accnt" {
  description = "GCP service account"
  type        = string 
}

variable "bucket_name" {
  description = "GCP Bucket Name"
  type        = string 
}
