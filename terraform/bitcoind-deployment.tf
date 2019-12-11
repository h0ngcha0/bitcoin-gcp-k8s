resource "kubernetes_namespace" "bitcoin" {
  metadata {
    name = "bitcoin"

    labels = {
      name = "bitcoin"
    }
  }

  depends_on = [
    "google_container_cluster.cluster"
  ]
}

resource "kubernetes_deployment" "bitcoind" {
  metadata {
    name = "bitcoind"
    namespace = "${kubernetes_namespace.bitcoin.metadata.0.name}"
    labels = {
      app = "bitcoind"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "bitcoind"
      }
    }

    template {
      metadata {
        name = "bitcoind"
        labels = {
          app = "bitcoind"
        }
      }

      spec {
        container {
          image = "nicolasdorier/docker-bitcoin:${var.bitcoin_version}"
          name = "bitcoind"
          image_pull_policy = "Always"

          env {
            name = "BITCOIN_EXTRA_ARGS"
            value = "rpcauth=${var.bitcoin_rpcauth}\ntxindex=1"
          }

          termination_message_path = "/dev/termination-log"

          volume_mount {
            mount_path = "/data"
            name = "bitcoin-blockchain-data"
          }
        }

        dns_policy = "ClusterFirst"
        restart_policy = "Always"
        termination_grace_period_seconds = 30

        volume {
          name = "bitcoin-blockchain-data"
          persistent_volume_claim {
            claim_name = "bitcoin-blockchain-pvc-claim"
          }
        }
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "bitcoin-blockchain-pvc-claim" {
  metadata {
    name = "bitcoin-blockchain-pvc-claim"
    namespace = "${kubernetes_namespace.bitcoin.metadata.0.name}"
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "350Gi"
      }
    }

    storage_class_name = "standard"
  }
}