resource "aws_s3_object" "app_folder" {
  for_each     = fileset("app/", "*")
  bucket       = aws_s3_bucket.bucket_cloud.id
  key          = each.value
  source       = "app/${each.value}"
  etag         = filemd5("app/${each.value}")
  content_type = "text/html"
}

#invalidation cache

# resource "null_resource" "cache_invalidation" {

#   depends_on = [
#     aws_s3_object.app_folder
#   ]

#   for_each = fileset("${path.module}/app/", "**")

#   triggers = {
#     hash = filemd5("app/${each.value}")
#   }

#   provisioner "local-exec" {
#     command = "sleep 1; aws cloudfront create-invalidation --distribution-id ${aws_cloudfront_distribution.s3_distribution.id} --paths '/${each.value}'"
#   }
# }
