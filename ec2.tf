data "aws_eip" "spi_tag" {
  filter {
    name   = "tag:Project"
    values = ["NetSPI_EIP"]
  }
}

resource "aws_instance" "spiinstance"{
    ami = var.ami_id
    instance_type = var.instance_size
    subnet_id = aws_subnet.spi_subnet.id
    vpc_security_group_ids = [aws_security_group.instance_grp.id]
    key_name = var.key_name
    iam_instance_profile = aws_iam_instance_profile.spi_profile.name
    user_data = <<EOF
#!/bin/bash
echo "Mount efs"
yum -y install nfs-utils amazon-efs-utils
mkdir -p /data/test
chmod -R 755 /data/test
chown ec2-user:wheel /data/test
python3 -m pip install botocore
mount -t efs -o tls ${aws_efs_file_system.spi-test.id}:/ /data/test

EOF
    depends_on = [aws_efs_mount_target.spi-mount]
}


resource "aws_eip_association" "eip_link" {
    instance_id   = aws_instance.spiinstance.id
    allocation_id = data.aws_eip.spi_tag.id
}



output "ec2_instance" {
    value = aws_instance.spiinstance.id
}