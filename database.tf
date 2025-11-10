resource "kubernetes_deployment" "database" {
  metadata { name = "database" }
  spec {
    replicas = 1
    selector { match_labels = { app = "database" } }
    template {
      metadata { labels = { app = "database" } }
      spec {
        container {
          name = "database"
          image = "postgres:14"
          env {
            name = "POSTGRES_PASSWORD"
            value = "password"
          }
          port { container_port = 5432 }
        }
      }
    }
  }
}

resource "kubernetes_service" "database" {
  metadata { name = "database" }
  spec {
    selector = { app = "database" }
    port {
        port = 5432
        target_port = 5432
    }
  }
}