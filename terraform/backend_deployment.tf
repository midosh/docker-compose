resource "kubernetes_deployment" "backend" {
  metadata {
    namespace = var.name_space
    name = "backend"
    labels = {
       app = var.backend_labels.app
       tier = var.backend_labels.tier
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
          app = var.backend_labels.app
          tier = var.backend_labels.tier
      }
    }

    template {
      metadata {
        labels = {
           app = var.backend_labels.app
           tier = var.backend_labels.tier
        }
      }

      spec {
        container {
          image = "arsharaf/backend:0.1"
          name  = "goapp-backend"
          image_pull_policy = "IfNotPresent"
          port {
            name = "http"
            container_port = 80
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

        #   liveness_probe {
        #     http_get {
        #       path = "/"
        #       port = 80

        #       http_header {
        #         name  = "X-Custom-Header"
        #         value = "Awesome"
        #       }
        #     }

        #     initial_delay_seconds = 3
        #     period_seconds        = 3
        #   }
        }
      }
    }
  }
}