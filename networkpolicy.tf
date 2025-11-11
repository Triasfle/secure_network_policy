# NetworkPolicy untuk Frontend
# Hanya mengizinkan koneksi dari luar (public) ke frontend di port 8080
resource "kubernetes_network_policy" "frontend_policy" {
  metadata {
    name = "frontend-policy"
  }

  spec {
    pod_selector {
      match_labels = {
        app = "frontend"
      }
    }

    ingress {
      ports {
        port     = 8080
        protocol = "TCP"
      }
    }

    policy_types = ["Ingress"]
  }
}

# NetworkPolicy untuk Backend
# Hanya mengizinkan koneksi dari frontend ke backend di port 8080
resource "kubernetes_network_policy" "backend_policy" {
  metadata {
    name = "backend-policy"
  }

  spec {
    pod_selector {
      match_labels = {
        app = "backend"
      }
    }

    ingress {
      from {
        pod_selector {
          match_labels = {
            app = "frontend"
          }
        }
      }

      ports {
        port     = 8080
        protocol = "TCP"
      }
    }

    policy_types = ["Ingress"]
  }
}

# NetworkPolicy untuk Database
# Hanya mengizinkan koneksi dari backend ke database di port 5432
resource "kubernetes_network_policy" "database_policy" {
  metadata {
    name = "database-policy"
  }

  spec {
    pod_selector {
      match_labels = {
        app = "database"
      }
    }

    ingress {
      from {
        pod_selector {
          match_labels = {
            app = "backend"
          }
        }
      }

      ports {
        port     = 5432
        protocol = "TCP"
      }
    }

    policy_types = ["Ingress"]
  }
}
