output "instance_name" {
  description = "Name of the created VM instance"
  value       = google_compute_instance.vm.name
}

output "instance_self_link" {
  description = "Self link of the created VM instance"
  value       = google_compute_instance.vm.self_link
}