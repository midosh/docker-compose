resource "kubernetes_namespace" "myapp" {
  metadata {
    name = var.name_space
  }
}