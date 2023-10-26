resource "aws_s3_bucket" "bucket_cloud" {
  bucket = "repo-build"
  tags = {
    Managed = "terraform"
  }
}

resource "aws_s3_bucket_ownership_controls" "owner_bucket" {
  bucket = aws_s3_bucket.bucket_cloud.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "acl_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.owner_bucket]
  bucket     = aws_s3_bucket.bucket_cloud.id
  acl        = "private"
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket_cloud.id

  policy = jsonencode({
    "Version" : "2008-10-17",
    "Statement" : [
      {
        "Sid" : "AllowCloudFrontServicePrincipalReadOnly",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudfront.amazonaws.com",
        },
        "Action" : "s3:GetObject",
        "Resource" : "arn:aws:s3:::${aws_s3_bucket.bucket_cloud.bucket}/*",
        "Condition" : {
          "StringEquals" : {
            "aws:SourceArn" : "arn:aws:cloudfront::441217594733:distribution/E1SRG06MY6SAFY"
          }
        }
      }
    ]
  })

  depends_on = [
    aws_s3_bucket.bucket_cloud
  ]
}
