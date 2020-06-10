variable "project_name" {
  type = string
  description = "Name of the Google project."
  default = "Bitcoin Full Node"
}

variable "project_id" {
  type = string
  description = "Id of the Google project for running bitcoin full node."
}

variable "region" {
  type = string
  description = "Google project region."
  default = "europe-west1"
}

variable "zone" {
  type = string
  description = "Google project zone."
  default = "europe-west1-d"
}

variable "kubernetes_node_pool_machine_type" {
  type = string
  description = "Machine type for Kubernetes node pool."
  default = "n1-standard-1"
}

variable "project_billing_account" {
  type = string
  description = "Billing account for the project."
}

variable "bitcoin_version" {
  type = string
  description = "Bitcoin core version. See https://hub.docker.com/r/nicolasdorier/docker-bitcoin for more details"
  default = "0.18.1"
}

variable "bitcoin_rpcauth" {
  type = string
  description = "Basic authentication of the bitcoin rpc, corresponding to the rpcauth option of bitcoind. Run `rpcpython.py username password` to generate the string here."
}
