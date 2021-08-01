resource "kubernetes_service" "frontend" {
  metadata {
    namespace = var.name_space
    name = "frontend"
  }
  spec {
    selector = {
      app = var.frontend_labels.app
      tier = var.frontend_labels.tier

    }
    port {
      protocol = "TCP"
      port        = 80
      target_port = 80
      node_port = 30008
    }
    type = "NodePort"

  }
}