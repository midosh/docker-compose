variable "name_space" {
  type        = string
  description = "The name of name space to use for the k8s cluster."
}

variable "backend_labels" {
  type = object({
    app    = string
    tier = string
  })
  sensitive = true
}

variable "frontend_labels" {
  type = object({
    app    = string
    tier = string
  })
  sensitive = true
}
