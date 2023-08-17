resource "aws_codebuild_project" "terraform_plan" {
  name         = "codebuild-plan"
  description  = "bhebhbhbh"
  service_role = aws_iam_role.codebuild.arn
  tags         = local.common_tags

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = var.codebuild_configuration["cb_compute_type"]
    image        = var.codebuild_configuration["cb_image"]
    type         = var.codebuild_configuration["cb_type"]
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "./terraform/buildspec-plan.yml"
  }
}

resource "aws_codebuild_project" "terraform_apply" {
  name         = "codebuild2-apply"
  description  = "cbhbchbdhc"
  service_role = aws_iam_role.codebuild.arn
  tags         = local.common_tags

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = var.codebuild_configuration["cb_compute_type"]
    image        = var.codebuild_configuration["cb_image"]
    type         = var.codebuild_configuration["cb_type"]
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "./terraform/buildspec-apply.yml"
  }
}