variable "task_family" {
  type        = string
  description = "Task family name"
}

variable "ecr_image_url" {
  type        = string
  description = "ECR image URL"
}

variable "efs_file_system_id" {
  type        = string
  description = "EFS file system ID"
}

variable "efs_access_point_id" {
  type        = string
  description = "EFS access point ID"
}

variable "ecs_task_role_arn" {
  type        = string
  default     = null
}

variable "subnets" {
  type        = list(string)
  description = "Private subnets where task will run"
}

variable "security_groups" {
  type        = list(string)
  description = "Security groups for task"
}

variable "tags" {
  type        = map(string)
  default     = {}
}
