provider "google" {
  credentials = "${file("./.secrets/terraform-service-account.json")}"
  project     = "${var.gcloud_project}"
  region      = "${var.gcloud_region}"
}
