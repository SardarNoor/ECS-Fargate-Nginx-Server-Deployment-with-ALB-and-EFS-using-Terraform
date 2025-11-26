variable "vpc_id" {
  type        = string
  description = "VPC ID where security groups will be created"
}

variable "alb_ingress_cidr" {
  type        = list(string)
  description = "CIDR blocks allowed to access ALB"
}

variable "tags" {
  type        = map(string)
  default     = {}
}
