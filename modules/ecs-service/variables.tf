variable "cluster_name" {
  type = string
}

variable "task_definition_arn" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "security_groups" {
  type = list(string)
}

variable "target_group_arn" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
