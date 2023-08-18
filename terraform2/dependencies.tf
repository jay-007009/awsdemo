resource "aws_s3_bucket" "codepipeline_terrafrom_s3_bucket" {
  bucket = "codepipeline-terraform-s3-bucket2"
  
}
resource "aws_s3_bucket_acl" "codepipeline_terraform_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.example]
  bucket = aws_s3_bucket.codepipeline_terrafrom_s3_bucket.id
  acl    = "private"
}
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.codepipeline_terrafrom_s3_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}



resource "aws_cloudwatch_log_group" "codebuild_terraform_pipeline" {
  name = "codebuild/terraform_pipeline"
}

resource "aws_iam_role" "codebuild_terraform_role" {
  name = "codebuild-terrafrom-service-role"
  assume_role_policy = jsonencode({

    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Principal : {
          Service : "codebuild.amazonaws.com"
        },
        Action : "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_role_policy" "codebuild_terraform_policy" {
  name = "codebuild_terraform_policy"
  role = aws_iam_role.codebuild_terraform_role.id
  policy = jsonencode({

    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Resource" : "*",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
      },
      {
        "Effect" : "Allow",
        "Resource" : [
          "${aws_s3_bucket.codepipeline_terrafrom_s3_bucket.arn}",
          "${aws_s3_bucket.codepipeline_terrafrom_s3_bucket.arn}/*"
        ],
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketAcl",
          "s3:GetBucketLocation"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "codebuild:CreateReportGroup",
          "codebuild:CreateReport",
          "codebuild:UpdateReport",
          "codebuild:BatchPutTestCases",
          "codebuild:BatchPutCodeCoverages"
        ],
        "Resource" : "*"
      }
    ],
  })
}


resource "aws_iam_role" "codepipeline_terraform_role" {
  name = "codepipeline-terraform-service-role"
  assume_role_policy = jsonencode({

    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "codepipeline.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

}


resource "aws_iam_role_policy" "codepipeline_terraform_policy" {
  name = "codepipeline_terraform_policy"
  role = aws_iam_role.codepipeline_terraform_role.id
  policy = jsonencode({

    "Statement" : [
      {
        "Action" : [
          "iam:PassRole"
        ],
        "Resource" : "*",
        "Effect" : "Allow",
        "Condition" : {
          "StringEqualsIfExists" : {
            "iam:PassedToService" : [
              "cloudformation.amazonaws.com",
              "elasticbeanstalk.amazonaws.com",
              "ec2.amazonaws.com",
              "ecs-tasks.amazonaws.com"
            ]
          }
        }
      },
      {
        "Action" : [
          "codecommit:CancelUploadArchive",
          "codecommit:GetBranch",
          "codecommit:GetCommit",
          "codecommit:GetRepository",
          "codecommit:GetUploadArchiveStatus",
          "codecommit:UploadArchive"
        ],
        "Resource" : "*",
        "Effect" : "Allow"
      },
      {
        "Action" : [
          "codedeploy:CreateDeployment",
          "codedeploy:GetApplication",
          "codedeploy:GetApplicationRevision",
          "codedeploy:GetDeployment",
          "codedeploy:GetDeploymentConfig",
          "codedeploy:RegisterApplicationRevision"
        ],
        "Resource" : "*",
        "Effect" : "Allow"
      },
      {
        "Action" : [
          "codestar-connections:UseConnection"
        ],
        "Resource" : "*",
        "Effect" : "Allow"
      },
      {
        "Action" : [
          "elasticbeanstalk:*",
          "ec2:*",
          "elasticloadbalancing:*",
          "autoscaling:*",
          "cloudwatch:*",
          "s3:*",
          "sns:*",
          "cloudformation:*",
          "rds:*",
          "sqs:*",
          "ecs:*"
        ],
        "Resource" : "*",
        "Effect" : "Allow"
      },
      {
        "Action" : [
          "lambda:InvokeFunction",
          "lambda:ListFunctions"
        ],
        "Resource" : "*",
        "Effect" : "Allow"
      },
      {
        "Action" : [
          "opsworks:CreateDeployment",
          "opsworks:DescribeApps",
          "opsworks:DescribeCommands",
          "opsworks:DescribeDeployments",
          "opsworks:DescribeInstances",
          "opsworks:DescribeStacks",
          "opsworks:UpdateApp",
          "opsworks:UpdateStack"
        ],
        "Resource" : "*",
        "Effect" : "Allow"
      },
      {
        "Action" : [
          "cloudformation:CreateStack",
          "cloudformation:DeleteStack",
          "cloudformation:DescribeStacks",
          "cloudformation:UpdateStack",
          "cloudformation:CreateChangeSet",
          "cloudformation:DeleteChangeSet",
          "cloudformation:DescribeChangeSet",
          "cloudformation:ExecuteChangeSet",
          "cloudformation:SetStackPolicy",
          "cloudformation:ValidateTemplate"
        ],
        "Resource" : "*",
        "Effect" : "Allow"
      },
      {
        "Action" : [
          "codebuild:BatchGetBuilds",
          "codebuild:StartBuild",
          "codebuild:BatchGetBuildBatches",
          "codebuild:StartBuildBatch"
        ],
        "Resource" : "*",
        "Effect" : "Allow"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "devicefarm:ListProjects",
          "devicefarm:ListDevicePools",
          "devicefarm:GetRun",
          "devicefarm:GetUpload",
          "devicefarm:CreateUpload",
          "devicefarm:ScheduleRun"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "servicecatalog:ListProvisioningArtifacts",
          "servicecatalog:CreateProvisioningArtifact",
          "servicecatalog:DescribeProvisioningArtifact",
          "servicecatalog:DeleteProvisioningArtifact",
          "servicecatalog:UpdateProduct"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "cloudformation:ValidateTemplate"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr:DescribeImages"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "states:DescribeExecution",
          "states:DescribeStateMachine",
          "states:StartExecution"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "appconfig:StartDeployment",
          "appconfig:StopDeployment",
          "appconfig:GetDeployment"
        ],
        "Resource" : "*"
      }
    ],
    "Version" : "2012-10-17"
  })

}



resource "aws_codebuild_project" "terraform" {
  name          = "terraform_resources"
  description   = "Apply terrafrom resource"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild_terraform_role.arn
artifacts {
    type = "CODEPIPELINE"
  }
environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
environment_variable {
      name  = "TF_COMMAND"
      value = "apply"
    }
environment_variable {
      name  = "TF_VERSION"
      value = "1.5.3"
    }
  }
logs_config {
    cloudwatch_logs {
      group_name  = "codepipeline"
      stream_name = "terraform"
    }
  }
source {
    type                = "CODEPIPELINE"
    git_clone_depth     = 0
    insecure_ssl        = false
    report_build_status = false
  }
}


resource "aws_codepipeline" "terrafrom_codepipeline" {
  name     = "terrafrom-pipeline"
  role_arn = aws_iam_role.codepipeline_terraform_role.arn
artifact_store {
    location = aws_s3_bucket.codepipeline_terrafrom_s3_bucket.bucket
    type     = "S3"
}
stage {
    name = "Source"
action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["SourceArtifact"]
configuration = {
        RepositoryName = aws_codecommit_repository.terraform.repository_name
        BranchName     = "node2"
      }
    }
  }
stage {
    name = "Build"
action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      region           = var.region
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      version          = "1"
configuration = {
        ProjectName = aws_codebuild_project.terraform.name
      }
    }
  }
}