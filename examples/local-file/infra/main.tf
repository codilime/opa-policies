# resource "random_id" "server" {
#   byte_length = 8
# }

resource "random_string" "this" {
  length           = 16
  special          = true
  override_special = "/@£$"
}

resource "local_file" "this" {
  content  = random_string.this.result
  filename = "${path.module}/generated.txt"
}
