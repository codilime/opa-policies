resource "aws_s3_bucket" "localstack_s3_opa_example" {
  bucket = "localstack-s3-opa-example"
  tags = {
    Name        = "Locastack bucket"
  }
}

resource "aws_s3_object" "data_json" {
  bucket = aws_s3_bucket.localstack_s3_opa_example.id
  key    = "data_json"
  source = "files/data.json"
  tags = {
    Name        = "Object in Locastack bucket"
  }
}
