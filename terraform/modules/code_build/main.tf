resource "aws_codebuild_project" "hello-world" {
  name         = "build-${var.app_name}"
  build_timeout      = "5"
  service_role = "${var.iam_role}"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/docker:1.12.1"
    type         = "LINUX_CONTAINER"
  }

  source {
    type     = "GITHUB"
    location = "https://github.com/mvlbarcelos/cloud-hello-world"
  }
}