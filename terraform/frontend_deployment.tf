resource "kubernetes_deployment" "frontend" {
  metadata {
    namespace = var.name_space
    name = "frontend"
    labels = {
       app = var.frontend_labels.app
       tier = var.frontend_labels.tier
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
          app = var.frontend_labels.app
          tier = var.frontend_labels.tier
      }
    }

    template {
      metadata {
        labels = {
           app = var.frontend_labels.app
           tier = var.frontend_labels.tier
        }
      }

      spec {
        container {
          image = "arsharaf/frontend:0.1"
          name  = "goapp-frontend"
          image_pull_policy = "IfNotPresent"
          lifecycle {
            pre_stop {
              exec {
                command = [ "/usr/sbin/nginx","-s","quit" ]
              }
            }
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

        }
      }
    }
  }
}