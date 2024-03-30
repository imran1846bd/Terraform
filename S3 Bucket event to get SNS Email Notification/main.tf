provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}



################################################################crrating a random string################################
resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}



################################################################Creagting S3 bucket################################


resource "aws_s3_bucket" "bucket" {
  bucket           = "whizbuckets-${random_string.random.result}"
  force_destroy = true
}

#############################Creating an sns topic################################################


resource "aws_sns_topic" "opic" {
  name = "whiz-s3-event-notification"
}

############ Creating an SNS Topic ############
 
resource "aws_sns_topic" "topic" {
  name = "whiz-s3-event-notification"
  policy = <<POLICY
{
    "Version":"2012-10-17",
    "Statement":[
        {
        "Effect": "Allow",
        "Principal": { "Service": "s3.amazonaws.com" },
        "Action": "SNS:Publish",
        "Resource": "arn:aws:sns:*:*:whiz-s3-event-notification",
        "Condition":{
            "ArnLike":{"aws:SourceArn":"${aws_s3_bucket.bucket.arn}"}
            }
        }
    ]
}
POLICY
}




#####################################Creating SNS Topic Subscription #################################
############ Creating SNS Topic Subscription ############
resource "aws_sns_topic_subscription" "topic-subscription" {
  topic_arn = aws_sns_topic.topic.arn
  protocol  = "email"
  endpoint  = "${var.endpoint}"
}
############ Creating bucket event notification ############
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.bucket.id
  topic {
    topic_arn     = aws_sns_topic.topic.arn
    events        = ["s3:ObjectCreated:*"]
  }
}











