terraform {
  required_version = ">=0.12"
  backend "s3" {
    bucket = "iop90876"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}



# resource "aws_s3_bucket" "cicd_bucket" {
#   bucket        = var.artifacts_bucket_name
#   acl           = "private"
#   force_destroy = true
#   versioning {
#     enabled    = true
#     mfa_delete = false
#   }
# }
provider "aws" {
  region = var.aws-region
}

resource "aws_iam_role" "containerAppBuildProjectRole" {
  name = "containerAppBuildProjectRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "codebuild.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_role_policy" "containerAppBuildProjectRolePolicy" {
  name = "containerAppBuildProjectRolePolicy"
  role = aws_iam_role.containerAppBuildProjectRole.name //id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
          "s3:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}


resource "aws_iam_role" "apps_codepipeline_role" {
  name = "apps_codepipeline_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
        Action = "sts:AssumeRole"


      },
    ]
  })
}

resource "aws_iam_role_policy" "apps_codepipeline_role_policy" {
  name = "apps_codepipeline_role_policy"
  role = aws_iam_role.apps_codepipeline_role.name //id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_codebuild_project" "containerAppBuild" {
  // badge_enabled  = true
  build_timeout  = "60"
  name           = "container-app-build"
  queued_timeout = 480
  description    = "test_codebuild_project"
  service_role   = aws_iam_role.containerAppBuildProjectRole.arn

  tags = {
    Environment = var.env
  }
  artifacts {
    encryption_disabled = false
    #name="container-app-code-${var.env}"
    #override_artifact_name=false
    packaging = "NONE"
    type      = "CODEPIPELINE"
  }

  #   cache {
  #     type     = "S3"
  #     location = aws_s3_bucket.bucket
  #   }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
    type                        = "LINUX_CONTAINER"

  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }

    s3_logs {
      status              = "DISABLED"
      encryption_disabled = false
    }
  }

  #   source {

  #     type            = "GITHUB"
  #     location        = "https://github.com/mitchellh/packer.git"
  #     git_clone_depth = 0

  #     git_submodules_config {
  #       fetch_submodules = true
  #     }
  #   }


  source {

    #buidspec            = data.template_file.buildspec.rendered
    #location        = "https://github.com/mitchellh/packer.git"
    git_clone_depth     = 0
    insecure_ssl        = false
    report_build_status = false
    type                = "CODEPIPELINE"
  }

}

resource "aws_codepipeline" "node_app_pipeline" {
  name     = "node_app_pipeline"
  role_arn = aws_iam_role.apps_codepipeline_role.arn
  tags = {
    Environment = var.env
  }
  artifact_store {
    location = var.artifacts_bucket_name
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name     = "Source"
      category = "Source"
      configuration = {
        BranchName = "jay"
        #PollForSourceChanges="false"
         RepositoryName = "awsdemo" //change
      //  location = "https://github.com/jay-007009/awsdemo.git"
      }
      input_artifacts = []

      output_artifacts = [
        "SourceArtifact",
      ]
      owner     = "AWS"
      provider  = "CodeCommit"
      run_order = 1
      version   = "1"


    }
  }


  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.containerAppBuild.name
      }
    }
  }


  stage {
    name = "Deploy"

    action {
      name     = "Deploy"
      category = "Deploy"
      configuration = {
        # ActionMode     = "REPLACE_ON_FAILURE"
        # Capabilities   = "CAPABILITY_AUTO_EXPAND,CAPABILITY_IAM"
        # OutputFileName = "CreateStackOutput.json"
        # StackName      = "MyStack"
        # TemplatePath   = "build_output::sam-templated.yaml"
        ClusterName = var.aws_ecs_cluster_name
        ServiceName = var.aws_ecs_node_app_service_name
        FileName    = "imagedefinitions.json"
      }
      input_artifacts  = ["BuildArtifact"]
      output_artifacts = []
      owner            = "AWS"
      provider         = "ECS"
      version          = "1"
      run_order        = 1

    }
  }


}








