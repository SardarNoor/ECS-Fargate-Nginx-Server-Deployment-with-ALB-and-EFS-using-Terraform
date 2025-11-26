variable "cluster_name" {
  type        = string
  description = "Name of the ECS cluster"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the ECS cluster"
  default     = {}
}
