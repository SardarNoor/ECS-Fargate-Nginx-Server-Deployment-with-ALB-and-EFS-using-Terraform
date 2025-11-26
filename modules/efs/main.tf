
# EFS Filesystem


resource "aws_efs_file_system" "this" {
  performance_mode = "generalPurpose"

  encrypted = true

  tags = merge(
    var.tags,
    { Name = "noortask5-efs" }
  )
}


# EFS Access Point


resource "aws_efs_access_point" "this" {
  file_system_id = aws_efs_file_system.this.id

  posix_user {
  uid = 101
  gid = 101
}

root_directory {
  path = "/nginx"
  creation_info {
    owner_uid   = 101
    owner_gid   = 101
    permissions = "755"
  }
}


  tags = merge(
    var.tags,
    { Name = "noortask5-efs-ap" }
  )
}


# Create EFS Mount Targets (one per AZ)


resource "aws_efs_mount_target" "this" {
  count = length(var.private_subnet_ids)

  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = var.private_subnet_ids[count.index]
  security_groups = [var.efs_security_group_id]
}
