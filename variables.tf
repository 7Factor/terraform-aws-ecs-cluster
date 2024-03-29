# networking config
variable "vpc_id" {
  description = "The id of your vpc."
}

variable "ecs_cluster_name" {
  description = "The name of your ECS cluster."
}

variable "ecs_cluster_name_suffix" {
  default     = " ECS Instance"
  description = "The suffix of your ECS cluster, default is ECS instance."
}

variable "utility_accessible_sg" {
  description = "Pass in the ID of your access security group here."
}

variable "asg_subnets" {
  type        = list(string)
  description = "The list of subnet IDs the ASG will launch instances into. These should be private."
}

variable "lb_ingress_cidr" {
  default     = "0.0.0.0/0"
  description = "CIDR to allow access to this load balancer. Allows white listing of IPs if you need that kind of thing, otherwise it just defaults to erebody."
}

# auto scaling group config
variable "instance_type" {
  default     = "t2.micro"
  description = "The type of ec2 container instance the asg will create. Defaults to t2.micro."
}

variable "key_name" {
  description = "The name of your pem key that will be associated with the ec2 container instances."
}

variable "desired_capacity" {
  default     = 2
  description = "The target number of container instances for the asg."
}

variable "min_size" {
  default     = 2
  description = "The mininum number of container isntances the asg will maintain."
}

variable "max_size" {
  default     = 3
  description = "The maximum number of container instances the asg will maintain."
}

variable "health_check_grace_period" {
  default     = 300
  description = "Time in seconds after instance comes into service before checking health. Defaults to 300."
}

variable "ecs_logging" {
  default     = "[\\\"json-file\\\",\\\"awslogs\\\"]"
  description = "Adding logging option to ECS that the Docker containers can use. It is possible to add fluentd as well"
}

variable "asg_user_data" {
  default     = ""
  description = "Adding an option to run arbitrary commands to ECS host startup for package installation."
}

variable "instance_ebs_volume_size" {
  default     = 50
  description = "The size for the root volume for the ECS instances. Defaults to 50."
}

variable "instance_ebs_volume_type" {
  default     = "gp2"
  description = "The volume type. Defaults to gp2."
}

variable "additional_asg_tags" {
  default     = []
  description = "Additional ASG tags for patch groups and such"
  type = list(object({
    key                 = string
    value               = string
    propagate_at_launch = bool
  }))
}

variable "ecs_patch_schedule" {
  default     = "cron(0 0 * * ? *)"
  description = "The frequency to patch the cluster. Defaults to midnight."
}

variable "schedule_timezone" {
  default     = "America/New_York"
  description = "The timezone inside of which to run the patch windows. Defaults to US eastern."
}

variable "stopped_ecs_task_log_group" {
  default     = "ecs/stopped-tasks"
  description = "The log group to use to log stopped task information."
}

variable "stopped_ecs_task_log_retention_days" {
  default     = 30
  description = "The number of days to retain stopped task logs."
}
