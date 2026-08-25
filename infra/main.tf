data "aws_route53_zone" "main" {
  name         = var.domain_name
  private_zone = false
}

module "networking" {
  source = "./modules/networking"

  project_name         = var.project_name
  vpc_cidr             = var.vpc_cidr
  public_subnet_1_cidr = var.public_subnet_1_cidr
  public_subnet_2_cidr = var.public_subnet_2_cidr
  availability_zone_1  = "${var.aws_region}a"
  availability_zone_2  = "${var.aws_region}b"
}

module "security" {
  source = "./modules/security"

  project_name   = var.project_name
  vpc_id         = module.networking.vpc_id
  container_port = var.container_port
}

module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
}

module "acm" {
  source = "./modules/acm"

  domain_name = var.domain_name
}

module "alb" {
  source = "./modules/alb"

  project_name      = var.project_name
  vpc_id            = module.networking.vpc_id
  subnet_ids        = module.networking.public_subnet_ids
  security_group_id = module.security.alb_security_group_id
  certificate_arn   = module.acm.certificate_arn
  container_port    = var.container_port
}

module "ecs" {
  source = "./modules/ecs"

  project_name      = var.project_name
  aws_region        = var.aws_region
  repository_url    = module.ecr.repository_url
  image_tag         = var.image_tag
  subnet_ids        = module.networking.public_subnet_ids
  security_group_id = module.security.ecs_security_group_id
  target_group_arn  = module.alb.target_group_arn
  container_port    = var.container_port
  task_cpu          = var.task_cpu
  task_memory       = var.task_memory
  desired_count     = var.desired_count

  depends_on = [module.alb]
}

resource "aws_route53_record" "app" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "${var.subdomain}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = module.alb.alb_dns_name
    zone_id                = module.alb.alb_zone_id
    evaluate_target_health = false
  }
}