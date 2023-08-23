module "static_resources" {
  source = "./static_resources"
  project_id = var.project_id
  bucket_name = var.bucket_name
}

module "dynamic_resources" {
  source = "./dynamic_resources"
  project_id = var.project_id
  svc_accnt = var.svc_accnt
  bucket_name = var.bucket_name
}
