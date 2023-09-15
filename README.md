# ECS Cluster via Terraform

This module will allow you to deploy an ECS Cluster composed of raw EC2 instances that are managed by an Auto Scaling Group.
From here you can bring in your own modules to deploy ECS Services and task definitions, or you can use 
[ours.](https://github.com/7Factor/terraform-ecs-http-task) Though you can run this on its own, we recommend running it together
with all of the modules you need for your CI/CD solution as part of a complete assembly line style process.

## Prerequisites

First, you need a decent understanding of how to use Terraform. [Hit the docs](https://www.terraform.io/intro/index.html) for that.
Then, you should familiarize yourself with ECS [concepts](https://aws.amazon.com/ecs/getting-started/), especially if you've 
never worked with a clustering solution before. Once you're good, import this module and 
pass the appropriate variables. Then, plan your run and deploy.

## Example Usage

**NOTE**
If you wish to hook in logging middleware such as [fluentd](https://www.fluentd.org/), you must pass the necessary params
to `ecs_logging`. Check out our [fluentd module](https://github.com/7Factor/terraform-ecs-fluentd) to see how we terraform
fluentd and for more information on how all the pipes connect together.

```hcl-terraform
module "ecs_cluster" {
  source  = "7Factor/ecs-cluster/aws"
  version = "~> 1"

  vpc_id                = "${var.vpc_id}"
  utility_accessible_sg = "${var.utility_accessible_sg}"
  asg_subnets           = "${var.web_private_subnets}"
  key_name              = "${var.ecs_key_name}"
  instance_type         = "t2.medium"
  ecs_logging           = "[\\\"json-file\\\",\\\"awslogs\\\",\\\"fluentd\\\"]"
  desired_capacity      = 2
  min_size              = 2
  max_size              = 4
}
```

## Migrating from github.com/7factor/terraform-ecs-cluster

This is the new home of the terraform-ecs-cluster. It was copied here so that changes wouldn't break services relying on
the old repo. Going forward, you should endeavour to use this version of the module. More specifically, use the [module
from the Terraform registry](https://registry.terraform.io/modules/7Factor/ecs-cluster/aws/latest). This way, you can
select a range of versions to use in your service which allows us to make potentially breaking changes to the module
without breaking your service.

### Migration instructions

You need to change the module source from the GitHub url to `7Factor/ecs-cluster/aws`. This will pull the module from
the Terraform registry. You should also add a version to the module block. See the [example](#example-usage) above for
what this looks like together.

**Major version 1 is intended to maintain backwards compatibility with the old module source.** To use the new module
source and maintain compatibility, set your version to `"~> 1"`. This means you will receive any updates that are
backwards compatible with the old module.
