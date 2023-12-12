module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "cicdpo-bucket-${var.environ}"
  acl = "private"

  control_object_ownership = true
  object_ownership = "ObjectWriter"

  versioning = {
    enabled = true
  }

  tags = {
        Name = "cicdpo-${var.environ}-bucket"
        Project = var.project
        Environment = var.environ
    }
}


resource "aws_s3_object" "cicdpo_bucket_object" {
    bucket = module.s3_bucket.s3_bucket_id

    for_each = fileset("./cicdpipelineoptimisation/", "**")
    key = each.value
    source = "./cicdpipelineoptimisation/${each.value}"
    content_type =  each.value

    etag = filemd5("./cicdpipelineoptimisation/")
}