# FRONTEND policy - boleh diakses publik, tapi hanya boleh akses backend
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

    policy_types = ["Ingress", "Egress"]

    # Ingress: boleh diakses publik
    ingress {
      from {
        ip_block {
          cidr = "0.0.0.0/0"
        }
      }
    }

    # Egress: hanya boleh ke backend (port 8080)
    egress {
      to {
        pod_selector {
          match_labels = {
            app = "backend"
          }
        }
      }
      ports {
        port     = 8080
        protocol = "TCP"
      }
    }
  }
}

# BACKEND policy - hanya boleh diakses oleh frontend
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

    policy_types = ["Ingress", "Egress"]

    # Ingress: hanya dari frontend
    ingress {
      from {
        pod_selector {
          match_labels = {
            app = "frontend"
          }
        }
      }
    }

    # Egress: hanya boleh ke database
    egress {
      to {
        pod_selector {
          match_labels = {
            app = "database"
          }
        }
      }
      ports {
        port     = 5432
        protocol = "TCP"
      }
    }
  }
}

# DATABASE policy - hanya boleh diakses oleh backend
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

    policy_types = ["Ingress"]

    # Ingress: hanya dari backend
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
  }
}