resource "kubernetes_service" "backend" {
  metadata {
    namespace = var.name_space
    name = "backend"
  }
  spec {
    selector = {
      app = var.backend_labels.app
      tier = var.backend_labels.tier
    }
    port {
      protocol = "TCP"
      port        = 80
      target_port = 80
    }

  }
}