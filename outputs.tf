output "service_url" {
  value = google_cloud_run_service.example.status[0].url
}
