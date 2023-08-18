resource "aws_codecommit_repository" "terraform" {
  repository_name = "awsdemo"
  description     = "Terraform resources"
}
# output "repository_clone_url_ssh" {
#   value = aws_codecommit_repository.stateless_app.clone_url_ssh
# }