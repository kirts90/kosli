aws_region      = "eu-west-2"
vpc_id          = "vpc-09ccaf9c3cb2cd4b8"
subnet_ids      = ["subnet-05465c64b769d0221", "subnet-01b1f7e0c65dde3eb"]
ami_id          = "ami-0a94c8e4ca2674d5a" # Ubuntu 24.04 LTS in eu-west-2
instance_type   = "t2.micro"
domain_name     = "prod2-kosli.georgioskyrtsidis.com"
route53_zone_id = "Z08706243CMHN9UB34MSW"
key_name        = "prod-key"
# ALB health check path removed
certificate_arn  = "arn:aws:acm:us-east-1:226210013150:certificate/6a527aa7-57d1-4e9f-858d-de497ccb6565" # Wildcard certificate for all domains
html_content     = "<html><body style='background-color: #f0f7e6;'><h1>Production EC2 Website</h1><p>This website is served from a single EC2 instance in the production environment.</p></body></html>"
root_volume_size = 8
data_volume_size = 2
data_volume_type = "gp2"

# S3 variables (placeholder values since we're using EC2 solution)
s3_bucket_name  = "prod2-kosli-georgioskyrtsidis-placeholder"
index_html_path = "/dev/null"
error_html_path = "/dev/null"
