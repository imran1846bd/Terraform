output "s3-bucket-name" {
  value = aws_s3_bucket.bucket.id
}

output "sns-topic-arn" {
  value = aws_sns_topic.topic.arn
}