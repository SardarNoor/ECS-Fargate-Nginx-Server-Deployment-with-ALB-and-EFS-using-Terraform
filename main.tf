module "vpc" {
  source = "./modules/vpc"

  vpc_cidr = "10.0.0.0/16"

  azs = [
    "us-east-1a",
    "us-east-1b"
  ]

  public_subnet_cidrs = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  private_subnet_cidrs = [
    "10.0.3.0/24",
    "10.0.4.0/24"
  ]

tags = {}
}
module "security_groups" {
  source = "./modules/security-groups"

  vpc_id          = module.vpc.vpc_id
  alb_ingress_cidr = ["0.0.0.0/0"]

  tags = {}
}
module "ecs_cluster" {
  source       = "./modules/ecs-cluster"
  cluster_name = "noortask5-ecs-cluster"

  
  tags = {}
}
module "ecr" {
  source          = "./modules/ecr"
  repository_name = "noortask5-nginx-repo"
  tags            = {}
}
module "efs" {
  source = "./modules/efs"

  vpc_id               = module.vpc.vpc_id
  private_subnet_ids   = module.vpc.private_subnet_ids
  efs_security_group_id = module.security_groups.efs_sg_id

  tags = {}
}
module "alb" {
  source = "./modules/alb"

  vpc_id               = module.vpc.vpc_id
  public_subnet_ids    = module.vpc.public_subnet_ids
  alb_security_group_id = module.security_groups.alb_sg_id

  tags = {}
}
module "ecs_task" {
  source = "./modules/ecs-task"

  task_family         = "noortask5-task"
  ecr_image_url       = module.ecr.repository_url
  efs_file_system_id  = module.efs.efs_file_system_id
  efs_access_point_id = module.efs.efs_access_point_id

  subnets          = module.vpc.private_subnet_ids
  security_groups  = [module.security_groups.ecs_sg_id]

  tags = {}
}
module "ecs_service" {
  source = "./modules/ecs-service"

  cluster_name        = module.ecs_cluster.cluster_name
  task_definition_arn = module.ecs_task.task_definition_arn

  subnets         = module.vpc.private_subnet_ids
  security_groups = [module.security_groups.ecs_sg_id]

  target_group_arn = module.alb.target_group_arn

  tags = {}
}





  
