// cluster setup
variable "gcloud_region"        { default = "europe-west1" }
variable "gcloud_zone"          { default = "europe-west1-b" }
variable "gcloud_project"       { default = "bifrost-demo3" }
variable "platform_name"        { default = "stellar1" }
variable "work_dir"             { default = "/tmp" }
// --
variable "gke_admin_name"       { default = "admin" }
variable "gke_admin_password"   { default = "xxxxxx" }
