data "aws_iam_policy_document" "spi_source" {
    statement {
      sid = "SidName"

      actions = ["s3:*"]

      resources = [
        "arn:aws:s3:::${var.bucket_name}",
        "arn:aws:s3:::${var.bucket_name}/*"
      ]
    }
    statement {
      sid = "Sid2"
      
      actions = [
        "elasticfilesystem:ClientMount",
        "elasticfilesystem:ClientWrite",
        "elasticfilesystem:ClientRootAccess",
        "elasticfilesystem:DescribeMountTargets",
        "elasticfilesystem:DescribeMountTargetSecurityGroups",
        "ec2:DescribeAvailabilityZones"
      ]

      resources = ["*"]
    }

}

resource "aws_iam_policy" "spi_access_policy" {
  name = "spi_bucket_policy"
  path = "/"
  description = "Allow"
  policy = data.aws_iam_policy_document.spi_source.json
}

resource "aws_iam_role" "spi_role" {
  name = "spi_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_instance_profile" "spi_profile" {
  name = "spi_profile"
  role = aws_iam_role.spi_role.name
}

resource "aws_iam_role_policy_attachment" "spi-attach" {
  role       = aws_iam_role.spi_role.name
  policy_arn = aws_iam_policy.spi_access_policy.arn
}