# Bifrost test environment
[Terraform](https://www.terraform.io) configuration to setup a bifrost demo cluster on
[Google Kubernetes Engine](https://cloud.google.com/kubernetes-engine/)

## Setup the project via gcloud
* Prepare environment
```
export TF_VAR_billing_account=$(gcloud beta billing accounts list | tail -n +2 | cut -d" " -f1)
export TF_CREDS="$(pwd)/.secrets/terraform-service-account.json"
export TF_VAR_gcloud_project=bifrost-demo3
```

```bash
gcloud projects create ${TF_VAR_gcloud_project} \
  --set-as-default

gcloud beta billing projects link ${TF_VAR_gcloud_project} \
  --billing-account ${TF_VAR_billing_account}
```

* Create a new service account for terraform
```bash
gcloud iam service-accounts create terraform \
  --display-name "Terraform admin account"
```
```bash
gcloud iam service-accounts keys create ${TF_CREDS} \
  --iam-account terraform@${TF_VAR_gcloud_project}.iam.gserviceaccount.com
```

```bash
gcloud projects add-iam-policy-binding ${TF_VAR_gcloud_project} \
  --member serviceAccount:terraform@${TF_VAR_gcloud_project}.iam.gserviceaccount.com \
  --role roles/owner
```

* Enable APIs for terraform
```bash
gcloud services enable cloudresourcemanager.googleapis.com \
                        cloudbilling.googleapis.com \
                        iam.googleapis.com \
                        compute.googleapis.com \
                        sqladmin.googleapis.com \
                        container.googleapis.com
```

## Setup the project manually
### Create a project on google cloud with following apis enabled
* Cloud SQL Administration API
* Compute Engine API 
* Google Identity and Access Management (IAM)
* Google Cloud Resource Manager API
* Google Container Engine API

### Download credentials

* Log into the Google Developers Console and select a project.
* Click the menu button in the top left corner, and navigate to “IAM & Admin”, then “Service accounts”, and finally “Create service account”.
* Provide a name and ID in the corresponding fields, select “Furnish a new private key”, and select “JSON” as the key type.
* Clicking “Create” will download your credentials.
* Rename it to `.secrets/terrarform-admin-account.json`. Make sure you don’t publish this file, for instance in Github (add it to .gitignore).
* Give `owner` role to this new service account to have all permissions set (for simplicity)

## Provision a kubernetes cluster 
### Install Terraform
Follow steps at https://www.terraform.io/intro/getting-started/install.html

* Install modules
```bash
terraform init
```

### Execute
* Generate a plan and store it to a file
```bash
terraform plan -out plan-1.0.plan
```
* Apply the plan
```bash
terraform apply plan-1.0.plan
```

## Delete Cluster
* Generate a plan
```bash
terraform plan -destroy -out destroy-1.0.plan
```

* Apply the plan
```
terraform apply destroy-1.0.plan
```

## Work with the cluster

* Import kubernetes context
```bash
gcloud container clusters get-credentials dev --zone europe-west1-b --project ${TF_VAR_gcloud_project}
```
or manually
```bash
source .secrets/setup_kubectl.sh
```

## Resource
- Managing GCP Projects with Terraform
 https://cloud.google.com/community/tutorials/managing-gcp-projects-with-terraform
- GKE Setup example: https://mrooding.me/using-terraform-to-bootstrap-a-google-cloud-platform-cluster-fb709d13f6f9