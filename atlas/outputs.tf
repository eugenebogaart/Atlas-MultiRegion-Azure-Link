output "atlasclusterstring" {
   value = mongodbatlas_advanced_cluster.this.connection_strings[0].standard
}

output "user1" {
  value = mongodbatlas_database_user.user1.username
}

output "atlas_proj_id" {
  value = mongodbatlas_project.proj1.id   
}