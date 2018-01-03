##############################################
# Networking
##############################################
resource "google_compute_network" "platform" {
  name       = "${var.platform_name}"
}

resource "google_compute_subnetwork" "dev" {
  name          = "dev-${var.platform_name}-${var.gcloud_region}"
  ip_cidr_range = "10.1.2.0/24"
  network       = "${google_compute_network.platform.self_link}"
  region        = "${var.gcloud_region}"
}

##############################################
# Firewall
##############################################
resource "google_compute_firewall" "ssh" {
  name    = "${var.platform_name}-ssh"
  network = "${google_compute_network.platform.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
}


##############################################
# Google Kubernetes Engine
##############################################
resource "google_container_cluster" "dev1" {
  depends_on= ["google_compute_subnetwork.dev", "google_compute_firewall.ssh"]
  name = "dev"
  network = "${google_compute_network.platform.name}"
  subnetwork = "${google_compute_subnetwork.dev.name}"
  zone = "${var.gcloud_zone}"

  initial_node_count = 1
  min_master_version = "1.8.1-gke.1"

  master_auth {
    username = "${var.gke_admin_name}"
    password = "${var.gke_admin_password}"
  }

  node_config {
    machine_type = "n1-standard-4"  # "g1-small" "n1-standard-1"
    oauth_scopes = [
      "https://www.googleapis.com/auth/projecthosting",
      "https://www.googleapis.com/auth/devstorage.full_control",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}


##############################################
# Kubectl
##############################################
resource "null_resource" "setup_kubectl" {
  depends_on= ["google_container_cluster.dev1"]
  provisioner "local-exec" {
   command = <<EOF
           echo export MASTER_HOST=${google_container_cluster.dev1.endpoint} > $PWD/.secrets/setup_kubectl.sh
           echo "${base64decode(google_container_cluster.dev1.master_auth.0.cluster_ca_certificate)}" > $PWD/.secrets/ca.pem
           echo export CA_CERT=$PWD/.secrets/ca.pem >> $PWD/.secrets/setup_kubectl.sh
           echo "${base64decode(google_container_cluster.dev1.master_auth.0.client_key)}" > $PWD/.secrets/admin-key.pem
           echo export ADMIN_KEY=$PWD/.secrets/admin-key.pem >> $PWD/.secrets/setup_kubectl.sh
           echo "${base64decode(google_container_cluster.dev1.master_auth.0.client_certificate)}" > $PWD/.secrets/admin.pem
           echo export ADMIN_CERT=$PWD/.secrets/admin.pem >> $PWD/.secrets/setup_kubectl.sh
           . $PWD/.secrets/setup_kubectl.sh

           kubectl config set-cluster ${var.platform_name} --server=https://$MASTER_HOST --certificate-authority=$CA_CERT --embed-certs
#           kubectl config set-credentials ${var.platform_name}-admin \
#                 --certificate-authority=$CA_CERT --client-key=$ADMIN_KEY --client-certificate=$ADMIN_CERT
           kubectl config set-credentials ${var.platform_name}-admin \
           --username=admin --password=xxxxxx
           kubectl config set-context ${var.platform_name} --cluster=${var.platform_name} --user=${var.platform_name}-admin
           kubectl config use-context ${var.platform_name}
EOF
  }
}
