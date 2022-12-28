
# provider "mongodbatlas" {
#   # variable are provided via ENV
#   # public_key = ""
#   # private_key  = ""
# }


resource "mongodbatlas_project" "proj1" {
  name   = var.project_name
  org_id = var.atlas_organization_id
}


resource "mongodbatlas_advanced_cluster" "this" {
  name                  = var.cluster_name
  project_id            = mongodbatlas_project.proj1.id
  cluster_type          = "REPLICASET"
  backup_enabled        = false
  mongo_db_major_version = "6.0"

   replication_specs {         
      region_configs {
          electable_specs {
              disk_iops = 0
              instance_size = "M10"
              node_count = 1
            }
          priority = 7
          provider_name = var.provider_name
          region_name = "EUROPE_WEST"
        }
      region_configs {
          electable_specs {
              disk_iops = 0
              instance_size = "M10"
              node_count = 1
            }
          priority = 6
          provider_name = var.provider_name
          region_name = "EUROPE_NORTH"
        }
      region_configs {
          electable_specs {
              disk_iops = 0
              instance_size = "M10"
              node_count = 1
            }
          priority = 5
          provider_name = "AZURE"
          region_name = "GERMANY_WEST_CENTRAL"
        }
   }      
}


# DATABASE USER
resource "mongodbatlas_database_user" "user1" {
  username           = var.admin_username
  password           = var.admin_password
  project_id         = mongodbatlas_project.proj1.id
  auth_database_name = "admin"

  roles {
    role_name     = "readWriteAnyDatabase"
    database_name = "admin"
  }

  labels {
    key   = "Created"
    value = "${timestamp()}"
  }

  # Label "Created" has always a different value, one can prevent updates with lifecycle 
  lifecycle { ignore_changes = [labels] }

  scopes {
    name = mongodbatlas_advanced_cluster.this.name
    type = "CLUSTER"
  }
}