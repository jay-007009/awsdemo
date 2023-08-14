variable "aws-region" {
description="AWS region to launch servers."
default="ap-south-1"
}

variable "env"{
   description="targetted deployment environment"
   default="dev" 
}

variable "nodejs_project_repository_name"{
    description="Nodejs Project Name"
    default="nodeapp"
}

variable "nodejs_project_repository_branch"{
    description = "nodejs project repository branch "
    default = "jay"
}

variable "artifacts_bucket_name"{
    description="s3 bucket for storing "
    default="iop90876"
}

variable "aws_ecs_cluster_name"{
    description = "Target amazon ecs cluster name"
    default = "MicroServicesCluster"
}

variable "aws_ecs_node_app_service_name"{
description="target ecs cluster node .js "
default="nodeappService"
} 