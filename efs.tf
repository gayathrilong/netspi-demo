resource "aws_efs_file_system" "spi-test" {
  creation_token = "test-volume"
}

resource "aws_efs_mount_target" "spi-mount" {
  file_system_id = aws_efs_file_system.spi-test.id
  subnet_id = aws_subnet.spi_subnet.id
  security_groups = [aws_security_group.efs_grp.id]
}

output "efs_volume" {
    value = aws_efs_file_system.spi-test.id
}