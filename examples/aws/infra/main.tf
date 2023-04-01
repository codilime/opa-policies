resource "aws_s3_bucket" "localstack_s3_opa_example" {
  bucket = "localstack-s3-opa-example"
}

resource "aws_s3_object" "data_json" {
  bucket = aws_s3_bucket.localstack_s3_opa_example.id
  key    = "data_json"
  source = "files/data.json"
}

resource "aws_iam_user" "lb" {
  name = "loadbalancer"
  path = "/system/"

  tags = {
    tag-key = "tag-value"
  }
}