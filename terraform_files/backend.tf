terraform {
    required_version = ">=1.0.2"
    backend "s3" {
        region = "us-east-1"
        profile = "default"
        key = "terraformstatefile"
        bucket = "S3_BUCKET"
    }
}